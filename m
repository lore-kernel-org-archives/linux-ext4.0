From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] ext4: refactor duplicated block placement code
Date: Mon, 27 Jun 2011 15:39:11 -0500
Message-ID: <4E08EA6F.4010102@redhat.com>
References: <4E023652.2010903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1F0UjN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 16:39:13 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5RKdC8i029876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 16:39:13 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5RKdBIF008104
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 16:39:12 -0400
In-Reply-To: <4E023652.2010903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I found that ext4_ext_find_goal() and ext4_find_near()
share the same code for returning a coloured start block
based on i_block_group.

We can refactor this into a common function so that they
don't diverge in the future.

Thanks to adilger for suggesting the new function name.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 ext4.h    |    1 
 extents.c |   37 ---------------------------------
 inode.c   |   69 +++++++++++++++++++++++++++++++++++++-------------------------
 3 files changed, 44 insertions(+), 63 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..ef9c3f1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1812,6 +1812,7 @@ extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 				struct kstat *stat);
 extern void ext4_evict_inode(struct inode *);
 extern void ext4_clear_inode(struct inode *);
+ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *, int);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5199bac..42b0486 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -114,12 +114,6 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 			      struct ext4_ext_path *path,
 			      ext4_lblk_t block)
 {
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	ext4_fsblk_t bg_start;
-	ext4_fsblk_t last_block;
-	ext4_grpblk_t colour;
-	ext4_group_t block_group;
-	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
 	int depth;
 
 	if (path) {
@@ -161,36 +155,7 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 	}
 
 	/* OK. use inode's group */
-	block_group = ei->i_block_group;
-	if (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) {
-		/*
-		 * If there are at least EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME
-		 * block groups per flexgroup, reserve the first block
-		 * group for directories and special files.  Regular
-		 * files will start at the second block group.  This
-		 * tends to speed up directory access and improves
-		 * fsck times.
-		 */
-		block_group &= ~(flex_size-1);
-		if (S_ISREG(inode->i_mode))
-			block_group++;
-	}
-	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
-	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
-
-	/*
-	 * If we are doing delayed allocation, we don't need take
-	 * colour into account.
-	 */
-	if (test_opt(inode->i_sb, DELALLOC))
-		return bg_start;
-
-	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
-		colour = (current->pid % 16) *
-			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
-	else
-		colour = (current->pid % 16) * ((last_block - bg_start) / 16);
-	return bg_start + colour + block;
+	return ext4_inode_to_goal_block(inode);
 }
 
 /*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a5763e3..a25a5e6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -466,6 +466,47 @@ no_block:
 	return p;
 }
 
+ext4_fsblk_t ext4_inode_to_goal_block(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	ext4_group_t block_group;
+	ext4_grpblk_t colour;
+	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
+	ext4_fsblk_t bg_start;
+	ext4_fsblk_t last_block;
+
+	block_group = ei->i_block_group;
+	if (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) {
+		/*
+		 * If there are at least EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME
+		 * block groups per flexgroup, reserve the first block
+		 * group for directories and special files.  Regular
+		 * files will start at the second block group.  This
+		 * tends to speed up directory access and improves
+		 * fsck times.
+		 */
+		block_group &= ~(flex_size-1);
+		if (S_ISREG(inode->i_mode))
+			block_group++;
+	}
+	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
+	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
+
+	/*
+	 * If we are doing delayed allocation, we don't need take
+	 * colour into account.
+	 */
+	if (test_opt(inode->i_sb, DELALLOC))
+		return bg_start;
+
+	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
+		colour = (current->pid % 16) *
+			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
+	else
+		colour = (current->pid % 16) * ((last_block - bg_start) / 16);
+	return bg_start + colour;
+}
+
 /**
  *	ext4_find_near - find a place for allocation with sufficient locality
  *	@inode: owner
@@ -491,11 +532,6 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	__le32 *start = ind->bh ? (__le32 *) ind->bh->b_data : ei->i_data;
 	__le32 *p;
-	ext4_fsblk_t bg_start;
-	ext4_fsblk_t last_block;
-	ext4_grpblk_t colour;
-	ext4_group_t block_group;
-	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
 
 	/* Try to find previous block */
 	for (p = ind->p - 1; p >= start; p--) {
@@ -511,28 +547,7 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
 	 * It is going to be referred to from the inode itself? OK, just put it
 	 * into the same cylinder group then.
 	 */
-	block_group = ei->i_block_group;
-	if (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) {
-		block_group &= ~(flex_size-1);
-		if (S_ISREG(inode->i_mode))
-			block_group++;
-	}
-	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
-	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
-
-	/*
-	 * If we are doing delayed allocation, we don't need take
-	 * colour into account.
-	 */
-	if (test_opt(inode->i_sb, DELALLOC))
-		return bg_start;
