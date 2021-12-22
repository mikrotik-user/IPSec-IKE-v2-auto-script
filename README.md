# IPSec-IKE-v2-auto-script
This script creates IPsec IKE v2 server and\or peers

How does it work.

1. Add a new script on your mikrotik router (server side), give it apropriate name and set required permissions, then copy-and-paste content of "Create-Server", press "OK" to save you script. 
2. Do the same for another script but copy-and-paste content of "Create-Client". The first script will create IPSec IKE v2 server on your mikrotik, the second script will create IPSec peer when you run it. Both scripts generate certificates end export them on a flash.
3. Download both certificates to your PC and then upload to a mikrotik that is inteded to serve as a IPSec client. The way you transfer those two files doesnt matter.
4. Add a new script on your mikrotik router (client side) as described in point 1 using content of "Create-client (client side)"
5. Optionally add a script using content of "Remove-client (client side)" to remove client configuration when needed.
6. On a server side configure scripts' variables to use proper hostname, IP address, peer name and password. Save scripts and run them sequentially. Check your log output to see if script worked with no errors.
7. On a client side configure scripts' variables to use proper hostname, peer name and password. Save scripts and run them sequentially. Check your log output to see if script worked with no errors.
