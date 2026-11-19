Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115863;
	b=gMgifEPyOIiFV+BTBZ03Mw8PHRDN14FJBRuhMNbcgtCcrJ81oxSqI1A9qE0PzLU0p232
	 muGl9b8khNDRMcOkKubHwZpvwEdhdWvXkaGPSqnN8R8Oz2sKhSgy+oICQhGnuN4TUoZGJ
	 8o79LiH8AsU7m2yb0qZg8II+zP3+NFYou2mmeaJajqBRxsMdGvrTYf6oovO8H3MgrqSrP
	 SowvpsbylIQUU3TM7GSPKAN9UTHRbwTDJdllJi9yMopn8WugM8tGgYvEbxpuwkDfk6kkR
	 cKkpRljjTsWDEC5/C78QNfS9Kod/WiLYEuoftwgISB6nK88yolNHbfsdAWYvsP4+9IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7ctXQJrcqmMV6dL61I43iZ0xIczJG47qCc0/TfUQkiI=;
	b=iwDIAXB6+AeTCnwmhBQsq7ngqukXWxDvb2TiEcFRFdB1rlKwA+1Vvn80CGSF/Modm+34
	 CqPgyh+gvX3UpArcWGj4ZyagK/HgwQnaYB2U6mqfFiz6VcfhsihOimNu7YWsp2saMFHFn
	 BDsKmfo7dbH3KSX8Rxs93f6dQIj5vzIVdsGLfRlZuQRNrAmzsfKML+o3XHT2BF9/fFzCU
	 6eYCVNJ04D688YDFoN2MpikBpY96+O+JWRiwhE/NWIUZJFwvveYkK3NPDgAWxSk+cHHez
	 /uIQL9CcEAxqnI19gurmJ1R2V0sornhj2nY5fL9mVZlQK+b+GjJCvHlYLXtzMbnzDpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ompRmoaM;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3E3606A326
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC3E3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ompRmoaM
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYFA029961
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=7ctXQJrcqmMV6dL61I43iZ0xIczJG47qCc0/TfUQkiI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=ompRmoaMxlC1NEQt6dLupxgvFpzwu33nX5xrOIekC6TslhaIGpWlhwMgZnDJRzmEC
	 yOoB9D2t6a9tsZ/k9chag8QgV/PdtjaaQl3faAFTS3CspEkVCcQw2jokq97f6zIo+z
	 hXpfNlQZtfXV+KN/BOdsUy2JQCEjUsUx/9phkJbQUdAVCJmVVNk3v0dxieI+5mW8KE
	 v6J210oHXvfX6vW6EfkEha4r1Nt0Y6Luxw7f0N2M7Lmaz5MXVf+a6yY9YVMRbYmUhO
	 jUm2nSCfkeQa+hiBR9zP/y3hYfh+7VCbovY3+GhDwK3jVpnFoYAMItyAHLLiLRV7OL
	 z5OMXtlYq/9yg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 574652E015B; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 22/32] ext4: use loff_t for i_size in ext4_inline_data_truncate()
Date: Thu, 19 Nov 2026 14:17:09 -0500
Message-ID: <20261119191719.1943298-23-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119191719.1943298-1-tytso@mit.edu>
References: <20261119191719.1943298-1-tytso@mit.edu>
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

In ext4_inline_data_truncate(), the local variable i_size was declared
as size_t rather than loff_t.  On 32-bit architectures, assigning
inode->i_size to size_t silently truncates sizes >= 4 GiB (e.g., an
extending truncate of an inline file to (1LL << 32) + 8 wraps i_size to
8), which then corrupts EXT4_I(inode)->i_disksize, erroneously enters
the shrink branch (i_size < inline_size), drops delayed extents from the
extent status tree, and truncates away inline data.

Change i_size to loff_t and extend test_inline_data_truncate() in
ext4_inline_test to verify that an extending truncate to (1LL << 32) + 8
preserves i_disksize, delayed extents, and inline data.

Fixes: aef1c8513c1f ("ext4: let ext4_truncate handle inline data correctly")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inline-test.c | 63 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inline.c      |  2 +-
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index 451ebc61cbf6..2c57e1a79754 100644
--- a/fs/ext4/inline-test.c
+++ b/fs/ext4/inline-test.c
@@ -62,6 +62,7 @@ struct inline_test_ctx {
 	int dirty_metadata_calls;
 	int da_get_block_prep_err;
 	int journal_mode;
+	bool es_stats_inited;
 };
 
 static struct inline_test_ctx *t_ctx;
@@ -314,6 +315,24 @@ static int inline_test_init(struct kunit *test)
 	spin_lock_init(&ctx->sbi.s_bdev_wb_lock);
 	spin_lock_init(&ctx->sbi.s_error_lock);
 	spin_lock_init(&ctx->sbi.s_md_lock);
