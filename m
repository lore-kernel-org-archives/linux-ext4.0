From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] - ext3: lighten up resize transaction requirements
Date: Mon, 01 Oct 2007 14:24:52 -0500
Message-ID: <47014984.9060600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXJATY5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 15:24:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Andreas Dilger <adilger@clusterfs.com>

Index: linux-2.6.23-rc7/fs/ext3/resize.c
===================================================================
--- linux-2.6.23-rc7.orig/fs/ext3/resize.c
+++ linux-2.6.23-rc7/fs/ext3/resize.c
@@ -154,6 +154,32 @@ static void mark_bitmap_end(int start_bi
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
+		if ((err = ext3_journal_restart(handle, EXT3_MAX_TRANS_DATA)))
+			return err;
+	        if ((err = ext3_journal_get_write_access(handle, bh)))
+			return err;
+        }
+
+	return 0;
+}
+
+/*
  * Set up the block and inode bitmaps, and the inode table for the new group.
  * This doesn't need to be part of the main transaction, since we are only
  * changing blocks outside the actual filesystem.  We still do journaling to
@@ -175,8 +201,9 @@ static int setup_new_group_blocks(struct
 	int i;
 	int err = 0, err2;
 
-	handle = ext3_journal_start_sb(sb, reserved_gdb + gdblocks +
-				       2 + sbi->s_itb_per_group);
+	/* This transaction may be extended/restarted along the way */
+	handle = ext3_journal_start_sb(sb, EXT3_MAX_TRANS_DATA);
+
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -203,6 +230,9 @@ static int setup_new_group_blocks(struct
 
 		ext3_debug("update backup group %#04lx (+%d)\n", block, bit);
 
+		if ((err = extend_or_restart_transaction(handle, 1, bh)))
+			goto exit_bh;
+
 		gdb = sb_getblk(sb, block);
 		if (!gdb) {
 			err = -EIO;
@@ -228,6 +258,9 @@ static int setup_new_group_blocks(struct
 
 		ext3_debug("clear reserved block %#04lx (+%d)\n", block, bit);
 
+		if ((err = extend_or_restart_transaction(handle, 1, bh)))
+			goto exit_bh;
+
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
 			err = PTR_ERR(bh);
 			goto exit_bh;
@@ -249,6 +282,10 @@ static int setup_new_group_blocks(struct
 		struct buffer_head *it;
 
 		ext3_debug("clear inode block %#04lx (+%d)\n", block, bit);
+
+		if ((err = extend_or_restart_transaction(handle, 1, bh)))
+			goto exit_bh;
+
 		if (IS_ERR(it = bclean(handle, sb, block))) {
 			err = PTR_ERR(it);
 			goto exit_bh;
@@ -257,6 +294,10 @@ static int setup_new_group_blocks(struct
 		brelse(it);
 		ext3_set_bit(bit, bh->b_data);
 	}
+
+	if ((err = extend_or_restart_transaction(handle, 2, bh)))
+		goto exit_bh;
+
 	mark_bitmap_end(input->blocks_count, EXT3_BLOCKS_PER_GROUP(sb),
 			bh->b_data);
 	ext3_journal_dirty_metadata(handle, bh);
