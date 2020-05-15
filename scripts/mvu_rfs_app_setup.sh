#!/bin/sh


#################################################################
# This script is created for the purpose of excising the UVRFS 
# related demos provided Rocket Software Multi-Value University.
#################################################################

# check the usage
if [ "$1" != "install" -a "$1" != "clean" ] 
then
   echo "Usage $0 [install | clean ]"
   exit 1
fi

# check if UniVerse is installed
if [ ! -f /.uvhome ]
then
   echo "It appears that this machine does not have an UniVerse installation."
   exit 1
fi

# check if the installation has 'showuv'
#
uvhomedir=`cat /.uvhome`

if [ ! -f $uvhomedir/bin/showuv ]
then
   echo "Unable to find the UniVerse bin/showuv."
   exit 1
fi


# run showuv to see if 'uvsm' ( the main UVRFS daemon process) is running
uvsm=`$uvhomedir/bin/showuv | grep uvsm | grep -v uvsmm -v`
if [ "$uvsm" = "" ]
then
   echo "Please start UV-12.1.1 database and try this script again."
   exit 1

fi

# check if the current directory has VOC file
if [ ! -f VOC -o ! -d BP ]
then
   echo "Unable to find the VOC file or BP directory under the current directory."
   exit 1
fi

if [ "$1" = "clean" ] 
then

   echo "Deleting PA START_2_000_000"
   UVdelete VOC START_2_000_000

   echo "Deleting PA START_2_050_010"
   UVdelete VOC START_2_050_010

   echo "Deleting PA START_2_500_010"
   UVdelete VOC START_2_500_010

   echo "Deleting PA START_4_000_000"
   UVdelete VOC START_4_000_000

   echo "Deleting PA START_4_050_010"
   UVdelete VOC START_4_050_010

   echo "Deleting PA START_4_500_010"
   UVdelete VOC START_4_500_010

   echo "Deleting PA STOPTEST"
   UVdelete VOC STOPTEST

   echo "Removing BP/TESTBP"
   rm -f BP/TESTBP

   echo "Removing media_test.sh"
   rm -f media_test.sh

   if [ -f TEST1 -a -f D_TEST1 ] 
   then
       echo "Deleting TEST1"
       $uvhomedir/bin/delete.file TEST1
   fi

   if [ -f TEST2 -a -f D_TEST2 ] 
   then
       echo "Deleting TEST2"
       $uvhomedir/bin/delete.file TEST2
   fi

   if [ -f TEST3 -a -f D_TEST3 ] 
   then
       echo "Deleting TEST3"
       $uvhomedir/bin/delete.file TEST3
   fi

   if [ -f TEST4 -a -f D_TEST4 ] 
   then
       echo "Deleting TEST4"
       $uvhomedir/bin/delete.file TEST4
   fi

   echo "Cleaned."
   exit 0
fi

if [ -f TEST1 -o -f D_TEST1 ] 
then
   echo "TEST1 exists"
   exit 1 
fi

if [ -f TEST2 -a -f D_TEST2 ] 
then
   echo "TEST2 exists"
   exit 1 
fi

if [ -f TEST3 -a -f D_TEST3 ] 
then
   echo "TEST3 exists"
   exit 1 
fi

if [ -f TEST4 -a -f D_TEST4 ] 
then
   echo "TEST4 exists"
   exit 1 
fi

echo "Creating the data files..."
$uvhomedir/bin/create.file TEST1 7 200009 2
$uvhomedir/bin/create.file TEST2 7 200009 2
$uvhomedir/bin/create.file TEST3 7 200009 2
$uvhomedir/bin/create.file TEST4 7 200009 2

echo "Extracting the shell script 'media_test.sh' for media-recovery..."
cat <<- EndOfProgram > media_test.sh
#!/bin/sh

uv -admin -stop

#
# Reinitialize the logging system.
#
echo y | uvcntl_install

uv -admin -start

clear.file TEST1
clear.file TEST2
clear.file TEST3
clear.file TEST4

printf "SELECT VOC WITH @ID LIKE 'A...'\nCOPY FROM VOC TO TEST1\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'B...'\nCOPY FROM VOC TO TEST2\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'C...'\nCOPY FROM VOC TO TEST3\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'D...'\nCOPY FROM VOC TO TEST4\nY\n" | uvsh

printf "COUNT TEST1\n" | uvsh
printf "COUNT TEST2\n" | uvsh
printf "COUNT TEST3\n" | uvsh
printf "COUNT TEST4\n" | uvsh

