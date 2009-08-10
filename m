From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC -V2 0/4] mballoc patches for ext4
Date: Sun,  9 Aug 2009 23:23:51 -0400
Message-ID: <1249874635-24250-1-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42150 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbZHJDYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:24:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series adds better debugging support for mballoc, but the
main goal was to improve how small files are allocated.

These patches could use some testing and benchmarking; I suspect we will
a slight increase the CPU required to read and write small files, but
hopefully it won't be significant enough to be significantly
noticeable.  More seriously, the hueristics that try to detect lock
contention and so we go back to using per-cpu group preallocation
extents may need some tuning.  We may also want to change the group
preallocation code so that instead of requiring an aligned extent of 512
blocks which is completely unused, that a partially used extent can also
be used for group preallocation.

I used the attached test script, named test-allocate, to demonstrate the
benefits of the last two patches in this patch series.  (The first two
simply add better debugging and make the flags field in mb_history
easier to understand.)  Without the last two patches applied, the
results of a (bug-fixed) e2freefrag looks like this:

Device: /dev/sdc1
Blocksize: 1024 bytes
Total blocks: 5237156
Free blocks: 5117184 (97.7%)

Min. free extent: 5 KB 
Max. free extent: 128992 KB
Avg. free extent: 85286 KB

HISTOGRAM OF FREE EXTENT SIZES:
Chunk Size Range :   Free chunks   Free Blocks  Percent
    4K...    8K- :             1             5    0.00%
    8K...   16K- :             1            11    0.00%
   16K...   32K- :             2            44    0.00%
  128K...  256K- :             1           235    0.00%
  256K...  512K- :             1           407    0.01%
    4M...    8M- :             5         30268    0.59%
    8M...   16M- :             5         79723    1.56%
   16M...   32M- :             2         46795    0.91%
   32M...   64M- :             3        153014    2.99%
   64M...  128M- :            39       4806682   93.93%

With the full patch series applied the e2freefrag output looks like
this:

Device: /dev/sdc1
Blocksize: 1024 bytes
Total blocks: 5237156
Free blocks: 5117184 (97.7%)

Min. free extent: 1 KB 
Max. free extent: 128992 KB
Avg. free extent: 88227 KB

HISTOGRAM OF FREE EXTENTS SIZES:
Chunk Size Range :   Free chunks   Free Blocks  Percent
    1K...    2K- :             2             2    0.00%
    2K...    4K- :             1             3    0.00%
    4K...    8K- :             1             5    0.00%
    4M...    8M- :             5         30268    0.59%
    8M...   16M- :             5         80415    1.57%
   16M...   32M- :             2         46795    0.91%
   32M...   64M- :             3        153014    2.99%
   64M...  128M- :            39       4806682   93.93%

Compare the histogram of the sub-megabyte free chunks.

Here is the before output of mb_history:

pid   inode    original                goal                    result                  found grps  cr flags  merge tail  broken
1920  513      0/0/1@0                 0/0/1@0                 0/2371/1@0              1     1     1  0x0000       0     0     
398   12       1/0/3@0                 0/0/512@0               1/512/512@0             1     1     0  0x04a0       0     0     
398   13       1/0/5@0                                         1/515/5@0              
398   14       1/0/7@0                                         1/520/7@0              
398   15       1/0/11@0                                        1/527/11@0             
398   16       1/0/13@0                                        1/538/13@0             
398   17       1/0/15@0                                        1/551/15@0             
398   19       1/0/5@0                                         1/566/5@0              
398   20       1/0/7@0                                         1/571/7@0              
398   21       1/0/11@0                                        1/578/11@0             
398   22       1/0/13@0                                        1/589/13@0             
398   23       1/0/15@0                                        1/602/15@0             
1933  18       1/0/3@0                 1/512/512@0             1/1024/512@0            1     1     0  0x04a0       512   1024  
398   13       1/0/2@0                                         1/1027/2@0             
398   15       1/0/3@0                                         1/1029/3@0             
398   17       1/0/5@0                                         1/1032/5@0             
398   19       1/0/6@0                                         1/1037/6@0             
398   21       1/0/9@0                                         1/1043/9@0             
398   22       1/0/6@0                                         1/1052/6@0             
398   24       1/0/2@0                                         1/1058/2@0             
398   25       1/0/3@0                                         1/1060/3@0             
398   26       1/0/5@0                                         1/1063/5@0             
398   27       1/0/6@0                                         1/1068/6@0             
398   28       1/0/9@0                                         1/1074/9@0             
398   29       1/0/6@0                                         1/1083/6@0             
.... and here is the after:

