require 'httmultiparty'
#require 'faye/websocket'

class Slack
  include HTTMultiParty
  base_uri 'https://slack.com/api'

  def initialize(token)
    @token = token
  end

  def rtm_start
    self.class.post("/rtm.start", body: { token: @token })
  end

  ## get a channel, group, im or user list
  def get_objects(method, key, params = {})
    self.class.get("/#{method}", query: { token: @token }.merge(params)).tap do |response|
      raise "error retrieving #{key} from #{method}: #{response.fetch('error', 'unknown error')}" unless response['ok']
    end.fetch(key)
  end

  def users
    get_objects('users.list', 'members', presence: false)
  end

  def user(id)
    get_objects('users.info', 'user', user: id)
  end

  def get_presence(id)
    get_objects('users.getPresence', 'presence', user: id)
  end
end
