/system script
add dont-require-permissions=no name=IKEv2-remove-peer-autoscript owner=admin \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    source=":local Hostname \"my.domain.com\"\r\
    \n:local PeerName \"UserName\"\r\
    \n\r\
    \n:log warn \" ============== Starting script ============== \"\r\
    \n\r\
    \n:log info \" ======== Revoke certificate PeerName@\$Hostname ======== \"\
    \r\
    \n:do {/certificate issued-revoke [ find name=\"\$PeerName@\$Hostname\"];}\
    \_on-error={:log error \"!!! cannot revoke certificate \$PeerName@\$Hostna\
    me\"}\r\
    \n:do {/file remove \"cert_export_\$PeerName@\$Hostname.p12\"} on-error={:\
    log error \"!!! cannot remove file cert_export_\$PeerName@\$Hostname.p12.\
    \" }\r\
    \n\r\
    \n:log info \" ======== Remove  IPSec identities dlya kazhdogo klienta ===\
    ===== \"\r\
    \n/ip ipsec identity\r\
    \nremove [find remote-id~\"\$PeerName\"]\r\
    \n\r\
    \n:log warn \" ============== Script finished ============== \"\r\
    \n"
