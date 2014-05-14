var topFives = {

  initialize: function () {
  },
  
  setTopWeaponStats: function(attribute) {
    $weapon_skeleton = $("#weapon_stat_skeleton");
    var that = this;
    var top_weapon_dom_elements = [];
    var weapon_dom_elements = [];

    var sorted_weapons = $('#weapons').data('weapons').sort(function(a, b) {
        return b[attribute] - a[attribute];
    });

    $.each(sorted_weapons, function( index, weapon ) {
      var $weapon_element = $weapon_skeleton.clone();
      $weapon_element.css("display", "");
      $weapon_element.find(".number").text("" + (index + 1));
      $weapon_element.find(".stat_name").text(weapon.ui_name);
      $weapon_element.find("table").append(that.statToTableRowString("Kills", weapon["kills"]));
      $weapon_element.find("table").append(that.statToTableRowString("Accuracy", weapon["accuracy"].toFixed(2) + "%"));
      $weapon_element.find("table").append(that.statToTableRowString("Shots Per Kill", weapon["shots_per_kill"].toFixed(2)));

      if(index < 5) top_weapon_dom_elements.push($weapon_element);
      else weapon_dom_elements.push($weapon_element);

      if((index + 1) % 5 == 0) {
        if(index > 0 ) weapon_dom_elements.push($("<br class='clear' />"));
      }
    });

    $("#top_weapons_table").append(top_weapon_dom_elements);
    $("#weapons_table").append(weapon_dom_elements);
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
