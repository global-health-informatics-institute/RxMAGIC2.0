module PmapInventoriesHelper
    def reorders(inventory)
        results = []
        (inventory || []).each do |item|
          results << {"patient_name" => item.owner,
                      "patient_gender" => item.patient.full_gender,
                      "patient_birthdate" => item.patient.formatted_dob,
                      "drug" => item.drug_name,
                      "reorder_date" => item.reorder_date.to_date.strftime('%b %d, %Y'),
                      "manufacturer" => item.manufactured_by,
                      "id" => item.id}
        end
        return results
    end
end
