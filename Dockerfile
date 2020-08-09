FROM micahkemp/alpine-curl:1.0.0

ARG SPLUNK_VERSION
ARG SPLUNK_BUILD
ARG SPLUNK_TGZ_URL=https://download.splunk.com/products/splunk/releases/$SPLUNK_VERSION/linux/splunk-$SPLUNK_VERSION-$SPLUNK_BUILD-Linux-x86_64.tgz

ARG SPLUNK_OS_USER=splunk
ARG SPLUNK_HOME=/opt/splunk

RUN adduser -h $SPLUNK_HOME -D $SPLUNK_OS_USER

USER $SPLUNK_OS_USER
RUN curl $SPLUNK_TGZ_URL | tar xz -C $SPLUNK_HOME/..

## always be optimistic about file locking, as this image may be run on OS X
## never run these images for anything important, only for cicd testing!!
RUN echo OPTIMISTIC_ABOUT_FILE_LOCKING=1 >> $SPLUNK_HOME/etc/splunk-launch.conf

# prepare for run
WORKDIR $SPLUNK_HOME
## splunk does *not* start when the image is run
## this is intentional so cicd can run "splunk start" and know when it's completed
CMD /bin/bash -c "while true; do sleep 10000; done"
