import Toybox.Application;
import Toybox.Background;
import Toybox.WatchUi;

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

    WatchUi.requestUpdate();
  }
}
