From: akpm@linux-foundation.org
Subject: - ext3-lighten-up-resize-transaction-requirements.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:55 -0700
Message-ID: <200710180701.l9I71tFd031215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: sandeen@redhat.com, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: lighten up resize transaction requirements
has been removed from the -mm tree.  Its filename was
     ext3-lighten-up-resize-transaction-requirements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: lighten up resize transaction requirements
From: Eric Sandeen <sandeen@redhat.com>

When resizing online, setup_new_group_blocks attempts to reserve a
potentially very large transaction, depending on the current filesystem
geometry.  For some journal sizes, there may not be enough room for this
transaction, and the online resize will fail.

The patch below resizes & restarts the transaction as necessary while
setting up the new group, and should work with even the smallest journal.

Tested with something like:

[root@newbox ~]# dd if=/dev/zero of=fsfile bs=1024 count=32768
[root@newbox ~]# mkfs.ext3 -b 1024 fsfile 16384
[root@newbox ~]# mount -o loop fsfile mnt/
[root@newbox ~]# resize2fs /dev/loop0
resize2fs 1.40.2 (12-Jul-2007)
Filesystem at /dev/loop0 is mounted on /root/mnt; on-line resizing required
old desc_blocks = 1, new_desc_blocks = 1
Performing an on-line resize of /dev/loop0 to 32768 (1k) blocks.
resize2fs: No space left on device While trying to add group #2
[root@newbox ~]# dmesg | tail -n 1
JBD: resize2fs wants too many credits (258 > 256)
[root@newbox ~]#

With the below change, it works.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Andreas Dilger <adilger@clusterfs.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/resize.c |   51 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff -puN fs/ext3/resize.c~ext3-lighten-up-resize-transaction-requirements fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-lighten-up-resize-transaction-requirements
+++ a/fs/ext3/resize.c
@@ -154,6 +154,34 @@ static void mark_bitmap_end(int start_bi
 }
 
 /*
+ * If we have fewer than thresh credits, extend by EXT3_MAX_TRANS_DATA.
+ * If that fails, restart the transaction & regain write access for the
+ * buffer head which is used for block_bitmap modifications.
+ */
+static int extend_or_restart_transaction(handle_t *handle, int thresh,
+					 struct buffer_head *bh)
+{
+	int err;
+
+	if (handle->h_buffer_credits >= thresh)
+		return 0;
+
+	err = ext3_journal_extend(handle, EXT3_MAX_TRANS_DATA);
+	if (err < 0)
+		return err;
+	if (err) {
+		err = ext3_journal_restart(handle, EXT3_MAX_TRANS_DATA);
+		if (err)
+			return err;
+		err = ext3_journal_get_write_access(handle, bh);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/*
  * Set up the block and inode bitmaps, and the inode table for the new group.
  * This doesn't need to be part of the main transaction, since we are only
  * changing blocks outside the actual filesystem.  We still do journaling to
@@ -175,8 +203,9 @@ static int setup_new_group_blocks(struct
 	int i;
 	int err = 0, err2;
 
-	handle = ext3_journal_start_sb(sb, reserved_gdb + gdblocks +
-				       2 + sbi->s_itb_per_group);
+	/* This transaction may be extended/restarted along the way */
+	handle = ext3_journal_start_sb(sb, EXT3_MAX_TRANS_DATA);
+
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -203,6 +232,10 @@ static int setup_new_group_blocks(struct
 
 		ext3_debug("update backup group %#04lx (+%d)\n", block, bit);
 
+		err = extend_or_restart_transaction(handle, 1, bh);
+		if (err)
+			goto exit_bh;
+
 		gdb = sb_getblk(sb, block);
 		if (!gdb) {
 			err = -EIO;
@@ -228,6 +261,10 @@ static int setup_new_group_blocks(struct
 
 		ext3_debug("clear reserved block %#04lx (+%d)\n", block, bit);
 
+		err = extend_or_restart_transaction(handle, 1, bh);
+		if (err)
+			goto exit_bh;
+
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
 			err = PTR_ERR(bh);
 			goto exit_bh;
@@ -249,6 +286,11 @@ static int setup_new_group_blocks(struct
 		struct buffer_head *it;
 
 		ext3_debug("clear inode block %#04lx (+%d)\n", block, bit);
+
+		err = extend_or_restart_transaction(handle, 1, bh);
+		if (err)
+			goto exit_bh;
+
 		if (IS_ERR(it = bclean(handle, sb, block))) {
 			err = PTR_ERR(it);
 			goto exit_bh;
@@ -257,6 +299,11 @@ static int setup_new_group_blocks(struct
 		brelse(it);
 		ext3_set_bit(bit, bh->b_data);
 	}
+
+	err = extend_or_restart_transaction(handle, 2, bh);
+	if (err)
+		goto exit_bh;
+
 	mark_bitmap_end(input->blocks_count, EXT3_BLOCKS_PER_GROUP(sb),
 			bh->b_data);
 	ext3_journal_dirty_metadata(handle, bh);
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ext4-remove-ifdef-config_ext4_index.patch
ext3-fix-setup_new_group_blocks-locking.patch
