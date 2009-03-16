From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH] ext2fs_block_alloc_stats2: fix size comparison for 64-bit compatibility.
Date: Mon, 16 Mar 2009 18:43:51 -0400
Message-ID: <12257.1237243431@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20783 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbZCPWny (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 18:43:54 -0400
Received: from smtp2.fc.hp.com (smtp2.fc.hp.com [15.11.136.114])
	by g1t0028.austin.hp.com (Postfix) with ESMTP id 491F51C0E9
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 22:43:53 +0000 (UTC)
From: Nick Dokos <nicholas.dokos@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[The following is perhaps not quite kosher in the details (e.g. should
the function names be changed?), but I think it's correct in principle.]

The block number comparison in ext2fs_block_alloc_stats2() is invalid
for 64-bit filesystems: it compares the block number to the low
32-bits of the blocks_count in the superblock. That caused the journal
file for a 32TiB filesystem to be malformed and the resulting filesystem
could not be mounted.

I found three static functions in lib/e2p/ls.c that do the right thing
wrt 64-bit compatibility, one of which can be used in the context
above; moved them to the common header file lib/ext2fs.ext2_fs.h, and
changed ext2fs_block_alloc_stats2() to use one of these, e2p_blocks_count(),
to calculate the correct blocks count.

With this change, the journal looks sane and the filesystem could be
mounted.
---
 lib/e2p/ls.c             |   21 ---------------------
 lib/ext2fs/alloc_stats.c |    2 +-
 lib/ext2fs/ext2_fs.h     |   25 +++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 77463ca..e6a819f 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -164,27 +164,6 @@ static void print_super_flags(struct ext2_super_block * s, FILE *f)
 		fputs("(none)\n", f);
 }
 
-static __u64 e2p_blocks_count(struct ext2_super_block *super)
-{
-	return super->s_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
-		(__u64) super->s_blocks_count_hi << 32 : 0);
-}
-
-static __u64 e2p_r_blocks_count(struct ext2_super_block *super)
-{
-	return super->s_r_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
-		(__u64) super->s_r_blocks_count_hi << 32 : 0);
-}
-
-static __u64 e2p_free_blocks_count(struct ext2_super_block *super)
-{
-	return super->s_free_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
-		(__u64) super->s_free_blocks_hi << 32 : 0);
-}
-
 #ifndef EXT2_INODE_SIZE
 #define EXT2_INODE_SIZE(s) sizeof(struct ext2_inode)
 #endif
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 7895aee..44142f4 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -65,7 +65,7 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 	int	group = ext2fs_group_of_blk2(fs, blk);
 
 #ifndef OMIT_COM_ERR
-	if (blk >= fs->super->s_blocks_count) {
+	if (blk >= e2p_blocks_count(fs->super)) {
 		com_err("ext2fs_block_alloc_stats2", 0,
 			"Illegal block number: %lu", blk);
 		return;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 46f4ae0..a256b5e 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -585,6 +585,7 @@ struct ext2_super_block {
 	__u32   s_reserved[162];        /* Padding to the end of the block */
 };
 
+
 /*
  * Codes for operating systems
  */
@@ -750,4 +751,28 @@ struct mmp_struct {
  */
 #define EXT2_MMP_DEF_INTERVAL	5
 
+/*
+ * Inlines used in lib/e2p/ls.c and lib/ext2fs/alloc_stats.c
+ */
+static __u64 e2p_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_blocks_count |
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) super->s_blocks_count_hi << 32 : 0);
+}
+
+static __u64 e2p_r_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_r_blocks_count |
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) super->s_r_blocks_count_hi << 32 : 0);
+}
+
+static __u64 e2p_free_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_free_blocks_count |
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) super->s_free_blocks_hi << 32 : 0);
+}
+
 #endif	/* _LINUX_EXT2_FS_H */
-- 
1.6.0.3

