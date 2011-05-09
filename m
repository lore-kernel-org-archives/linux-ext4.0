From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 13/30] ext4: snapshot file - increase maximum file size limit to 16TB
Date: Mon,  9 May 2011 19:41:31 +0300
Message-ID: <1304959308-11122-14-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1EIQns (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:48 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:47 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Files larger than 2TB use Ext4 huge_file flag to store i_blocks
in file system blocks units, so the upper limit on snapshot actual
size is increased from 512*2^32 = 2TB to 4K*2^32 = 16TB,
which is also the upper limit on file system size.
To map 2^32 logical blocks, 4 triple indirect blocks are used instead
of just one.  The extra 3 triple indirect blocks are stored in-place
of direct blocks, which are not in use by snapshot files.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |   13 +++++++++++++
 fs/ext4/inode.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/super.c |    5 ++++-
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4072036..8f59322 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -333,6 +333,19 @@ struct flex_groups {
 #define	EXT4_DIND_BLOCK			(EXT4_IND_BLOCK + 1)
 #define	EXT4_TIND_BLOCK			(EXT4_DIND_BLOCK + 1)
 #define	EXT4_N_BLOCKS			(EXT4_TIND_BLOCK + 1)
+/*
+ * Snapshot files have different indirection mapping that can map up to 2^32
+ * logical blocks, so they can cover the mapped filesystem block address space.
+ * Ext4 must use either 4K or 8K blocks (depending on PAGE_SIZE).
+ * With 8K blocks, 1 triple indirect block maps 2^33 logical blocks.
+ * With 4K blocks (the system default), each triple indirect block maps 2^30
+ * logical blocks, so 4 triple indirect blocks map 2^32 logical blocks.
+ * Snapshot files in small filesystems (<= 4G), use only 1 double indirect
+ * block to map the entire filesystem.
+ */
+#define	EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS	3
+#define	EXT4_SNAPSHOT_N_BLOCKS		(EXT4_TIND_BLOCK + 1 + \
+					 EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS)
 
 /*
  * Inode flags
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index db1706f..425dabb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -335,6 +335,7 @@ static int ext4_block_to_path(struct inode *inode,
 		double_blocks = (1 << (ptrs_bits * 2));
 	int n = 0;
 	int final = 0;
+	int tind;
 
 	if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
@@ -354,6 +355,18 @@ static int ext4_block_to_path(struct inode *inode,
 		offsets[n++] = (i_block >> ptrs_bits) & (ptrs - 1);
 		offsets[n++] = i_block & (ptrs - 1);
 		final = ptrs;
+	} else if (ext4_snapshot_file(inode) &&
+			(i_block >> (ptrs_bits * 3)) <
+			EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS + 1) {
+		tind = i_block >> (ptrs_bits * 3);
+		BUG_ON(tind == 0);
+		/* use up to 4 triple indirect blocks to map 2^32 blocks */
+		i_block -= (tind << (ptrs_bits * 3));
+		offsets[n++] = (EXT4_TIND_BLOCK + tind) % EXT4_NDIR_BLOCKS;
+		offsets[n++] = i_block >> (ptrs_bits * 2);
+		offsets[n++] = (i_block >> ptrs_bits) & (ptrs - 1);
+		offsets[n++] = i_block & (ptrs - 1);
+		final = ptrs;
 	} else {
 		ext4_warning(inode->i_sb, "block %lu > max in inode %lu",
 			     i_block + direct_blocks +
@@ -4748,6 +4761,13 @@ void ext4_truncate(struct inode *inode)
 	ext4_lblk_t last_block, max_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 
+	/* prevent partial truncate of snapshot files */
+	if (ext4_snapshot_file(inode) && inode->i_size != 0) {
+		snapshot_debug(1, "snapshot file (%lu) cannot be partly "
+				"truncated!\n", inode->i_ino);
+		return;
+	}
+
 	/* prevent truncate of files on snapshot list */
 	if (ext4_snapshot_list(inode)) {
 		snapshot_debug(1, "snapshot (%u) cannot be truncated!\n",
@@ -4861,6 +4881,10 @@ do_indirects:
 	/* Kill the remaining (whole) subtrees */
 	switch (offsets[0]) {
 	default:
+		if (ext4_snapshot_file(inode) &&
+				offsets[0] < EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS)
+			/* Freeing snapshot extra tind branches */
+			break;
 		nr = i_data[EXT4_IND_BLOCK];
 		if (nr) {
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
@@ -4882,6 +4906,19 @@ do_indirects:
 		;
 	}
 
+	if (ext4_snapshot_file(inode)) {
+		int i;
+
+		/* Kill the remaining snapshot file triple indirect trees */
+		for (i = 0; i < EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS; i++) {
+			nr = i_data[i];
+			if (!nr)
+				continue;
+			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
+			i_data[i] = 0;
+		}
+	}
+
 out_unlock:
 	up_write(&ei->i_data_sem);
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
@@ -5114,7 +5151,8 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 	struct super_block *sb = inode->i_sb;
 
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
+				EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+			ext4_snapshot_file(inode)) {
 		/* we are using combined 48 bit field */
 		i_blocks = ((u64)le16_to_cpu(raw_inode->i_blocks_high)) << 32 |
 					le32_to_cpu(raw_inode->i_blocks_lo);
@@ -5353,7 +5391,9 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		return 0;
 	}
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE))
+	/* snapshot files may be represented as huge files */
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+			!ext4_snapshot_file(inode))
 		return -EFBIG;
 
 	if (i_blocks <= 0xffffffffffffULL) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e3ebd7d..d26831a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2316,7 +2316,7 @@ static loff_t ext4_max_bitmap_size(int bits, int has_huge_files)
 
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
-	res += 1LL << (3*(bits-2));
+	res += (1LL + EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS) << (3*(bits-2));
 	res <<= bits;
 	if (res > upper_limit)
 		res = upper_limit;
@@ -3259,6 +3259,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
+	if (EXT4_SNAPSHOTS(sb))
+		/* Snapshot files are huge files */
+		has_huge_files = 1;
 	sbi->s_bitmap_maxbytes = ext4_max_bitmap_size(sb->s_blocksize_bits,
 						      has_huge_files);
 	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, has_huge_files);
-- 
1.7.0.4

