#!/bin/bash

#============================================
# Install required package using SDK manager
#============================================

# Exit if any command fails
set -e

#============================================
# Check if ANDROID_SDK_PACKAGES is set
#============================================
if [ -z "$ANDROID_SDK_PACKAGES" ]; then
    echo "Error: ANDROID_SDK_PACKAGES is not set."
    exit 1
fi

#============================================
# Install required packages using SDK manager
#============================================

# Automatically accept all Android SDK licenses
echo "Accepting Android SDK licenses..."
yes | sdkmanager --licenses

# Installing the required SDK packages
echo "Installing SDK packages: $ANDROID_SDK_PACKAGES"
yes | sdkmanager --verbose --no_https $ANDROID_SDK_PACKAGES 2>&1 | tee sdk_install.log

# Check if sdkmanager ran successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to install Android SDK packages."
    exit 1
fi

# Clean up SDK manager cache
echo "Cleaning up SDK manager files..."
sdkmanager --update
rm -rf /tmp/*  

echo "Android SDK packages installed successfully."