import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;

class ProtomoleculeFaceViewMinimal extends WatchUi.View {
  function initialize() {
    View.initialize();
  }

   // Resources are loaded here
  function onLayout(dc) {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {}

  // Update the view
  function onUpdate(dc) {
    clearClip(dc);

    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() {
    Settings.lowPowerMode = false;

    WatchUi.requestUpdate();
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {
    Settings.lowPowerMode = true;

    WatchUi.requestUpdate();
  }
}

