From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 25/47] e2fsck: Check directory leaf block checksums
Date: Sat, 08 Oct 2011 00:35:55 -0700
Message-ID: <20111008073555.17888.73085.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49304 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1JHHiX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:38:23 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p986EZSZ012750
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 02:14:35 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987ZvJU139166
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:35:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987ZuAh017147
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:35:57 -0400
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Checks that directory leaf blocks have the necessary fake dir_entry at the end
of the block to hold a checksum and that the checksum is valid.  It will resize
the block and/or rebuild the directory if necessary.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/e2fsck.h  |    1 +
 e2fsck/pass2.c   |   76 ++++++++++++++++++++++++++++++++++++++++++++++++------
 e2fsck/pass3.c   |    4 +++
 e2fsck/problem.c |   10 +++++++
 e2fsck/problem.h |    6 ++++
 e2fsck/rehash.c  |   12 +++++++++
 6 files changed, 101 insertions(+), 8 deletions(-)


diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d225d89..96a0cc9 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -483,6 +483,7 @@ extern void region_free(region_t region);
 extern int region_allocate(region_t region, region_addr_t start, int n);
 
 /* rehash.c */
+int e2fsck_dir_will_be_rehashed(e2fsck_t ctx, ext2_ino_t ino);
 errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino);
 void e2fsck_rehash_directories(e2fsck_t ctx);
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 6b103fc..7b11405 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -748,7 +748,8 @@ static int check_dir_block(ext2_filsys fs,
 	struct problem_context	pctx;
 	int	dups_found = 0;
 	int	ret;
-	int	csum_size = 0;
+	int	dx_csum_size = 0, de_csum_size = 0;
+	int	is_leaf = 1;
 
 	cd = (struct check_dir_struct *) priv_data;
 	buf = cd->buf;
@@ -761,8 +762,10 @@ static int check_dir_block(ext2_filsys fs,
 		return DIRENT_ABORT;
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-		csum_size = sizeof(struct ext2_dx_tail);
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		dx_csum_size = sizeof(struct ext2_dx_tail);
+		de_csum_size = sizeof(struct ext2_dir_entry_tail);
+	}
 
 	/*
 	 * Make sure the inode is still in use (could have been
@@ -806,11 +809,15 @@ static int check_dir_block(ext2_filsys fs,
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
 	if (cd->pctx.errcode) {
+		char *buf2;
 		if (!fix_problem(ctx, PR_2_READ_DIRBLOCK, &cd->pctx)) {
 			ctx->flags |= E2F_FLAG_ABORT;
 			return DIRENT_ABORT;
 		}
-		memset(buf, 0, fs->blocksize);
+		ext2fs_new_dir_block(fs, db->blockcnt == 0 ? ino : 0,
+				     EXT2_ROOT_INO, &buf2);
+		memcpy(buf, buf2, fs->blocksize);
+		ext2fs_free_mem(&buf2);
 	}
 #ifdef ENABLE_HTREE
 	dx_dir = e2fsck_get_dx_dir_info(ctx, ino);
@@ -855,13 +862,49 @@ static int check_dir_block(ext2_filsys fs,
 			   (rec_len == fs->blocksize) &&
 			   (dirent->name_len == 0) &&
 			   (ext2fs_le16_to_cpu(limit->limit) ==
-			    ((fs->blocksize - (8 + csum_size)) /
+			    ((fs->blocksize - (8 + dx_csum_size)) /
 			     sizeof(struct ext2_dx_entry))))
 			dx_db->type = DX_DIRBLOCK_NODE;
+		is_leaf = 0;
 	}
 out_htree:
 #endif /* ENABLE_HTREE */
 
+	/* Verify checksum. */
+	if (is_leaf && de_csum_size) {
+		/* No space for csum?  Rebuild dirs in pass 3A. */
+		if (!ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
+			de_csum_size = 0;
+			if (e2fsck_dir_will_be_rehashed(ctx, ino))
+				goto skip_checksum;
+			if (!fix_problem(cd->ctx, PR_2_LEAF_NODE_MISSING_CSUM,
+					 &cd->pctx))
+				goto skip_checksum;
+			if (!ctx->dirs_to_hash)
+				ext2fs_u32_list_create(&ctx->dirs_to_hash, 50);
+			if (ctx->dirs_to_hash)
+				ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
+			goto skip_checksum;
+		}
+		if (!ext2fs_dirent_csum_verify(fs, ino,
+					       (struct ext2_dir_entry *)buf)) {
+			char *buf2;
+			if (!fix_problem(cd->ctx, PR_2_LEAF_NODE_CSUM_INVALID,
+					 &cd->pctx))
+				goto skip_checksum;
+			ext2fs_new_dir_block(fs,
+					     db->blockcnt == 0 ? ino : 0,
+					     EXT2_ROOT_INO, &buf2);
+			memcpy(buf, buf2, fs->blocksize);
+			ext2fs_free_mem(&buf2);
+			dir_modified++;
+		}
+	}
+	/* htree nodes don't use fake dirents to store checksums */
+	if (!is_leaf)
+		de_csum_size = 0;
+
+skip_checksum:
 	dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
 	prev = 0;
 	do {
@@ -1128,7 +1171,7 @@ out_htree:
 			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		offset += rec_len;
 		dot_state++;
-	} while (offset < fs->blocksize);
+	} while (offset < fs->blocksize - de_csum_size);
 #if 0
 	printf("\n");
 #endif
