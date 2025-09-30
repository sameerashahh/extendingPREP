#!/bin/bash

DOCKER_CMD="docker run --rm --memory=30g -v /mnt/ResearchData/srshah25/prep-run:/opt/codeflaws/genprog-run prep"

splits=(split1 split2 split3 split4 split5)

for split in "${splits[@]}"; do
  $DOCKER_CMD bash -c "cp /opt/codeflaws/$split /opt/codeflaws/run1 && /opt/codeflaws/run-version-genprog.sh" &
done

echo "Started all containers in background"
