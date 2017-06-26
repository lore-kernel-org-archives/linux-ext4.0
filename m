From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 07/12] e2fsck: track ea_inode references
Date: Mon, 26 Jun 2017 06:43:43 -0700
Message-ID: <20170626134348.1240-7-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35876 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752137AbdFZNoL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:11 -0400
Received: by mail-pf0-f172.google.com with SMTP id q86so720584pfl.3
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:06 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An extended attribute inode has a ref count to track how many entries
point to it. Update e2fsck to verify that the stored ref count is
correct.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 e2fsck/e2fsck.c  |   4 +++
 e2fsck/e2fsck.h  |   6 +++-
 e2fsck/message.c |   7 ++++
 e2fsck/pass1.c   |  66 ++++++++++++++++++++++--------------
 e2fsck/pass4.c   | 101 +++++++++++++++++++++++++++++++++++++++++++++----------
 e2fsck/problem.c |   4 +++
 e2fsck/problem.h |   5 ++-
 7 files changed, 148 insertions(+), 45 deletions(-)

diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index e0f449ee2047..63a986b92af9 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -102,6 +102,10 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 		ea_refcount_free(ctx->ea_block_quota);
 		ctx->ea_block_quota = 0;
 	}
+	if (ctx->ea_inode_refs) {
+		ea_refcount_free(ctx->ea_inode_refs);
+		ctx->ea_inode_refs = 0;
+	}
 	if (ctx->block_dup_map) {
 		ext2fs_free_block_bitmap(ctx->block_dup_map);
 		ctx->block_dup_map = 0;
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 79eeda9fbafb..b25c5eb9179b 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -254,7 +254,6 @@ struct e2fsck_struct {
 	ext2fs_inode_bitmap inode_bb_map; /* Inodes which are in bad blocks */
 	ext2fs_inode_bitmap inode_imagic_map; /* AFS inodes */
 	ext2fs_inode_bitmap inode_reg_map; /* Inodes which are regular files*/
-	ext2fs_inode_bitmap inode_ea_map; /* EA inodes which are non-orphan */
 
 	ext2fs_block_bitmap block_found_map; /* Blocks which are in use */
 	ext2fs_block_bitmap block_dup_map; /* Blks referenced more than once */
@@ -274,6 +273,11 @@ struct e2fsck_struct {
 	 */
 	ext2_refcount_t ea_block_quota;
 
+	/*
+	 * ea_inode references from attr entries.
+	 */
+	ext2_refcount_t ea_inode_refs;
+
 	/*
 	 * Array of flags indicating whether an inode bitmap, block
 	 * bitmap, or inode table is invalid
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 34201a37fd4b..525f4a1e7628 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -466,6 +466,13 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		fprintf(f, "%*u", width, ctx->num);
 #else
 		fprintf(f, "%*llu", width, (long long)ctx->num);
+#endif
+		break;
+	case 'n':
+#ifdef EXT2_NO_64_TYPE
+		fprintf(f, "%*u", width, ctx->num2);
+#else
+		fprintf(f, "%*llu", width, (long long)ctx->num2);
 #endif
 		break;
 	case 'p':
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index cc88a7d05cef..1033b7646cb6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -26,7 +26,7 @@
  * 	- A bitmap of which blocks are in use.		(block_found_map)
  * 	- A bitmap of which blocks are in use by two inodes	(block_dup_map)
  * 	- The data blocks of the directory inodes.	(dir_map)
- *	- A bitmap of EA inodes.			(inode_ea_map)
+ * 	- Ref counts for ea_inodes.			(ea_inode_refs)
  *
  * Pass 1 is designed to stash away enough information so that the
  * other passes should not need to read in the inode information
@@ -335,23 +335,6 @@ static void check_size(e2fsck_t ctx, struct problem_context *pctx)
 	e2fsck_write_inode(ctx, pctx->ino, pctx->inode, "pass1");
 }
 
-static void mark_inode_ea_map(e2fsck_t ctx, struct problem_context *pctx,
-			      ext2_ino_t ino)
-{
-	if (!ctx->inode_ea_map) {
-		pctx->errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-					 _("EA inode map"),
-					 &ctx->inode_ea_map);
-		if (pctx->errcode) {
-			fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR,
-				    pctx);
-			exit(1);
-		}
-	}
-
-	ext2fs_mark_inode_bitmap2(ctx->inode_ea_map, ino);
-}
-
 /*
  * For a given size, calculate how many blocks would be charged towards quota.
  */
@@ -428,13 +411,38 @@ static problem_t check_large_ea_inode(e2fsck_t ctx,
 	return 0;
 }
 
+static void inc_ea_inode_refs(e2fsck_t ctx, struct problem_context *pctx,
+			      struct ext2_ext_attr_entry *first, void *end)
+{
+	struct ext2_ext_attr_entry *entry;
+
+	for (entry = first;
+	     (void *)entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry);
+	     entry = EXT2_EXT_ATTR_NEXT(entry)) {
+		if (!entry->e_value_inum)
+			continue;
+		if (!ctx->ea_inode_refs) {
+			pctx->errcode = ea_refcount_create(0,
+							   &ctx->ea_inode_refs);
+			if (pctx->errcode) {
+				pctx->num = 4;
+				fix_problem(ctx, PR_1_ALLOCATE_REFCOUNT, pctx);
+				ctx->flags |= E2F_FLAG_ABORT;
+				return;
+			}
+		}
+		ea_refcount_increment(ctx->ea_inode_refs, entry->e_value_inum,
+				      0);
+	}
+}
+
 static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx,
 			      blk64_t *ea_ibody_quota_blocks)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct ext2_inode_large *inode;
 	struct ext2_ext_attr_entry *entry;
-	char *start, *header;
+	char *start, *header, *end;
 	unsigned int storage_size, remain;
 	problem_t problem = 0;
 	region_t region = 0;
@@ -447,6 +455,7 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx,
 		inode->i_extra_isize;
 	header = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 		 inode->i_extra_isize;
+	end = header + storage_size;
 	start = header + sizeof(__u32);
 	entry = (struct ext2_ext_attr_entry *) start;
 
@@ -524,7 +533,6 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx,
 			if (problem != 0)
 				goto fix;
 
-			mark_inode_ea_map(ctx, pctx, entry->e_value_inum);
 			quota_blocks += entry_quota_blocks;
 		}
 
