From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/47] libext2fs: set interior tree block goal more
 intelligently
Date: Fri, 07 Nov 2014 13:52:05 -0800
Message-ID: <20141107215205.883.11850.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45317 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaKGVwJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:52:09 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're splitting an extent node, try to allocate the new interior
tree block just prior to the first extent in the block we're trying to
split.  The previous logic only set a goal block if we had to split
both the current node and its parent, which is somewhat infrequent.
When that would happen, the goal would start at zero, leading to poor
locality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/extent.c         |   20 +++++++++++++++++++-
 tests/f_extents2/expect.1   |    2 +-
 tests/m_bigjournal/expect.1 |   10 +++++-----
 3 files changed, 25 insertions(+), 7 deletions(-)


diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index b6e4fbd..afb79c8 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -934,6 +934,25 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle,
 	orig_height = info.max_depth - info.curr_level;
 	orig_lblk = extent.e_lblk;
 
+	/* Try to put the index block before the first extent */
+	path = handle->path + handle->level;
+	eh = (struct ext3_extent_header *) path->buf;
+	if (handle->level == handle->max_depth) {
+		struct ext3_extent	*ex;
+
+		ex = EXT_FIRST_EXTENT(eh);
+		goal_blk = ext2fs_le32_to_cpu(ex->ee_start) +
+			((__u64) ext2fs_le16_to_cpu(ex->ee_start_hi) << 32);
+	} else {
+		struct ext3_extent_idx	*ix;
+
+		ix = EXT_FIRST_INDEX(eh);
+		goal_blk = ext2fs_le32_to_cpu(ix->ei_leaf) +
+			((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);
+	}
+	goal_blk -= EXT2FS_CLUSTER_RATIO(handle->fs);
+	goal_blk &= ~EXT2FS_CLUSTER_MASK(handle->fs);
+
 	/* Is there room in the parent for a new entry? */
 	if (handle->level &&
 			(handle->path[handle->level - 1].entries >=
@@ -947,7 +966,6 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle,
 		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
 		if (retval)
 			goto done;
-		goal_blk = extent.e_pblk;
 
 		retval = extent_node_split(handle, expand_allowed);
 		if (retval)
diff --git a/tests/f_extents2/expect.1 b/tests/f_extents2/expect.1
index 51e36ff..180568b 100644
--- a/tests/f_extents2/expect.1
+++ b/tests/f_extents2/expect.1
@@ -55,7 +55,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Block bitmap differences:  -(25--34) -(155--199)
+Block bitmap differences:  -(25--33) -(154--199)
 Fix? yes
 
 Free blocks count wrong for group #0 (65535, counted=55).
diff --git a/tests/m_bigjournal/expect.1 b/tests/m_bigjournal/expect.1
index 7246739..61d85f9 100644
--- a/tests/m_bigjournal/expect.1
+++ b/tests/m_bigjournal/expect.1
@@ -52,8 +52,8 @@ Group 0: (Blocks 0-32767)
   Reserved GDT blocks at 2-672
   Block bitmap at 673 (+673), Inode bitmap at 757 (+757)
   Inode table at 841-841 (+841)
-  31836 free blocks, 5 free inodes, 2 directories, 5 unused inodes
-  Free blocks: 932-32767
+  31837 free blocks, 5 free inodes, 2 directories, 5 unused inodes
+  Free blocks: 931-32767
   Free inodes: 12-16
 Group 1: (Blocks 32768-65535) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 32768, Group descriptors at 32769-32769
@@ -297,11 +297,11 @@ Group 38: (Blocks 1245184-1277951) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 1245184-1277951
   Free inodes: 609-624
-Group 39: (Blocks 1277952-1310719) [INODE_UNINIT, BLOCK_UNINIT]
+Group 39: (Blocks 1277952-1310719) [INODE_UNINIT]
   Block bitmap at 712 (bg #0 + 712), Inode bitmap at 796 (bg #0 + 796)
   Inode table at 880-880 (bg #0 + 880)
-  32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
-  Free blocks: 1277952-1310719
+  32767 free blocks, 16 free inodes, 0 directories, 16 unused inodes
+  Free blocks: 1277952-1310718
   Free inodes: 625-640
 Group 40: (Blocks 1310720-1343487) [INODE_UNINIT]
   Block bitmap at 713 (bg #0 + 713), Inode bitmap at 797 (bg #0 + 797)

