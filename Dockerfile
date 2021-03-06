FROM ruby:2.1
MAINTAINER Micheal Waltz <ecliptik@gmail.com>

#Setup environment and copy contents
WORKDIR /app
COPY [ "/", "/app" ]

#Install gems
RUN [ "bundle", "install", "--standalone" ]

#Set timezone to US/Pacific
RUN [ "cp", "/usr/share/zoneinfo/US/Pacific", "/etc/localtime" ]

#Run ruby script
ENTRYPOINT [ "ruby", "/app/coffee-and-pie.rb" ]
