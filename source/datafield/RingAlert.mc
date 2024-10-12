import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class RingAlert {
  hidden var centerX;
  hidden var centerY;
  hidden var msgY;
  hidden var radius;
  hidden var weight;
  hidden var hasAlert = false;
  hidden var alertMsg = "";
  hidden var color;

  function initialize() {
  }

  function prepare(dc) {
    var width = System.getDeviceSettings().screenWidth;
    var height = System.getDeviceSettings().screenHeight;

    centerX = width / 2.0;
    centerY = height / 2.0;
    msgY = centerY * 0.3;
    radius = width / 2.0;
    weight = radius * 0.11;
  }

  function setAlert(a, c) {
    alertMsg = a;
    hasAlert = !alertMsg.equals("");
    color = c;
  }

  function draw(dc) {
    if (! (hasAlert && color)) {
      return;
    }

    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    // setAntiAlias(dc, true);
    
    dc.setPenWidth(weight);
    dc.drawCircle(centerX, centerY, radius-weight/2+2);

    // setAntiAlias(dc, false);

    dc.drawText(centerX, msgY, Graphics.FONT_SYSTEM_XTINY, alertMsg, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }
}
