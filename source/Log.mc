import Toybox.System;
import Toybox.Application;
import Toybox.Lang;
import Toybox.Time;

(:debug)
module Log {
  function log(string) {
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    System.println(Lang.format("$1$:$2$:$3$D: ", [now.hour,now.min,now.sec]) + string);
  }
}

(:release)
module Log {
   function log(string) {
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    System.println(Lang.format("$1$:$2$:$3$: ", [now.hour,now.min,now.sec]) + string);
  }
}
