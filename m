From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/5] ext4: Mark group corrupt on group descriptor checksum
 error
Date: Fri, 19 Jul 2013 16:56:05 -0700
Message-ID: <20130719235605.24017.35311.stgit@blackbox.djwong.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36475 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3GSX4O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jul 2013 19:56:14 -0400
In-Reply-To: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the group descriptor fails validation, mark the whole blockgroup corrupt so
that the inode/block allocators skip this group.  The previous approach takes
the risk of writing to a damaged group descriptor; hopefully it was never the
case that the [ib]bitmap fields pointed to another valid block and got dirtied,
since the memset would fill the page with 1s.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |    9 ++++-----
 fs/ext4/ialloc.c |   10 ++++------
 2 files changed, 8 insertions(+), 11 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b4c406b..f19e94d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -184,6 +184,7 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_fsblk_t start, tmp;
 	int flex_bg = 0;
+	struct ext4_group_info *grp;
 
 	J_ASSERT_BH(bh, buffer_locked(bh));
 
@@ -191,11 +192,9 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 	 * essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
 		ext4_error(sb, "Checksum bad for group %u", block_group);
-		ext4_free_group_clusters_set(sb, gdp, 0);
-		ext4_free_inodes_set(sb, gdp, 0);
-		ext4_itable_unused_set(sb, gdp, 0);
-		memset(bh->b_data, 0xff, sb->s_blocksize);
-		ext4_block_bitmap_csum_set(sb, block_group, gdp, bh);
+		grp = ext4_get_group_info(sb, block_group);
+		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
 		return;
 	}
 	memset(bh->b_data, 0, sb->s_blocksize);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 08c7fa7..f75be27 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -70,18 +70,16 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
 {
+	struct ext4_group_info *grp;
 	J_ASSERT_BH(bh, buffer_locked(bh));
 
 	/* If checksum is bad mark all blocks and inodes use to prevent
 	 * allocation, essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
 		ext4_error(sb, "Checksum bad for group %u", block_group);
-		ext4_free_group_clusters_set(sb, gdp, 0);
-		ext4_free_inodes_set(sb, gdp, 0);
-		ext4_itable_unused_set(sb, gdp, 0);
-		memset(bh->b_data, 0xff, sb->s_blocksize);
-		ext4_inode_bitmap_csum_set(sb, block_group, gdp, bh,
-					   EXT4_INODES_PER_GROUP(sb) / 8);
+		grp = ext4_get_group_info(sb, block_group);
+		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
 		return 0;
 	}
 

