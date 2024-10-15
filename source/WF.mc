import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

module Format {
  const INT_ZERO = "%02d";
  const INT = "%i";
  const FLOAT = "%2.0d";
}

class WF extends WatchUi.WatchFace {
  var rl = new RingAlert();

  var isWatchActive = true;
  var lastMin = -1; // last time min updated  
  var inactiveMin = 0; // how many minutes we are inactive
  var powerSavingMode = false;

  var dateToDraw = "";
  var timeToDraw = "";
  
  var battery = 0;
  var heartRateZone = 0;
  var heartRate = 0;

  var iconFont;

  // Alerts
  hidden var stressHighCount = 0;
  hidden var activeAlert = :alertNone;

  var settings = new WFSettings();
  var theme = 1;
  
  function initialize() {
    WatchFace.initialize();
    
    reloadSettings(); // preload setting values (theme is read multiple times so good to cache)

    iconFont = WatchUi.loadResource(Rez.Fonts.IconsFont);

    battery = System.getSystemStats().battery;
    Log.log("WF::initialize() - battery " + battery + "%");
  }

   // Resources are loaded here
  function onLayout(dc) {
    rl.prepare(dc);
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {
  }

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() {
    isWatchActive = true;
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {
    isWatchActive = false;
  }

  // Update the view
  function onUpdate(dc) {
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

    if (isWatchActive && (inactiveMin>0)) {
      if (powerSavingMode) {
        powerSavingMode = false;
        Log.log("powersaving=>active, " + inactiveMin + " min inactive");
      }
      
      inactiveMin = 0;
    }

    if (!now.min.equals(lastMin)) {
      lastMin = now.min;
      if (!isWatchActive) {
        inactiveMin ++;
        if (inactiveMin == settings.get("powerSavingMin")) {
          Log.log("* => powersaving after " + inactiveMin + " min");
          powerSavingMode = true;

          onEnterPowerSaving();
        }
        
      }
      
      onUpdate_1Min(now, powerSavingMode);
    }else {
      onUpdate_Immediate();
    }
    
    drawWF(dc, now);
  }

  hidden function drawWF(dc, now) {
    dc.setColor(themeColor(Color.PRIMARY), themeColor(Color.BACKGROUND));
    dc.clear();

    // time
    dc.drawText(144, 140, Graphics.FONT_NUMBER_THAI_HOT, timeToDraw, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    if (powerSavingMode) {
      return; // don't draw anything more
    }

    // battery
    dc.drawText(237, 68, Graphics.FONT_TINY, battery.format(Format.INT) + "%", Graphics.TEXT_JUSTIFY_RIGHT);
    // Date
    dc.drawText(48, 68, Graphics.FONT_TINY, dateToDraw, Graphics.TEXT_JUSTIFY_LEFT);    
    // second
    if (settings.get("showSeconds") && isWatchActive) {
      dc.drawText(144, 186, Graphics.FONT_XTINY, now.sec, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }    

    // heartRate
    if (heartRate > 0) {
      // dc.drawText(140, 225, Graphics.FONT_LARGE, heartRate.format(Format.INT), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
      dc.drawText(160, 225, Graphics.FONT_LARGE, heartRate.format(Format.INT), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      
      if (heartRateZone > 0) {
        dc.setColor(heartRateColor(heartRateZone-1), Graphics.COLOR_TRANSPARENT);
      }
      dc.drawText(140, 225, iconFont, "0", Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    
    // alert ring
    rl.draw(dc);
  }

  hidden function getHours(now, is12Hour) {
    var hours = now.hour;
    if (is12Hour) {
      if (hours == 0) {
        hours = 12;
      }
      if (hours > 12) {
        hours -= 12;
      }
    }
    return hours.format(Format.INT_ZERO);
  }

  function checkAlerts() {
    if (heartRateZone >= 5 && settings.get("heartRateAlert")) {
      setAlert(:alertHR, "High HR", themeColor(Color.ALERT_RED));
      return;
    }

    var stressAlertLevel = settings.get("stressAlertLevel");
    // 100 is disabled
    if (stressAlertLevel < 100 ) {
      var stressLevel = 0;
      var activityInfo = ActivityMonitor.getInfo();
      if (activityInfo.stressScore != null) {
        stressLevel = activityInfo.stressScore.toNumber();
      }
      if (stressLevel>=stressAlertLevel) {
        stressHighCount ++;
      } else {
        stressHighCount = 0;
      }
      if (stressHighCount >= 3) {
        setAlert(:alertStress, "Stress " + stressLevel.format(Format.INT), themeColor(Color.ALERT_ORANGE));
        return;
      }
    }
    
    if (settings.get("moveAlert")) {
      var movebar = 0;
      var activityInfo = ActivityMonitor.getInfo();
      if (activityInfo.moveBarLevel != null) {
        movebar = activityInfo.moveBarLevel.toNumber();
      }
      // movebar = ActivityMonitor.MOVE_BAR_LEVEL_MAX;
      if (movebar == ActivityMonitor.MOVE_BAR_LEVEL_MAX) {
        setAlert(:alertMove, "Time to Move", themeColor(Color.ALERT_BLUE));
        return;
      }
    }    

    setAlert(:alertNone, "", null);
  }

  function updateHearRate() {
    var hr = Activity.getActivityInfo().currentHeartRate;
    // var hr = (heartRate + 10) % 300 + 1;
    // var hr = 140;
    if (hr) {
      heartRate = hr;

      var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
      heartRateZone = 0;
      for (var i = 0; i < 6; i ++) {
        if (heartRate.toNumber() >= zones[i]) {
          heartRateZone = i+1; // zone 0 to 6
        }else {
          break;
        }
      }
      // Log.log("HR " + heartRate + " Zone " + heartRateZone);
    }
  }

  // this function is called once every 1min
  function onUpdate_1Min(now, powerSavingMode) {
    var is12Hour = !System.getDeviceSettings().is24Hour;
    dateToDraw = format("$1$ $2$", [now.day_of_week, now.day.format(Format.INT_ZERO)]);
    timeToDraw = getHours(now, is12Hour) + ":" + now.min.format(Format.INT_ZERO);

    var b = System.getSystemStats().battery;
    if (battery != 0 && battery != b) {
      // Logging battery changes
      Log.log("Battery " + battery + "% to " + b + "%");
    }    
    battery = b;
      
    if (!powerSavingMode) {
      updateHearRate();

      checkAlerts();
    }
  }

  // this function is called once per sec during isWatchActive mode
  // otherwise ad-hoc when system wants
  // this function is not called when onUpdate_1Min() gets called
  function onUpdate_Immediate() {
    if (isWatchActive) {
      if (heartRate == 0) {
        // update during start when heartrate number not available
        updateHearRate();
      }else if (heartRateZone >= settings.get("updateHRZone")) {
        // update heart rate when active if in zone specified by the setting
        updateHearRate();
      }
    }
  }

  function onEnterPowerSaving() {
    setAlert(:alertNone, "", null);
  }

  function setAlert(alert, msg, color) {
    if (activeAlert == alert) {
      return;
    }

    if (alert != :alertStress) {
      stressHighCount = 0;
    }

    /// Print changes in alert status
    Log.log("Alert " + getAlertName(activeAlert) + " => " + getAlertName(alert));
    
    activeAlert = alert;
    rl.setAlert(msg, color);
  }

  function getAlertName(alert) {
    if (alert == :alertNone) { return "none"; }
    if (alert == :alertHR) { return "HR"; }
    if (alert == :alertStress) { return "stress"; }
    if (alert == :alertMove) { return "move"; }

    return "unknown";
  }

  function themeColor(sectionId as Number) as Number {
    return Color._COLORS[theme * Color.MAX_COLOR_ID + sectionId];
  }

  function heartRateColor(sectionId as Number) as Number {
    // var theme = settings.get("theme") as Number;
    return Color._HR_COLORS[theme * 6 + sectionId];
  }

  function reloadSettings() {
    settings.initSettings();
    theme = settings.get("theme");
  }
}