#
# force the checkpoint
#
uvforcecp
#
# force to use the next archive: we will be given the next
# LSN of the archive. This LSN will be assoicated with the backup
#
echo "#################################################"
uvforcearch
echo "#################################################"
sleep 10

# now stop the database for making a cleanup backup
uv -admin -stop

#
# Now, we are ready to make the backup:
#
# make a clean system backup associated with the LSN
# number that uvforcearch reported.
#

if [ -d ../XDEMO.backup ]
then
    rm -rf ../XDEMO.backup
fi

cp -rfp ../XDEMO ../XDEMO.backup


#
# bring the system up after the backup
#
uv -admin -start


#
# adding more reocrds to files
# 
printf "SELECT VOC WITH @ID LIKE 'O...'\nCOPY FROM VOC TO TEST1\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'P...'\nCOPY FROM VOC TO TEST2\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'Q...'\nCOPY FROM VOC TO TEST3\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'R...'\nCOPY FROM VOC TO TEST4\nY\n" | uvsh

printf "COUNT TEST1\n" | uvsh
printf "COUNT TEST2\n" | uvsh
printf "COUNT TEST3\n" | uvsh
printf "COUNT TEST4\n" | uvsh

delete.file TEST3
delete.file TEST4

#
# recreate TEST3 and TEST4, and add more records into it
#
create.file TEST3 7 200009 2 
create.file TEST4 7 200009 2 

printf "SELECT VOC WITH @ID LIKE 'E...'\nCOPY FROM VOC TO TEST3\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'T...'\nCOPY FROM VOC TO TEST3\nY\n" | uvsh

printf "SELECT VOC WITH @ID LIKE 'D...'\nCOPY FROM VOC TO TEST4\nY\n" | uvsh
printf "SELECT VOC WITH @ID LIKE 'R...'\nCOPY FROM VOC TO TEST4\nY\n" | uvsh

#
# delete some records in TEST1
#
printf "SELECT TEST1 WITH @ID LIKE 'A...'\nDELETE TEST1\nY\n" | uvsh

printf "COUNT TEST1\n" | uvsh
printf "COUNT TEST2\n" | uvsh
printf "COUNT TEST3\n" | uvsh
printf "COUNT TEST4\n" | uvsh

EndOfProgram


echo "Extracting the BASIC programes ..."
cat <<- EndOfProgram > BP/TESTBP
SENT  = SENTENCE()
PARAM = CONVERT(' ', @FM, TRIM( SENT, ' ', 'D'))

NFILES  = PARAM<4> 
UPDPERM = PARAM<5>
DELPERM = PARAM<6>

CRT "NFILES=":NFILES:",UPDPERM=":UPDPERM:",DELPERM=":DELPERM

KEYBASE = 10000000
KEYFROM = 1
KEYMAX  = 1000000

COUNT   = 0

DIM FP(4)

FOR I=1 TO NFILES
  OPEN '','TEST':I TO FP(I) ELSE STOP "Unable to open TEST":I
NEXT

SEED=@USERNO

IF SEED < 0 THEN
  SEED = -SEED  
END
RANDOMIZE SEED

LOOP 

  COUNT = COUNT + 1

  IF MOD(COUNT, 2048) = 0 THEN
      READ BODY FROM FP(1), 'CONTROL' THEN
         IF (BODY='STOP') THEN
             CRT "STOP request detected, exiting..."
             STOP
         END
      END 
  END

  ** select the file
  N = RND(NFILES) + 1 

  F = FP(N)

  N = RND(KEYMAX) + KEYFROM
  KEY = N

  READ BODY FROM F, KEY THEN
      IF RND(1000) < UPDPERM THEN
         BODY<1> = BODY<1> + 1
         WRITE BODY TO F, KEY
      END

  END ELSE
      BODY<1>= 1
      BODY<2>= KEY
      BODY<3>= STR("*", 32 + MOD(COUNT,128))

      WRITE BODY TO F, KEY
  END


*  IF MOD(COUNT,512)=0 THEN
*     SLEEP 1
*  END

  IF MOD(COUNT, 1000) < DELPERM THEN
      DELETE F, KEY 
  END

REPEAT

END
EndOfProgram

chmod +x media_test.sh

$uvhomedir/bin/nbasic BP TESTBP

echo "Creating PA STOPTEST"
UVwrite VOC STOPTEST \
 PA \
 "" \
 "SH -c 'UVwrite TEST1 CONTROL STOP'" 


