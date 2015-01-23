require 'celluloid/autostart'
require 'riak'
require 'json'
require 'awesome_print'
require_relative './config'

client = Riak::Client.new
bucket = client.bucket('messages')

obj = Riak::RObject.new(bucket, 'pink_floyd')
obj.content_type = 'text/plain'
obj.raw_data = 'The dark side of the moon'
obj.store

# bucket.keys
bucket.get('pink_floyd')
bucket.delete('pink_floyd')

#byebug






class Message
  attr_reader :id

  def initialize(id, recipient, content)
    @id = id
    @recipient = recipient
    @content = content
  end

  def to_json
    { 'id_i' => @id,
      'recipient_s' => @recipient,
      'content_s' => @content }
  end
end

message = Message.new('108', 'leandro', 'does this clock work?')



riak_msg_obj = bucket.get_or_new(message.id)
riak_msg_obj.data = message.to_json
riak_msg_obj.store

bucket.get('108')

#byebug



index = client.create_search_index('nice_index')
# riak-admin security grant search.admin on index to all
# riak-admin security grant search.query on index to all

bucket.properties = {'search_index' => 'nice_index'}

riak_msg_obj.store

result = client.search('nice_index', 'content_s:*clock*')

a = bucket.get( result['docs'].first["_yz_rk"] ).data

byebug





class Draft
  attr_reader :id

  def initialize(id, author, content)
    @id = id
    @author = author
    @content = content
  end

  def to_json
    { 'id_s' => @id,
      'author_s' => @author,
      'content_s' => @content }
  end
end

drafts_bucket = client.bucket('drafts')
drafts_bucket.properties = {'search_index' => 'nice_index'}

draft = Draft.new('draft_key_abcde', 'Tim Rogers', 'What we might mean when we say a clock is wrong')
d = drafts_bucket.get_or_new(draft.id)
d.data = draft.to_json
d.store

result = client.search('nice_index', 'content_s:*clock*')

byebug # Yep, we did not include byebug in the Gemfile, we're using pry-rescue

# riak-admin bucket-type create text '{"props":{}}'
# riak-admin bucket-type activate text
# curl -XPUT http://localhost:8098/types/text/buckets/messages/props -H 'Content-Type: application/json' -d '{"props":{"search_index":"nice_index"}}'

