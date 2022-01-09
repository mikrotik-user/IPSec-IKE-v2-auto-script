/system script
add dont-require-permissions=no name=IKEv2 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_Declare some variables and functions\r\
    \n:local variant\r\
    \n:local Hostname\r\
    \n:local IPaddress \r\
    \n:local Country \"DE\"\r\
    \n:local State \"Frankfurt\"\r\
    \n:local CertFile\r\
    \n:local arrayRollback [ :toarray \"\" ]\r\
    \n:local err \"false\"\r\
    \n:local PeerName\r\
    \n:local Password\r\
    \n\r\
    \n:local inputFunc do={:put \$1;:return}\r\
    \n:local checkHostnameFunc do={\r\
    \n    :local hostname \$1\r\
    \n    :if ([:len \$hostname]=0) do={\r\
    \n         :if ([/ip cloud get value-name=ddns-enabled] = false) do {\r\
    \n             /ip cloud set ddns-enabled=yes\r\
    \n             :delay 10s\r\
    \n         } \r\
    \n    :set \$hostname [/ip cloud get value-name=dns-name]\r\
    \n\t:if ([:len \$hostname]=0) do={\r\
    \n         :return \"\"\r\
    \n\t    }\r\
    \n    }\r\
    \n\treturn \$hostname\r\
    \n}\r\
    \n:local checkIpAddressFunc do={\r\
    \n    :if ([:tostr \$1] = [:toip \$1]) do={:return \$1} else={:return \"\"\
    }\r\
    \n}\r\
    \n\r\
    \n:put (\"\\r\\n\\\r\
    \n     ###################################################################\
    ###########\\r\\n\\\r\
    \n     Welcome to IPSec-auto-script. This script will install and setup IP\
    Sec server.\\r\\n\\\r\
    \n     ###################################################################\
    ###########\\r\\n\\r\\n\")\r\
    \n:put (\"What would you like to do\\\?\\r\\n\\\r\
    \n       1. Install IKE v2 server\\r\\n\\\r\
    \n       2. Create peer\\r\\n\\\r\
    \n\t   3. Revoke peer\\r\\n\\\r\
    \n\t   4. Remove IKE v2 server\\r\\n\")\r\
    \n:set variant [\$inputFunc \"Choose corresponding number.\"]\r\
    \n:if (variant = 1) do={\r\
    \n    :put \"\"\r\
    \n    :set Hostname  [\$inputFunc \"Input domain name of this server. E.g.\
    : 123456789012.sn.mynetname.net. Leave it empty if you want this script to\
    \_find it out from /ip cloud settings\"]\r\
    \n\t:set \$Hostname [\$checkHostnameFunc \$Hostname]\r\
    \n\t:if (\$Hostname = \"\") do={\r\
    \n\t     :put \"Error: cannot get DNS name\"\r\
    \n         :set err \"true\"\r\
    \n\t    }\r\
    \n\tdo {\r\
    \n\t    :put \"\"\r\
    \n\t    :set IPaddress [\$inputFunc \"Input IP address of this server. E.g\
    .: 10.20.30.40. Leave it empty if you want this script to find it out by r\
    esolving Hostname\"]\r\
    \n\t\t:if ([:len \$IPaddress]=0) do={\r\
    \n             do {:set \$IPaddress [:resolve \$Hostname]} on-error={\r\
    \n\t             :put \"Error: cannot resolve DNS name\"\r\
    \n\t            }\r\
    \n            }\r\
    \n\t\t:set IPaddress [\$checkIpAddressFunc \$IPaddress]\r\
    \n\t\t} while=( [:len \$IPaddress]=0 )\r\
    \n\t:put \"\"\r\
    \n\t:set Country   [\$inputFunc \"Input Country of server location. E.g.: \
    DE\"]\r\
    \n\t:put \"\"\r\
    \n\t:set State     [\$inputFunc \"Input State of server location. E.g.: Fr\
    ankfurt\"]\r\
    \n    \r\
    \n\t:put \"\\r\\nChecking if script can use given parameters\\r\\n\"\r\
    \n\t:if ([/certificate find name=\"ca.\$Hostname\"] != \"\") do={\r\
    \n             :put \"Error: certificate ca.\$Hostname already exists\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: certificate name ca.\$Hostname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/certificate find name=\"\$Hostname\"] != \"\") do={\r\
    \n             :put \"Error: certificate \$Hostname already exists\"\r\
    \n\t\t     :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: certificate name \$Hostname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/certificate find name=\"~client-template@\$Hostname\"] != \"\
    \") do={\r\
    \n             :put \"Error: certificate template ~client-template@\$Hostn\
    ame already exists\"\r\
    \n\t\t     :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: certificate template name ~client-template@\$Hos\
    tname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/file find name=\"cert_export_ca.\$Hostname.crt\"] != \"\") do\
    ={\r\
    \n             :put \"Error: file cert_export_ca.\$Hostname.crt already ex\
    ists\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: file name cert_export_ca.\$Hostname.crt\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/int bridge find name=\"bridge-vpn\"] != \"\") do={\r\
    \n             :put \"Error: bridge bridge-vpn already exists\"\r\
    \n\t\t     :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: bridge name bridge-vpn\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip address find address=\"10.0.88.1/24\"] != \"\") do={\r\
    \n             :put \"Error: ip address 10.0.88.1/24 already exists\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ip address 10.0.88.1/24\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip pool find name=\"pool-\$Hostname\"] != \"\") do={\r\
    \n             :put \"Error: ip pool pool-\$Hostname already exists\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ip pool name pool-\$Hostname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip ipsec mode-config find name=\"modeconf-\$Hostname\"] != \"\
    \") do={\r\
    \n             :put \"Error: mode-config modeconf-\$Hostname already exist\
    s\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n              :put \"OK: mode-config name modeconf-\$Hostname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip ipsec profile find name=\"profile-\$Hostname\"] != \"\") d\
    o={\r\
    \n             :put \"Error: ipsec profile profile-\$Hostname already exis\
    ts\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ipsec profile name profile-\$Hostname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip ipsec peer find name=\"peer-\$IPaddress\"] !=\"\") do={\r\
    \n            :put \"Error: ipsec peer peer-\$IPaddress already exists\"\r\
    \n            :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ipsec peer name peer-\$IPaddress\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip ipsec proposal find name=\"proposal-\$Hostname\"] != \"\")\
    \_do={\r\
    \n             :put \"Error: ipsec proposal proposal-\$Hostname already ex\
    ists\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ipsec proposal name proposal-\$Hostname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip ipsec policy group find name=\"group-\$Hostname\"] != \"\"\
    ) do={\r\
    \n             :put \"Error: ipsec policy group group-\$Hostname already e\
    xists\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ipsec policy group name group-\$Hostname\"\r\
    \n        }\r\
    \n\r\
    \n    :if ([/ip ipsec policy find dst-address=\"10.0.88.0/24\" ] != \"\") \
    do={\r\
    \n         :put \"Error: ipsec policy for dst-address=10.0.88.0/24 already\
    \_exists\"\r\
    \n         :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ipsec policy for dst-address=10.0.88.0/24\"\r\
    \n        }\r\
    \n\t:if (\$err = \"true\") do={:error \"\\r\\nPrecheck failed\"} else={:pu\
    t \"\\r\\nPrecheck OK\"}\r\
    \n\t:put \"\\r\\n\"\r\
    \n\t:put \"Hostname is: \$Hostname\"\r\
    \n\t:put \"IP address is: \$IPaddress\"\r\
    \n\t:put \"Country is: \$Country\"\r\
    \n\t:put \"State is: \$State\"\r\
    \n\t:put \"\"\r\
    \n\t:if ([\$inputFunc \"Continue\? [y/n]\"]=\"n\") do={:error \"Script sto\
    pped by user request\"}\r\
    \n    :put \"\\r\\nGenerating CA SSL certificate\"\r\
    \n    :do {/certificate \r\
    \n         add name=\"ca.\$Hostname\" country=\$Country state=\$State loca\
    lity=City \\\r\
    \n         organization=\"\$Hostname\" common-name=\"ca.\$Hostname\"  subj\
    ect-alt-name=\"DNS:ca.\$Hostname\"  \\\r\
    \n         key-size=4096 days-valid=3650 trusted=yes key-usage=digital-sig\
    nature,key-encipherment,data-encipherment,key-cert-sign,crl-sign\r\
    \n\t\t :set arrayRollback ( \$arrayRollback, \":do {/certificate remove [ \
    find name=\\\"ca.\$Hostname\\\"]} on-error={} \" )\r\
    \n\t\t } on-error={\r\
    \n             :put \"Error: Cannot add certificate ca.\$Hostname\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n        }\r\
    \n\r\
    \n    :put \"Signing CA SSL certificate (Certificate Authority)\"\r\
    \n    :delay 1\r\
    \n    :do {/certificate sign \"ca.\$Hostname\"} on-error={\r\
    \n         :put \"Error: Cannot sign ca.\$Hostname\"\r\
    \n         :set err \"true\"\r\
    \n\t\t :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Generating server SSL certificate\"\r\
    \n    :do {/certificate \r\
    \n        add name=\"\$Hostname\" country=\$Country state=\$State locality\
    =\"City\" organization=\"\$Hostname\" common-name=\"\$Hostname\" \\\r\
    \n        subject-alt-name=\"DNS:\$Hostname\" key-size=2048 days-valid=109\
    5 trusted=yes key-usage=tls-server\r\
    \n\t\t:set arrayRollback ( \$arrayRollback, \":do {/certificate remove [ f\
    ind name=\\\"\$Hostname\\\"]} on-error={} \" )\r\
    \n\t\t\t} on-error={\r\
    \n                 :put \"Error: Cannot add certificate \$Hostname\"\r\
    \n                 :set err \"true\"\r\
    \n\t\t         :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Signing server certificate with ca.\$Hostname\"\r\
    \n    :delay 1\r\
    \n    :do {/certificate sign \"\$Hostname\" ca=\"ca.\$Hostname\"} on-error\
    ={\r\
    \n         :put \"Cannot sign \$Hostname with ca.\$Hostname\"\r\
    \n         :set err \"true\"\r\
    \n\t\t :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Creating template for signing clients\"\r\
    \n    :do {/certificate\r\
    \n       add name=\"~client-template@\$Hostname\" country=\$Country state=\
    \$State locality=\"City\" organization=\"\$Hostname\" common-name=\"~clien\
    t-template@\$Hostname\" \\\r\
    \n       subject-alt-name=\"email:~client-template@\$Hostname\" key-size=2\
    048 days-valid=365 trusted=yes key-usage=tls-client\r\
    \n\t   :set arrayRollback ( \$arrayRollback, \":do {/certificate remove [ \
    find name~\\\"~client-template\\\"]} on-error={} \" )\r\
    \n\t\t\t} on-error={\r\
    \n                 :put \"Cannot add client-template@\$Hostname\"\r\
    \n                 :set err \"true\"\r\
    \n\t\t         :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Exporting CA certificate to file cert_export_ca.\$Hostname\"\
    \r\
    \n    :do {/certificate export-certificate \"ca.\$Hostname\" type=pem} on-\
    error={\r\
    \n         :put \"Cannot export-certificate ca.\$Hostname\"\r\
    \n         :set err \"true\"\r\
    \n\t\t :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Create IKEv2 server\"\r\
    \n    :do {/interface bridge add name=\"bridge-vpn\"\r\
    \n\t\t:set arrayRollback ( \$arrayRollback, \"/interface bridge remove [fi\
    nd name=\\\"bridge-vpn\\\"]\" )\r\
    \n\t\t} on-error={\r\
    \n             :put \"bridge bridge-vpn already exists\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n    :do {/ip address add address=10.0.88.1/24 interface=\"bridge-vpn\" n\
    etwork=10.0.88.0\r\
    \n\t\t:set arrayRollback ( \$arrayRollback, \"/ip address remove [find add\
    ress=\\\"10.0.88.1/24\\\"]\" )\r\
    \n\t\t} on-error={\r\
    \n             :put \"Cannot add ip address (10.0.88.1/24) on interface br\
    idge-vpn\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n    :do {/ip pool add name=\"pool-\$Hostname\" ranges=10.0.88.2-10.0.88.\
    254\r\
    \n\t\t:set arrayRollback ( \$arrayRollback, \"/ip pool remove [find name=\
    \\\"pool-\$Hostname\\\"]\" )\r\
    \n\t\t} on-error={\r\
    \n             :put \"IP pool (10.0.88.2-10.0.88.254) already exists\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Create new IPSec mode config\"\r\
    \n    :do {/ip ipsec mode-config add address-pool=\"pool-\$Hostname\" addr\
    ess-prefix-length=32 name=\"modeconf-\$Hostname\" split-include=0.0.0.0/0 \
    static-dns=10.0.88.1 system-dns=no\r\
    \n\t    :set arrayRollback ( \$arrayRollback, \"/ip ipsec mode-config remo\
    ve [ find name=\\\"modeconf-\$Hostname\\\"]\" )\r\
    \n\t\t} on-error={\r\
    \n             :put \"Cannot create modeconf-\$Hostname or it already exis\
    ts\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Create new IPSec peer profile (phase 1)\"\r\
    \n    :do {/ip ipsec profile add dh-group=modp2048,modp1536,modp1024 enc-a\
    lgorithm=aes-256,aes-192,aes-128 hash-algorithm=sha256 name=\"profile-\$Ho\
    stname\" nat-traversal=yes proposal-check=obey \r\
    \n\t    :set arrayRollback ( \$arrayRollback, \"/ip ipsec profile remove  \
    [ find name=\\\"profile-\$Hostname\\\"]\" )\r\
    \n\t\t} on-error={\r\
    \n             :put \"Cannot create profile-\$Hostname or it already exist\
    s\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Create new IPSec peer using public IP address (mode IKE2)\"\r\
    \n    :do {/ip ipsec peer add exchange-mode=ike2 address=0.0.0.0/0 local-a\
    ddress=\"\$IPaddress\" name=\"peer-\$IPaddress\" passive=yes send-initial-\
    contact=yes profile=\"profile-\$Hostname\"\r\
    \n\t   :set arrayRollback ( \$arrayRollback, \"/ip ipsec peer remove  [ fi\
    nd name=\\\"peer-\$IPaddress\\\"]\" )\r\
    \n\t   } on-error={\r\
    \n             :put \"Cannot create ipsec peer-\$IPaddress or it already e\
    xists\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Create new IPSec proposal (phase 2)\"\r\
    \n    :do {/ip ipsec proposal add auth-algorithms=sha512,sha256,sha1 enc-a\
    lgorithms=aes-256-cbc,aes-256-ctr,aes-256-gcm,aes-192-ctr,aes-192-gcm,aes-\
    128-cbc,aes-128-ctr,aes-128-gcm lifetime=8h name=\"proposal-\$Hostname\" p\
    fs-group=none\r\
    \n\t    :set arrayRollback ( \$arrayRollback, \"/ip ipsec proposal remove \
    [find name=\\\"proposal-\$Hostname\\\"]\" )\r\
    \n\t\t} on-error={\r\
    \n             :put \"Cannot create ipsec proposal-\$Hostname or it alread\
    y exists\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Create new IPSec policy group\"\r\
    \n    :do {/ip ipsec policy group add name=\"group-\$Hostname\"\r\
    \n\t   :set arrayRollback ( \$arrayRollback, \"/ip ipsec policy group remo\
    ve [find name=\\\"group-\$Hostname\\\"]\" )\r\
    \n\t   } on-error={\r\
    \n             :put \"Cannot create policy group-\$Hostname or it already \
    exists\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n\r\
    \n    :put \"Create new template IPSec policy\"\r\
    \n    :do {/ip ipsec policy add dst-address=10.0.88.0/24 group=\"group-\$H\
    ostname\" proposal=\"proposal-\$Hostname\" src-address=0.0.0.0/0 template=\
    yes\r\
    \n\t    :set arrayRollback ( \$arrayRollback, \"/ip ipsec policy remove [f\
    ind dst-address=10.0.88.0/24 group=\\\"group-\$Hostname\\\" proposal=\\\"p\
    roposal-\$Hostname\\\" src-address=0.0.0.0/0]\" )\r\
    \n\t\t} on-error={\r\
    \n             :put \"Cannot create ipsec policy dst-address=10.0.88.0/24 \
    src-address=0.0.0.0/0 or it already exists\"\r\
    \n             :set err \"true\"\r\
    \n\t\t     :return \"\"\r\
    \n    }\r\
    \n\t\r\
    \n    :local scr\r\
    \n\t:local ln\r\
    \n\t:set arrayRollback ( \$arrayRollback, \":if ([\\\$inputFunc \\\"Contin\
    ue\? [y/n]\\\"]=\\\"n\\\") do={:error \\\"Script stopped by user request\\\
    \"}\" )\r\
    \n\t:set arrayRollback ( \$arrayRollback, \":local inputFunc do={:put \\\$\
    1;:return}\")\r\
    \n\t:set arrayRollback ( \$arrayRollback, \":put \\\"This script will remo\
    ve IPSec IKEv2\\\" \" )\r\
    \n\t:for x from=[:len \$arrayRollback] to=0 step=-1 do={\r\
    \n\t     :set ln [:pick \$arrayRollback \$x] \r\
    \n\t\t :if ([:len \$ln]!=0) do={:set scr (\$scr.\"\\r\\n\".\$ln)}\r\
    \n\t}\r\
    \n\t\r\
    \n    /system script remove [find name=\"IKEv2-rollback\"]\r\
    \n    /system script\r\
    \n         add dont-require-permissions=no name=\"IKEv2-rollback\" owner=a\
    dmin policy=\\\r\
    \n         ftp,reboot,read,write,policy,test,password,sniff,sensitive,romo\
    n source=\"\$scr\"\r\
    \n\t:put \"\\r\\nGenerated IKEv2-rollback script.\"\r\
    \n\t}\r\
    \n\r\
    \n:if (variant = 2) do={\r\
    \n    :put \"\"\r\
    \n    :set Hostname  [\$inputFunc \"Input domain name of this server. Leav\
    e it empty if you want to use /ip cloud DNS name\"]\r\
    \n\t:set \$Hostname [\$checkHostnameFunc \$Hostname]\r\
    \n\t:if (\$Hostname = \"\") do={\r\
    \n\t     :put \"Error: cannot get DNS name of this router.\"\r\
    \n         :set err \"true\"\r\
    \n\t    }\r\
    \n\t:put \"\"\r\
    \n\t:do {\r\
    \n\t    :set IPaddress [\$inputFunc \"Input IP address of this server. E.g\
    .: 10.20.30.40. Leave it empty if you want this script to find it out by r\
    esolving Hostname\"]\r\
    \n\t\t:if ([:len \$IPaddress]=0) do={\r\
    \n             do {:set \$IPaddress [:resolve \$Hostname]} on-error={\r\
    \n\t             :put \"Error: cannot resolve DNS name\"\r\
    \n\t            }\r\
    \n            }\r\
    \n\t\t:set IPaddress [\$checkIpAddressFunc \$IPaddress]\r\
    \n\t\t} while=( [:len \$IPaddress]=0 )\r\
    \n    :put \"\"\r\
    \n    :set PeerName [\$inputFunc \"Input peer name.\"]\r\
    \n\t:put \"\"\r\
    \n\t:do {\r\
    \n         :set Password [\$inputFunc \"Input password to encript certific\
    ate file (length should be more than 7 digits).\"]\r\
    \n         } while=( [:len \$Password]<7 )\r\
    \n    :put \"\\r\\nChecking if script can use given parameters\\r\\n\"\r\
    \n\t\r\
    \n\t:if ([/certificate find name=\"\$PeerName@\$Hostname\"] != \"\") do={\
    \r\
    \n             :put \"Error: certificate \$PeerName@\$Hostname already exi\
    sts\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: certificate name \$PeerName@\$Hostname\"\r\
    \n        }\r\
    \n\t:if ([/certificate find name=\"~client-template@\$Hostname\"] = \"\") \
    do={\r\
    \n             :put \"Error: there's no template ~client-template@\$Hostna\
    me\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: template ~client-template@\$Hostname\"\r\
    \n        }\r\
    \n\t:if ([/certificate find name=\"ca.\$Hostname\"] = \"\") do={\r\
    \n             :put \"Error: there's no ca.\$Hostname certificate\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: ca.\$Hostname certificate\"\r\
    \n        }\r\
    \n    :if ([/file find name=\"cert_export_\$PeerName@\$Hostname.crt\"] != \
    \"\") do={\r\
    \n             :put \"Error: file cert_export_ca.\$Hostname.crt already ex\
    ists\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: file name cert_export_ca.\$Hostname.crt\"\r\
    \n        }\r\
    \n\t:if (\$err = \"true\") do={:error \"\\r\\nPrecheck failed\"} else={:pu\
    t \"\\r\\nPrecheck OK\"}\r\
    \n\t:put \"\\r\\n\"\r\
    \n\t:put \"Hostname is: \$Hostname\"\r\
    \n\t:put \"PeerName is: \$PeerName\"\r\
    \n\t:put \"Password is: \$Password\"\r\
    \n\t:put \"\"\r\
    \n\t:if ([\$inputFunc \"Continue\? [y/n]\"]=\"n\") do={:error \"Script sto\
    pped by user request\"}\r\
    \n    \r\
    \n\t:put \"Creating client certificate from template\"\r\
    \n    :do {/certificate \r\
    \n         add copy-from=\"~client-template@\$Hostname\" name=\"\$PeerName\
    @\$Hostname\" common-name=\"\$PeerName@\$Hostname\" subject-alt-name=\"ema\
    il:\$PeerName@\$Hostname\"\r\
    \n\t\t :set arrayRollback ( \$arrayRollback, \":do {/certificate issued-re\
    voke [ find name=\\\"\$PeerName@\$Hostname\\\"]} on-error={}\" )\r\
    \n        } on-error={\r\
    \n             :put \"Script error: cannot copy-from ~client-template@\$Ho\
    stname certificate\"\r\
    \n             :set err \"true\"\r\
    \n        }    \r\
    \n\t:put \"Signing client certificate with ca.\$Hostname\"\r\
    \n    :do {/certificate sign \"\$PeerName@\$Hostname\" ca=\"ca.\$Hostname\
    \" } on-error={\r\
    \n             :put \"Script error: cannot sign client certificate \$PeerN\
    ame@\$Hostname\"\r\
    \n             :set err \"true\"\r\
    \n        } \r\
    \n    :delay 1\r\
    \n\t:put (\"Exporting client certificate and private key\")\t\t\r\
    \n    :do {/certificate export-certificate \"\$PeerName@\$Hostname\" type=\
    pkcs12 export-passphrase=\"\$Password\"} on-error={\r\
    \n             :put \"Script error: cannot create export-certificate \$Pee\
    rName@\$Hostname\"\r\
    \n             :set err \"true\"\r\
    \n        }\r\
    \n\t:put \"Assembling ipsec identity\"\t\t\r\
    \n    :do {/ip ipsec identity\r\
    \n         add auth-method=digital-signature certificate=\"\$Hostname\" re\
    mote-certificate=\"\$PeerName@\$Hostname\" generate-policy=port-strict \\\
    \r\
    \n         match-by=certificate mode-config=\"modeconf-\$Hostname\" peer=\
    \"peer-\$IPaddress\" policy-template-group=\"group-\$Hostname\" remote-id=\
    \"user-fqdn:\$PeerName@\$Hostname\"\r\
    \n\t\t :set arrayRollback ( \$arrayRollback, \":do {/ip ipsec identity rem\
    ove [find remote-id~\\\"\$PeerName@\$Hostname\\\"]} on-error={}\" )\r\
    \n        } on-error={\r\
    \n\t         :put \"Script error: cannot create ipsec identity\"\r\
    \n             :set err \"true\"\r\
    \n        }\r\
    \n\t:if (\$err=\"true\") do={:put \"\\r\\nThe were errors creating peer.\"\
    }\r\
    \n\t:local scr\r\
    \n\t:local ln\r\
    \n\t:set arrayRollback ( \$arrayRollback, \":if ([\\\$inputFunc \\\"Contin\
    ue\? [y/n]\\\"]=\\\"n\\\") do={:error \\\"Script stopped by user request\\\
    \"}\" )\r\
    \n\t:set arrayRollback ( \$arrayRollback, \":local inputFunc do={:put \\\$\
    1;:return}\")\r\
    \n\t:set arrayRollback ( \$arrayRollback, \":put \\\"This script will remo\
    ve \$PeerName@\$Hostname from this server\\\" \" )\r\
    \n\t:for x from=[:len \$arrayRollback] to=0 step=-1 do={\r\
    \n\t     :set ln [:pick \$arrayRollback \$x] \r\
    \n\t\t :if ([:len \$ln]!=0) do={:set scr (\$scr.\"\\r\\n\".\$ln)}\r\
    \n\t}\r\
    \n\r\
    \n\t/system script remove [find name=\"\$PeerName-rollback\"]\r\
    \n    /system script\r\
    \n         add dont-require-permissions=no name=\"\$PeerName-rollback\" ow\
    ner=admin policy=\\\r\
    \n         ftp,reboot,read,write,policy,test,password,sniff,sensitive,romo\
    n source=\"\$scr\"\r\
    \n\t:put \"\\r\\nGenerated \$PeerName-rollback script.\"\r\
    \n\t:put \"\\r\\nCopy certificate file to a new peer device.\"\r\
    \n\t}\r\
    \n:if (variant = 3) do={\r\
    \n\t:put \"\"\r\
    \n    :set \$Hostname  [\$inputFunc \"Input domain name of this server. Le\
    ave it empty if you want to use /ip cloud DNS name\"]\r\
    \n\t:set \$Hostname [\$checkHostnameFunc \$Hostname]\r\
    \n\t:if (\$Hostname = \"\") do={\r\
    \n\t         :put \"Error: cannot get DNS name of this router.\"\r\
    \n             :set err \"true\"\r\
    \n\t    }\r\
    \n\t:put \"\"\r\
    \n    :set PeerName [\$inputFunc \"Input peer name you want to remove.\"]\
    \r\
    \n\t:put \"\"\r\
    \n\t:put \"\\r\\nChecking if script can use given parameters\\r\\n\"\r\
    \n\t:if ([/certificate find name=\"\$PeerName@\$Hostname\"] = \"\") do={\r\
    \n             :put \"Error: there's no such peer \$PeerName@\$Hostname\"\
    \r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: peer name \$PeerName@\$Hostname\"\r\
    \n        }\r\
    \n\t:if ([/ip ipsec identity find remote-id~\"\$PeerName@\$Hostname\"] = \
    \"\") do={\r\
    \n             :put \"Error: there's no such identity for \$PeerName@\$Hos\
    tname\"\r\
    \n             :set err \"true\"\r\
    \n        } else {\r\
    \n             :put \"OK: identity for peer name \$PeerName@\$Hostname\"\r\
    \n        }\r\
    \n\t\t\r\
    \n\t:if (\$err = \"true\") do={:error \"\\r\\nPrecheck failed\"} else={:pu\
    t \"Precheck OK\"}\r\
    \n\t:put \"\\r\\n\"\r\
    \n\t:if ([\$inputFunc \"Remove peer\? [y/n]\"]=\"n\") do={:error \"Script \
    stopped by user request\"}\r\
    \n\t:do {/certificate issued-revoke [find name=\"\$PeerName@\$Hostname\"]}\
    \_on-error={}\r\
    \n\t:do {/ip ipsec identity remove [find remote-id~\"\$PeerName@\$Hostname\
    \"]} on-error={}\r\
    \n\t}\r\
    \n:if (variant = 4) do={\r\
    \n    :if ([\$inputFunc \"Remove IKE v2 server\? [y/n]\"]=\"n\") do={:erro\
    r \"Script stopped by user request\"}\r\
    \n\t:put \"\\r\\nChecking if script can use given parameters\\r\\n\"\r\
    \n\t:if ([/system script find name=\"IKEv2-rollback\"] = \"\") do={\r\
    \n             :put \"Error: cannot find rollback script IKEv2-rollback\"\
    \r\
    \n        } else {\r\
    \n             :put \"OK: rollback script IKEv2-rollback found.\"\r\
    \n\t\t\t :do {/system script run [find name=\"IKEv2-rollback\"]} on-error=\
    {:error \"Error: script error in IKEv2-rollback\"}\r\
    \n        }\r\
    \n\t}\r\
    \n\t\r\
    \n\t:put \"\\r\\nScript finished.\"\r\
    \n}"
