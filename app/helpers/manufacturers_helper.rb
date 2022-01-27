module ManufacturersHelper
    def pmap_options
        return Manufacturer.where(:has_pmap => true, :voided => false).count()
    end

    def pmap_suppliers
        return PmapInventory.select("distinct manufacturer").count()
    end
    def active_manufacturers
        return Manufacturer.where(:voided => false).count()
    end

end
