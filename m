Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458847;
	b=MYTOSG9lq2gzam8upeJ+QRttJCChRir+2YcCO/t7nWD2eDQUX1uJLcO5VEBSolffpXYX
	 Jy/DRibuuPqY8UXPrukCXwT4ss5hXVUBc65nFshEwy8W8a/vIfkmmu4m/jCu5Zwwf/vZD
	 q5+sET6/2g79XnQhyYpEhw9tHPozm9PIaz6+YCRo94GF7L6hCdRb4W4LJUGlsYZMNZHPM
	 YK2l2U4Z/MYdE7oPGmU7EgL9z46EGOugNnxulZy4LBp9Sk0BxfZcsUIqDuoHC9ikgDtkJ
	 iFv9/kTGMH9vv8NhH/M4nOwK25j3KJy/56HndgFTKedgvyUpro/3yf7nPW73Oh+9G3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458847;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TecECUWF8LFyki6NA+Jr56CZGkOKZivNOrQvLDPUdus=;
	b=i/TGQUUtRpot+/guLOjE+v+Av3Yn09KLDkgvRuPahfsc4ZiQXjaQEO3WOVZzryQMUNc/
	 nUjoUHoa0TWpa8Q0Ik52Zr6gBjGhsnyoFBURfWv4O2znUoe63gRlr3IhvcYPj4q5JkxmT
	 HyyB+uVNSZuFQk2j/FM60YnjXzTsoDBR2LRon55dEjT1weEAlY1v8zP6WXbgjE3PF1O4x
	 0jsA5FmhBTSYSTbRwX0g19NUNQzu/QGmIPEU8nA/3BueGAKKlJAA3IwpnJQXGymIPFgd4
	 dPvW12wJfdd89Pvil34HGiwMq83bfRhdwcbsYuAuOko7Ovtytw3L7YL7W1hNTGNyuGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cOmEsFYo;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCA7606A882
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DCA7606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cOmEsFYo
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lMZE031249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458843; bh=TecECUWF8LFyki6NA+Jr56CZGkOKZivNOrQvLDPUdus=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=cOmEsFYowG4krNN6y2H55b6VOnRQK8scgpjinnHH4RekiWi41ktJudFkUmnijKjOo
	 u2t+hEJmVdK15yO4+9gJmDaRNDzzQxc3Gu1D3dtpJ65slkV0jQY7KqqvpwyxJuv7bB
	 dVWZ/3TaoD7COXdU+tuabHFr3Swz4MvKpL1vCC/7IP9pQ+tZH05ry7RnejpwSBhztM
	 uA6FlYM2TqxKtNxPWXNpWiCbmDjba/mBEf4BHi6YonhKGsFg9hghoic/xxZ3WXr1hg
	 yyhwsJ0sSdSTlsou9KSvxBlxlH+yAb3lsXiE4qhThpenB6yZ5JRsptyz2f7F7WN4oG
	 srZrOa/mb6xPg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4FEE12E0154; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 15/23] ext4: cap migrated extents at EXT_INIT_MAX_LEN
Date: Wed, 11 Nov 2026 23:47:04 -0500
Message-ID: <20261112044712.1577296-16-tytso@mit.edu>
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

When converting an indirect-mapped inode to extents, ext4_ext_migrate()
coalesces physically and logically contiguous blocks in
update_extent_range() without any upper bound, and finish_range() then
stores the raw run length into the 16-bit ee_len field.

An initialized extent can be at most EXT_INIT_MAX_LEN (32768) blocks
long; larger ee_len values encode unwritten extents.  So if an indirect
file contains a contiguous run of more than 32768 blocks (128 MiB with
4 KiB blocks), the migrated extent is silently turned into an unwritten
extent of length (len - 32768): the file data reads back as zeroes, the
tail of the run becomes a hole, and 32768 blocks are leaked once the
file is truncated or unlinked.  A run of exactly 65536 blocks wraps
ee_len to zero, producing a corrupt extent.

Stop extending the current range once it reaches EXT_INIT_MAX_LEN, so
that long runs are split into several initialized extents.

Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/migrate-test.c | 91 ++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/migrate.c      |  6 ++-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/migrate-test.c b/fs/ext4/migrate-test.c
index e83d208a5117..7a7d6607b67f 100644
--- a/fs/ext4/migrate-test.c
+++ b/fs/ext4/migrate-test.c
@@ -1041,6 +1041,96 @@ static void test_ind_migrate_rejections(struct kunit *test)
 	iput(inode);
 }
 
