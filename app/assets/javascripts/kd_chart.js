var kdChart = {
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
    $("#total_kd").text(kd.toFixed(2));
    if(total_shots == 0)
      $("#total_accuracy").text("--");
    else
      $("#total_accuracy").text(((total_hits / total_shots) * 100).toFixed(2) + "%");
  },

  drawChart: function(data) {
    if(data.length == 0) {
      return;
    }

    $('#kd_chart').highcharts({
      chart: {
        backgroundColor:'transparent'
      },
      title: {
        text: ''
      },
      xAxis: {
        type: 'datetime',
        labels: {
          style: {
            color: "#FFFFFF"
          }
        }
      },
      yAxis: {
        min: 0,
        maxPadding: 0,
        gridLineColor: '#555',
        title: {
          enabled: false
        },
        labels: {
          enabled: true,
          style: {
            color: "#AAA"
          }
        }
      },
      tooltip: {
        formatter: function() {
          return '<b>'+ (this.x.getMonth() + 1) + '-' + this.x.getDate() + '-' +  this.x.getFullYear() +'</b><br/>'+
          this.series.name +': '+ this.y.toFixed(2);
        }
      },
      legend: {
        enabled: false
      },
      series: [{
        name: 'KD',
        color: "#cf5300",
        data: $.map( data, function ( elementOfArray, indexInArray ) {
          return { x: new Date(elementOfArray["d"]), y: elementOfArray["kd"]}
      })}]
  });

    $("#weapon_chart").addClass("loaded");
  }
}