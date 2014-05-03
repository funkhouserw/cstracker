class Inventory
  include Mongoid::Document
  field :items, type: Array
  field :player_id, type: Integer
  field :fetched_at, type: DateTime, default: ->{ DateTime.now }
  index({ player_id: 1 }, { name: "player_id_index" })
  index({ fetched_at: 1}, { expire_after_seconds: 3600 })

  def operations
    operations = []
    items.each do |item|
      coin = Rails.configuration.operations["coins"][item["defindex"]]
      if coin
        operations << OperationStat.new(Rails.configuration.operations["operations"][coin["operation"]]["name"], item["attributes"])
      end
    end
    operations
  end

  OperationStat = Struct.new(:name, :attributes) do
    def method_missing(sym, *args, &block)
      stat_info = Rails.configuration.operations["stats"][sym.to_s]
      if stat_info
        attributes.detect { |x| x["defindex"] == stat_info["id"] }[stat_info["value"]]
      else
        super(sym, *args, &block)
      end
    end

    def respond_to?(sym, include_private = false)
      Rails.configuration.operations["stats"].try(:[], sym.to_s) != nil || super(sym, include_private)
    end
  end
end
