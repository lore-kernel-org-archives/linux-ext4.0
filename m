From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: Improve the documentation for ext4's /proc tunables
Date: Thu, 09 Oct 2008 12:49:26 -0400
Message-ID: <E1Knyha-0004G7-S2@closure.thunk.org>
Cc: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50470 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755475AbYJIQta (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 12:49:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


When Aneesh asked me to update the /proc documentation for the new
tunable inode_readahead_blks in /proc/fs/ext4/<devname>, it forced me to
look at the current documentation, and some of the text caused my gorge
to rise and my English parser to core dump.  :-(

So I considered it a moral imperative to rewrite section 1.10 of
Documentation/filesystems/proc.txt.  I *think* I got the definitions of
the mballoc tuning parameters correct, but the original text made it
hard to understand what exactly some of these tuning parameters meant,
and so I was forced to go RTFS.   Alex, Andreas, could you quickly
double check the new documentation and make sure I got things right?

Thanks, regards,

					- Ted

>From be75f52f5e9acd376c64ff41f84314213bb761bb Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 9 Oct 2008 12:48:49 -0400
Subject: [PATCH] ext4: Improve the documentation for ext4's /proc tunables

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alex Tomas <bzzz@sun.com>
Cc: Andreas Dilger <adilger@sun.com>
---
 Documentation/filesystems/proc.txt |   70 +++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f566ad9..bcf742d 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -923,45 +923,41 @@ CPUs.
 The   "procs_blocked" line gives  the  number of  processes currently blocked,
 waiting for I/O to complete.
 
+
 1.9 Ext4 file system parameters
 ------------------------------
-Ext4 file system have one directory per partition under /proc/fs/ext4/
-# ls /proc/fs/ext4/hdc/
-group_prealloc  max_to_scan  mb_groups  mb_history  min_to_scan  order2_req
-stats  stream_req
-
-mb_groups:
-This file gives the details of multiblock allocator buddy cache of free blocks
-
-mb_history:
-Multiblock allocation history.
-
-stats:
-This file indicate whether the multiblock allocator should start collecting
-statistics. The statistics are shown during unmount
-
-group_prealloc:
-The multiblock allocator normalize the block allocation request to
-group_prealloc filesystem blocks if we don't have strip value set.
-The stripe value can be specified at mount time or during mke2fs.
-
-max_to_scan:
-How long multiblock allocator can look for a best extent (in found extents)
-
-min_to_scan:
-How long multiblock allocator  must look for a best extent
-
-order2_req:
-Multiblock allocator use  2^N search using buddies only for requests greater
-than or equal to order2_req. The request size is specfied in file system
-blocks. A value of 2 indicate only if the requests are greater than or equal
-to 4 blocks.
-
-stream_req:
-Files smaller than stream_req are served by the stream allocator, whose
-purpose is to pack requests as close each to other as possible to
-produce smooth I/O traffic. Avalue of 16 indicate that file smaller than 16
-filesystem block size will use group based preallocation.
+
+Information about mounted ext4 file systems can be found in
+/proc/fs/ext4.  Each mounted filesystem will have a directory in
+/proc/fs/ext4 based on its device name (i.e., /proc/fs/ext4/hdc or
+/proc/fs/ext4/dm-0).   The files in each per-device directory are shown
+in Table 1-10, below.
+
+Table 1-10: Files in /proc/fs/ext4/<devname>
+..............................................................................
+ File            Content                                        
+ mb_groups       details of multiblock allocator buddy cache of free blocks
+ mb_history      multiblock allocation history
+ stats           controls whether the multiblock allocator should start
+                 collecting statistics, which are shown during the unmount
+ group_prealloc  the multiblock allocator will round up allocation
+                 requests to a multiple of this tuning parameter if the
+                 stripe size is not set in the ext4 superblock
+ max_to_scan     The maximum number of extents the multiblock allocator
+                 will search to find the best extent
+ min_to_scan     The minum number of extents the multiblock allocator
+                 will search to find the best extent
+ order2_req      Tuning parameter which controls the minimum size for 
+                 requests (as a power of 2) where the buddy cache is
+                 used
+ stream_req      Files which have fewer blocks than this tunable
+                 parameter will have their blocks allocated out of a
+                 block group specific preallocation pool, so that small
+                 files are packed closely together.  Each large files
+                 will have its blocks allocated out of its own unique
+                 preallocation pool.
+..............................................................................
+
 
 ------------------------------------------------------------------------------
 Summary
-- 
1.5.6.1.205.ge2c7.dirty

