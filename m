Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458844;
	b=ydGLIK5ZKMvWiTW3Ple2hlE9rjQGM2Ka9u8InxSrvzhEGj2ICUsjrv32zEdlj4t5cQab
	 zAMwavVb3hSxayTbJ7EMPjTOUgWBEuFNIhTri9vIxUNJkjR+tS3/6D4AFT+VjQEvLuvlp
	 VrZ4B8J4aaaea4SRtqtFRn/0m4Oqr2YAW6Jfj+3u8ki7u/dZXgL5jif3vVniLoNl7TRKE
	 wGiG+2zZ/TDCiHnFxshZYBe3VbFcwFSRBtlf+CuVnq/nOeOEqtjTl7cPqMFA9OWmpVtlv
	 pS7cfs7ojMT3rCu+9wN4OPvbYVZ/HJnXP8KlPVmZs8Ae9G7KS3vWi5r0KnVDTM26CEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458844;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e9dwBUw5Jl5ngY6ZdErI+y5D0zZ1DM5Vk61QTWHilmw=;
	b=tGuJ9+O+LqHKmvJF1gFB1jvsNft2N76Uz5ewiX21Nz0I6OasC1U/4NZpyNGL4AP+kBkw
	 nxAgXJhvwepxB0YllLnwmC006oEsP4pDmchmQKcW5c20pA2A+9QUj7lzQL901TtLnOVBf
	 bNnfTvl+G+X79C9OaOZ1Ds1217BPS+sjtgCj2WoHxqpT80UJROfGth4fKsyrFhVtChfQU
	 lDp3DSFeMWLlwEo/lH3fo+jr5+YJVmBrFaZ1ZAhrhzhREE8Gg5zufQmuzFNqwdKQqCkzI
	 iwr/VvWINHDiJrEJzxts8IAQyhxR/JMrKUDJek/RX8dlqC7HUJvDEJvzK+/BdnLZWzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=pYEEm1fa;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D49C60A260B
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D49C60A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=pYEEm1fa
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lKTN031192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=e9dwBUw5Jl5ngY6ZdErI+y5D0zZ1DM5Vk61QTWHilmw=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=pYEEm1faTdME/yh/mfKqdfxggs/YVG9UudY/C781fmoveiGYtadaUGnRVM4rhzztR
	 hHF5hgDGuTkjYiJhw2A4VnXDSVxNDTg+RQn72RNK/Wtw2yr7F32upp3NQjdtp07CeG
	 8xG/UrV6FjCd5jeRp8FlYkKWUYXaoM9AzQizrbbSfrThpgTsFK9tZL55pcH0FTtXYK
	 GfJojf/KyPTecMO3kng3bYa7j0D7UeMH+kgqzFVhbP+UlTFWbReIKD/MncxgdfLmzF
	 Kz3ta3DS5jujNx6K42rEWV4QSG26Fm8L6BJQG3B8QfBfxxblDb2MaOtYQMbIwMzC5P
	 YUWatwlNqGnXw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4328B2E0150; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 11/23] ext4: handle flex groups straddling s_first_meta_bg in online resize
