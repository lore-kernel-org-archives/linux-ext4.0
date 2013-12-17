From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 1/2] e2fsck: verify s_desc_size is power-of-two value
Date: Tue, 17 Dec 2013 01:19:03 -0700
Message-ID: <1387268344-8320-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.br.shawcable.net ([64.59.134.9]:42257 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3LQITF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Dec 2013 03:19:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a LOG2_CHECK mode for check_super_value() so that it is easy
to verify values that are supposed to be power-of-two values
(s_desc_size and s_inode_size so far).  In ext2fs_check_desc()
also check for a power-of-two s_desc_size.

Print out s_desc_size in debugfs "stats" and dumpe2fs output, if
it is non-zero.

It turns out that the s_desc_size validation in check_super_block()
is not currently used by e2fsck, because the group descriptors are
verified earlier by ext2fs_check_desc(), and even without an
explicit check of s_desc_size the group descriptors fail to align
correctly on disk.  It makes sense to keep the check_super_block()
regardless, in case the code changes at some point in the future.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/super.c          |   18 ++++++++----------
 lib/e2p/ls.c            |    2 ++
 lib/ext2fs/check_desc.c |    3 +++
 lib/ext2fs/closefs.c    |    2 +-
 lib/ext2fs/ext2_fs.h    |    2 +-
 5 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 56a3381..b0cc440 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -22,6 +22,7 @@
 
 #define MIN_CHECK 1
 #define MAX_CHECK 2
+#define LOG2_CHECK 4
 
 static void check_super_value(e2fsck_t ctx, const char *descr,
 			      unsigned long value, int flags,
@@ -30,7 +31,8 @@ static void check_super_value(e2fsck_t ctx, const char *descr,
 	struct		problem_context pctx;
 
 	if (((flags & MIN_CHECK) && (value < min_val)) ||
-	    ((flags & MAX_CHECK) && (value > max_val))) {
+	    ((flags & MAX_CHECK) && (value > max_val)) ||
+	    ((flags & LOG2_CHECK) && (value & (value - 1) != 0))) {
 		clear_problem_context(&pctx);
 		pctx.num = value;
 		pctx.str = descr;
@@ -527,14 +529,17 @@ void check_super_block(e2fsck_t ctx)
 			  MAX_CHECK, 0, ext2fs_blocks_count(sb) / 2);
 	check_super_value(ctx, "reserved_gdt_blocks",
 			  sb->s_reserved_gdt_blocks, MAX_CHECK, 0,
-			  fs->blocksize/4);
+			  fs->blocksize / sizeof(__u32));
+	check_super_value(ctx, "desc_size",
+			  sb->s_desc_size, MAX_CHECK | LOG2_CHECK, 0,
+			  EXT2_MAX_DESC_SIZE);
 	if (sb->s_rev_level > EXT2_GOOD_OLD_REV)
 		check_super_value(ctx, "first_ino", sb->s_first_ino,
 				  MIN_CHECK | MAX_CHECK,
 				  EXT2_GOOD_OLD_FIRST_INO, sb->s_inodes_count);
 	inode_size = EXT2_INODE_SIZE(sb);
 	check_super_value(ctx, "inode_size",
-			  inode_size, MIN_CHECK | MAX_CHECK,
+			  inode_size, MIN_CHECK | MAX_CHECK | LOG2_CHECK,
 			  EXT2_GOOD_OLD_INODE_SIZE, fs->blocksize);
 	if (sb->s_blocks_per_group != (sb->s_clusters_per_group *
 				       EXT2FS_CLUSTER_RATIO(fs))) {
@@ -544,13 +549,6 @@ void check_super_block(e2fsck_t ctx)
 		ctx->flags |= E2F_FLAG_ABORT; /* never get here! */
 		return;
 	}
-	if (inode_size & (inode_size - 1)) {
-		pctx.num = inode_size;
-		pctx.str = "inode_size";
-		fix_problem(ctx, PR_0_MISC_CORRUPT_SUPER, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT; /* never get here! */
-		return;
-	}
 
 	if ((ctx->flags & E2F_FLAG_GOT_DEVSIZE) &&
 	    (ctx->num_blocks < ext2fs_blocks_count(sb))) {
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index f05e16d..5b3d3c8 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -259,6 +259,8 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	else
 		fprintf(f, "Fragment size:            %u\n",
 			EXT2_CLUSTER_SIZE(sb));
+	if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		fprintf(f, "Group descriptor size:    %u\n", sb->s_desc_size);
 	if (sb->s_reserved_gdt_blocks)
 		fprintf(f, "Reserved GDT blocks:      %u\n",
 			sb->s_reserved_gdt_blocks);
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index a6fcc45..1a768f9 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -42,6 +42,9 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	if (EXT2_DESC_SIZE(fs->super) & (EXT2_DESC_SIZE(fs->super) - 1))
+		return EXT2_ET_BAD_DESC_SIZE;
+
 	retval = ext2fs_allocate_subcluster_bitmap(fs, "check_desc map", &bmap);
 	if (retval)
 		return retval;
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 3a80424..3e4af7f 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -302,7 +302,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	       fs->desc_blocks);
 
 	/* swap the group descriptors */
-	for (j=0; j < fs->group_desc_count; j++) {
+	for (j = 0; j < fs->group_desc_count; j++) {
 		gdp = ext2fs_group_desc(fs, group_shadow, j);
 		ext2fs_swap_group_desc2(fs, gdp);
 	}
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fb3f7cc..930c2a3 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -159,7 +159,7 @@ struct ext2_group_desc
 	__u16	bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
 	__u16	bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
 	__u16	bg_itable_unused;	/* Unused inodes count */
-	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
+	__u16	bg_checksum;		/* crc16(s_uuid+group_num+group_desc)*/
 };
 
 /*
-- 
1.7.3.4

