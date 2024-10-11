import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;
import Toybox.WatchUi;

class WFSettingsView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.clear();
        dc.drawText(0, 0,  Graphics.FONT_TINY, "Text line 1", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 20,  Graphics.FONT_TINY, "Text line 2", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 40,  Graphics.FONT_TINY, "Text line 3", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 60,  Graphics.FONT_TINY, "Text line 4", Graphics.TEXT_JUSTIFY_LEFT);

    }
}

class WFSettingsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Detect Menu behavior
    function onMenu() {
        System.println("Menu behavior triggered");
        return false; // allow InputDelegate function to be called
    }
    // Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        return true;
    }
}