Date: Wed, 11 Nov 2026 23:47:00 -0500
Message-ID: <20261112044712.1577296-12-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112044712.1577296-1-tytso@mit.edu>
References: <20261112044712.1577296-1-tytso@mit.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a file system without resize_inode is grown online past the last
GDT block, ext4_resize_fs() converts it to meta_bg and sets
s_first_meta_bg to the current number of GDT blocks.  Descriptor
blocks below s_first_meta_bg keep the traditional layout (backed up
right after each backup superblock in groups < s_first_meta_bg *
EXT4_DESC_PER_BLOCK), the later ones use the meta_bg layout.  The
online resize code does not handle this boundary correctly:

 - ext4_flex_group_add() decides meta_bg and padding_blocks once, from
   the first descriptor block touched by the flex group.  When a flex
   group straddles s_first_meta_bg (possible whenever the flex_bg size
   exceeds EXT4_DESC_PER_BLOCK, e.g. 1k blocks, 64bit and -G 32), the
   meta_bg descriptor blocks are passed to update_backups() as
   traditional ones, so their physical block number is used as an
   in-group offset.  This writes descriptor blocks over free or data
   blocks (and over backup superblocks) of unrelated groups, or past
   the end of the file system, while the real meta_bg backups are never
   written.

 - Even with the layout known per block, update_backups() copies a
   traditional GDT block into every sparse group below s_groups_count,
   including the newly added groups beyond s_first_meta_bg, which have
   no traditional GDT backup area.  This again overwrites blocks that
   are free (or meta_bg descriptor backups) in those groups.

 - setup_new_flex_group_blocks() skips copying the GDT blocks into a
   new backup group whenever the meta_bg feature is set.  Sparse groups
   added below s_first_meta_bg still have a traditional backup area of
   s_first_meta_bg blocks (reserved in the block bitmap), but only the
   last traditional GDT block gets written there later by
   update_backups(), leaving stale contents in the backup copies of all
   earlier GDT blocks.

Add ext4_gdb_is_meta_bg() and use it to decide the layout per
descriptor block in ext4_flex_group_add() and per group in
setup_new_flex_group_blocks(), and limit the backups of traditional GDT
blocks in update_backups() to the groups below s_first_meta_bg.

ext4_add_new_descs() does not need changing: a new descriptor block is
always number s_gdb_count, and s_first_meta_bg can never exceed it (it
is checked at mount time and set to the current GDT block count during
online conversion).

Fixes: 01f795f9e0d6 ("ext4: add online resizing support for meta_bg and 64-bit file systems")
Fixes: a6b3bfe176e8 ("ext4: fix corruption during on-line resize")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/resize-test.c | 80 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/resize.c      | 55 ++++++++++++++++++++++-------
 2 files changed, 122 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/resize-test.c b/fs/ext4/resize-test.c
index 081a5d6c6fd9..32de2876416b 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -1317,6 +1317,85 @@ static void test_resize_fs_across_resize_inode_to_meta_bg(struct kunit *test)
 			34U * RESIZE_TEST_INODES_PER_GRP);
 }
 
