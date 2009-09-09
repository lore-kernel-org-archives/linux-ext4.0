From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: clean up ext2fs_bg_flags_ interfaces
Date: Wed, 09 Sep 2009 14:03:47 -0500
Message-ID: <4AA7FC13.6060109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZIITDs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 15:03:48 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n89J3pUL026458
	for <linux-ext4@vger.kernel.org>; Wed, 9 Sep 2009 15:03:51 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n89J3lFc028987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Sep 2009 15:03:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_bg_flag* functions were confusing.

Currently we have this:

void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group,__u16 bg_flags);

(_set (unused) sets exactly bg_flags; _clear clears all and ignores bg_flags)

and these, which can twiddle individual bits in bg_flags:

void ext2fs_bg_flag_set(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
void ext2fs_bg_flag_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flag);

A better interface, after the patch below, is just:

ext2fs_bg_flags_zap(fs, group) /* zeros bg_flags */
ext2fs_bg_flags_set(fs, group, flags) /* adds flags to bg_flags */
ext2fs_bg_flags_clear(fs, group, flags) /* clears flags in bg_flags */

and remove the original ext2fs_bg_flags_set / ext2fs_bg_flags_clear.

Applies to the pu branch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index e25aba0..9376188 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -991,7 +991,7 @@ out_htree:
 			pctx.num = dirent->inode;
 			if (fix_problem(ctx, PR_2_INOREF_BG_INO_UNINIT,
 					&cd->pctx)){
-				ext2fs_bg_flag_clear(fs, group,
+				ext2fs_bg_flags_clear(fs, group,
 						      EXT2_BG_INODE_UNINIT);
 				ext2fs_mark_super_dirty(fs);
 				ctx->flags |= E2F_FLAG_RESTART_LATER;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 018fa61..23def7f 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -260,7 +260,7 @@ redo_counts:
 				pctx2.blk = i;
 				pctx2.group = group;
 				if (fix_problem(ctx, PR_5_BLOCK_UNINIT,&pctx2)){
-					ext2fs_bg_flag_clear(fs, group, EXT2_BG_BLOCK_UNINIT)
+					ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT)
 						;
 					skip_group = 0;
 				}
@@ -482,7 +482,7 @@ redo_counts:
 				pctx2.blk = i;
 				pctx2.group = group;
 				if (fix_problem(ctx, PR_5_INODE_UNINIT,&pctx2)){
-					ext2fs_bg_flag_clear(fs, group, EXT2_BG_INODE_UNINIT)
+					ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT)
 						;
 					skip_group = 0;
 				}
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 409d472..b8eee6b 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -637,8 +637,8 @@ void check_super_block(e2fsck_t ctx)
 		should_be = 0;
 		if (!ext2fs_group_desc_csum_verify(fs, i)) {
 			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
-				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
-				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
+				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 				should_be = 1;
 			}
@@ -650,8 +650,8 @@ void check_super_block(e2fsck_t ctx)
 		     ext2fs_bg_flag_test(fs, i, EXT2_BG_INODE_UNINIT) ||
 		     ext2fs_bg_itable_unused(fs, i) != 0)){
 			if (fix_problem(ctx, PR_0_GDT_UNINIT, &pctx)) {
-				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
-				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
+				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 				should_be = 1;
 			}
@@ -661,7 +661,7 @@ void check_super_block(e2fsck_t ctx)
 		if (i == fs->group_desc_count - 1 &&
 		    ext2fs_bg_flag_test(fs, i, EXT2_BG_BLOCK_UNINIT)) {
 			if (fix_problem(ctx, PR_0_BB_UNINIT_LAST, &pctx)) {
-				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
 				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
@@ -670,7 +670,7 @@ void check_super_block(e2fsck_t ctx)
 		if (ext2fs_bg_flag_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
 		    !ext2fs_bg_flag_test(fs, i, EXT2_BG_INODE_UNINIT)) {
 			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx)) {
-				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
 				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 06ac1aa..b52eb92 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -68,7 +68,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 		else
 			ext2fs_fast_unmark_block_bitmap2(map, blk);
 	}
-	ext2fs_bg_flag_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+	ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 	ext2fs_group_desc_csum_set(fs, group);
 }
 
@@ -89,7 +89,7 @@ static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
 	for (i=0; i < fs->super->s_inodes_per_group; i++, ino++)
 		ext2fs_fast_unmark_inode_bitmap2(map, ino);
 
-	ext2fs_bg_flag_clear(fs, group, EXT2_BG_INODE_UNINIT);
+	ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
 	check_block_uninit(fs, fs->block_map, group);
 }
 
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 37f2140..b2e1969 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -62,7 +62,7 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 
 	if (old_desc_blk) {
 		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
-			ext2fs_bg_flag_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		for (j=0; j < old_desc_blocks; j++)
 			if (old_desc_blk + j < ext2fs_blocks_count(fs->super))
 				ext2fs_mark_block_bitmap2(bmap,
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 4d601a3..fab198b 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -37,7 +37,7 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 
 	/* We don't strictly need to be clearing the uninit flag if inuse < 0
 	 * (i.e. freeing inodes) but it also means something is bad. */
-	ext2fs_bg_flag_clear(fs, group, EXT2_BG_INODE_UNINIT);
+	ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
 		ext2_ino_t first_unused_inode =	fs->super->s_inodes_per_group -
@@ -76,7 +76,7 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 	else
 		ext2fs_unmark_block_bitmap2(fs->block_map, blk);
 	ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group) - inuse);
