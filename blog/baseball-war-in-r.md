---
title: "Baseball WAR in R: the side project I keep coming back to"
date: 2024-04-25
excerpt: I've written half a Wins Above Replacement calculator in R more times than I can count. Why sabermetrics is my forever project — and what it taught me about real data work.
---

# Baseball WAR in R: the side project I keep coming back to

Some people have a novel in a drawer. I have a half-finished Wins Above Replacement (WAR) calculator in R, in at least three branches, dating back to 2024. [It's public.](https://github.com/groundsada/Baseball-WAR-in-R) I refuse to apologize.

## Why WAR

WAR is the stat that asks the best possible question in sports analytics: *how many wins did this player add compared to a replacement-level player?* It's the batting runs, baserunning, fielding, pitching — all folded into one number. It's also an absolute swamp of research questions: park factors, positional adjustments, era adjustments, fielding metrics you can't measure well. For a systems person, it's a toy with the same shape as a real production problem: **a bunch of noisy measurements, a model that is defensible but not perfect, and a number people will dispute forever.**

## What it keeps teaching me

Every rewrite taught me something that later paid off in science infrastructure:

- **Missing values are the enemy.** Half the play-by-play data I wanted simply wasn't in the file. Learning to trace where data disappears is the same skill as debugging why a transfer stalled.
- **Measure twice, commit once.** My functions gained tests not because I'm disciplined, but because I got burned by one bad rolling-window calculation.
- **The model is a story you tell with evidence.** A WAR estimate is only as good as its assumptions — state them, or someone will (rightly) catch you.

## Why it's a forever project

Because, unlike everything at work, nobody is waiting on it. It's the rare hobby with a hard craft and zero deadlines. I get to write R at my own pace, drifting between datasets and arguing with myself about whether a particular fielder adjustment is reasonable.

One day it'll be a finished notebook, and then — and I know exactly what will happen — I'll think of a better position adjustment and start over. That's the point.

*If you also keep a "one day" data project: I see you. The repo is open-sourced, so if you find a cleaner way to do fielding runs, the branch is yours.*
