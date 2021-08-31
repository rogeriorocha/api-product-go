FROM docker.io/golang:alpine
#FROM golang

RUN mkdir /app

WORKDIR /app
#
#ADD go.mod .
#ADD go.sum .

#RUN go mod download
ADD . .
RUN go get

# debug
#ENV GOTRACEBACK=all
#ARG SKAFFOLD_GO_GCFLAGS

#RUN go get github.com/githubnemo/CompileDaemon
EXPOSE 8080
#ENTRYPOINT CompileDaemon --build="go build main.go" --command=./main
ENTRYPOINT go run .

