# Design Philosophy

The Apollo spacecraft that took humans back and forth to the Moon from 1969 to
1972 was a hybrid craft. In many of its systems it was fully automatic, being
controlled by a sophisticated suite of real-time programs running in the Apollo
Guidance Computer. [RCS jets](https://en.wikipedia.org/wiki/Reaction_control_system)
were fired solely by the computer, for instance. These automatic systems were
"flown" by the human crew, preserving the human pilots as the supreme authority
in the craft. While RCS trimming was controlled by the computer, the pilots set
the attitude goals.

Automation excels at repeating the same well-understood task without error but
it is entirely unable to improvise and will have do Bad Things should the
situation get outside of the norm expected by the design and engineering team.
Human operators excel at adaptation to new circumstances and improvement on
existing processes but are unable to cope with tedium, forgetting steps or
"improving" our way out of them.

In this project we'll build a similar hybrid system. Where feasible, human
operation should be preferred to automatic. Where it will reduce error
and relieve tedium, automation should be applied, though in a manner that does
not reduce the pilot's ability to intercede in a crisis nor one that reduces the
pertinent information available to the pilot.

Good technology accepts the failures of humanity. It acts as a tool rather than
a master, increasing our capability for action, though to do so often requires
significant study and experimentation. When designing a new piece of the
guidance system, ask "What information do I need to do better?" or "In this
task, what is the essential human activity?"

Consider the descent to the Mun. Landing the Mun Thrower V's payload requires a
few essential variables to be kept under control:

  * vertical speed at impact must be within leg tolerance
  * horizontal speed at impact must be zero
  * landing site must be relatively flat

This last point, with the equipment available in the lander, is an essentially
human action. The project default landing script [land.ks](../assets/scripts/land.ks) leaves all three
points under human control but reduces the tedium--and error--involved in
controlling the first two. A smooth landing still requires significant practice
but you're less likely to become a permanent fixture on the Mun.
