FROM ubuntu:20.04

ARG SPLUNK_VERSION
ARG SPLUNK_BUILD
ARG SPLUNK_ADMIN_USERNAME
ARG SPLUNK_ADMIN_PASSWORD
ARG SPLUNK_TGZ_URL=https://download.splunk.com/products/splunk/releases/$SPLUNK_VERSION/linux/splunk-$SPLUNK_VERSION-$SPLUNK_BUILD-Linux-x86_64.tgz

ARG SPLUNK_OS_USER=splunk
ARG SPLUNK_HOME=/opt/splunk

RUN apt-get update
RUN apt-get install
RUN apt-get install -y --no-install-recommends curl ca-certificates
RUN useradd -d $SPLUNK_HOME -m $SPLUNK_OS_USER

USER $SPLUNK_OS_USER
RUN curl $SPLUNK_TGZ_URL | tar xz -C $SPLUNK_HOME/..

# prepare to start
RUN echo "[user_info]\nUSERNAME = $SPLUNK_ADMIN_USERNAME\nPASSWORD = $SPLUNK_ADMIN_PASSWORD\n" > $SPLUNK_HOME/etc/system/local/user-seed.conf

## always be optimistic about file locking, as this image may be run on OS X
## never run these images for anything important, only for cicd testing!!
RUN echo OPTIMISTIC_ABOUT_FILE_LOCKING=1 >> $SPLUNK_HOME/etc/splunk-launch.conf

# prepare for run
WORKDIR $SPLUNK_HOME
## splunk does *not* start when the image is run
## this is intentional so cicd can run "splunk start" and know when it's completed
CMD /bin/bash -c "while true; do sleep 10000; done"
