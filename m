From: Nick Dokos <nicholas.dokos@hp.com>
Subject: streaming read and write - test results
Date: Mon, 23 Jun 2008 13:36:42 -0400
Message-ID: <4278.1214242602@alphaville.zko.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:12265 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYFWRgo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 13:36:44 -0400
Received: from smtp1.fc.hp.com (smtp1.fc.hp.com [15.15.136.127])
	by g1t0029.austin.hp.com (Postfix) with ESMTP id 015E238AFB
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 17:36:43 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are some preliminary results from streaming reads and writes
on ext4. The test rig consists of the following:

o an 8-cpu Opteron box (4 slots, dual-core) with 64GB of memory.

o 8 MSA1000 RAID controllers, each with four back-end SCSI busses, each
bus with 7 300GB 15K disks. Only one bus on each controller is used for
the tests below (the rest are going to be used for larger filesystem
testing). The 7 disks are striped ("horizontally" @ 128KB stripe size) at
the hardware level and exported as a single 2TB LUN (that's the current
hardware LUN size limit).

o the 8 LUNs are striped ("vertically" @ 128KB also) at the LVM level to
produce a 16TB logical volume.

o the kernels used were 2.6.26-rc3 and 2.6.26-rc5, each patched with the
then current ext4 patch queue.

o e2fsprogs were 1.41-WIP.

