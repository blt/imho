//Set the ship to a known configuration
SAS on.
RCS off.
lights off.
lock throttle to 0. //Throttle is a decimal from 0.0 to 1.0
gear off.

clearscreen.

DECLARE PARAMETER targetApoapsis. // meters
SET targetPeriapsis TO targetApoapsis.

set missionStartSeconds TO TIME:SECONDS.

set runmode to 2. //Safety in case we start mid-flight
if ALT:RADAR < 100 { //Guess if we are waiting for take off
        set runmode to 1.
}

until runmode = 0 { //Run until we end the program

        if runmode = 1 { //Ship is on the launchpad
                lock steering to UP.  //Point the rocket straight up
                set TVAL to 1.        //Throttle up to 100%
                stage.                //Same thing as pressing Space-bar
                set runmode to 2.     //Go to the next runmode
        }

        else if runmode = 2 { // rotate to heading 90', straight up
                lock steering to heading(90, 90).
                if ALT:RADAR > 1000 {
                        set runmode to 3.
                }
        }

        else if runmode = 3 { //Gravity turn
                set targetPitch to max( 5, 90 * (1 - ALT:RADAR / 50000)).
                //Pitch over gradually until levelling out to 5 degrees at 50km
                lock steering to heading (90, targetPitch). //Heading 90' (East), then target pitch
                set TVAL to 1.

                if SHIP:APOAPSIS > targetApoapsis {
                        set runmode to 4.
                }
        }

        else if runmode = 4 { //Coast to Ap
                set TVAL to 0. //Engines off.
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

        else if runmode = 6 { //Burn to raise Periapsis
                set TVAL to 1.
                lock steering to heading(90, 0). // Point 0 degrees above horizon

                if ship:orbit:apoapsis > ( 2 * targetPeriapsis) {
                        set runmode to 10.
                }

                if ETA:APOAPSIS < 10 {
                        lock steering to heading(90, 5).
                }

                if ETA:APOAPSIS > 30 {
                        lock steering to heading(90, -5).
                }

                if SHIP:PERIAPSIS > targetPeriapsis {
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
                lights off.
                panels on.
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

        lock throttle to TVAL. //Write our planned throttle to the physical throttle

        SET elapsedMissionTime TO (TIME:SECONDS - missionStartSeconds).

        //Print data to screen.
        print "RUNMODE:       " + runmode                 + "      " at (5,3).
        print "ELAPSED:       " + elapsedMissionTime      + "      " at (5,4).

        print "VERTICAL SPEED " + ship:verticalspeed + "      " at (5, 6).

        print "APOAPSIS:      " + round(SHIP:APOAPSIS)    + "      " at (5,12).
        print "APOAPSIS ETA:  " + round(ETA:APOAPSIS)     + "      " at (5,13).

        print "PERIAPSIS:     " + round(SHIP:PERIAPSIS)   + "      " at (5,15).
        print "PERIAPSIS ETA: " + round(ETA:PERIAPSIS)    + "      " at (5,16).

        print "TVAL:          " + TVAL                    + "      " at (5,18).
}

SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
