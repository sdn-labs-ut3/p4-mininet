# p4-mininet
P4 Mininet environment based on [p4lang/tutorials](https://github.com/p4lang/tutorials) utils with minor updates:

* Add ModifyTableEntry, ReadDirectCounters, StreamMessageIn and WriteDigestEntry methods in `p4runtime_lib/switch.py`
* Add CPU port, log level and priority-queues when starting P4RuntimeSwitch in `p4runtime_switch.py`
* Add log level argument and print Thrift port in `run_exercise.py`
* Rename `run_exercise.py` to `run.py`
* Update Makefile
