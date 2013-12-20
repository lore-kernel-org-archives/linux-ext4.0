From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC PATCH 0/2] ext4: extents status tree shrinker improvement
Date: Fri, 20 Dec 2013 18:42:43 +0800
Message-ID: <1387536165-15956-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35016 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3LTKjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Dec 2013 05:39:31 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so2445606pbb.14
        for <linux-ext4@vger.kernel.org>; Fri, 20 Dec 2013 02:39:30 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I still have some ideas for improving the extents status tree shrinker.
But before doing that, I think I should send out these patches for
discussion so that I want to be sure that I am on the right way.  I
describe my work below, which contains four parts.  The first part
describes my work of improvment for the shrinker.  In second part I
describe the test case for measurement.  In third part I measure the
performance and compare my work with current implememtation on mainline
kernel.  The last part is TODO list.  I describe some ideas that might
improve the performance of extents status tree shrinker.

Improvement
===========
According to this bug report [1], the extents status tree shrinker might
causes excessive time stall under heavy memory pressure.  Due to lacking
some details from this report, I am not sure whether the delalloc is
enabled or not.  But if I remember correctly Andreas has mentioned that
he also notices that es shrinker takes too much time to try to reclaim
some entries from extents status tree, and he observes that the app does
a lot of buffered writes.  So I suspect that the root cause is that
currently es shrinker has to scan a lot of delayed entries that don't be
reclaimed under some workloads.  Hence it burns too much cpu time.

1. https://bugzilla.kernel.org/show_bug.cgi?id=62751

Why don't we discard delayed entry from extents status tree?  Now we need
to use delayed entry in extents status tree to reserve delayed space for
delayed allocation, and support seek_data/hole.  So we couldn't discard
these delayed entries.

In this patch series, it contains two patches.  Patch 1 just improves the
trace point in extents status tree.  Later I will use them to calculate
the latency of every function.  This is a trival patch.  So feel free to
pick it up.

Patch 2 tries to make es shrinker avoid scanning delayed entry.  It adds
a evictable list in order to track all reclaimable objects.  Meanwhile
a hlist_node structure is defined in 'extent_status' structure.  The
defect of using hlist_node is that it costs extra 1/3 memory space.  On
64bits platform, extent_status structure occupies 48 bytes.  After that
it will take 64 bytes.  Then the es shrinker can traverse on this list.
It shouldn't encounter any delayed entry.  So it reduces the time taking
sbi->s_es_lru_lock and ei->i_es_lock due to it don't need to scan all
delayed extries.

Workload
========
For comparing the improvement, I use fio to generate a workload that
could cause some fragmented files.  For getting a extreme fragmented
tree, I hack the code in ext4_es_can_be_merge() to always return 0.
That means we don't try to merge any entry in extents status tree.
Meanwhile vm.dirty_ratio, vm.dirty_background_ratio are adjusted to 80
and 60 on my machine.  The purpose of doing this is to accumulate more
delayed entries on extents status tree.  The configure file of fio is
like below:

  [global]
  ioengine=psync
  bs=4k
  directory=/mnt/sda1
  thread
  group_reporting
  fallocate=0
  direct=0
  filesize=10g
  size=20g
  runtime=300
  
  [io]
  rw=randwrite:32
  rw_sequencer=sequential
  numjobs=25
  nrfiles=10

sysctl settings:

  #!/bin/bash
  #
  # This script is used to adjust sysctl parameter to increase the memory
  # pressure and accumluate some delayed entries.
  
  sudo sysctl vm.dirty_ratio=80
  sudo sysctl vm.dirty_background_ratio=60

Using this workload, the extents status tree will look like this:
[0, 1)[1, 2)...[31, 32)[32, 51)[51, 52)[52, 53)...[101, 102)...[111, 112)
[ D  ][ D  ]...[  D   ][  H   ][  D   ][  D   ]...[    W   ]...[    U   ]

D: Delayed entry
H: Hole entry
W: Written entry
U: Unwritten entry

*NOTE*
This workload couldn't reproduce the problem that is reported by [1].

I run this workload on my desktop, which has a Intel Core Duo CPU @ 3.0
GHz, 4G memeory and a HDD.  I will run the same workload on a server to
measure the result of improvement.

Comparison
===========

slabtop
-------
slabtop is used to measure memory space which the slab of extent_status
occupies.  The following is the result of $(slabtop -o)

