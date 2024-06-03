BUILD_DIR = build
PCAP_DIR = pcaps
LOG_DIR = logs

P4C = p4c-bm2-ss
P4C_ARGS += --p4runtime-files $(basename $@).p4.p4info.txt

# Define the path of this P4 Mininet dir (TO UPDATE ACCORDING TO YOUR SETTINGS)
ifndef P4_MININET
P4_MININET = ~/p4-mininet
endif

# The main run script
RUN_SCRIPT = $(P4_MININET)/run.py

# Define the program to build
ifndef DEFAULT_PROG
DEFAULT_PROG = $(wildcard *.p4)
endif
P4_SRC = $(notdir $(DEFAULT_PROG))
SRC_DIR = $(dir $(DEFAULT_PROG))
COMPILED_JSON = $(P4_SRC:.p4=.json)

# Define the program to load in the switch (a JSON file in the case of BMv2)
ifndef NO_P4
run_args += -j $(BUILD_DIR)/$(COMPILED_JSON)
endif

# Define the path to behavioral executable
ifdef BMV2_SWITCH_EXE
run_args += -b $(BMV2_SWITCH_EXE)
endif

# Define the mininet topology 
ifndef TOPO
TOPO = topology.json
endif
run_args += -t $(TOPO)

# Define the log level
ifdef LOG_LEVEL
run_args += -L $(LOG_LEVEL)
endif

# Define the priority queues
ifdef PRIO_QUEUES
run_args += -PQ $(PRIO_QUEUES)
endif

all: run

run: build
	sudo -E python3 $(RUN_SCRIPT) $(run_args)

stop:
	sudo mn -c

build: dirs $(BUILD_DIR)/$(COMPILED_JSON)

$(BUILD_DIR)/%.json: $(SRC_DIR)/%.p4
	$(P4C) --p4v 16 $(P4C_ARGS) -o $@ $<

dirs:
	mkdir -p $(BUILD_DIR) $(PCAP_DIR) $(LOG_DIR)

clean: stop
	rm -f *.pcap
	rm -rf $(BUILD_DIR) $(PCAP_DIR) $(LOG_DIR)
