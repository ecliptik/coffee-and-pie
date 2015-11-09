FROM ruby:2.1
MAINTAINER Micheal Waltz <ecliptik@gmail.com>

#Setup environment and copy contents
WORKDIR /app
COPY [ "/", "/app" ]
RUN [ "bundle", "install", "--standalone" ]

#Run event handler
ENTRYPOINT [ "ruby", "/app/coffee-and-pie.rb" ]
