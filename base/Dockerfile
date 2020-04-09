FROM ubuntu:18.10
MAINTAINER Abdullah Dagli

ENV METEORD_DIR /opt/meteord
COPY scripts $METEORD_DIR

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION:-12.16.1}
ONBUILD ENV NODE_VERSION ${NODE_VERSION:-12.16.1}

RUN bash $METEORD_DIR/lib/install_base.sh
RUN bash $METEORD_DIR/lib/install_node.sh
RUN bash $METEORD_DIR/lib/install_phantomjs.sh
RUN bash $METEORD_DIR/lib/cleanup.sh

RUN apt-get -y update && apt-get install -y ffmpeg

EXPOSE 80
RUN chmod +x $METEORD_DIR/run_app.sh
ENTRYPOINT exec $METEORD_DIR/run_app.sh
