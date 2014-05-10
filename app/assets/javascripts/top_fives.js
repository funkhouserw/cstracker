var topFives = {

  initialize: function () {
  },
  
  setTopWeaponStats: function(attribute) {
    $weapon_skeleton = $("#weapon_stat_skeleton");
    var that = this;

    var sorted_weapons = $('#weapons').data('weapons').sort(function(a, b) {
        return b[attribute] - a[attribute];
    });

    for (var i=0; i < 5; i++) {
      $weapon_element = $weapon_skeleton.clone();
      $weapon_element.css("display", "");
      $weapon_element.find(".number").text("" + (i + 1));
      $weapon_element.find(".name").text(sorted_weapons[i].ui_name);
      $weapon_element.find("table").append(that.statToTableRowString("Kills", sorted_weapons[i]["kills"]));
      $weapon_element.find("table").append(that.statToTableRowString("Accuracy", sorted_weapons[i]["accuracy"].toFixed(2) + "%"));
      $weapon_element.find("table").append(that.statToTableRowString("Shots Per Kill", sorted_weapons[i]["shots_per_kill"].toFixed(2)));

      $("#weapons_table").append($weapon_element);
    }
  },
  
  setTopMapStats: function(map_hash) {
    var i = 1;
    while (i < 6) {
      $( '#map_' + i ).text( map_hash[i][0] )
      $( '#map_plays_' + i ).text(map_hash[i][1] );
      i++;
    }
  },

  statToTableRowString: function(name, value) {
    return "<tr><td class=\"stat_title\">" + name + "</td><td class=\"stat stat_accent\">" + value + "</td></tr>";
  }
}
