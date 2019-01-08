class Market

  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def sorted_item_list
    @vendors.map do |vendor|
      vendor.inventory.keys
    end.flatten.sort.uniq
  end

  def total_inventory
    total = {}
    sorted_item_list.each do |item|
      total[item] = total_item_inventory(item)
    end
    total
  end

  def total_item_inventory(item)
    vendors_that_sell(item).sum do |vendor|
      vendor.inventory[item]
    end
  end

  def reduce_stock(item, amount)
    vendors_that_sell(item).inject(amount) do |total, vendor|
      if amount > vendor.inventory[item]
        stock = vendor.inventory[item]
        vendor.inventory[item] = 0
        total - stock
      elsif amount <= vendor.inventory[item]
        total - vendor.inventory[item]
        vendor.inventory[item] -= total
      end
    end
  end

  def sell(item, amount)
    if total_item_inventory(item) >= amount
      reduce_stock(item, amount)
      true
    else
      false
    end
  end

end
