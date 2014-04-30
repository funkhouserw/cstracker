var topFives = {

  initialize: function () {
  },
  
  setTopWeaponStats: function(weapon_hash) {
    var i = 1;
    while (i < 6) {
      $( '#weapon_' + i ).text( weapon_hash[i][0] )
      $( '#weapon_kills_' + i ).text(weapon_hash[i][1] );
      i++;
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