@@ -1145,16 +1188,33 @@ out_htree:
 			parse_int_node(fs, db, cd, dx_dir, buf);
 	}
 #endif /* ENABLE_HTREE */
-	if (offset != fs->blocksize) {
-		cd->pctx.num = rec_len - fs->blocksize + offset;
+
+	if (offset != fs->blocksize - de_csum_size) {
+		cd->pctx.num = rec_len - (fs->blocksize - de_csum_size) +
+			       offset;
 		if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
 			dirent->rec_len = cd->pctx.num;
 			dir_modified++;
 		}
 	}
 	if (dir_modified) {
+		/* leaf block with no tail?  Rehash dirs later. */
+		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+		    is_leaf &&
+		    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
+			if (!ctx->dirs_to_hash)
+				ext2fs_u32_list_create(&ctx->dirs_to_hash, 50);
+			if (ctx->dirs_to_hash)
+				ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
+		}
+
+		if (e2fsck_dir_will_be_rehashed(ctx, ino))
+			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		cd->pctx.errcode = ext2fs_write_dir_block4(fs, block_nr, buf,
 							   0, ino);
+		if (e2fsck_dir_will_be_rehashed(ctx, ino))
+			ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 86a509c..7ebbadc 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -658,8 +658,12 @@ static void fix_dotdot(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
+	if (e2fsck_dir_will_be_rehashed(ctx, ino))
+		ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	retval = ext2fs_dir_iterate(fs, ino, DIRENT_FLAG_INCLUDE_EMPTY,
 				    0, fix_dotdot_proc, &fp);
+	if (e2fsck_dir_will_be_rehashed(ctx, ino))
+		ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (retval || !fp.done) {
 		pctx.errcode = retval;
 		fix_problem(ctx, retval ? PR_3_FIX_PARENT_ERR :
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index d5c8796..5412dc8 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1388,6 +1388,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@p @h %d: node fails checksum\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
+	/* leaf node fails checksum */
+	{ PR_2_LEAF_NODE_CSUM_INVALID,
+	  N_("@d @i %i, %B, offset %N: @d fails checksum\n"),
+	  PROMPT_SALVAGE, 0 },
+
+	/* leaf node fails checksum */
+	{ PR_2_LEAF_NODE_MISSING_CSUM,
+	  N_("@d @i %i, %B, offset %N: @d has no checksum\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 22c6b9b..573a7f5 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -830,6 +830,12 @@ struct problem_context {
 /* htree node fails checksum */
 #define PR_2_HTREE_NODE_CSUM_INVALID	0x02004A
 
+/* dir leaf node fails checksum */
+#define PR_2_LEAF_NODE_CSUM_INVALID	0x02004B
+
+/* no space in leaf for checksum */
+#define PR_2_LEAF_NODE_MISSING_CSUM	0x02004C
+
 /*
  * Pass 3 errors
  */
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index ff5e000..31f3856 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -52,6 +52,15 @@
 #include "e2fsck.h"
 #include "problem.h"
 
+int e2fsck_dir_will_be_rehashed(e2fsck_t ctx, ext2_ino_t ino)
+{
+	if (ctx->options & E2F_OPT_COMPRESS_DIRS)
+		return 1;
+	if (!ctx->dirs_to_hash)
+		return 0;
+	return ext2fs_u32_list_test(ctx->dirs_to_hash, ino);
+}
+
 struct fill_dir_struct {
 	char *buf;
 	struct ext2_inode *inode;
@@ -901,8 +910,11 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 			if (!ext2fs_u32_list_iterate(iter, &ino))
 				break;
 		}
+#if 0
+		/* Why is lost_and_found never cleaned up or hashed? */
 		if (ino == ctx->lost_and_found)
 			continue;
+#endif
 		pctx.dir = ino;
 		if (first) {
 			fix_problem(ctx, PR_3A_PASS_HEADER, &pctx);

