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


end
