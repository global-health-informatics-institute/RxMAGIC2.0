class HomeController < ApplicationController
  def index
    #This is the landing page for the application
    @alerts = News.where({:resolved => false}).order(created_at: :desc)
  end

  def dashboard
  end

  def about
  end

  def contact
    @item = GeneralInventory.last
    @mfns = Manufacturer.select(["mfn_id", "name"])
  end

  def faq
  end
  
  def custom_report

    if !params["duration"].blank?
      @type =params[:duration]
      case @type
        when 'daily'
          @title = "Daily Inventory and Dispension Report for #{params[:start_date].to_date.strftime('%d %B, %Y')}"
          @start_date = params[:start_date].to_date.strftime('%Y-%m-%d 00:00:00')
          @end_date = params[:start_date].to_date.strftime('%Y-%m-%d 23:59:59')
 
        when 'monthly'
          @title = "Inventory and Dispensation Report for #{params[:start_date].to_date.strftime('%B %Y')}"
          @start_date = params[:start_date].to_date.beginning_of_month.strftime('%Y-%m-%d 00:00:00')
          @end_date = params[:start_date].to_date.end_of_month.strftime('%Y-%m-%d 23:59:59')

        when 'range'
          @title = "Inventory and Dispensation Report from #{params[:start_date].to_date.strftime('%d %B, %Y')}
         to #{params[:end_date].to_date.strftime('%d %B, %Y')}"
          @start_date = params[:start_date].to_date.strftime('%Y-%m-%d 00:00:00')
          @end_date = params[:end_date].to_date.strftime('%Y-%m-%d 23:59:59')

      end


      prescriptions = Prescription.select("count(rx_id) as rx_id,sum(quantity) as quantity,sum(amount_dispensed)
                                            as amount_dispensed, rxaui").where("voided = ? and date_prescribed
                                            BETWEEN ? and ?", false, @start_date, @end_date).group("rxaui")

      dispensations = Dispensation.find_by_sql("select rxaui, sum(d.quantity) as quantity from dispensations as d left join
                                       prescriptions p on d.rx_id=p.rx_id where d.voided =0 and p.voided =0 
                                       and dispensation_date BETWEEN '#{@start_date}' AND '#{@end_date}'  group by rxaui, inventory_id")


      inventory = GeneralInventory.find_by_sql("SELECT inventory.rxaui,sum(current_quantity)
                                                as current_quantity FROM (Select rxaui, gn_identifier as identifier,
                                                current_quantity from general_inventories where voided = 0 and
                                                date_received <= '#{@end_date}' UNION Select rxaui, pap_identifier as
                                                identifier, current_quantity from pmap_inventories where voided = 0
                                                and date_received <= '#{@end_date}') as inventory group by inventory.rxaui")

      @records = view_context.compile_report(prescriptions,inventory, dispensations)
    else
      @title = "Inventory and Dispensation Report"
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = InventoryReportPdf.new(@records,@title, @type)
        send_data pdf.render, filename: "inventory_report_#{@end_date}.pdf", type: 'application/pdf'
      end
    end
  end

  def activity_sheet
    #code block for generating activity sheet

    report_date = params[:date].to_date rescue Date.today
    @date = report_date.strftime("%b %d, %Y")
    dispensations = Dispensation.where("voided = ? AND dispensation_date BETWEEN ? AND ?", false,
                                        report_date.strftime("%Y-%m-%d 00:00:00"),
                                        report_date.strftime("%Y-%m-%d 23:59:59"))

    @records = view_context.activities(dispensations)

    low_stock_items = News.where("date_resolved = ? AND resolved = ? AND resolution = ? AND news_type = ?",
                                  report_date.strftime("%Y-%m-%d"), true,'Added to activity sheet',
                                  "low general stock").pluck(:refers_to)
    @low_stock = Rxnconso.where("RXAUI in (?)", low_stock_items).pluck(:STR)

    @clinic = YAML.load_file("#{Rails.root}/config/application.yml")['facility_name']

    respond_to do |format|
      format.html
      format.pdf do
        pdf = ActivitySheetPdf.new(@records, @low_stock,@date)
        send_data pdf.render, filename: "activity_sheet_#{report_date}.pdf", type: 'application/pdf'
      end
      # format.docx { headers["Content-Disposition"] = "attachment; filename=\"activity_sheet_#{report_date}.docx\"" }
    end    
  end

  def drug_name_suggestions
    items = Rxnconso.where("STR like ? and TTY in ('PSN', 'SCD')", "#{params[:query]}%").limit(10).collect{|x| x.STR.humanize.gsub(/\b('?[a-z])/) { $1.capitalize }}.uniq
    respond_to do |format|
      format.html
      format.json {render json: items}       
    end
  end

  def provider_suggestions
    providers = Provider.where("first_name like ? OR last_name like ?", "#{params[:query]}%","#{params[:query]}%").limit(15).collect{|x| "#{x.first_name.squish rescue ''} #{x.last_name.squish  rescue ''}"}.uniq
    respond_to do |format|
      format.html
      format.json {render json: providers}       
    end
  end
  
  def dispose_item
    item = params[:id].match(/g/i) ? GeneralInventory.find_by_gn_identifier_and_voided(params[:id],false) : PMAPInventory.find_by_pap_identifier_and_voided(params[:id],false)
    inventory_type = params[:id].gsub('$','').match(/g/i) ? "General" : "PMAP"
        
    if item.blank? and inventory_type == "PMAP"
        item = GeneralInventory.find_by_gn_identifier_and_voided(params[:id].gsub('$',''), false)
    end

    item.update(voided: true, void_reason: "Expired item")
    if item.errors.blank?
      flash[:success] = {title: "Item Disposed",message: "Item with bottle ID #{params[:id].gsub('$','')} was successfully disposed."}
      news_item = News.where("refers_to = ? AND resolved = ? AND news_type = ?",params[:id], false,"expired item").update(:resolved => true,:resolution => "Item Disposed",:date_resolved => Date.today)
    else
      flash[:errors] = {title: "Missing Item",message: "Item with bottle ID #{params[:id].gsub('$','')} could not be disposed."}
    end
    redirect_to "/"
  end
end
