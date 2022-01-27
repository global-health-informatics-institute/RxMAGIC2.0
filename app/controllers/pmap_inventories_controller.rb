class PmapInventoriesController < ApplicationController
    def index
        @items = PmapInventory.where("current_quantity > ? and voided = ? ", 0, false)
        @aboutToExpire = PmapInventory.aboutToExpire_items.length
        #@underStocked = underStocked.length
        @expired = PmapInventory.expired_items.length
        #@wellStocked = wellStocked.length
    end

    def show
        @item = PmapInventory.find(params[:id]) rescue nil

        if @item.blank?
          redirect_to "/reorders"
        else
          @inventory = PmapInventory.where("voided = ? AND current_quantity > 0 AND patient_id = ? AND rxaui = ?",
                                           false, @item.patient_id, @item.rxaui).order(date_received: :asc)
          @prescriptions = Prescription.where("voided = ? AND patient_id = ? AND rxaui = ?", false, @item.patient_id,
                                              @item.rxaui).order(date_prescribed: :asc)
          @patient = @item.patient
        end
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
        @mfns = Manufacturer.select("mfn_id,name").where(:has_pmap => true, :voided => false)
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
        @item = PmapInventory.find(params[:id])
        @mfns = Manufacturer.select(["mfn_id", "name"]).where(:has_pmap => true, :voided => false)
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def update
        item = PmapInventory.find(params[:id])
        if item.blank?
            flash[:errors] = {title: "Failed to Update Record", message: "Item could not be found"}
        else
            item.lot_number = params[:pmap_inventory][:lot_number].upcase
            item.reorder_date = params[:pmap_inventory][:reorder_date].to_date rescue nil
            item.expiration_date = params[:pmap_inventory][:expiration_date].to_date rescue nil
            item.received_quantity = params[:pmap_inventory][:received_quantity].to_i + (item.received_quantity - item.current_quantity)
            item.current_quantity = params[:pmap_inventory][:received_quantity].to_i
            item.mfn_id = params[:pmap_inventory][:mfn_id]
            item.save
            if item.errors.blank?
                flash[:success] = {title: "Successfully deleted record", message: "#{item.drug_name} #{item.lot_number} was successfully deleted."}
                news = News.where("refers_to = ? AND resolved = ?", item.bottle_id, false).update({
                    :resolved => true,
                    :resolution => "Item was voided",
                    :date_resolved => Date.today
                })
            else
                flash[:errors] = {title: "Failed to Update Record", message: "Item could not be found"}
            end
            #logger.info "#{current_user.username} voided pmap inventory item #{params[:id]}"
        end
        
        redirect_to "/pmap_inventories"
    end

    def delete
        @item = PmapInventory.find(params[:id])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'delete'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def destroy
        item = PmapInventory.where(:pap_identifier => params[:id]).update(pmap_params)
        if item.blank?
            flash[:errors] = {title: "Failed to Delete Record", message: "Item with bottle id #{params[:id]} could not be found"}
        else
            flash[:success] = {title: "Successfully deleted record", message: "#{item.first.drug_name} #{item.first.lot_number} was successfully deleted."}
            news = News.where("refers_to = ? AND resolved = ?", item.first.bottle_id, false).update({
                :resolved => true,
                :resolution => "Item was voided",
                :date_resolved => Date.today
            })
            #logger.info "#{current_user.username} voided general inventory item #{params[:general_inventory][:gn_id]}"
        end

        redirect_to "/pmap_inventories"
    end
    
    def reorders
        reorders = PmapInventory.where("reorder_date between ? AND ? AND voided = ?",
                                       Date.today.beginning_of_week.strftime("%Y-%m-%d"),
                                       Date.today.end_of_week.strftime("%Y-%m-%d"),false )
    
        @reorders = view_context.reorders(reorders)
    end

    private 
    def pmap_params
        params.require(:pmap_inventory).permit(:voided_by,:void_reason, :voided,:rxaui,:patient_id, :manufacturer, :mfn_id,:name, :lot_number, :reorder_date, :expiration_date, :date_received, :received_quantity, :pap_inventory_id)
    end
end
