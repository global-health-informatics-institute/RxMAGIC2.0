class Dispensation < ApplicationRecord
    belongs_to :prescription, :foreign_key => :rx_id
    belongs_to :patient, :foreign_key => :patient_id
    include Misc

    def inventory
        return (self.inventory_id.match(/g/i)? GeneralInventory.where("gn_identifier = ?", self.inventory_id).first : PmapInventory.where("pap_identifier = ?", self.inventory_id).first)
    end
    
    def drug_name
        self.prescription.drug_name
    end
end
