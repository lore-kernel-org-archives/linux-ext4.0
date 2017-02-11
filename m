From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] e2fsck: make problem comments match error messages
Date: Sat, 11 Feb 2017 00:24:36 -0700
Message-ID: <1486797876-4390-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:51460 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdBKHdr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Feb 2017 02:33:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the @x compression obscures e2fsck problem error messages
from being found by normal searching, make the comment for each
error match the actual error message so that they can be found
more easily.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/problem.c | 247 ++++++++++++-------------
 e2fsck/problem.h | 551 ++++++++++++++++++++++++++++---------------------------
 2 files changed, 402 insertions(+), 396 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 34a671e..c3fdb8b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -106,15 +106,15 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Pre-Pass 1 errors */
 
-	/* Block bitmap not in group */
+	/* Block bitmap for group is not in group */
 	{ PR_0_BB_NOT_GROUP, N_("@b @B for @g %g is not in @g.  (@b %b)\n"),
 	  PROMPT_RELOCATE, PR_LATCH_RELOC },
 
-	/* Inode bitmap not in group */
+	/* Inode bitmap for group is not in group */
 	{ PR_0_IB_NOT_GROUP, N_("@i @B for @g %g is not in @g.  (@b %b)\n"),
 	  PROMPT_RELOCATE, PR_LATCH_RELOC },
 
