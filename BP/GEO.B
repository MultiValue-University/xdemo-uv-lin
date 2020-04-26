crt '* Geospatial Sample'
crt
c1 = -105
c2 = 39.7
c3 = 121.6
c4 = 38.9
ret = gcdistance(c2, c1, c4, c3)
crt 'GCDISTANCE(39.7, -105, 38.9, 121.6)'
crt 'distance = ':ret

END