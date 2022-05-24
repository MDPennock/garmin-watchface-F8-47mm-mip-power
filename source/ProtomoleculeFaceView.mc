using Toybox.WatchUi as Ui;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;

class ProtomoleculeFaceView extends Ui.WatchFace {

  var mLowPowerMode = false;
  var mLastUpdateLowPowerMode = false;
  var mLastUpdateSleepTime = false; 
  hidden var mLastLayout;
  
  hidden var mNoProgress1;
  hidden var mNoProgress2;
  hidden var mNoProgress3;

  hidden var mActiveHeartrateField;
  hidden var mActiveHeartrateCounter = 0;

  hidden var mSettings;

  function initialize() {
    WatchFace.initialize();
  }

  function chooseLayout(dc, onLayoutCall) {
    // onLayout
    if (onLayoutCall) {
      if (requiresBurnInProtection() && mLowPowerMode) {
        Log.debug("set burn-in protection layout");
        return Rez.Layouts.SimpleWatchFace(dc);
      } else if (Settings.isSleepTime) {
        Log.debug("set sleep time layout");
        return Rez.Layouts.WatchFaceSleep(dc);
      } else {
        Log.debug("set default layout");
        return defaultLayout(dc);
      }
    }
    // enter / exit low power mode triggered
    if (requiresBurnInProtection() && mLastUpdateLowPowerMode != mLowPowerMode) {
      Log.debug("burn-in protection layout switch");
      return burnInProtectionLayout(dc);
    }
    // sleep / wake time event triggered
    if (!mLowPowerMode && mLastUpdateSleepTime != Settings.isSleepTime) {
      Log.debug("sleep time layout switch");
      return sleepTimeLayout(dc);
    }
    // Layout switch trigered
    if (!mLowPowerMode && !Settings.isSleepTime && mLastLayout != Settings.get("layout")) {
      Log.debug("default layout switch");
      return defaultLayout(dc);
    }
    Log.debug("no layout switch triggered");
    return null;
  }

  hidden function defaultLayout(dc) {
    mLastLayout = Settings.get("layout");
    return (mLastLayout == LayoutId.ORBIT) ? Rez.Layouts.WatchFace(dc) : Rez.Layouts.WatchFaceAlt(dc);
  }

  hidden function sleepTimeLayout(dc) {
    mLastUpdateSleepTime = Settings.isSleepTime;
    if (mLastUpdateSleepTime) {
      return Rez.Layouts.WatchFaceSleep(dc);
    } else {
      return defaultLayout(dc);
    }
  }

  hidden function burnInProtectionLayout(dc) {
    mLastUpdateLowPowerMode = mLowPowerMode;
    if (mLowPowerMode) {
      return Rez.Layouts.SimpleWatchFace(dc);
    }
    if (Settings.isSleepTime) {
      return sleepTimeLayout(dc);
    }
    return defaultLayout(dc);
  }

  // Load your resources here
  function onLayout(dc) {
    setLayout(chooseLayout(dc, true));
    getDrawableDataFields();
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
  }

  // Update the view
  function onUpdate(dc) {
    clearClip(dc);
    // Call the parent onUpdate function to redraw the layout
    var layout = chooseLayout(dc, false);
    if (layout != null) {
      setLayout(layout);
    }

    if (Settings.get("activeHeartrate")) {
      if (Settings.dataField("middle1") == FieldType.HEART_RATE) {
        mActiveHeartrateField = mNoProgress1;
      } else if (Settings.dataField("middle2") == FieldType.HEART_RATE) {
        mActiveHeartrateField = mNoProgress2;
      } else if (Settings.dataField("middle3") == FieldType.HEART_RATE) {
        mActiveHeartrateField = mNoProgress3;
      } else {
        mActiveHeartrateField = null;
      }
    } else {
      mActiveHeartrateField = null;
    }

    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {
  }

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() {
    if (requiresBurnInProtection()) {
      mLowPowerMode = false;
      WatchUi.requestUpdate();
    }
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {
    if (requiresBurnInProtection()) {
      mLowPowerMode = true;
      WatchUi.requestUpdate();
    }
  }

  // too expensive?
  function onPartialUpdate(dc) {
    if (!mLastUpdateSleepTime) {
      updateHeartrate(dc);
    }
  }

  function updateHeartrate(dc) {
    if (mActiveHeartrateField != null) {
      mActiveHeartrateCounter += 1; 
      if (mActiveHeartrateCounter % 10 == 0) {
        mActiveHeartrateField.draw(dc);
        mActiveHeartrateCounter = 0;
      }
    }
  }

  hidden function _settings() {
    if (mSettings == null) {
      mSettings = System.getDeviceSettings();
    }
    return mSettings;
  }

  hidden function requiresBurnInProtection() {
    return _settings() has :requiresBurnInProtection && _settings().requiresBurnInProtection;
  }

  hidden function getDrawableDataFields() {
    mNoProgress1 = findDrawableById("NoProgressDataField1");
    mNoProgress2 = findDrawableById("NoProgressDataField2");
    mNoProgress3 = findDrawableById("NoProgressDataField3");
  }
}
