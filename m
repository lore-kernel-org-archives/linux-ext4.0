From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/54] resize2fs: fix regression test to not depend on
 ext4.ko being loaded
Date: Mon, 26 Jan 2015 23:36:25 -0800
Message-ID: <20150127073625.13308.27450.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45581 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0Hga (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:36:30 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The behavior of the r_fixup_lastbg_big test varies depending on
whether or not ext4.ko is loaded and supports lazy_itable_init.  This
makes checking the bg flags after resize2fs hard to predict, so put in
a way to force resize2fs to zero the inode tables, and compare the
output based on lazy_itable_init == 0.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c              |    3 ++-
 tests/r_fixup_lastbg_big/expect |    4 +++-
 tests/r_fixup_lastbg_big/script |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 2febfde..041ff75 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -904,7 +904,8 @@ retry:
 	group_block = ext2fs_group_first_block2(fs,
 						old_fs->group_desc_count);
 	csum_flag = ext2fs_has_group_desc_csum(fs);
-	if (access("/sys/fs/ext4/features/lazy_itable_init", F_OK) == 0)
+	if (!getenv("RESIZE2FS_FORCE_ITABLE_INIT") &&
+	    access("/sys/fs/ext4/features/lazy_itable_init", F_OK) == 0)
 		lazy_itable_init = 1;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
diff --git a/tests/r_fixup_lastbg_big/expect b/tests/r_fixup_lastbg_big/expect
index 8f302a3..edaabaf 100644
--- a/tests/r_fixup_lastbg_big/expect
+++ b/tests/r_fixup_lastbg_big/expect
@@ -22,6 +22,8 @@ Group 2: (Blocks 16385-19999)
   Free blocks: 16385-19999
   Free inodes: 833-1248
 Resizing the filesystem on test.img to 40000 (1k) blocks.
+Begin pass 1 (max = 2)
+Extending the inode table     ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 The filesystem on test.img is now 40000 (1k) blocks long.
 
 Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT]
@@ -31,7 +33,7 @@ Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT]
   8192 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-24576
   Free inodes: 833-1248
-Group 3: (Blocks 24577-32768) [INODE_UNINIT]
+Group 3: (Blocks 24577-32768) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 24577, Group descriptors at 24578-24578
   Reserved GDT blocks at 24579-24656
   Block bitmap at 413 (bg #0 + 412)
diff --git a/tests/r_fixup_lastbg_big/script b/tests/r_fixup_lastbg_big/script
index 4c4a351..97d9fd4 100755
--- a/tests/r_fixup_lastbg_big/script
+++ b/tests/r_fixup_lastbg_big/script
@@ -13,7 +13,7 @@ $DEBUGFS -R "set_bg 2 flags 0" -w $TMPFILE > /dev/null 2>&1
 $DEBUGFS -R "set_bg 2 checksum 0xd318" -w $TMPFILE > /dev/null 2>&1
 $DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
 dd if=/dev/zero of=$TMPFILE bs=1 count=1 seek=$((1024 * 40000)) conv=notrunc >> $OUT 2> /dev/null
-$RESIZE2FS_EXE -f -p $TMPFILE >> $OUT 2>&1
+RESIZE2FS_FORCE_ITABLE_INIT=1 $RESIZE2FS_EXE -f -p $TMPFILE >> $OUT 2>&1
 $DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
 $E2FSCK -fy $TMPFILE >> $OUT 2>&1
 