-	ext2fs_bg_flag_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+	ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 	ext2fs_group_desc_csum_set(fs, group);
 
 	ext2fs_free_blocks_count_add(fs->super, -inuse);
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index c73a39a..c71bd60 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -143,7 +143,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
 			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 			ext2fs_free_blocks_count_add(fs->super, -1);
-			ext2fs_bg_flag_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 			ext2fs_group_desc_csum_set(fs, gr);
 		}
 	}
@@ -171,7 +171,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
 			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 			ext2fs_free_blocks_count_add(fs->super, -1);
-			ext2fs_bg_flag_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 			ext2fs_group_desc_csum_set(fs, gr);
 		}
 	}
@@ -205,7 +205,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 				dgrp_t gr = ext2fs_group_of_blk2(fs, blk);
 				ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 				ext2fs_free_blocks_count_add(fs->super, -1);
-				ext2fs_bg_flag_clear(fs, gr,
+				ext2fs_bg_flags_clear(fs, gr,
 						     EXT2_BG_BLOCK_UNINIT);
 				ext2fs_group_desc_csum_set(fs, gr);
 			}
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 1f183f4..91abdfb 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -419,25 +419,9 @@ __u16 ext2fs_bg_flags(ext2_filsys fs, dgrp_t group)
 }
 
 /*
- * Set the flags for this block group
+ * Zero out the flags for this block group
  */
-void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
-{
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		gdp->bg_flags = bg_flags;
-		return;
-	}
-
-	fs->group_desc[group].bg_flags = bg_flags;
-}
-
-/*
- * Clear the flags for this block group
- */
-void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
+void ext2fs_bg_flags_zap(ext2_filsys fs, dgrp_t group)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
@@ -466,35 +450,35 @@ int ext2fs_bg_flag_test(ext2_filsys fs, dgrp_t group, __u16 bg_flag)
 }
 
 /*
- * Set a particular flag for this block group
+ * Set a flag or set of flags for this block group
  */
-void ext2fs_bg_flag_set(ext2_filsys fs, dgrp_t group, __u16 bg_flag)
+void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
 		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
 
-		gdp->bg_flags |= bg_flag;
+		gdp->bg_flags |= bg_flags;
 		return;
 	}
 
-	fs->group_desc[group].bg_flags |= bg_flag;
+	fs->group_desc[group].bg_flags |= bg_flags;
 }
 
 /*
- * Clear a particular flag for this block group
+ * Clear a flag or set of flags for this block group
  */
-void ext2fs_bg_flag_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flag)
+void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
 		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
 
-		gdp->bg_flags &= ~bg_flag;
+		gdp->bg_flags &= ~bg_flags;
 		return;
 	}
 
