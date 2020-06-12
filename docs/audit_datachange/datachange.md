# Set up ADE

>1. Set up Master key as root, at OS prompt, run .
>
>      ```
>      cd $UVHOME
>      bin/uvregen -m SYSGEN
>      ```
>
>2. Create the key store, as root, run
>
>      ```
>      cd $UVHOME
>      bin/encman -genkeystore
>      ```
>

# Sample program to test Audit Data Change Capture with ADE data

Test Steps (recommended run as non-root user except when specified otherwise):

1. Set up: RUN BP AUD_DC_ENC_TEST 1, then exit session

   ```
   bash-4.2$ cd XDEMO/
   bash-4.2$ $UVHOME/bin/uvsh
   
   > BASIC BP AUD_DC_ENC_TEST
   > RUN BP AUD_DC_ENC_TEST 1
   ```

2. Configue: as root, at OS prompt, run "audman -config", add the following 4 lines (remove #):

   ```
   # account=XDEMO:/nome3/MVU/XDEMO
   # app1_events=DAT.BASIC.WRITE,DAT.BASIC.DELETE
   # app1_events.file=XDEMO:ENC_FIELD
   # app1_events.dataChange=on
   
   * NOTE: CHANGE THE ABOVE PATH TO THE ACTUAL PATH ON YOUR TEST SYSTEM!!!
   ```

3. Change audit log type to Sequential type

   ```
   bash-4.2$ bin/audman -logtype seq
   ```

4. Test:   RUN BP AUD_DC_ENC_TEST 2, after test exit session

   ```
   bash-4.2$ $UVHOME/bin/uvsh
   > RUN BP AUD_DC_ENC_TEST 2
   ```

5. decrypt the datachange data.

   ```
   bash-4.2$ bin/audman -decryptDC -doutonly -mek @mygenkey "in-file" "out-file" 
   ```

6. Cleanup: RUN BP AUD_DC_ENC_TEST 3 (in a new session)

   ```
   bash-4.2$ $UVHOME/bin/uvsh
   > RUN BP AUD_DC_ENC_TEST 3
   ```

   