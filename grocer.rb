def consolidate_cart(cart)
  new_cart = {}
  cart.each do |elem|
    first = elem.keys.first
    if new_cart.include?(first)
      new_cart[first][:count] += 1
    else
      new_cart[first] = elem[first] 
      new_cart[first][:count] = 1 
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.include?(coupon[:item])
      item = cart[coupon[:item]]
      if item[:count] >= coupon[:num]
        item_w_coupon = coupon[:item] + ' W/COUPON'
        if cart.include?(item_w_coupon)
          cart[item_w_coupon][:count] += coupon[:num]
          item[:count] -= coupon[:num]
        else
          cart[coupon[:item] + ' W/COUPON'] = {
            price: coupon[:cost] / coupon[:num],
            clearance: item[:clearance],
            count: coupon[:num]
          }
          item[:count] -= coupon[:num]
        end
      end
    end
  end 
  cart
end



def apply_clearance(cart)
  cart.each do |elem|
    if elem.last[:clearance]
     elem.last[:price] = (elem.last[:price] * 0.8).round(2)
    end
  end
    cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, attributes|
    total += (attributes[:price] * attributes[:count])
  end 
  total > 100.00 ? (total * 0.9).round(2) : total
end

coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.00},
           {:item => "AVOCADO", :num => 2, :cost => 5.00}]
grocery_cart = [
  {"AVOCADO" => {:price => 3.00, :clearance => true }},
  {"AVOCADO" => {:price => 3.00, :clearance => true }},
  {"AVOCADO" => {:price => 3.00, :clearance => true }},
  {"AVOCADO" => {:price => 3.00, :clearance => true }},
  {"AVOCADO" => {:price => 3.00, :clearance => true }},
  {"KALE"    => {:price => 3.00, :clearance => false}}
]

new_grocery_cart = consolidate_cart(grocery_cart)
p apply_coupons(new_grocery_cart, coupons)