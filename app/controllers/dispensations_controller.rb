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
        @item = params[:bottle_id].match(/g/i) ? GeneralInventory.find_by_gn_identifier(params[:bottle_id]) : PMAPInventory.find_by_pap_identifier(params[:bottle_id])
        inventory_type = params[:bottle_id].match(/g/i) ? "General" : "PMAP"
        flash[:errors] = {}

        #Dispense according to inventory while paying attention to possible race conditions
        if @item.errors.blank?
            if dispense_item(@item,@prescription,params[:quantity])
                flash[:success] = "#{params[:quantity]} of #{@item.drug_name} successfuly dispensed"
            else
                flash[:errors][:insufficient_quantity] = ["#{@item.drug_name} could not be dispensed"]
            end
        else                
            flash[:errors][:missing] = ["Item with bottle ID #{params[:bottle_id]} could not be found"]
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
