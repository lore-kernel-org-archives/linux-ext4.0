From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 0/9 v1] ext4: extent status tree implementation (step2)
Date: Mon, 24 Dec 2012 15:55:33 +0800
Message-ID: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:44194 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2LXHmS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 02:42:18 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so3034949dak.20
        for <linux-ext4@vger.kernel.org>; Sun, 23 Dec 2012 23:42:18 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the first try to implement the second step of extent status tree.
In this step, it tries to improve the following problems:
 - A metadata reserve space warning when bigalloc and delalloc are enabled
 - track all extent status in this tree
 - lookup a block mapping in this tree as a extent tree cache
 - improve unwritten extent conversion
 - improve the dio performance

The patch series is not perfect, and there still has some works in my TODO list
(see below).  But I believe that I need to send it out as early as possible to
let others review.  Any comments, suggestions, or feedbacks are welcome!


The patch series can be splitted into 5 parts.

Patch 1:
  ext4: fixup metadata reserve block warning when bigalloc and delalloc
    are enabled

  This patch tries to fixup a metadata reserve space warning from
ext4_da_update_reserve_space() when bigalloc and delalloc are enabled.  This
warning can be triggered by xfstest #13.

Patch 2:
  ext4: refine extent status tree

  This patch refine the code of extent status tree.  The major change is add a
prefix 'es_'.  Some comments also are updated.

Patch 3-5:
  ext4: add physical block and status member into extent status tree
  ext4: adjust interfaces of extent status tree
  ext4: track all extent status in extent status tree

  These patches make extent status tree track all extent status in memory.  We
first add two members (physical block and status) into the tree, and adjust
related functions to save them in the tree.  Then when we create/lookup an
extent in *_map_blocks, this extent will be inserted into the extent status tree.
Currently we don't load all extent status in alloc_inode function because if a
file is opened/closed very frequently and it will cost too much memory and cause
a latency while the file is being opened.  So now the solution is to load extent
status on-demand.

Patch 6:
  ext4: lookup block mapping in extent status tree

  It makes extent status tree as like a extent cache in memory to try to avoid
potential disk I/O because we don't need to lookup in extent tree if this lookup
hits this cache.  Due to there has not a complete extent status in the tree, its
effect is not very obviously for performance.  But it is useful for us to
improve unwritten extent conversion.

Patch 7-9:
  ext4: add a new convert function to convert an unwritten extent in
    extent status tree
  ext4: refine unwritten extent conversion
  ext4: set dioread_nolock by default for extent-based files

  These patches aim to improve unwritten extent conversion and dio performance.
The first patch adds a new function to convert unwritten extent in extent status
tree.  The second patch refines the unwritten extent conversion and improves the
dio performance.  Before applied this patch, all unwritten conversion need to be
done in a work queue to avoid to take i_data_sem in a irq context due to dio
end_io function is in a irq context.  It causes that we call aio_complete and
inode_dio_done to notify upper level that a dio has been done until this
conversion had done.  When dioread_nolock is enabled, reader must wait the
conversion to avoid to get a stale data.  After applied this patch, we will
convert this unwritten extent in extent status tree in dio end_io function, and
then aio_complete and inode_dio_done are called.  Here we don't need to be
worried about exposing a stale data because we always try to lookup a block
mapping in extent status tree firstly.  Then we finish this conversion in a work
queue to convert unwritten extent in disk.  Meanwhile reader with dioread_nolock
never need to wait the conversion and this can reduce the latency.

TODO list in this step:
 - Use cache as inserting a new extent.  Now when an new extent is inserted
   into extent status tree, the cache will only be invalidated to avoid some
   complexities.  We could use cache to speed up this process.

 - Refactor the delayed space reservation code.  Now delayed space reservation
   has been simplfied but it sill has some problems.  So maybe a refactor is a
   good choice.

 - Avoid to change extent status tree when we convert an unwritten extent in
   ext4_convert_unwritten_extents().  Now ext4_map_blocks is called by
   ext4_convert_unwritten_extents() to convert an unwritten extent.  But at the
   time the unwritten extent has been converted in extent status tree.

 - Refactor ext4_map_blocks.  In ext4 some operations call this function but
   these operations is only for extent-based files.  So maybe we need to
   refactor this function to simplify the code.

