Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456425;
	b=G69s4d5VoTImhdsFGlKNqB9Ms7c2MRmI15rhcxG4Qx59t862P9i2nMRFIEDtvcE7iZaw
	 DQWh5tq728+8iVUnlTBQpuVcE1F2yQNdLaJmQOX5yVTNCO/s1unMqliSlir0mtAQ9NmbE
	 uVpZsE5ffHUJXWLMRZ8bYnIjRd2sxeu4UATBdAr2ROGWL8XmPvduMzgiBdo5vy7EXatcZ
	 HbSRxt3twm0K8b5YXRL4NTE+SwLSJsq2PNpBXjDNtqAS1M+MTCm3K2kZN9Wtpr6Tem0Ba
	 wDq+bOqPbw8ZriPI3uCtfLKg2vItCqZLmB1j6ZfvVAsaYkwVhZZKbaSN6wtz/jmb3zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456425;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fDb1jt0GH6qJFrlu/ou8CKtlcf1ptsJOXON3asKYdkQ=;
	b=dSw1Igd8w1cP+6nNdqjrv5/ygj1/YCmi6nQCT6OAz7XGf9kmkn5JpxsEBgguGNo0WkBL
	 oLjHNLwj/V4tknjPWnay5gQrrNCBWjV/015DH55TdBTVkKQr9XxlZAvBUYQqEDqoj5I8Q
	 S9zUBnDZSC2hHtoPjL3yO86mlrxj6LPQU5x2UZyQx5qN+n4R++cRhUK7aVeJuDqfOkiG6
	 ro+QiWdIM9MZkvfpqyQ5Q+tYeaaJ+GoiB4O4xoSyldvXqF31gt2OB0JdWOUp8IM54p95I
	 h7a5igJX1fhdLB0SWj1e3J6xKT0XtUwwtcdENTOZQ4Xd0cv7TUAEdkEKFfTrWuDAN+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=odbf7VoA;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B6606A888
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C24B6606A888
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=odbf7VoA
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46sJ1016886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456416; bh=fDb1jt0GH6qJFrlu/ou8CKtlcf1ptsJOXON3asKYdkQ=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=odbf7VoAyvWcSmnDkTMh84+oPNlbdTeOMFXwV0IUUUjwvMn61QEPz7qruCwir6R6p
	 UmbCRszwt1NPqQWCf/gHD99T61cDwMwUTC89SyUJmAL9gu3J0xMNu/AY2oJSIUdvWl
	 sTrSEEnND8LjUroImBWr6ihV8tdADU4MKJ0DiqkWZJFjYIloBzobTB6pbM49am04Tj
	 2hMd5KBM94D8KexZdrdz/qAszj+Z5Ziey1gQTCwOTq+L9tHMSYsrYRl/LDuH8we+Cu
	 LWREfB8ea5JQVflz7LZOm0Ug97xFs3oWz9skp8TbIf5Xplf+jeivOadhKJiZn9CNeA
	 G0S33bSYokjYA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 731C72E0154; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 15/27] ext4: check multi-block overlap on left traversal in add_system_zone()
Date: Wed, 11 Nov 2026 23:06:26 -0500
Message-ID: <20261112040638.1576836-16-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112040638.1576836-1-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
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

When walking system_blks->root to insert [start_blk, start_blk + count),
add_system_zone() takes the left branch whenever start_blk <
entry->start_blk instead of checking that the entire range ends at or
before entry->start_blk (unlike ext4_sb_block_valid(), which checks
start_blk + count - 1 < entry->start_blk).

As a result, a corrupt multi-block metadata range (such as a group's
inode table or a reserved journal inode extent mapped in
ext4_protect_reserved_inode() before sbi->s_system_blks is published)
that starts strictly before an existing system zone and extends into or
across it traverses rb_left instead of returning -EFSCORRUPTED. This
inserts overlapping intervals into system_blks->root and breaks the
disjoint-interval invariant relied upon by ext4_sb_block_valid() (for
example, a lookup on blocks past entry->start_blk + entry->count
branches right and misses the overlapping zone stored in rb_left). A
corrupt 64-bit start_blk whose start_blk + count wraps around u64 can
similarly corrupt the rbtree ordering.

Reject zero-length or u64-wrapping ranges up front and require
start_blk + count <= entry->start_blk before taking rb_left in
add_system_zone(). Add KUnit regression tests in
fs/ext4/block_validity-test.c covering group metadata and journal
extents that partially overlap from the left, completely enclose an
existing system zone, or wrap 64-bit block numbers.

Fixes: bf9a379d0980 ("ext4: don't allow overlapping system zones")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/block_validity-test.c | 68 +++++++++++++++++++++++++++++++++++
 fs/ext4/block_validity.c      |  5 ++-
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/block_validity-test.c b/fs/ext4/block_validity-test.c
index 5d3dadba1328..5b50f56b3453 100644
--- a/fs/ext4/block_validity-test.c
+++ b/fs/ext4/block_validity-test.c
@@ -1111,6 +1111,27 @@ static const struct bv_corrupt_meta_case bv_corrupt_meta_cases[] = {
 		.ibitmap = 2050,
 		.itable = 2051,
 	},