@@ -549,6 +557,8 @@ fix:
 	 * EA(s) in automatic fashion -bzzz
 	 */
 	if (problem == 0 || !fix_problem(ctx, problem, pctx)) {
+		inc_ea_inode_refs(ctx, pctx,
+				  (struct ext2_ext_attr_entry *)start, end);
 		*ea_ibody_quota_blocks = quota_blocks;
 		return;
 	}
@@ -1988,6 +1998,11 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ctx->refcount_extra = 0;
 	}
 
+	if (ctx->ea_block_quota) {
+		ea_refcount_free(ctx->ea_block_quota);
+		ctx->ea_block_quota = 0;
+	}
+
 	if (ctx->invalid_bitmaps)
 		handle_fs_bad_blocks(ctx);
 
@@ -2349,7 +2364,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	blk64_t		blk;
 	char *		end;
 	struct ext2_ext_attr_header *header;
-	struct ext2_ext_attr_entry *entry;
+	struct ext2_ext_attr_entry *first, *entry;
 	blk64_t		quota_blocks = EXT2FS_C2B(fs, 1);
 	region_t	region = 0;
 	int		failed_csum = 0;
@@ -2473,8 +2488,9 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 			goto clear_extattr;
 	}
 
-	entry = (struct ext2_ext_attr_entry *)(header+1);
+	first = (struct ext2_ext_attr_entry *)(header+1);
 	end = block_buf + fs->blocksize;
