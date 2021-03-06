class ManufacturersController < ApplicationController
    def index
        if !params[:has_pmap].blank? 
            @manufacturers = Manufacturer.where(:has_pmap => true, :voided => false)
        elsif !params[:supports_us].blank?
            @manufacturers = Manufacturer.where("mfn_id in (?)", PmapInventory.where(:voided => false ).pluck(:manufacturer).uniq)
        else
            @manufacturers = Manufacturer.where(:voided => false)
        end
        
    end

    def create
        new_manufacturer = Manufacturer.create(mfn_params)

        if new_manufacturer.errors.blank?
            flash[:success] = {message: "#{new_manufacturer.name.titleize} was successfully added.", title:"Manufacturer Created"}
        else
            flash[:errors] = {message: "Manufacturer Could Not Be Added.", title:"Manufacturer Not Created"}
        end

        redirect_to "/manufacturers"
    end

    def new
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'new'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def edit
        @manufacturer = Manufacturer.find(params[:id])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def update
        mfn = Manufacturer.where("mfn_id = ? ", params[:manufacturer][:mfn_id]).update(mfn_params)
        if mfn.first.errors.blank? 
            flash[:success] = {message: "Successfully voided manufacturer #{mfn.first.name}", title: "Manufacturer Updated"}
        else
            flash[:errors] = {message: "Could not delete manufacturer", title: "Manufacturer Not Updated"}
        end
        
        redirect_to "/manufacturers"
    end

    def delete
        @manufacturer = Manufacturer.find(params[:id])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'delete'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def destroy
        mfn = Manufacturer.where("mfn_id = ? ", params[:id]).update(:voided => true)
        if mfn.first.errors.blank? 
            flash[:success] = {message: "Successfully voided manufacturer #{mfn.first.name}", title: "Manufacturer Deleted"}
        else
            flash[:errors] = {message: "Could not delete manufacturer", title: "Manufacturer Not Deleted"}
        end
        
        redirect_to "/manufacturers"
    end

    def toggle_pmap
        mfn = Manufacturer.where("mfn_id = ? ", params[:id]).update(:has_pmap => params[:status])
        status = mfn.first.errors.blank? 
        respond_to do |format|
            format.json {render json: status}       
        end
    end

    private
    def mfn_params
        params.require(:manufacturer).permit(:voided,:mfn_id,:name, :has_pmap)
    end
end
