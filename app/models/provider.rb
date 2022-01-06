class Provider < ApplicationRecord

    has_many :prescriptions

    def name
        return "#{self.first_name.to_s} #{self.last_name.to_s}" 
    end

end
