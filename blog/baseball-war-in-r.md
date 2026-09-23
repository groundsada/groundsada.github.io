---
title: "Baseball WAR in R: the forever project"
date: 2024-04-25
excerpt: A half-finished Wins Above Replacement calculator in R, in at least three branches, is the project I keep coming back to. Here's what it keeps teaching me.
---

# Baseball WAR in R: the forever project

Some people have a novel in a drawer. I have a half-finished Wins Above Replacement calculator in R, in at least three branches, dating back to 2024. It's public: [Baseball-WAR-in-R](https://github.com/groundsada/Baseball-WAR-in-R).

WAR is the stat that asks a good question: how many wins did this player add compared to a replacement-level player? It folds batting runs, baserunning, fielding, and pitching into one number. It's also a swamp of research questions. Park factors, positional adjustments, era adjustments, fielding metrics that are hard to measure well. For a systems person it has the same shape as a production problem: a pile of noisy measurements, a model that's defensible but not perfect, and a number that someone will dispute.

Every rewrite has taught me something that later paid off at work:

- Missing values are the enemy. Half the play-by-play data I wanted wasn't in the file. Learning to trace where data disappears is the same skill as debugging a stalled transfer.
- Measure twice, commit once. My functions gained tests not because I'm disciplined but because a rolling-window bug burned me once and I didn't want a second time.
- A model is a story you tell with evidence. A WAR estimate is only as good as its assumptions, so state them.

It's a forever project because nobody is waiting on it. No deadlines, no reviewer, no ticket. I get to write R at my own pace and argue with myself about whether a particular fielding adjustment is reasonable.

One day it'll be a finished notebook. Then I'll think of a better position adjustment, and start over. That's what it's for.
