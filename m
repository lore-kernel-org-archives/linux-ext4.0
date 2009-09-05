From: Frank Mayhar <fmayhar@google.com>
Subject: [PATCH] Make non-journal fsync work properly.
Date: Fri, 04 Sep 2009 19:55:00 -0700
Message-ID: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:29649 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbZIECzF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 22:55:05 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id n852t6Bf017918
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 19:55:06 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
mode:  If we're not using a journal, ext4_write_inode() now calls
ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
with a new "do_sync" parameter.  If that parameter is nonzero
ext4_do_update_inode() calls sync_dirty_buffer() instead of
ext4_handle_dirty_metadata().

This problem was found in power-fail testing, checking the amount of
loss of files and blocks after a power failure when using fsync() and
when not using fsync().  It turned out that using fsync() was actually
worse than not doing so, possibly because it increased the likelihood
that the inodes would remain unflushed and would therefore be lost at
the power failure.

Signed-off-by: Frank Mayhar <fmayhar@google.com>

 fs/ext4/inode.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d87f6a0..24dbfb6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4741,7 +4741,8 @@ static int ext4_inode_blocks_set(handle_t *handle,
  */
 static int ext4_do_update_inode(handle_t *handle,
 				struct inode *inode,
-				struct ext4_iloc *iloc)
+				struct ext4_iloc *iloc,
+				int do_sync)
 {
 	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -4843,10 +4844,20 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
-	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-	rc = ext4_handle_dirty_metadata(handle, inode, bh);
-	if (!err)
-		err = rc;
+	/*
+	 * This is only true if we're not using a journal and we were called
+	 * from ext4_write_inode() to sync the inode.  We can therefore just
+	 * use sync_dirty_buffer() directly to do the dirty work.
+	 */
+	if (do_sync) {
+		BUFFER_TRACE(bh, "call sync_dirty_buffer");
+		sync_dirty_buffer(bh);
+	} else {
+		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		rc = ext4_handle_dirty_metadata(handle, inode, bh);
+		if (!err)
+			err = rc;
+	}
 	ei->i_state &= ~EXT4_STATE_NEW;
 
 out_brelse:
@@ -4892,19 +4903,32 @@ out_brelse:
  */
 int ext4_write_inode(struct inode *inode, int wait)
 {
+	int err;
+
 	if (current->flags & PF_MEMALLOC)
 		return 0;
 
-	if (ext4_journal_current_handle()) {
-		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
-		dump_stack();
-		return -EIO;
-	}
+	if (EXT4_SB(inode->i_sb)->s_journal) {
+		if (ext4_journal_current_handle()) {
+			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
+			dump_stack();
+			return -EIO;
+		}
 
-	if (!wait)
-		return 0;
+		if (!wait)
+			return 0;
+
+		err = ext4_force_commit(inode->i_sb);
+	} else {
+		struct ext4_iloc iloc;
 
-	return ext4_force_commit(inode->i_sb);
+		err = ext4_get_inode_loc(inode, &iloc);
+		if (err)
+			return err;
+		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
+					   inode, &iloc, wait);
+	}
+	return err;
 }
 
 /*
@@ -5198,7 +5222,7 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	get_bh(iloc->bh);
 
 	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
-	err = ext4_do_update_inode(handle, inode, iloc);
+	err = ext4_do_update_inode(handle, inode, iloc, 0);
 	put_bh(iloc->bh);
 	return err;
 }

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

