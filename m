From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] ext4: handle corrupted orphan list at mount
Date: Tue,  8 Jul 2008 15:41:59 +0100
Message-ID: <1215528121-26934-1-git-send-email-duaneg@dghda.com>
Cc: sct@redhat.com, adilger@clusterfs.com, Mingming <cmm@us.ibm.com>,
	Sami Liedes <sliedes@cc.hut.fi>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2716 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbYGHOmG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2008 10:42:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the orphan node list includes valid, untruncatable nodes with nlink > 0
the ext4_orphan_cleanup loop which attempts to delete them will not do so,
causing it to loop forever. Fix by checking for such nodes in the
ext4_orphan_get function.

This patch fixes the second case (image hdb.20000009.softlockup.gz)
reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

This is an ext4 version of an ext3 patch queued in -mm.
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8158083..f7a0758 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1039,6 +1039,7 @@ extern void ext4_discard_reservation (struct inode *);
 extern void ext4_dirty_inode(struct inode *);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
+extern int ext4_can_truncate(struct inode *inode);
 extern void ext4_truncate (struct inode *);
 extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c6efbab..11cafe1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -817,6 +817,14 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 	if (IS_ERR(inode))
 		goto iget_failed;
 
+	/*
+	 * If the orphans has i_nlinks > 0 then it should be able to be
+	 * truncated, otherwise it won't be removed from the orphan list
+	 * during processing and an infinite loop will result.
+	 */
+	if (inode->i_nlink && !ext4_can_truncate(inode))
+		goto bad_orphan;
+
 	if (NEXT_ORPHAN(inode) > max_ino)
 		goto bad_orphan;
 	brelse(bitmap_bh);
@@ -838,6 +846,7 @@ bad_orphan:
 		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
 		       NEXT_ORPHAN(inode));
 		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
+		printk(KERN_NOTICE "i_nlink=%u\n", inode->i_nlink);
 		/* Avoid freeing blocks if we got a bad deleted inode */
 		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d97077..269763b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2305,6 +2305,19 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 	}
 }
 
+int ext4_can_truncate(struct inode *inode)
+{
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return 0;
+	if (S_ISREG(inode->i_mode))
+		return 1;
+	if (S_ISDIR(inode->i_mode))
+		return 1;
+	if (S_ISLNK(inode->i_mode))
+		return !ext4_inode_is_fast_symlink(inode);
+	return 0;
+}
+
 /*
  * ext4_truncate()
  *
@@ -2349,12 +2362,7 @@ void ext4_truncate(struct inode *inode)
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	struct page *page;
 
-	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	    S_ISLNK(inode->i_mode)))
-		return;
-	if (ext4_inode_is_fast_symlink(inode))
-		return;
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+	if (!ext4_can_truncate(inode))
 		return;
 
 	/*
