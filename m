From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext3: Update PF_MEMALLOC handling in ext3_write_inode()
Date: Fri, 28 Feb 2014 09:40:30 +0100
Message-ID: <1393576831-29915-2-git-send-email-jack@suse.cz>
References: <1393576831-29915-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbaB1Iki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Feb 2014 03:40:38 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E5DDE75026
	for <linux-ext4@vger.kernel.org>; Fri, 28 Feb 2014 08:40:37 +0000 (UTC)
In-Reply-To: <1393576831-29915-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The special handling of PF_MEMALLOC callers in ext3_write_inode()
shouldn't be necessary as there shouldn't be any. Warn about it. Also
update comment before the function as it seems somewhat outdated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 491f022c476a..2fef98abb207 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3209,21 +3209,20 @@ out_brelse:
  *
  * We are called from a few places:
  *
- * - Within generic_file_write() for O_SYNC files.
+ * - Within generic_file_aio_write() -> generic_write_sync() for O_SYNC files.
  *   Here, there will be no transaction running. We wait for any running
  *   transaction to commit.
  *
- * - Within sys_sync(), kupdate and such.
- *   We wait on commit, if tol to.
+ * - Within flush work (for sys_sync(), kupdate and such).
+ *   We wait on commit, if told to.
  *
- * - Within prune_icache() (PF_MEMALLOC == true)
- *   Here we simply return.  We can't afford to block kswapd on the
- *   journal commit.
+ * - Within iput_final() -> write_inode_now()
+ *   We wait on commit, if told to.
  *
  * In all cases it is actually safe for us to return without doing anything,
  * because the inode has been copied into a raw inode buffer in
- * ext3_mark_inode_dirty().  This is a correctness thing for O_SYNC and for
- * knfsd.
+ * ext3_mark_inode_dirty().  This is a correctness thing for WB_SYNC_ALL
+ * writeback.
  *
  * Note that we are absolutely dependent upon all inode dirtiers doing the
  * right thing: they *must* call mark_inode_dirty() after dirtying info in
@@ -3235,13 +3234,13 @@ out_brelse:
  *	stuff();
  *	inode->i_size = expr;
  *
- * is in error because a kswapd-driven write_inode() could occur while
- * `stuff()' is running, and the new i_size will be lost.  Plus the inode
- * will no longer be on the superblock's dirty inode list.
+ * is in error because write_inode() could occur while `stuff()' is running,
+ * and the new i_size will be lost.  Plus the inode will no longer be on the
+ * superblock's dirty inode list.
  */
 int ext3_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	if (current->flags & PF_MEMALLOC)
+	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC))
 		return 0;
 
 	if (ext3_journal_current_handle()) {
-- 
1.8.1.4