o the test used was aiod (http://sourceforge.net/projects/aiod/) with the
  following command line:

  aiod -S -B -b4M -I -v -w 3500000 -W|-R

  (aiod uses AIO by default, but reverts back to ordinary read/write with -S
  - note that the documentation calls this "sync-io" but that's a
  misnomer: there is nothing synchronous about it, it just means non-AIO;
  aiod uses directIO by default, but reverts to buffered IO with -B;
  -b4M makes aiod issue 4MB IOs and -w <N> makes it issue that many IOs.)

  The test first sequentially writes a ~14TB (4MB*3500000) file,
  unmounts the fs, remounts it and then sequentially reads the file back.

o There were two write tests: in the first,  the fs was mounted with default options;
  in the second with mntopts=delalloc,journal_async_commit.

o The readahead setting was changed by doing a blockdev --setra on the LVM special
  file, /dev/mapper/<vgname>-<lvname>. The default RA was 256.


-------------------------------------------------------------------------------
Throughput results (in MB/s):
                
Ext4         Read   Read (RA=4K)    Read (RA=64K)    Write     Write(+mntopts)
----         ----   ------------    -------------    -----     ---------------
2.6.26-rc3    122                                      144

2.6.26-rc5    117            509 [1]          570                      295 [2]
                                                                       281

Ext3         Read                                    Write
----         ----                                    -----
2.6.26-rc3    131                                      155 [3]



Footnotes:
-----
[1] Typical iostat output:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00   14.50    0.57    0.00   84.92

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda              56.04     0.00 449.05  0.00 129304.30     0.00   287.95     1.51    3.37   2.00  89.59
sde              61.14     0.00 443.96  0.00 129304.30     0.00   291.25     1.51    3.41   2.02  89.63
sdi              60.54     0.00 444.56  0.00 129304.30     0.00   290.86     1.50    3.38   2.02  89.71
sdm              61.14     0.00 443.96  0.00 129304.30     0.00   291.25     1.50    3.39   2.02  89.75
sdq              62.94     0.00 442.16  0.00 129304.30     0.00   292.44     1.49    3.36   2.03  89.67
sdu              64.24     0.00 440.86  0.00 129304.30     0.00   293.30     1.49    3.37   2.03  89.51
sdy              63.64     0.00 441.56  0.00 129304.30     0.00   292.84     1.49    3.37   2.03  89.83
sdac             61.84     0.00 443.36  0.00 129304.30     0.00   291.65     1.50    3.37   2.03  89.99
dm-0              0.00     0.00 2020.38  0.00 1034434.37     0.00   512.00     7.05    3.48   0.46  92.11


and top output (only %CPU > 0 shown):


top - 15:07:20 up 2 days, 20:08,  0 users,  load average: 1.12, 1.38, 1.33
Tasks: 189 total,   1 running, 188 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us, 13.1%sy,  0.0%ni, 84.8%id,  0.6%wa,  0.2%hi,  1.2%si,  0.0%st
Mem:  66114888k total, 66005660k used,   109228k free,     4196k buffers
Swap:  2040212k total,     3884k used,  2036328k free, 19773724k cached

    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND          
  80046 root      20   0 18808 4796  564 S   86  0.0 186:21.78 aiod             
    391 root      15  -5     0    0    0 S   10  0.0 196:19.05 kswapd1          
    392 root      15  -5     0    0    0 S    8  0.0 178:58.83 kswapd2          
    393 root      15  -5     0    0    0 S    7  0.0 166:29.31 kswapd3          
    135 root      15  -5     0    0    0 S    1  0.0   1:06.74 kblockd/6        
    ....

-----
[2] Two runs made: it's not clear why the difference is so large (~5%).

During both runs, iostat showed fairly constant and even spread among
the disks (sort-of: sda and sde form one group and the others form
another - the difference between the two groups stayed pretty constant
through the run). Here is a typical entry:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00   13.01    2.65    0.00   84.34

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00   252.15  0.00 95.80     0.00 75623.58   789.36     0.29    3.04   3.01  28.81
sde               0.00   252.35  0.00 95.60     0.00 75623.58   791.01     0.29    3.07   2.98  28.53
sdi               0.00   185.61  0.00 162.24     0.00 75623.58   466.13     0.51    3.11   1.80  29.21
sdm               0.00   185.31  0.00 162.64     0.00 75623.58   464.98     0.50    3.05   1.77  28.73
sdq               0.00   187.71  0.00 162.54     0.00 75642.76   465.39     0.52    3.17   1.81  29.45
sdu               0.00   185.61  0.00 162.44     0.00 75624.38   465.56     0.51    3.12   1.79  29.09
sdy               0.00   188.41  2.50 167.73    19.98 75689.11   444.75     0.53    3.09   1.79  30.45
sdac              0.00   188.21  0.00 162.54     0.00 75645.95   465.41     0.52    3.21   1.81  29.37
dm-0              0.00     0.00  2.50 1622.18    19.98 604636.16   372.17     4.40    2.70   0.20  31.89



Typical top output looked like this (%CPU > 0 shown only):

top - 01:17:38 up  6:19,  0 users,  load average: 1.38, 1.31, 1.23
Tasks: 189 total,   1 running, 188 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us, 12.3%sy,  0.0%ni, 84.4%id,  2.6%wa,  0.1%hi,  0.6%si,  0.0%st
Mem:  66114888k total, 66006468k used,   108420k free,   137832k buffers
Swap:  2040212k total,     4120k used,  2036092k free, 39614736k cached

    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND          
   9965 root      20   0 18808 4808  580 S   72  0.0 243:32.36 aiod             
    391 root      15  -5     0    0    0 S    8  0.0  28:23.96 kswapd1          
    392 root      15  -5     0    0    0 S    7  0.0  25:28.88 kswapd2          
    393 root      15  -5     0    0    0 S    7  0.0  23:53.41 kswapd3          
   9860 root      15  -5     0    0    0 S    2  0.0   6:20.61 kjournald2    
   ....
                  


-----
[3] File size in this case is only 2TB (ext3 limit).

During read, typical iostat output looked like this:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    3.80   10.81    0.00   85.39

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda              44.86     0.00 267.83  0.00 33553.65     0.00   125.28     0.35    1.31   1.07  28.73
sde              48.85     0.00 268.03  0.00 33528.07     0.00   125.09     0.36    1.33   1.04  27.85
sdi              23.58     0.00 262.04  0.00 33553.65     0.00   128.05     0.33    1.26   1.03  27.01
sdm              25.07     0.00 262.54  0.00 33553.65     0.00   127.81     0.33    1.24   1.04  27.29
sdq              46.45     0.00 266.63  0.00 33483.32     0.00   125.58     0.35    1.31   1.06  28.29
sdu              23.98     0.00 263.14  0.00 33554.45     0.00   127.52     0.36    1.36   1.07  28.13
sdy              44.76     0.00 267.73  0.00 33553.65     0.00   125.33     0.33    1.24   1.01  27.13
sdac             46.85     0.00 268.33  0.00 33553.65     0.00   125.05     0.32    1.19   0.99  26.57
dm-0              0.00     0.00 1427.57  0.00 268334.07     0.00   187.97     2.02    1.42   0.69  98.74


and typical top output:

top - 18:09:24 up  6:58,  0 users,  load average: 1.11, 1.12, 1.04
Tasks: 196 total,   1 running, 195 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  3.5%sy,  0.0%ni, 85.0%id, 11.0%wa,  0.0%hi,  0.4%si,  0.0%st
Mem:  66115496k total, 66007072k used,   108424k free,    79140k buffers
Swap:  2040212k total,     3524k used,  2036688k free, 44337588k cached

    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND          
  10748 root      20   0 18808 4796  560 S   22  0.0  33:16.84 aiod             
    382 root      15  -5     0    0    0 S    2  0.0  13:49.95 kswapd1          
    383 root      15  -5     0    0    0 S    2  0.0  12:54.08 kswapd2          
    384 root      15  -5     0    0    0 S    2  0.0  12:03.61 kswapd3          
    ...

During write, iostat looked like this:


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00   14.01    1.61    0.00   84.38

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00  4997.10  0.00 96.40     0.00 40747.25   422.67     0.57    5.92   3.45  33.25
sde               0.00  4995.10  0.00 98.30     0.00 40747.25   414.51     0.55    5.54   3.15  30.93
sdi               0.00  4996.20  0.00 97.60     0.00 40724.88   417.25     0.54    5.56   3.12  30.49
sdm               0.00  4996.60  0.00 96.60     0.00 40720.08   421.52     0.54    5.57   3.14  30.29
sdq               0.00  4987.21  1.30 97.90    10.39 40655.34   409.93     0.55    5.52   3.10  30.77
sdu               0.00  4997.80  0.00 97.50     0.00 40736.86   417.80     0.58    5.96   3.39  33.05
sdy               0.00  5035.46  0.00 58.04     0.00 40748.05   702.04     0.34    5.80   5.33  30.93
sdac              0.00  5032.87  0.00 57.84     0.00 40725.67   704.08     0.36    6.16   5.66  32.77
dm-0              0.00     0.00  1.30 40737.06    10.39 325896.50     8.00   237.23    5.75   0.01  38.96

and top looked like this:

top - 13:58:25 up  2:47,  1 user,  load average: 1.40, 1.42, 1.37
Tasks: 200 total,   5 running, 195 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us, 11.9%sy,  0.0%ni, 83.6%id,  2.2%wa,  0.0%hi,  2.4%si,  0.0%st
Mem:  66115496k total, 66004292k used,   111204k free,   146224k buffers
Swap:  2040212k total,     4212k used,  2036000k free, 43686528k cached

    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND          
   9476 root      20   0 18808 4788  560 S   76  0.0  96:40.63 aiod             
   9373 root      15  -5     0    0    0 S    6  0.0   7:53.28 kjournald        
    382 root      15  -5     0    0    0 R    4  0.0   6:44.07 kswapd1          
    383 root      15  -5     0    0    0 R    4  0.0   6:08.69 kswapd2          
    384 root      15  -5     0    0    0 R    3  0.0   5:48.96 kswapd3          
    128 root      15  -5     0    0    0 S    1  0.0   0:39.71 kblockd/6        
    ...
-------------------------------------------------------------------------------


I'll be filling in some of the holes in the table above (but move everything forward
to 2.6.26-rc7 plus the current patch queue). Note also that these are preliminary
results and the test rig is subject to change. If you have suggestions for
improvements, I'd be very interested in hearing them.


