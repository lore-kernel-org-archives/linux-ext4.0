From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 0/6] ext4: extents status tree shrinker improvement
Date: Thu,  7 Aug 2014 11:35:47 +0800
Message-ID: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61949 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaHGDbA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2014 23:31:00 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so4587121pad.36
        for <linux-ext4@vger.kernel.org>; Wed, 06 Aug 2014 20:30:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Intro
=====

Here is the third version to improve the extent status tree shrinker.
Sorry for very late work.  Thanks Ted's and Dave's suggestions.  I
revise my work and currently in extent status tree shrinker we should
fix two issues.  One is how to reclaim some objects from the tree as
quick as possible, and another is how to keep useful extent cache in
the tree as many as possible.  The first issue also can be divided into
two problems: a) how to scan list that tracks all inodes and b) how to
reclaim object from an inode.  This patch set tries to fix these issues.

In the patch set, the first two patches just does some cleanups and
adds some statistics for measuring the improvements.

Patch 3 makes extent status tree cache extent hole in delalloc code path
to improve the cache hit ratio.  Currently we don't cache extent hole
when we do a delalloc write because this extent hole might be converted
into delayed soon.  But the defect is that we could miss some extent
hole in extent cache.  That means that the following writes must lookup
in extent tree again to make sure whether a block has been allocated or
not.

Patch 4 makes shrinker replace lru list with a normal list to track all
inodes.  Then the shrinker uses a round-robin algorithm to scan this
list.  The purpose that we discard the lru list and use rr algorithm is
that we don't need to take a long time to keep lru list.  Thus we can
save some scan time.  Meanwhile this commit tries to reduce the critical
section.  Thus the locking gets more fine-granularity.  That means that
other processes don't need to wait on this locking for a long time.  The
improvement can be seen in test case (b).

Patch 5 uses a list to track all reclaimable objects in an inode to
speed up the reclaim time.  Now when shrinker tries to reclaim some
objects it should scan rb-tree in an inode.  But in this rb-tree, it
has some non-reclaimable objects (delayed extent, ext4 uses them to
finish seeking data/hole, finding delayed range, etc.).  That means the
shrinker must take some time to skip these non-reclaimble objects during
the scan time.  So after applying this patch the shrinker can directly
reclaim objects.  The improvement can be seen in test case (a).

Patch 6 improve the list that tracks all reclaimable objects in order
to promote the cache hit ratio.  After applied patch 5, the extent
cache could be flushed by a streaming workload because we don't any
way to recognize which one should be kept as much as possible.  In this
commit it splits the list into active list and inactive list.  Meanwhile
a new flag called '_ACCESSED' is defined.  When an extent cache is
accessed, this flag will be markd.  When the shrinker encounters this
flag during scanning list, this extent cache will be moved to the tail
of active list.  All these active extent caches will be reclaimed when
we are under high memory pressure and the shrinker doesn't reclaim any
object in the first round.  The improvement can be seen in test case (c).

Environment
===========
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
/dev/sdb1             453G   51G  380G  12% /mnt/sdb1 (HDD)

Test Case
=========

Test Case (a)
-------------
The test case (a) is used to create a huge number of extent caches in
500 inodes.  Running this test, we will get a very big rb-tree on every
inodes.  The purpose is to measure the latency when shrinker reclaim
object from an inode.

Fio script:

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

Test Case (b)
-------------
The test case (b) is used to create a very long list in super block so
that we can measure the latency when shrinker scan the list.

Fio script:

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
filesize=100000g
size=600000g
rw=write
numjobs=100
nrfiles=5
openfiles=10000

[rand]
filesize=1000g
size=600000g
rw=write:4k
numjobs=20
nrfiles=20000

Test Case (c)
-------------
The test case (c) is used to measure the cache hit/miss.

*NOTE*
I reduce the memory to 12g in order to make shrinker work more aggressive.

Fio script:

[global]
ioengine=psync
bs=4k
directory=/mnt/sdb1
group_reporting
direct=0
runtime=300

[read]
rw=read
numjobs=1
nrfiles=50
filesize=1g
size=600000g

[stream]
filesize=1000g
size=600000g
rw=write
numjobs=100
nrfiles=5
create_on_open=1
create_serialize=0
create_fsync=0

