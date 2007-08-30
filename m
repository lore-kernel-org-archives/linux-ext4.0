From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 2/8][e2fsprogs] convert block number definition to blk_t
Date: Thu, 30 Aug 2007 17:33:40 +0200
Message-ID: <1188488020.15770.41.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43722 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbXH3N0k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:40 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

This patch converts a few __u32 or unsigned int block number definitions to
blk_t type.  Conversions are necessary to prepare the 64-bit porting.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 debugfs/logdump.c    |   10 +++++-----
 e2fsck/pass5.c       |    4 ++--
 e2fsck/super.c       |    3 ++-
 lib/ext2fs/closefs.c |    4 ++--
 lib/ext2fs/ext2fs.h  |    2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 2bf67b5..773d84e 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -36,11 +36,11 @@ extern char *optarg;
 
 enum journal_location {JOURNAL_IS_INTERNAL, JOURNAL_IS_EXTERNAL};
 
-#define ANY_BLOCK ((unsigned int) -1)
+#define ANY_BLOCK ((blk_t) -1)
 
 int		dump_all, dump_contents, dump_descriptors;
-unsigned int	block_to_dump, group_to_dump, bitmap_to_dump;
-unsigned int	inode_block_to_dump, inode_offset_to_dump, bitmap_to_dump;
+blk_t		block_to_dump, bitmap_to_dump, inode_block_to_dump;
+unsigned int	group_to_dump, inode_offset_to_dump;
 ext2_ino_t	inode_to_dump;
 
 struct journal_source 
@@ -365,8 +365,8 @@ static void dump_journal(char *cmdname, FILE *out_file,
 		if (dump_all) {
 			fprintf(out_file, "\tuuid=%s\n", jsb_buffer);
 			fprintf(out_file, "\tblocksize=%d\n", blocksize);
-			fprintf(out_file, "\tjournal data size %ld\n",
-				(long) sb->s_blocks_count);
+			fprintf(out_file, "\tjournal data size %lu\n",
+				sb->s_blocks_count);
 		}
 	}
 	
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 53248b0..8e3794d 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -114,8 +114,8 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	blk_t	i, super;
 	int	*free_array;
 	int	group = 0;
-	unsigned int	blocks = 0;
-	unsigned int	free_blocks = 0;
+	blk_t	blocks = 0;
+	blk_t	free_blocks = 0;
 	int	group_free = 0;
 	int	actual, bitmap;
 	struct problem_context	pctx;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 00a131c..a91f37e 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -466,7 +466,8 @@ void check_super_block(e2fsck_t ctx)
 	dgrp_t	i;
 	blk_t	should_be;
 	struct problem_context	pctx;
-	__u32	free_blocks = 0, free_inodes = 0;
+	blk_t	free_blocks = 0;
+	ino_t	free_inodes = 0;
 
 	inodes_per_block = EXT2_INODES_PER_BLOCK(fs->super);
 	ipg_max = inodes_per_block * (blocks_per_group - 4);
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index f780e80..efbb727 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -54,8 +54,8 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 {
 	blk_t	group_block, super_blk = 0, old_desc_blk = 0, new_desc_blk = 0;
 	unsigned int meta_bg, meta_bg_size;
-	int	numblocks, has_super;
-	int	old_desc_blocks;
+	blk_t	numblocks, old_desc_blocks;
+	int	has_super;
 
 	group_block = ext2fs_group_first_block(fs, group);
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 20c63c0..3aa9c8f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -415,7 +415,7 @@ typedef struct ext2_icount *ext2_icount_t;
 /*
  * For ext2 compression support
  */
-#define EXT2FS_COMPRESSED_BLKADDR ((blk_t) 0xffffffff)
+#define EXT2FS_COMPRESSED_BLKADDR ((blk_t) -1)
 #define HOLE_BLKADDR(_b) ((_b) == 0 || (_b) == EXT2FS_COMPRESSED_BLKADDR)
 
 /*
