# IKEv2 Installation

Ubuntu 16.04 - Install and setup gateway

* StrongSwan (VPN IKEv2 Server)
* Dante (SOCKS Proxy)
* Squid (HTTP/S Proxy)

## Usage

Run the following to setup gateway:

```
bash <(wget -qO- https://github.com/OreinSoft/IKEv2Setup/raw/master/setupAll.sh) user_name user_pass strongSwanIP squidPort danteInterface dantePort
```
Don't forget to change your user_name, user_pass, strongSwanIP as per your credentials <br/>
After setup completed check ssh connection, if connect is ok run the following commands

```
netfilter-persistent save
netfilter-persistent reload
```