+	entry = first;
 	while ((char *)entry < end && *(__u32 *)entry) {
 		__u32 hash;
 
@@ -2522,10 +2538,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 
 			problem = check_large_ea_inode(ctx, entry, pctx,
 						       &entry_quota_blocks);
-			if (problem == 0)
-				mark_inode_ea_map(ctx, pctx,
-						  entry->e_value_inum);
-			else if (fix_problem(ctx, problem, pctx))
+			if (problem && fix_problem(ctx, problem, pctx))
 				goto clear_extattr;
 
 			quota_blocks += entry_quota_blocks;
@@ -2565,6 +2578,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 		}
 		ea_refcount_store(ctx->ea_block_quota, blk, quota_blocks);
 	}
+	inc_ea_inode_refs(ctx, pctx, first, end);
 	ea_refcount_store(ctx->refcount, blk, header->h_refcount - 1);
 	mark_block_used(ctx, blk);
 	ext2fs_fast_mark_block_bitmap2(ctx->block_ea_map, blk);
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index e44fc69c1613..663f87ab59c0 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -11,7 +11,7 @@
  * Pass 4 frees the following data structures:
  * 	- A bitmap of which inodes are in bad blocks.	(inode_bb_map)
  * 	- A bitmap of which inodes are imagic inodes.	(inode_imagic_map)
- *	- A bitmap of EA inodes.			(inode_ea_map)
+ *	- Ref counts for ea_inodes.			(ea_inode_refs)
  */
 
 #include "config.h"
@@ -40,20 +40,6 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
 	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		extra_size = inode->i_extra_isize;
 
-	if (inode->i_flags & EXT4_EA_INODE_FL) {
-		if (ext2fs_test_inode_bitmap2(ctx->inode_ea_map, i)) {
-			ext2fs_icount_store(ctx->inode_count, i, 1);
-			return 0;
-		} else {
-			/* Zero the link count so that when inode is linked to
-			 * lost+found it has correct link count */
-			inode->i_links_count = 0;
-			e2fsck_write_inode(ctx, i, EXT2_INODE(inode),
-					   "disconnect_inode");
-			ext2fs_icount_store(ctx->inode_link_info, i, 0);
-		}
-	}
-
 	clear_problem_context(&pctx);
 	pctx.ino = i;
 	pctx.inode = EXT2_INODE(inode);
@@ -101,6 +87,77 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
 	return 0;
 }
 
