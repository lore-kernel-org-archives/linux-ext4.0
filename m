From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file systems
Date: Mon,  3 Sep 2012 12:45:58 -0400
Message-ID: <1346690758-21072-2-git-send-email-tytso@mit.edu>
References: <20120903164525.GD5066@thunk.org>
 <1346690758-21072-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48628 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab2ICQqA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 12:46:00 -0400
In-Reply-To: <1346690758-21072-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The file system overhead calculation in calculate_minimum_resize_size
was incorrect meta_bg file systems.  This caused the minimum size to
underflow for very large file systems, which threw resize2fs into a
loop generally lasted longer than the user's patience.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index dc2805d..1dce498 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1890,6 +1890,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	blk64_t grp, data_needed, last_start;
 	blk64_t overhead = 0;
 	int num_of_superblocks = 0;
+	blk64_t super_overhead = 0;
+	int old_desc_blocks;
 	int extra_groups = 0;
 	int flexbg_size = 1 << fs->super->s_log_groups_per_flex;
 
@@ -1909,15 +1911,36 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	 * we need to figure out how many backup superblocks we have so we can
 	 * account for that in the metadata
 	 */
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+		old_desc_blocks = fs->super->s_first_meta_bg;
+	else
+		old_desc_blocks = fs->desc_blocks +
+			fs->super->s_reserved_gdt_blocks;
+
 	for (grp = 0; grp < fs->group_desc_count; grp++) {
+		blk64_t	super_blk, old_desc_blk, new_desc_blk;
+		int has_super;
+
+		ext2fs_super_and_bgd_loc2(fs, grp, &super_blk,
+					  &old_desc_blk, &new_desc_blk, 0);
+		has_super = ((grp == 0) || super_blk);
+		if (has_super)
+			super_overhead++;
+		if (old_desc_blk)
+			super_overhead += old_desc_blocks;
+		else if (new_desc_blk)
+			super_overhead++;
 		if (ext2fs_bg_has_super(fs, grp))
 			num_of_superblocks++;
+
 	}
+	printf("super overhead is %llu, old algorithm was %llu\n",
+	       super_overhead, SUPER_OVERHEAD(fs) * num_of_superblocks);
 
 	/* calculate how many blocks are needed for data */
 	data_needed = ext2fs_blocks_count(fs->super) -
 		ext2fs_free_blocks_count(fs->super);
-	data_needed -= SUPER_OVERHEAD(fs) * num_of_superblocks;
+	data_needed -= super_overhead;
 	data_needed -= META_OVERHEAD(fs) * fs->group_desc_count;
 
 	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
-- 
1.7.12.rc0.22.gcdd159b

