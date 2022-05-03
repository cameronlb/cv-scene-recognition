"""Little script to help generate metrics statistics...
not very expandable, will need to change matlab binary paths
etc. Must be in same directory as script.

Changes the only argument of the metrics() matlab function
in a given range. Parses the output for doubles and writes 
them to a file.

Its only regexes so watch out if matlab prints out more than
two doubles
"""

import subprocess
import sys
import re

distance_metric = sys.argv[1]

for k in range(1, 100):
    cmd = ['/home/eden/.local/share/applications/bin/matlab', '-nodisplay', '-nosplash', '-nodesktop', '-batch', 'metrics(%d, "%s")' % (k, distance_metric)]
    print(" ".join(cmd))
    proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
    output = ""
    while True:
        line = proc.stdout.readline()
        if not line:
            break
        output += line.decode()
        print(line.decode().rstrip())

    double_outs = re.findall(r"\d+\.\d+", output)
    double_outs.insert(0, k)
    o = ",".join([str(i) for i in double_outs])

    print(o)
    with open("results_csv/knn_best_tinyimages_%s.csv" % distance_metric, "a") as f:
        f.write(o + "\n")