+	spin_lock_init(&ctx->sbi.s_es_lock);
+	INIT_LIST_HEAD(&ctx->sbi.s_es_list);
+	INIT_LIST_HEAD(&ctx->ei.i_orphan);
+	KUNIT_ASSERT_EQ(test,
+			percpu_counter_init(&ctx->sbi.s_dirtyclusters_counter,
+					    0, GFP_KERNEL), 0);
+	KUNIT_ASSERT_EQ(test,
+			percpu_counter_init(&ctx->sbi.s_es_stats.es_stats_cache_hits,
+					    0, GFP_KERNEL), 0);
+	KUNIT_ASSERT_EQ(test,
+			percpu_counter_init(&ctx->sbi.s_es_stats.es_stats_cache_misses,
+					    0, GFP_KERNEL), 0);
+	KUNIT_ASSERT_EQ(test,
+			percpu_counter_init(&ctx->sbi.s_es_stats.es_stats_all_cnt,
+					    0, GFP_KERNEL), 0);
+	KUNIT_ASSERT_EQ(test,
+			percpu_counter_init(&ctx->sbi.s_es_stats.es_stats_shk_cnt,
+					    0, GFP_KERNEL), 0);
 	ratelimit_state_init(&ctx->sbi.s_err_ratelimit_state,
 			     DEFAULT_RATELIMIT_INTERVAL, 0);
 	ratelimit_state_init(&ctx->sbi.s_warning_ratelimit_state,
@@ -380,6 +399,7 @@ static int inline_test_init(struct kunit *test)
 	INIT_LIST_HEAD(&ctx->ei.i_es_list);
 	ctx->ei.i_es_all_nr = 0;
 	ctx->ei.i_es_shk_nr = 0;
+	ctx->es_stats_inited = true;
 
 	reset_inode_state(ctx, S_IFREG | 0644);
 
@@ -414,7 +434,15 @@ static void inline_test_exit(struct kunit *test)
 	if (ctx) {
 		if (!list_empty(&ctx->ei.i_orphan))
 			list_del_init(&ctx->ei.i_orphan);
+		if (ctx->es_stats_inited)
+			ext4_es_remove_extent(&ctx->ei.vfs_inode, 0,
+					      EXT_MAX_BLOCKS);
 		truncate_inode_pages(&ctx->ei.vfs_inode.i_data, 0);
+		percpu_counter_destroy(&ctx->sbi.s_es_stats.es_stats_shk_cnt);
+		percpu_counter_destroy(&ctx->sbi.s_es_stats.es_stats_all_cnt);
+		percpu_counter_destroy(&ctx->sbi.s_es_stats.es_stats_cache_misses);
+		percpu_counter_destroy(&ctx->sbi.s_es_stats.es_stats_cache_hits);
+		percpu_counter_destroy(&ctx->sbi.s_dirtyclusters_counter);
 	}
 	t_ctx = NULL;
 }
@@ -1113,6 +1141,41 @@ static void test_inline_data_truncate(struct kunit *test)
 	ext4_inline_data_truncate(inode, &has_inline);
 	inode_unlock(inode);
 	KUNIT_EXPECT_TRUE(test, list_empty(&ctx->ei.i_orphan));
+
+	/*
+	 * 8. Extending i_size past 4 GiB ((1LL << 32) + 8) must not truncate
+	 * i_size via a 32-bit size_t local, corrupt i_disksize, wipe delayed
+	 * extents, or truncate inline data.
+	 */
+	{
+		struct extent_status es;
+
+		reset_inode_state(ctx, S_IFREG | 0644);
+		ret = create_inline_file(inode, buf, 100);
+		KUNIT_ASSERT_EQ(test, ret, 0);
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		ctx->ei.i_reserved_data_blocks = 1;
+		ext4_es_insert_delayed_extent(inode, 0, 1, false, false);
+		inode_lock(inode);
+		i_size_write(inode, (1LL << 32) + 8);
+		has_inline = 1;
+		ret = ext4_inline_data_truncate(inode, &has_inline);
+		inode_unlock(inode);
+		KUNIT_EXPECT_EQ(test, ret, 0);
+		KUNIT_EXPECT_EQ(test, has_inline, 1);
+		KUNIT_EXPECT_EQ(test, ctx->ei.i_disksize, (1LL << 32) + 8);
+		KUNIT_EXPECT_EQ(test, ctx->ei.i_inline_size, 100);
+		KUNIT_EXPECT_MEMEQ(test, raw_inline_i_block(ctx), buf,
+				   EXT4_MIN_INLINE_DATA_SIZE);
+		KUNIT_EXPECT_MEMEQ(test, raw_inline_xattr_pos(ctx),
+				   buf + EXT4_MIN_INLINE_DATA_SIZE,
+				   100 - EXT4_MIN_INLINE_DATA_SIZE);
+		KUNIT_EXPECT_TRUE(test,
+				  ext4_es_lookup_extent(inode, 0, NULL, &es,
+							NULL));
+		KUNIT_EXPECT_TRUE(test, ext4_es_is_delayed(&es));
+		ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	}
 }
 
 /* =========================================================================
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 5ac45258cc96..3e77f46f7774 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1893,7 +1893,7 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 {
 	handle_t *handle;
 	int inline_size, value_len, needed_blocks, no_expand, err = 0;
-	size_t i_size;
+	loff_t i_size;
 	void *value = NULL;
 	struct ext4_xattr_ibody_find is = {
 		.s = { .not_found = -ENODATA, },
-- 
2.56.1.708.g77570a6a1d-goog

