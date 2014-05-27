var matchWinChart = {
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

    if(match_data.length > 0)
      this.setPerformanceDateHeader(new Date(match_data[0]["d"]));
  },

  setPerformanceDateHeader: function(date) {
    $("#performance_header").append("<span class=\"section_subheader\">Since " + (date.getMonth() + 1) + '-' + date.getDate() + '-' + date.getFullYear() + "</span>");
  },

  drawChart: function(data) {
    if(data.length == 0) {
      $("#win_loss_chart").append("<div class=\"chart_text\">There is no data to display yet.<br />We'll start to collect data for this player so check back soon.</div>");
      return;
    }

    $(function () {
      $('#win_loss_chart').highcharts({
        chart: {
          type: 'column',
          backgroundColor:'transparent'
        },
        title: {
          text: ''
        },
        legend: {
          enabled: false
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
          stackLabels: {
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
            this.series.name +': '+ this.y;
          }
        },
        plotOptions: {
          column: {
            stacking: 'normal',
              dataLabels: {
                enabled: false,
                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                style: {
                  textShadow: '0 0 3px black, 0 0 3px black'
                }
            }
          }
        },
        series: [{
          name: 'Wins',
          color: '#4756FF',
          data: $.map( data, function ( elementOfArray, indexInArray ) {
            return { x: new Date(elementOfArray["d"]), y: elementOfArray["wins"]};
          })
        }, {
          name: 'Losses',
          color: '#AF0000',
          data: $.map( data, function ( elementOfArray, indexInArray ) {
            return { x: new Date(elementOfArray["d"]), y: elementOfArray["losses"]};
          })
        }]
      });
    });

    $("#weapon_chart").addClass("loaded");
  }
}
