# Populate the graph with some random points

require 'json'

TOKEN=ENV['SLACK_TOKEN']

class A
  def change_status(uid, presence)
    user = @users.find { |u| u["id"] == uid }
    unless user
      user = @slack.user
      @user[uid] = user
    end
    name = user["profile"]["real_name"]
    status = user["profile"]["status_text"]
    img = user["profile"]["image_512"] || user["profile"]["image_original"]
    send_event(uid, {name: name, slackStatus: status, text: "", img: img, presence: presence == "active"})
  end

  def start
    @slack = Slack.new(TOKEN)
    @users = @slack.users
    @users.each { |user|  change_status(user["id"], user["presence"]) }
    rtm = Rtm.new(@slack.rtm_start)
    rtm.on :presence_change do |m|
      change_status(m["user"], m["presence"]) if m["user"]
      unless m["users"].nil?
        m["users"].each { |uid| change_status(uid, m["presence"]) }
      end
    end
    rtm.start
  end
end

A.new.start
