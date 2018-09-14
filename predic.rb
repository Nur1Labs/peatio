def generate_orders(market_id, orders_settings)
  orders = []
  market  = Market.find_by_id(market_id)
  traders = Member.where(email: orders_settings[:traders].split(',')).pluck(:id)
  orders_settings[:amount].times do
    orders << {
      volume:     orders_settings[:min_volume],
      price:      orders_settings[:min_price],
      created_at: orders_settings[:min_created_at],
      updated_at: orders_settings[:min_created_at],
      ord_type:   :limit,
      bid:        market.quote_unit,
      ask:        market.base_unit,
      type:       orders_settings[:type] == 'bid' ? 'OrderBid' : 'OrderAsk',
      member_id:  traders.sample,
      market_id:  market.id,
      state:      ::Order::WAIT
    }
  end
  orders
end

YAML.load_file('predictive_trading.yml' || []).deep_symbolize_keys.each do |market, settings|
  settings.map do |orders_settings|
    generate_orders(market, orders_settings)
      .yield_self do |orders_array|
        orders_array.map {|order_hash| Order.new(order_hash) }
      end
      .yield_self do |orders_objects|
        Ordering.new(orders_objects).submit
      end
  end
end
