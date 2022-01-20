class PmapInventoriesController < ApplicationController
    def index
        @items = PmapInventory.where("current_quantity > ? and voided = ? ", 0, false)
        #@aboutToExpire = aboutToExpire_items.length
        #@underStocked = underStocked.length
        #@expired = expired_items.length
        #@wellStocked = wellStocked.length
    end

    def create
        
        new_item = PmapInventory.create(pmap_params)
        
        if new_item.errors.blank?
            flash[:success] = {title: "Inventory Item Added", message: "#{params[:pmap_inventory][:name]} was successfully added to inventory."}
            print_and_redirect("/pmap_inventories/print/#{new_item.bottle_id}", "/patients/#{params[:pmap_inventory][:patient_id]}")
        else
            flash[:errors] = {title: "Failed to Create Record", message: new_item.errors}
            redirect_to "/patients/#{params[:pmap_inventory][:patient_id]}"
        end
    end

    def new
        @patient = Patient.find(params[:patient_id])
        if !params[:mfn_id].blank?
            @mfn = Manufacturer.find(params[:mfn_id]).name
            @drug = Rxnconso.find_by_RXAUI(params[:rx]).STR
        end
        @mfns = Manufacturer.select("mfn_id,name").where(:voided => false)
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'new'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def print
        entry = PmapInventory.where("pap_identifier = ?", params[:id]).first 
        print_string = entry.create_bottle_label(entry.drug_name,params[:id],entry.expiration_date,entry.lot_number,"PMAP", entry.owner)
        send_data(print_string,:type=>"application/label; charset=utf-8", :stream=> true, :filename=>"#{entry.lot_number}#{rand(10000)}.lbl", :disposition => "inline")
    end
    
    def edit
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def update
    end

    def delete
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'delete'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def destroy
    end

    private 
    def pmap_params
        params.require(:pmap_inventory).permit(:voided_by,:void_reason, :voided,:rxaui,:patient_id, :manufacturer, :mfn_id,:name, :lot_number, :expiration_date, :date_received, :received_quantity, :pap_inventory_id)
    end
end
