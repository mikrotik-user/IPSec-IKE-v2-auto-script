/system script
add dont-require-permissions=no name=IKEv2-strongswan-peer-autoscript owner=\
    admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local PeerCertFile\r\
    \n:local Password\r\
    \n:local ServerAddress\r\
    \n:local PeerName\r\
    \n:local variant\r\
    \n:local err \"false\"\r\
    \n:local inputFunc do={:put \$1;:return}\r\
    \n\r\
    \n:put \"#################################################################\
    #############\"\r\
    \n:put \"Welcome to IPSec-Strongswan-auto-script.\"\r\
    \n:put \"This script will setup IPSec IKEv2 StrongSwan peer.\"\r\
    \n:put \"#################################################################\
    #############\\r\\n\"\r\
    \n:put \"What would you like to do\\\?\"\r\
    \n:put \"1. Create peer\"\r\
    \n:put \"2. Remove peer\"\r\
    \n:put \"3. Exit\"\r\
    \n\r\
    \n:set variant [\$inputFunc \"Choose corresponding number.\"]\r\
    \n:if (variant = 1) do={\r\
    \n\t:set ServerAddress  [\$inputFunc \"Input domain name or IP address of \
    IPSec IKEv2 server you want to connect to.\"]\r\
    \n\t:if (\$ServerAddress = \"\") do={:error \"Error: name or IP address ca\
    nnot be empty\"}\r\
    \n\t:set PeerName [\$inputFunc \"Input PeerName. Usually this name indicat\
    es VPN server's name or IP address. E.g.: VPN-server or 1.2.3.4\" ]\r\
    \n\t:if (\$PeerName = \"\") do={:error \"Error: PeerName cannot be empty\"\
    \_} \r\
    \n\t:set PeerCertFile [\$inputFunc \"Input peer certificate filename you u\
    ploaded from server. E.g.: PeerName@ServerAddress.p12\"]\r\
    \n\t:if (\$PeerCertFile = \"\") do={:error \"Error: certificate filename c\
    annot be empty\" } \r\
    \n\t:set Password [\$inputFunc \"Input passphrase to import certificate fr\
    om file\"]\r\
    \n\t:if (\$Password = \"\") do={:error \"Error: Password cannot be empty\"\
    \_} \r\
    \n\t\t \r\
    \n\t:put \"\\r\\nCheck if script can use given parameters\"\r\
    \n\t\t \r\
    \n    :if ([/file find name=\"\$PeerCertFile\"] = \"\") do={\r\
    \n\t\t\t  :put \"Error: cannot find file \$PeerCertFile\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/certificate find name=\"\$PeerCertFile_0\"] != \"\") do={\r\
    \n\t\t\t  :put \"Error: certificate \$PeerCertFile_0 already exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/certificate find name=\"\$PeerCertFile_1\"] != \"\") do={\r\
    \n\t\t\t  :put \"Error: certificate \$PeerCertFile_1 already exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/ip ipsec profile find name=\"prof-\$PeerName-autoscript-vpn\"] \
    != \"\") do={\r\
    \n\t\t      :put \"Error: ipsec profile prof-\$PeerName-autoscript-vpn alr\
    eady exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/ip ipsec proposal find name=\"prop-\$PeerName-autoscript-vpn\"]\
    \_!= \"\") do={\r\
    \n\t\t      :put \"Error: ipsec proposal prop-\$PeerName-autoscript-vpn al\
    ready exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/ip ipsec policy group find name=\"group-\$PeerName-autoscript-v\
    pn\"] != \"\") do={\r\
    \n\t\t      :put \"Error: ipsec policy group group-\$PeerName-autoscript-v\
    pn already exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/ip ipsec policy find dst-address=\"0.0.0.0/0\" src-address=\"0.\
    0.0.0/0\" group=\"group-\$PeerName-autoscript-vpn\"] != \"\") do={\r\
    \n\t\t      :put \"Error: ipsec policy for dst-address=0.0.0.0/0 already e\
    xists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/ip ipsec mode-config find name=\"mconf-\$PeerName-autoscript-vp\
    n\"] != \"\") do={\r\
    \n\t\t\t  :put \"Error: mode-config mconf-\$PeerName-autoscript-vpn alread\
    y exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/ip ipsec peer find name=\"peer-\$PeerName-autoscript-vpn\"] !=\
    \"\") do={\r\
    \n\t\t      :put \"Error: ipsec peer peer-\$PeerName-autoscript-vpn alread\
    y exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if ([/ip ipsec identity find name=\"identity-\$PeerName-autoscript-vp\
    n\"] !=\"\") do={\r\
    \n\t\t      :put \"Error: ipsec identity identity-\$PeerName-autoscript-vp\
    n already exists\"\r\
    \n\t\t\t  :set err \"true\"\r\
    \n\t\t } \r\
    \n\t:if (\$err = \"true\") do={:error \"Precheck failed\"}\r\
    \n\t:put \"Precheck OK\"\r\
    \n\t:put \"\\r\\nStarting script\"\r\
    \n\t \r\
    \n\t:put \"Importing certificates\"\r\
    \n\t:do {/certificate import file-name=\$PeerCertFile passphrase=\$Passwor\
    d } on-error={}\r\
    \n\t:do {/certificate import file-name=\$PeerCertFile passphrase=\$Passwor\
    d } on-error={}\r\
    \n\t\r\
    \n\t:if ([/certificate find name=\"\$PeerCertFile_0\"] = \"\") do={ :error\
    \_\"Error: cannot import \$PeerCertFile_0\" }\r\
    \n\t:if ([/certificate find name=\"\$PeerCertFile_1\"] = \"\") do={ :error\
    \_\"Error: cannot import \$PeerCertFile_1\" }\r\
    \n \r\
    \n\t:do {/ip ipsec profile add name=\"prof-\$PeerName-autoscript-vpn\" } o\
    n-error={\r\
    \n\t     :put \"Error: cannot add profile prof-\$PeerName-autoscript-vpn\"\
    \r\
    \n\t     :set err \"true\"}\r\
    \n\t:do {/ip ipsec proposal add name=\"prop-\$PeerName-autoscript-vpn\" pf\
    s-group=none } on-error={\r\
    \n\t     :put \"Error: cannot add proposal prop-\$PeerName-autoscript-vpn\
    \"\r\
    \n\t\t :put \"Rollback previous action\"\r\
    \n\t\t :do {/ip ipsec profile remove [find name=\"prof-\$PeerName-autoscri\
    pt-vpn\"]} on-error={}\r\
    \n\t     :set err \"true\"}\r\
    \n\t:do {/ip ipsec policy group add name=\"group-\$PeerName-autoscript-vpn\
    \" } on-error={\r\
    \n         :put \"Error: cannot add group group-\$PeerName-autoscript-vpn\
    \"\r\
    \n\t\t :put \"Rollback previous action\"\r\
    \n\t\t :do {/ip ipsec proposal remove [find name=\"prop-\$PeerName-autoscr\
    ipt-vpn\" pfs-group=none]} on-error={}\r\
    \n\t\t :do {/ip ipsec profile remove [find name=\"prof-\$PeerName-autoscri\
    pt-vpn\"]} on-error={}\r\
    \n\t     :set err \"true\"}\r\
    \n\t:do {/ip ipsec policy add comment=\"IKEv2-strongswan-autoscript-vpn\" \
    group=\"group-\$PeerName-autoscript-vpn\" proposal=\"prop-\$PeerName-autos\
    cript-vpn\" template=yes dst-address=\"0.0.0.0/0\" src-address=\"0.0.0.0/0\
    \" } on-error={\r\
    \n\t     :put \"Error: cannot add policy\"\r\
    \n\t\t :put \"Rollback previous action\"\r\
    \n\t\t :do {/ip ipsec policy group remove [find name=\"group-\$PeerName-au\
    toscript-vpn\"] } on-error={}\r\
    \n\t\t :do {/ip ipsec proposal remove [find name=\"prop-\$PeerName-autoscr\
    ipt-vpn\" pfs-group=none]} on-error={}\r\
    \n\t\t :do {/ip ipsec profile remove [find name=\"prof-\$PeerName-autoscri\
    pt-vpn\"]} on-error={}\r\
    \n\t     :set err \"true\"}\r\
    \n\t:do {/ip ipsec mode-config add name=\"mconf-\$PeerName-autoscript-vpn\
    \" responder=no } on-error={\r\
    \n\t     :put \"Error: cannot add mode-config mconf-\$PeerName-autoscript-\
    vpn\"\r\
    \n\t\t :put \"Rollback previous action\"\r\
    \n\t\t :do {/ip ipsec policy remove [find group=\"group-\$PeerName-autoscr\
    ipt-vpn\" proposal=\"prop-\$PeerName-autoscript-vpn\" template=yes dst-add\
    ress=\"0.0.0.0/0\" src-address=\"0.0.0.0/0\"] } on-error={}\r\
    \n\t\t :do {/ip ipsec policy group remove [find name=\"group-\$PeerName-au\
    toscript-vpn\"] } on-error={}\r\
    \n\t\t :do {/ip ipsec proposal remove [find name=\"prop-\$PeerName-autoscr\
    ipt-vpn\" pfs-group=none]} on-error={}\r\
    \n\t\t :do {/ip ipsec profile remove [find name=\"prof-\$PeerName-autoscri\
    pt-vpn\"]} on-error={}\r\
    \n\t     :set err \"true\"}\r\
    \n\t:do {/ip ipsec peer add comment=\"IKEv2-strongswan-autoscript-vpn\" ad\
    dress=\$ServerAddress exchange-mode=ike2 name=\"peer-\$PeerName-autoscript\
    -vpn\" profile=\"prof-\$PeerName-autoscript-vpn\" } on-error={\r\
    \n\t     :put \"Error: cannot add peer for \$ServerAddress\"\r\
    \n\t\t :put \"Rollback previous action\"\r\
    \n\t\t :do {/ip ipsec mode-config remove [find name=\"mconf-\$PeerName-aut\
    oscript-vpn\" responder=no ] } on-error={}\r\
    \n\t\t :do {/ip ipsec policy remove [find group=\"group-\$PeerName-autoscr\
    ipt-vpn\" proposal=\"prop-\$PeerName-autoscript-vpn\" template=yes dst-add\
    ress=\"0.0.0.0/0\" src-address=\"0.0.0.0/0\"] } on-error={}\r\
    \n\t\t :do {/ip ipsec policy group remove [find name=\"group-\$PeerName-au\
    toscript-vpn\"] } on-error={}\r\
    \n\t\t :do {/ip ipsec proposal remove [find name=\"prop-\$PeerName-autoscr\
    ipt-vpn\" pfs-group=none]} on-error={}\r\
    \n\t\t :do {/ip ipsec profile remove [find name=\"prof-\$PeerName-autoscri\
    pt-vpn\"]} on-error={}\r\
    \n\t     :set err \"true\"}\r\
    \n\t:do {/ip ipsec identity add comment=\"IKEv2-strongswan-autoscript-vpn\
    \" auth-method=digital-signature certificate=\"\$PeerCertFile_1\" generate\
    -policy=port-strict mode-config=\"mconf-\$PeerName-autoscript-vpn\" peer=\
    \"peer-\$PeerName-autoscript-vpn\" policy-template-group=\"group-\$PeerNam\
    e-autoscript-vpn\" } on-error={\r\
    \n\t     :put \"Error: cannot add identity for peer peer-\$PeerName-autosc\
    ript-vpn\"\r\
    \n\t\t :put \"Rollback previous action\"\r\
    \n\t\t :do {/ip ipsec peer remove [find address=\"\$ServerAddress/32\" exc\
    hange-mode=ike2 name=\"peer-\$PeerName-autoscript-vpn\" profile=\"prof-\$P\
    eerName-autoscript-vpn\" ] } on-error={}\r\
    \n\t\t :do {/ip ipsec mode-config remove [find name=\"mconf-\$PeerName-aut\
    oscript-vpn\" responder=no ] } on-error={}\r\
    \n\t\t :do {/ip ipsec policy remove [find group=\"group-\$PeerName-autoscr\
    ipt-vpn\" proposal=\"prop-\$PeerName-autoscript-vpn\" template=yes dst-add\
    ress=\"0.0.0.0/0\" src-address=\"0.0.0.0/0\"] } on-error={}\r\
    \n\t\t :do {/ip ipsec policy group remove [find name=\"group-\$PeerName-au\
    toscript-vpn\"] } on-error={}\r\
    \n\t\t :do {/ip ipsec proposal remove [find name=\"prop-\$PeerName-autoscr\
    ipt-vpn\" pfs-group=none]} on-error={}\r\
    \n\t\t :do {/ip ipsec profile remove [find name=\"prof-\$PeerName-autoscri\
    pt-vpn\"]} on-error={}\r\
    \n\t     :set err \"true\"}\r\
    \n\t:if (\$err = \"true\") do={:error \"Script finished with errors\"}\r\
    \n\t:put \"Script finished\"\r\
    \n\r\
    \n\t/system script\r\
    \n\t:do {remove [find name=\"remove-peer-\$PeerName\"] } on-error={}\r\
    \n\t:do {add dont-require-permissions=no name=\"remove-peer-\$PeerName\" o\
    wner=admin policy=\\\r\
    \n\t\tftp,reboot,read,write,policy,test,password,sniff,sensitive,romon sou\
    rce=\"\\\r\
    \n\t\t\\n #This script removes automatically created peer\\r\\\r\
    \n\t\t\\n\\r\\\r\
    \n\t\t\\n:put \\\"Starting remove-peer-\$PeerName\\\"\\r\\\r\
    \n\t\t\\n/ip ipsec policy remove [find group=\\\"group-\$PeerName-autoscri\
    pt-vpn\\\" proposal=\\\"prop-\$PeerName-autoscript-vpn\\\" template=yes ds\
    t-address=\\\"0.0.0.0/0\\\" src-address=\\\"0.0.0.0/0\\\"]\\r\\\r\
    \n\t\t\\n/ip ipsec identity remove [find auth-method=digital-signature cer\
    tificate=\\\"\$PeerCertFile_1\\\" generate-policy=port-strict mode-config=\
    \\\"mconf-\$PeerName-autoscript-vpn\\\" peer=\\\"peer-\$PeerName-autoscrip\
    t-vpn\\\" policy-template-group=\\\"group-\$PeerName-autoscript-vpn\\\"]\\\
    r\\\r\
    \n\t\t\\n/ip ipsec peer remove [find address=\\\"\$ServerAddress/32\\\" ex\
    change-mode=ike2 name=\\\"peer-\$PeerName-autoscript-vpn\\\" profile=\\\"p\
    rof-\$PeerName-autoscript-vpn\\\" ]\\r\\\r\
    \n\t\t\\n/ip ipsec proposal remove [find name=\\\"prop-\$PeerName-autoscri\
    pt-vpn\\\" pfs-group=none]\\r\\\r\
    \n\t\t\\n/ip ipsec policy group remove [find name=\\\"group-\$PeerName-aut\
    oscript-vpn\\\"]\\r\\\r\
    \n\t\t\\n/ip ipsec profile remove [find name=\\\"prof-\$PeerName-autoscrip\
    t-vpn\\\"]\\r\\\r\
    \n\t\t\\n/ip ipsec mode-config remove [find name=\\\"mconf-\$PeerName-auto\
    script-vpn\\\" responder=no ]\\r\\\r\
    \n\t\t\\n/certificate remove [find name=\$PeerCertFile_1]\\r\\\r\
    \n\t\t\\n/certificate remove [find name=\$PeerCertFile_0]\\r\\\r\
    \n\t\t\\n/system script remove [find name=\\\"remove-peer-\$PeerName\\\"]\
    \\r\\\r\
    \n        \\n:put \\\"Script finished\\\"\" } on-error={\r\
    \n\t\t     put \"Error: cannot add rollback script removePeer\"}\r\
    \n\t:put \"Rollback script removePeer created\"\r\
    \n}"
