#!/usr/bin/expect

set user [lindex $argv 0]
set server [lindex $argv 1]
#set user [lindex $argv 0]

# Try to retrieve password from macOS Keychain
set result [catch {exec security find-generic-password -a $user -s $server -w} password]

if {$result != 0 || $password eq ""} {
    puts "No password found for user $user@$server"
    exit 1
}

spawn ssh -X $user@$server

# Expect the password prompt
expect {
  "password:" {
    stty -echo
    send "$password\r"
    stty echo
  }
  # Case when the SSH key works and the connection is established
  "$ " {
    # Do nothing, SSH key was used successfully
  }

  # Handle cases where other prompts may appear
  eof {
    puts "SSH connection failed or something went wrong."
    exit 1
  }
}

# Allow interaction after sending the password
interact