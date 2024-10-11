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

class ProtomoleculeFaceViewMinimal extends WatchUi.WatchFace {
  var rl = new RingAlert();

  var highpower = true;
  var lastMin = -1; // last time min updated  
  var inactiveMin = 0; // how many minutes we are inactive

  // Layout Positions
  hidden var dateX = 0;
  hidden var dateY = 0;
  hidden var timeX = 0;
  hidden var timeY = 0;
  hidden var secX = 0;
  hidden var batteryX = 0;
  hidden var hrX;
  hidden var hrY;
  hidden var hrIconY;

  var dateToDraw = "";
  var timeToDraw = "";
  var batteryToDraw = "";

  // var heartRateActive = false;
  var heartRateZone = 0;
  var heartRate = 0;

  var iconFont;

  // Alerts
  hidden var stressLowCount = 0;
  hidden var stressHighCount = 0;

  // var dt = new DateTimeBattery();
  // var df1 = new SecondaryDataField({:fieldId=>FieldId.NO_PROGRESS_1});

  function initialize() {
    WatchFace.initialize();

    iconFont = WatchUi.loadResource(Rez.Fonts.IconsFont);
  }

   // Resources are loaded here
  function onLayout(dc) {
    rl.prepare(dc);
    prepareLayout(dc);
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {}

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() {
    Log.debug(" - system onExitSleep()");
    highpower = true;
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {
    Log.debug(" - system onEnterSleep()");
    highpower = false;
  }

  // Update the view
  function onUpdate(dc) {    
    var powerSavingMode = false;
    if (highpower && (inactiveMin>0)) {
      Log.debug(" - enter active/high power mode after " + inactiveMin + " min inactive");
      inactiveMin = 0;
    }

    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    if (!now.min.equals(lastMin)) {
      lastMin = now.min;
      if (!highpower) {
        inactiveMin ++;
        if (inactiveMin == 30) {
          Log.debug(" - enter power saving mode after 30min inactive");
        }
        powerSavingMode = inactiveMin>30; // inactive for 30min
      }
      
      onUpdate_1Min(now, powerSavingMode);
    }else {
      onUpdate_Immediate();
    }
    
    dc.setColor(themeColor(Color.PRIMARY), themeColor(Color.BACKGROUND));
    dc.clear();
    
    // time
    dc.drawText(timeX, timeY, Graphics.FONT_NUMBER_THAI_HOT, timeToDraw, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    if (powerSavingMode) {
      return; // don't draw anything more
    }

    // battery
    dc.drawText(batteryX, dateY, Graphics.FONT_TINY, batteryToDraw, Graphics.TEXT_JUSTIFY_RIGHT);
    // Date
    dc.drawText(dateX, dateY, Graphics.FONT_TINY, dateToDraw, Graphics.TEXT_JUSTIFY_LEFT);    
    // second
    if (Settings.get("showSeconds") && highpower) {
      dc.drawText(secX, timeY, Graphics.FONT_XTINY, now.sec, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }    

    // heartRate
    if (heartRate > 0) {
      dc.drawText(hrX, hrY, Graphics.FONT_LARGE,  heartRate.format(Format.INT), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      
      if (heartRateZone > 0) {
        dc.setColor(heartRateColor(heartRateZone-1), Graphics.COLOR_TRANSPARENT);
      }
      dc.drawText(hrX, hrIconY, iconFont, "p", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
    var movebar = ActivityMonitor.getInfo().moveBarLevel;
    
    var stressLevel = 0;
    if (ActivityMonitor.Info has :stressScore) {
      // Log.debug("Using stress score");
      var activityInfo = ActivityMonitor.getInfo();
      if (activityInfo.stressScore != null) {
        stressLevel = activityInfo.stressScore.toDouble();
      }
    }

    if (stressLevel >=60) {
      stressHighCount ++;
    }else {
      stressHighCount = 0;
    }
    
    if (stressLevel>0 && stressLevel <=30) {
      stressLowCount ++;
    } else {
      stressLowCount = 0;
    }

    if (heartRateZone >= 5) {
      rl.setAlert("High HR", themeColor(Color.ALERT_RED));
    } else if (stressHighCount >= 3) {
      rl.setAlert("Stress " + stressLevel.format(Format.INT), themeColor(Color.ALERT_ORANGE));
    } else if (movebar == ActivityMonitor.MOVE_BAR_LEVEL_MAX) {
      rl.setAlert("Time to Move", themeColor(Color.ALERT_BLUE));
    } else if (stressLowCount>=3) {
      rl.setAlert("Calm" + stressLevel.format(Format.INT), themeColor(Color.ALERT_GREEN));
    } else {
      rl.setAlert("", null);
    }
  }

  function prepareLayout(dc) {
    var w = dc.getWidth();
    var h = dc.getHeight();

    dateX = w * 0.16;
    dateY = h * 0.210;
    timeX = w * 0.475;
    timeY = h * 0.5;
    secX  = w * 0.95;
    batteryX = w * 0.84;
    hrX = w * 0.495;
    hrY = h * 0.77;
    hrIconY = h * 0.87;
  }

  function updateHearRate() {
    var hr = Activity.getActivityInfo().currentHeartRate;
    // var hr = heartRate + 10;
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
      // Log.debug("HR " + heartRate + " Zone " + heartRateZone);
    }
  }

  // this function is called once every 1min
  function onUpdate_1Min(now, powerSavingMode) {
    var is12Hour = !System.getDeviceSettings().is24Hour;
    dateToDraw = format("$1$ $2$", [now.day_of_week, now.day.format(Format.INT_ZERO)]);
    timeToDraw = getHours(now, is12Hour) + ":" + now.min.format(Format.INT_ZERO);

    batteryToDraw = System.getSystemStats().battery.format(Format.INT) + "%";
      
    if (!powerSavingMode) {
      updateHearRate();

      checkAlerts();
    }
  }

  // this function is called once per sec during highpower mode
  // otherwise ad-hoc when system wants
  // this function is not called when onUpdate_1Min() gets called
  function onUpdate_Immediate() {
    if (highpower) {
      updateHearRate();
    }
  }
}

