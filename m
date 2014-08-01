From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/19] libext2fs: check EA block headers when reading in the
 block
Date: Fri, 01 Aug 2014 11:12:14 -0700
Message-ID: <20140801181214.12496.71494.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33062 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaHASMT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:19 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

When reading an EA block in from disk, do a quick sanity check of the
block header, and return an error if we think we have garbage.  Teach
e2fsck to ignore the new error code in favor of doing its own
checking, and remove the strict_csums bits while we're at it.

(Also document some assumptions in the new ext_attr code.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c        |   18 ++++++++++++------
 e2fsck/problem.c      |    5 -----
 e2fsck/problem.h      |    3 ---
 lib/ext2fs/ext_attr.c |   25 +++++++++++++++++++------
 4 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index e7a6acd..02683d3 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1748,12 +1748,16 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	pctx->blk = blk;
 	pctx->errcode = ext2fs_read_ext_attr3(fs, blk, block_buf, pctx->ino);
 	if (pctx->errcode == EXT2_ET_EXT_ATTR_CSUM_INVALID) {
-		if (fix_problem(ctx, PR_1_EA_BLOCK_CSUM_INVALID, pctx))
-			goto clear_extattr;
+		pctx->errcode = 0;
 		failed_csum = 1;
-	}
-	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
+	} else if (pctx->errcode == EXT2_ET_BAD_EA_HEADER)
+		pctx->errcode = 0;
+
+	if (pctx->errcode &&
+	    fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx)) {
+		pctx->errcode = 0;
 		goto clear_extattr;
+	}
 	header = (struct ext2_ext_attr_header *) block_buf;
 	pctx->blk = ext2fs_file_acl_block(fs, inode);
 	if (((ctx->ext_attr_ver == 1) &&
@@ -1769,6 +1773,9 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 			goto clear_extattr;
 	}
 
+	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
+		goto clear_extattr;
+
 	region = region_create(0, fs->blocksize);
 	if (!region) {
 		fix_problem(ctx, PR_1_EA_ALLOC_REGION_ABORT, pctx);
@@ -2438,8 +2445,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (ext2fs_file_acl_block(fs, inode) &&
-	    check_ext_attr(ctx, pctx, block_buf)) {
+	if (check_ext_attr(ctx, pctx, block_buf)) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			goto out;
 		pb.num_blocks++;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index e68433b..dc094ed 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -992,11 +992,6 @@ static struct e2fsck_problem problem_table[] = {
 	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
 	  PROMPT_FIX, 0 },
 
-	/* Inode extended attribute block checksum does not match block. */
-	{ PR_1_EA_BLOCK_CSUM_INVALID,
-	  N_("@i %i @a @b %b checksum does not match block.  "),
-	  PROMPT_CLEAR, 0 },
-
 	/*
 	 * Inode extended attribute block passes checks, but checksum does not
 	 * match block.
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 496e873..af7a73e 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -583,9 +583,6 @@ struct problem_context {
 /* extent block passes checks, but checksum does not match extent block */
 #define PR_1_EXTENT_ONLY_CSUM_INVALID  0x01006A
 
-/* ea block checksum invalid */
-#define PR_1_EA_BLOCK_CSUM_INVALID     0x01006B
-
 /* ea block passes checks, but checksum invalid */
 #define PR_1_EA_BLOCK_ONLY_CSUM_INVALID        0x01006C
 
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 308d21d..f3fba96 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -58,12 +58,23 @@ __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry, void *data)
 	return hash;
 }
 
+static errcode_t check_ext_attr_header(struct ext2_ext_attr_header *header)
+{
+	if ((header->h_magic != EXT2_EXT_ATTR_MAGIC_v1 &&
+	     header->h_magic != EXT2_EXT_ATTR_MAGIC) ||
+	    header->h_blocks != 1)
+		return EXT2_ET_BAD_EA_HEADER;
+
+	return 0;
+}
+
 #undef NAME_HASH_SHIFT
 #undef VALUE_HASH_SHIFT
 
 errcode_t ext2fs_read_ext_attr3(ext2_filsys fs, blk64_t block, void *buf,
 				ext2_ino_t inum)
 {
+	int		csum_failed = 0;
 	errcode_t	retval;
 
 	retval = io_channel_read_blk64(fs->io, block, 1, buf);
@@ -72,12 +83,16 @@ errcode_t ext2fs_read_ext_attr3(ext2_filsys fs, blk64_t block, void *buf,
 
 	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
 	    !ext2fs_ext_attr_block_csum_verify(fs, inum, block, buf))
-		retval = EXT2_ET_EXT_ATTR_CSUM_INVALID;
+		csum_failed = 1;
 
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_ext_attr(buf, buf, fs->blocksize, 1);
 #endif
 
+	retval = check_ext_attr_header(buf);
+	if (retval == 0 && csum_failed)
+		retval = EXT2_ET_EXT_ATTR_CSUM_INVALID;
+
 	return retval;
 }
 
@@ -321,6 +336,7 @@ errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
 	if (err)
 		goto out2;
 
+	/* We only know how to deal with v2 EA blocks */
 	header = (struct ext2_ext_attr_header *) block_buf;
 	if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
 		err = EXT2_ET_BAD_EA_HEADER;
@@ -380,6 +396,7 @@ static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 		if (err)
 			goto out2;
 
+		/* We only know how to deal with v2 EA blocks */
 		header = (struct ext2_ext_attr_header *) block_buf;
 		if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
 			err = EXT2_ET_BAD_EA_HEADER;
@@ -763,17 +780,13 @@ read_ea_block:
 		if (err)
 			goto out3;
 
+		/* We only know how to deal with v2 EA blocks */
 		header = (struct ext2_ext_attr_header *) block_buf;
 		if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
 			err = EXT2_ET_BAD_EA_HEADER;
 			goto out3;
 		}
 
-		if (header->h_blocks != 1) {
-			err = EXT2_ET_BAD_EA_HEADER;
-			goto out3;
-		}
