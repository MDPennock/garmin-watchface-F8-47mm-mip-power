import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.UserProfile;
import Toybox.WatchUi;

module Settings {
  function get(key) {
    return _settings[key];
  }

  function initSettings() {
    setAsBoolean("showSeconds", false); // show seconds when active
    setAsNumber("updateHRZone", 2); // Higher HR zones have active HR update

    setAsNumber("powerSavingMin", 10); // Minutes inactive to enter power saving mode
  }

  function setAsBoolean(settingsId, defaultValue as Lang.Boolean) {
    var value = defaultValue;
    _settings[settingsId] = value;
  }

  function setAsNumber(settingsId, defaultValue as Lang.Number) {
    var value = defaultValue;
    _settings[settingsId] = value;
  }

  var _settings as Dictionary<String, Object> = {};
}
