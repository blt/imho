SAS off.
RCS off.
LIGHTS off.
LOCK THROTTLE TO 0.
gear off.

clearscreen.

set runmode to 1.

until runmode = 0 {
  if runmode = 1 {
     lock steering to heading(90, 90).
     set TVAL to 1.
     stage.
  }
}