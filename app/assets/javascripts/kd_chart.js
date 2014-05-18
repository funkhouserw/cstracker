var kdChart = {
  amchart: null,
  chart_data: null,

  initialize: function (w_data) {
    this.chart_data = w_data;
    this.drawChart(this.chart_data);
  },

  setStats: function(kd_data, accuracy_data) {
    var kills = 0;
    var deaths = 0;
    var kd = 0;
    var total_shots = 0;
    var total_hits = 0;

    $.each( kd_data, function( index, value ) {
      kills += value.kills;
      deaths += value.deaths;
    });

    $.each( accuracy_data, function( index, value ) {
      total_hits += value.shots_hit;
      total_shots += value.shots_fired;
    });

    if(deaths != 0) kd = kills / deaths;

    $("#total_kills").text(kills);
    $("#total_deaths").text(deaths);
    $("#total_kd").text(kd);
    $("#total_accuracy").text(((total_hits / total_shots) * 100).toFixed(2) + "%");
  },

  drawChart: function(data) {
    this.amchart = AmCharts.makeChart("kd_chart", {
      "type": "serial",
      "theme": "dark",
      "pathToImages": "/javascripts/amcharts/images/",
      "dataProvider": this.chart_data,
      "color": "#FFFFFF",
      "valueAxes": [{
          "axisAlpha": 0.3,
          "gridAlpha": 0
      }],
      "graphs": [{
          "balloonText": "<b>[[title]]</b><br><span style='font-size:14px'>[[category]]: <b>[[value]]</b></span>",
          "labelText": "[[value]]",
          "title": "K/D",
		      "color": "#FFFFFF",
		      "lineColor": "#0000FF",
          "valueField": "kd",
          "id": "kd",
          "bullet": "round",
          "bulletBorderAlpha": 1,
          "bulletSize": 5,
          "hideBulletsCount": 50,
          "lineThickness": 4,
          "useLineColorForBulletBorder": true,
          "numberFormatter": {precision:2, decimalSeparator:'.', thousandsSeparator:','}

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