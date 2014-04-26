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
    })
    .fail(function() {
      //$("#weapon_chart").append("<div class='failure'>Chart failed to load.</div>");
      $("#win_loss_chart").append("<div class='failure'>Chart failed to load.</div>");
    });
  }
}
