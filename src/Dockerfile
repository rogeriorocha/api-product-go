FROM docker.io/golang:alpine
RUN mkdir /app
WORKDIR /app
ADD . .
RUN go get
EXPOSE 8080
ENTRYPOINT go run .

#FROM golang:1.17 AS build
#RUN mkdir /app
#WORKDIR /app
#RUN apt update && apt install ca-certificates libgnutls30 -y
#ADD . .
#RUN go get 
#RUN go build -o main
# or FROM golang:alpine or some other base depending on need
#FROM alpine:latest AS runtime
#FROM golang:alpine 
#this seems dumb, but the libc from the build stage is not the same as the alpine libc
#create a symlink to where it expects it since they are compatable. https://stackoverflow.com/a/35613430/3105368
#RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
#WORKDIR /app
#COPY --from=build /app/main /app
#ENTRYPOINT GIN_MODE=release && /app/main