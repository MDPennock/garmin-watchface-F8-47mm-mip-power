import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application;

module Color {
  const BACKGROUND as Number = 0;
  const PRIMARY as Number = 1;
  const ALERT_GREEN as Number = 2;
  const ALERT_BLUE as Number = 3;
  const ALERT_ORANGE as Number = 4;
  const ALERT_RED as Number = 5;

  const MAX_COLOR_ID as Number = 6;

// see colors at https://developer.garmin.com/connect-iq/user-experience-guidelines/incorporating-the-visual-design-and-product-personalities/
  const _COLORS as Array<Number> = [
    /* DARK */
    Graphics.COLOR_BLACK, // BACKGROUND
    Graphics.COLOR_WHITE, // PRIMARY
    0xAAFFAA, // ALERT_GREEN
    0xAAFFFF, // ALERT_BLUE
    0xFFAA55, // ALERT_ORANGE
    0xAA0000, // ALERT_RED,
    /* LIGHT */
    Graphics.COLOR_WHITE, // BACKGROUND
    Graphics.COLOR_BLACK, // PRIMARY
    0x00AA00, // ALERT_GREEN
    0x00AAFF, // ALERT_BLUE
    0xFFAA00, // ALERT_ORANGE
    0xAA0000, // ALERT_RED,
    /* NIGHT */
    Graphics.COLOR_BLACK, // BACKGROUND
    Graphics.COLOR_DK_RED, // PRIMARY,
    Graphics.COLOR_GREEN, // ALERT_GREEN
    Graphics.COLOR_YELLOW, // ALERT_YELLOW
    Graphics.COLOR_ORANGE, // ALERT_ORANGE
    Graphics.COLOR_RED, // ALERT_RED,
  ];

  // see colors at https://developer.garmin.com/connect-iq/user-experience-guidelines/incorporating-the-visual-design-and-product-personalities/
  const _HR_COLORS as Array<Number> = [
    Graphics.COLOR_LT_GRAY, // zone-1 gray
    Graphics.COLOR_BLUE, // zone 2 blue
    0x55FF00, // zone 3 green
    0xFFAA00, // zone 4 yellow
    0xFF5555, // zone 5 orage
    0xFF5555, // max red
    Graphics.COLOR_DK_GRAY, // zone-1 gray
    0x0055AA, // zone 2 blue
    0x00AA00, // zone 3 green
    0xFF5500, // zone 4 yellow
    0xAA0000, // zone 5 orage
    0xAA0000, // max red    
  ];
}

function themeColor(sectionId as Number) as Number {
  // var theme = Settings.get("theme") as Number;
  var theme = 1;
  return Color._COLORS[theme * Color.MAX_COLOR_ID + sectionId];
}

function heartRateColor(sectionId as Number) as Number {
  // var theme = Settings.get("theme") as Number;
  var theme = 1;
  return Color._HR_COLORS[theme * 6 + sectionId];
}

function setAntiAlias(dc, enabled as Boolean) as Void {
  if (Graphics.Dc has :setAntiAlias) {
    dc.setAntiAlias(enabled);
  }
}

function clearClip(dc) as Void {
  if (Graphics.Dc has :clearClip) {
    dc.clearClip();
  }
}