echo "Creating PA START_2_000_000"
UVwrite VOC START_2_000_000 \
 PA \
 ""  \
 "DISPLAY ----------------------" \
 "DISPLAY Test parameters:" \
 "DISPLAY           sessions =  3" \
 "" \
 "DISPLAY              files =  2" \
 "DISPLAY   update per-mille =  0" \
 "DISPLAY   delete per-mille =  0" \
 "DISPLAY ----------------------" \
 "DISPLAY" \
 "" \
 "SH -c 'UVwrite TEST1 CONTROL 0'" \
 "" \
 "PHANTOM RUN BP TESTBP 2 0 0" \
 "PHANTOM RUN BP TESTBP 2 0 0" \
 "PHANTOM RUN BP TESTBP 2 0 0" 

echo "Creating PA START_2_050_010"
UVwrite VOC START_2_050_010 \
 PA \
 ""  \
 "DISPLAY ----------------------" \
 "DISPLAY Test parameters:" \
 "DISPLAY           sessions =  3" \
 "" \
 "DISPLAY              files =  2" \
 "DISPLAY   update per-mille = 50" \
 "DISPLAY   delete per-mille = 10" \
 "DISPLAY ----------------------" \
 "DISPLAY" \
 "" \
 "SH -c 'UVwrite TEST1 CONTROL 0'" \
 "" \
 "PHANTOM RUN BP TESTBP 2 50 10" \
 "PHANTOM RUN BP TESTBP 2 50 10" \
 "PHANTOM RUN BP TESTBP 2 50 10" 

echo "Creating PA START_2_500_010"
UVwrite VOC START_2_500_010 \
 PA \
 ""  \
 "DISPLAY ----------------------" \
 "DISPLAY Test parameters:" \
 "DISPLAY           sessions =  3" \
 "" \
 "DISPLAY              files =  2" \
 "DISPLAY   update per-mille =500" \
 "DISPLAY   delete per-mille = 10" \
 "DISPLAY ----------------------" \
 "DISPLAY" \
 "" \
 "SH -c 'UVwrite TEST1 CONTROL 0'" \
 "" \
 "PHANTOM RUN BP TESTBP 2 500 10" \
 "PHANTOM RUN BP TESTBP 2 500 10" \
 "PHANTOM RUN BP TESTBP 2 500 10" 

echo "Creating PA START_4_000_000"
UVwrite VOC START_4_000_000 \
 PA \
 ""  \
 "DISPLAY ----------------------" \
 "DISPLAY Test parameters:" \
 "DISPLAY           sessions =  3" \
 "" \
 "DISPLAY              files =  4" \
 "DISPLAY   update per-mille =  0" \
 "DISPLAY   delete per-mille =  0" \
 "DISPLAY ----------------------" \
 "DISPLAY" \
 "" \
 "SH -c 'UVwrite TEST1 CONTROL 0'" \
 "" \
 "PHANTOM RUN BP TESTBP 4 0 0" \
 "PHANTOM RUN BP TESTBP 4 0 0" \
 "PHANTOM RUN BP TESTBP 4 0 0" 

echo "Creating PA START_4_050_010"
UVwrite VOC START_4_050_010 \
 PA \
 ""  \
 "DISPLAY ----------------------" \
 "DISPLAY Test parameters:" \
 "DISPLAY           sessions =  3" \
 "" \
 "DISPLAY              files =  4" \
 "DISPLAY   update per-mille = 50" \
 "DISPLAY   delete per-mille = 10" \
 "DISPLAY ----------------------" \
 "DISPLAY" \
 "" \
 "SH -c 'UVwrite TEST1 CONTROL 0'" \
 "" \
 "PHANTOM RUN BP TESTBP 4 50 10" \
 "PHANTOM RUN BP TESTBP 4 50 10" \
 "PHANTOM RUN BP TESTBP 4 50 10" 

echo "Creating PA START_4_500_010"
UVwrite VOC START_4_500_010 \
 PA \
 ""  \
 "DISPLAY ----------------------" \
 "DISPLAY Test parameters:" \
 "DISPLAY           sessions =  3" \
 "" \
 "DISPLAY              files =  2" \
 "DISPLAY   update per-mille =500" \
 "DISPLAY   delete per-mille = 10" \
 "DISPLAY ----------------------" \
 "DISPLAY" \
 "" \
 "SH -c 'UVwrite TEST1 CONTROL 0'" \
 "" \
 "PHANTOM RUN BP TESTBP 4 500 10" \
 "PHANTOM RUN BP TESTBP 4 500 10" \
 "PHANTOM RUN BP TESTBP 4 500 10" 


echo "Done."
exit 0

