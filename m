From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] ext3: lighten up resize transaction requirements
Date: Thu, 27 Sep 2007 16:07:09 -0500
Message-ID: <46FC1B7D.2000601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbXI0VHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2007 17:07:14 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l8RL7AWG022970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 17:07:12 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l8RL7APi019101
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 17:07:10 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l8RL79sV013974
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 17:07:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've got a fedora bug, which has been fairly widely reported around the
net it seems, where attempting to do an online resize "requires too many
credits".  This usually leaves the person trying to do the resize fairly
befuddled.  There is a workaround to resize the journal to something larger,
but then this must be done offline, so what's the point really? :)

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

but with the change below:

[root@newbox ~]# mount -o loop fsfile mnt/
[root@newbox ~]# resize2fs /dev/loop0
resize2fs 1.40.2 (12-Jul-2007)
Filesystem at /dev/loop0 is mounted on /root/mnt; on-line resizing required
old desc_blocks = 1, new_desc_blocks = 1
Performing an on-line resize of /dev/loop0 to 32768 (1k) blocks.
The filesystem on /dev/loop0 is now 32768 blocks long.

Any comments?

Thanks,

-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.23-rc7/fs/ext3/resize.c
===================================================================
--- linux-2.6.23-rc7.orig/fs/ext3/resize.c
+++ linux-2.6.23-rc7/fs/ext3/resize.c
@@ -154,6 +154,32 @@ static void mark_bitmap_end(int start_bi
 }
 
 /*
+ * If we have fewer than "thresh" credits, extend by EXT3_MAX_TRANS_DATA.
+ * If that fails, restart the transaction & regain write access for the
+ * buffer head which is being used for block_bitmap modifications.
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
