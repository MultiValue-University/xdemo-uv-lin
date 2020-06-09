# Set up Master key as root, at OS prompt, run 
>uvregen -m SYSGEN

# Once the master key is set up, create the key store, as root, run
>encman -genkeystore

# Sample program to test Audit Data Change Capture with ADE data
# 
# Test Steps (recommended run as non-root user except when specified otherwise):
# 1. Set up: RUN BP AUD_DC_ENC_TEST 1, then exit session

> BASIC BP AUD_DC_ENC_TEST
> RUN BP AUD_DC_ENC_TEST 1

# 2. Configue: as root, at OS prompt, run "audman -config", add the following 4 lines (remove *):
# account=XDEMO:/nome3/MVU/XDEMO
# app1_events=DAT.BASIC.WRITE,DAT.BASIC.DELETE
# app1_events.file=XDEMO:ENC_FIELD
# app1_events.dataChange=on
# NOTE: CHANGE THE ABOVE PATH TO THE ACTUAL PATH ON YOUR TEST SYSTEM!!!

>audman -config
>audman -logtype seq

# 3. Test:   RUN BP AUD_DC_ENC_TEST 2, after test exit session
# YOU CAN RUN THE ABOVE TESTS MULTIPLE TIMES IN THE SAME SESSION

> RUN BP AUD_DC_ENC_TEST 2

# 4. decrypt the datachange data.
>audman -decryptDC -doutonly -mek @mygenkey "in-file" "out-file" 

# Cleanup:RUN BP AUD_DC_ENC_TEST 3 (in a new session)
> RUN BP AUD_DC_ENC_TEST 3
```
