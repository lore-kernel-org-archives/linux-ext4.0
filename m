From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ext4_group_t: Fix negative groups
Date: Tue, 30 Oct 2007 17:52:29 -0700
Message-ID: <4727D1CD.9040802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080706040507050007080300"
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50365 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbXJaAvT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2007 20:51:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------080706040507050007080300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------080706040507050007080300
Content-Type: text/x-patch;
 name="ext4_grpnum_t_int_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ext4_grpnum_t_int_fix.patch"

Ext4: fixes block group number being set to a negative value

From: Avantika Mathur <mathur@us.ibm.com>

This patch fixes various places where the group number is set to a negative
value.

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---

 fs/ext4/ialloc.c |  101 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 53 insertions(+), 48 deletions(-)


Index: linux-2.6.24-rc1/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/ext4/ialloc.c	2007-10-30 10:47:50.000000000 -0700
+++ linux-2.6.24-rc1/fs/ext4/ialloc.c	2007-10-30 10:58:16.000000000 -0700
@@ -260,12 +260,14 @@
  * For other inodes, search forward from the parent directory\'s block
  * group to find a free inode.
  */
-static ext4_group_t find_group_dir(struct super_block *sb, struct inode *parent)
+static int find_group_dir(struct super_block *sb, struct inode *parent,
+				ext4_group_t *best_group)
 {
 	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
 	unsigned int freei, avefreei;
 	struct ext4_group_desc *desc, *best_desc = NULL;
-	ext4_group_t group, best_group = -1;
+	ext4_group_t group;
+	int ret = -1;
 
 	freei = percpu_counter_read_positive(&EXT4_SB(sb)->s_freeinodes_counter);
 	avefreei = freei / ngroups;
@@ -279,11 +281,12 @@
 		if (!best_desc ||
 		    (le16_to_cpu(desc->bg_free_blocks_count) >
 		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
-			best_group = group;
+			*best_group = group;
 			best_desc = desc;
+			ret = 0;
 		}
 	}
-	return best_group;
+	return ret;
 }
 
 /*
@@ -314,8 +317,8 @@
 #define INODE_COST 64
 #define BLOCK_COST 256
 
-static ext4_group_t find_group_orlov(struct super_block *sb,
-				      struct inode *parent)
+static int find_group_orlov(struct super_block *sb, struct inode *parent,
+				ext4_group_t *group)
 {
 	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -328,7 +331,7 @@
 	unsigned int ndirs;
 	int max_debt, max_dirs, min_inodes;
 	ext4_grpblk_t min_blocks;
-	ext4_group_t group = -1, i;
+	ext4_group_t i;
 	struct ext4_group_desc *desc;
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
@@ -341,13 +344,14 @@
 	if ((parent == sb->s_root->d_inode) ||
 	    (EXT4_I(parent)->i_flags & EXT4_TOPDIR_FL)) {
 		int best_ndir = inodes_per_group;
-		ext4_group_t best_group = -1;
+		ext4_group_t grp;
+		int ret = -1;
 
-		get_random_bytes(&group, sizeof(group));
-		parent_group = (unsigned)group % ngroups;
+		get_random_bytes(&grp, sizeof(grp));
+		parent_group = (unsigned)grp % ngroups;
 		for (i = 0; i < ngroups; i++) {
-			group = (parent_group + i) % ngroups;
-			desc = ext4_get_group_desc (sb, group, NULL);
+			grp = (parent_group + i) % ngroups;
+			desc = ext4_get_group_desc(sb, grp, NULL);
 			if (!desc || !desc->bg_free_inodes_count)
 				continue;
 			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
@@ -356,11 +360,12 @@
 				continue;
 			if (le16_to_cpu(desc->bg_free_blocks_count) < avefreeb)
 				continue;
-			best_group = group;
+			*group = grp;
+			ret = 0;
 			best_ndir = le16_to_cpu(desc->bg_used_dirs_count);
 		}
-		if (best_group >= 0)
-			return best_group;
+		if (ret == 0)
+			return ret;
 		goto fallback;
 	}
 
@@ -381,8 +386,8 @@
 		max_debt = 1;
 
 	for (i = 0; i < ngroups; i++) {
-		group = (parent_group + i) % ngroups;
-		desc = ext4_get_group_desc (sb, group, NULL);
+		*group = (parent_group + i) % ngroups;
+		desc = ext4_get_group_desc(sb, *group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
@@ -391,17 +396,16 @@
 			continue;
 		if (le16_to_cpu(desc->bg_free_blocks_count) < min_blocks)
 			continue;
-		return group;
+		return 0;
 	}
 
 fallback:
 	for (i = 0; i < ngroups; i++) {
-		group = (parent_group + i) % ngroups;
-		desc = ext4_get_group_desc (sb, group, NULL);
-		if (!desc || !desc->bg_free_inodes_count)
-			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
-			return group;
+		*group = (parent_group + i) % ngroups;
+		desc = ext4_get_group_desc(sb, *group, NULL);
+		if (desc && desc->bg_free_inodes_count &&
+			le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
+			return 0;
 	}
 
 	if (avefreei) {
@@ -416,22 +420,22 @@
 	return -1;
 }
 
-static ext4_group_t find_group_other(struct super_block *sb, 
-					struct inode *parent)
+static int find_group_other(struct super_block *sb, struct inode *parent,
+				ext4_group_t *group)
 {
 	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
 	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
 	struct ext4_group_desc *desc;
-	ext4_group_t group, i;
+	ext4_group_t i;
 
 	/*
 	 * Try to place the inode in its parent directory
 	 */
