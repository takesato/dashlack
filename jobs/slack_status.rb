# Populate the graph with some random points

require 'json'

require 'dotenv/load'

Dotenv.load
p TOKEN=ENV['SLACK_TOKEN']

class A
  def change_status(uid, presence, force = false)
    user = @users.find { |u| u["id"] == uid }
    unless user
      user = @slack.user(uid)
      @users[uid] = user
    end
    name = user["profile"]["real_name"]
    status = user["profile"]["status_text"]
    img = user["profile"]["image_512"] || user["profile"]["image_original"]
    p "#{Time.now.to_strftime('%Y/%m/%d %H:%i:%s')} #{uid} #{name} #{presence}"
    send_event(uid, {name: name, slackStatus: status, text: "", img: img, presence: presence == "active"})
  end

  def start
    @slack = Slack.new(TOKEN)
    @users = @slack.users
    rtm = Rtm.new(@slack.rtm_start)
    rtm.on :presence_change do |m|
      change_status(m["user"], m["presence"]) if m["user"]
      unless m["users"].nil?
        m["users"].each { |uid| change_status(uid, m["presence"]) }
      end
    end
    rtm.start
    puts "start!!!"
  end
end

SCHEDULER.in '1m' do
  @slack = Slack.new(TOKEN)
  @slack.users.each do |user|
    uid = user["id"]
    begin
      sleep 1
      presence = @slack.get_presence(uid)
      name = user["profile"]["real_name"]
      status = user["profile"]["status_text"]
      img = user["profile"]["image_512"] || user["profile"]["image_original"]
      puts "#{uid} #{name} #{presence}"
      send_event(uid, {name: name, slackStatus: status, text: "", img: img, presence: presence == "active"})
    rescue
    end
  end
end

A.new.start
