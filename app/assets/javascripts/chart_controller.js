var chartController = {
  player_id: null,
  chart_data: null,
  initialized: false,

  initialize: function (p_id) {
    if(this.initialized == true) return;
    this.initialized = true;

    this.player_id = p_id;
    that = this;

    $.get( "/players/" + this.player_id + "/stats", function(data) {
      that.chart_data = data;
      //weaponChart.initialize(p_id, data["weapons"]);
      matchWinChart.initialize(data["general"]["matches"]);
      matchWinChart.setStats(data["general"]["matches"], data["general"]["rounds"])

      kdChart.initialize(data["general"]["kd"]);
      kdChart.setStats(data["general"]["kd"], data["general"]["accuracy"]);
    })
    .fail(function() {
      //$("#weapon_chart").append("<div class='failure'>Chart failed to load.</div>");
      $("#win_loss_chart").append("<div class='failure chart_text'>Chart failed to load.</div>");
    })
    .always(function() {
      $(".loader").remove();
    });

    categoryTable.setTopWeaponStats("kills");
    categoryTable.setTopMapStats("wins");

    $.get( "/players/" + this.player_id + "/stats/operation_coins", function(data) {
      operationStats.initialize(data);
    }).fail(function() {
      operationStats.failed();
    });
  }
}
