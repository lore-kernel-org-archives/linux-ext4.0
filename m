From: Alex Tomas <alex@clusterfs.com>
Subject: [RFC] delayed allocation testing on node tom
Date: Fri, 01 Dec 2006 02:34:28 +0300
Message-ID: <m37ixcv58q.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:14032 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1031634AbWLAARy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 19:17:54 -0500
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.13.7/8.13.4) with ESMTP id kB11JAjb005491
	for <linux-ext4@vger.kernel.org>; Fri, 1 Dec 2006 04:19:10 +0300
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Node tom: 2 x PIII-1000MHz, 256MB RAM, SCSI HDD
===============================================

        : dd512w                               
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 12.46  10     551    32      525436  5 extents
EXT4    : 11.30  9      333    20      524416  5 extents
REISERFS: 12.55  7      418    20      525452  94 extents
JFS     : 11.88  6      370    72      525064  1 extents
XFS     : 11.52  4      482    24      524331  2 extents

        : dd512r                               
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 10.92  5      385    525012  0       5 extents
EXT4    : 10.37  6      390    524296  0       6 extents
REISERFS: 10.72  7      415    524992  32      94 extents
JFS     : 10.41  7      387    524288  0       1 extents
XFS     : 10.56  1      381    524288  1       2 extents

        : dd512rw                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 14.32  6      365    616     524336  5 extents
EXT4    : 11.29  8      253    8       524320  5 extents
REISERFS: 13.95  7      342    596     524360  94 extents
JFS     : 10.78  10     266    0       524304  1 extents
XFS     : 12.95  4      389    0       525137  2 extents

        : dd1024w                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 24.72  12     1109   84      1050824 9 extents
EXT4    : 22.27  13     679    44      1048816 10 extents
REISERFS: 25.23  10     830    36      1050860 215 extents
JFS     : 23.81  5      762    136     1050728 1 extents
XFS     : 22.46  11     991    44      1048657 3 extents

        : dd1024r                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 21.64  12     797    1050292 0       9 extents
EXT4    : 20.36  6      704    1048584 0       10 extents
REISERFS: 22.28  8      877    1050328 32      215 extents
JFS     : 20.61  6      712    1048576 0       1 extents
XFS     : 20.64  8      775    1048576 1       3 extents

        : dd1024rw                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 28.89  13     754    1636    1048660 9 extents
EXT4    : 22.05  13     549    12      1048632 10 extents
REISERFS: 27.74  12     723    1656    1048684 215 extents
JFS     : 21.82  12     523    0       1048608 1 extents
XFS     : 25.08  11     719    0       1050577 3 extents

        : dd2048w                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 50.73  15     2227   1160    2101664 17 extents
EXT4    : 44.39  20     1383   72      2097548 18 extents
REISERFS: 50.26  9      1720   68      2101676 457 extents
JFS     : 47.63  14     1511   264     2104988 1 extents
XFS     : 44.46  11     2037   68      2097275 5 extents

        : dd2048r                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 43.21  28     1509   2100892 0       17 extents
EXT4    : 40.70  24     1538   2097160 0       18 extents
REISERFS: 44.46  18     1725   2100992 32      457 extents
JFS     : 40.40  21     1547   2097152 0       1 extents
XFS     : 41.15  15     1564   2097152 1       5 extents

        : dd2048rw                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 57.08  27     1617   3644    2097292 17 extents
EXT4    : 44.20  17     1086   12      2097256 18 extents
REISERFS: 56.72  17     1435   3700    2097336 457 extents
JFS     : 43.91  22     1053   0       2097268 1 extents
XFS     : 49.93  21     1464   0       2100969 5 extents

        : kernuntar                            
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 56.68  4940   714    68      252020  
EXT4    : 54.59  4921   584    64      247488  
REISERFS: 54.68  4959   853    64      238164  
JFS     : 69.56  4975   677    804     288728  
XFS     : 74.06  5005   946    132     317247  

        : kernstat                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 2.97   9      12     5872    0       
EXT4    : 0.65   7      7      5900    0       
REISERFS: 0.90   7      45     2696    0       
JFS     : 6.31   5      43     12552   0       
XFS     : 2.49   11     62     6504    0       

        : kerncat                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 10.29  31     215    241624  0       
