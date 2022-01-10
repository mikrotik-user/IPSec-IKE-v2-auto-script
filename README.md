# IPSec-IKE-v2-auto-script
**These scripts create\remove IPsec IKE v2 server and\or peers.**

1. _"IKEv2-server-autoscript.rsc"_ is an interactive script to create and manage IKEv2 server on mikrotik router.
2. _"IKEv2-peer-autoscript.rsc"_ is used on client-side mikrotik to create peer.
3. _"IKEv2-remove-peer-autoscript.rsc"_ is used on client side mikrotik to remove peer.
4. _"Mikrotik-to-Strongswan.rsc"_ is used on client-side mikrotik to create peer working with [StrongSwan IPSec ikev2 server](https://github.com/hwdsl2/setup-ipsec-vpn).

**HOW TO...**

**How to setup an IKE v2 server and create CA certificate.**
1. Download [IKEv2-server-autoscript.rsc](https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/IKEv2-server-autoscript.rsc) on your mikrotik router `/tool fetch url="https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/IKEv2-server-autoscript.rsc" mode=https dst-path=IKEv2-server-autoscript.rsc`. Also you may download [file](https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/IKEv2-server-autoscript.rsc) manually and upload it to router.
2. Import script `/import IKEv2-server-autoscript.rsc`. You may also copy content of [this page](https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/IKEv2-server-autoscript.rsc) and paste to a newly created script using GUI.
3. Run script via CLI. `/system script run IKEv2`
_**IMPORTANT: Script won't work if you run it via GUI.**_
4. Choose _**1. Install IKE v2 server**_ by typing "1"
5. Follow instructions on CLI

**How to create a client and create client's certificate. (Server-side)**
1. Run script via CLI. `/system script run IKEv2`
2. Choose _**2. Create peer**_ by typing "2"
3. Follow instructions on CLI

**How to setup a peer on client mikrotik router.**

to do...

**How to setup strongswan client on mikrotik router.**
1. Download "Mikrotik-to-Strongswan.rsc" on your mikrotik router  
    `/tool fetch url="https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/Mikrotik-to-Strongswan.rsc" mode=https dst-path=createPeer.rsc`
    Also you may download file manually and upload it to router.
2. Import script
    `/import createPeer.rsc`
    You may also copy content of [this page](https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/Mikrotik-to-Strongswan.rsc) and paste to a newly created script using GUI.
3. Edit script to modify the first three variables. These are:
   - :local CertFile "vpnclient.p12"    - holds name of your client's certificate
   - :local Password "passphrase"       - holds passphrase of your certificate file to import
   - :local ServerAddress "11.22.33.44" - IP address of strongswan server
4. Make sure you uploaded certificate file to you router. Run script.
     `/system script run createPeer`
     Or you may run it using GUI
5. Script creates new peer and a new rollback script named "removePeer". You can use it to rollback modifications made by "createPeer"
