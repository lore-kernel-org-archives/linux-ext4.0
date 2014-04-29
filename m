From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Wed, 30 Apr 2014 01:32:33 +0200
Message-ID: <1398814353-11904-3-git-send-email-jack@suse.cz>
References: <1398814353-11904-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaD2Xcm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 19:32:42 -0400
In-Reply-To: <1398814353-11904-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Shuffle code around in ext4_orphan_add() and ext4_orphan_del() so that
we avoid taking global s_orphan_lock in some cases and hold it for
shorter time in other cases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 411957326827..4253df8af9ef 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2539,13 +2539,17 @@ static int empty_dir(struct inode *inode)
 	return 1;
 }
 
-/* ext4_orphan_add() links an unlinked or truncated inode into a list of
+/*
+ * ext4_orphan_add() links an unlinked or truncated inode into a list of
  * such inodes, starting at the superblock, in case we crash before the
  * file is closed/deleted, or in case the inode truncate spans multiple
  * transactions and the last transaction is not recovered after a crash.
  *
  * At filesystem recovery time, we walk this list deleting unlinked
  * inodes and truncating linked inodes in ext4_orphan_cleanup().
+ *
+ * Orphan list manipulation functions must be called under i_mutex unless
+ * we are just creating the inode or deleting it.
  */
 int ext4_orphan_add(handle_t *handle, struct inode *inode)
 {
@@ -2556,9 +2560,14 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	if (!EXT4_SB(sb)->s_journal)
 		return 0;
 
-	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
-	if (!list_empty(&EXT4_I(inode)->i_orphan))
-		goto out_unlock;
+	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+		     !mutex_is_locked(&inode->i_mutex));
+	/*
+	 * Exit early if inode already is on orphan list. This is a big speedup
+	 * since we don't have to contend on the global s_orphan_lock.
+	 */
+ 	if (!list_empty(&EXT4_I(inode)->i_orphan))
+		return 0;
 
 	/*
 	 * Orphan handling is only valid for files with data blocks
@@ -2577,6 +2586,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
 		goto out_unlock;
+	
+	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
 	/*
 	 * Due to previous errors inode may be already a part of on-disk
 	 * orphan list. If so skip on-disk list modification.
@@ -2630,10 +2641,22 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
-	mutex_lock(&sbi->s_orphan_lock);
+	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+		     !mutex_is_locked(&inode->i_mutex));
+	/*
+	 * Do this quick and racy check before taking global s_orphan_lock.
+	 */
 	if (list_empty(&ei->i_orphan))
-		goto out;
+		return 0;
 
+	/* Grab inode buffer early before taking global s_orphan_lock */
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err) {
+		list_del_init(&ei->i_orphan);
+		return err;
+	}
+
+	mutex_lock(&sbi->s_orphan_lock);
 	ino_next = NEXT_ORPHAN(inode);
 	prev = ei->i_orphan.prev;
 
@@ -2648,10 +2671,6 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	if (!handle)
 		goto out;
 
-	err = ext4_reserve_inode_write(handle, inode, &iloc);
-	if (err)
-		goto out_err;
