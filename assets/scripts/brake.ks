set runmode to 1.

set brk_node to node(time:seconds + eta:periapsis, 0, 0, 0).
add brk_node.
set cnt to 0.
set step to 0.1.

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
