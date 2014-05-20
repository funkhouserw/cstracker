var matchWinChart = {
  amchart: null,
  chart_data: null,

  initialize: function (w_data) {
    this.chart_data = w_data;
    this.drawChart(this.chart_data);
  },

  setStats: function(match_data, round_data) {
    var match_wins = 0;
    var match_losses = 0;
    var round_wins = 0;
    var round_losses = 0;

    $.each( match_data, function( index, value ) {
      match_wins += value.wins;
      match_losses += value.losses;
    });

    $.each( round_data, function( index, value ) {
      round_wins += value.wins;
      round_losses += value.losses;
    });

    $("#match_wins").text(match_wins);
    $("#match_losses").text(match_losses);
    $("#round_wins").text(round_wins);
    $("#round_losses").text(round_losses);
  },

  drawChart: function(data) {
    this.amchart = AmCharts.makeChart("win_loss_chart", {
      "type": "serial",
      "theme": "dark",
      "pathToImages": "/javascripts/amcharts/images/",
      "dataProvider": this.chart_data,
      "color": "#FFFFFF",
      "chartCursor": {
        "cursorPosition":"mouse"
      },
      "valueAxis": {
          "axisAlpha": 0.3,
          "gridAlpha": 0
      },
      "graphs": [{
          "balloonText": "<b>[[title]]</b>: [[value]]",
          "title": "Wins",
		      "color": "#FFFFFF",
		      "lineColor": "#0000FF",
          "valueField": "wins",
          "id": "wins",
          "bullet": "round",
          "bulletBorderAlpha": 1,
          "bulletSize": 5,
          "hideBulletsCount": 50,
          "lineThickness": 4,
          "useLineColorForBulletBorder": true

      }, {
          "balloonText": "<b>[[title]]</b>: [[value]]",
          "lineAlpha": 0.3,
          "title": "Losses",
		      "color": "#FFFFFF",
		      "lineColor": "#FF0000",
          "valueField": "losses",
          "id": "losses",
          "bullet": "round",
          "bulletBorderAlpha": 1,
          "bulletSize": 5,
          "hideBulletsCount": 50,
          "lineThickness": 4,
          "useLineColorForBulletBorder": true
      }],
      "categoryField": "d",
      "categoryAxis": {
          "parseDates": true,
          "gridPosition": "start",
          "axisAlpha": 0,
          "gridAlpha": 0,
          "position": "left",
          "minPeriod": "DD",
          "equalSpacing": true
      }
    });
    $("#weapon_chart").addClass("loaded");
  }
}