-	fs->group_desc[group].bg_flags &= ~bg_flag;
+	fs->group_desc[group].bg_flags &= ~bg_flags;
 }
 
 /*
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 120ce6f..a6661b7 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -122,7 +122,7 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 		int old_free_inodes_count = ext2fs_bg_free_inodes_count(fs, i);
 
 		if (old_free_inodes_count == sb->s_inodes_per_group) {
-			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_UNINIT);
+			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT);
 			ext2fs_bg_itable_unused_set(fs, i, sb->s_inodes_per_group);
 		} else {
 			int unused =
@@ -130,7 +130,7 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 				find_last_inode_ingrp(fs->inode_map,
 						      sb->s_inodes_per_group, i);
 
-			ext2fs_bg_flag_clear(fs, i, EXT2_BG_INODE_UNINIT);
+			ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
 			ext2fs_bg_itable_unused_set(fs, i, unused);
 		}
 
@@ -207,7 +207,7 @@ int main(int argc, char **argv)
 		fs->group_desc[i].bg_free_blocks_count = 31119;
 		fs->group_desc[i].bg_free_inodes_count = 15701;
 		fs->group_desc[i].bg_used_dirs_count = 2;
-		ext2fs_bg_flags_clear(fs, i, 0);
+		ext2fs_bg_flags_zap(fs, i);
 	};
 
 	csum1 = ext2fs_group_desc_csum(fs, 0);
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 4c5313c..aa4d94c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -776,12 +776,10 @@ extern __u32 ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_itable_unused_set(ext2_filsys fs, dgrp_t group,
 				     __u32 n);
 extern __u16 ext2fs_bg_flags(ext2_filsys fs, dgrp_t group);
-extern void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
-extern void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group,
-				  __u16 bg_flags);
+extern void ext2fs_bg_flags_zap(ext2_filsys fs, dgrp_t group);
 extern int ext2fs_bg_flag_test(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
-extern void ext2fs_bg_flag_set(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
-extern void ext2fs_bg_flag_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
+extern void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
+extern void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
 extern __u16 ext2fs_bg_checksum(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_checksum_set(ext2_filsys fs, dgrp_t group, __u16 checksum);
 extern blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode);
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 682b40a..439b379 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -417,8 +417,8 @@ ipg_retry:
 		 */
 		if (csum_flag) {
 			if (i != fs->group_desc_count - 1)
-				ext2fs_bg_flag_set(fs, i, EXT2_BG_BLOCK_UNINIT);
-			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_UNINIT);
+				ext2fs_bg_flags_set(fs, i, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT);
 			numblocks = super->s_inodes_per_group;
 			if (i == 0)
 				numblocks -= super->s_first_ino;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 39d7eaa..d750679 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -353,8 +353,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		dgrp_t group;
 
 		for (group = 0; group < fs->group_desc_count; group++) {
-			ext2fs_bg_flag_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
-			ext2fs_bg_flag_clear(fs, group, EXT2_BG_INODE_UNINIT);
+			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
 			ext2fs_bg_itable_unused_set(fs, group, 0);
 		}
 		ext2fs_mark_super_dirty(fs);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 3a809ee..2793548 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -322,7 +322,7 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 			       EXT2_BLOCK_SIZE(fs->super));
 		} else {
 			/* The kernel doesn't need to zero the itable blocks */
-			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_ZEROED);
+			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
 			ext2fs_group_desc_csum_set(fs, i);
 		}
 		retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index b449ae4..9a70b27 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -108,7 +108,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 
 	fix_uninit_block_bitmaps(rfs->new_fs);
 	/* Clear the block bitmap uninit flag for the last block group */
-	ext2fs_bg_flag_clear(rfs->new_fs, rfs->new_fs->group_desc_count - 1,
+	ext2fs_bg_flags_clear(rfs->new_fs, rfs->new_fs->group_desc_count - 1,
 			     EXT2_BG_BLOCK_UNINIT);
 
 	*new_size = ext2fs_blocks_count(rfs->new_fs->super);
@@ -495,9 +495,9 @@ retry:
 		       sizeof(struct ext2_group_desc));
 		adjblocks = 0;
 
-		ext2fs_bg_flags_clear(fs, i, 0);
+		ext2fs_bg_flags_zap(fs, i);
 		if (csum_flag)
-			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED)
+			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED)
 				;
 		if (i == fs->group_desc_count-1) {
 			numblocks = (ext2fs_blocks_count(fs->super) -
@@ -508,7 +508,7 @@ retry:
 		} else {
 			numblocks = fs->super->s_blocks_per_group;
 			if (csum_flag)
-				ext2fs_bg_flag_set(fs, i, EXT2_BG_BLOCK_UNINIT)
+				ext2fs_bg_flags_set(fs, i, EXT2_BG_BLOCK_UNINIT)
 					;
 		}
 

