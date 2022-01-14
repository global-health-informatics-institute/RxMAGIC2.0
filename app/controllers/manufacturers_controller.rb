class ManufacturersController < ApplicationController
    def index
        @manufacturers = Manufacturer.where("voided = ?", false)
    end

    def create
        new_manufacturer = Manufacturer.create(mfn_params)

        if new_manufacturer.errors.blank?
            flash[:success] = "#{new_manufacturer.name.titleize} was successfully added."
        else
            flash[:errors] = new_manufacturer.errors
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
            flash[:success] = "Successfully voided manufacturer #{mfn.first.name}"
        else
            flash[:errors] = "Could not delete manufacturer"
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
            flash[:success] = "Successfully voided manufacturer #{mfn.first.name}"
        else
            flash[:errors] = "Could not delete manufacturer"
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
