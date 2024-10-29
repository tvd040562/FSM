TECHLIB ?= "../Fault/Tech/osu035/osu035_stdcells.lib"
TECHCELL ?= "../Fault/Tech/osu035/osu035_stdcells.v"
DESIGN ?= fsm
all:
	fault synth -t $(DESIGN) -l $(TECHLIB) -o Netlists/$(DESIGN).nl.v $(DESIGN).v
	fault cut Netlists/$(DESIGN).nl.v --clock clk --reset rstb --activeLow --bypassing VDD=1 --bypassing GND=0
	fault -c $(TECHCELL) -v 100 -r 50 -m 95 --ceiling 1000 Netlists/$(DESIGN).cut.v --clock clk --reset rstb --activeLow --bypassing VDD=1 --bypassing GND=0
	nl2bench -o Netlists/$(DESIGN).bench -l $(TECHLIB) Netlists/$(DESIGN).cut.v
	fault atpg -g Quaigh -c $(TECHCELL) -b Netlists/$(DESIGN).bench Netlists/$(DESIGN).cut.v --clock clk --reset rstb --activeLow --bypassing VDD=1 --bypassing GND=0
	fault chain --clock clk --reset rstb --activeLow --bypassing VDD=1 --bypassing GND=0 -l $(TECHLIB) -c $(TECHCELL) Netlists/$(DESIGN).nl.v
	fault tap --clock clk --reset rstb --activeLow --bypassing VDD --bypassing GND -l $(TECHLIB) -c $(TECHCELL) Netlists/$(DESIGN).chained.v
