From: Alex Tomas <alex@clusterfs.com>
Subject: [RFC] delayed allocation testing on node zefir
Date: Fri, 01 Dec 2006 03:16:15 +0300
Message-ID: <m3d574v592.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:13264 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1031633AbWLAARo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 19:17:44 -0500
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.13.7/8.13.4) with ESMTP id kB11Iww8005486
	for <linux-ext4@vger.kernel.org>; Fri, 1 Dec 2006 04:18:58 +0300
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Node zefir: 2 x PIII-933MHz, 896MB RAM, SCSI HDD
================================================


Test description:

    * dd512w - write 512MB
    * dd512r - read 512MB
    * dd512rw - rewrite 512MB
    * dd1024w - write 1024MB
    * dd1024r - read 1024MB
    * dd1024rw - rewrite 1024MB
    * dd2048w - write 2048MB
    * dd2048r - read 2048MB
    * dd2048rw - rewrite 2048MB
    * kernuntar - untar kernel
    * kernstat - stat kernel tree
    * kerncat - cat kernel tree to /dev/null
    * kernrm - remove kernel tree
    * kernuntar2 - 2 concurrent kernuntar
    * kernstat2 - 2 concurrent kernstat
    * kerncat2 - 2 concurrent kernstat
    * kernrm2 - 2 concurrent kernrm
    * dbench4 - dbench with 4 threads
    * dbench8 - dbench with 8 threads
    * dbench16 - dbench with 16 threads
    * dbench32 - dbench with 32 threads 

Legenda:

    * REAL    - how long a test took
    * UTIME   - how long it spent in userspace
    * STIME   - how long it spent in kernelspace
    * READ    - how many KBs were read
    * WRITTEN - how many KBs were written

    UTIME/STIME/READ/WRITTEN are gathered from /proc/stat
    so they include all system activity (important for
    delayed allocation)

Notes:

    * all filesystems are mounted with noatime
    * before every test, filesystem was recreated and
      remounted after preparation
    * reiserfs is mounted with notail option
    * ext3 is mounted with reservation,data=writeback
    * xfs is mounted with logbufs=8,logbsize=256k
    * ext4 is mounted with extents,mballoc,delalloc





        : dd512w                               
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 13.38  4      550    32      525436  5 extents
EXT4    : 11.21  7      286    12      524416  6 extents
REISERFS: 13.08  6      380    20      525420  94 extents
JFS     : 12.13  4      344    72      525028  1 extents
XFS     : 11.77  4      412    24      524311  2 extents

        : dd512r                               
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 10.31  4      350    524808  0       5 extents
EXT4    : 10.16  5      312    524296  0       5 extents
REISERFS: 10.71  6      379    524800  32      94 extents
JFS     : 10.08  4      332    524288  0       1 extents
XFS     : 10.29  7      362    524288  1       2 extents

        : dd512rw                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 14.03  13     352    520     524336  5 extents
EXT4    : 11.27  9      220    8       524308  5 extents
REISERFS: 14.07  6      309    512     524356  94 extents
JFS     : 11.51  2      247    0       524308  1 extents
XFS     : 13.00  5      331    0       525145  2 extents

        : dd1024w                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 25.74  11     1099   48      1050820 9 extents
EXT4    : 22.85  12     604    24      1048780 9 extents
REISERFS: 25.84  10     825    36      1050856 215 extents
JFS     : 24.58  11     698    136     1050980 1 extents
XFS     : 23.34  14     885    48      1048625 4 extents

        : dd1024r                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 20.73  17     698    1049756 0       9 extents
EXT4    : 20.32  9      661    1048584 0       10 extents
REISERFS: 21.72  14     793    1049716 32      215 extents
JFS     : 20.16  10     680    1048576 0       1 extents
XFS     : 20.71  8      709    1048576 1       4 extents

        : dd1024rw                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 28.45  19     700    1120    1048660 9 extents
EXT4    : 22.32  18     490    8       1048620 9 extents
REISERFS: 28.40  14     653    1152    1048684 215 extents
JFS     : 23.09  14     471    0       1048620 1 extents
XFS     : 25.55  8      672    0       1050377 4 extents

        : dd2048w                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 50.50  29     2285   92      2101632 17 extents
EXT4    : 44.95  18     1301   60      2097524 18 extents
REISERFS: 51.83  21     1668   68      2101596 457 extents
JFS     : 48.64  20     1491   264     2106388 1 extents
XFS     : 46.34  14     1867   92      2097246 7 extents

        : dd2048r                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 42.28  24     1388   2100156 0       17 extents
EXT4    : 40.73  18     1314   2097160 0       19 extents
REISERFS: 43.75  24     1658   2100188 32      457 extents
JFS     : 40.51  16     1359   2097152 0       1 extents
XFS     : 41.21  17     1483   2097152 1       7 extents

        : dd2048rw                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 58.46  23     1491   2572    2097292 17 extents
EXT4    : 44.56  19     1018   12      2097244 19 extents
REISERFS: 56.80  26     1370   2952    2097336 457 extents
JFS     : 45.77  22     984    0       2097216 1 extents
XFS     : 50.97  20     1394   0       2100825 7 extents

        : kernuntar                            
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 56.99  5037   651    68      252016  
EXT4    : 55.03  5034   553    36      249884  
REISERFS: 52.55  4996   854    64      238068  
JFS     : 70.15  5057   630    496     288116  
XFS     : 72.84  5052   953    132     316798  

        : kernstat                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 2.83   8      15     5892    0       
