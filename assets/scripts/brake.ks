// brake -- arrests fly-by and enters orbit around body
//
// This program converts a fly-by orbit of a body into a capture. This is done
// by firing program, as is traditional by the laws of physics. No delta-v
// calculation takes place. This program searches for the correct burn
// parameters by steadily adjusting them upward.
//
// Parameters:
//   NONE
//
// Concerns:
//   * No attempt is made to ensure that braking is done in the
//     sphere-of-influence of any particular body. Maybe that's a good thing.
//   * Depending on orbital speed and parameters this program may take a Very
//     Long Time to run, causing the craft to shoot past its burn window.
//
// Procedure List:
//   1. Ensure vessel is in the SOI of the appropriate body.
//   2. Ensure periapsis is at appropriate altitude for mission parameters.
//   3. Run program.
//   4. Before committing to burn, ensure delta-v budget of craft is not
//      consumed.
//
// Example run:
//
//   > run brake.
//

set runmode to 1.

set brk_node to node(time:seconds + eta:periapsis, 0, 0, 0).
add brk_node.
set cnt to 0.
set step to 0.1.

on ag9 { set runmode to 0. }

until runmode = 0 {
        if runmode = 1 {
                set brk_node:prograde to brk_node:prograde - step.
                set cnt to cnt + 1.
                when (abs(brk_node:orbit:apoapsis - brk_node:orbit:periapsis) < 10000) then {
                        set step to 0.01.
                }
                if (abs(brk_node:orbit:apoapsis - brk_node:orbit:periapsis) < 100) OR
                   (cnt > 10000) {
                        set runmode to 0.
                }
        }

        print "RUNMODE: " + runmode at (5,5).

        print "PREDICTED APOAPSIS: " + brk_node:orbit:apoapsis at (5,7).
        print "PREDICTED PERIAPSIS: " + brk_node:orbit:periapsis at (5,8).

        print "CNT: " + cnt at (5,10).
}
