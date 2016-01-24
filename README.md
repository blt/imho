# International Mun Humbling Organization

> Ancient Kerbals believed that the Mun was a big, spooky ghost which, no matter
> how many times they offered and no matter how graciously, would not come to
> brunch.
>
> Modern Kerbals think this too! So rude!
>
> But! We Kerbals now have rockets and electricty and computers that let us do
> more than spell out funny words in math class. I believe that we should commit
> ourselves to achieving the goal, before we get bored and do something else, of
> landing some Kerbals on the Mun and make friends up close. No single space
> project will be more likely to impress on the Mun how rude it's been or how,
> really, there's no hard feelings and we just want to drink some coffee and
> talk about stuff.
>
> My fellow Kerbals, has anyone heard the Mun actually decline an invitation?
> No? Perhaps it's just been really busy?

-- President John F. Kerman

## Welcome!

This repository contains source code and vessel assets for
[Kerbal Space Program](https://kerbalspaceprogram.com/) to explore the creation
of Project Apollo-style "pilot in the loop" control systems. The idea is to
program guidance computers and fly the rockets they're guiding without blowing
yourself up.

Please take a gander at [Design Philosophy](docs/Design-Philosophy.md) if "pilot in
the loop" sounds unfamiliar.

### Sign me up!

Well great!

First things first, this project has a Slack channel: https://imho.slack.com/
Please email brian@troutwine.us with your address and an invite'll come along
shortly.

You'll need a copy of Kerbal Space Program (KSP), in particular version 1.05.
(Other versions might work, but they've not beed tested.) Installing KSP should
be straightforward but ask for help if you need.

One that's installed, you'll need to find your game directory. This varies by
operating system and install method but the official wiki
[has the details](http://wiki.kerbalspaceprogram.com/wiki/Root_directory). From
this point forward, we're going to refer to your KSP root directory as `$KSP/`.

You will need a copy of [kOS](https://github.com/KSP-KOS/KOS), the flight
computer this project uses, version v0.18.2. Setting kOS up properly is a little
finicky but totally doable. Download and unzip the
[release package](https://github.com/KSP-KOS/KOS/releases) somewhere to your
disk. Move unzipped release to `$KSP/GameData/kOS`. If you do this while Kerbal
Space Program is running you'll need to restart it for the mod to show up.

To be sure we're all working from the same basic world, the folder `assets/IMHO`
contains the save-file we'll be using. This whole folder should be copied to
`$KSP/saves`. The folder `assets/scripts/` should be symlinked to
`$KSP/Ships/Script`. If everything went according to plan, you should see a save
game called IMHO to load when you start Kerbal Space Program.

With that, you're all setup!

### Let's get to Flying!
