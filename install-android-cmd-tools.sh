#!/bin/bash

#============================================
# Install required Android cmdline-tools tools
#============================================


# Exit the script if any command fails
set -e

# Check if ANDROID_CMD is set
if [ -z "$ANDROID_CMD" ]; then
    echo "Error: ANDROID_CMD variable is not set."
    exit 1
fi

# Download the Android command-line tools
echo "Downloading Android command-line tools..."
wget https://dl.google.com/android/repository/${ANDROID_CMD} -O /tmp/${ANDROID_CMD}

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download ${ANDROID_CMD}"
    exit 1
fi

# Unzip the downloaded file into the ANDROID_HOME directory
echo "Unzipping Android command-line tools..."
unzip -q /tmp/${ANDROID_CMD} -d ${ANDROID_HOME}

# Check if unzip was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to unzip ${ANDROID_CMD}"
    exit 1
fi

# Remove the downloaded zip file to clean up
echo "Cleaning up..."
rm /tmp/${ANDROID_CMD}

# Move extracted files into correct directory structure
echo "Rearranging extracted files..."
mkdir -p $ANDROID_HOME/cmdline-tools/tools
cd $ANDROID_HOME/cmdline-tools
mv NOTICE.txt source.properties bin lib tools/

# Verify the tools directory is set up correctly
echo "Verifying installation..."
ls $ANDROID_HOME/cmdline-tools/tools/

echo "Android command-line tools installed successfully."
