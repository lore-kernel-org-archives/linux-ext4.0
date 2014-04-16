From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Wed, 16 Apr 2014 19:30:26 +0800
Message-ID: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57221 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaDPLYR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 07:24:17 -0400
Received: by mail-pb0-f54.google.com with SMTP id ma3so10699532pbc.41
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 04:24:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is the second version to improve the extent status tree shrinker.
In this version I do some cleanups, add some statistics, and implement
two apporaches that we discussed at Napa to improve the shrinker.

One is to improve the current lru algorithm, which add a new list to
track all reclaimable objects in order not to burn some cpu time to scan
delayed extent.  Meanwhile it makes lru algorithm more efficient when
some applications open a huge number of files.  Another apporach is
inspired by Jan Kara.  It drops lru algorithm and uses a round-robin
algorithm to shrink all reclaimable extent caches.  Every time the
shrinker scans the list and tries to shrink objects from the position
that it stopped at last time.  Please see the commit log in the patch
to get the more details.

>From the result, the conclusion is that the round-robin algorithm wins.
Espeically if the applications open a large amount of files.

In this patch set, patch 1 is pretty stable and can be queued in this
cycle.  Patch 2 adds some statistics in order that we can collect more
details about the status of the shrinker.  But I am not sure whether or
not we should enable it by default.  Maybe we need to define a switch
to turn on/off dynamically.  Patch 3 and patch 4 improve the shrinker
as described above.

There are also some improvements for these apporaches, such as using
rcu when the shrinker traverses the list because now the shrinker does
not need to change the list during this process.  Another improvement
is to make the shrinker numa-aware.  But before that I believe this
patch set should be reviewed as soon as possible.  Now the key problem
is to make a decision which apporach should be applied.

I use two test cases to compare these improvements.  The test case A
simulates some applications that generate a very fragmented extents
status tree, and the test case B simulates some applications opens a
large number of files with a few extent caches.  Every test cases are
run 3 times.

For getting a fragmented extents status tree, I hack the code and let
ext4_es_can_be_merged() always return 0 in order to disable to merge
the extents status tree.  Meanwhile for increasing the memory pressure,
vm.dirty_background_ratio is set to 60, and vm.dirty_ratio is set to 80
in order to keep dirty pages in memory as many as possible.

Environement
============
$ lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                16
On-line CPU(s) list:   0-15
Thread(s) per core:    2
Core(s) per socket:    4
CPU socket(s):         2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 44
Stepping:              2
CPU MHz:               2400.000
BogoMIPS:              4799.89
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              12288K
NUMA node0 CPU(s):     0-3,8-11
NUMA node1 CPU(s):     4-7,12-15

$ cat /proc/meminfo
MemTotal:       24677988 kB

$ df -ah
/dev/sdb1             183G   15G  159G   9% /mnt/sdb1 (HDD)

The Test Case A
===============

Script
------ 
[global]
ioengine=psync
bs=4k
directory=/mnt/sdb1
group_reporting
fallocate=0
direct=0
filesize=100000g
size=600000g
runtime=300
create_on_open=1
create_serialize=0
create_fsync=0
norandommap

[io]
rw=write
numjobs=100
nrfiles=5

Max Scan Time
-------------
x vanilla
+ lru
* rr
    N           Min           Max        Median           Avg        Stddev
x   3         22230         24607         23532     23456.333     1190.3051
+   3           203           364           301     289.33333      81.13158
Difference at 95.0% confidence
        -23167 +/- 1912.16
        -98.7665% +/- 8.15199%
        (Student's t, pooled s = 843.626)
*   3           165           248           172           195     46.032597
Difference at 95.0% confidence
        -23261.3 +/- 1909.16
        -99.1687% +/- 8.1392%
        (Student's t, pooled s = 842.302)

Avg. Scan Time
-------------
x vanilla
+ lru
* rr
    N           Min           Max        Median           Avg        Stddev
x 220           204         15997          3976     5268.6773     4121.2038
+ 220           105           169           126        132.65     14.904881
Difference at 95.0% confidence
        -5136.03 +/- 544.593
        -97.4823% +/- 10.3364%
        (Student's t, pooled s = 2914.15)
* 224            55           144            82     97.834821     27.811093
Difference at 95.0% confidence
        -5170.84 +/- 539.706
        -98.1431% +/- 10.2437%
        (Student's t, pooled s = 2900.98)

The Test Case B
===============

Script
------
[global]
ioengine=psync
bs=4k
directory=/mnt/sdb1
group_reporting
fallocate=0
direct=0
runtime=300
create_on_open=1
create_serialize=0
create_fsync=0
norandommap

[io]
rw=randwrite
numjobs=25
nrfiles=40000

[streamer]
rw=write
numjobs=1
filesize=1000g
size=1000g
nrfiles=1

Max Scan Time
-------------
x vanilla
+ lru
* rr
    N           Min           Max        Median           Avg        Stddev
x   3        390531        481463        393469        421821     51672.373
+   3        106433        170801        130652        135962     32510.874
Difference at 95.0% confidence
        -285859 +/- 97844.9
        -67.7678% +/- 23.1958%
        (Student's t, pooled s = 43168.2)
*   3         72569        156338        113704     114203.67     41886.735
Difference at 95.0% confidence
        -307617 +/- 106609
        -72.926% +/- 25.2734%
        (Student's t, pooled s = 47034.7)

Avg. Scan Time
-------------
x vanilla
+ lru
* rr
    N           Min           Max        Median           Avg        Stddev
x 221           164        155601         19553     24630.968     22736.242
+ 207            44         49210         13633     16167.768     15087.729
Difference at 95.0% confidence
        -8463.2 +/- 3681.22
        -34.36% +/- 14.9455%
        (Student's t, pooled s = 19417.6)
*  78            41         18043           166     808.85897     2605.2387
Difference at 95.0% confidence
        -23822.1 +/- 5062.86
        -96.7161% +/- 20.5548%
        (Student's t, pooled s = 19613.2)

As always, feedback, comment and idea are welcome.

Regards,
						- Zheng

Zheng Liu (4):
  ext4: improve extents status tree trace point
  ext4: track extent status tree shrinker delay statictics
  ext4: improve extents status tree shrinker lru algorithm
  ext4: use a round-robin algorithm to shrink extent cache

 fs/ext4/ext4.h              |   11 +-
 fs/ext4/extents.c           |    4 +-
 fs/ext4/extents_status.c    |  310 +++++++++++++++++++++++++++++--------------
 fs/ext4/extents_status.h    |   16 ++-
 fs/ext4/inode.c             |    4 +-
 fs/ext4/ioctl.c             |    4 +-
 fs/ext4/super.c             |   22 ++-
 include/trace/events/ext4.h |   59 ++++++--
 8 files changed, 296 insertions(+), 134 deletions(-)

-- 
1.7.9.7

