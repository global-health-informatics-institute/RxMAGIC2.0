class Prescription < ApplicationRecord
    belongs_to :patient, class_name: 'Patient'
    belongs_to :provider, class_name: 'Provider'
    belongs_to :rxnconso, class_name: 'Rxnconso', :foreign_key => :rxaui

    def drug_name
        return Rxnconso.find_by_RXAUI(self.rxaui).STR
    end
    
    def prescribed_by
        return self.provider.name
    end

    def made_by
        return ""
    end

    def has_pmap
        pmap_meds = PmapInventory.where("patient_id = ? and rxaui = ? and current_quantity > ? and voided = ?",
                                       self.patient_id, self.rxaui, 0, false).pluck(:pap_inventory_id)
    
        return (pmap_meds.blank? ? false : true)
      end
end
