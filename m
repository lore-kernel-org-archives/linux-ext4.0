From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/7 v2] ext4: extent status tree (step2)
Date: Fri, 11 Jan 2013 18:53:40 +0800
Message-ID: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63719 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3AKKkI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2013 05:40:08 -0500
Received: by mail-pb0-f50.google.com with SMTP id wz7so887094pbc.37
        for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2013 02:40:07 -0800 (PST)
CC: Jan kara <jack@suse.cz>
CC: "Theodore Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is my second try to implement the second step of extent status tree in
ext4.  The changelog is as below.

v2 <- v1:
 - drop patches that try to improve unwritten extent conversion
 - remove EXT4_MAP_FROM_CLUSTER flag
 - add tracepoint for ext4_es_lookup_extent()
 - drop a patch, which tries to fix a warning when bigalloc and delalloc are
   enabled
 - add a shrinker to reclaim memory from extent status tree
 - rebase against 3.8-rc2

Now the patch set makes extent status tree to track all extent status in memory
and makes it as a extent cache.

The patches that try to improve unwritten extent conversion are dropped because
Jan has worked on it and has a perfect solution.

Now when bigalloc and delalloc are enabled, there still has some works to be
done.  The key issue is delayed space reservation.  I tried to improve it using
extent status tree, but I don't have a good idea in my mind.  That would be
great if some one could give me some suggestions.  I think this work should be
as a new patch series.  So I drop a patch that is in the first version.

As Jan and Dave advised, fragmented extent tree will causes that status tree
costs too much memory.  So in this patch set a shrinker is defined to reclaim
memory.  When the status tree of an inode is accessed, the inode will be
inserted into the tail of lru list.  It will be dropped as ext4_clear_inode is
called.  When shrinker tries to reclaim some memory, written/unwritten extents
will be freed from status tree.  Delayed extent in the tree shouldn't be
reclaimed because they are used by fiemap, bigalloc, and seek_data/hole.  I am
worry about the lock contention because a lru lock is used to protect lru list.
This lock will be taken by all inodes in this file system.  So I do some
comparisons to measure this overhead.  The result shows that we don't need to
care this problem.

First I use fio to measure iops on a SSD in my desktop.  The config file is as
below:

== config file ==
[global]
ioengine=libaio
iodepth=8
bs=4k
filesize=1G
fallocate=none
size=8G
directory=/mnt/sda1
thread
group_reporting
runtime=600

[jobs]
numjobs=4
rw=randrw
nrfiles=16

== result of iops ==
    read    write
w/  2237    2233
w/o 2225    2227

In addition, I use 'perf lock' to re-run above test case to understand whether
there is a heavy contention, and the result shows that it is OK.

Other changes in this patch set are minor and straightforward.  Please review
it.  Any feedbacks or comments are welcome.

Thanks,
						- Zheng

Zheng Liu (7):
  ext4: refine extent status tree
  ext4: remove EXT4_MAP_FROM_CLUSTER flag
  ext4: add physical block and status member into extent status tree
  ext4: adjust interfaces of extent status tree
  ext4: track all extent status in extent status tree
  ext4: lookup block mapping in extent status tree
  ext4: reclaim extents from extent status tree

 fs/ext4/ext4.h              |  19 +-
 fs/ext4/extents.c           |  44 ++--
 fs/ext4/extents_status.c    | 505 ++++++++++++++++++++++++++++++++------------
 fs/ext4/extents_status.h    |  53 ++++-
 fs/ext4/file.c              |  14 +-
 fs/ext4/inode.c             | 138 +++++++++---
 fs/ext4/super.c             |   6 +
 include/trace/events/ext4.h | 118 ++++++++---
 8 files changed, 652 insertions(+), 245 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

