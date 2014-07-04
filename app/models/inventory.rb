class Inventory
  include Mongoid::Document
  field :items, type: Array
  field :fetched_at, type: DateTime, default: ->{ DateTime.now }
  belongs_to :player, index: true
  index({ fetched_at: 1}, { expire_after_seconds: 3600 })

  def operations
    operations = []
    items.each do |item|
      coin = Rails.configuration.operations["coins"][item["defindex"]]
      if coin
        operations << OperationStat.new(
          Rails.configuration.operations["operations"][coin["operation"]]["name"],
          item["defindex"],
          item["attributes"])
      end
    end
    operations
  end

  OperationStat = Struct.new(:name, :item_id, :attributes) do
    def method_missing(sym, *args, &block)
      stat_info = Rails.configuration.operations["stats"][sym.to_s]
      if stat_info
        attributes.detect { |x| x["defindex"] == stat_info["id"] }.try(:[], stat_info["value"])
      else
        super(sym, *args, &block)
      end
    end

    def respond_to?(sym, include_private = false)
      Rails.configuration.operations["stats"].try(:[], sym.to_s) != nil || super(sym, include_private)
    end

    def as_json(options={})
      _json = {}
      Rails.configuration.operations["stats"].keys.each do |stat|
        _json[stat.to_sym] = self.send(stat)
      end

      _json[:name] = "#{name}"
      _json[:coin] = "#{Rails.configuration.operations["coins"][item_id]['name']}"
      _json
    end
  end
end
