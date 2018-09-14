# create_order(mar)
#
def generate_orders(settings)
  orders = []
  settings[:amount].times do
    orders << {
      volume:     settings[:min_volume],
      price:      settings[:min_price],
      created_at: settings[:min_created_at],
      updated_at: settings[:min_created_at]
    }
  end
end

def save_orders

end

YAML.load_file('predictive_trading.yml' || []).deep_symbolize_keys.each do |market, orders|
  orders
  binding.pry
end