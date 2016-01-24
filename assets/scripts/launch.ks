// launch -- get from ground to orbit on a column of fire
//
// This launch program will take a multi-stage rocket from the Kerbal Space
// Center up to parameter target_apoapsis, fuel and aerodynamic properties
// allowing. Max Q and friction heating with the atmosphere are not considered.
// This program will just plow right on through at full speed.
//
// Parameters:
//   * target_apoapsis :: apoapsis of eventual (roughly circular) orbit
//
// Concerns:
//   * Mechanical stress on the craft is ignored: no consideration to max Q or
//     vibration of the craft is given. Craft must be sturdy. Crew preferred
//     to be sound of mind for legal reasons.
//   * Orbits produced by this program, owing to the imprecise method used in
//     runmode 6, produces eccentric orbits. The error compounds as the apoapsis
//     target is raised.
//
// Procedure List:
//   1. Determine that payload is secured.
//   2. Launch.
//
// Example run:
//
//   > run launch(95000).
//

// We want to trim the ship, to put it in a known condition before starting out.
//
// SAS stands for Stability Assist System and augments kOS's built-in steering.
// In some lift vehicles this will increase stability, in others it will reduce
// stability. It is a hard world.
SAS on.
// RCS is Reaction Control System. RCS is only marginally useful in an
// atmosphere and the reaction mass to drive the RCS system is often limited. We
// conserve the fuel.
RCS off.
// This program needs total control over the lift system's thrust. We lock the
// throttle from user input and set it zero so we don't thrust unintentionally.
// It's embarrassing to hover 600 tons and topple it over in the wind. Also:
// deadly.
lock throttle to 0.

// 'on' allow us to run actions for user inputs. In this case, we run on action
// group 9 and exit the program by setting the runmode to 0. Other programs make
// more sophisticated use of 'on'.
on ag9 { set runmode to 0. }

clearscreen.

DECLARE PARAMETER target_apoapsis. // meters
SET target_periapsis TO target_apoapsis.

set runmode to 2. //Safety in case we start mid-flight
if ALT:RADAR < 100 { //Guess if we are waiting for take off
        set runmode to 1.
}

until runmode = 0 { //Run until we end the program

        if runmode = 1 { // get off the launchpad
                lock steering to UP.
                set TVAL to 1.
                stage.
                set runmode to 2.
        }

        else if runmode = 2 { // rotate to heading 90', straight up
                lock steering to heading(90, 90).
                if ALT:RADAR > 1000 {
                        set runmode to 3.
                }
        }

        else if runmode = 3 { //Gravity turn
                // Pitch over gradually until levelling out to 5 degrees at 50km,
                // heading 90' (east).
                set pitch to max( 5, 90 * (1 - ALT:RADAR / 50000)).
                lock steering to heading (90, pitch).
                set TVAL to 1.

                if SHIP:APOAPSIS > target_apoapsis {
                        set runmode to 4.
                }
        }

        else if runmode = 4 { // coast on up to apoapsis
                set TVAL to 0.
                if ETA:APOAPSIS < 60 {
                        set runmode to 5.
                }
        }

        else if runmode = 5 { // set up for circulization burn
                RCS on.
                lock steering to heading(90, 0). // Point 0 degrees above horizon
                if ETA:APOAPSIS < 30 {
                        set runmode to 6.
                }
        }

        else if runmode = 6 { // burn to raise periapsis
                // The approach taken here is... not the best. We ping-pong up
                // and down between 5 and -5 degrees from horizon to keep the
                // apoapsis close to us. Too short and we risk burning too far
                // past the apoapsis to raise our periapsis, too long and we
                // waste fuel and shift the center of our orbit away from the
                // main gravitational mass.
                //
                // A better approach would be to calculate the delta-v required
                // to raise the periapsis and spread that out over a burn
                // centered on the apoapsis.
                set TVAL to 1.
                lock steering to heading(90, 0). // Point 0 degrees above horizon

                if ship:orbit:apoapsis > ( 2 * target_periapsis) { // oops
                        set runmode to 10.
                }

                if ETA:APOAPSIS < 10 {
                        lock steering to heading(90, 5).
                }

                if ETA:APOAPSIS > 30 {
                        lock steering to heading(90, -5).
                }

                if SHIP:PERIAPSIS > target_periapsis {
                        set runmode to 9.
                }
        }

        else if runmode = 9 { // stablize the craft in flight
                lock throttle to 0.
                lock steering to heading(90, 0).
                wait 10.
                set runmode to 10.
        }


        else if runmode = 10 { //Final touches
                RCS off.
                SAS off.
                gear off.
                SET TVAL to 0.
                lock throttle to 0.
                unlock steering.
                set runmode to 0.

                print "SHUTDOWN: WELCOME TO SPACE" at (5,25).
        }

        LIST ENGINES IN engines.
        FOR eng in engines {
                if eng:FLAMEOUT {
                        lock throttle to 0.
                        stage.
                        wait 2.
                        lock throttle to TVAL.
                }
        }

        UNTIL MAXTHRUST > 0 {
                stage.
        }

        lock throttle to TVAL.

        //
        //  Print relevant data to the console. This will update pilot. Launches
        //  are finicky and difficult to get right manually so the information
        //  presented here will primarily serve to inform aborts.
        //
        print "RUNMODE:       " + runmode               at (5,3).

        print "VERTICAL SPEED " + ship:verticalspeed    at (5, 4).

        print "APOAPSIS:      " + round(SHIP:APOAPSIS)  at (5,6).
        print "APOAPSIS ETA:  " + round(ETA:APOAPSIS)   at (5,7).

        print "PERIAPSIS:     " + round(SHIP:PERIAPSIS) at (5,9).
        print "PERIAPSIS ETA: " + round(ETA:PERIAPSIS)  at (5,10).
}

SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
