class Patient < ApplicationRecord

    def name
        return "#{self.first_name.to_s} #{self.last_name.to_s}" 
    end

    def full_gender
        return self.gender == "F" ? "Female" : "Male"
    end

    def formatted_dob
        return self.birthdate.strftime("%B %d, %Y") rescue "Unknown"
    end

    def age
        age_in_days = (Date.today - self.birthdate).to_i

        if age_in_days < 31
            return age_in_days.to_s + " days"
        elsif age_in_days < 365
            years = (Date.today.year - self.birthdate.year)
            months = (Date.today.month - self.birthdate.month)
            return ((years * 12) + months).to_s + " months"
        else
            return (age_in_days / 365)
        end
    end
end
