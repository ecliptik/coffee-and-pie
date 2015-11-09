#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'hipchat'
require 'working_hours'

#Set working hours
WorkingHours::Config.working_hours = {
  :mon => {'09:00' => '12:00', '13:00' => '17:00'},
  :tue => {'09:00' => '12:00', '13:00' => '17:00'},
  :wed => {'09:00' => '12:00', '13:00' => '17:00'},
  :thu => {'09:00' => '12:00', '13:00' => '17:00'},
  :fri => {'09:00' => '12:00', '13:00' => '16:00'},
}

# Configure timezone (uses activesupport, defaults to UTC)
WorkingHours::Config.time_zone = "Pacific Time (US & Canada)"

# Configure holidays
WorkingHours::Config.holidays = [Date.new(2015, 11, 26),
                                 Date.new(2015, 11, 27),
                                 Date.new(2015, 12, 25),
                                 Date.new(2015, 12, 26),
                                 Date.new(2015, 12, 31),
                                 Date.new(2016, 1, 1)]

gifs = ["https://raw.githubusercontent.com/ecliptik/gifs/master/agent-cooper-coffee-01.gif",
        "https://raw.githubusercontent.com/ecliptik/gifs/master/agent-cooper-coffee-02.gif",
        "https://raw.githubusercontent.com/ecliptik/gifs/master/big-trouble-are-you-crazy.gif",
        "https://raw.githubusercontent.com/ecliptik/gifs/master/big-trouble-invincible.gif",
        "https://raw.githubusercontent.com/ecliptik/gifs/master/big-trouble-rub-the-wrong-way.gif",
        "https://raw.githubusercontent.com/ecliptik/gifs/master/dr-strangelove-chew-gum.gif",
        "https://raw.githubusercontent.com/ecliptik/gifs/master/dr-strangelove-slim-pickens.gif",
        "https://raw.githubusercontent.com/ecliptik/gifs/master/hackers-floppy-draw.gif"]

# send2hipchat function to emit a message to channel
# Accepts message and color string
def send2hipchat(message, color = "yellow")
  @message = message
  @color = color

  # Load in our config
  hipchat_config = YAML.load_file('hipchat_config.yml')

  # Setup our hipchat API connection
  puts ' [' + Time.now.strftime('%b %d %T.%2N') + "] Sending message #{@message} to hipchat channel #{hipchat_config['hipchat_room']}"
  hp = HipChat::Client.new(hipchat_config['hipchat_auth_token'],
                           api_version: 'v2',
                           server_url:  hipchat_config['hipchat_api_url'])

  hp[hipchat_config['hipchat_room']].send(hipchat_config['hipchat_message_from'],
                                          @message,
                                          color: @color,
                                          message_format: hipchat_config['hipchat_message_format'])
end

#Select a random amount of minutes between 3 and 8 days
def calcday()
  prng = Random.new
  return prng.rand(4320..11520)
end

begin
  puts '[' + Time.now.strftime('%b %d %T.%2N') + '] Starting up...'

  while true
    sleep_time = calcday
    future = sleep_time.minutes.from_now

    #Only setup message send time if within working hours
    if future.in_working_hours?
      puts ' Next message will send on ' + future.strftime('%A %B %d @ %I:%M%p')
      sleep(sleep_time.minutes)

      #Select random gif to send
      message = gifs.sample

      #Send message to hipchat
      #send2hipchat(message, color)
    end
  end

#What to do on CTRL-C
rescue Interrupt => _
  puts '[' + Time.now.strftime('%b %d %T.%2N') + '] Exiting...'
  exit(0)

end
