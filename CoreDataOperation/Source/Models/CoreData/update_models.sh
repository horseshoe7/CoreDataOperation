#!/bin/sh

#  update_models.sh
#  Songbook
#
#  Created by Stephen O'Connor on 31/01/15.
#  Copyright (c) 2015 Stephen O'Connor. All rights reserved.
# Script to Update your CoreData models using mogenerator.
# It may be that you need to update the script on your filesystem to be executable
# chmod 755 update_models.sh
# This script needs to be run in the same folder as mogenerator, and should also contain your .xcdatamodeld file.
# Now you could be pedantic and say 'my mogenerator is in /usr/bin' but I like to include it here to be explicit
# and to guarantee you don't have to ensure a supported version or that you've already installed it.
# Here, it just works.
echo "Updating CoreData models with mogenerator..."
#
#
# Script variables
#
PROJECT_NAME=CoreDataOperation
#
#
CD_PATH=${SRCROOT}/${PROJECT_NAME}/Source/Models/CoreData
MODEL_NAME=${PROJECT_NAME}
#
# Update this as you add migrations.  We assume you just Standard Xcode version name incrementing
MODEL_VERSION=1

if [ "${MODEL_VERSION}" -eq 1 ]; then
    echo "Building $MODEL_NAME"
    ${CD_PATH}/mogenerator --v2 --model=${CD_PATH}/${MODEL_NAME}.xcdatamodeld/${MODEL_NAME}.xcdatamodel/ --machine-dir=${CD_PATH}/_generated --human-dir=${CD_PATH}/.

else
    echo "Building $MODEL_NAME $MODEL_VERSION"
    ${CD_PATH}/mogenerator --v2 --model=${CD_PATH}/${MODEL_NAME}.xcdatamodeld/${MODEL_NAME}\ ${MODEL_VERSION}.xcdatamodel/ --machine-dir=${CD_PATH}/_generated --human-dir=${CD_PATH}/.
fi