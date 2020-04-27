# How to config replication

1. Prepare two machines and install UV on both of them.

2. Copy [repsys](repsys) and [repconfig](repconfig) under `docs/replication/` to UV installation root directory. (please configure step 2-4 on both machines).

3. Find and edit repsys

    * change `pub_hostname_or_ip` to your real hostname or IP of the publisher machine.
    * change `sub_hostname_or_ip` to your real hostname or IP of the subscriber machine.

4. Restart UV
    ```
    cd bin
    ./uv -admin -stop
    ./uv -admin -start
    ```
    Now you can run `uv_repadmin report` to verify if the publisher and subscriber are in synchronized status.

    ```
    ./uv_repadmin report
    ```

# Experience new feature

Run below steps only on the publisher to experience the new feature replication of sequentail I/O in UV 11.3.2

Go to sample account XDEMO and run below commands

```
bash-4.2$ cd XDEMO/
bash-4.2$ ../bin/uv

> BASIC BP REP_WRITESEQ
> BASIC BP REP_WRITESEQ_BUF
> RUN BP REP_WRITESEQ
> RUN BP REP_WRITESEQ_BUF
```