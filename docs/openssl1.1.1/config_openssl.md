# Turn on TLS1.3 in uvconfig file

SSL_PROTOCOLS   TLSv1,TLSv1.1,TLSv1.2,TLSv1.3

# Experience new feature

#Prepared files such as encrypted files for digest and certificates and private keys used for secure socket test

```
XDEMO/certs
XDEMO/digest.txt
```

CASE 1. For TLS1.3 feature, run CallHttp (SEC_TLS13) .

```
bash-4.2$ cd XDEMO/
bash-4.2$ #UVHOME/bin/uvsh

>BASIC BP SEC_TLS13
>RUN BP SEC_TLS13
```

CASE 2. For TLS1.3 feature, run secure socket (SEC_SOCKET and SEC_CLIENT).

```
#First run SEC_CREATE.CTX to create CTX.
>BASIC BP SEC_CREATE.CTX
>RUN BP SEC_CREATE.CTX

#start two uv sessions run client and server socket
>BASIC BP SEC_SOCKET
>BASIC BP SEC_CLIENT
>RUN BP SEC_SOCKET
>RUN BP SEC_CLIENT
```

CASE 3. For SHA3 support, you can run SEC_DIGEST.

```
BASIC BP SEC_DIGEST
RUN BP SEC_DIGEST
```

#Verify the protocolLogging

```
#in the XDEMO
tls13.log
clnt.log
svr.log
createctx.log
```