From: akpm@linux-foundation.org
Subject: [patch 081/327] remove unused bh in calls to ext234_get_group_desc
Date: Tue, 16 Oct 2007 23:26:30 -0700
Message-ID: <200710170626.l9H6QUFZ006624@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715AbXJQGlG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2007 02:41:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

ext[234]_get_group_desc never tests the bh argument, and only sets it if it
is passed in; it is perfectly happy with a NULL bh argument.  But, many
callers send one in and never use it.  May as well call with NULL like
other callers who don't use the bh.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ialloc.c |   24 ++++++++----------------
 fs/ext2/inode.c  |    2 +-
 fs/ext3/ialloc.c |   17 +++++++----------
 fs/ext4/ialloc.c |   17 +++++++----------
 4 files changed, 23 insertions(+), 37 deletions(-)

diff -puN fs/ext2/ialloc.c~remove-unused-bh-in-calls-to-ext234_get_group_desc fs/ext2/ialloc.c
--- a/fs/ext2/ialloc.c~remove-unused-bh-in-calls-to-ext234_get_group_desc
+++ a/fs/ext2/ialloc.c
@@ -177,7 +177,6 @@ static void ext2_preread_inode(struct in
 	unsigned long block_group;
 	unsigned long offset;
 	unsigned long block;
-	struct buffer_head *bh;
 	struct ext2_group_desc * gdp;
 	struct backing_dev_info *bdi;
 
@@ -188,7 +187,7 @@ static void ext2_preread_inode(struct in
 		return;
 
 	block_group = (inode->i_ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
-	gdp = ext2_get_group_desc(inode->i_sb, block_group, &bh);
+	gdp = ext2_get_group_desc(inode->i_sb, block_group, NULL);
 	if (gdp == NULL)
 		return;
 
@@ -217,11 +216,10 @@ static int find_group_dir(struct super_b
 	int ngroups = EXT2_SB(sb)->s_groups_count;
 	int avefreei = ext2_count_free_inodes(sb) / ngroups;
 	struct ext2_group_desc *desc, *best_desc = NULL;
-	struct buffer_head *bh, *best_bh = NULL;
 	int group, best_group = -1;
 
 	for (group = 0; group < ngroups; group++) {
-		desc = ext2_get_group_desc (sb, group, &bh);
+		desc = ext2_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
@@ -231,7 +229,6 @@ static int find_group_dir(struct super_b
 		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
 			best_group = group;
 			best_desc = desc;
-			best_bh = bh;
 		}
 	}
 	if (!best_desc)
@@ -284,7 +281,6 @@ static int find_group_orlov(struct super
 	int max_debt, max_dirs, min_blocks, min_inodes;
 	int group = -1, i;
 	struct ext2_group_desc *desc;
-	struct buffer_head *bh;
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
@@ -295,7 +291,6 @@ static int find_group_orlov(struct super
 	if ((parent == sb->s_root->d_inode) ||
 	    (EXT2_I(parent)->i_flags & EXT2_TOPDIR_FL)) {
 		struct ext2_group_desc *best_desc = NULL;
-		struct buffer_head *best_bh = NULL;
 		int best_ndir = inodes_per_group;
 		int best_group = -1;
 
@@ -303,7 +298,7 @@ static int find_group_orlov(struct super
 		parent_group = (unsigned)group % ngroups;
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
-			desc = ext2_get_group_desc (sb, group, &bh);
+			desc = ext2_get_group_desc (sb, group, NULL);
 			if (!desc || !desc->bg_free_inodes_count)
 				continue;
 			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
@@ -315,11 +310,9 @@ static int find_group_orlov(struct super
 			best_group = group;
 			best_ndir = le16_to_cpu(desc->bg_used_dirs_count);
 			best_desc = desc;
-			best_bh = bh;
 		}
 		if (best_group >= 0) {
 			desc = best_desc;
-			bh = best_bh;
 			group = best_group;
 			goto found;
 		}
@@ -345,7 +338,7 @@ static int find_group_orlov(struct super
 
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
-		desc = ext2_get_group_desc (sb, group, &bh);
+		desc = ext2_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (sbi->s_debts[group] >= max_debt)
@@ -362,7 +355,7 @@ static int find_group_orlov(struct super
 fallback:
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
-		desc = ext2_get_group_desc (sb, group, &bh);
+		desc = ext2_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
@@ -389,14 +382,13 @@ static int find_group_other(struct super
 	int parent_group = EXT2_I(parent)->i_block_group;
 	int ngroups = EXT2_SB(sb)->s_groups_count;
 	struct ext2_group_desc *desc;
-	struct buffer_head *bh;
 	int group, i;
 
 	/*
 	 * Try to place the inode in its parent directory
 	 */
 	group = parent_group;
-	desc = ext2_get_group_desc (sb, group, &bh);
+	desc = ext2_get_group_desc (sb, group, NULL);
 	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 			le16_to_cpu(desc->bg_free_blocks_count))
 		goto found;
@@ -420,7 +412,7 @@ static int find_group_other(struct super
 		group += i;
 		if (group >= ngroups)
 			group -= ngroups;
-		desc = ext2_get_group_desc (sb, group, &bh);
+		desc = ext2_get_group_desc (sb, group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 				le16_to_cpu(desc->bg_free_blocks_count))
 			goto found;
@@ -434,7 +426,7 @@ static int find_group_other(struct super
 	for (i = 0; i < ngroups; i++) {
 		if (++group >= ngroups)
 			group = 0;
-		desc = ext2_get_group_desc (sb, group, &bh);
+		desc = ext2_get_group_desc (sb, group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
 			goto found;
 	}
diff -puN fs/ext2/inode.c~remove-unused-bh-in-calls-to-ext234_get_group_desc fs/ext2/inode.c
--- a/fs/ext2/inode.c~remove-unused-bh-in-calls-to-ext234_get_group_desc
+++ a/fs/ext2/inode.c
@@ -1028,7 +1028,7 @@ static struct ext2_inode *ext2_get_inode
 		goto Einval;
 
 	block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
-	gdp = ext2_get_group_desc(sb, block_group, &bh);
+	gdp = ext2_get_group_desc(sb, block_group, NULL);
 	if (!gdp)
 		goto Egdp;
 	/*
diff -puN fs/ext3/ialloc.c~remove-unused-bh-in-calls-to-ext234_get_group_desc fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~remove-unused-bh-in-calls-to-ext234_get_group_desc
+++ a/fs/ext3/ialloc.c
@@ -204,14 +204,13 @@ static int find_group_dir(struct super_b
 	int ngroups = EXT3_SB(sb)->s_groups_count;
 	unsigned int freei, avefreei;
 	struct ext3_group_desc *desc, *best_desc = NULL;
-	struct buffer_head *bh;
 	int group, best_group = -1;
 
 	freei = percpu_counter_read_positive(&EXT3_SB(sb)->s_freeinodes_counter);
 	avefreei = freei / ngroups;
 
 	for (group = 0; group < ngroups; group++) {
-		desc = ext3_get_group_desc (sb, group, &bh);
+		desc = ext3_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
@@ -269,7 +268,6 @@ static int find_group_orlov(struct super
 	ext3_grpblk_t min_blocks;
 	int group = -1, i;
 	struct ext3_group_desc *desc;
-	struct buffer_head *bh;
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
@@ -286,7 +284,7 @@ static int find_group_orlov(struct super
 		parent_group = (unsigned)group % ngroups;
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
-			desc = ext3_get_group_desc (sb, group, &bh);
+			desc = ext3_get_group_desc (sb, group, NULL);
 			if (!desc || !desc->bg_free_inodes_count)
 				continue;
 			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
@@ -319,7 +317,7 @@ static int find_group_orlov(struct super
 
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
-		desc = ext3_get_group_desc (sb, group, &bh);
+		desc = ext3_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
@@ -334,7 +332,7 @@ static int find_group_orlov(struct super
 fallback:
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
-		desc = ext3_get_group_desc (sb, group, &bh);
+		desc = ext3_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
@@ -358,14 +356,13 @@ static int find_group_other(struct super
 	int parent_group = EXT3_I(parent)->i_block_group;
 	int ngroups = EXT3_SB(sb)->s_groups_count;
 	struct ext3_group_desc *desc;
-	struct buffer_head *bh;
 	int group, i;
 
 	/*
 	 * Try to place the inode in its parent directory
 	 */
 	group = parent_group;
-	desc = ext3_get_group_desc (sb, group, &bh);
+	desc = ext3_get_group_desc (sb, group, NULL);
 	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 			le16_to_cpu(desc->bg_free_blocks_count))
 		return group;
@@ -389,7 +386,7 @@ static int find_group_other(struct super
 		group += i;
 		if (group >= ngroups)
 			group -= ngroups;
-		desc = ext3_get_group_desc (sb, group, &bh);
+		desc = ext3_get_group_desc (sb, group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 				le16_to_cpu(desc->bg_free_blocks_count))
 			return group;
@@ -403,7 +400,7 @@ static int find_group_other(struct super
 	for (i = 0; i < ngroups; i++) {
 		if (++group >= ngroups)
 			group = 0;
-		desc = ext3_get_group_desc (sb, group, &bh);
+		desc = ext3_get_group_desc (sb, group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
 			return group;
 	}
diff -puN fs/ext4/ialloc.c~remove-unused-bh-in-calls-to-ext234_get_group_desc fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~remove-unused-bh-in-calls-to-ext234_get_group_desc
+++ a/fs/ext4/ialloc.c
@@ -204,14 +204,13 @@ static int find_group_dir(struct super_b
 	int ngroups = EXT4_SB(sb)->s_groups_count;
 	unsigned int freei, avefreei;
 	struct ext4_group_desc *desc, *best_desc = NULL;
-	struct buffer_head *bh;
 	int group, best_group = -1;
 
 	freei = percpu_counter_read_positive(&EXT4_SB(sb)->s_freeinodes_counter);
 	avefreei = freei / ngroups;
 
 	for (group = 0; group < ngroups; group++) {
-		desc = ext4_get_group_desc (sb, group, &bh);
+		desc = ext4_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
@@ -269,7 +268,6 @@ static int find_group_orlov(struct super
 	ext4_grpblk_t min_blocks;
 	int group = -1, i;
 	struct ext4_group_desc *desc;
-	struct buffer_head *bh;
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
@@ -287,7 +285,7 @@ static int find_group_orlov(struct super
 		parent_group = (unsigned)group % ngroups;
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
-			desc = ext4_get_group_desc (sb, group, &bh);
+			desc = ext4_get_group_desc (sb, group, NULL);
 			if (!desc || !desc->bg_free_inodes_count)
 				continue;
 			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
@@ -322,7 +320,7 @@ static int find_group_orlov(struct super
 
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
-		desc = ext4_get_group_desc (sb, group, &bh);
+		desc = ext4_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
@@ -337,7 +335,7 @@ static int find_group_orlov(struct super
 fallback:
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
-		desc = ext4_get_group_desc (sb, group, &bh);
+		desc = ext4_get_group_desc (sb, group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
@@ -361,14 +359,13 @@ static int find_group_other(struct super
 	int parent_group = EXT4_I(parent)->i_block_group;
 	int ngroups = EXT4_SB(sb)->s_groups_count;
 	struct ext4_group_desc *desc;
-	struct buffer_head *bh;
 	int group, i;
 
 	/*
 	 * Try to place the inode in its parent directory
 	 */
 	group = parent_group;
-	desc = ext4_get_group_desc (sb, group, &bh);
+	desc = ext4_get_group_desc (sb, group, NULL);
 	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 			le16_to_cpu(desc->bg_free_blocks_count))
 		return group;
@@ -392,7 +389,7 @@ static int find_group_other(struct super
 		group += i;
 		if (group >= ngroups)
 			group -= ngroups;
-		desc = ext4_get_group_desc (sb, group, &bh);
+		desc = ext4_get_group_desc (sb, group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 				le16_to_cpu(desc->bg_free_blocks_count))
 			return group;
@@ -406,7 +403,7 @@ static int find_group_other(struct super
 	for (i = 0; i < ngroups; i++) {
 		if (++group >= ngroups)
 			group = 0;
-		desc = ext4_get_group_desc (sb, group, &bh);
+		desc = ext4_get_group_desc (sb, group, NULL);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
 			return group;
 	}
_
