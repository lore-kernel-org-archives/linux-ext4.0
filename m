From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/19] e2fsck: offer to clear inode table blocks that are
 insane
Date: Fri, 01 Aug 2014 11:12:34 -0700
Message-ID: <20140801181234.12496.95546.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@orale.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33254 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaHASMm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:42 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new behavior flag to the inode scan functions; when specified,
this flag will do some simple sanity checking of entire inode table
blocks.  If all the checksums are ok, we can skip checksum
verification on individual inodes later on.  If more than half of the
inodes look "insane" (bad extent tree root or checksum failure) then
ext2fs_get_next_inode_full() can return a special status code
indicating that what's in the buffer is probably garbage.

When e2fsck' inode scan encounters the 'inode is garbage' return code
it'll offer to zap the inode straightaway instead of trying to recover
anything.  This replaces the previous behavior of asking to zap
anything with a checksum error (strict_csum).

Signed-off-by: Darrick J. Wong <darrick.wong@orale.com>
---
 e2fsck/pass1.c            |   18 ++++--
 e2fsck/problem.c          |    8 +--
 e2fsck/problem.h          |    4 +
 lib/ext2fs/ext2_err.et.in |    3 +
 lib/ext2fs/ext2fs.h       |    1 
 lib/ext2fs/inode.c        |  137 ++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 154 insertions(+), 17 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 283b0b1..a7792c4 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -809,7 +809,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ctx->flags |= E2F_FLAG_ABORT;
 		goto endit;
 	}
-	ext2fs_inode_scan_flags(scan, EXT2_SF_SKIP_MISSING_ITABLE, 0);
+	ext2fs_inode_scan_flags(scan, EXT2_SF_SKIP_MISSING_ITABLE |
+				      EXT2_SF_WARN_GARBAGE_INODES, 0);
 	ctx->stashed_inode = inode;
 	scan_struct.ctx = ctx;
 	scan_struct.block_buf = block_buf;
