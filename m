From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] e2fsck: fix gcc -Wall nits
Date: Mon, 20 May 2013 09:59:02 -0400
Message-ID: <1369058343-1988-2-git-send-email-tytso@mit.edu>
References: <1369058343-1988-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49957 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab3ETN7E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 09:59:04 -0400
In-Reply-To: <1369058343-1988-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[For 1.43 branch]

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/journal.c  | 15 +++++++++------
 e2fsck/pass5.c    |  6 ------
 e2fsck/recovery.c |  4 ++--
 e2fsck/rehash.c   |  5 ++---
 4 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 2ca19b8..45d9462 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -41,7 +41,8 @@ static int bh_count = 0;
 #undef USE_INODE_IO
 
 /* Checksumming functions */
-int e2fsck_journal_verify_csum_type(journal_t *j, journal_superblock_t *jsb)
+static int e2fsck_journal_verify_csum_type(journal_t *j,
+					   journal_superblock_t *jsb)
 {
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
@@ -49,7 +50,7 @@ int e2fsck_journal_verify_csum_type(journal_t *j, journal_superblock_t *jsb)
 	return jsb->s_checksum_type == JBD2_CRC32C_CHKSUM;
 }
 
-static __u32 e2fsck_journal_sb_csum(journal_t *j, journal_superblock_t *jsb)
+static __u32 e2fsck_journal_sb_csum(journal_superblock_t *jsb)
 {
 	__u32 crc, old_crc;
 
@@ -62,7 +63,8 @@ static __u32 e2fsck_journal_sb_csum(journal_t *j, journal_superblock_t *jsb)
 	return crc;
 }
 
-int e2fsck_journal_sb_csum_verify(journal_t *j, journal_superblock_t *jsb)
+static int e2fsck_journal_sb_csum_verify(journal_t *j,
+					 journal_superblock_t *jsb)
 {
 	__u32 provided, calculated;
 
@@ -70,19 +72,20 @@ int e2fsck_journal_sb_csum_verify(journal_t *j, journal_superblock_t *jsb)
 		return 1;
 
 	provided = ext2fs_be32_to_cpu(jsb->s_checksum);
-	calculated = e2fsck_journal_sb_csum(j, jsb);
+	calculated = e2fsck_journal_sb_csum(jsb);
 
 	return provided == calculated;
 }
 
-errcode_t e2fsck_journal_sb_csum_set(journal_t *j, journal_superblock_t *jsb)
+static errcode_t e2fsck_journal_sb_csum_set(journal_t *j,
+					    journal_superblock_t *jsb)
 {
 	__u32 crc;
 
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 0;
 
-	crc = e2fsck_journal_sb_csum(j, jsb);
+	crc = e2fsck_journal_sb_csum(jsb);
 	jsb->s_checksum = ext2fs_cpu_to_be32(crc);
 	return 0;
 }
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 86b5225..51e4683 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -82,7 +82,6 @@ void e2fsck_pass5(e2fsck_t ctx)
 static void check_inode_bitmap_checksum(e2fsck_t ctx)
 {
 	struct problem_context	pctx;
-	struct ext4_group_desc	*gdp;
 	char		*buf;
 	dgrp_t		i;
 	int		nbytes;
@@ -112,8 +111,6 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 			continue;
 
 		ino_itr = 1 + (i * (nbytes << 3));
-		gdp = (struct ext4_group_desc *)ext2fs_group_desc(ctx->fs,
-				ctx->fs->group_desc, i);
 		retval = ext2fs_get_inode_bitmap_range2(ctx->fs->inode_map,
 							ino_itr, nbytes << 3,
 							buf);
@@ -141,7 +138,6 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 static void check_block_bitmap_checksum(e2fsck_t ctx)
 {
 	struct problem_context	pctx;
-	struct ext4_group_desc	*gdp;
 	char		*buf;
 	dgrp_t		i;
 	int		nbytes;
@@ -173,8 +169,6 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 		blk_itr = EXT2FS_B2C(ctx->fs,
 				     ctx->fs->super->s_first_data_block) +
 			  (i * (nbytes << 3));
-		gdp = (struct ext4_group_desc *)ext2fs_group_desc(ctx->fs,
-				ctx->fs->group_desc, i);
 		retval = ext2fs_get_block_bitmap_range2(ctx->fs->block_map,
 							blk_itr, nbytes << 3,
 							buf);
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 7712185..b04a204 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -183,7 +183,7 @@ static int jbd2_descr_block_csum_verify(journal_t *j,
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
 
-	tail = (struct journal_block_tail *)(buf + j->j_blocksize -
+	tail = (struct journal_block_tail *)((char *)buf + j->j_blocksize -
 			sizeof(struct journal_block_tail));
 	provided = tail->t_checksum;
 	tail->t_checksum = 0;
@@ -821,7 +821,7 @@ static int jbd2_revoke_block_csum_verify(journal_t *j,
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
 
-	tail = (struct journal_revoke_tail *)(buf + j->j_blocksize -
+	tail = (struct journal_revoke_tail *)((char *)buf + j->j_blocksize -
 			sizeof(struct journal_revoke_tail));
 	provided = tail->r_checksum;
 	tail->r_checksum = 0;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index df3afab..5592e3f 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -420,8 +420,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 
 static errcode_t copy_dir_entries(e2fsck_t ctx,
 				  struct fill_dir_struct *fd,
-				  struct out_dir *outdir,
-				  ext2_ino_t ino)
+				  struct out_dir *outdir)
 {
 	ext2_filsys 		fs = ctx->fs;
 	errcode_t		retval;
@@ -857,7 +856,7 @@ resort:
 	 * Copy the directory entries.  In a htree directory these
 	 * will become the leaf nodes.
 	 */
-	retval = copy_dir_entries(ctx, &fd, &outdir, ino);
+	retval = copy_dir_entries(ctx, &fd, &outdir);
 	if (retval)
 		goto errout;
 
-- 
1.7.12.rc0.22.gcdd159b

