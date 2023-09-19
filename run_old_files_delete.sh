#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# -----------------------------------------------------------------------------
# Copyright (C) Business Learning Incorporated (businesslearninginc.com)
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License at
# <http://www.gnu.org/licenses/> for more details.
#
# -----------------------------------------------------------------------------
#
# A bash script front-end to call old_files_delete.sh
#
# requirements:
#  --access to old_files_delete.sh
#
# inputs:
#  --None (runs with no inputs)
#
# outputs:
#  --None (side effect is the completion of the called script)
#

#!/bin/bash

# Set the directory path to check for files
DIR="/var/log/suricata"

# Get the current timestamp
NOW=$(date +%s)

# Loop through all files in the directory
for FILE in "$DIR"/*
do
  # Check if the file is older than 6 hours
  if [ -f "$FILE" ] && [ $(($NOW - $(stat -c %Y "$FILE"))) -gt 21600 ]
  then
    # Remove the file
    rm "$FILE"
    echo "Removed file: $FILE"
  fi
done
