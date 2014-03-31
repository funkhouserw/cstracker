var weaponChart = {
  player_id: null,
  amchart: null,
  chart_data: null,

  initialize: function (p_id) {
    this.player_id = p_id;
    that = this;

    $.get( "/players/" + this.player_id + "/stats/weapons", function(data) {
      that.chart_data = data;
      that.drawChart(data);
    })
    .fail(function() {
      $("#weapon_chart").append("<div class='failure'>Chart failed to load.</div>");
    });
  },

  drawChart: function(data) {
    var graphs = [];
    $.each($('#weapons').data('ids'), function( index, value ) {
      graphs.push({
        "id":value,
        "balloonText": value + "<br />[[d]]<br /><b><span style='font-size:14px;'>value: [[value]]</span></b>",
        "bullet": "round",
        "bulletBorderAlpha": 1,
		    "bulletColor":"#FFFFFF",
        "hideBulletsCount": 50,
        "valueField": value,
		    "useLineColorForBulletBorder":true
      });
    });

    this.amchart = AmCharts.makeChart("weapon_chart", {
      "type": "serial",
      "theme": "dark",
      "pathToImages": "/javascripts/amcharts/images/",
      "dataProvider": data,
      "valueAxes": [{
          "axisAlpha": 0.2,
          "dashLength": 1,
          "position": "left",
          "title": "Weapon Kills"
      }],
      "graphs": graphs,
      "chartCursor": {
          "cursorPosition": "mouse"
      },
      "parseDates": true,
      "categoryField": "d",
      "categoryAxis": {
          "axisColor": "#DADADA",
          "dashLength": 1,
          "minorGridEnabled": true
      }
    });
    $("#weapon_chart").addClass("loaded");
  }
}
