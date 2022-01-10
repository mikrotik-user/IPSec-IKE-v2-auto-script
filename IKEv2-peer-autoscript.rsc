/system script
add dont-require-permissions=no name=IKEv2-peer owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local Hostname\r\
    \n:local PeerName\r\
    \n:local Password\r\
    \n:local PeerCertFile\r\
    \n:local variant\r\
    \n:local err false\r\
    \n\r\
    \n:local inputFunc do={:put \$1;:return}\r\
    \n\r\
    \n:put \"#################################################################\
    #############\"\r\
    \n:put \"Welcome to IPSec-auto-script. This script will setup IPSec IKEv2 \
    peer.\"\r\
    \n:put \"#################################################################\
    #############\\r\\n\"\r\
    \n:put \"What would you like to do\\\?\"\r\
    \n:put \"1. Create peer\"\r\
    \n:put \"2. Remove peer\"\r\
    \n\t   \r\
    \n:set variant [\$inputFunc \"Choose corresponding number.\"]\r\
    \n\r\
    \n:if (variant = 1) do={\r\
    \n     :put \"\"\r\
    \n     :set Hostname  [\$inputFunc \"Input domain name of IPSec IKEv2 serv\
    er you want to connect to. E.g.: 123456789012.sn.mynetname.net.\"]\r\
    \n\t :if (\$Hostname = \"\") do={\r\
    \n\t     :put \"Error: cannot get DNS name\"\r\
    \n         :set err \"true\"\r\
    \n\t    }\r\
    \n\t :set PeerCertFile  [\$inputFunc \"Input peer certificate filename you\
    \_uploaded from server. E.g.: PeerName@Hostname.p12\"]\r\
    \n\t :set PeerName [\$inputFunc \"Input PeerName. E.g.: newPeer\" ]\r\
    \n\t :set Password  [\$inputFunc \"Input passphrase to import certificate \
    from file\"]\r\
    \n\t :put \"Importing \$PeerCertFile\"\r\
    \n     :do {/certificate import file-name=\"\$PeerCertFile\" passphrase=\"\
    \$Password\"} on-error={\r\
    \n\t     :put \"Error importing \$PeerCertFile\"\r\
    \n\t\t :set err \"true\"}\r\
    \n\t :put \"Setting up new IPSec peer profile (phase 1)\"\r\
    \n\t :do {/ip ipsec profile add dh-group=modp2048,modp1536,modp1024 enc-al\
    gorithm=aes-256,aes-192,aes-128 hash-algorithm=sha256 name=\"profile-\$Hos\
    tname\" nat-traversal=yes proposal-check=obey} on-error={\r\
    \n\t     :put \"Error: cannot add peer profile profile-\$Hostname\"\r\
    \n\t\t :set err \"true\"}\r\
    \n     :put \"Adding new client IPSec peer (initiator)\"\r\
    \n     :do {/ip ipsec peer add address=\$Hostname exchange-mode=ike2 name=\
    \"peer-\$Hostname\" profile=\"profile-\$Hostname\"} on-error={\r\
    \n\t     :put \"Error: cannot add new client IPSec peer peer-\$Hostname (i\
    nitiator)\"\r\
    \n\t\t :set err \"true\"}\r\
    \n\t :put \"Setting up new IPSec proposal (phase 2)\"\r\
    \n\t :do {/ip ipsec proposal add auth-algorithms=sha512,sha256,sha1 enc-al\
    gorithms=aes-256-cbc,aes-256-ctr,aes-256-gcm,aes-192-ctr,aes-192-gcm,aes-1\
    28-cbc,aes-128-ctr,aes-128-gcm lifetime=8h name=\"proposal-\$Hostname\" pf\
    s-group=none} on-error={\r\
    \n\t     :put \"Error: cannot set up new IPSec proposal proposal-\$Hostnam\
    e (phase 2)\"\r\
    \n\t\t :set err \"true\"}\r\
    \n\t :put \"Adding new IPSec policy group\"\r\
    \n\t :do {/ip ipsec policy group add name=\"group-\$Hostname\"} on-error={\
    \r\
    \n\t     :put \"Error: cannot add new IPSec policy group group-\$Hostname\
    \"\r\
    \n\t\t :set err \"true\"} \r\
    \n\t :put \"Adding new IPSec policy template\"\r\
    \n\t :do {/ip ipsec policy add comment=\"policy template \$Hostname\" dst-\
    address=\"0.0.0.0/0\" group=\"group-\$Hostname\" proposal=\"proposal-\$Hos\
    tname\" src-address=10.0.88.0/24 template=yes} on-error={\r\
    \n\t     :put \"Error: cannot add new IPSec policy template\"\r\
    \n\t\t :set err \"true\"} \r\
    \n\t :put \"Assembling clients IPSec identity\"\r\
    \n\t :do {/ip ipsec identity\r\
    \n\t        add auth-method=digital-signature \\\r\
    \n\t\t\tcertificate=\"\$PeerCertFile_0\" generate-policy=port-strict mode-\
    config=request-only \\\r\
    \n\t\t\tmy-id=\"user-fqdn:\$PeerName@\$Hostname\" \\\r\
    \n\t\t\tpeer=\"peer-\$Hostname\" \\\r\
    \n\t\t\tpolicy-template-group=\"group-\$Hostname\" \\\r\
    \n\t\t\tremote-id=\"fqdn:\$Hostname\" } on-error={\r\
    \n\t            :put \"Error: cannot add new client\92s IPSec identity\"\r\
    \n\t\t        :set err \"true\"} \t \r\
    \n\t :if (\$err = \"true\") do={:error \"Cannot create peer\"}\r\
    \n}\r\
    \n:if (variant = 2) do={}\r\
    \n\r\
    \n:put \"Script finished\"\r\
    \n"
