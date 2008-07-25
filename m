From: akpm@linux-foundation.org
Subject: [patch 069/283] ext3: handle corrupted orphan list at mount
Date: Fri, 25 Jul 2008 00:02:01 -0700
Message-ID: <200807250702.m6P721g8028456@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbYGYHCG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 03:02:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Duane Griffin" <duaneg@dghda.com>

If the orphan node list includes valid, untruncatable nodes with nlink > 0
the ext3_orphan_cleanup loop which attempts to delete them will not do so,
causing it to loop forever. Fix by checking for such nodes in the
ext3_orphan_get function.

This patch fixes the second case (image hdb.20000009.softlockup.gz)
reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: printk warning fix]
Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c        |    9 +++++++++
 fs/ext3/inode.c         |   20 ++++++++++++++------
 include/linux/ext3_fs.h |    1 +
 3 files changed, 24 insertions(+), 6 deletions(-)

diff -puN fs/ext3/ialloc.c~ext3-handle-corrupted-orphan-list-at-mount fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~ext3-handle-corrupted-orphan-list-at-mount
+++ a/fs/ext3/ialloc.c
@@ -669,6 +669,14 @@ struct inode *ext3_orphan_get(struct sup
 	if (IS_ERR(inode))
 		goto iget_failed;
 
+	/*
+	 * If the orphans has i_nlinks > 0 then it should be able to be
+	 * truncated, otherwise it won't be removed from the orphan list
+	 * during processing and an infinite loop will result.
+	 */
+	if (inode->i_nlink && !ext3_can_truncate(inode))
+		goto bad_orphan;
+
 	if (NEXT_ORPHAN(inode) > max_ino)
 		goto bad_orphan;
 	brelse(bitmap_bh);
@@ -690,6 +698,7 @@ bad_orphan:
 		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
 		       NEXT_ORPHAN(inode));
 		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
+		printk(KERN_NOTICE "i_nlink=%u\n", inode->i_nlink);
 		/* Avoid freeing blocks if we got a bad deleted inode */
 		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
diff -puN fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount
+++ a/fs/ext3/inode.c
@@ -2253,6 +2253,19 @@ static void ext3_free_branches(handle_t 
 	}
 }
 
+int ext3_can_truncate(struct inode *inode)
+{
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return 0;
+	if (S_ISREG(inode->i_mode))
+		return 1;
+	if (S_ISDIR(inode->i_mode))
+		return 1;
+	if (S_ISLNK(inode->i_mode))
+		return !ext3_inode_is_fast_symlink(inode);
+	return 0;
+}
+
 /*
  * ext3_truncate()
  *
@@ -2297,12 +2310,7 @@ void ext3_truncate(struct inode *inode)
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	struct page *page;
 
-	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	    S_ISLNK(inode->i_mode)))
-		return;
-	if (ext3_inode_is_fast_symlink(inode))
-		return;
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+	if (!ext3_can_truncate(inode))
 		return;
 
 	/*
diff -puN include/linux/ext3_fs.h~ext3-handle-corrupted-orphan-list-at-mount include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-handle-corrupted-orphan-list-at-mount
+++ a/include/linux/ext3_fs.h
@@ -832,6 +832,7 @@ extern void ext3_discard_reservation (st
 extern void ext3_dirty_inode(struct inode *);
 extern int ext3_change_inode_journal_flag(struct inode *, int);
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
+extern int ext3_can_truncate(struct inode *inode);
 extern void ext3_truncate (struct inode *);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
_
