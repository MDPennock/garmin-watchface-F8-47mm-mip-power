import Toybox.Application;
import Toybox.Background;
import Toybox.WatchUi;

(:background)
class WFApp extends Application.AppBase {
  hidden var wf as WF or Null;

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state) {
  }

  // onStop() is called when your application is exiting
  function onStop(state) {
    (wf as WF).checkPerfCounters();
  }

  // Return the initial view of your application here
  function getInitialView() {
    wf = new WF();
    return [wf];
  }

  function onSettingsChanged() {
    (wf as WF).reloadSettings();

    checkSleepBackground();

    WatchUi.requestUpdate();
  }

  function checkSleepBackground() as Void {
    var profile = UserProfile.getProfile();
    var current = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    current = new Time.Duration(current.hour * 3600 + current.min * 60);

    if (profile.wakeTime.lessThan(profile.sleepTime)) {
      Settings.isSleepTime = Settings.get("sleepLayoutActive") && (current.greaterThan(profile.sleepTime) || current.lessThan(profile.wakeTime));
    } else if (profile.wakeTime.greaterThan(profile.sleepTime)) {
      Settings.isSleepTime = Settings.get("sleepLayoutActive") && current.greaterThan(profile.sleepTime) && current.lessThan(profile.wakeTime);
    } else {
      Settings.isSleepTime = false;
    }
  }

}
