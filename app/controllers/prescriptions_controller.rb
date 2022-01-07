class PrescriptionsController < ApplicationController

    def index
        @prescriptions = Prescription.where("voided = ? AND quantity > amount_dispensed",false).order(date_prescribed: :asc)
        respond_to do |format|
            format.js {render :text => view_context.prescriptions(@prescriptions).to_json}
            format.html {render 'index'} 
        end
    end

    def dashboard
        #This is the function that handles the dashboard page
        render :layout => false
    end

    def show
        @prescription = Prescription.find(params[:id])
        @patient = @prescription.patient
        @category, @suggestions = get_suggestions(@prescription.patient_id, @prescription.rxaui)    
    end

    def destroy
         # This function voids a prescription and marks it as deleted

        prescription = Prescription.find(params[:id])
        prescription.update(:voided => true)
        if prescription.errors.blank?
            news = News.where("refers_to = ? AND resolved = ?", params[:id], false).first
            unless news.blank?
                news.resolved = true
                news.resolution = "Rx was cancelled"
                news.date_resolved= Date.today
                news.save
                # logger.info "Prescription #{params[:id]} was voided by #{current_user.username}"
            end
        end
        redirect_to "/prescriptions"
    end

    def void_prescription
        @prescription = Prescription.find(params[:id])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'void_prescription'} 
        end
    end

    def print_dispensation_label
        #This function prints bottle barcode labels for both inventory types
    
        @prescription = Prescription.find(params[:id])
        directions = (@prescription.patient.language == "ENG" ? @prescription.directions : "")
        print_string = Misc.create_dispensation_label(@prescription.drug_name,@prescription.amount_dispensed,
                                                 @prescription.made_by, directions, @prescription.patient_name,
                                                 @prescription.prescribed_by,@prescription.id)
    
        send_data(print_string,:type=>"application/label; charset=utf-8", :stream=> false, :filename=>"#{('a'..'z').to_a.shuffle[0,8].join}.lbl", :disposition => "inline")
    end

    def ajax_prescriptions
        @prescriptions = Prescription.where("voided = ? AND quantity > amount_dispensed",false).order(date_prescribed: :asc)
        respond_to do |format|
            format.html
            format.json {render json: view_context.prescriptions(@prescriptions).to_json}       
          end
    end

    private
    def get_suggestions(patient_id, drug)

        drug_type = Rxnconso.find_by_RXAUI(drug).RXCUI rescue nil
        options = Rxnconso.where("RXCUI = ? ",drug_type).pluck(:RXAUI)
        category = "PMAP"
        meds = PmapInventory.where("patient_id = ? and rxaui in (?) and current_quantity > ? and voided = ?",
                                patient_id, options, 0, false).order(expiration_date: :asc).pluck(:pap_identifier,:lot_number,
                                                                                                :expiration_date,
                                                                                                :current_quantity)

        suggestions =[]
        if meds.blank?
        category = "General"
        meds = GeneralInventory.where("rxaui in (?) and current_quantity > ? and voided = ?", options,0,
                                        false).order(expiration_date: :asc).limit(5).pluck(:gn_identifier, :lot_number,
                                                                                        :expiration_date,:current_quantity)
        end

        (meds || []).each do |item|
        suggestions << {"id" => Misc.dash_formatter(item[0]),"lot_number" => Misc.dash_formatter(item[1]),
                        "expiry_date" => (item[2].to_date.strftime('%b %d, %Y') rescue ""),"amount_remaining" => item[3]}
        end
        return [category,suggestions]
    end
end
