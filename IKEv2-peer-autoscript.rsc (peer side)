/system script
add dont-require-permissions=no name=IKEv2-peer-autoscript owner=admin \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    source="# This variable points to IPSec server's hostname\r\
    \n:global Hostname \"my.domain.com\"\r\
    \n:global PeerName \"UserName\"\r\
    \n:global Password \"KeepInSecret\"\r\
    \n\r\
    \n:log warning \" ============== Starting script ============== \"\r\
    \n:log info \" ============== Client side certificates CA and client =====\
    ========= \"\r\
    \n/certificate import file-name=\"cert_export_\$PeerName@\$Hostname.p12\" \
    passphrase=\$Password\r\
    \n/certificate import file-name=\"cert_export_ca.\$Hostname.crt\" passphra\
    se=\$Password\r\
    \n\r\
    \n:log info \" ============== Setting up new IPSec peer profile (phase 1) \
    ============== \"\r\
    \n/ip ipsec profile\r\
    \nadd dh-group=modp2048,modp1536,modp1024 enc-algorithm=aes-256,aes-192,ae\
    s-128 hash-algorithm=sha256 name=\"profile-\$Hostname\" nat-traversal=yes \
    proposal-check=obey\r\
    \n\r\
    \n:log info \" ============== Adding new client IPSec peer (initiator) ===\
    =========== \"\r\
    \n/ip ipsec peer \r\
    \nadd address=\$Hostname exchange-mode=ike2 name=\"peer-\$Hostname\" profi\
    le=\"profile-\$Hostname\"\r\
    \n\r\
    \n:log info \" ============== Setting up new IPSec proposal (phase 2) ====\
    ========== \"\r\
    \n/ip ipsec proposal \r\
    \nadd auth-algorithms=sha512,sha256,sha1 enc-algorithms=aes-256-cbc,aes-25\
    6-ctr,aes-256-gcm,aes-192-ctr,aes-192-gcm,aes-128-cbc,aes-128-ctr,aes-128-\
    gcm \\\r\
    \nlifetime=8h name=\"proposal-\$Hostname\" pfs-group=none\r\
    \n\r\
    \n:log info \" ============== Adding new IPSec policy group ==============\
    \_\"\r\
    \n/ip ipsec policy group \r\
    \nadd name=\"group-\$Hostname\"\r\
    \n\r\
    \n:log info \" ============== Adding new IPSec policy template ===========\
    === \"\r\
    \n/ip ipsec policy \r\
    \nadd comment=\"policy template \$Hostname\" dst-address=\"0.0.0.0/0\" gro\
    up=\"group-\$Hostname\" proposal=\"proposal-\$Hostname\" src-address=10.0.\
    88.0/24 template=yes\r\
    \n\r\
    \n:log info \" ============== Carefully assembling client\92s IPSec identi\
    ty ============== \"\r\
    \n/ip ipsec identity \r\
    \nadd auth-method=digital-signature certificate=\"cert_export_\$PeerName@\
    \$Hostname.p12_0\" generate-policy=port-strict mode-config=request-only\\\
    \r\
    \nmy-id=\"user-fqdn:\$PeerName@\$Hostname\" peer=\"peer-\$Hostname\" polic\
    y-template-group=\"group-\$Hostname\" remote-id=\"fqdn:\$Hostname\"\r\
    \n\r\
    \n:log warning \" ============== Script finished ============== \"\r\
    \n"
