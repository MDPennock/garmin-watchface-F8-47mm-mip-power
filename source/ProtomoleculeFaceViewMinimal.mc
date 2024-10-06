import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;

class ProtomoleculeFaceViewMinimal extends WatchUi.WatchFace {
  var mBurnInProtectionMode = false;
  var mLastUpdateBIPMode = false;
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

  hidden function defaultLayout(dc) {
    // mLastLayout = Settings.get(layout);
    // return mLastLayout == LayoutId.ORBIT ? Rez.Layouts.WatchFace(dc) : Rez.Layouts.WatchFaceAlt(dc);

    return Rez.Layouts.WatchFace(dc);
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {}

  // Update the view
  function onUpdate(dc) {
    clearClip(dc);
    
    setLayout(defaultLayout(dc));
    
    mActiveHeartrateField = null;

    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() {
    if (requiresBurnInProtection()) {
      mBurnInProtectionMode = false;
      WatchUi.requestUpdate();
    }
    // Settings.lowPowerMode = false;
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {
    if (requiresBurnInProtection()) {
      mBurnInProtectionMode = true;
      WatchUi.requestUpdate();
    }
    // Settings.lowPowerMode = true;
  }

  // too expensive?
  function onPartialUpdate(dc) {
    // if (!mLastUpdateSleepTime) {
    //   updateHeartrate(dc);
    // }
  }

  function updateHeartrate(dc) {
    if (mActiveHeartrateField != null) {
      mActiveHeartrateCounter += 1;
      if (mActiveHeartrateCounter % 10 == 0) {
        mActiveHeartrateField.partialUpdate(dc);
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
