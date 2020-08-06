#!/usr/bin/env ruby

require "sinatra"
require "openssl"
require "base64"

MEMBERS = [
  {
    id: "00001",
    hidden: true,
    name: "Number One",
    address: "libctf{malleability_will_break_your_crypto}",
    phone: "1800 160 401 "
  },
  {
    id: "00029",
    hidden: false,
    name: "Charles Montgomery Burns",
    address: "1000 Mammon Lane",
    phone: "0491 570 159"
  },
  {
    id: "00012",
    hidden: false,
    name: "Lenny Leonard",
    address: "Next Door to Springfield Stamp Museum",
    phone: "0491 570 156"
  },
  {
    id: "00908",
    hidden: false,
    name: "Homer Simpson",
    address: "742 Evergreen Terrace",
    phone: "0491 570 110"
  },
]

configure do
  enable :inline_templates
end

helpers do
  include ERB::Util
end

set :environment, :production

KEY = ["ace292133bb6b3ace0160309ace00ace"].pack("H*")

def encrypt(plaintext)
  cipher = OpenSSL::Cipher.new("aes-128-cbc")
  cipher.encrypt
  cipher.key = KEY
  iv = cipher.random_iv
  cipher.iv = iv
  ciphertext = cipher.update(plaintext)
  ciphertext << cipher.final
  return (iv + ciphertext).unpack('H*')[0]
end

def decrypt(hex_ciphertext)
  ciphertext = [hex_ciphertext].pack('H*')
  cipher = OpenSSL::Cipher.new("aes-128-cbc")
  cipher.decrypt
  cipher.key = KEY
  cipher.iv = ciphertext.slice!(0..15)
  plaintext = cipher.update(ciphertext) << cipher.final
  return plaintext
end

def encrypted_member_url(member_id)
  "/member?id=#{encrypt(member_id)}"
end

get "/" do
  @title = "Stonecutter Secret Society"
  erb :index
end

get "/member" do
  member_id = decrypt(params["id"].to_s)
  @member = MEMBERS.find{|member| member[:id] == member_id}
  if @member
    erb :member
  else
    @member_id = member_id
    erb :member_not_found
  end
end


__END__

@@ layout
<!doctype html>
<html>
 <head>
  <title><%= h @title %></title>
 </head>
 <body>
  <h1><%= h @title %></h1>
<%= yield %>
 </body>
</html>

@@ index
<h2>How to become a member</h2>
<ul>
 <li>Be the son of a a Stonecutter</li>
 <li>Save the life of a Stonecutter</li>
</ul>
<hr />
<h2>Public Members</h2>
<ul>
<% MEMBERS.each do |member|
  next if member[:hidden]
%>
  <li><a href="<%= encrypted_member_url(member[:id]) %>"><%= member[:name] %></li>
<% end %>
</ul>

@@ member_not_found
Member ID <%= @member_id %> not found

@@ member
<h2><%= @member[:name] %></h2>
ID: <%= @member[:id] %><br />
Address: <%= @member[:address] %><br />
Phone Number: <%= @member[:phone] %><br />
