***1. Fixing ```remote port forwarding failed``` warning***
---
If you use ```rmate``` for editing files on the HPC but get this warning sometimes when logging into the HPC:

```Warning: remote port forwarding failed for listen port 52698```

and your last log-out from the HPC was by an unintended ```broken pipe```, then it is very likely that this port forwarding failure is due to your remote server not having closed the port for previous ssh session.

**hma02** found a solution to this issue in [rmate issue#48 on github](https://github.com/textmate/rmate/issues/48).

Basically, use ```ps -u <username>``` to list the active processes and find the PIDs of processes with CMD listed as ```sshd```. Then, kill the process by ```kill <PID>```. You might kill your current process, in which case you will need to log back in again, so make sure you kill the right PIDs (usually the smaller ones, and leave the largest PID with ```sshd```).
