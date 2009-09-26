From: Frank Mayhar <fmayhar@google.com>
Subject: [PATCH] ext4: Make non-journal fsync work properly.  (Version 3)
Date: Fri, 25 Sep 2009 17:39:05 -0700
Message-ID: <1253925545.22432.57.camel@bobble.smo.corp.google.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
	 <20090908050614.GA10477@mit.edu>
	 <1252424465.17646.7.camel@bobble.smo.corp.google.com>
	 <20090908220504.GS22901@mit.edu>
	 <1252517664.18594.3.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:38103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZIZAjI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Sep 2009 20:39:08 -0400
In-Reply-To: <1252517664.18594.3.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch follows Aneesh' suggestion of just calling
sync_dirty_buffer() directly.  Sorry about the delay, I've been busy

Teach ext4_write_inode() about non-journal mode in a better way,
suggested upstream.  Instead of using ext4_do_update_inode(), it
now calls sync_dirty_buffer() directly.  Also handle possible
error return from that function.

Signed-off-by: Frank Mayhar <fmayhar@google.com>

 fs/ext4/inode.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d87f6a0..ab31cc4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4892,19 +4892,40 @@ out_brelse:
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
+		if (wait)
+			sync_dirty_buffer(iloc.bh);
+		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
+			ext4_error(inode->i_sb, __func__,
+				   "IO error syncing inode, "
+				   "inode=%lu, block=%llu",
+				   inode->i_ino,
+				   (unsigned long long)iloc.bh->b_blocknr);
+			err = -EIO;
+		}
+	}
+	return err;
 }
 
 /*

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

