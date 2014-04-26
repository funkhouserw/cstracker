var matchWinChart = {
  amchart: null,
  chart_data: null,

  initialize: function (w_data) {
    this.chart_data = w_data;
    this.drawChart(this.chart_data);
  },

  drawChart: function(data) {
    this.amchart = AmCharts.makeChart("win_loss_chart", {
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
          "lineAlpha": 0.3,
          "title": "Wins",
		      "color": "#FFFFFF",
		      "lineColor": "#0000FF",
          "valueField": "wins"
      }, {
          "balloonText": "<b>[[title]]</b><br><span style='font-size:14px'>[[category]]: <b>[[value]]</b></span>",
          "labelText": "[[value]]",
          "lineAlpha": 0.3,
          "title": "Losses",
		      "color": "#FFFFFF",
		      "lineColor": "#FF0000",
          "valueField": "losses"
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
