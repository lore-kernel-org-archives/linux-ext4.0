From: Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH RFC] e2fsprogs: Speed up ext2fs_new_block2
Date: Fri, 20 Feb 2015 15:41:54 -0800
Message-ID: <54E7C642.3020003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: tytso@mit.edu, darrick.wong@oracle.com,
	richard.purdie@linuxfoundation.org, liezhi.yang@windriver.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54567 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbbBTXl4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2015 18:41:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted and Darrick,

We're back with a Yocto Project use case. We use mkfs.ext4 to create our
root filesystems. For one of our larger images including an X desktop
and an SDK (toolchain, etc.), it took over 8 minutes to complete.
Richard Purdie noticed most of this time was in ext2fs_new_block2. He
provided this small hack to test an idea and it has reduced the runtime
to 35 seconds. The images function as expected.

Can you have a look and see if there some value in this approach, or if
perhaps it might lead to a more appropriate/correct solution?

Thanks!

Darren

(What follows is the test patch from Richard for the Yocto Project)


The comment to this function says:

"""
  * Stupid algorithm --- we now just search forward starting from the
  * goal.  Should put in a smarter one someday....
"""

This adds in a rather hacky algorthim which starts where we finished
searching previously using a static variable rather than starting
from scratch if a hint isn't provided.

This was after noticing that mkfs.ext4 -F X -d Y was spending *lots*
of time in ext2fs_new_block2 called from ext2fs_bmap from
ext2fs_file_write().

Numbers wise, this took a core-image-sato-sdk mkfs time from over
8 minutes to around 35 seconds.

Upstream-Status: Pending

RP 2015/02/20

Index: e2fsprogs-1.42.9/lib/ext2fs/alloc.c
===================================================================
--- e2fsprogs-1.42.9.orig/lib/ext2fs/alloc.c
+++ e2fsprogs-1.42.9/lib/ext2fs/alloc.c
@@ -160,6 +160,8 @@ errcode_t ext2fs_new_inode(ext2_filsys f
 	return 0;
 }

+static blk64_t last_goal = 0;
+
 /*
  * Stupid algorithm --- we now just search forward starting from the
  * goal.  Should put in a smarter one someday....
@@ -170,6 +172,9 @@ errcode_t ext2fs_new_block2(ext2_filsys
 	blk64_t	i;
 	int	c_ratio;

+        if (!goal)
+            goal = last_goal;
+
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);

 	if (!map)
@@ -194,6 +199,7 @@ errcode_t ext2fs_new_block2(ext2_filsys

 		if (!ext2fs_fast_test_block_bitmap2(map, i)) {
 			*ret = i;
+			last_goal = i;
 			return 0;
 		}
 		i = (i + c_ratio) & ~(c_ratio - 1);

-- 
Darren Hart
Intel Open Source Technology Center
