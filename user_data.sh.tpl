#!/bin/bash
${pm} -y update
${pm} -y upgrade
${instal_cmd}
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > ${home_dir}index.html
<html>
<h2> ${S_name} WEB Server with IP: $myip</h2>
<br> Build by Terraform
<br> ver. 0.1 (c) AG"
</html>
EOF
systemctl start nginx
${auto_cmd}
