#!/bin/bash

sudo su -
yum -y install openldap-clients nss-pam-ldapd

ldapserver=${int_ip}
ldapbasedn="dc=devopsldab,dc=com"

authconfig --enableldap \
--enableldapauth \
--ldapserver=${int_ip} \
--ldapbasedn="dc=devopsldab,dc=com" \
--enablemkhomedir \
--update

cat << 'EOL' >> /opt/ssh_ldap.sh 
#!/bin/bash
set -eou pipefail
IFS=$'\n\t'

result=$(ldapsearch -x '(&(objectClass=posixAccount)(uid='"$1"'))' 'sshPublicKey')
attrLine=$(echo "$result" | sed -n '/^ /{H;d};/sshPublicKey:/x;$g;s/\n *//g;/sshPublicKey:/p')

if [[ "$attrLine" == sshPublicKey::* ]]; then
  echo "$attrLine" | sed 's/sshPublicKey:: //' | base64 -d
elif [[ "$attrLine" == sshPublicKey:* ]]; then
  echo "$attrLine" | sed 's/sshPublicKey: //'
else
  exit 1
fi
EOL

chmod +x /opt/ssh_ldap.sh
echo -e "\nAuthorizedKeysCommand /opt/ssh_ldap.sh\nAuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config

sudo systemctl restart sshd