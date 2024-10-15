import Toybox.Lang;
import Toybox.Application.Properties;

class WFSettings {
  var key as Dictionary<String, Object> = {};
  function initialize() {
    initSettings();
  }

  function initSettings() {
    key["theme"] = Properties.getValue("theme");
    key["showSeconds"] = Properties.getValue("showSeconds");
    key["updateHRZone"] = Properties.getValue("updateHRZone");

    key["powerSavingMin"] = Properties.getValue("powerSavingMin");

    key["heartRateAlert"] = Properties.getValue("heartRateAlert");
    key["stressAlertLevel"] = Properties.getValue("stressAlertLevel");
    key["moveAlert"] = Properties.getValue("moveAlert");
  }

  function get(k) {
    return key[k];
  }
}