@@ -851,7 +852,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			continue;
 		}
 		if (pctx.errcode &&
-		    pctx.errcode != EXT2_ET_INODE_CSUM_INVALID) {
+		    pctx.errcode != EXT2_ET_INODE_CSUM_INVALID &&
+		    pctx.errcode != EXT2_ET_INODE_IS_GARBAGE) {
 			fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
 			goto endit;
@@ -862,12 +864,14 @@ void e2fsck_pass1(e2fsck_t ctx)
 		pctx.inode = inode;
 		ctx->stashed_ino = ino;
 
-		/* Clear corrupt inode? */
-		if (pctx.errcode == EXT2_ET_INODE_CSUM_INVALID) {
-			if (fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
-				goto clear_inode;
-			failed_csum = 1;
+		/* Clear trashed inode? */
+		if (pctx.errcode == EXT2_ET_INODE_IS_GARBAGE &&
+		    inode->i_links_count > 0 &&
+		    fix_problem(ctx, PR_1_INODE_IS_GARBAGE, &pctx)) {
+			pctx.errcode = 0;
+			e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
 		}
+		failed_csum = pctx.errcode != 0;
 
 		if (inode->i_links_count) {
 			pctx.errcode = ext2fs_icount_store(ctx->inode_link_info,
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 80ca3a0..452137a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -967,10 +967,10 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has zero length extent\n\t(@n logical @b %c, physical @b %b)\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* inode checksum does not match inode */
-	{ PR_1_INODE_CSUM_INVALID,
-	  N_("@i %i checksum does not match @i.  "),
-	  PROMPT_CLEAR, PR_PREEN_OK },
+	/* inode seems to contain garbage */
+	{ PR_1_INODE_IS_GARBAGE,
+	  N_("@i %i seems to contain garbage.  "),
+	  PROMPT_CLEAR, 0 },
 
 	/* inode passes checks, but checksum does not match inode */
 	{ PR_1_INODE_ONLY_CSUM_INVALID,
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 4813fc6..72cfc4d 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -571,8 +571,8 @@ struct problem_context {
 /* Extent has zero length */
 #define PR_1_EXTENT_LENGTH_ZERO		0x010066
 
-/* inode checksum does not match inode */
-#define PR_1_INODE_CSUM_INVALID                0x010067
+/* inode seems to contain garbage */
+#define PR_1_INODE_IS_GARBAGE		0x010067
 
 /* inode passes checks, but checksum does not match inode */
 #define PR_1_INODE_ONLY_CSUM_INVALID   0x010068
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 51c88d0..2194a18 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -515,4 +515,7 @@ ec	EXT2_ET_INLINE_DATA_NO_SPACE,
 ec	EXT2_ET_MAGIC_EA_HANDLE,
 	"Wrong magic number for extended attribute structure"
 
+ec	EXT2_ET_INODE_IS_GARBAGE,
+	"Inode seems to contain garbage"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7812956..b4a9f84 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -462,6 +462,7 @@ typedef struct ext2_struct_inode_scan *ext2_inode_scan;
 #define EXT2_SF_BAD_EXTRA_BYTES	0x0004
 #define EXT2_SF_SKIP_MISSING_ITABLE	0x0008
 #define EXT2_SF_DO_LAZY		0x0010
+#define EXT2_SF_WARN_GARBAGE_INODES	0x0020
 
 /*
  * ext2fs_check_if_mounted flags
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 0cea9f0..08024cb 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -30,6 +30,10 @@
 #include "ext2fsP.h"
 #include "e2image.h"
 
+#define IBLOCK_STATUS_CSUMS_OK	1
+#define IBLOCK_STATUS_INSANE	2
+#define SCAN_BLOCK_STATUS(scan)	((scan)->temp_buffer + (scan)->inode_size)
+
 struct ext2_struct_inode_scan {
 	errcode_t		magic;
 	ext2_filsys		fs;
@@ -193,12 +197,14 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 		ext2fs_free_mem(&scan);
 		return retval;
 	}
-	retval = ext2fs_get_mem(scan->inode_size, &scan->temp_buffer);
+	retval = ext2fs_get_mem(scan->inode_size + scan->inode_buffer_blocks,
+				&scan->temp_buffer);
 	if (retval) {
 		ext2fs_free_mem(&scan->inode_buffer);
 		ext2fs_free_mem(&scan);
 		return retval;
 	}
+	memset(SCAN_BLOCK_STATUS(scan), 0, scan->inode_buffer_blocks);
 	if (scan->fs->badblocks && scan->fs->badblocks->num)
 		scan->scan_flags |= EXT2_SF_CHK_BADBLOCKS;
 	if (ext2fs_has_group_desc_csum(fs))
@@ -348,6 +354,114 @@ static errcode_t check_for_inode_bad_blocks(ext2_inode_scan scan,
 	return 0;
 }
 
+static int block_map_looks_insane(ext2_filsys fs,
+				  struct ext2_inode_large *inode)
+{
+	unsigned int i, bad;
+
+	/* We're only interested in block mapped files, dirs, and symlinks */
+	if ((inode->i_flags & EXT4_INLINE_DATA_FL) ||
+	    (inode->i_flags & EXT4_EXTENTS_FL))
+		return 0;
+	if (!LINUX_S_ISREG(inode->i_mode) &&
+	    !LINUX_S_ISLNK(inode->i_mode) &&
+	    !LINUX_S_ISDIR(inode->i_mode))
+		return 0;
+	if (LINUX_S_ISLNK(inode->i_mode) &&
+	    EXT2_I_SIZE(inode) <= sizeof(inode->i_block))
+		return 0;
+
+	/* Unused inodes probably aren't insane */
+	if (inode->i_links_count == 0)
+		return 0;
+
+	/* See if more than half the block maps are insane */
+	for (i = 0, bad = 0; i < EXT2_N_BLOCKS; i++)
+		if (inode->i_block[i] != 0 &&
+		    (inode->i_block[i] < fs->super->s_first_data_block ||
+		     inode->i_block[i] >= ext2fs_blocks_count(fs->super)))
+			bad++;
+	return bad > EXT2_N_BLOCKS / 2;
+}
+
+static int extent_head_looks_insane(struct ext2_inode_large *inode)
+{
+	if (!(inode->i_flags & EXT4_EXTENTS_FL) ||
+	    ext2fs_extent_header_verify(inode->i_block,
+					sizeof(inode->i_block)) == 0)
+		return 0;
+	return 1;
+}
+
+/*
+ * Check all the inodes that we just read into the buffer.  Record what we
+ * find here -- currently, we can observe that all checksums are ok; more
+ * than half the inodes are insane; or no conclusions at all.
+ */
+static void check_inode_block_sanity(ext2_inode_scan scan, blk64_t num_blocks)
+{
+	ext2_ino_t	ino, inodes_to_scan;
+	unsigned int	badness, checksum_failures;
+	unsigned int	inodes_in_buf, inodes_per_block;
+	void		*p;
+	struct ext2_inode_large *inode;
+	char		*block_status;
+	unsigned int	blk;
+
+	if (!(scan->scan_flags & EXT2_SF_WARN_GARBAGE_INODES))
+		return;
+
+	inodes_to_scan = scan->inodes_left;
+	inodes_in_buf = num_blocks * scan->fs->blocksize / scan->inode_size;
+	if (inodes_to_scan > inodes_in_buf)
+		inodes_to_scan = inodes_in_buf;
+
+	p = scan->inode_buffer;
+	ino = scan->current_inode + 1;
+	checksum_failures = badness = 0;
+	block_status = SCAN_BLOCK_STATUS(scan);
+	memset(block_status, 0, scan->inode_buffer_blocks);
+	inodes_per_block = EXT2_INODES_PER_BLOCK(scan->fs->super);
+
+	while (inodes_to_scan > 0) {
+		blk = (p - (void *)scan->inode_buffer) / scan->fs->blocksize;
+		inode = p;
+
+		/* Is this inode insane? */
+		if (!ext2fs_inode_csum_verify(scan->fs, ino, inode)) {
+			checksum_failures++;
+			badness++;
+		} else if (extent_head_looks_insane(inode) ||
+			   block_map_looks_insane(scan->fs, inode))
+			badness++;
+
+		/* If more than half are insane, declare the whole block bad */
+		if (badness > inodes_per_block / 2) {
+			unsigned int ino_adj;
+
+			block_status[blk] |= IBLOCK_STATUS_INSANE;
+			ino_adj = inodes_per_block -
+						((ino - 1) % inodes_per_block);
+			if (ino_adj > inodes_to_scan)
+				ino_adj = inodes_to_scan;
+			inodes_to_scan -= ino_adj;
+			p += scan->inode_size * ino_adj;
+			ino += ino_adj;
+			checksum_failures = badness = 0;
+			continue;
+		}
+
+		if ((ino % inodes_per_block) == 0) {
+			if (checksum_failures == 0)
+				block_status[blk] |= IBLOCK_STATUS_CSUMS_OK;
+			checksum_failures = badness = 0;
+		}
+		inodes_to_scan--;
+		p += scan->inode_size;
+		ino++;
+	};
+}
+
 /*
  * This function is called by ext2fs_get_next_inode when it needs to
  * read in more blocks from the current blockgroup's inode table.
@@ -397,12 +511,15 @@ static errcode_t get_next_blocks(ext2_inode_scan scan)
 		if (retval)
 			return EXT2_ET_NEXT_INODE_READ;
 	}
+	check_inode_block_sanity(scan, num_blocks);
+
 	scan->ptr = scan->inode_buffer;
 	scan->bytes_left = num_blocks * scan->fs->blocksize;
 
 	scan->blocks_left -= num_blocks;
 	if (scan->current_block)
 		scan->current_block += num_blocks;
+
 	return 0;
 }
 
@@ -432,10 +549,14 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 {
 	errcode_t	retval;
 	int		extra_bytes = 0;
-	const int	length = EXT2_INODE_SIZE(scan->fs->super);
+	int		length;
 	struct ext2_inode_large	*iptr = (struct ext2_inode_large *)inode;
+	char		*iblock_status;
+	unsigned int	iblk;
 
 	EXT2_CHECK_MAGIC(scan, EXT2_ET_MAGIC_INODE_SCAN);
+	length = EXT2_INODE_SIZE(scan->fs->super);
+	iblock_status = SCAN_BLOCK_STATUS(scan);
 
 	/*
 	 * Do we need to start reading a new block group?
@@ -503,6 +624,9 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 	}
 
 	retval = 0;
+	iblk = scan->current_inode % EXT2_INODES_PER_GROUP(scan->fs->super) /
+				EXT2_INODES_PER_BLOCK(scan->fs->super) %
+				scan->inode_buffer_blocks;
 	if (extra_bytes) {
 		memcpy(scan->temp_buffer+extra_bytes, scan->ptr,
 		       scan->inode_size - extra_bytes);
@@ -510,7 +634,8 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 		scan->bytes_left -= scan->inode_size - extra_bytes;
 
 		/* Verify the inode checksum. */
-		if (!(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+		if (!(iblock_status[iblk] & IBLOCK_STATUS_CSUMS_OK) &&
+		    !(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
 		    !ext2fs_inode_csum_verify(scan->fs, scan->current_inode + 1,
 				(struct ext2_inode_large *)scan->temp_buffer))
 			retval = EXT2_ET_INODE_CSUM_INVALID;
@@ -529,7 +654,8 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 		scan->scan_flags &= ~EXT2_SF_BAD_EXTRA_BYTES;
 	} else {
 		/* Verify the inode checksum. */
-		if (!(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+		if (!(iblock_status[iblk] & IBLOCK_STATUS_CSUMS_OK) &&
+		    !(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
 		    !ext2fs_inode_csum_verify(scan->fs, scan->current_inode + 1,
 				(struct ext2_inode_large *)scan->ptr))
 			retval = EXT2_ET_INODE_CSUM_INVALID;
@@ -548,6 +674,9 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 		if (scan->scan_flags & EXT2_SF_BAD_INODE_BLK)
 			retval = EXT2_ET_BAD_BLOCK_IN_INODE_TABLE;
 	}
+	if ((iblock_status[iblk] & IBLOCK_STATUS_INSANE) &&
+	    (retval == 0 || retval == EXT2_ET_INODE_CSUM_INVALID))
+		retval = EXT2_ET_INODE_IS_GARBAGE;
 
 	scan->inodes_left--;
 	scan->current_inode++;

