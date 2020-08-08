FROM ubuntu:20.04

ARG SPLUNK_VERSION
ARG SPLUNK_VERSION_IDENTIFIER
ARG SPLUNK_TGZ_URL=https://download.splunk.com/products/splunk/releases/$SPLUNK_VERSION/linux/splunk-$SPLUNK_VERSION-$SPLUNK_VERSION_IDENTIFIER-Linux-x86_64.tgz
ARG SPLUNK_ADMIN_USERNAME=admin
ARG SPLUNK_ADMIN_PASSWORD=changeme

ARG SPLUNK_OS_USER=splunk
ARG SPLUNK_HOME=/opt/splunk
# any value other than 0 is considered "true"
ARG NEEDS_USER_SEED=1

RUN apt-get update
RUN apt-get install
RUN apt-get install -y --no-install-recommends curl ca-certificates
RUN useradd -d $SPLUNK_HOME -m $SPLUNK_OS_USER

USER $SPLUNK_OS_USER
RUN curl $SPLUNK_TGZ_URL | tar xz -C $SPLUNK_HOME/..

# prepare to start
## place user-seed.conf if configured to do so
RUN if [ NEEDS_USER_SEED != 0 ]; then echo "[user_info]\nUSERNAME = admin\nPASSWORD = $SPLUNK_ADMIN_PASSWORD\n" > $SPLUNK_HOME/etc/system/local/user-seed.conf; fi

## always be optimistic about file locking, as this image may be run on OS X
## never run these images for anything important, only for cicd testing!!
RUN echo OPTIMISTIC_ABOUT_FILE_LOCKING=1 >> $SPLUNK_HOME/etc/splunk-launch.conf

# prepare for run
WORKDIR $SPLUNK_HOME
## splunk does *not* start when the image is run
## this is intentional so cicd can run "splunk start" and know when it's completed
CMD /bin/bash -c "while true; do sleep 10000; done"
