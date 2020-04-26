crt '* ICONV Samples:'

data = '2019-08-16 12:59:00.123'
ccode = 'DT'
gosub test1

data = '16 Aug 2019 12:59'
ccode = 'DTM'
gosub test1

data = '08 16 2019 12:59'
ccode = 'DT4'
gosub test1

data = '12:59:59'
ccode = 'DTTS'
gosub test1

data = '08/16/2019 12:59:59'
ccode = 'DT;D/;MTS'
gosub test1

data = '16 AUG 2019'
ccode = 'DT;D'
gosub test1

data = '08/16/2019 14:59:59'
ccode = 'DT;D/;MTS;America/New_York'
gosub test1


data = "1970-01-01 00:00:00Z"
ccode = "DT"
gosub test1

data = '2000-08-10 13:00:00.123'
ccode = 'DT;America/Denver'
gosub test1

data = '1970-W01-4 12:00:00Z'
ccode = 'DTIZ'
gosub test1

data = '1969-12-31 23:59:59.100-01:05'
ccode = 'DTI'
gosub test1

data = '2019-124 11:00:00'
ccode = 'DTI;America/Denver'
gosub test1

data = '14 Aug 2019 12:24 +0000'
ccode = 'DTW'
gosub test1

data = 'Wed 14 Aug 2019 12:24 +0000'
ccode = 'DTW'
gosub test1

data = 'Wed 14 Aug 2019 12:24 +0000'
ccode = 'DTW;America/Denver'
gosub test1

crt '* OCONV Samples:'

data = 0 
ccode = "DTI"
gosub test2

data = -2190728990000
ccode = "DTIZ"
gosub test2

data = 1556150583123
ccode = 'DTIBZ'
gosub test2

data = -2190728990000
ccode = 'DTIBSZ'
gosub test2

data = 0
ccode = 'DTI;+08:00'
gosub test2

data = 1556150583123
ccode = 'DTI;Asia/Tokyo'
gosub test2

data = 0
ccode = 'DTIWZ'
gosub test2

data = 1566144000000
ccode = 'DT;D'
gosub test2

crt '* Datetime functions'
crt 'NOW() = ':NOW()
crt 'TODATETIME(DATE(), TIME()) = ':TODATETIME(DATE(), TIME())
crt 'TODATE(NOW()) = ':TODATE(NOW())
crt 'TOTIME(NOW()) = ':TOTIME(NOW())
crt 'DATETIMEL() = ':DATETIMEL()
crt 'DATETIMEZ() = ':DATETIMEZ()
crt


crt '* @TZ Sample'
crt
crt '@TZ is not set'
data = '1970-01-01 00:00:00'
ccode = 'DTI'
gosub test1

crt '@TZ is set to Asia/Shanghai'
@TZ = 'Asia/Shanghai'
data = '1970-01-01 00:00:00'
ccode = 'DTI'
gosub test1

RETURN

test1:
    ret = ICONV(data, ccode)
    crt 'data = ':data
    crt 'ccode = ':ccode
    crt 'ret = ':ret
    crt
    RETURN

test2:
    ret = OCONV(data, ccode)
    crt 'data = ':data
    crt 'ccode = ':ccode
    crt 'ret = ':ret
    crt
    RETURN

end