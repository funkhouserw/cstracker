var weaponChart = {
  player_id: null,
  amchart: null,
  chart_data: null,

  initialize: function (p_id, w_data) {
    this.player_id = p_id;
    this.chart_data = w_data;
    this.drawChart(this.chart_data);
    var that = this;

    $.each( $('#weapons').data('weapons')["groups"], function( group_id, group_data ) {
      $('#weapon_group_' + group_id).click(function() {
        that.showGroup(group_id);
      });
    });

    $('#weapon_group_rifle').removeClass("disabled");
  },

  hideGraph: function (graph_id) {
    this.amchart.hideGraph(this.amchart.getGraphById(graph_id));
  },

  showGraph: function(graph_id) {
    this.amchart.showGraph(this.amchart.getGraphById(graph_id));
  },

  showGroup: function(group_id) {
    var weaponData = $('#weapons').data('weapons')["weapons"];
    var that = this;

    $.each(this.amchart.graphs, function(index, graph) {
      if(weaponData[graph.id]["group"] == group_id) {
        if(graph.hidden == true) that.amchart.showGraph(graph);
      } else {
        if(graph.hidden == false) that.amchart.hideGraph(graph);
      }
    });

    $.each($('#weapons').data('weapons')["groups"], function(id, group_data) {
      if(id == group_id)
        $('#weapon_group_' + id).removeClass("disabled");
      else
        $('#weapon_group_' + id).addClass("disabled");
    });
  },

  hideGroup: function(group_id) {
    var that = this;
    $.each( $('#weapons').data('weapons')["weapons"], function( weapon_id, weapon_data ) {
      if(weapon_data["group"] == group_id) {
        that.hideGraph(weapon_id);
      }
    });
  },

  drawChart: function(data) {
    var graphs = [];
    $.each($('#weapons').data('weapons')["weapons"], function( weapon_id, weapon_data ) {
      graphs.push({
        "id":weapon_id,
        "balloonText": weapon_data["name"] + "<br />[[d]]<br /><b><span style='font-size:14px;'>value: [[value]]</span></b>",
        "bullet": "round",
        "bulletBorderAlpha": 1,
		    "bulletColor":"#FFFFFF",
        "hideBulletsCount": 50,
        "valueField": weapon_id,
		    "useLineColorForBulletBorder":true,
		    "hidden": weapon_data["group"] != "rifle"
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