+/*
+ * Get/set ref functions below could later be moved to somewhere in lib/ext2fs/.
+ * Currently the only user is e2fsck so we rather not expose it in common
+ * library until there are more users.
+ */
+static __u64 ea_inode_get_ref(struct ext2_inode_large *inode)
+{
+	return ((__u64)inode->i_ctime << 32) | inode->osd1.linux1.l_i_version;
+}
+
+static void ea_inode_set_ref(struct ext2_inode_large *inode, __u64 ref_count)
+{
+	inode->i_ctime = (__u32)(ref_count >> 32);
+	inode->osd1.linux1.l_i_version = (__u32)ref_count;
+}
+
+static void check_ea_inode(e2fsck_t ctx, ext2_ino_t i,
+			   struct ext2_inode_large *inode, __u16 *link_counted)
+{
+	__u64 actual_refs = 0;
+	__u64 ref_count;
+
+	/*
+	 * This function is called when link_counted is zero. So this may not
+	 * be an xattr inode at all. Return immediately if EA_INODE flag is not
+	 * set.
+	 */
+	e2fsck_read_inode_full(ctx, i, EXT2_INODE(inode),
+			       EXT2_INODE_SIZE(ctx->fs->super),
+			       "pass4: check_ea_inode");
+	if (!(inode->i_flags & EXT4_EA_INODE_FL))
+		return;
+
+	if (ctx->ea_inode_refs)
+		ea_refcount_fetch(ctx->ea_inode_refs, i, &actual_refs);
+	if (!actual_refs) {
+		/*
+		 * There are no attribute references to the ea_inode.
+		 * Zero the link count so that when  inode is linked to
+		 * lost+found it has correct link count.
+		 */
+		inode->i_links_count = 0;
+		e2fsck_write_inode(ctx, i, EXT2_INODE(inode), "check_ea_inode");
+		ext2fs_icount_store(ctx->inode_link_info, i, 0);
+		return;
+	}
+
+	/*
+	 * There are some attribute references, link_counted is now considered
+	 * to be 1.
+	 */
+	*link_counted = 1;
+
+	ref_count = ea_inode_get_ref(inode);
+
+	/* Old Lustre-style xattr inodes do not have a stored refcount.
+	 * However, their i_ctime and i_atime should be the same.
+	 */
+	if (ref_count != actual_refs && inode->i_ctime != inode->i_atime) {
+		struct problem_context pctx;
+
+		clear_problem_context(&pctx);
+		pctx.ino = i;
+		pctx.num = ref_count;
+		pctx.num2 = actual_refs;
+		if (fix_problem(ctx, PR_4_EA_INODE_REF_COUNT, &pctx)) {
+			ea_inode_set_ref(inode, actual_refs);
+			e2fsck_write_inode(ctx, i, EXT2_INODE(inode), "pass4");
+		}
+	}
+}
 
 void e2fsck_pass4(e2fsck_t ctx)
 {
@@ -168,6 +225,16 @@ void e2fsck_pass4(e2fsck_t ctx)
 			continue;
 		ext2fs_icount_fetch(ctx->inode_link_info, i, &link_count);
 		ext2fs_icount_fetch(ctx->inode_count, i, &link_counted);
+
+		if (link_counted == 0) {
+			/*
+			 * link_counted is expected to be 0 for an ea_inode.
+			 * check_ea_inode() will update link_counted if
+			 * necessary.
+			 */
+			check_ea_inode(ctx, i, inode, &link_counted);
+		}
+
 		if (link_counted == 0) {
 			if (!buf)
 				buf = e2fsck_allocate_memory(ctx,
@@ -211,10 +278,10 @@ void e2fsck_pass4(e2fsck_t ctx)
 	}
 	ext2fs_free_icount(ctx->inode_link_info); ctx->inode_link_info = 0;
 	ext2fs_free_icount(ctx->inode_count); ctx->inode_count = 0;
-	ext2fs_free_inode_bitmap(ctx->inode_ea_map);
-	ctx->inode_ea_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_bb_map);
 	ctx->inode_bb_map = 0;
+	ea_refcount_free(ctx->ea_inode_refs);
+	ctx->ea_inode_refs = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
 	ctx->inode_imagic_map = 0;
 errout:
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index deffa4d66a89..97069335156c 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1869,6 +1869,10 @@ static struct e2fsck_problem problem_table[] = {
 	  "They @s the same!\n"),
 	  PROMPT_NONE, 0 },
 
+	{ PR_4_EA_INODE_REF_COUNT,
+	  N_("@a @i %i ref count is %N, @s %n. "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 5 errors */
 
 	/* Pass 5: Checking group summary information */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 8e07c10895c1..54eb1cf9a519 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -20,7 +20,7 @@ struct problem_context {
 	e2_blkcnt_t	blkcount;
 	dgrp_t		group;
 	__u32		csum1, csum2;
-	__u64	num;
+	__u64		num, num2;
 	const char *str;
 };
 
@@ -1131,6 +1131,9 @@ struct problem_context {
 /* Inconsistent inode count information cached */
 #define PR_4_INCONSISTENT_COUNT		0x040004
 
+/* Extended attribute inode ref count wrong */
+#define PR_4_EA_INODE_REF_COUNT		0x040005
+
 /*
  * Pass 5 errors
  */
-- 
2.13.1.611.g7e3b11ae1-goog
