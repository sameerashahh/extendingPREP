with open("prepfiles.txt") as f1, open("original.txt") as f2:
    names1 = set(line.strip() for line in f1)
    names2 = set(line.strip() for line in f2)

prep_transforms_missing = names2-names1

with open("differences.txt", "w") as out:    
    for name in sorted(prep_transforms_missing):
        out.write(name + "\n")