Here I use fio to do a simple test to verify that the dio latency quite can be
reduced after applied this patch series.  The result shows that the max latency
can be reduced.  Max submission latency is reduced from 228903 (usec) to 19734
(usec), Max completion latency is reduced from 1002.3k (usec) to 845251 (usec).

[fio config file]

[global]
ioengine=libaio
direct=1
bs=4k
thread
group_reporting
directory=/mnt/sda1/
filename=testfile
filesize=10g
size=10g
runtime=120
iodepth=16

[fio]
rw=randrw
numjobs=4

[result]
== w/o patches ==
Starting 4 threads
Jobs: 4 (f=4): [mmmm] [100.0% done] [8862K/8755K/0K /s] [2215 /2188 /0  iops]
[eta 00m:00s] 
fio: (groupid=0, jobs=4): err= 0: pid=14214: Sun Dec 23 23:25:03 2012
  read : io=1457.9MB, bw=12440KB/s, iops=3109 , runt=120007msec
    slat (usec): min=3 , max=228903 , avg=13.00, stdev=534.68
    clat (usec): min=67 , max=1002.3K, avg=10239.69, stdev=46513.08
     lat (usec): min=167 , max=1002.3K, avg=10253.04, stdev=46515.61
    clat percentiles (usec):
     |  1.00th=[  266],  5.00th=[  524], 10.00th=[  660], 20.00th=[  924],
     | 30.00th=[ 1240], 40.00th=[ 1544], 50.00th=[ 1832], 60.00th=[ 2128],
     | 70.00th=[ 2896], 80.00th=[ 3568], 90.00th=[ 4768], 95.00th=[ 7200],
     | 99.00th=[232448], 99.50th=[276480], 99.90th=[468992], 99.95th=[561152],
     | 99.99th=[618496]
    bw (KB/s)  : min=    7, max= 6728, per=25.08%, avg=3119.32, stdev=1100.92
  write: io=1457.5MB, bw=12436KB/s, iops=3109 , runt=120007msec
    slat (usec): min=3 , max=219742 , avg=14.50, stdev=519.13
    clat (usec): min=82 , max=1002.4K, avg=10308.26, stdev=47075.41
     lat (usec): min=100 , max=1002.4K, avg=10323.12, stdev=47083.93
    clat percentiles (usec):
     |  1.00th=[  199],  5.00th=[  346], 10.00th=[  572], 20.00th=[  788],
     | 30.00th=[ 1112], 40.00th=[ 1448], 50.00th=[ 1720], 60.00th=[ 1992],
     | 70.00th=[ 2640], 80.00th=[ 3440], 90.00th=[ 4640], 95.00th=[ 7456],
     | 99.00th=[232448], 99.50th=[276480], 99.90th=[473088], 99.95th=[561152],
     | 99.99th=[618496]
    bw (KB/s)  : min=   23, max= 6424, per=25.07%, avg=3117.85, stdev=1080.65
    lat (usec) : 100=0.01%, 250=1.55%, 500=4.61%, 750=10.12%, 1000=8.25%
    lat (msec) : 2=33.76%, 4=27.86%, 10=9.95%, 20=0.46%, 50=0.18%
    lat (msec) : 100=0.11%, 250=2.56%, 500=0.52%, 750=0.07%, 1000=0.01%
    lat (msec) : 2000=0.01%
  cpu          : usr=0.54%, sys=2.31%, ctx=330224, majf=0,
minf=18446744073709500708
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=373217/w=373112/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=1457.9MB, aggrb=12439KB/s, minb=12439KB/s, maxb=12439KB/s,
mint=120007msec, maxt=120007msec
  WRITE: io=1457.5MB, aggrb=12436KB/s, minb=12436KB/s, maxb=12436KB/s,
mint=120007msec, maxt=120007msec

Disk stats (read/write):
  sda: ios=372594/372606, merge=248/233, ticks=3800094/3825295,
in_queue=7630213, util=100.00%

