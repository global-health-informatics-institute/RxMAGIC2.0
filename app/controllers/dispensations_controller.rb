class DispensationsController < ApplicationController
    include Misc
        
    def new
        @prescription = Prescription.find(params[:rx_id])
        @item = params[:bottle_id].match(/g/i) ? GeneralInventory.find_by_gn_identifier(params[:bottle_id]) : PMAPInventory.find_by_pap_identifier(params[:bottle_id])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'new'} 
        end
    end

    def create
        
        # First we check which inventory we are dispensing from
        @prescription = Prescription.find(params[:dispensation][:prescription_id])
        @item = params[:bottle_id].match(/g/i) ? GeneralInventory.find_by_gn_identifier(params[:bottle_id].gsub('$','')) : PMAPInventory.find_by_pap_identifier(params[:bottle_id].gsub('$',''))
        inventory_type = params[:bottle_id].gsub('$','').match(/g/i) ? "General" : "PMAP"
        flash[:errors] = {}

        #Dispense according to inventory while paying attention to possible race conditions
        if @item.errors.blank?
            if dispense_item(@item,@prescription,params[:quantity])
                flash[:success] = {message: "#{params[:quantity]} of #{@item.drug_name} successfuly dispensed", title: "Item Dispensed"}
            else
                flash[:errors] = {title: "Insufficient Quantity", message: "#{@item.drug_name} could not be dispensed"}
            end
        else                
            flash[:errors] = {title: "Missing Item",message: "Item with bottle ID #{params[:bottle_id]} could not be found"}
        end
        
        if @prescription.amount_dispensed >= @prescription.quantity
            #News.resolve(params[:dispensation][:prescription],"new prescription","prescritption filled")
            print_and_redirect("/print_dispensation_label?prescription=#{@prescription.id}", "/prescriptions")
        else
            redirect_to @prescription
        end
    end

    def print_dispensation_label
        #This function prints bottle barcode labels for both inventory types
    
        @prescription = Prescription.find(params[:prescription])
        directions = (@prescription.patient.language == "ENG" ? @prescription.directions : "")
        print_string = create_dispensation_label(@prescription.drug_name,@prescription.amount_dispensed,
                                                @prescription.made_by, directions, @prescription.patient.name,
                                                @prescription.prescribed_by,@prescription.id)

        send_data(print_string,:type=>"application/label; charset=utf-8", :stream=> false, :filename=>"#{('a'..'z').to_a.shuffle[0,8].join}.lbl", :disposition => "inline")
    end

    def refill
        
        if request.post?
            item = params[:dispensation][:bottle_id].gsub('$','').match(/g/i) ? GeneralInventory.find_by_gn_identifier(params[:dispensation][:bottle_id].gsub('$','')) : PmapInventory.find_by_pap_identifier(params[:dispensation][:bottle_id].gsub('$',''))
            patient = Patient.find(params[:dispensation][:patient_id])
            inventory_type = params[:dispensation][:bottle_id].match(/g/i) ? "General" : "PMAP"
            flash[:errors] = {}

            provider = Provider.where("first_name = ? AND last_name = ?",
                params[:dispensation][:provider].split(" ")[0],
                params[:dispensation][:provider].split(" ")[1]).first

            if provider.blank?
                provider = Provider.create(:first_name => params[:dispensation][:provider].split(" ")[0],
                                    :last_name => (params[:dispensation][:provider].split(" ")[1] || params[:dispensation][:provider].split(" ")[0]))
            end

            #Dispense according to inventory while paying attention to possible race conditions
            if item.blank?
                flash[:errors] = {title: "Missing Item",message: "Item with bottle ID #{params[:dispensation][:bottle_id].gsub('$','')} could not be found"}
            else              
                Prescription.transaction do 
                    prescription = Prescription.create(
                        patient_id: patient.id, rxaui: item.rxaui, directions: params[:dispensation][:directions] + " [Refill]",
                        quantity: params[:dispensation][:quantity], amount_dispensed: params[:dispensation][:quantity],
                        provider_id: provider.id, date_prescribed: Time.now
                    )
                    if dispense_item(item,prescription,params[:dispensation][:quantity])
                        flash[:success] = {message: "#{params[:dispensation][:quantity]} of #{item.drug_name} successfuly dispensed", title: "Refill Complete"}
                    else
                        flash[:errors]= {title: "Refill Not Completed", message: "#{item.drug_name} could not be dispensed due to insufficient quntity."}
                    end
                    if flash[:errors].blank?
                        print_and_redirect("/print_dispensation_label?prescription=#{prescription.id}", "/patients/#{patient.id}")
                    else
                        redirect_to "/patients/#{patient.id}"
                    end
                end
            end
            
            

        else
            @patient = Patient.find(params[:patient_id])
            @providers = Provider.all.collect{|x| "#{x.first_name.squish rescue ''} #{x.last_name.squish  rescue ''}"}.uniq
            respond_to do |format|
                format.js {render layout: false}
                format.html { render 'refill'} 
            end
        end
    end

    def show
    end

    def destroy
    end

    private

    def dispense_item(inventory,prescription,dispense_amount)

        Dispensation.transaction do    
            prescription.update(:amount_dispensed => prescription.amount_dispensed + dispense_amount.to_i) 
            inventory.update(:current_quantity => (inventory.current_quantity - dispense_amount.to_i))
            dispensation = Dispensation.create({:rx_id => prescription.id, :inventory_id => inventory.bottle_id,
                                                :patient_id => prescription.patient_id, :quantity => dispense_amount,
                                                :dispensation_date => Time.now})
            #logger.info "#{current_user.username} dispensed #{dispense_amount} of #{inventory.bottle_id} (RX:#{prescription.id})"
        end
    end
end
