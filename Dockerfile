FROM node:9.11.1-alpine
ENV NODE_ENV production
RUN apk update && \
    apk add ffmpeg ffmpeg-dev ghostscript ghostscript-dev make cmake g++ gcc boost boost-dev libmad libmad-dev gd gd-dev libgd libid3tag libid3tag-dev libsndfile libsndfile-dev && \
    rm -Rf /var/cache/apk/* /var/lib/apk/* /etc/apk/cache/*
COPY audiowaveform /audiowaveform
RUN mkdir -p /audiowaveform/build
WORKDIR /audiowaveform/build
RUN cmake -D ENABLE_TESTS=0 .. && make && make install
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY spacedeck-open/package.json /usr/src/app/
RUN npm install
RUN npm install -g --save-dev gulp
RUN npm install gulp-rev-replace gulp-clean gulp-fingerprint gulp-rev gulp-rev-all


COPY spacedeck-open/app.js Dockerfile spacedeck-open/Gulpfile.js spacedeck-open/LICENSE /usr/src/app/
COPY spacedeck-open/config /usr/src/app/config
COPY spacedeck-open/helpers /usr/src/app/helpers
COPY spacedeck-open/locales /usr/src/app/locales
COPY spacedeck-open/middlewares /usr/src/app/middlewares
COPY spacedeck-open/models /usr/src/app/models
COPY spacedeck-open/public /usr/src/app/public
COPY spacedeck-open/routes /usr/src/app/routes
COPY spacedeck-open/styles /usr/src/app/styles
COPY spacedeck-open/views /usr/src/app/views

RUN /usr/local/bin/gulp all
RUN npm cache clean

CMD [ "node", "app.js" ]

EXPOSE 9666