Thanks,
Nick



----
PS. One additional tidbit: I ran fsck on the ext4 filesystem - it took about an
hour and a half (I presume uninit_bg would speed that up substantially since
there are only a handful of inodes in use). But I got an interesting question
from it:

    # time fsck.ext4 /dev/mapper/bigvg-bigvol
    e2fsck 1.41-WIP (17-Jun-2008)
    /dev/mapper/bigvg-bigvol primary superblock features different from backup, check forced.
    Pass 1: Checking inodes, blocks, and sizes
    Inode 49153, i_size is 14680064000000, should be 14680064000000.  Fix<y>? y
    yes

    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information

    /dev/mapper/bigvg-bigvol: ***** FILE SYSTEM WAS MODIFIED *****
    /dev/mapper/bigvg-bigvol: 12/2050768896 files (8.3% non-contiguous), 3648395645/4101537792 blocks

    real	197m45.245s
    user	24m56.602s
    sys	9m16.335s


The real time includes about 30 mins of waiting at the ? while I was not
looking, so it's not as bad as it looks.  But why was there a question
since the reported sizes are the same? and why are the primary
superblock features different from backup?


Also, during pass1, every disk was being hit:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.79    0.00    1.70    9.72    0.00   86.79

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda             882.20     0.00 61.80  0.00  7552.00     0.00   122.20     0.29    4.64   4.27  26.36
sde             898.60     0.00 45.50  0.00  7552.00     0.00   165.98     0.26    5.78   4.84  22.00
sdi             880.10     0.00 63.90  0.00  7552.00     0.00   118.18     0.29    4.58   4.18  26.72
sdm             900.60     0.00 43.40  0.00  7552.00     0.00   174.01     0.25    5.73   4.87  21.12
sdq            1195.10     0.00 193.60  0.00 11101.60     0.00    57.34     0.69    3.56   2.07  40.00
sdu            1273.20     0.00 55.60  0.00 10630.40     0.00   191.19     0.30    5.45   5.00  27.80
sdy             880.70     0.00 63.90  0.00  7556.80     0.00   118.26     0.28    4.44   3.96  25.28
sdac            899.20     0.00 48.00  0.00  7577.60     0.00   157.87     0.26    5.49   4.57  21.92
dm-0              0.00     0.00 8385.60  0.00 67084.80     0.00     8.00    44.06    5.25   0.11  95.16


During pass5, only one disk was being hit:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.01    0.00    0.14   12.39    0.00   87.46

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sde               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdi               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdm               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdq             391.20     0.00 260.70  0.00  5212.80     0.00    20.00     1.00    3.99   3.83  99.76
sdu               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdy               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdac              0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-0              0.00     0.00 651.90  0.00  5215.20     0.00     8.00     2.66    4.14   1.53  99.72


Perhaps this indicates a less-than-optimal set-up of the storage?