EXT4    : 0.51   9      10     5892    0       
REISERFS: 0.81   7      49     2696    0       
JFS     : 6.19   11     49     12552   0       
XFS     : 2.09   9      61     6504    0       

        : kerncat                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 9.48   25     213    241624  0       
EXT4    : 6.29   27     197    238560  0       
REISERFS: 14.69  33     230    234744  0       
JFS     : 23.51  23     231    244596  0       
XFS     : 18.24  36     254    238548  0       

        : kernrm                               
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 4.82   4      108    9628    4672    
EXT4    : 1.61   5      110    6536    4632    
REISERFS: 3.15   8      276    2768    236     
JFS     : 33.90  7      168    14400   33048   
XFS     : 20.03  8      296    6632    86160   

        : kernuntar2                           
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 72.83  11552  1512   108     503844  
EXT4    : 66.72  11489  1208   60      497732  
REISERFS: 70.27  11570  2146   100     476300  
JFS     : 104.55 11222  1426   504     586860  
XFS     : 108.03 11333  2008   132     636157  

        : kernstat2                            
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 6.73   12     17     11756   0       
EXT4    : 0.73   6      20     11808   0       
REISERFS: 1.93   8      92     5424    0       
JFS     : 17.85  17     108    24264   0       
XFS     : 5.08   20     113    13000   0       

        : kerncat2                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 24.17  50     422    483236  0       
EXT4    : 14.54  46     426    477108  0       
REISERFS: 42.82  59     511    469488  0       
JFS     : 61.48  63     444    488396  0       
XFS     : 46.63  60     540    477072  0       

        : kernrm2                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 11.01  6      184    19232   9528    
EXT4    : 2.44   13     250    13072   9228    
REISERFS: 6.76   7      625    5564    520     
JFS     : 79.88  15     322    27516   74848   
XFS     : 44.28  13     691    13140   186428  

        : dbench2                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 3.22   125    499    16      0       Throughput 215.813 MB/sec 2 procs
EXT4    : 2.76   132    404    8       0       Throughput 251.927 MB/sec 2 procs
REISERFS: 3.69   130    506    12      6048    Throughput 187.573 MB/sec 2 procs
JFS     : 5.38   119    441    100     10196   Throughput 127.945 MB/sec 2 procs
XFS     : 13.86  125    490    116     23966   Throughput 49.4258 MB/sec 2 procs

        : dbench4                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 6.18   276    937    28      5368    Throughput 222.623 MB/sec 4 procs
EXT4    : 5.35   291    759    12      4280    Throughput 258.937 MB/sec 4 procs
REISERFS: 7.84   298    1023   40      66992   Throughput 175.719 MB/sec 4 procs
JFS     : 17.43  283    805    372     33144   Throughput 78.5572 MB/sec 4 procs
XFS     : 27.82  247    1007   132     55062   Throughput 49.15 MB/sec 4 procs

        : dbench8                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 12.37  538    1897   48      97972   Throughput 221.759 MB/sec 8 procs
EXT4    : 10.78  524    1575   12      107252  Throughput 255 MB/sec 8 procs
REISERFS: 15.54  611    2315   76      145652  Throughput 176.266 MB/sec 8 procs
JFS     : 40.23  538    1681   492     189276  Throughput 68.0126 MB/sec 8 procs
XFS     : 61.33  561    1951   132     272619  Throughput 44.589 MB/sec 8 procs

        : dbench16                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 26.85  1078   3789   76      319480  Throughput 203.867 MB/sec 16 procs
EXT4    : 22.76  1101   3107   20      315268  Throughput 240.433 MB/sec 16 procs
REISERFS: 36.40  1072   4546   104     411336  Throughput 150.273 MB/sec 16 procs
JFS     : 86.47  1065   3364   496     483656  Throughput 63.2243 MB/sec 16 procs
XFS     : 133.00 1139   3770   132     585088  Throughput 41.0857 MB/sec 16 procs

        : dbench32                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 57.77  2209   7515   140     835524  Throughput 189.412 MB/sec 32 procs
EXT4    : 48.72  2201   6271   56      826776  Throughput 224.498 MB/sec 32 procs
REISERFS: 87.57  2107   7730   124     1217700 Throughput 124.844 MB/sec 32 procs
JFS     : 191.00 2099   6796   504     1034920 Throughput 57.2123 MB/sec 32 procs
XFS     : 2125.3 2422   12529  140     4601881 Throughput 5.13852 MB/sec 32 procs

        : dbench64                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 137.50 4373   15334  110000  1953432 Throughput 159.002 MB/sec 64 procs
EXT4    : 110.76 4404   12868  159076  2175932 Throughput 197.71 MB/sec 64 procs
REISERFS: 365.08 4164   16814  286200  4924032 Throughput 59.9278 MB/sec 64 procs
JFS     : 458.58 4257   13818  118196  2280152 Throughput 47.6528 MB/sec 64 procs
XFS     : 6781.9 5089   34484  155344  12020653 Throughput 3.22044 MB/sec 64 procs


thanks, Alex
