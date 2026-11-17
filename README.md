# Wolf Sheep Predation with Shepherds

Wolves eat sheep, sheep eat grass, and three shepherds keep their flocks in pastures and guard them from wolves.

This model builds on version 2 (wolves, sheep and grass) of the predator-prey model of Wilensky and Reisman, as implemented in [Wolf Sheep Predation](https://github.com/cormas/wolf-sheep-predation-model). The rules of wolves, sheep and grass are the same. Shepherds, pastures and flocks are added on top of them, so the results differ from those of the paper.

It is the example of the Cormas documentation on looks, aspects and perspectives: the same world can be watched from several perspectives at once, in different windows.

## The model

- **The world** is a grid of 51 by 51 patches that wraps around. Grass grows on every patch, as in version 2.
- **Three pastures** of 17 by 17 patches lie in a triangle, with wild land around and between them.
- **Three shepherds**, one per pasture, walk at random within their pasture. They never die.
- **Sheep** belong to a shepherd's flock and live in its pasture: they move, graze and give birth only inside it. A lamb joins its mother's flock. Otherwise sheep follow the rules of version 2.
- **Wolves** roam the whole world and follow the rules of the paper, except that a wolf cannot eat a sheep within `guardingDistance` patches of a shepherd.

At each step, the shepherds move, then all sheep act in a random order, then all wolves, then the grass grows. The simulation stops when no animal is left.

The init method is `sheepWolvesShepherds`, and the control method is `stepSheepWolvesShepherds`.

## Parameters

The parameters of version 2 of Wolf Sheep Predation, with the same defaults, except:

- `wolfGainFromFood` is 40 instead of 20. The sheep live only in the pastures, a third of the world, so wolves find fewer of them. With 20, the wolves always die out within a few hundred steps.
- `guardingDistance` (default 1) is how far a shepherd keeps wolves from eating, in patches. At 0, shepherds guard nothing.
- The size of the world is fixed, since the pastures are at fixed places.

## Source

Wilensky, U. & Reisman, K. (2006). Thinking like a wolf, a sheep or a firefly: Learning biology through constructing and testing computational theories — an embodied modeling approach. *Cognition and Instruction*, 24(2), 171–209.

Where the paper says nothing, the model follows the [NetLogo Wolf Sheep Predation model](https://ccl.northwestern.edu/netlogo/models/WolfSheepPredation) (Wilensky, 1997), as Wolf Sheep Predation does. The shepherds, pastures and flocks are not in the paper or in NetLogo.
