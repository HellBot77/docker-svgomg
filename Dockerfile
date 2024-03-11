FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/jakearchibald/svgomg.git && \
    cd svgomg && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine as build

WORKDIR /svgomg
COPY --from=base /git/svgomg .
RUN npm install && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /svgomg/build .
