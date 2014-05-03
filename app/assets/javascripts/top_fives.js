var topFives = {

  initialize: function () {
  },
  
  setTopWeaponStats: function(attribute) {
    var sorted_weapons = $('#weapons').data('weapons').sort(function(a, b) {
        return b[attribute] - a[attribute];
    });

    for (var i=0; i < 5; i++) {
      $( '#weapon_' + i ).text( sorted_weapons[i].ui_name )
      $( '#weapon_kills_' + i ).text(sorted_weapons[i][attribute] );
    }
  },
  
  setTopMapStats: function(map_hash) {
    var i = 1;
    while (i < 6) {
      $( '#map_' + i ).text( map_hash[i][0] )
      $( '#map_plays_' + i ).text(map_hash[i][1] );
      i++;
    }
  }
}
