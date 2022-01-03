# IPSec-IKE-v2-auto-script
**These scripts create\remove IPsec IKE v2 server and\or peers.**

1. _"Create-Server"_ is used to create server and server's CA certificate on mikrotik router.
2. _"Create-Client"_ is used to create client and client's certificate on mikrotik router.
3. _"Create-client (client side)"_ is used on client side mikrotik to create peer.
4. _"Remove-client (client side)"_ is used on client side mikrotik to remove peer.
5. _"Mikrotik-to-Strongswan"_ is used on client side mikrotik to create peer working with [StrongSwan IPSec ikev2 server](https://github.com/hwdsl2/setup-ipsec-vpn).
6. _"Mikrotik-to-Strongswan.rsc"_ (with extention .rsc) is identical to _"Mikrotik-to-Strongswan"_. The difference is that this script can be imported using CLI.

**HOW TO...**

**How to setup a IKE v2 server and create CA certificate.**

to do...

**How to create a client and create client's certificate.**

to do...

**How to setup a peer on client mikrotik router.**

to do...

**How to setup strongswan client on mikrotik router.**
1. Download "Mikrotik-to-Strongswan.rsc" on your mikrotik router  
    `/tool fetch url="https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/mikrotik-to-strongswan.rsc" mode=https dst-path=createPeer.rsc`
    Also you may download file manually and upload it to router.
2. Import script
    `/import createPeer.rsc`
    You may also copy content of [this page](https://raw.githubusercontent.com/mikrotik-user/IPSec-IKE-v2-auto-script/main/mikrotik-to-strongswan.rsc) and paste to a newly created script using GUI.
3. Edit script to modify the first three variables. These are:
   - :local CertFile "vpnclient.p12"    - holds name of your client's certificate
   - :local Password "passphrase"       - holds passphrase of your certificate file to import
   - :local ServerAddress "11.22.33.44" - IP address of strongswan server
4. Make sure you uploaded certificate file to you router. Run script.
     `/system script run createPeer`
     Or you may run it using GUI
5. Script creates new peer and a new rollback script named "removePeer". You can use it to rollback modifications made by "createPeer"

**How does it work.**

1. Add a new script on your mikrotik router (server side), give it apropriate name and set required permissions, then copy-and-paste content of "Create-Server", press "OK" to save you script. 
2. Do the same for another script but copy-and-paste content of "Create-Client". The first script will create IPSec IKE v2 server on your mikrotik, the second script will create IPSec peer when you run it. Both scripts generate certificates end export them on a flash.
3. Download both certificates to your PC and then upload to a mikrotik that is inteded to serve as a IPSec client. The way you transfer those two files doesnt matter.
4. Add a new script on your mikrotik router (client side) as described in point 1 using content of "Create-client (client side)"
5. Optionally add a script using content of "Remove-client (client side)" to remove client configuration when needed.
6. On a server side configure scripts' variables to use proper hostname, IP address, peer name and password. Save scripts and run them sequentially. Check your log output to see if script worked with no errors.
7. On a client side configure scripts' variables to use proper hostname, peer name and password. Save scripts and run them sequentially. Check your log output to see if script worked with no errors.