Note 1
------
*For getting a very fragmented extent status tree, I use the following
patch to disallow to merge extent cache*

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index b6c3366..f8c693e 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -351,6 +351,7 @@ static void ext4_es_free_extent(struct inode *inode, struct
extent_status *es)
 static int ext4_es_can_be_merged(struct extent_status *es1,
                                 struct extent_status *es2)
 {
+#if 0
        if (ext4_es_status(es1) != ext4_es_status(es2))
                return 0;

@@ -376,6 +377,7 @@ static int ext4_es_can_be_merged(struct extent_status *es1,
        /* we need to check delayed extent is without unwritten status */
        if (ext4_es_is_delayed(es1) && !ext4_es_is_unwritten(es1))
                return 1;
+#endif

        return 0;
 }

Note 2
------
For caching data in memory as many as possible, two sysctl parameters
are changed:
 sudo sysctl vm.dirty_ratio=80
 sudo sysctl vm.dirty_background_ratio=60

Result
======
Every test cases we collect 5 metrics:
 1. The shrinker avg. scan time
 2. The shrinker max scan time
 3. The extent cache hit/miss
 4. The userspace avg. latency
 5. The userspace max latency

Due to using fio to do the test, it is easy to get the userspace latency.

For review, I brief the patch as blow:
 * baseline: ext4/dev branch + patch 1, 2
 * es-cache: baseline + patch 3
 * es-slist: es-cache + patch 4
 * es-ilist: es-slist + patch 5
 * es-gc:    es-ilist + patch 6

Every test cases should be run 3 times.

1. es avg. scan time

test case (a)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3          9402         11552          9633     10195.667      1180.284
+   3          7069         10358          9931     9119.3333     1788.4301
*   3          3754          6854          4480     5029.3333     1621.3653
%   3           190           243           204     212.33333     27.465129
#   3           269           513           290     357.33333     135.21957

test case (b)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3         23047         36274         30195     29838.667     6620.6958
+   3          2992         32867         14370         16743     15078.205
*   3           124          1281           173           526     654.30803
%   3           133           157           136           142     13.076697
#   3           124           315           140           193     105.95754

test case (c)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3           137           235           163     178.33333     50.767444
+   3            57          9333          6383     5257.6667     4739.2853
*   3            48            54            49     50.333333     3.2145503
%   3            52            57            53            54     2.6457513
#   3            49            88            69     68.666667     19.502137

2. es max scan time

test case (a)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3         17503         22339         19329     19723.667     2442.0371
+   3         26275         33930         31867     30690.667     3960.7545
*   3        170970        199678        188287     186311.67     14455.579
%   3           325           405           382     370.66667     41.186567
#   3           500           857           790     715.66667     189.75335

test case (b)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3        361903        384286        380877     375688.67       12059.8
+   3        277470        313231        293883     294861.33     17900.562
*   3        112727        131888        114761        119792     10524.695
%   3         59466         76178         67195         67613     8363.8376
#   3         38747         84505         45682     56311.333     24661.421

test case (c)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3           337           462           355     384.66667      67.57465
+   3         22136         31236         24031         25801     4801.2681
*   3         36105         56888         54150     49047.667     11291.972
%   3           152           191           158           167            21
#   3           115           154           139           136     19.672316

3. cache hit/miss

test case (a)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3          4673          4858          4832     4787.6667     100.15155
+   3       7911368       8364372       8263210       8179650     237781.12
*   3       6657959       6900137       6830922     6796339.3     124737.79
%   3       6525957       6691967       6535884     6584602.7     93112.627
#   3      10061008      10704728      10501548      10422428      329072.7

test case (b)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3       1645455       1648083       1646239     1646592.3     1349.1588
+   3       8531336       9081690       8570763     8727929.7     306999.03
*   3       6591288       6643048       6595983     6610106.3     28624.741
%   3       6501434       6556700       6537840     6531991.3     28093.378
#   3       9656351       9801225       9739132       9732236      72682.77

test case (c)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3         10873         18200         15614     14895.667     3715.9433
+   3       1781010       1925331       1888470       1864937      74983.26
*   3       1697486       1929501       1765950     1797645.7     119210.74
%   3       1703674       1870348       1743376       1772466     87061.626
#   3       1687157       1953796       1774275       1805076     135961.82

4. userspace avg. latency (usec)

test case (a)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3       2638.64       2798.02       2649.18       2695.28     89.131384
+   3       2641.12       2817.16       2648.18     2702.1533     99.661231
*   3       2637.54       2812.82       2642.68       2697.68     99.747279
%   3       2850.76       2859.45       2852.68     2854.2967     4.5650009
#   3       2643.07       2817.62       2653.54     2704.7433     97.894135

test case (b)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3        3561.9        3580.1       3563.47       3568.49     10.085152
+   3       3596.12       3631.57        3600.2     3609.2967     19.396846
*   3        3565.4       3605.12       3585.48     3585.3333     19.860406
%   3       3577.07       3597.76       3588.12       3587.65     10.353004
#   3       3593.63        3626.3       3602.66       3607.53     16.870682

test case (c)
-------------
read:
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3        165.46        200.33        166.31     177.36667     19.891371
+   3        165.11        218.36        165.16     182.87667     30.729478
*   3        165.14        199.36        165.36        176.62     19.693725
%   3        165.45        197.07        166.32        176.28     18.009922
#   3        165.13        228.35        165.71     186.39667      36.33381

write:
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3      13804.25      15932.47      15148.61     14961.777     1076.3411
+   3      13807.94      15922.01      15114.67     14948.207     1066.8203
*   3      13808.51      15936.08      15083.47     14942.687      1070.749
%   3      13807.08       15290.5      15093.27     14730.283     805.57632
#   3      13809.13      15972.27       15308.6         15030     1108.1548

5. userspace max latency (usec)

test case (a)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3        849941       2720800        941754       1504165     1054636.4
+   3       1080500       2199500       1090500     1456833.3     643187.63
*   3        863204       2663400        920104       1482236     1023313.6
%   3        879189       1156700        991861       1009250     139570.31
#   3        896181       1692100        984983       1191088     436155.04

test case (b)
-------------
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3       1293500       4917500       3935800     3382266.7     1874338.1
+   3       1027900       3232200       1505500     1921866.7     1159635.9
*   3       1025500       1109300       1033500       1056100     46245.865
%   3        983719       1188300       1119400     1097139.7     104091.25
#   3        869236       1118400        992344     993326.67     124584.91

test case (c)
-------------
read:
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3        147107       3594200        566804       1436037     1880767.7
+   3        124889       3586600        402357       1371282     1923531.3
*   3        299597       3578300        327797       1401898     1884872.2
%   3        406603       3587600        729393       1574532     1750822.8
#   3        301480       3583600        997081       1627387       1729463

write:
x baseline
+ es-cache
* es-slist
% es-ilist
# es-gc
    N           Min           Max        Median           Avg        Stddev
x   3      28892400      29715800      29536400      29381533     432994.98
+   3      28726600      29821200      29530000      29359267     566921.24
*   3      28859400      29681400      29528700      29356500      437219.2
%   3      28472300      29819700      28728200      29006733     715581.79
#   3      28807200      29681900      29516100      29335067     464601.79

Conclusion
==========
On the view of kernel side that the max scan time and avg. scan time can
be improved.  Meanwhile the cache hit ratio is also increased.

On the view of userspace side, the max latency of test case (a) and (b) 
can be improved.  Others are not outstanding.

As always, any comment or feedback are welcome.

Thanks,
						- Zheng

Zheng Liu (6):
  ext4: improve extents status tree trace point
  ext4: track extent status tree shrinker delay statictics
  ext4: cache extent hole in extent status tree for
    ext4_da_map_blocks()
  ext4: change lru to round-robin in extent status tree shrinker
  ext4: use a list to track all reclaimable objects for extent status
    tree
  ext4: use a garbage collection algorithm to manage object

 fs/ext4/ext4.h              |   18 +-
 fs/ext4/extents.c           |   27 ++-
 fs/ext4/extents_status.c    |  430 ++++++++++++++++++++++++++++++-------------
 fs/ext4/extents_status.h    |   47 ++++-
 fs/ext4/inode.c             |   10 +-
 fs/ext4/ioctl.c             |    4 +-
 fs/ext4/super.c             |   18 +-
 include/trace/events/ext4.h |   59 +++++-
 8 files changed, 419 insertions(+), 194 deletions(-)

-- 
1.7.9.7

