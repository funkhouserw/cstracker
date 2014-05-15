var categoryTable = {

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
      $weapon_element.removeAttr('id');
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
  
  setTopMapStats: function(attribute) {
    $map_skeleton = $("#map_stat_skeleton");
    $map_skeleton.removeAttr('id');
    var that = this;
    var top_map_dom_elements = [];
    var map_dom_elements = [];

    var sorted_maps = $('#maps').data('maps').sort(function(a, b) {
      return b[attribute] - a[attribute];
    });

    $.each(sorted_maps, function( index, map ) {
      var $map_element = $map_skeleton.clone();
      $map_element.css("display", "");
      $map_element.find(".number").text("" + (index + 1));
      $map_element.find(".stat_name").text(map.ui_name);
      $map_element.find("table").append(that.statToTableRowString("Wins", map["wins"]));
      $map_element.find("table").append(that.statToTableRowString("Rounds Played", map["played"]));
      $map_element.find("table").append(that.statToTableRowString("Win Percent", map["win_percentage"].toFixed(2) + "%"));

      if(index < 5) top_map_dom_elements.push($map_element);
      else map_dom_elements.push($map_element);

      if((index + 1) % 5 == 0) {
        if(index > 0 ) map_dom_elements.push($("<br class='clear' />"));
      }
    });

    $("#top_maps_table").append(top_map_dom_elements);
    $("#maps_table").append(map_dom_elements);
  },

  statToTableRowString: function(name, value) {
    return "<tr><td class=\"stat_title\">" + name + "</td><td class=\"stat stat_accent\">" + value + "</td></tr>";
  }
}
