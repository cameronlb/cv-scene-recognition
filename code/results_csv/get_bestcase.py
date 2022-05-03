import csv
import os

for f in os.listdir():
    if f.startswith("knn_best_tinyimages"):
        
        with open(f, "r") as csvfile:
            reader = csv.DictReader(csvfile)

            highest_k = 999
            highest_accuracy = 0
            for row in reader:
                if float(row["weightedmajorityvote mean accuracy"]) > highest_accuracy:
                    highest_accuracy = float(row["weightedmajorityvote mean accuracy"])
                    highest_k = row["k"]

        with open("best_tinyimages.csv", "a") as outf:
            outf.write("%s,%f,%s\n" % (os.path.splitext(f)[0].split("_")[-1], highest_accuracy, highest_k))