vanilla:
718890 688677  95%    0.04K   7730       93     30920K ext4_extent_status
patched:
718420 675933  94%    0.05K  10565       68     42260K ext4_extent_status

                   vanilla        patched        +/- (%)
ext4_extent_status 30920k         42260k         36.68

As I said above, adding hlist_node adds ~1/3 extra memory space.

perf record -g
--------------
The following is the result of $(perf diff), which compares the result
of $(perf record -g).  Here I cut all *_es_* functions and paste them
here.

# Event 'cycles'
#
# Baseline    Delta       Shared Object                                        Symbol
# ........  .......  ..................  ............................................
#
     1.82%   +0.04%  [ext4]              [k] ext4_es_lookup_extent                   
     0.55%   +0.01%  [ext4]              [k] __es_tree_search                        
     0.39%   -0.05%  [ext4]              [k] __es_insert_extent                      
     0.10%   +0.02%  [ext4]              [k] ext4_es_insert_extent                   
     0.08%   +0.01%  [ext4]              [k] __es_remove_extent                      
     0.07%   +0.01%  [ext4]              [k] ext4_es_lru_add                         
     0.01%   -0.01%  [ext4]              [k] __es_try_to_reclaim_extents             
     0.00%           [ext4]              [k] ext4_es_free_extent                     
     0.00%           [ext4]              [k] ext4_es_cache_extent                    

perf lock record -g
-------------------
Here is the result of $(perf lock report -k wait_max).

                Name   acquired  contended   avg wait (ns) total wait (ns)   max wait (ns)   min wait (ns)
vanilla:
&(&sbi->s_es_lru...        152          1           87275           87275           87275           87275
patched:
&(&sbi->s_es_lru...        148          0               0               0               0               0

'sbi->s_es_lru_lock' protects the entire lru list of inodes which have
reclaimable entries.  When es shrinker tries to reclaim some entries,
this lock will be taken during this process.  From the result we can see
that the improvement can reduce the waiting time.

latency
-------
Here I calculate the latency of the following operations from the
result of trace points. (Unit: *us*)

- es_find_delayed_extent_range -
x vanilla
+ patched
    N           Min           Max        Median           Avg        Stddev
x 4425             0            54             1     1.0280226     1.0898311
+ 7063             0           140             1     1.0127425     1.8662003

- es_insert_extent -
x vanilla
+ patched
    N           Min           Max        Median           Avg        Stddev
x 26995             1          1270             2     4.1053899      20.26818
+ 26559             1           440             2     3.0948454     7.6911348

- es_lookup_extent -
x vanilla
+ patched
    N           Min           Max        Median           Avg        Stddev
x 32025             0           104             1     1.6082748      1.385739
+ 31433             0           168             1     1.6219578     1.4846153

- es_shrink_scan -
x vanilla
+ patched
    N           Min           Max        Median           Avg        Stddev
x 1219            24          1872           171     278.35603      275.8815
+ 1405            17           339            86     95.057651     33.216144

The result of latency shows that the patch can reduce the latency when es
shrinker tries to reclaim the entry.  Meanwhile other operations don't be
impacted too much.

TODO list
=========

Numa-aware shrinker
-------------------
Now the shrinker has been numa-aware.  But the es shrinker doesn't
support it.  So an improvement is to make es shrinker numa-aware.  The
key issue is that extent_status objects might not be on the same node
with its inode.  So that means we need to use lru_list on ext4_sb_info in
order to make s_es_lru list numa-aware, and use lru_list on ext4_es_tree
for making evictable list numa-aware.  I am not sure it is worthwhile.

rcu-skiplist
------------
Chris Mason has sent out a rcu-skiplist patch set.  So an potential
improvement here is to use rcu-skiplist in extents status tree to track
all entries.  Now we use rb-tree to do the same thing.  But the defect
of using rb-tree here is that we need to rotate the subtree when a node
is inserted or removed.  That means that rb-tree couldn't provide a very
stable latency when it tries to balance the subtree.  The skiplist does
not need to do this.  So I suspect that it would provide more smooth
latency.

Regards,
						- Zheng

Zheng Liu (2):
  ext4: improve extents status tree trace point
  ext4: improve extents status tree shrinker to avoid scanning delayed entries

 fs/ext4/extents_status.c    |   53 +++++++++++++++++++++++--------------------
 fs/ext4/extents_status.h    |    2 ++
 include/trace/events/ext4.h |   46 +++++++++++++++++++++++++++++++++----
 3 files changed, 71 insertions(+), 30 deletions(-)

-- 
1.7.9.7

