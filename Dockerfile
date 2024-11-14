FROM openjdk:openjdk:24-jdk-slim

ENV BUILD_TOOLS="35.0.0"
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /

#=============================
# Install Dependencies and Clean Up
#=============================
SHELL ["/bin/bash", "-c"]   

RUN apt update && apt install -y \
    tzdata \
    curl \
    wget \
    unzip \
    bzip2 \
    libdrm-dev \
    libxkbcommon-dev \
    libgbm-dev \
    libnss3 \
    libpulse-dev \
    xauth \
    xvfb \
    libdbus-glib-1-2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#==============================
# Android SDK ARGS
#==============================
ARG ANDROID_CMD="commandlinetools-linux-11076708_latest.zip"
ARG BUILD_TOOL="build-tools;${BUILD_TOOLS}"
ARG ANDROID_SDK_PACKAGES="${BUILD_TOOL} platform-tools emulator"

#==============================
# Set Environment Variables
#==============================
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH "$PATH:$ANDROID_HOME/cmdline-tools/tools:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/${BUILD_TOOLS}"
ENV DOCKER="true"

#=========================
# Copying Scripts to /tmp
#=========================
COPY install-android-cmd-tools.sh /tmp/
COPY install-sdk-packages.sh /tmp/

RUN chmod a+x /tmp/install-android-cmd-tools.sh && \
    chmod a+x /tmp/install-sdk-packages.sh

#====================================
# Run Scripts
#====================================
RUN /tmp/install-android-cmd-tools.sh --ANDROID_HOME $ANDROID_HOME --ANDROID_CMD $ANDROID_CMD && \
    /tmp/install-sdk-packages.sh --ANDROID_SDK_PACKAGES $ANDROID_SDK_PACKAGES

#====================================
# Clean up the scripts
#====================================
RUN rm -f /tmp/install-android-cmd-tools.sh /tmp/install-sdk-packages.sh

CMD [ "/bin/bash" ]