+/*
+ * Test 8: ext4_ext_migrate() splits a physically and logically contiguous
+ * run longer than EXT_INIT_MAX_LEN into multiple initialized extents rather
+ * than encoding the raw length into ee_len, which would turn the extent
+ * into an unwritten one (or wrap ee_len) and lose the file data.
+ */
+static void test_ext_migrate_caps_long_run_at_init_max_len(struct kunit *test)
+{
+	struct migrate_test_ctx *ctx = test->priv;
+	const unsigned int per_blk = MIGRATE_TEST_BLK_SIZE / sizeof(__le32);
+	const unsigned int nr_ind = 128;
+	const ext4_fsblk_t data_pblk = 2000;
+	const ext4_fsblk_t ind_pblk = 600, dind_pblk = 700;
+	const ext4_lblk_t len = EXT4_NDIR_BLOCKS + per_blk + nr_ind * per_blk;
+	const int max_len = EXT_INIT_MAX_LEN;
+	struct ext4_extent_header *eh;
+	struct ext4_extent *ex;
+	struct buffer_head *bh;
+	struct inode *inode;
+	ext4_fsblk_t pblk = data_pblk;
+	unsigned int i, j;
+
+	/* 12 + 256 + 128 * 256 = 33036 blocks > EXT_INIT_MAX_LEN */
+	KUNIT_ASSERT_GT(test, len, (ext4_lblk_t)max_len);
+	ext4_blocks_count_set(ctx->es, data_pblk + len + 1024);
+
+	inode = migrate_make_test_inode(test, 22, S_IFREG | 0644);
+	i_size_write(inode, (loff_t)len * MIGRATE_TEST_BLK_SIZE);
+
+	for (i = 0; i < EXT4_NDIR_BLOCKS; i++)
+		EXT4_I(inode)->i_data[i] = cpu_to_le32(pblk++);
+
+	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] = cpu_to_le32(ind_pblk);
+	bh = migrate_get_or_create_bh(ctx, ind_pblk);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	for (j = 0; j < per_blk; j++)
+		((__le32 *)bh->b_data)[j] = cpu_to_le32(pblk++);
+	brelse(bh);
+
+	EXT4_I(inode)->i_data[EXT4_DIND_BLOCK] = cpu_to_le32(dind_pblk);
+	bh = migrate_get_or_create_bh(ctx, dind_pblk);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	for (i = 0; i < nr_ind; i++)
+		((__le32 *)bh->b_data)[i] = cpu_to_le32(dind_pblk + 1 + i);
+	brelse(bh);
+
+	for (i = 0; i < nr_ind; i++) {
+		bh = migrate_get_or_create_bh(ctx, dind_pblk + 1 + i);
+		KUNIT_ASSERT_NOT_NULL(test, bh);
+		for (j = 0; j < per_blk; j++)
+			((__le32 *)bh->b_data)[j] = cpu_to_le32(pblk++);
+		brelse(bh);
+	}
+	inode->i_blocks = (blkcnt_t)(len + 2 + nr_ind) *
+			  (MIGRATE_TEST_BLK_SIZE >> 9);
+
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), 0);
+	KUNIT_EXPECT_TRUE(test,
+			  ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	eh = ext_inode_hdr(inode);
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ||
+	    !eh->eh_entries)
+		goto out;
+
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_depth), 0U);
+	ex = EXT_FIRST_EXTENT(eh);
+
+	/* Extent 0: lblk [0..32767] -> data_pblk, initialized */
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 0U);
+	KUNIT_EXPECT_FALSE(test, ext4_ext_is_unwritten(&ex[0]));
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), max_len);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[0]), data_pblk);
+
+	/* Extent 1: remainder of the run, initialized */
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 2U);
+	if (le16_to_cpu(eh->eh_entries) < 2)
+		goto out;
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), (u32)max_len);
+	KUNIT_EXPECT_FALSE(test, ext4_ext_is_unwritten(&ex[1]));
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[1]),
+			(int)len - max_len);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[1]), data_pblk + max_len);
+
+	/* Indirect metadata blocks were released */
+	KUNIT_EXPECT_TRUE(test, migrate_was_freed(ctx, ind_pblk));
+	KUNIT_EXPECT_TRUE(test, migrate_was_freed(ctx, dind_pblk + 1));
+out:
+	iput(inode);
+}
+
 static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ext_migrate_precondition_checks_and_fast_symlink),
 	KUNIT_CASE(test_ext_migrate_direct_and_ind_coalescing_and_holes),
@@ -1049,6 +1139,7 @@ static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ext_swap_inode_data_detects_concurrent_allocation),
 	KUNIT_CASE(test_ind_migrate_empty_and_single_direct_extent),
 	KUNIT_CASE(test_ind_migrate_rejections),
+	KUNIT_CASE(test_ext_migrate_caps_long_run_at_init_max_len),
 	{}
 };
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 8d76042f0cae..e4c1603e1402 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -67,11 +67,13 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
 {
 	int retval;
 	/*
-	 * See if we can add on to the existing range (if it exists)
+	 * See if we can add on to the existing range (if it exists).
+	 * An initialized extent cannot be longer than EXT_INIT_MAX_LEN.
 	 */
 	if (lb->first_pblock &&
 		(lb->last_pblock+1 == pblock) &&
-		(lb->last_block+1 == lb->curr_block)) {
+		(lb->last_block+1 == lb->curr_block) &&
+		(lb->last_block - lb->first_block + 1 < EXT_INIT_MAX_LEN)) {
 		lb->last_pblock = pblock;
 		lb->last_block = lb->curr_block;
 		lb->curr_block++;
-- 
2.56.0.542.g3ef89b7020-goog

