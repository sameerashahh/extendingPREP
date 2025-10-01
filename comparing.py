# compare_files.py
with open("prepfiles.txt") as f1, open("original.txt") as f2:
    names1 = set(line.strip() for line in f1)
    names2 = set(line.strip() for line in f2)

only_in_file2 = names2 - names1

with open("differences.txt", "w") as out:    
    for name in sorted(only_in_file2):
        out.write(name + "\n")