-	/* Inode table not in group */
+	/* Inode table for group is not in group.  (block nnnn) */
 	{ PR_0_ITABLE_NOT_GROUP,
 	  N_("@i table for @g %g is not in @g.  (@b %b)\n"
 	  "WARNING: SEVERE DATA LOSS POSSIBLE.\n"),
@@ -145,17 +145,17 @@ static struct e2fsck_problem problem_table[] = {
 	  "from the @b size.\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	  /* Bad blocks_per_group */
+	/* Superblock blocks_per_group = bbbb, should have been cccc */
 	{ PR_0_BLOCKS_PER_GROUP,
 	  N_("@S @bs_per_group = %b, should have been %c\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_0_SB_CORRUPT },
 
-	/* Bad first_data_block */
+	/* Superblock first_data_block = bbbb, should have been cccc */
 	{ PR_0_FIRST_DATA_BLOCK,
 	  N_("@S first_data_@b = %b, should have been %c\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_0_SB_CORRUPT },
 
-	/* Adding UUID to filesystem */
+	/* Filesystem did not have a UUID; generating one */
 	{ PR_0_ADD_UUID,
 	  N_("@f did not have a UUID; generating one.\n\n"),
 	  PROMPT_NONE, 0 },
@@ -188,12 +188,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("The Hurd does not support the filetype feature.\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* Journal inode is invalid */
+	/* Superblock has an invalid journal (inode inum) */
 	{ PR_0_JOURNAL_BAD_INODE,
 	  N_("@S has an @n @j (@i %i).\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* The external journal has (unsupported) multiple filesystems */
+	/* External journal has multiple filesystem users (unsupported) */
 	{ PR_0_JOURNAL_UNSUPP_MULTIFS,
 	  N_("External @j has multiple @f users (unsupported).\n"),
 	  PROMPT_NONE, PR_FATAL },
@@ -213,7 +213,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("External @j does not support this @f\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Journal has an unknown superblock type */
+	/* Filesystem journal superblock is an unknown type */
 	{ PR_0_JOURNAL_UNSUPP_SUPER,
 	  N_("@f @j @S is unknown type %N (unsupported).\n"
 	     "It is likely that your copy of e2fsck is old and/or doesn't "
@@ -231,7 +231,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@S has_@j flag is clear, but a @j is present.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Superblock needs_recovery flag is set but not journal is present */
+	/* Superblock needs_recovery flag is set but no journal is present */
 	{ PR_0_JOURNAL_RECOVER_SET,
 	  N_("@S needs_recovery flag is set, but no @j is present.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
@@ -286,12 +286,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@j @S has an unknown incompatible feature flag set.\n"),
 	  PROMPT_ABORT, 0 },
 
-	/* Journal has unsupported version number */
+	/* Journal version not supported by this e2fsck */
 	{ PR_0_JOURNAL_UNSUPP_VERSION,
 	  N_("@j version not supported by this e2fsck.\n"),
 	  PROMPT_ABORT, 0 },
 
-	/* Moving journal to hidden file */
+	/* Moving journal from /file to hidden inode */
 	{ PR_0_MOVE_JOURNAL,
 	  N_("Moving @j from /%s to hidden @i.\n\n"),
 	  PROMPT_NONE, 0 },
@@ -301,7 +301,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error moving @j: %m\n\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Clearing V2 journal superblock */
+	/* Found invalid V2 journal superblock fields */
 	{ PR_0_CLEAR_V2_JOURNAL,
 	  N_("Found @n V2 @j @S fields (from V1 @j).\n"
 	     "Clearing fields beyond the V1 @j @S...\n\n"),
@@ -317,47 +317,49 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Recovery flag not set in backup @S, so running @j anyway.\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Backup journal inode blocks */
+	/* Backing up journal inode block information */
 	{ PR_0_BACKUP_JNL,
 	  N_("Backing up @j @i @b information.\n\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Reserved blocks w/o resize_inode */
+	/* Filesystem does not have resize_inode enabled, but
+	 * s_reserved_gdt_blocks is nnnn; should be zero */
 	{ PR_0_NONZERO_RESERVED_GDT_BLOCKS,
 	  N_("@f does not have resize_@i enabled, but s_reserved_gdt_@bs\n"
 	     "is %N; @s zero.  "),
 	  PROMPT_FIX, 0 },
 
-	/* Resize_inode not enabled, but resize inode is non-zero */
+	/* Resize_inode not enabled, but the resize inode is non-zero */
 	{ PR_0_CLEAR_RESIZE_INODE,
 	  N_("Resize_@i not enabled, but the resize @i is non-zero.  "),
 	  PROMPT_CLEAR, 0 },
 
-	/* Resize inode invalid */
+	/* Resize inode not valid */
 	{ PR_0_RESIZE_INODE_INVALID,
 	  N_("Resize @i not valid.  "),
 	  PROMPT_RECREATE, 0 },
 
-	/* Last mount time is in the future */
+	/* Superblock last mount time is in the future */
 	{ PR_0_FUTURE_SB_LAST_MOUNT,
 	  N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
-	/* Last write time is in the future */
+	/* Superblock last write time is in the future */
 	{ PR_0_FUTURE_SB_LAST_WRITE,
 	  N_("@S last write time (%t,\n\tnow = %T) is in the future.\n"),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
+	/* Superblock hint for external superblock should be xxxx */
 	{ PR_0_EXTERNAL_JOURNAL_HINT,
 	  N_("@S hint for external superblock @s %X.  "),
 	     PROMPT_FIX, PR_PREEN_OK },
 
-	/* Adding dirhash hint */
+	/* Adding dirhash hint to filesystem */
 	{ PR_0_DIRHASH_HINT,
 	  N_("Adding dirhash hint to @f.\n\n"),
 	  PROMPT_NONE, 0 },
 
-	/* group descriptor N checksum is invalid. */
+	/* group descriptor N checksum is invalid, should be yyyy. */
 	{ PR_0_GDT_CSUM,
 	  N_("@g descriptor %g checksum is %04x, should be %04y.  "),
 	     PROMPT_FIX, PR_LATCH_BG_CHECKSUM },
@@ -377,11 +379,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Last @g @b @B uninitialized.  "),
 	     PROMPT_FIX, PR_PREEN_OK },
 
-	/* Journal transaction found corrupt */
+	/* Journal transaction was corrupt, replay was aborted */
 	{ PR_0_JNL_TXN_CORRUPT,
 	  N_("Journal transaction %i was corrupt, replay was aborted.\n"),
 	  PROMPT_NONE, 0 },
 
+	/* The test_fs filesystem flag is set (and ext4 is available) */
 	{ PR_0_CLEAR_TESTFS_FLAG,
 	  N_("The test_fs flag is set (and ext4 is available).  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
@@ -398,22 +401,22 @@ static struct e2fsck_problem problem_table[] = {
 	     "probably due to the hardware clock being incorrectly set)\n"),
 	  PROMPT_NONE, PR_PREEN_OK | PR_NO_OK },
 
-	/* Block group checksum (latch question) is invalid. */
+	/* One or more block group descriptor checksums are invalid (latch) */
 	{ PR_0_GDT_CSUM_LATCH,
 	  N_("One or more @b @g descriptor checksums are invalid.  "),
 	     PROMPT_FIX, PR_PREEN_OK },
 
-	/* Free inodes count wrong */
+	/* Setting free inodes count to right (was wrong) */
 	{ PR_0_FREE_INODE_COUNT,
 	  N_("Setting free @is count to %j (was %i)\n"),
 	  PROMPT_NONE, PR_PREEN_NOMSG },
 
-	/* Free blocks count wrong */
+	/* Setting free blocks count to right (was wrong) */
 	{ PR_0_FREE_BLOCK_COUNT,
 	  N_("Setting free @bs count to %c (was %b)\n"),
 	  PROMPT_NONE, PR_PREEN_NOMSG },
 
-	/* Making quota file hidden */
+	/* Making quota inode hidden */
 	{ PR_0_HIDE_QUOTA,
 	  N_("Making @q @i %i (%Q) hidden.\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
@@ -438,23 +441,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("ext2fs_check_desc: %m\n"),
 	  PROMPT_NONE, 0 },
 
-	/*
-	 * metadata_csum implies uninit_bg; both feature bits cannot
-	 * be set simultaneously.
-	 */
+	/* Superblock metadata_csum supersedes uninit_bg; both feature
+	 * bits cannot be set simultaneously. */
 	{ PR_0_META_AND_GDT_CSUM_SET,
 	  N_("@S metadata_csum supersedes uninit_bg; both feature "
 	     "bits cannot be set simultaneously."),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
-	/* Superblock has invalid MMP checksum. */
+	/* Superblock MMP block checksum does not match MMP block. */
 	{ PR_0_MMP_CSUM_INVALID,
-	  N_("@S MMP block checksum does not match MMP block.  "),
+	  N_("@S MMP @b checksum does not match MMP @b.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
-	/* 64bit is set but extents is unset. */
+	/* Superblock 64bit filesystem needs extents to access the whole disk */
 	{ PR_0_64BIT_WITHOUT_EXTENTS,
-	  N_("@S 64bit filesystems needs extents to access the whole disk.  "),
+	  N_("@S 64bit @f needs extents to access the whole disk.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
 	/* The first_meta_bg is too big */
@@ -462,12 +463,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("First_meta_bg is too big.  (%N, max value %g).  "),
 	  PROMPT_CLEAR, 0 },
 
-	/* External journal has corrupt superblock */
+	/* External journal superblock checksum does not match superblock */
 	{ PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID,
 	  N_("External @j @S checksum does not match @S.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* metadata_csum_seed means nothing without metadata_csum */
+	/* Superblock metadata_csum_seed means nothing without metadata_csum */
 	{ PR_0_CSUM_SEED_WITHOUT_META_CSUM,
 	  N_("@S metadata_csum_seed is not necessary without metadata_csum."),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
@@ -477,12 +478,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error initializing quota context in support library: %m\n"),
 	  PROMPT_NULL, PR_FATAL },
 
-	/* Bad s_min_extra_isize in superblock */
+	/* Bad required extra isize in superblock */
 	{ PR_0_BAD_MIN_EXTRA_ISIZE,
 	  N_("Bad required extra isize in @S (%N).  "),
 	  PROMPT_FIX, 0 },
 
-	/* Bad s_min_extra_isize in superblock */
+	/* Bad desired extra isize in superblock */
 	{ PR_0_BAD_WANT_EXTRA_ISIZE,
 	  N_("Bad desired extra isize in @S (%N).  "),
 	  PROMPT_FIX, 0 },
@@ -508,62 +509,62 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Reserved @i %i (%Q) has @n mode.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Deleted inode has zero dtime */
+	/* Deleted inode inum has zero dtime */
 	{ PR_1_ZERO_DTIME,
 	  N_("@D @i %i has zero dtime.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Inode in use, but dtime set */
+	/* Inode inum is in use, but has dtime set */
 	{ PR_1_SET_DTIME,
 	  N_("@i %i is in use, but has dtime set.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Zero-length directory */
+	/* Inode inum is a zero-length directory */
 	{ PR_1_ZERO_LENGTH_DIR,
 	  N_("@i %i is a @z @d.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Block bitmap conflicts with some other fs block */
+	/* Group block bitmap at block conflicts with some other fs block */
 	{ PR_1_BB_CONFLICT,
 	  N_("@g %g's @b @B at %b @C.\n"),
 	  PROMPT_RELOCATE, 0 },
 
-	/* Inode bitmap conflicts with some other fs block */
+	/* Group inode bitmap at block conflicts with some other fs block */
 	{ PR_1_IB_CONFLICT,
 	  N_("@g %g's @i @B at %b @C.\n"),
 	  PROMPT_RELOCATE, 0 },
 
-	/* Inode table conflicts with some other fs block */
+	/* Group inode table at block conflicts with some other fs block */
 	{ PR_1_ITABLE_CONFLICT,
 	  N_("@g %g's @i table at %b @C.\n"),
 	  PROMPT_RELOCATE, 0 },
 
-	/* Block bitmap is on a bad block */
+	/* Group block bitmap (block) is bad */
 	{ PR_1_BB_BAD_BLOCK,
 	  N_("@g %g's @b @B (%b) is bad.  "),
 	  PROMPT_RELOCATE, 0 },
 
-	/* Inode bitmap is on a bad block */
+	/* Group inode bitmap (block) is bad */
 	{ PR_1_IB_BAD_BLOCK,
 	  N_("@g %g's @i @B (%b) is bad.  "),
 	  PROMPT_RELOCATE, 0 },
 
-	/* Inode has incorrect i_size */
+	/* Inode inum, i_size is small, should be larger */
 	{ PR_1_BAD_I_SIZE,
 	  N_("@i %i, i_size is %Is, @s %N.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Inode has incorrect i_blocks */
+	/* Inode inum, i_blocks is small, should be larger */
 	{ PR_1_BAD_I_BLOCKS,
 	  N_("@i %i, i_@bs is %Ib, @s %N.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Illegal blocknumber in inode */
+	/* Illegal block number in inode */
 	{ PR_1_ILLEGAL_BLOCK_NUM,
 	  N_("@I %B (%b) in @i %i.  "),
 	  PROMPT_CLEAR, PR_LATCH_BLOCK },
 
-	/* Block number overlaps fs metadata */
+	/* Block number overlaps filesystem metadata in inode */
 	{ PR_1_BLOCK_OVERLAPS_METADATA,
 	  N_("%B (%b) overlaps @f metadata in @i %i.  "),
 	  PROMPT_CLEAR, PR_LATCH_BLOCK },
@@ -573,7 +574,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has illegal @b(s).  "),
 	  PROMPT_CLEAR, 0 },
 
-	/* Too many bad blocks in inode */
+	/* Too many illegal blocks in inode */
 	{ PR_1_TOO_MANY_BAD_BLOCKS,
 	  N_("Too many illegal @bs in @i %i.\n"),
 	  PROMPT_CLEAR_INODE, PR_NO_OK },
@@ -593,7 +594,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Duplicate or bad @b in use!\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Bad block used as bad block indirect block */
+	/* Bad block number used as bad block inode indirect block */
 	{ PR_1_BBINODE_BAD_METABLOCK,
 	  N_("Bad @b %b used as bad @b @i indirect @b.  "),
 	  PROMPT_CLEAR, PR_LATCH_BBLOCK },
@@ -616,7 +617,7 @@ static struct e2fsck_problem problem_table[] = {
 	     "that the @b is really OK.  But there are no guarantees.\n\n"),
 	  PROMPT_CLEAR, PR_PREEN_NOMSG },
 
-	/* Bad primary superblock */
+	/* The primary superblock block is on the bad block list */
 	{ PR_1_BAD_PRIMARY_SUPERBLOCK,
 	  N_("The primary @S (%b) is on the bad @b list.\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_1_BAD_PRIMARY_BLOCK },
@@ -624,52 +625,53 @@ static struct e2fsck_problem problem_table[] = {
 	/* Bad primary block group descriptors */
 	{ PR_1_BAD_PRIMARY_GROUP_DESCRIPTOR,
 	  N_("Block %b in the primary @g descriptors "
-	  "is on the bad @b list\n"),
+	     "is on the bad @b list\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_1_BAD_PRIMARY_BLOCK },
 
-	/* Bad superblock in group */
+	/* Warning: Group number's superblock (block) is bad */
 	{ PR_1_BAD_SUPERBLOCK,
 	  N_("Warning: Group %g's @S (%b) is bad.\n"),
 	  PROMPT_NONE, PR_PREEN_OK | PR_PREEN_NOMSG },
 
-	/* Bad block group descriptors in group */
+	/* Warning: Group number's copy of the group descriptors has a bad
+	 * block */
 	{ PR_1_BAD_GROUP_DESCRIPTORS,
 	  N_("Warning: Group %g's copy of the @g descriptors has a bad "
 	  "@b (%b).\n"),
 	  PROMPT_NONE, PR_PREEN_OK | PR_PREEN_NOMSG },
 
-	/* Block claimed for no reason */
+	/* Block number claimed for no reason in process_bad_blocks */
 	{ PR_1_PROGERR_CLAIMED_BLOCK,
 	  N_("Programming error?  @b #%b claimed for no reason in "
 	  "process_bad_@b.\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
 
-	/* Error allocating blocks for relocating metadata */
+	/* Allocating number contiguous block(s) in block group number */
 	{ PR_1_RELOC_BLOCK_ALLOCATE,
 	  N_("@A %N contiguous @b(s) in @b @g %g for %s: %m\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
 
-	/* Error allocating block buffer during relocation process */
+	/* Allocating block buffer for relocating process */
 	{ PR_1_RELOC_MEMORY_ALLOCATE,
 	  N_("@A @b buffer for relocating %s\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
 
-	/* Relocating metadata group information from X to Y */
+	/* Relocating group number's information from X to Y */
 	{ PR_1_RELOC_FROM_TO,
 	  N_("Relocating @g %g's %s from %b to %c...\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
 
-	/* Relocating metatdata group information to X */
+	/* Relocating group number's information to X */
 	{ PR_1_RELOC_TO,
 	  N_("Relocating @g %g's %s to %c...\n"), /* xgettext:no-c-format */
 	  PROMPT_NONE, PR_PREEN_OK },
 
-	/* Block read error during relocation process */
+	/* Warning: could not read block number of relocation process */
 	{ PR_1_RELOC_READ_ERR,
 	  N_("Warning: could not read @b %b of %s: %m\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
 
-	/* Block write error during relocation process */
+	/* Warning: could not write block number of relocation process */
 	{ PR_1_RELOC_WRITE_ERR,
 	  N_("Warning: could not write @b %b for %s: %m\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
@@ -699,23 +701,23 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error while scanning @is (%i): %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Error while iterating over blocks */
+	/* Error while iterating over blocks in inode */
 	{ PR_1_BLOCK_ITERATE,
 	  N_("Error while iterating over @bs in @i %i: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Error while storing inode count information */
+	/* Error storing inode count information */
 	{ PR_1_ICOUNT_STORE,
 	  N_("Error storing @i count information (@i=%i, count=%N): %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Error while storing directory block information */
+	/* Error storing directory block information */
 	{ PR_1_ADD_DBLOCK,
 	  N_("Error storing @d @b information "
 	  "(@i=%i, @b=%b, num=%N): %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Error while reading inode (for clearing) */
+	/* Error reading inode (for clearing) */
 	{ PR_1_READ_INODE,
 	  N_("Error reading @i %i: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
@@ -723,7 +725,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Suppress messages prompt */
 	{ PR_1_SUPPRESS_MESSAGES, "", PROMPT_SUPPRESS, PR_NO_OK },
 
-	/* Imagic flag set on an inode when filesystem doesn't support it */
+	/* Imagic number has imagic flag set when fs doesn't support it */
 	{ PR_1_SET_IMAGIC,
 	  N_("@i %i has imagic flag set.  "),
 	  PROMPT_CLEAR, 0 },
@@ -739,7 +741,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Special (@v/socket/fifo) @i %i has non-zero size.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Filesystem revision is 0, but feature flags are set */
+	/* Filesystem has feature flag(s) set, but is a revision 0 filesystem */
 	{ PR_1_FS_REV_LEVEL,
 	  N_("@f has feature flag(s) set, but is a revision 0 @f.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
@@ -749,18 +751,18 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@j @i is not in use, but contains data.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Journal has bad mode */
+	/* Journal is not a regular file */
 	{ PR_1_JOURNAL_BAD_MODE,
 	  N_("@j is not regular file.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Deal with inodes that were part of orphan linked list */
+	/* Inode that was part of the orphan list */
 	{ PR_1_LOW_DTIME,
 	  N_("@i %i was part of the @o @i list.  "),
 	  PROMPT_FIX, PR_LATCH_LOW_DTIME, 0 },
 
-	/* Deal with inodes that were part of corrupted orphan linked
-	   list (latch question) */
+	/* Inodes that were part of a corrupted orphan linked list found
+	 * (latch question) */
 	{ PR_1_ORPHAN_LIST_REFUGEES,
 	  N_("@is that were part of a corrupted orphan linked list found.  "),
 	  PROMPT_FIX, 0 },
@@ -775,7 +777,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error reading @a @b %b for @i %i.  "),
 	  PROMPT_CLEAR, 0 },
 
-	/* Invalid extended attribute block */
+	/* Inode number has a bad extended attribute block */
 	{ PR_1_BAD_EA_BLOCK,
 	  N_("@i %i has a bad @a @b %b.  "),
 	  PROMPT_CLEAR, 0 },
@@ -785,7 +787,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error reading @a @b %b (%m).  "),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Extended attribute reference count incorrect */
+	/* Extended attribute number has reference count incorrect */
 	{ PR_1_EXTATTR_REFCOUNT,
 	  N_("@a @b %b has reference count %r, @s %N.  "),
 	  PROMPT_FIX, 0 },
@@ -795,153 +797,154 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error writing @a @b %b (%m).  "),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Multiple EA blocks not supported */
+	/* Extended attribute block has h_blocks > 1 */
 	{ PR_1_EA_MULTI_BLOCK,
 	  N_("@a @b %b has h_@bs > 1.  "),
 	  PROMPT_CLEAR, 0},
 
-	/* Error allocating EA region allocation structure */
+	/* Allocating extended attribute region allocation structure */
 	{ PR_1_EA_ALLOC_REGION_ABORT,
 	  N_("@A @a region allocation structure.  "),
 	  PROMPT_NONE, PR_FATAL},
 
-	/* Error EA allocation collision */
+	/* Extended Attribute block number is corrupt (allocation collision) */
 	{ PR_1_EA_ALLOC_COLLISION,
 	  N_("@a @b %b is corrupt (allocation collision).  "),
 	  PROMPT_CLEAR, 0},
 
-	/* Bad extended attribute name */
+	/* Extended attribute block number is corrupt (invalid name) */
 	{ PR_1_EA_BAD_NAME,
 	  N_("@a @b %b is corrupt (@n name).  "),
 	  PROMPT_CLEAR, 0},
 
-	/* Bad extended attribute value */
+	/* Extended attribute block number is corrupt (invalid value) */
 	{ PR_1_EA_BAD_VALUE,
 	  N_("@a @b %b is corrupt (@n value).  "),
 	  PROMPT_CLEAR, 0},
 
-	/* Inode too big (latch question) */
+	/* Inode number is too big (latch question) */
 	{ PR_1_INODE_TOOBIG,
 	  N_("@i %i is too big.  "), PROMPT_TRUNCATE, 0 },
 
-	/* Directory too big */
+	/* Problem causes directory to be too big */
 	{ PR_1_TOOBIG_DIR,
 	  N_("%B (%b) causes @d to be too big.  "),
 	  PROMPT_CLEAR, PR_LATCH_TOOBIG },
 
-	/* Regular file too big */
+	/* Problem causes file to be too big */
 	{ PR_1_TOOBIG_REG,
 	  N_("%B (%b) causes file to be too big.  "),
 	  PROMPT_CLEAR, PR_LATCH_TOOBIG },
 
-	/* Symlink too big */
+	/* Problem causes symlink to be too big */
 	{ PR_1_TOOBIG_SYMLINK,
 	  N_("%B (%b) causes symlink to be too big.  "),
 	  PROMPT_CLEAR, PR_LATCH_TOOBIG },
 
-	/* INDEX_FL flag set on a non-HTREE filesystem */
+	/* Inode has INDEX_FL flag set on filesystem without htree support  */
 	{ PR_1_HTREE_SET,
 	  N_("@i %i has INDEX_FL flag set on @f without htree support.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* INDEX_FL flag set on a non-directory */
+	/* Inode number has INDEX_FL flag set but is on a directory */
 	{ PR_1_HTREE_NODIR,
 	  N_("@i %i has INDEX_FL flag set but is not a @d.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* Invalid root node in HTREE directory */
+	/* htree directory has an invalid root node */
 	{ PR_1_HTREE_BADROOT,
 	  N_("@h %i has an @n root node.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* Unsupported hash version in HTREE directory */
+	/* Htree directory has an unsupported hash version */
 	{ PR_1_HTREE_HASHV,
 	  N_("@h %i has an unsupported hash version (%N)\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* Incompatible flag in HTREE root node */
+	/* Htree directory uses an Incompatible htree root node flag */
 	{ PR_1_HTREE_INCOMPAT,
 	  N_("@h %i uses an incompatible htree root node flag.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* HTREE too deep */
+	/* Htree directory has a tree depth which is too big */
 	{ PR_1_HTREE_DEPTH,
 	  N_("@h %i has a tree depth (%N) which is too big\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* Bad block has indirect block that conflicts with filesystem block */
+	/* Bad block inode has an indirect block number that conflicts with
+	 * filesystem metadata */
 	{ PR_1_BB_FS_BLOCK,
 	  N_("Bad @b @i has an indirect @b (%b) that conflicts with\n"
 	     "@f metadata.  "),
 	  PROMPT_CLEAR, PR_LATCH_BBLOCK },
 
-	/* Resize inode failed */
+	/* Resize inode (re)creation failed */
 	{ PR_1_RESIZE_INODE_CREATE,
 	  N_("Resize @i (re)creation failed: %m."),
 	  PROMPT_CONTINUE, 0 },
 
-	/* invalid inode->i_extra_isize */
+	/* inode has a extra size i_extra_isize which is invalid */
 	{ PR_1_EXTRA_ISIZE,
 	  N_("@i %i has a extra size (%IS) which is @n\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* invalid ea entry->e_name_len */
+	/* Extended attribute in inode has a namelen which is invalid */
 	{ PR_1_ATTR_NAME_LEN,
 	  N_("@a in @i %i has a namelen (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_value_offs */
+	/* Extended attribute in inode has a value offset which is invalid */
 	{ PR_1_ATTR_VALUE_OFFSET,
 	  N_("@a in @i %i has a value offset (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_value_block */
+	/* extended attribute in inode has a value block which is invalid */
 	{ PR_1_ATTR_VALUE_BLOCK,
 	  N_("@a in @i %i has a value @b (%N) which is @n (must be 0)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_value_size */
+	/* extended attribute in inode has a value size which is invalid */
 	{ PR_1_ATTR_VALUE_SIZE,
 	  N_("@a in @i %i has a value size (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* invalid ea entry->e_hash */
+	/* extended attribute in inode has a hash which is invalid */
 	{ PR_1_ATTR_HASH,
 	  N_("@a in @i %i has a hash (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* inode appears to be a directory */
+	/* inode is a type but it looks like it is really a directory */
 	{ PR_1_TREAT_AS_DIRECTORY,
 	  N_("@i %i is a %It but it looks like it is really a directory.\n"),
 	  PROMPT_FIX, 0 },
 
-	/* Error while reading extent tree */
+	/* Error while reading extent tree in inode */
 	{ PR_1_READ_EXTENT,
 	  N_("Error while reading over @x tree in @i %i: %m\n"),
 	  PROMPT_CLEAR_INODE, 0 },
 
-	/* Failure to iterate extents */
+	/* Failure to iterate extents in inode */
 	{ PR_1_EXTENT_ITERATE_FAILURE,
 	  N_("Failed to iterate extents in @i %i\n"
 	     "\t(op %s, blk %b, lblk %c): %m\n"),
 	  PROMPT_CLEAR_INODE, 0 },
 
-	/* Bad starting block in extent */
+	/* Inode has an invalid extent starting block */
 	{ PR_1_EXTENT_BAD_START_BLK,
 	  N_("@i %i has an @n extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* Extent ends beyond filesystem */
+	/* Inode has an invalid extent that ends beyond filesystem */
 	{ PR_1_EXTENT_ENDS_BEYOND,
 	  N_("@i %i has an @n extent\n\t(logical @b %c, physical @b %b, @n len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* EXTENTS_FL flag set on a non-extents filesystem */
+	/* inode has EXTENTS_FL flag set on filesystem without extents support*/
 	{ PR_1_EXTENTS_SET,
 	  N_("@i %i has EXTENTS_FL flag set on @f without extents support.\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* inode has extents, superblock missing INCOMPAT_EXTENTS feature */
+	/* inode is in extents format, but superblock is missing EXTENTS feature */
 	{ PR_1_EXTENT_FEATURE,
 	  N_("@i %i is in extent format, but @S is missing EXTENTS feature\n"),
 	  PROMPT_FIX, 0 },
@@ -965,14 +968,14 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has an invalid extent node (blk %b, lblk %c)\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* Failed to convert subcluster bitmap */
+	/* Failed to convert subcluster block bitmap */
 	{ PR_1_CONVERT_SUBCLUSTER,
 	  N_("Error converting subcluster @b @B: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
-	/* Quota inode has bad mode */
+	/* Quota inode is not a regular file */
 	{ PR_1_QUOTA_BAD_MODE,
-	  N_("@q @i is not regular file.  "),
+	  N_("@q @i is not a regular file.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
 	/* Quota inode is not in use, but contains data */
@@ -980,17 +983,17 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@q @i is not in use, but contains data.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Quota inode is user visible */
+	/* Quota inode is visible to the user */
 	{ PR_1_QUOTA_INODE_NOT_HIDDEN,
 	  N_("@q @i is visible to the user.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Invalid bad inode */
+	/* The bad block inode looks invalid */
 	{ PR_1_INVALID_BAD_INODE,
 	  N_("The bad @b @i looks @n.  "),
 	  PROMPT_CLEAR, 0 },
 
-	/* Extent has zero length */
+	/* Extent has zero length extent */
 	{ PR_1_EXTENT_LENGTH_ZERO,
 	  N_("@i %i has zero length extent\n\t(@n logical @b %c, physical @b %b)\n"),
 	  PROMPT_CLEAR, 0 },
@@ -1027,32 +1030,29 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i @a @b %b passes checks, but checksum does not match @b.  "),
 	  PROMPT_FIX, 0 },
 
-	/*
-	 * Interior extent node logical offset doesn't match first node below it
-	 */
+	/* Interior extent node level number of inode doesn't first node down */
 	{ PR_1_EXTENT_INDEX_START_INVALID,
 	  N_("Interior @x node level %N of @i %i:\n"
 	     "Logical start %b does not match logical start %c at next level.  "),
 	  PROMPT_FIX, 0 },
 
-	/* Extent end is out of bounds for the tree */
+	/* Inode end of extent exceeds allowed value */
 	{ PR_1_EXTENT_END_OUT_OF_BOUNDS,
 	  N_("@i %i, end of extent exceeds allowed value\n\t(logical @b %c, physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* Inode has inline data, but superblock is missing INLINE_DATA feature. */
+	/* Inode has inline data, but superblock is missing INLINE_DATA feature */
 	{ PR_1_INLINE_DATA_FEATURE,
 	  N_("@i %i has inline data, but @S is missing INLINE_DATA feature\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* INLINE_DATA feature is set in a non-inline-data filesystem */
+	/* inode has INLINE_DATA_FL flag on filesystem without inline data */
 	{ PR_1_INLINE_DATA_SET,
 	  N_("@i %i has INLINE_DATA_FL flag on @f without inline data support.\n"),
 	  PROMPT_CLEAR, 0 },
 
 	/*
-	 * Inode block conflicts with critical metadata, skipping
-	 * block checks
+	 * Inode block conflicts with critical metadata, skipping block checks
 	 */
 	{ PR_1_CRITICAL_METADATA_COLLISION,
 	  N_("@i %i block %b conflicts with critical metadata, skipping block checks.\n"),
@@ -1068,7 +1068,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@d @i %i has @x marked uninitialized at @b %c.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* Inode logical block (physical block ) is misaligned. */
+	/* Inode logical block (physical block) violates cluster allocation */
 	{ PR_1_MISALIGNED_CLUSTER,
 	  N_("@i %i logical @b %b (physical @b %c) violates cluster allocation rules.\nWill fix in pass 1B.\n"),
 	  PROMPT_NONE, 0 },
@@ -1078,7 +1078,8 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has INLINE_DATA_FL flag but @a not found.  "),
 	  PROMPT_TRUNCATE, 0 },
 
-	/* Extents/inlinedata flag set on a device or socket inode */
+	/* Special (device/socket/fifo) file (inode num) has extents
+	 * or inline-data flag set */
 	{ PR_1_SPECIAL_EXTENTS_IDATA,
 	  N_("Special (@v/socket/fifo) file (@i %i) has extents\n"
 	     "or inline-data flag set.  "),
@@ -1114,7 +1115,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@A @x region allocation structure.  "),
 	  PROMPT_NONE, PR_FATAL},
 
-	/* Inode has a duplicate extent mapping */
+	/* Inode leaf has a duplicate extent mapping */
 	{ PR_1_EXTENT_COLLISION,
 	  N_("@i %i has a duplicate @x mapping\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
@@ -1129,7 +1130,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i @x tree could be more shallow (%b; could be <= %c)\n"),
 	  PROMPT_FIX, PR_NO_OK | PR_PREEN_NO | PR_PREEN_OK },
 
-	/* Inode extent tree could be more shallow */
+	/* inode num on bigalloc filesystem cannot be block mapped */
 	{ PR_1_NO_BIGALLOC_BLOCKMAP_FILES,
 	  N_("@i %i on bigalloc @f cannot be @b mapped.  "),
 	  PROMPT_FIX, 0 },
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 86cb614..d291e26 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -58,83 +58,83 @@ struct problem_context {
  * Pre-Pass 1 errors
  */
 
-/* Block bitmap not in group */
-#define PR_0_BB_NOT_GROUP	0x000001
+/* Block bitmap for group gggg is not in group */
+#define PR_0_BB_NOT_GROUP			0x000001
 
-/* Inode bitmap not in group */
-#define PR_0_IB_NOT_GROUP	0x000002
+/* Inode bitmap for group gggg is not in group */
+#define PR_0_IB_NOT_GROUP			0x000002
 
-/* Inode table not in group */
-#define PR_0_ITABLE_NOT_GROUP	0x000003
+/* Inode table for group gggg is not in group.  (block nnnn) */
+#define PR_0_ITABLE_NOT_GROUP			0x000003
 
 /* Superblock corrupt */
-#define PR_0_SB_CORRUPT		0x000004
+#define PR_0_SB_CORRUPT				0x000004
 
 /* Filesystem size is wrong */
-#define PR_0_FS_SIZE_WRONG	0x000005
+#define PR_0_FS_SIZE_WRONG			0x000005
 
 /* Fragments not supported */
-#define PR_0_NO_FRAGMENTS	0x000006
+#define PR_0_NO_FRAGMENTS			0x000006
 
-/* Bad blocks_per_group */
-#define PR_0_BLOCKS_PER_GROUP	0x000007
+/* Superblock blocks_per_group = bbbb, should have been cccc */
+#define PR_0_BLOCKS_PER_GROUP			0x000007
 
-/* Bad first_data_block */
-#define PR_0_FIRST_DATA_BLOCK	0x000008
+/* Superblock first_data_block = bbbb, should have been cccc */
+#define PR_0_FIRST_DATA_BLOCK			0x000008
 
-/* Adding UUID to filesystem */
-#define PR_0_ADD_UUID		0x000009
+/* Filesystem did not have a UUID; generating one */
+#define PR_0_ADD_UUID				0x000009
 
 /* Relocate hint */
-#define PR_0_RELOCATE_HINT	0x00000A
+#define PR_0_RELOCATE_HINT			0x00000A
 
 /* Miscellaneous superblock corruption */
-#define PR_0_MISC_CORRUPT_SUPER	0x00000B
+#define PR_0_MISC_CORRUPT_SUPER			0x00000B
 
 /* Error determing physical device size of filesystem */
-#define PR_0_GETSIZE_ERROR	0x00000C
+#define PR_0_GETSIZE_ERROR			0x00000C
 
 /* Inode count in the superblock incorrect */
-#define PR_0_INODE_COUNT_WRONG	0x00000D
+#define PR_0_INODE_COUNT_WRONG			0x00000D
 
 /* The Hurd does not support the filetype feature */
-#define PR_0_HURD_CLEAR_FILETYPE 0x00000E
+#define PR_0_HURD_CLEAR_FILETYPE		0x00000E
 
-/* Journal inode is invalid */
-#define PR_0_JOURNAL_BAD_INODE	0x00000F
+/* Superblock has an invalid journal (inode inum) */
+#define PR_0_JOURNAL_BAD_INODE			0x00000F
 
-/* The external journal has multiple filesystems (which we can't handle yet) */
-#define PR_0_JOURNAL_UNSUPP_MULTIFS 0x000010
+/* External journal has multiple filesystem users (unsupported) */
+#define PR_0_JOURNAL_UNSUPP_MULTIFS		0x000010
 
 /* Can't find external journal */
-#define PR_0_CANT_FIND_JOURNAL	0x000011
+#define PR_0_CANT_FIND_JOURNAL			0x000011
 
 /* External journal has bad superblock */
-#define PR_0_EXT_JOURNAL_BAD_SUPER 0x000012
+#define PR_0_EXT_JOURNAL_BAD_SUPER		0x000012
 
 /* Superblock has a bad journal UUID */
-#define PR_0_JOURNAL_BAD_UUID	0x000013
+#define PR_0_JOURNAL_BAD_UUID			0x000013
 
-/* Journal has an unknown superblock type */
-#define PR_0_JOURNAL_UNSUPP_SUPER 0x000014
+/* Filesystem journal superblock is an unknown type */
+#define PR_0_JOURNAL_UNSUPP_SUPER		0x000014
 
 /* Journal superblock is corrupt */
-#define PR_0_JOURNAL_BAD_SUPER	0x000015
+#define PR_0_JOURNAL_BAD_SUPER			0x000015
 
-/* Journal superblock is corrupt */
-#define PR_0_JOURNAL_HAS_JOURNAL 0x000016
+/* Superblock has_journal flag is clear but has a journal */
+#define PR_0_JOURNAL_HAS_JOURNAL		0x000016
 
-/* Superblock has recovery flag set but no journal */
-#define PR_0_JOURNAL_RECOVER_SET 0x000017
+/* Superblock needs_recovery flag is set but no journal is present */
+#define PR_0_JOURNAL_RECOVER_SET		0x000017
 
 /* Journal has data, but recovery flag is clear */
-#define PR_0_JOURNAL_RECOVERY_CLEAR 0x000018
+#define PR_0_JOURNAL_RECOVERY_CLEAR		0x000018
 
 /* Ask if we should clear the journal */
-#define PR_0_JOURNAL_RESET_JOURNAL 0x000019
+#define PR_0_JOURNAL_RESET_JOURNAL		0x000019
 
 /* Filesystem revision is 0, but feature flags are set */
-#define PR_0_FS_REV_LEVEL	0x00001A
+#define PR_0_FS_REV_LEVEL			0x00001A
 
 /* Clearing orphan inode */
 #define PR_0_ORPHAN_CLEAR_INODE			0x000020
@@ -157,16 +157,16 @@ struct problem_context {
 /* Journal has unsupported incompatible feature - abort */
 #define PR_0_JOURNAL_UNSUPP_INCOMPAT		0x000026
 
-/* Journal has unsupported version number */
+/* Journal version not supported by this e2fsck */
 #define PR_0_JOURNAL_UNSUPP_VERSION		0x000027
 
-/* Moving journal to hidden file */
+/* Moving journal from /file to hidden inode */
 #define	PR_0_MOVE_JOURNAL			0x000028
 
-/* Error moving journal */
+/* Error moving journal to hidden file */
 #define	PR_0_ERR_MOVE_JOURNAL			0x000029
 
-/* Clearing V2 journal superblock */
+/* Found invalid V2 journal superblock fields */
 #define PR_0_CLEAR_V2_JOURNAL			0x00002A
 
 /* Run journal anyway */
@@ -175,31 +175,32 @@ struct problem_context {
 /* Run journal anyway by default */
 #define PR_0_JOURNAL_RUN_DEFAULT		0x00002C
 
-/* Backup journal inode blocks */
+/* Backing up journal inode block information */
 #define PR_0_BACKUP_JNL				0x00002D
 
-/* Reserved blocks w/o resize_inode */
+/* Filesystem does not have resize_inode enabled, but
+ * s_reserved_gdt_blocks is nnnn; should be zero */
 #define PR_0_NONZERO_RESERVED_GDT_BLOCKS	0x00002E
 
-/* Resize_inode not enabled, but resize inode is non-zero */
+/* Resize_inode not enabled, but the resize inode is non-zero */
 #define PR_0_CLEAR_RESIZE_INODE			0x00002F
 
-/* Resize inode invalid */
+/* Resize inode not valid */
 #define PR_0_RESIZE_INODE_INVALID		0x000030
 
-/* Last mount time is in the future */
+/* Superblock last mount time is in the future */
 #define PR_0_FUTURE_SB_LAST_MOUNT		0x000031
 
-/* Last write time is in the future */
+/* Superblock last write time is in the future */
 #define PR_0_FUTURE_SB_LAST_WRITE		0x000032
 
-/* Superblock hint for external journal incorrect */
+/* Superblock hint for external superblock should be xxxx */
 #define PR_0_EXTERNAL_JOURNAL_HINT		0x000033
 
-/* Superblock hint for external journal incorrect */
+/* Adding dirhash hint to filesystem */
 #define PR_0_DIRHASH_HINT			0x000034
 
-/* Group descriptor N checksum is invalid */
+/* group descriptor N checksum is invalid, should be yyyy. */
 #define PR_0_GDT_CSUM				0x000035
 
 /* Group descriptor N marked uninitialized without feature set. */
@@ -214,7 +215,7 @@ struct problem_context {
 /* Last group block bitmap is uninitialized. */
 #define PR_0_BB_UNINIT_LAST			0x000039
 
-/* Journal transaction found corrupt */
+/* Journal transaction was corrupt, replay was aborted */
 #define PR_0_JNL_TXN_CORRUPT			0x00003A
 
 /* The test_fs filesystem flag is set and ext4 is available */
@@ -226,16 +227,16 @@ struct problem_context {
 /* Last write time is in the future (fudged) */
 #define PR_0_FUTURE_SB_LAST_WRITE_FUDGED	0x00003D
 
-/* Block group checksum (latch question) */
+/* One or more block group descriptor checksums are invalid (latch) */
 #define PR_0_GDT_CSUM_LATCH			0x00003E
 
-/* Free inodes count wrong */
+/* Setting free inodes count to right (was wrong) */
 #define PR_0_FREE_INODE_COUNT			0x00003F
 
-/* Free blocks count wrong */
+/* Setting free blocks count to right (was wrong) */
 #define PR_0_FREE_BLOCK_COUNT			0x000040
 
-/* Make quota file hidden */
+/* Making quota inode hidden */
 #define	PR_0_HIDE_QUOTA				0x000041
 
 /* Superblock has invalid MMP block. */
@@ -250,22 +251,20 @@ struct problem_context {
 /* Checking group descriptor failed */
 #define PR_0_CHECK_DESC_FAILED			0x000045
 
-/*
- * metadata_csum supersedes uninit_bg; both feature bits cannot be set
- * simultaneously.
- */
+/* Superblock metadata_csum supersedes uninit_bg; both feature
+ * bits cannot be set simultaneously. */
 #define PR_0_META_AND_GDT_CSUM_SET		0x000046
 
-/* Superblock has invalid MMP checksum. */
+/* Superblock MMP block checksum does not match MMP block. */
 #define PR_0_MMP_CSUM_INVALID			0x000047
 
-/* 64bit is set but extents are not set. */
+/* Superblock 64bit filesystem needs extents to access the whole disk */
 #define PR_0_64BIT_WITHOUT_EXTENTS		0x000048
 
 /* The first_meta_bg is too big */
 #define PR_0_FIRST_META_BG_TOO_BIG		0x000049
 
-/* External journal has corrupt superblock */
+/* External journal superblock checksum does not match superblock */
 #define PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID	0x00004A
 
 /* metadata_csum_seed means nothing without metadata_csum */
@@ -274,10 +273,10 @@ struct problem_context {
 /* Error initializing quota context */
 #define PR_0_QUOTA_INIT_CTX			0x00004C
 
-/* Bad s_min_extra_isize in superblock */
+/* Bad required extra isize in superblock */
 #define PR_0_BAD_MIN_EXTRA_ISIZE		0x00004D
 
-/* Bad s_want_extra_isize in superblock */
+/* Bad desired extra isize in superblock */
 #define PR_0_BAD_WANT_EXTRA_ISIZE		0x00004E
 
 
@@ -286,385 +285,391 @@ struct problem_context {
  */
 
 /* Pass 1: Checking inodes, blocks, and sizes */
-#define PR_1_PASS_HEADER		0x010000
+#define PR_1_PASS_HEADER			0x010000
 
-/* Root directory is not an inode */
-#define PR_1_ROOT_NO_DIR		0x010001
+/* Root inode is not a directory */
+#define PR_1_ROOT_NO_DIR			0x010001
 
-/* Root directory has dtime set */
-#define PR_1_ROOT_DTIME			0x010002
+/* Root inode has dtime set */
+#define PR_1_ROOT_DTIME				0x010002
 
 /* Reserved inode has bad mode */
-#define PR_1_RESERVED_BAD_MODE		0x010003
+#define PR_1_RESERVED_BAD_MODE			0x010003
 
-/* Deleted inode has zero dtime */
-#define PR_1_ZERO_DTIME			0x010004
+/* Deleted inode inum has zero dtime */
+#define PR_1_ZERO_DTIME				0x010004
 
-/* Inode in use, but dtime set */
-#define PR_1_SET_DTIME			0x010005
+/* Inode inum is in use, but has dtime set */
+#define PR_1_SET_DTIME				0x010005
 
-/* Zero-length directory */
-#define PR_1_ZERO_LENGTH_DIR		0x010006
+/* Inode inum is a zero-length directory */
+#define PR_1_ZERO_LENGTH_DIR			0x010006
 
-/* Block bitmap conflicts with some other fs block */
-#define PR_1_BB_CONFLICT		0x010007
+/* Group block bitmap at block conflicts with some other fs block */
+#define PR_1_BB_CONFLICT			0x010007
 
-/* Inode bitmap conflicts with some other fs block */
-#define PR_1_IB_CONFLICT		0x010008
+/* Group inode bitmap at block conflicts with some other fs block */
+#define PR_1_IB_CONFLICT			0x010008
 
-/* Inode table conflicts with some other fs block */
-#define PR_1_ITABLE_CONFLICT		0x010009
+/* Group inode table at block conflicts with some other fs block */
+#define PR_1_ITABLE_CONFLICT			0x010009
 
-/* Block bitmap is on a bad block */
-#define PR_1_BB_BAD_BLOCK		0x01000A
+/* Group block bitmap (block) is bad */
+#define PR_1_BB_BAD_BLOCK			0x01000A
 
-/* Inode bitmap is on a bad block */
-#define PR_1_IB_BAD_BLOCK		0x01000B
+/* Group inode bitmap (block) is bad */
+#define PR_1_IB_BAD_BLOCK			0x01000B
 
-/* Inode has incorrect i_size */
-#define PR_1_BAD_I_SIZE			0x01000C
+/* Inode i_size is small, should be larger */
+#define PR_1_BAD_I_SIZE				0x01000C
 
-/* Inode has incorrect i_blocks */
-#define PR_1_BAD_I_BLOCKS		0x01000D
+/* Inode i_blocks is small, should be larger */
+#define PR_1_BAD_I_BLOCKS			0x01000D
 
 /* Illegal block number in inode */
-#define PR_1_ILLEGAL_BLOCK_NUM		0x01000E
+#define PR_1_ILLEGAL_BLOCK_NUM			0x01000E
 
-/* Block number overlaps fs metadata */
-#define PR_1_BLOCK_OVERLAPS_METADATA	0x01000F
+/* Block number overlaps filesystem metadata in inode */
+#define PR_1_BLOCK_OVERLAPS_METADATA		0x01000F
 
 /* Inode has illegal blocks (latch question) */
-#define PR_1_INODE_BLOCK_LATCH		0x010010
+#define PR_1_INODE_BLOCK_LATCH			0x010010
 
-/* Too many bad blocks in inode */
-#define	PR_1_TOO_MANY_BAD_BLOCKS	0x010011
+/* Too many illegal blocks in inode */
+#define	PR_1_TOO_MANY_BAD_BLOCKS		0x010011
 
 /* Illegal block number in bad block inode */
-#define PR_1_BB_ILLEGAL_BLOCK_NUM	0x010012
+#define PR_1_BB_ILLEGAL_BLOCK_NUM		0x010012
 
 /* Bad block inode has illegal blocks (latch question) */
-#define PR_1_INODE_BBLOCK_LATCH		0x010013
+#define PR_1_INODE_BBLOCK_LATCH			0x010013
 
 /* Duplicate or bad blocks in use! */
-#define PR_1_DUP_BLOCKS_PREENSTOP	0x010014
+#define PR_1_DUP_BLOCKS_PREENSTOP		0x010014
 
-/* Bad block used as bad block indirect block */
-#define PR_1_BBINODE_BAD_METABLOCK	0x010015
+/* Bad block number used as bad block inode indirect block */
+#define PR_1_BBINODE_BAD_METABLOCK		0x010015
 
 /* Inconsistency can't be fixed prompt */
-#define PR_1_BBINODE_BAD_METABLOCK_PROMPT 0x010016
+#define PR_1_BBINODE_BAD_METABLOCK_PROMPT	0x010016
 
 /* Bad primary block */
-#define PR_1_BAD_PRIMARY_BLOCK		0x010017
+#define PR_1_BAD_PRIMARY_BLOCK			0x010017
 
 /* Bad primary block prompt */
-#define PR_1_BAD_PRIMARY_BLOCK_PROMPT	0x010018
+#define PR_1_BAD_PRIMARY_BLOCK_PROMPT		0x010018
 
-/* Bad primary superblock */
-#define PR_1_BAD_PRIMARY_SUPERBLOCK	0x010019
+/* The primary superblock block is on the bad block list */
+#define PR_1_BAD_PRIMARY_SUPERBLOCK		0x010019
 
 /* Bad primary block group descriptors */
-#define PR_1_BAD_PRIMARY_GROUP_DESCRIPTOR 0x01001A
+#define PR_1_BAD_PRIMARY_GROUP_DESCRIPTOR	0x01001A
 
-/* Bad superblock in group */
-#define PR_1_BAD_SUPERBLOCK		0x01001B
+/* Warning: Group number's superblock (block) is bad */
+#define PR_1_BAD_SUPERBLOCK			0x01001B
 
-/* Bad block group descriptors in group */
-#define PR_1_BAD_GROUP_DESCRIPTORS	0x01001C
+/* Warning: Group number's copy of the group descriptors has a bad block */
+#define PR_1_BAD_GROUP_DESCRIPTORS		0x01001C
 
-/* Block claimed for no reason */
-#define PR_1_PROGERR_CLAIMED_BLOCK	0x01001D
+/* Block number claimed for no reason in process_bad_blocks */
+#define PR_1_PROGERR_CLAIMED_BLOCK		0x01001D
 
-/* Error allocating blocks for relocating metadata */
-#define PR_1_RELOC_BLOCK_ALLOCATE	0x01001E
+/* Allocating number contiguous block(s) in block group number */
+#define PR_1_RELOC_BLOCK_ALLOCATE		0x01001E
 
-/* Error allocating block buffer during relocation process */
-#define PR_1_RELOC_MEMORY_ALLOCATE	0x01001F
+/* Allocating block buffer for relocating process */
+#define PR_1_RELOC_MEMORY_ALLOCATE		0x01001F
 
-/* Relocating metadata group information from X to Y */
-#define PR_1_RELOC_FROM_TO		0x010020
+/* Relocating group number's information from X to Y */
+#define PR_1_RELOC_FROM_TO			0x010020
 
-/* Relocating metatdata group information to X */
-#define PR_1_RELOC_TO			0x010021
+/* Relocating group number's information to X */
+#define PR_1_RELOC_TO				0x010021
 
-/* Block read error during relocation process */
-#define PR_1_RELOC_READ_ERR		0x010022
+/* Warning: could not read block number of relocation process */
+#define PR_1_RELOC_READ_ERR			0x010022
 
-/* Block write error during relocation process */
-#define PR_1_RELOC_WRITE_ERR		0x010023
+/* Warning: could not write block number of relocation process */
+#define PR_1_RELOC_WRITE_ERR			0x010023
 
 /* Error allocating inode bitmap */
-#define PR_1_ALLOCATE_IBITMAP_ERROR	0x010024
+#define PR_1_ALLOCATE_IBITMAP_ERROR		0x010024
 
 /* Error allocating block bitmap */
-#define PR_1_ALLOCATE_BBITMAP_ERROR	0x010025
+#define PR_1_ALLOCATE_BBITMAP_ERROR		0x010025
 
-/* Error allocating icount structure */
-#define PR_1_ALLOCATE_ICOUNT		0x010026
+/* Error allocating icount link information */
+#define PR_1_ALLOCATE_ICOUNT			0x010026
 
-/* Error allocating dbcount */
-#define PR_1_ALLOCATE_DBCOUNT		0x010027
+/* Error allocating directory block array */
+#define PR_1_ALLOCATE_DBCOUNT			0x010027
 
 /* Error while scanning inodes */
-#define PR_1_ISCAN_ERROR		0x010028
+#define PR_1_ISCAN_ERROR			0x010028
 
-/* Error while iterating over blocks */
-#define PR_1_BLOCK_ITERATE		0x010029
+/* Error while iterating over blocks in inode */
+#define PR_1_BLOCK_ITERATE			0x010029
 
-/* Error while storing inode count information */
-#define PR_1_ICOUNT_STORE		0x01002A
+/* Error storing inode count information */
+#define PR_1_ICOUNT_STORE			0x01002A
 
-/* Error while storing directory block information */
-#define PR_1_ADD_DBLOCK			0x01002B
+/* Error storing directory block information */
+#define PR_1_ADD_DBLOCK				0x01002B
 
-/* Error while reading inode (for clearing) */
-#define PR_1_READ_INODE			0x01002C
+/* Error reading inode (for clearing) */
+#define PR_1_READ_INODE				0x01002C
 
 /* Suppress messages prompt */
-#define PR_1_SUPPRESS_MESSAGES		0x01002D
+#define PR_1_SUPPRESS_MESSAGES			0x01002D
 
-/* Imagic flag set on an inode when filesystem doesn't support it */
-#define PR_1_SET_IMAGIC			0x01002F
+/* Imagic number has imagic flag set when fs doesn't support it */
+#define PR_1_SET_IMAGIC				0x01002F
 
 /* Immutable flag set on a device or socket inode */
-#define PR_1_SET_IMMUTABLE		0x010030
+#define PR_1_SET_IMMUTABLE			0x010030
 
 /* Compression flag set on a non-compressed filesystem -- no longer used*/
 /* #define PR_1_COMPR_SET			0x010031 */
 
 /* Non-zero size on on device, fifo or socket inode */
-#define PR_1_SET_NONZSIZE		0x010032
+#define PR_1_SET_NONZSIZE			0x010032
 
-/* Filesystem revision is 0, but feature flags are set */
-#define PR_1_FS_REV_LEVEL		0x010033
+/* Filesystem has feature flag(s) set, but is a revision 0 filesystem */
+#define PR_1_FS_REV_LEVEL			0x010033
 
-/* Journal inode not in use, needs clearing */
-#define PR_1_JOURNAL_INODE_NOT_CLEAR	0x010034
+/* Journal inode is not in use, but contains data */
+#define PR_1_JOURNAL_INODE_NOT_CLEAR		0x010034
 
-/* Journal inode has wrong mode */
-#define PR_1_JOURNAL_BAD_MODE		0x010035
+/* Journal is not a regular file */
+#define PR_1_JOURNAL_BAD_MODE			0x010035
 
-/* Inode that was part of orphan linked list */
-#define PR_1_LOW_DTIME			0x010036
+/* Inode that was part of the orphan list */
+#define PR_1_LOW_DTIME				0x010036
 
-/* Latch question which asks how to deal with low dtime inodes */
-#define PR_1_ORPHAN_LIST_REFUGEES	0x010037
+/* Inodes that were part of a corrupted orphan linked list found
+ * (latch question) */
+#define PR_1_ORPHAN_LIST_REFUGEES		0x010037
 
 /* Error allocating refcount structure */
-#define PR_1_ALLOCATE_REFCOUNT		0x010038
+#define PR_1_ALLOCATE_REFCOUNT			0x010038
 
-/* Error reading Extended Attribute block */
-#define PR_1_READ_EA_BLOCK		0x010039
+/* Error reading extended attribute block */
+#define PR_1_READ_EA_BLOCK			0x010039
 
-/* Invalid Extended Attribute block */
-#define PR_1_BAD_EA_BLOCK		0x01003A
+/* Inode number has a bad extended attribute block */
+#define PR_1_BAD_EA_BLOCK			0x01003A
 
 /* Error reading Extended Attribute block while fixing refcount -- abort */
-#define PR_1_EXTATTR_READ_ABORT		0x01003B
+#define PR_1_EXTATTR_READ_ABORT			0x01003B
 
-/* Extended attribute reference count incorrect */
-#define PR_1_EXTATTR_REFCOUNT		0x01003C
+/* Extended attribute number has reference count incorrect, should be */
+#define PR_1_EXTATTR_REFCOUNT			0x01003C
 
 /* Error writing Extended Attribute block while fixing refcount */
-#define PR_1_EXTATTR_WRITE_ABORT	0x01003D
+#define PR_1_EXTATTR_WRITE_ABORT		0x01003D
 
-/* Multiple EA blocks not supported */
-#define PR_1_EA_MULTI_BLOCK		0x01003E
+/* Extended attribute block has h_blocks > 1 */
+#define PR_1_EA_MULTI_BLOCK			0x01003E
 
-/* Error allocating EA region allocation structure */
-#define PR_1_EA_ALLOC_REGION_ABORT	0x01003F
+/* Allocating extended attribute region allocation structure */
+#define PR_1_EA_ALLOC_REGION_ABORT		0x01003F
 
-/* Error EA allocation collision */
-#define PR_1_EA_ALLOC_COLLISION		0x010040
+/* Extended Attribute block number is corrupt (allocation collision) */
+#define PR_1_EA_ALLOC_COLLISION			0x010040
 
-/* Bad extended attribute name */
-#define PR_1_EA_BAD_NAME		0x010041
+/* Extended attribute block number is corrupt (invalid name) */
+#define PR_1_EA_BAD_NAME			0x010041
 
-/* Bad extended attribute value */
-#define PR_1_EA_BAD_VALUE		0x010042
+/* Extended attribute block number is corrupt (invalid value) */
+#define PR_1_EA_BAD_VALUE			0x010042
 
-/* Inode too big (latch question) */
-#define PR_1_INODE_TOOBIG		0x010043
+/* Inode number is too big (latch question) */
+#define PR_1_INODE_TOOBIG			0x010043
 
-/* Directory too big */
-#define PR_1_TOOBIG_DIR			0x010044
+/* Problem causes directory to be too big */
+#define PR_1_TOOBIG_DIR				0x010044
 
-/* Regular file too big */
-#define PR_1_TOOBIG_REG			0x010045
+/* Problem causes file to be too big */
+#define PR_1_TOOBIG_REG				0x010045
 
-/* Symlink too big */
-#define PR_1_TOOBIG_SYMLINK		0x010046
+/* Problem causes symlink to be too big */
+#define PR_1_TOOBIG_SYMLINK			0x010046
 
-/* INDEX_FL flag set on a non-HTREE filesystem */
-#define PR_1_HTREE_SET			0x010047
+/* Inode has INDEX_FL flag set on filesystem without htree support  */
+#define PR_1_HTREE_SET				0x010047
 
-/* INDEX_FL flag set on a non-directory */
-#define PR_1_HTREE_NODIR		0x010048
+/* Inode number has INDEX_FL flag set but is on a directory */
+#define PR_1_HTREE_NODIR			0x010048
 
-/* Invalid root node in HTREE directory */
-#define PR_1_HTREE_BADROOT		0x010049
+/* htree directory has an invalid root node */
+#define PR_1_HTREE_BADROOT			0x010049
 
-/* Unsupported hash version in HTREE directory */
-#define PR_1_HTREE_HASHV		0x01004A
+/* Htree directory has an unsupported hash version */
+#define PR_1_HTREE_HASHV			0x01004A
 
-/* Incompatible flag in HTREE root node */
-#define PR_1_HTREE_INCOMPAT		0x01004B
+/* Htree directory uses an Incompatible htree root node flag */
+#define PR_1_HTREE_INCOMPAT			0x01004B
 
-/* HTREE too deep */
-#define PR_1_HTREE_DEPTH		0x01004C
+/* Htree directory has a tree depth which is too big */
+#define PR_1_HTREE_DEPTH			0x01004C
 
-/* Bad block has indirect block that conflicts with filesystem block */
-#define PR_1_BB_FS_BLOCK		0x01004D
+/* Bad block inode has an indirect block number that conflicts with
+ * filesystem metadata */
+#define PR_1_BB_FS_BLOCK			0x01004D
 
-/* Resize inode failed */
-#define PR_1_RESIZE_INODE_CREATE	0x01004E
+/* Resize inode (re)creation failed */
+#define PR_1_RESIZE_INODE_CREATE		0x01004E
 
-/* inode->i_size is too long */
-#define PR_1_EXTRA_ISIZE		0x01004F
+/* inode has a extra size i_extra_isize which is invalid */
+#define PR_1_EXTRA_ISIZE			0x01004F
 
-/* attribute name is too long */
-#define PR_1_ATTR_NAME_LEN		0x010050
+/* Extended attribute in inode has a namelen which is invalid */
+#define PR_1_ATTR_NAME_LEN			0x010050
 
-/* wrong EA value offset */
-#define PR_1_ATTR_VALUE_OFFSET		0x010051
+/* Extended attribute in inode has a value offset which is invalid */
+#define PR_1_ATTR_VALUE_OFFSET			0x010051
 
-/* wrong EA blocknumber */
-#define PR_1_ATTR_VALUE_BLOCK		0x010052
+/* extended attribute in inode has a value block which is invalid */
+#define PR_1_ATTR_VALUE_BLOCK			0x010052
 
-/* wrong EA value size */
-#define PR_1_ATTR_VALUE_SIZE		0x010053
+/* extended attribute in inode has a value size which is invalid */
+#define PR_1_ATTR_VALUE_SIZE			0x010053
 
-/* wrong EA hash value */
-#define PR_1_ATTR_HASH			0x010054
+/* extended attribute in inode has a hash which is invalid */
+#define PR_1_ATTR_HASH				0x010054
 
-/* inode appears to be a directory */
-#define PR_1_TREAT_AS_DIRECTORY		0x010055
+/* inode is a type but it looks like it is really a directory */
+#define PR_1_TREAT_AS_DIRECTORY			0x010055
 
-/* Error while reading extent tree */
-#define PR_1_READ_EXTENT		0x010056
+/* Error while reading extent tree in inode */
+#define PR_1_READ_EXTENT			0x010056
 
-/* Failure to iterate extents */
-#define PR_1_EXTENT_ITERATE_FAILURE	0x010057
+/* Failure to iterate extents in inode */
+#define PR_1_EXTENT_ITERATE_FAILURE		0x010057
 
-/* Bad starting block in extent */
-#define PR_1_EXTENT_BAD_START_BLK	0x010058
+/* Inode has an invalid extent starting block */
+#define PR_1_EXTENT_BAD_START_BLK		0x010058
 
-/* Extent ends beyond filesystem */
-#define PR_1_EXTENT_ENDS_BEYOND		0x010059
+/* Inode has an invalid extent that ends beyond filesystem */
+#define PR_1_EXTENT_ENDS_BEYOND			0x010059
 
-/* EXTENTS_FL flag set on a non-extents capable filesystem */
-#define PR_1_EXTENTS_SET		0x01005A
+/* inode has EXTENTS_FL flag set on filesystem without extents support */
+#define PR_1_EXTENTS_SET			0x01005A
 
+/* inode is in extents format, but superblock is missing EXTENTS feature */
 /* inode has extents, superblock missing INCOMPAT_EXTENTS feature */
-#define PR_1_EXTENT_FEATURE		0x01005B
+#define PR_1_EXTENT_FEATURE			0x01005B
 
 /* inode missing EXTENTS_FL, but is an extent inode */
-#define PR_1_UNSET_EXTENT_FL		0x01005C
+#define PR_1_UNSET_EXTENT_FL			0x01005C
 
 /* Fast symlink has EXTENTS_FL set */
-#define PR_1_FAST_SYMLINK_EXTENT_FL	0x01005D
+#define PR_1_FAST_SYMLINK_EXTENT_FL		0x01005D
 
 /* Extents are out of order */
-#define PR_1_OUT_OF_ORDER_EXTENTS	0x01005E
+#define PR_1_OUT_OF_ORDER_EXTENTS		0x01005E
 
 /* Extent node header invalid */
-#define PR_1_EXTENT_HEADER_INVALID	0x01005F
+#define PR_1_EXTENT_HEADER_INVALID		0x01005F
 
 /* PR_1_EOFBLOCKS_FL_SET 0x010060 was here */
 
-/* Failed to convert subcluster bitmap */
-#define PR_1_CONVERT_SUBCLUSTER		0x010061
+/* Failed to convert subcluster block bitmap */
+#define PR_1_CONVERT_SUBCLUSTER			0x010061
 
-/* Quota inode has wrong mode */
-#define PR_1_QUOTA_BAD_MODE		0x010062
+/* Quota inode is not a regular file */
+#define PR_1_QUOTA_BAD_MODE			0x010062
 
 /* Quota inode is not in use, but contains data */
-#define PR_1_QUOTA_INODE_NOT_CLEAR	0x010063
+#define PR_1_QUOTA_INODE_NOT_CLEAR		0x010063
 
-/* Quota inode is user visible */
-#define PR_1_QUOTA_INODE_NOT_HIDDEN	0x010064
+/* Quota inode is visible to the user */
+#define PR_1_QUOTA_INODE_NOT_HIDDEN		0x010064
 
-/* Invalid bad inode */
-#define PR_1_INVALID_BAD_INODE		0x010065
+/* The bad block inode looks invalid */
+#define PR_1_INVALID_BAD_INODE			0x010065
 
-/* Extent has zero length */
-#define PR_1_EXTENT_LENGTH_ZERO		0x010066
+/* Extent has zero length extent */
+#define PR_1_EXTENT_LENGTH_ZERO			0x010066
 
 /* inode seems to contain garbage */
-#define PR_1_INODE_IS_GARBAGE		0x010067
+#define PR_1_INODE_IS_GARBAGE			0x010067
 
 /* inode passes checks, but checksum does not match inode */
-#define PR_1_INODE_ONLY_CSUM_INVALID   0x010068
+#define PR_1_INODE_ONLY_CSUM_INVALID		0x010068
 
-/* Inode EA allocation collision */
-#define PR_1_INODE_EA_ALLOC_COLLISION	0x010069
+/* Inode extended attribute is corrupt (allocation collision) */
+#define PR_1_INODE_EA_ALLOC_COLLISION		0x010069
 
-/* extent block passes checks, but checksum does not match extent block */
-#define PR_1_EXTENT_ONLY_CSUM_INVALID  0x01006A
+/* Inode extent block passes checks, but checksum does not match extent */
+#define PR_1_EXTENT_ONLY_CSUM_INVALID		0x01006A
 
-/* ea block passes checks, but checksum invalid */
-#define PR_1_EA_BLOCK_ONLY_CSUM_INVALID        0x01006C
+/* Inode extended attribute block passes checks, but checksum does not
+ * match block. */
+#define PR_1_EA_BLOCK_ONLY_CSUM_INVALID		0x01006C
 
-/* Index start doesn't match start of next extent down */
-#define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
+/* Interior extent node level number of inode doesn't first node down */
+#define PR_1_EXTENT_INDEX_START_INVALID		0x01006D
 
-#define PR_1_EXTENT_END_OUT_OF_BOUNDS	0x01006E
+/* Inode end of extent exceeds allowed value */
+#define PR_1_EXTENT_END_OUT_OF_BOUNDS		0x01006E
 
-/* Inode has inline data, but superblock is missing INLINE_DATA feature. */
-#define PR_1_INLINE_DATA_FEATURE       0x01006F
+/* inode has INLINE_DATA_FL flag on filesystem without inline data */
+#define PR_1_INLINE_DATA_FEATURE		0x01006F
 
-/* INLINE_DATA feature is set in a non-inline-data filesystem */
-#define PR_1_INLINE_DATA_SET	       0x010070
+/* inode has INLINE_DATA_FL flag on filesystem without inline data */
+#define PR_1_INLINE_DATA_SET			0x010070
 
-/* file metadata collides with critical metadata */
+/* Inode block conflicts with critical metadata, skipping block checks */
 #define PR_1_CRITICAL_METADATA_COLLISION	0x010071
 
-/* Directory inode has a missing block (hole) */
-#define PR_1_COLLAPSE_DBLOCK		0x010072
+/* Directory inode block <block> should be at block <otherblock> */
+#define PR_1_COLLAPSE_DBLOCK			0x010072
 
-/* uninit directory block */
-#define PR_1_UNINIT_DBLOCK		0x010073
+/* Directory inode block <block> should be at block <otherblock> */
+#define PR_1_UNINIT_DBLOCK			0x010073
 
-/* Inode logical block is misaligned */
-#define PR_1_MISALIGNED_CLUSTER		0x010074
+/* Inode logical block (physical block) violates cluster allocation */
+#define PR_1_MISALIGNED_CLUSTER			0x010074
 
 /* Inode has INLINE_DATA_FL flag but extended attribute not found */
-#define PR_1_INLINE_DATA_NO_ATTR	0x010075
+#define PR_1_INLINE_DATA_NO_ATTR		0x010075
 
-/* extents/inlinedata set on fifo/socket/device */
-#define PR_1_SPECIAL_EXTENTS_IDATA	0x010076
+/* Special (device/socket/fifo) file (inode num) has extents
+ * or inline-data flag set */
+#define PR_1_SPECIAL_EXTENTS_IDATA		0x010076
 
-/* idata/extent flag set and extent header found, clear idata flag */
+/* Inode has extent header but inline data flag is set */
 #define PR_1_CLEAR_INLINE_DATA_FOR_EXTENT	0x010077
 
-/* inlinedata/extent set and no extent header found, clear extent flag */
+/* Inode seems to have inline data but extent flag is set */
 #define PR_1_CLEAR_EXTENT_FOR_INLINE_DATA	0x010078
 
-/* inlinedata/extent set, clear both flags */
+/* Inode seems to have block map but inline data and extent flags set */
 #define PR_1_CLEAR_EXTENT_INLINE_DATA_FLAGS	0x010079
 
-/* inlinedata/extent set, clear inode */
+/* Inode has inline data and extent flags but i_block contains junk */
 #define PR_1_CLEAR_EXTENT_INLINE_DATA_INODE	0x01007A
 
-/* badblocks is in badblocks */
+/* Bad block list says the bad block list inode is bad */
 #define PR_1_BADBLOCKS_IN_BADBLOCKS		0x01007B
 
-/* can't allocate extent region */
+/* Error allocating extent region allocation structure */
 #define PR_1_EXTENT_ALLOC_REGION_ABORT		0x01007C
 
-/* leaf extent collision */
+/* Inode leaf has a duplicate extent mapping */
 #define PR_1_EXTENT_COLLISION			0x01007D
 
 /* Error allocating memory for encrypted directory list */
 #define PR_1_ALLOCATE_ENCRYPTED_DIRLIST		0x01007E
 
-/* extent tree max depth too big */
+/* Inode extent tree could be more shallow */
 #define PR_1_EXTENT_BAD_MAX_DEPTH		0x01007F
 
-/* bigalloc fs cannot have blockmap files */
+/* inode num on bigalloc filesystem cannot be block mapped */
 #define PR_1_NO_BIGALLOC_BLOCKMAP_FILES		0x010080
 
-/* Missing extent header */
+/* Inode has corrupt extent header */
 #define PR_1_MISSING_EXTENT_HEADER		0x010081
 
 /* Timestamp(s) on inode beyond 2310-04-04 are likely pre-1970. */
-- 
1.8.0
