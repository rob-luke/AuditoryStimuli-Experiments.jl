# Auditory Experiments

#### Work in progress. Not stable

## Instructions

Each experiment is contained in a directory. Each experiment contains a Project.toml file to allow precise reproduction of the experimental setup and behaviour.

Each experiment will output results as a csv file in the directory it is run. And may also output a log file or summary result.

Experiments use a basic terminal graphical interface to guide the participant.

## Experiments

#### Three Alternative Forced Choice Theshold Task (Threshold-3AFC)

In this experiment listeners are presented with trials consisting of three intervals.
One interval will contain a noise stimulus, the other two will contain only silence.
The interval which contains the noise will be randomised in each trial.
The listener is asked to identify the interval which contained the noise stimulus.
The level of the presented stimulus in each trial will be adaptively varied using a 2 down 1 up procedure to estimate the perceptual threshold.

To execute this experiment run `julia --project=. threshold-3afc.jl` from the experiment subdirectory.

#### Two Alternative Forced Choice Lateralisation Task (Lateralisation-2AFC)

This experiment...

To execute this experiment run `julia --project=. lateralisarion-2afc.jl` from the experiment subdirectory.