pid   inode    original                goal                    result                  found grps  cr flags  merge tail  broken
1825  513      0/0/1@0                 0/0/1@0                 0/2371/1@0              1     1     1  0x0000       0     0     
397   12       1/0/3@0                 1/0/3@0                 1/277/3@0               1     1     1  0x0460       0     0     
397   13       1/0/5@0                 1/0/5@0                 1/280/5@0               9     1     1  0x0460       5     8     
397   14       1/0/7@0                 1/0/7@0                 1/285/7@0               8     1     1  0x0460       4     32    
397   15       1/0/11@0                1/0/11@0                1/292/11@0              9     1     1  0x0460       7     8     
397   16       1/0/13@0                1/0/13@0                1/303/13@0              8     1     1  0x0460       12    16    
397   17       1/0/15@0                1/0/15@0                1/316/15@0              7     1     1  0x0460       11    64    
397   18       1/0/3@0                 1/0/3@0                 1/331/3@0               9     1     1  0x0460       2     4     
397   19       1/0/5@0                 1/0/5@0                 1/334/5@0               8     1     1  0x0460       3     16    
397   20       1/0/7@0                 1/0/7@0                 1/339/7@0               8     1     1  0x0460       2     8     
397   21       1/0/11@0                1/0/11@0                1/346/11@0              7     1     1  0x0460       5     32    
397   22       1/0/13@0                1/0/13@0                1/357/13@0              7     1     1  0x0460       2     16    
397   23       1/0/15@0                1/0/15@0                1/370/15@0              6     1     1  0x0460       1     128   
1853  13       1/0/2@0                 1/0/2@0                 1/300/2@0               1     1     0  0x0460       0     0     
1853  15       1/0/3@0                 1/0/3@0                 1/328/3@0               8     1     1  0x0460       0     0     
1853  17       1/0/5@0                 1/0/5@0                 1/280/5@0               1     1     1  0x0460       0     0     
1853  19       1/0/6@0                 1/0/6@0                 1/346/6@0               5     1     1  0x0460       0     0     
1853  21       1/0/9@0                 1/0/9@0                 1/316/9@0               11    1     1  0x0460       5     8     
1853  22       1/0/6@0                 1/0/6@0                 1/385/6@0               11    1     1  0x0460       3     4     
1853  24       1/0/2@0                 1/0/2@0                 1/326/2@0               1     1     0  0x0460       0     0     
1853  25       1/0/3@0                 1/0/3@0                 1/292/3@0               11    1     1  0x0460       3     4     
1853  26       1/0/5@0                 1/0/5@0                 1/295/5@0               1     1     1  0x0460       0     0     
1853  27       1/0/6@0                 1/0/6@0                 1/391/6@0               11    1     1  0x0460       5     8     
1853  28       1/0/9@0                 1/0/9@0                 1/352/9@0               11    1     1  0x0460       9     16    
1853  29       1/0/6@0                 1/0/6@0                 1/361/6@0               11    1     1  0x0460       3     4     

      	       			       		- Ted

------------------------ begin test-allocate

#!/bin/bash

function gen_file()
{
	dd if=/dev/zero of=$1 bs=1k count=$2
}

mkdir t
cd t
gen_file a 3
gen_file b 5
gen_file c 7
gen_file d 11
gen_file e 13
gen_file f 15
gen_file g 3
gen_file h 5
gen_file i 7
gen_file j 11
gen_file k 13
gen_file l 15
sync

rm b d f h j k
sync

gen_file m 2
gen_file n 3
gen_file o 5
gen_file p 6
gen_file q 9
gen_file r 6
gen_file s 2
gen_file t 3
gen_file u 5
gen_file v 6
gen_file w 9
gen_file x 6
sync
-------------------------------------------------


Theodore Ts'o (4):
  ext4: Add configurable run-time mballoc debugging
  ext4: Display the mballoc flags in mb_history in hex instead of
    decimal
  ext4: Fix bugs in mballoc's stream allocation mode
  ext4: Avoid group preallocation for closed files

 fs/ext4/Kconfig   |    9 ++++
 fs/ext4/ext4.h    |   46 +++++++++++++++-----
 fs/ext4/mballoc.c |  116 ++++++++++++++++++++++++++++++++++++-----------------
 fs/ext4/mballoc.h |   16 +++++--
 4 files changed, 134 insertions(+), 53 deletions(-)

