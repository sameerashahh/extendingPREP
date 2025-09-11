versiondir="$rootdir/codeflaws" #directory where the codeflaws.tar.gz is extracted
filename="$rootdir/codeflaws-defect-detail-info.txt" #should be a copy of the codeflaws-defect-detail-info.txt, or select several defects from codeflaws-defect-detail-info.txt
prepdir="$rootdir/xform" #directory where prep transforms are

#egrep -w "$version" $filename >> new_run1
list=$(cut -d$'\t' -f1 $filename)

# 611-A-bug-16019969-16020019

while read -r line; do
if [[ "$line" == *"-bug-"* ]]; then 
  version=$line
  if ! grep -q "$version" $rootdir/versions-ignored-all.txt; then    
    var=$((var+1))
    #get buggy filename from directory name:
    contestnum=$(echo $version | cut -d$'-' -f1) #611
    probnum=$(echo $version | cut -d$'-' -f2) #A
    buggyfile=$(echo $version | cut -d$'-' -f4) #16019969
    cfile=$(echo "$contestnum-$probnum-$buggyfile".c)
    # check if files exist. if they exist then we have to move the file over 
    # to the normal directory.
    # add the file to a new run1 file to make a count of which files we need to use.
    prep_cfile="t-$cfile"
    PREPDIRECTORY="$prepdir/$version"
    if [ -d "$PREPDIRECTORY" ]; then
      if [ -e "$PREPDIRECTORY/$prep_cfile" ];
        
    fi 
    cilfile=$(echo "$contestnum-$probnum-$buggyfile".cil.c)
    cfixfile=$(echo "$contestnum-$probnum-$buggyfile"-fix.c)
    echo "Running on version:$version";


    DIRECTORY="$versiondir/$version"
    if [ ! -d "$DIRECTORY" ]; then
      echo "FOLDER DOESNT EXIST: $version"
    fi 
  else
    echo "IGNORING:$version"  
  fi
fi
done <<< "$list"