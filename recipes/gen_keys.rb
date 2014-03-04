require 'net/ssh'

def gen_key(keytype)
  case keytype
  when /ecdsa/
    key = OpenSSL::PKey::EC.new
    key.group = OpenSSL::PKey::EC::Group.new('prime256v1')
    key.generate_key
    pub = OpenSSL::PKey::EC.new(key.group)
    pub.public_key = key.public_key
  when /rsa/
    key = OpenSSL::PKey::RSA.new 2048
    pub = key.public_key
  when /dsa/
    key = OpenSSL::PKey::DSA.new 2048
    pub = key.public_key
  end
  pubkey_text = pub.ssh_type + ' ' + [pub.to_blob].pack('m0')
  return key.to_pem, pubkey_text, key.fingerprint
end

ciphers = %w{ rsa dsa ecdsa }

ciphers.each do |cipher|
  keyfile = "#{node['tmate']['keys_dir']}/ssh_host_#{cipher}_key"
  pubfile = "#{node['tmate']['keys_dir']}/ssh_host_#{cipher}_key.pub"
  fpfile = "#{node['tmate']['keys_dir']}/ssh_host_#{cipher}_key.fp"
  if File.exists?(keyfile) && File.exists?(pubfile) && File.exists?(fpfile)
    #key_pem = open(keyfile).read
    #pub_line = open(pubfile).read
    fingerprint = open(fpfile).read
    Chef::Log.info "existing_#{cipher}_fingerprint: #{fingerprint}"
    node.set['tmate']['keys'][cipher]['fingerprint'] = fingerprint
  else
    key_pem,pub_line,fingerprint=gen_key(cipher)
    Chef::Log.info "new_#{cipher}_fingerprint: #{fingerprint}"
    node.set['tmate']['keys'][cipher]['fingerprint'] = fingerprint
    file keyfile do
      content key_pem
      mode 0600
    end
    file pubfile do
      content pub_line
      mode 0600
    end
    file fpfile do
      content fingerprint
      mode 0600
    end
  end
end