+	{
+		.desc = "itable_starts_before_and_overlaps_bbitmap",
+		.grp = 0,
+		.bbitmap = 20,
+		.ibitmap = 40,
+		.itable = 15,
+	},
+	{
+		.desc = "itable_starts_before_and_encloses_ibitmap",
+		.grp = 2,
+		.bbitmap = 50,
+		.ibitmap = 55,
+		.itable = 52,
+	},
+	{
+		.desc = "itable_u64_wrap_around_overflow",
+		.grp = 2,
+		.bbitmap = 2049,
+		.ibitmap = 2050,
+		.itable = U64_MAX - 2ULL,
+	},
 };
 
 KUNIT_ARRAY_PARAM_DESC(bv_corrupt_meta, bv_corrupt_meta_cases, desc);
@@ -1314,6 +1335,52 @@ static void test_journal_inode_overlap_sets_fs_error(struct kunit *test)
 	KUNIT_EXPECT_NULL(test, rcu_access_pointer(ctx->sbi.s_system_blks));
 }
 
+static void test_journal_extent_left_overlap_rejected(struct kunit *test)
+{
+	struct bv_test_ctx *ctx = test->priv;
+	struct inode *j_inode;
+
+	/*
+	 * Place group 2's block bitmap at block 20 (ino = 0) and map a
+	 * multi-block journal extent at [18..21] that starts strictly before
+	 * block 20 and extends across it. During ext4_setup_system_zone(),
+	 * s_system_blks is still NULL when ext4_map_blocks() runs, so
+	 * add_system_zone() must catch this left-traversal overlap.
+	 */
+	bv_set_group_meta(ctx->sb, &ctx->gdps[2], 20ULL, 2050ULL, 2051ULL);
+	ext4_set_feature_journal(ctx->sb);
+	ctx->es.s_journal_inum = cpu_to_le32(EXT4_JOURNAL_INO);
+
+	j_inode = bv_create_inode(test, ctx, EXT4_JOURNAL_INO,
+				  S_IFREG | 0600, true);
+	i_size_write(j_inode, 4 * BV_TEST_BLK_SIZE);
+	bv_append_extent(test, j_inode, 0, 18ULL, 4);
+
+	KUNIT_EXPECT_EQ(test, ext4_setup_system_zone(ctx->sb), -EFSCORRUPTED);
+	KUNIT_EXPECT_TRUE(test,
+			  (bool)(ctx->sbi.s_mount_state & EXT4_ERROR_FS));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ctx->es.s_last_error_ino),
+			(u32)EXT4_JOURNAL_INO);
+	KUNIT_EXPECT_EQ(test, ctx->es.s_last_error_errcode,
+			EXT4_ERR_EFSCORRUPTED);
+	KUNIT_EXPECT_NULL(test, rcu_access_pointer(ctx->sbi.s_system_blks));
+
+	/*
+	 * Also verify a journal extent [1020..1040] that completely encloses
+	 * group 1's entire metadata zone [1025..1038].
+	 */
+	bv_clear_fs_error(ctx);
+	ext4_es_remove_extent(j_inode, 0, EXT_MAX_BLOCKS);
+	ext_inode_hdr(j_inode)->eh_entries = 0;
+	i_size_write(j_inode, 21 * BV_TEST_BLK_SIZE);
+	bv_append_extent(test, j_inode, 0, 1020ULL, 21);
+
+	KUNIT_EXPECT_EQ(test, ext4_setup_system_zone(ctx->sb), -EFSCORRUPTED);
+	KUNIT_EXPECT_TRUE(test,
+			  (bool)(ctx->sbi.s_mount_state & EXT4_ERROR_FS));
+	KUNIT_EXPECT_NULL(test, rcu_access_pointer(ctx->sbi.s_system_blks));
+}
+
 /* --- Test 10: ext4_check_blockref and Indirect Macros --- */
 
 static void test_check_blockref_valid_and_sparse(struct kunit *test)
@@ -1498,6 +1565,7 @@ static struct kunit_case ext4_block_validity_test_cases[] = {
 	KUNIT_CASE(test_journal_inode_iget_error),
 	KUNIT_CASE(test_journal_inode_map_blocks_error),
 	KUNIT_CASE(test_journal_inode_overlap_sets_fs_error),
+	KUNIT_CASE(test_journal_extent_left_overlap_rejected),
 	KUNIT_CASE(test_check_blockref_valid_and_sparse),
 	KUNIT_CASE(test_check_blockref_corrupt_entries_and_journal_bypass),
 	KUNIT_CASE(test_ind_check_inode_and_indirect_blockref),
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 53b042f36a69..34468932e461 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -75,10 +75,13 @@ static int add_system_zone(struct ext4_system_blocks *system_blks,
 	struct rb_node **n = &system_blks->root.rb_node, *node;
 	struct rb_node *parent = NULL, *new_node;
 
+	if (!count || (start_blk + count < start_blk))
+		return -EFSCORRUPTED;
+
 	while (*n) {
 		parent = *n;
 		entry = rb_entry(parent, struct ext4_system_zone, node);
-		if (start_blk < entry->start_blk)
+		if (start_blk + count <= entry->start_blk)
 			n = &(*n)->rb_left;
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = &(*n)->rb_right;
-- 
2.56.0.542.g3ef89b7020-goog

