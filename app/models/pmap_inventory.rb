class PmapInventory < ApplicationRecord
    has_one :rxnconso, :foreign_key => :rxaui
    #has_one :manufacturer, :foreign_key => :manufacturer
    belongs_to :patient, :foreign_key => :patient_id
    before_save :complete_record

    attribute :name, :string
    attribute :mfn_id, :string

    include Misc

    def drug_name
      return Rxnconso.find_by_RXAUI(self.rxaui).STR
    end
    
    def bottle_id
        return self.pap_identifier
    end

    def formatted_identifier
      return self.pap_identifier
    end

    def formatted_lot_number
      return self.lot_number
    end

    def manufactured_by
      return Manufacturer.find(self.manufacturer).name 
    end

    def owner
      return self.patient.name
    end

    def complete_record
      self.current_quantity = self.received_quantity
      self.date_received = Date.today
      unless !self.pap_identifier.blank?
        last_id = PmapInventory.order(pap_inventory_id: :desc).first.id rescue "0"
        next_number = (last_id.to_i+1).to_s.rjust(6,"0")
        check_digit = calculate_check_digit(next_number)
        self.pap_identifier = "P#{next_number}#{check_digit}"
      end
      if self.rxaui.blank? and !self.name.blank?
        self.rxaui = Rxnconso.where("STR = ? and TTY in ('PSN', 'SCD')", self.name).first.RXAUI
      end
      if self.manufacturer.blank? and !self.mfn_id.blank?
        self.manufacturer = self.mfn_id
      end
    end

    def self.aboutToExpire_items
      return PmapInventory.where("voided = ? AND current_quantity > ? AND expiration_date  BETWEEN ? AND ?",
        false,0,Date.today.strftime('%Y-%m-%d'),Date.today.advance(:months => 2).end_of_month.strftime('%Y-%m-%d'))
    end

    def self.underStocked
      
    end

    def self.expired_items
      return PmapInventory.where("voided = ? AND current_quantity > ? AND expiration_date <= ? ", false,0, Date.current.strftime('%Y-%m-%d'))
    end

    def self.wellStocked
      return PmapInventory.select("patient_id, rxaui, count(rxaui) as count").where("current_quantity > 0 and voided = ?",false).group(:patient_id,:rxaui)
    end

    def self.move_to_general(bottle_id)
      item = PmapInventory.find_by_pap_identifier_and_voided(bottle_id,false)
  
      unless item.blank?
        PmapInventory.transaction do
          item.voided = true
          item.void_reason = "Moved to general inventory"
          item.manufacturer = "Unknown" if item.manufacturer.blank?
  
          if item.save
            new_stock_entry = GeneralInventory.new
            new_stock_entry.lot_number = item.lot_number.upcase
            new_stock_entry.expiration_date = item.expiration_date rescue nil
            new_stock_entry.received_quantity = item.current_quantity
            new_stock_entry.current_quantity = item.current_quantity
            new_stock_entry.rxaui = item.rxaui
            new_stock_entry.gn_identifier= item.pap_identifier
            new_stock_entry.save
            return new_stock_entry
          end
        end
      end
      return false
    end
end