-	group = parent_group;
-	desc = ext4_get_group_desc (sb, group, NULL);
+	*group = parent_group;
+	desc = ext4_get_group_desc(sb, *group, NULL);
 	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 			le16_to_cpu(desc->bg_free_blocks_count))
-		return group;
+		return 0;
 
 	/*
 	 * We're going to place this inode in a different blockgroup from its
@@ -442,33 +446,33 @@
 	 *
 	 * So add our directory's i_ino into the starting point for the hash.
 	 */
-	group = (group + parent->i_ino) % ngroups;
+	*group = (*group + parent->i_ino) % ngroups;
 
 	/*
 	 * Use a quadratic hash to find a group with a free inode and some free
 	 * blocks.
 	 */
 	for (i = 1; i < ngroups; i <<= 1) {
-		group += i;
-		if (group >= ngroups)
-			group -= ngroups;
-		desc = ext4_get_group_desc (sb, group, NULL);
+		*group += i;
+		if (*group >= ngroups)
+			*group -= ngroups;
+		desc = ext4_get_group_desc(sb, *group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 				le16_to_cpu(desc->bg_free_blocks_count))
-			return group;
+			return 0;
 	}
 
 	/*
 	 * That failed: try linear search for a free inode, even if that group
 	 * has no free blocks.
 	 */
-	group = parent_group;
+	*group = parent_group;
 	for (i = 0; i < ngroups; i++) {
-		if (++group >= ngroups)
-			group = 0;
-		desc = ext4_get_group_desc (sb, group, NULL);
+		if (++*group >= ngroups)
+			*group = 0;
+		desc = ext4_get_group_desc(sb, *group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
-			return group;
+			return 0;
 	}
 
 	return -1;
@@ -489,16 +493,17 @@
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *bh2;
-	ext4_group_t group;
+	ext4_group_t group = 0;
 	unsigned long ino = 0;
 	struct inode * inode;
 	struct ext4_group_desc * gdp = NULL;
 	struct ext4_super_block * es;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int err = 0;
+	int ret2, err = 0;
 	struct inode *ret;
-	int i, free = 0;
+	ext4_group_t i;
+	int free = 0;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -514,14 +519,14 @@
 	es = sbi->s_es;
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
-			group = find_group_dir(sb, dir);
+			ret2 = find_group_dir(sb, dir, &group);
 		else
-			group = find_group_orlov(sb, dir);
+			ret2 = find_group_orlov(sb, dir, &group);
 	} else
-		group = find_group_other(sb, dir);
+		ret2 = find_group_other(sb, dir, &group);
 
 	err = -ENOSPC;
-	if (group == -1)
+	if (ret2 == -1)
 		goto out;
 
 	for (i = 0; i < sbi->s_groups_count; i++) {

--------------080706040507050007080300--
