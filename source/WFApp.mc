import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.UserProfile;
import Toybox.WatchUi;

class WFApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();
    // Log.log("WFApp::initialize()");
  }

  // onStart() is called on application start up
  function onStart(state) {
    // Log.log("WFApp::onStart " + state);
  }

  // onStop() is called when your application is exiting
  function onStop(state) {
    // Log.log("WFApp::onStop " + state);
  }

  // Return the initial view of your application here
  function getInitialView() {
    Settings.initSettings();
    return [new WF()];
  }

  // function getSettingsView() {
  //   return [new WFSettingsView(), new WFSettingsDelegate()];
  // }

  // New app settings have been received so trigger a UI update
  // function onSettingsChanged() {
  //   WatchUi.requestUpdate();
  // }
}