+static bool resize_blk_matches(struct resize_test_ctx *ctx, ext4_fsblk_t blk,
+			       struct buffer_head *src)
+{
+	struct buffer_head *bh = resize_lookup_bh(ctx, blk);
+
+	return bh && !memcmp(bh->b_data, src->b_data, src->b_size);
+}
+
+/*
+ * Test 9: ext4_resize_fs() on a file system without resize_inode, where a
+ * single 64-group flex batch (groups 20..63) straddles s_first_meta_bg (2).
+ * GDT blocks 0 and 1 use the traditional layout and must be backed up only
+ * into sparse groups below 32 (including new groups 25 and 27); GDT blocks
+ * 2 and 3 use the meta_bg layout and must be backed up into the second and
+ * last group of their meta group, without scribbling over other blocks.
+ */
+static void test_resize_fs_flex_group_straddles_first_meta_bg(struct kunit *test)
+{
+	struct resize_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	struct ext4_sb_info *sbi = &ctx->sbi;
+	struct ext4_super_block *backup_es;
+	struct buffer_head *gdb[4], *bh;
+	ext4_fsblk_t target_blks;
+	unsigned int i;
+
+	/* 20 groups: GDT block 0 full, GDT block 1 holds groups 16..19 */
+	resize_configure_fs(test, 20, 0, 6, RESIZE_TEST_BLOCKS_PER_GRP);
+	target_blks = RESIZE_TEST_FIRST_DATA_BLK +
+		      64ULL * RESIZE_TEST_BLOCKS_PER_GRP;
+
+	KUNIT_ASSERT_EQ(test, ext4_resize_fs(sb, target_blks), 0);
+	KUNIT_ASSERT_EQ(test, sbi->s_groups_count, 64U);
+	KUNIT_ASSERT_EQ(test, sbi->s_gdb_count, 4UL);
+	KUNIT_ASSERT_TRUE(test, ext4_has_feature_meta_bg(sb));
+	KUNIT_ASSERT_EQ(test, le32_to_cpu(ctx->es->s_first_meta_bg), 2U);
+
+	for (i = 0; i < ARRAY_SIZE(gdb); i++)
+		gdb[i] = sbi_array_rcu_deref(sbi, s_group_desc, i);
+
+	/* Traditional GDT backups in the new sparse groups 25 and 27 */
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 25) + 1, gdb[0]));
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 25) + 2, gdb[1]));
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 27) + 1, gdb[0]));
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 27) + 2, gdb[1]));
+
+	/* meta_bg descriptor backups in groups 33/47 and 49/63 */
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 33), gdb[2]));
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 47), gdb[2]));
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 49) + 1, gdb[3]));
+	KUNIT_EXPECT_TRUE(test, resize_blk_matches(ctx,
+			  ext4_group_first_block_no(sb, 63), gdb[3]));
+
+	/* Backup superblock in group 49 must not be overwritten */
+	bh = resize_lookup_bh(ctx, ext4_group_first_block_no(sb, 49));
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	backup_es = (struct ext4_super_block *)bh->b_data;
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(backup_es->s_magic),
+			EXT4_SUPER_MAGIC);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(backup_es->s_block_group_nr), 49U);
+
+	/*
+	 * Free blocks must not be written: the start of group 35 (meta_bg
+	 * GDT block 2 treated as a traditional offset) and the block after
+	 * group 49's meta_bg backup (traditional GDT block 1 copy).
+	 */
+	KUNIT_EXPECT_NULL(test, resize_lookup_bh(ctx,
+			  ext4_group_first_block_no(sb, 35)));
+	KUNIT_EXPECT_NULL(test, resize_lookup_bh(ctx,
+			  ext4_group_first_block_no(sb, 49) + 2));
+}
+
 static struct kunit_case ext4_resize_test_cases[] = {
 	KUNIT_CASE(test_resize_begin_and_end_guards),
 	KUNIT_CASE(test_list_backups_and_verify_reserved_gdb),
@@ -1326,6 +1405,7 @@ static struct kunit_case ext4_resize_test_cases[] = {
 	KUNIT_CASE(test_group_add_with_resize_inode_and_backup_gdb),
 	KUNIT_CASE(test_convert_meta_bg_validation_and_conversion),
 	KUNIT_CASE(test_resize_fs_across_resize_inode_to_meta_bg),
+	KUNIT_CASE(test_resize_fs_flex_group_straddles_first_meta_bg),
 	{}
 };
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index e873e09e609a..2ecd758be38e 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -127,6 +127,17 @@ static ext4_grpblk_t ext4_group_overhead_blocks(struct super_block *sb,
 	return overhead;
 }
 
+/*
+ * Return true if group descriptor block @gdb_num uses the meta_bg layout
+ * (stored in the first group of its meta block group) rather than the
+ * traditional layout (stored right after the superblock).
+ */
+static bool ext4_gdb_is_meta_bg(struct super_block *sb, unsigned long gdb_num)
+{
+	return ext4_has_feature_meta_bg(sb) &&
+	       gdb_num >= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
+}
+
 #define outside(b, first, last)	((b) < (first) || (b) >= (last))
 #define inside(b, first, last)	((b) >= (first) && (b) < (last))
 
@@ -539,13 +550,11 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 	ext4_group_t group, count;
 	struct buffer_head *bh = NULL;
 	int reserved_gdb, i, j, err = 0, err2;
-	int meta_bg;
 
 	BUG_ON(!flex_gd->count || !group_data ||
 	       group_data[0].group != sbi->s_groups_count);
 
 	reserved_gdb = le16_to_cpu(es->s_reserved_gdt_blocks);
-	meta_bg = ext4_has_feature_meta_bg(sb);
 
 	/* This transaction may be extended/restarted along the way */
 	handle = ext4_journal_start_sb(sb, EXT4_HT_RESIZE, EXT4_MAX_TRANS_DATA);
@@ -560,10 +569,14 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 		gdblocks = ext4_bg_num_gdb(sb, group);
 		start = ext4_group_first_block_no(sb, group);
 
-		if (meta_bg == 0 && !ext4_bg_has_super(sb, group))
-			goto handle_itb;
-
-		if (meta_bg == 1)
+		/*
+		 * Only groups covered by the traditional GDT layout carry
+		 * backups of the traditional GDT blocks; meta_bg descriptor
+		 * blocks are handled by add_new_gdb_meta_bg() and
+		 * update_backups().
+		 */
+		if (ext4_gdb_is_meta_bg(sb, group / EXT4_DESC_PER_BLOCK(sb)) ||
+		    !ext4_bg_has_super(sb, group))
 			goto handle_itb;
 
 		block = start + ext4_bg_has_super(sb, group);
@@ -1160,6 +1173,15 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 	if (meta_bg == 0) {
 		group = ext4_list_backups(sb, &three, &five, &seven);
 		last = sbi->s_groups_count;
+		/*
+		 * Superblock backups live in every backup group, but with
+		 * meta_bg only the groups below s_first_meta_bg hold copies
+		 * of the traditional GDT blocks.
+		 */
+		if (data != (char *)sbi->s_es && ext4_has_feature_meta_bg(sb))
+			last = min_t(ext4_group_t, last,
+				     le32_to_cpu(sbi->s_es->s_first_meta_bg) *
+				     EXT4_DESC_PER_BLOCK(sb));
 	} else {
 		group = ext4_get_group_number(sb, blk_off) + 1;
 		last = (ext4_group_t)(group + EXT4_DESC_PER_BLOCK(sb) - 2);
@@ -1208,12 +1230,15 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 			ext4_std_error(sb, err);
 		brelse(bh);
 
-		if (meta_bg == 0)
+		if (meta_bg == 0) {
 			group = ext4_list_backups(sb, &three, &five, &seven);
-		else if (group == last)
+			if (group >= last)
+				break;
+		} else if (group == last) {
 			break;
-		else
+		} else {
 			group = last;
+		}
 	}
 	if ((err2 = ext4_journal_stop(handle)) && !err)
 		err = err2;
@@ -1601,15 +1626,19 @@ static int ext4_flex_group_add(struct super_block *sb,
 		int gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
 		int gdb_num_end = ((group + flex_gd->count - 1) /
 				   EXT4_DESC_PER_BLOCK(sb));
-		int meta_bg = ext4_has_feature_meta_bg(sb) &&
-			      gdb_num >= le32_to_cpu(es->s_first_meta_bg);
-		sector_t padding_blocks = meta_bg ? 0 : sbi->s_sbh->b_blocknr -
-					 ext4_group_first_block_no(sb, 0);
 
 		update_backups(sb, ext4_group_first_block_no(sb, 0),
 			       (char *)es, sizeof(struct ext4_super_block), 0);
+		/*
+		 * A flex group may straddle s_first_meta_bg, so the layout
+		 * of each descriptor block has to be checked separately.
+		 */
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
+			int meta_bg = ext4_gdb_is_meta_bg(sb, gdb_num);
+			sector_t padding_blocks = meta_bg ? 0 :
+				sbi->s_sbh->b_blocknr -
+				ext4_group_first_block_no(sb, 0);
 
 			gdb_bh = sbi_array_rcu_deref(sbi, s_group_desc,
 						     gdb_num);
-- 
2.56.0.542.g3ef89b7020-goog

