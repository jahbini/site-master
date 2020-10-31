FROM mhart/alpine-node:12
MAINTAINER jim@bamboocando.com

RUN mkdir /site-master && apk update
RUN apk add curl python git make
RUN yarn global add gulp-cli

WORKDIR /site-master
ADD . /site-master
RUN node -v
RUN yarn install || yarn audit

#RUN curl -LOu jahbini:Tqbfj0tlD https://github.com/jahbini/Stagserv/archive/mas
RUN ls -lisa

expose 3030
CMD yarn run gitget; gulp bamboosnowAppJs  | sleep 5000

