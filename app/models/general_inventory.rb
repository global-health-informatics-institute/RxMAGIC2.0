class GeneralInventory < ApplicationRecord
    has_one :rxnconso, :foreign_key => :rxaui
    before_save :complete_record
    before_create :complete_record
    attribute :name, :string
    #validates_associated :rxnconso

    include Misc

    def drug_name
      return Rxnconso.find_by_RXAUI(self.rxaui).STR
    end
    
    def bottle_id
        return self.gn_identifier
    end

    def formatted_identifier
      return self.gn_identifier
    end

    def formatted_lot_number
      return self.lot_number
    end

    def complete_record
      self.current_quantity = self.received_quantity
      self.date_received = Date.today
      unless !self.gn_identifier.blank?
        last_id = GeneralInventory.order(gn_inventory_id: :desc).first.id rescue "0"
        next_number = (last_id.to_i+1).to_s.rjust(6,"0")
        check_digit = calculate_check_digit(next_number)
        self.gn_identifier = "G#{next_number}#{check_digit}"
      end
      if self.rxaui.blank? and !self.name.blank?
        self.rxaui = Rxnconso.where("STR = ? and TTY in ('PSN', 'SCD')", self.name).first.RXAUI
      end
    end

    def aboutToExpire_items
    end

    def underStocked
      
    end

    def expired_items
    end

    def wellStocked
    end

end