EXT4    : 6.89   23     189    238564  0       
REISERFS: 15.19  23     240    234744  0       
JFS     : 24.35  29     262    244596  0       
XFS     : 19.00  22     256    238548  0       

        : kernrm                               
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 4.84   8      95     9620    4656    
EXT4    : 1.65   6      105    6540    4656    
REISERFS: 3.13   4      252    2768    172     
JFS     : 32.63  7      151    14400   32360   
XFS     : 19.90  8      299    6632    82509   

        : kernuntar2                           
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 71.73  11525  1622   112     503940  
EXT4    : 66.10  11465  1308   124     494688  
REISERFS: 70.87  11697  2056   96      476340  
JFS     : 117.56 11224  1403   2196    587360  
XFS     : 115.13 11351  2048   132     639523  

        : kernstat2                            
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 7.06   10     21     11772   0       
EXT4    : 0.81   10     24     11808   0       
REISERFS: 2.07   10     83     5376    0       
JFS     : 18.71  20     95     24288   0       
XFS     : 5.95   10     120    13000   0       

        : kerncat2                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 22.92  48     413    483232  0       
EXT4    : 15.19  48     457    477080  0       
REISERFS: 40.80  47     504    469560  0       
JFS     : 66.97  62     449    489172  0       
XFS     : 45.11  43     498    477080  0       

        : kernrm2                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 10.80  8      207    19232   9516    
EXT4    : 2.49   6      240    13080   9260    
REISERFS: 6.38   13     585    5556    656     
JFS     : 79.09  19     309    27556   77888   
XFS     : 43.37  11     680    13140   179683  

        : dbench2                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 3.24   131    491    16      24576   Throughput 215.358 MB/sec 2 procs
EXT4    : 2.80   122    419    8       20480   Throughput 248.989 MB/sec 2 procs
REISERFS: 3.88   135    511    8       44344   Throughput 178.426 MB/sec 2 procs
JFS     : 6.32   128    435    112     34520   Throughput 108.894 MB/sec 2 procs
XFS     : 14.70  136    482    124     48213   Throughput 46.5866 MB/sec 2 procs

        : dbench4                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 6.68   256    980    32      70988   Throughput 206.344 MB/sec 4 procs
EXT4    : 5.99   258    809    20      69868   Throughput 230.938 MB/sec 4 procs
REISERFS: 8.40   284    1051   68      89416   Throughput 163.654 MB/sec 4 procs
JFS     : 19.06  256    855    384     97652   Throughput 71.8116 MB/sec 4 procs
XFS     : 29.57  250    958    124     124796  Throughput  46.302 MB/sec 4 procs

        : dbench8                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 13.80  512    1937   44      198740  Throughput 198.702 MB/sec 8 procs
EXT4    : 11.43  526    1624   16      180516  Throughput 239.848 MB/sec 8 procs
REISERFS: 16.34  537    2446   68      185584  Throughput 167.689 MB/sec 8 procs
JFS     : 43.56  509    1721   496     264100  Throughput  62.802 MB/sec 8 procs
XFS     : 62.73  480    1972   132     305359  Throughput 43.5861 MB/sec 8 procs

        : dbench16                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 32.49  1016   3947   27024   532724  Throughput 168.599 MB/sec 16 procs
EXT4    : 28.14  977    3372   44816   560820  Throughput 195.931 MB/sec 16 procs
REISERFS: 38.95  1006   4111   40552   677312  Throughput 140.962 MB/sec 16 procs
JFS     : 118.03 986    3465   40000   834684  Throughput  46.349 MB/sec 16 procs
XFS     : 184.68 1054   4036   38152   1234746 Throughput 29.5931 MB/sec 16 procs

        : dbench32                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 89.02  2043   7922   206316  1047732 Throughput 123.101 MB/sec 32 procs
EXT4    : 67.09  2034   6739   209948  1251076 Throughput 163.517 MB/sec 32 procs
REISERFS: 88.52  2045   8419   351340  1011324 Throughput 123.777 MB/sec 32 procs
JFS     : 418.67 1928   7093   1073704 1815412 Throughput 26.1018 MB/sec 32 procs
XFS     : 2268.5 2309   12829  1286852 5012589 Throughput 4.81441 MB/sec 32 procs

        : dbench64                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 686.82 4100   15908  3529592 3170776 Throughput 31.8135 MB/sec 64 procs
EXT4    : 225.88 4060   13545  1390120 2306412 Throughput 97.2635 MB/sec 64 procs
REISERFS: 472.18 4256   18977  3465188 2205780 Throughput 46.3041 MB/sec 64 procs
JFS     : 1561.6 4106   16303  6843768 5195952 Throughput 13.9881 MB/sec 64 procs
XFS     : 7555.0 4788   37838  6001616 13316997 Throughput2.89094 MB/sec 64 procs


thanks, Alex
