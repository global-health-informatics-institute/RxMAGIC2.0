class PatientsController < ApplicationController
    def index
        if params[:pmap_only].blank?
            @patients = Patient.where(:voided => false)
            @patient_count = @patients.count
            @pmap_patients = PmapInventory.select("distinct patient_id").where(:voided => false).count
        else
            pt_on_pmap = PmapInventory.where(:voided => false).pluck(:patient_id).uniq
            @patients = Patient.where("voided = ?  and patient_id in (?) ", false, pt_on_pmap)
            @patient_count = Patient.where(:voided => false).count
            @pmap_patients = pt_on_pmap.length
        end
    end

    def show
        @patient = Patient.find(params[:id])
        @history = Dispensation.where("patient_id = ? and voided = ?",params[:id],false).order(dispensation_date: :desc).limit(6)
        pmap_items =  PmapInventory.select("manufacturer, rxaui, sum(current_quantity) as current_quantity").where(:patient_id => params[:id],
                                       :voided => false).group(:manufacturer, :rxaui)            
        @pmap_meds = {}
        (pmap_items || []).each do |med|
            @pmap_meds[med.manufactured_by] = [] if @pmap_meds[med.manufactured_by].blank?
            @pmap_meds[med.manufactured_by] << ["#{med.drug_name}", med.current_quantity,med.manufacturer, med.rxaui]
        end
        flash[:success] = {message: "Testing", title:"Title"}
    end

    def new 
    end

    def create
        new_patient = Patient.create(patient_params)
        if new_patient.errors.blank?
            flash[:success] = {title: "Patient Record Created", message: "Record for #{new_patient.name} has been successfully created"}
            redirect_to "/patients/#{new_patient.id}"
        else
            flash[:errors] = {title: "Patient Record Not Created", message: "Record for #{new_patient.name} could not be created"}
            redirect_to "/patients"
        end
    end

    def edit
    end

    def update
    end

    def delete
    end

    def destroy
    end

    def update_language
        patient = Patient.where("patient_id = ? ", params[:id]).update(:language => params[:language])
        status = patient.first.errors.blank? 
        respond_to do |format|
            format.json {render json: status}       
        end
    end

    private
    def patient_params
        params.require(:patient).permit(:voided,:epic_id, :first_name, :last_name, :birthdate, :gender, :language, :address, :city, :state, :zip, :phone)
    end
end
