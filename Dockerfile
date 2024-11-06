FROM amd64/openjdk:24-jdk-slim

ENV DEBIAN_FRONTEND noninteractive

# Set working directory
WORKDIR /

#=============================
# Install Dependencies
#=============================
SHELL ["/bin/bash", "-c"]

RUN apt update && apt install --no-install-recommends -y \
    tzdata curl sudo wget unzip bzip2 libdrm-dev libxkbcommon-dev \
    libgbm-dev libasound-dev libnss3 libxcursor1 libpulse-dev \
    libxshmfence-dev xauth xvfb x11vnc fluxbox wmctrl libdbus-glib-1-2 \
    iputils-ping net-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#==============================
# Android SDK ARGS
#==============================
ARG BUILD_TOOLS="35.0.0"
ARG ANDROID_CMD="commandlinetools-linux-11076708_latest.zip"
ARG BUILD_TOOL="build-tools;${BUILD_TOOLS}"
ARG ANDROID_SDK_PACKAGES="${BUILD_TOOL} platform-tools emulator"

#==============================
# Set Environment Variables
#==============================
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH "$PATH:$ANDROID_HOME/cmdline-tools/tools:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/${BUILD_TOOLS}"
ENV DOCKER="true"

#=========================
# Copy Scripts to root
#=========================
COPY . /

#=========================
# Set Executable Permissions
#=========================
RUN chmod a+x install-android-cmd-tools.sh && \
    chmod a+x install-sdk-packages.sh

#====================================
# Run Scripts
#====================================
RUN ./install-android-cmd-tools.sh \
    --ANDROID_HOME $ANDROID_HOME \
    --ANDROID_CMD $ANDROID_CMD && \
    ./install-sdk-packages.sh \
    --ANDROID_SDK_PACKAGES $ANDROID_SDK_PACKAGES

CMD [ "/bin/bash" ]
