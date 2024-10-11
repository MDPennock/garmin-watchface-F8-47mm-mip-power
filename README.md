![](https://services.garmin.com/appsLibraryBusinessServices_v0/rest/apps/0688f00f-64ce-4661-9ef3-464f02d56399/screenshots/bdcd8b9e-0350-495f-9980-f41778322826?raw=true)

A Watchface for Garmin Smartwatches. The date and time and all numbers are based on the "broken" letters used in the television show The Expanse.

Can now be found in the Garmin store: https://apps.garmin.com/en-US/apps/d9f524cc-b8e3-41df-b0d3-967b1743d165

### Priorities

* Battery life - goal to consume ~2.5% per day on Enduro 3 -- prioritize this over esthetic
* Health tracking - HR, Stress and steps by default - not configurable
* Smart Aura - reminder to reduce stress and HR

- Green - calm state, stress <30 during last 15 samples (one sample per min)
- Yellow - move alert, inactive for 2h, time to take a walk
- Orange - stress > 70 for more than 2 of 5 samples during last 5min (one sample per min)
- Red - current heart rate in zone 5

### Optimizations

* Minimizing code running when updating the watch face
  * Don't use View Layout as resource but rely on manual layout
  * Minimize number graphics calls, e.g., don't paint minutes in different color
  * Keep only minimum data fields during low power / always on mode

* All data fields update once when it wakes up or every 15min in background
* NOT NEEDED - Don't use data fields that have overlap with each out to avoid layered rendering
* DOESNT WORK - Don't clear background on each display update
* DOESNT WORK - Update data field and re-render only when data field has changed, e.g., hour should be refreshed only every 60min


### Different Designs

- **Orbit** - Three Indicators that show the progress towards a certain goal
- **Circles** - Five Indicators, one big ring that doesn't shows an icon and 4 small ones (two over and two under the date and time element) with a respective icon in the middle.
- **(optional) Sleep Time** - Design that will active during the configured hours of sleep. Only showes the minimum datafields (currently not configurable).

### Supported DataFields

- Heartrate
- Battery
- Calories
- Steps per Day
- Active Minutes per Week
- Floors Up / Down per Day
- Notifcations
- Alarms
- Bluetooth connection status
- Body Battery
- Stress Level

### Attributions

- Uses a slightly modified Version of the [DINish Font](https://github.com/playbeing/dinish) for the date and time elements.
- Various icons used from and inspired by [The Noun Project](https://thenounproject.com/).