== w/ patches ==
Starting 4 threads
Jobs: 4 (f=4): [mmmm] [100.0% done] [12518K/12358K/0K /s] [3129 /3089 /0  iops]
[eta 00m:00s]
fio: (groupid=0, jobs=4): err= 0: pid=13551: Sun Dec 23 23:17:12 2012
  read : io=1465.6MB, bw=12501KB/s, iops=3125 , runt=120010msec
    slat (usec): min=3 , max=19734 , avg=11.20, stdev=69.57
    clat (usec): min=70 , max=845251 , avg=10183.20, stdev=46813.94
     lat (usec): min=167 , max=845266 , avg=10194.76, stdev=46813.77
    clat percentiles (usec):
     |  1.00th=[  266],  5.00th=[  524], 10.00th=[  652], 20.00th=[  916],
     | 30.00th=[ 1240], 40.00th=[ 1544], 50.00th=[ 1816], 60.00th=[ 2096],
     | 70.00th=[ 2832], 80.00th=[ 3536], 90.00th=[ 4640], 95.00th=[ 6816],
     | 99.00th=[232448], 99.50th=[305152], 99.90th=[497664], 99.95th=[585728],
     | 99.99th=[618496]
    bw (KB/s)  : min=   53, max= 6528, per=25.20%, avg=3149.71, stdev=1136.70
  write: io=1459.9MB, bw=12457KB/s, iops=3114 , runt=120010msec
    slat (usec): min=3 , max=19539 , avg=12.68, stdev=76.27
    clat (usec): min=79 , max=847388 , avg=10301.65, stdev=47597.19
     lat (usec): min=96 , max=847407 , avg=10314.69, stdev=47598.35
    clat percentiles (usec):
     |  1.00th=[  199],  5.00th=[  342], 10.00th=[  572], 20.00th=[  780],
     | 30.00th=[ 1112], 40.00th=[ 1448], 50.00th=[ 1720], 60.00th=[ 1976],
     | 70.00th=[ 2544], 80.00th=[ 3376], 90.00th=[ 4448], 95.00th=[ 6944],
     | 99.00th=[232448], 99.50th=[313344], 99.90th=[497664], 99.95th=[569344],
     | 99.99th=[626688]
    bw (KB/s)  : min=   38, max= 6696, per=25.20%, avg=3139.33, stdev=1133.35
    lat (usec) : 100=0.01%, 250=1.52%, 500=4.79%, 750=10.01%, 1000=8.39%
    lat (msec) : 2=34.14%, 4=27.93%, 10=9.40%, 20=0.42%, 50=0.15%
    lat (msec) : 100=0.10%, 250=2.44%, 500=0.60%, 750=0.10%, 1000=0.01%
  cpu          : usr=0.52%, sys=2.28%, ctx=333031, majf=0,
minf=18446744073709500709
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=375055/w=373729/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=1465.6MB, aggrb=12500KB/s, minb=12500KB/s, maxb=12500KB/s,
mint=120010msec, maxt=120010msec
  WRITE: io=1459.9MB, aggrb=12456KB/s, minb=12456KB/s, maxb=12456KB/s,
mint=120010msec, maxt=120010msec

Disk stats (read/write):
  sda: ios=374445/373178, merge=203/232, ticks=3803894/3836417,
in_queue=7645242, util=100.00%


Regards,
					- Zheng

Zheng Liu (9):
  ext4: fixup metadata reserve block warning when bigalloc and delalloc
    are enabled
  ext4: refine extent status tree
  ext4: add physical block and status member into extent status tree
  ext4: adjust interfaces of extent status tree
  ext4: track all extent status in extent status tree
  ext4: lookup block mapping in extent status tree
  ext4: add a new convert function to convert an unwritten extent in
    extent status tree
  ext4: refine unwritten extent conversion
  ext4: set dioread_nolock by default for extent-based files

 Documentation/filesystems/ext4.txt |   5 +-
 fs/ext4/ext4.h                     |   2 +-
 fs/ext4/extents.c                  |  26 +-
 fs/ext4/extents_status.c           | 545 +++++++++++++++++++++++++++----------
 fs/ext4/extents_status.h           |  37 ++-
 fs/ext4/file.c                     |  14 +-
 fs/ext4/indirect.c                 |  11 +-
 fs/ext4/inode.c                    | 150 +++++++---
 fs/ext4/page-io.c                  |  26 +-
 fs/ext4/super.c                    |   8 +
 include/trace/events/ext4.h        |  62 +++--
 11 files changed, 650 insertions(+), 236 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

