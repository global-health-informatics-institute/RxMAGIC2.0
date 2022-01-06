class PmapInventory < ApplicationRecord
    belongs_to :rxnconso, :foreign_key => :rxaui
    before_save :complete_record

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


    def complete_record
        self.current_quantity = self.received_quantity
        self.date_received = Date.today
        unless !self.pap_identifier.blank?
          last_id = PmapInventory.order(pap_inventory_id: :desc).first.id rescue "0"
          next_number = (last_id.to_i+1).to_s.rjust(6,"0")
          check_digit = 0 #calculate_check_digit(next_number)
          self.pap_identifier = "P#{next_number}#{check_digit}"
        end
    end
end
