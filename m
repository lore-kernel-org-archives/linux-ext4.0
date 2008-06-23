From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] ext3: handle corrupted orphan list at mount
Date: Mon, 23 Jun 2008 22:56:40 +0100
Message-ID: <1214258200-16623-1-git-send-email-duaneg@dghda.com>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1344 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbYFWV4n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 17:56:43 -0400
In-Reply-To: <20080607121940.8ee6044a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the orphan node list includes valid, untruncatable nodes with nlink > 0
the ext3_orphan_cleanup loop which attempts to delete them will not do so,
causing it to loop forever. Fix by checking for such nodes in the
ext3_orphan_get function.

This patch fixes the second case (image hdb.20000009.softlockup.gz)
reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

Note that we can still end up in an infinite loop if the ext3_truncate
errors out early (and keeps doing so). I'm not sure if we should worry
about that. If we did want to handle it then we could change ext3_truncate
to return success/failure and exit the ext3_orphan_cleanup.

---

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 7712682..bc030f4 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -669,6 +669,14 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
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
+		printk(KERN_NOTICE "i_nlink=%lu\n", inode->i_nlink);
 		/* Avoid freeing blocks if we got a bad deleted inode */
 		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 6ae4ecf..7b7e234 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2253,6 +2253,14 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
 	}
 }
 
+int ext3_can_truncate(struct inode *inode)
+{
+	return (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+		S_ISLNK(inode->i_mode)) &&
+		!ext3_inode_is_fast_symlink(inode) &&
+		!(IS_APPEND(inode) || IS_IMMUTABLE(inode));
+}
+
 /*
  * ext3_truncate()
  *
@@ -2297,12 +2305,7 @@ void ext3_truncate(struct inode *inode)
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
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..80171ee 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -832,6 +832,7 @@ extern void ext3_discard_reservation (struct inode *);
 extern void ext3_dirty_inode(struct inode *);
 extern int ext3_change_inode_journal_flag(struct inode *, int);
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
+extern int ext3_can_truncate(struct inode *inode);
 extern void ext3_truncate (struct inode *);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
