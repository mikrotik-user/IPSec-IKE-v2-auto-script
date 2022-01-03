/system script
add dont-require-permissions=no name=createPeer owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_File name with extention. E.g.: vpnclient.p12\r\
    \n:local CertFile \"vpnclient.p12\"\r\
    \n# Password to import certificates from CertFile\r\
    \n:local Password \"passphrase\"\r\
    \n# IP address of IPSec IKEv2 server\r\
    \n:local ServerAddress \"11.22.33.44\"\r\
    \n\r\
    \n:log warning \"Check if script can use given parameters\"\r\
    \n:put \"Check if script can use given parameters\"\r\
    \n\r\
    \n:if ([/certificate find name=\"\$CertFile_0\"] != \"\") do={\r\
    \n          :log error \"Script error: certificate \$CertFile_0 already ex\
    ists\"\r\
    \n\t\t  :put \"Script error: certificate \$CertFile_0 already exists\"\r\
    \n          :error \"Script error: certificate \$CertFile_0 already exists\
    \"\r\
    \n     } else {\r\
    \n          :log info \"Script: certificate name \$CertFile_0 OK\"\r\
    \n\t\t  :put \"Script: certificate name \$CertFile_0 OK\"\r\
    \n     }\r\
    \n:if ([/certificate find name=\"\$CertFile_1\"] != \"\") do={\r\
    \n          :log error \"Script error: certificate \$CertFile_1 already ex\
    ists\"\r\
    \n\t\t  :put \"Script error: certificate \$CertFile_1 already exists\"\r\
    \n          :error \"Script error: certificate \$CertFile_1 already exists\
    \"\r\
    \n     } else {\r\
    \n          :log info \"Script: certificate name \$CertFile_1 OK\"\r\
    \n\t\t  :put \"Script: certificate name \$CertFile_1 OK\"\r\
    \n     }\r\
    \n:if ([/ip ipsec profile find name=\"ikev2-autoscript-vpn\"] != \"\") do=\
    {\r\
    \n     :log error \"Script error: ipsec profile ikev2-autoscript-vpn alrea\
    dy exists\"\r\
    \n\t :put \"Script error: ipsec profile ikev2-autoscript-vpn already exist\
    s\"\r\
    \n     :error \"Script error: ipsec profile ikev2-autoscript-vpn already e\
    xists\"\r\
    \n     } else {\r\
    \n     :log info \"Script: ipsec profile name ikev2-autoscript-vpn OK\"\r\
    \n\t :put \"Script: ipsec profile name ikev2-autoscript-vpn OK\"\r\
    \n     }\r\
    \n:if ([/ip ipsec proposal find name=\"ikev2-autoscript-vpn\"] != \"\") do\
    ={\r\
    \n     :log error \"Script error: ipsec proposal ikev2-autoscript-vpn alre\
    ady exists\"\r\
    \n\t :put \"Script error: ipsec proposal ikev2-autoscript-vpn already exis\
    ts\"\r\
    \n     :error \"Script error: ipsec proposal ikev2-autoscript-vpn already \
    exists\"\r\
    \n     } else {\r\
    \n     :log info \"Script: ipsec proposal name ikev2-autoscript-vpn OK\"\r\
    \n\t :put \"Script: ipsec proposal name ikev2-autoscript-vpn OK\"\r\
    \n     }\r\
    \n:if ([/ip ipsec policy group find name=\"ikev2-autoscript-vpn\"] != \"\"\
    ) do={\r\
    \n     :log error \"Script error: ipsec policy group ikev2-autoscript-vpn \
    already exists\"\r\
    \n\t :put \"Script error: ipsec policy group ikev2-autoscript-vpn already \
    exists\"\r\
    \n     :error \"Script error: ipsec policy group ikev2-autoscript-vpn alre\
    ady exists\"\r\
    \n     } else {\r\
    \n     :log info \"Script: ipsec policy group name ikev2-autoscript-vpn OK\
    \"\r\
    \n\t :put \"Script: ipsec policy group name ikev2-autoscript-vpn OK\"\r\
    \n     }\r\
    \n:if ([/ip ipsec policy find dst-address=\"0.0.0.0/0\" src-address=\"0.0.\
    0.0/0\"] != \"\") do={\r\
    \n     :log error \"Script error: ipsec policy for dst-address=0.0.0.0/0 a\
    lready exists\"\r\
    \n\t :put \"Script error: ipsec policy for dst-address=0.0.0.0/0 already e\
    xists\"\r\
    \n     :error \"Script error: ipsec policy for dst-address=0.0.0.0/0 alrea\
    dy exists\"\r\
    \n     } else {\r\
    \n     :log info \"Script: ipsec policy for dst-address=0.0.0.0/0 src-addr\
    ess=0.0.0.0/0 OK\"\r\
    \n\t :put \"Script: ipsec policy for dst-address=0.0.0.0/0 src-address=0.0\
    .0.0/0 OK\"\r\
    \n     }\r\
    \n:if ([/ip ipsec mode-config find name=\"ikev2-autoscript-vpn\"] != \"\")\
    \_do={\r\
    \n          :log error \"Script error: mode-config ikev2-autoscript-vpn al\
    ready exists\"\r\
    \n\t\t  :put \"Script error: mode-config ikev2-autoscript-vpn already exis\
    ts\"\r\
    \n          :error \"Script error: mode-config ikev2-autoscript-vpn alread\
    y exists\"\r\
    \n     } else {\r\
    \n     :log info \"Script: mode-config name ikev2-autoscript-vpn OK\"\r\
    \n\t :put \"Script: mode-config name ikev2-autoscript-vpn OK\"\r\
    \n     }\r\
    \n:if ([/ip ipsec peer find name=\"ikev2-autoscript-vpn\"] !=\"\") do={\r\
    \n     :log error \"Script error: ipsec peer ikev2-autoscript-vpn already \
    exists\"\r\
    \n\t :put \"Script error: ipsec peer ikev2-autoscript-vpn already exists\"\
    \r\
    \n     :error \"Script error: ipsec peer ikev2-autoscript-vpn already exis\
    ts\"\r\
    \n     } else {\r\
    \n     :log info \"Script: ipsec peer name ikev2-autoscript-vpn OK\"\r\
    \n\t :put \"Script: ipsec peer name ikev2-autoscript-vpn OK\"\r\
    \n     }\r\
    \n:if ([/ip ipsec identity find name=\"ikev2-autoscript-vpn\"] !=\"\") do=\
    {\r\
    \n     :log error \"Script error: ipsec identity ikev2-autoscript-vpn alre\
    ady exists\"\r\
    \n\t :put \"Script error: ipsec identity ikev2-autoscript-vpn already exis\
    ts\"\r\
    \n     :error \"Script error: ipsec identity ikev2-autoscript-vpn already \
    exists\"\r\
    \n     } else {\r\
    \n     :log info \"Script: ipsec identity name ikev2-autoscript-vpn OK\"\r\
    \n\t :put \"Script: ipsec identity name ikev2-autoscript-vpn OK\"\r\
    \n     }\r\
    \n:log warning \"Precheck OK\"\r\
    \n:put \"Precheck OK\"\r\
    \n:log warning \"Starting script\"\r\
    \n:put \"Starting script\"\r\
    \n \r\
    \n/certificate import file-name=\$CertFile passphrase=\$Password \r\
    \n/certificate import file-name=\$CertFile passphrase=\$Password \r\
    \n\r\
    \n/ip ipsec profile add name=\"ikev2-autoscript-vpn\" \r\
    \n/ip ipsec proposal add name=\"ikev2-autoscript-vpn\" pfs-group=none \r\
    \n/ip ipsec policy group add name=\"ikev2-autoscript-vpn\" \r\
    \n/ip ipsec policy add group=\"ikev2-autoscript-vpn\" proposal=\"ikev2-aut\
    oscript-vpn\" template=yes dst-address=\"0.0.0.0/0\" src-address=\"0.0.0.0\
    /0\" \r\
    \n/ip ipsec mode-config add name=\"ikev2-autoscript-vpn\" responder=no \r\
    \n/ip ipsec peer add address=\$ServerAddress exchange-mode=ike2 name=\"ike\
    v2-autoscript-vpn\" profile=\"ikev2-autoscript-vpn\" \r\
    \n/ip ipsec identity add auth-method=digital-signature certificate=\"\$Cer\
    tFile_1\" generate-policy=port-strict mode-config=\"ikev2-autoscript-vpn\"\
    \_peer=\"ikev2-autoscript-vpn\" policy-template-group=\"ikev2-autoscript-v\
    pn\" \r\
    \n\r\
    \n:log warning \"Script finished\"\r\
    \n:put \"Script finished\"\r\
    \n\r\
    \n/system script\r\
    \nadd dont-require-permissions=no name=removePeer owner=admin policy=\\\r\
    \n    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon sou\
    rce=\"\\\r\
    \n    \\n #This script removes automatically created peer\\r\\\r\
    \n    \\n\\r\\\r\
    \n\t\\n:log warning \\\"Starting removePeer script\\\"\\r\\\r\
    \n    \\n:put \\\"Starting removePeer script\\\"\\r\\\r\
    \n\t\\n/ip ipsec policy remove [find group=\\\"ikev2-autoscript-vpn\\\" pr\
    oposal=\\\"ikev2-autoscript-vpn\\\" template=yes dst-address=\\\"0.0.0.0/0\
    \\\" src-address=\\\"0.0.0.0/0\\\"]\\r\\\r\
    \n\t\\n/ip ipsec identity remove [find auth-method=digital-signature certi\
    ficate=\\\"\$CertFile_1\\\" generate-policy=port-strict mode-config=\\\"ik\
    ev2-autoscript-vpn\\\" peer=\\\"ikev2-autoscript-vpn\\\" policy-template-g\
    roup=\\\"ikev2-autoscript-vpn\\\"]\\r\\\r\
    \n    \\n/ip ipsec peer remove [find address=\\\"\$ServerAddress/32\\\" ex\
    change-mode=ike2 name=\\\"ikev2-autoscript-vpn\\\" profile=\\\"ikev2-autos\
    cript-vpn\\\" ]\\r\\\r\
    \n\t\\n/ip ipsec proposal remove [find name=\\\"ikev2-autoscript-vpn\\\" p\
    fs-group=none]\\r\\\r\
    \n    \\n/ip ipsec policy group remove [find name=\\\"ikev2-autoscript-vpn\
    \\\"]\\r\\\r\
    \n\t\\n/ip ipsec profile remove [find name=\\\"ikev2-autoscript-vpn\\\"]\\\
    r\\\r\
    \n\t\\n/ip ipsec mode-config remove [find name=\\\"ikev2-autoscript-vpn\\\
    \" responder=no ]\\r\\\r\
    \n\t\\n/certificate remove [find name=\$CertFile_1]\\r\\\r\
    \n\t\\n/certificate remove [find name=\$CertFile_0]\\r\\\r\
    \n\t\\n/system script remove [find name=removePeer]\\r\\\r\
    \n    \\n:log warning \\\"Script removePeer finished\\\"\\r\\\r\
    \n    \\n:put \\\"Script removePeer finished\\\"\"\r\
    \n:log warning (\"Rollback script removePeer created\")\r\
    \n:put (\"Rollback script removePeer created\")\r\
    \n"
