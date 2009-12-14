From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/4] ext3: Replace lock/unlock_super() with an explicit lock
 for the orphan list
Date: Mon, 14 Dec 2009 13:00:30 -0600
Message-ID: <4B268B4E.10100@redhat.com>
References: <4B268A3C.8060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbZLNTA0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 14:00:26 -0500
In-Reply-To: <4B268A3C.8060708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@mit.edu>

Use a separate lock to protect the orphan list, so we can stop
overloading the use of lock_super().

Crossport of 3b9d4ed26680771295d904a6b83e88e620780893

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext3/namei.c            |   20 +++++++++++---------
 fs/ext3/super.c            |    1 +
 include/linux/ext3_fs_sb.h |    1 +
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index aad6400..76d4c58 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1920,7 +1920,7 @@ int ext3_orphan_add(handle_t *handle, struct inode *inode)
 	struct ext3_iloc iloc;
 	int err = 0, rc;
 
-	lock_super(sb);
+	mutex_lock(&EXT3_SB(sb)->s_orphan_lock);
 	if (!list_empty(&EXT3_I(inode)->i_orphan))
 		goto out_unlock;
 
@@ -1929,9 +1929,13 @@ int ext3_orphan_add(handle_t *handle, struct inode *inode)
 
 	/* @@@ FIXME: Observation from aviro:
 	 * I think I can trigger J_ASSERT in ext3_orphan_add().  We block
-	 * here (on lock_super()), so race with ext3_link() which might bump
+	 * here (on s_orphan_lock), so race with ext3_link() which might bump
 	 * ->i_nlink. For, say it, character device. Not a regular file,
 	 * not a directory, not a symlink and ->i_nlink > 0.
+	 *
+	 * tytso, 4/25/2009: I'm not sure how that could happen;
+	 * shouldn't the fs core protect us from these sort of
+	 * unlink()/link() races?
 	 */
 	J_ASSERT ((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 		S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
@@ -1968,7 +1972,7 @@ int ext3_orphan_add(handle_t *handle, struct inode *inode)
 	jbd_debug(4, "orphan inode %lu will point to %d\n",
 			inode->i_ino, NEXT_ORPHAN(inode));
 out_unlock:
-	unlock_super(sb);
+	mutex_unlock(&EXT3_SB(sb)->s_orphan_lock);
 	ext3_std_error(inode->i_sb, err);
 	return err;
 }
@@ -1986,11 +1990,9 @@ int ext3_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext3_iloc iloc;
 	int err = 0;
 
-	lock_super(inode->i_sb);
-	if (list_empty(&ei->i_orphan)) {
-		unlock_super(inode->i_sb);
-		return 0;
-	}
+	mutex_lock(&EXT3_SB(inode->i_sb)->s_orphan_lock);
+	if (list_empty(&ei->i_orphan))
+		goto out;
 
 	ino_next = NEXT_ORPHAN(inode);
 	prev = ei->i_orphan.prev;
@@ -2040,7 +2042,7 @@ int ext3_orphan_del(handle_t *handle, struct inode *inode)
 out_err:
 	ext3_std_error(inode->i_sb, err);
 out:
-	unlock_super(inode->i_sb);
+	mutex_unlock(&EXT3_SB(inode->i_sb)->s_orphan_lock);
 	return err;
 
 out_brelse:
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 602b308..534557c 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1890,6 +1890,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sb->dq_op = &ext3_quota_operations;
 #endif
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
+	mutex_init(&sbi->s_orphan_lock);
 
 	sb->s_root = NULL;
 
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index f07f34d..dd61d83 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -72,6 +72,7 @@ struct ext3_sb_info {
 	struct inode * s_journal_inode;
 	struct journal_s * s_journal;
 	struct list_head s_orphan;
+	struct mutex s_orphan_lock;
 	unsigned long s_commit_interval;
 	struct block_device *journal_bdev;
 #ifdef CONFIG_JBD_DEBUG
-- 1.6.0.6

