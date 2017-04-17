#!/bin/bash

apt-get -y update
apt-get -y install expect

success_file=`find . -name "*SUCCESS"`
fail_file=`find . -name "*FAIL"`

expect << EOF
spawn scp $success_file $ANSIBLE_HOST/pingtest/internal
expect -re "(yes/no)" {
        send "yes\r"
		exp_continue
} -re "password:" {
		send "tmax@23\r"
}

expect eof
EOF

expect <<  EOF
spawn scp $fail_file $ANSIBLE_HOST/pingtest/internal
expect "password:" {
	send "tmax@23\r"
}

expect eof
EOF

rm -f $success_file
rm -f $fail_file
