var operationStats = {
  operation_data: null,

  initialize: function (data) {
    this.operation_data = data;
    this.addOperationData(data);
  },

  addOperationData: function(_data) {
    $operation_skeleton = $("#operation_stat_skeleton");
    var operation_dom_elements = [];
    var that = this;

    $.each(_data, function( index, operation ) {
      var $operation_element = $operation_skeleton.clone();
      $operation_element.removeAttr('id');
      $operation_element.css("display", "");
      $operation_element.find(".operation_title").text(operation["name"]);
      $operation_element.find("table").append(that.statToTableRowString("Competitive Match Wins", operation["comp_wins"]));
      $operation_element.find("table").append(that.statToTableRowString("Competitive Kills", operation["comp_kills"]));
      $operation_element.find("table").append(that.statToTableRowString("3k Rounds", operation["comp_3k"]));
      $operation_element.find("table").append(that.statToTableRowString("4k Rounds", operation["comp_4k"]));
      $operation_element.find("table").append(that.statToTableRowString("5k Rounds", operation["comp_5k"]));
      $operation_element.find("table").append(that.statToTableRowString("Headshot Percentage", operation["comp_hs"].toFixed(2) + "%"));
      $operation_element.find("table").append(that.statToTableRowString("Competitive MVPs", operation["comp_mvp"]));

      operation_dom_elements.push($operation_element);

      if((index + 1) % 3 == 0) {
        if(index > 0 ) operation_dom_elements.push($("<br class='clear' />"));
      }
    });

    $("#operation_stats_container").append(operation_dom_elements);
  },

  statToTableRowString: function(name, value) {
    return "<tr><td class=\"stat_title\">" + name + "</td><td class=\"stat stat_accent\">" + value + "</td></tr>";
  },

  failed: function() {
    $("#operation_stats_container").append("<div class='api_error'>Inventory is set to private or there was a Steam API error.</div>");
  }
}
