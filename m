From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Use struct flex_groups to calculate get_orlov_stats()
Date: Wed,  4 Mar 2009 19:54:14 -0500
Message-ID: <1236214454-3140-2-git-send-email-tytso@mit.edu>
References: <1236214454-3140-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34701 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZCEAyT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 19:54:19 -0500
In-Reply-To: <1236214454-3140-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of looping over all of the block groups in a flex group
summing their summary statistics, start tracking used_dirs in struct
flex_groups, and use struct flex_groups instead.  This should save a
bit of CPU for mkdir-heavy workloads.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h   |    1 +
 fs/ext4/ialloc.c |   45 ++++++++++++++++++++++++++++-----------------
 fs/ext4/super.c  |    2 ++
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 50c92a8..8065374 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -171,6 +171,7 @@ struct ext4_group_desc
 struct flex_groups {
 	atomic_t free_inodes;
 	atomic_t free_blocks;
+	atomic_t used_dirs;
 };
 
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 692fd0d..7c21a24 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -267,6 +267,13 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 			if (is_directory) {
 				count = ext4_used_dirs_count(sb, gdp) - 1;
 				ext4_used_dirs_set(sb, gdp, count);
+				if (sbi->s_log_groups_per_flex) {
+					ext4_group_t f;
+
+					f = ext4_flex_group(sbi, block_group);
+					atomic_dec(&sbi->s_flex_groups[f].free_inodes);
+				}
+
 			}
 			gdp->bg_checksum = ext4_group_desc_csum(sbi,
 							block_group, gdp);
@@ -424,25 +431,24 @@ void get_orlov_stats(struct super_block *sb, ext4_group_t g,
 		       int flex_size, struct orlov_stats *stats)
 {
 	struct ext4_group_desc *desc;
-	ext4_group_t		ngroups = EXT4_SB(sb)->s_groups_count;
-	int			i;
-
-	stats->free_inodes = 0;
-	stats->free_blocks = 0;
-	stats->used_dirs = 0;
+	struct flex_groups *flex_group = EXT4_SB(sb)->s_flex_groups;
 
-	g *= flex_size;
-
-	for (i = 0; i < flex_size; i++) {
-		if (g >= ngroups)
-			break;
-		desc = ext4_get_group_desc(sb, g++, NULL);
-		if (!desc)
-			continue;
+	if (flex_size > 1) {
+		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
+		stats->free_blocks = atomic_read(&flex_group[g].free_blocks);
+		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
+		return;
+	}
 
-		stats->free_inodes += ext4_free_inodes_count(sb, desc);
-		stats->free_blocks += ext4_free_blks_count(sb, desc);
-		stats->used_dirs += ext4_used_dirs_count(sb, desc);
+	desc = ext4_get_group_desc(sb, g, NULL);
+	if (desc) {
+		stats->free_inodes = ext4_free_inodes_count(sb, desc);
+		stats->free_blocks = ext4_free_blks_count(sb, desc);
+		stats->used_dirs = ext4_used_dirs_count(sb, desc);
+	} else {
+		stats->free_inodes = 0;
+		stats->free_blocks = 0;
+		stats->used_dirs = 0;
 	}
 }
 
@@ -765,6 +771,11 @@ static int ext4_claim_inode(struct super_block *sb,
 	if (S_ISDIR(mode)) {
 		count = ext4_used_dirs_count(sb, gdp) + 1;
 		ext4_used_dirs_set(sb, gdp, count);
+		if (sbi->s_log_groups_per_flex) {
+			ext4_group_t f = ext4_flex_group(sbi, group);
+
+			atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+		}
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 err_ret:
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f34ddf8..8bd9d82 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1623,6 +1623,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
 			   ext4_free_inodes_count(sb, gdp));
 		atomic_set(&sbi->s_flex_groups[flex_group].free_blocks,
 			   ext4_free_blks_count(sb, gdp));
+		atomic_set(&sbi->s_flex_groups[flex_group].used_dirs,
+			   ext4_used_dirs_count(sb, gdp));
 	}
 
 	return 1;
-- 
1.5.6.3

