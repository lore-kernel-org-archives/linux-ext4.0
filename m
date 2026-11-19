Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103828;
	b=BaSxkbdxFWPqXHARXvYI26bCKTescxTq9ltCyBfz//QV80Im7Cp+xwkB75rSZauQN2m0
	 St+f2o6tfe5DrOwJ8YLC3vvWJkBxYH+xsprfh8YSHqLkzPtclNBNNkhlGqY/2Tmb6HM8q
	 xhcQsGFsDLxO+EiqHynsQOKnWdTvr+3yBay0GwNi/e/3BhJk2VEhprb7F1ZqcyANvCrJN
	 e0LF+1vvuq+mf7fF7xmXia6jz3aNEmH8Fzentb8FlxQMStMS8ufzWUU9P/vxMuMtBvkmB
	 Kl8/SKBQ3k6IxFnvc0a6Ff8uVLsAF5bsQJU41/WCa7P8dB0Yesr9a/B/GDsotPPmF2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103828;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zYzZFTbAz7qdQuZ1q7nK2p5HzHEpHt31uE/UUpaWkMQ=;
	b=jyjLKk6baqDY8hVUBiqmy5ykitfjBW7UiSp3HY/IXIIiwHRFMHgPq7yWiX6Pzr4pEoAK
	 fvHvlOnZkzJY38XpvVGksswTx3AXnY/j0fouFAC3cHRfc0I5RBKnRqvlPKR33FFTVXH1b
	 vfQXGlWWyJNVC61rmiNePchobf9V791YnDRGHAM6VZAk50UITJ6fP0VcYZjj4NKybyV8e
	 PoqK3DnHT6Z9cj2ghrTyf40wXBFY6TBqfW1fosfAEgF2msdoytjuuEThubEtMFscK9VFi
	 Z0ku3j9mtWDjYgBgy4GJJQO0QWa49jO7WB/ExY+yWNHuanHn0uchhFJs9K2QgOh+jiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=qJVEy4Kk;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1085D60A2619
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 15:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1085D60A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=qJVEy4Kk
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJFv3Me001679
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 10:57:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795103824; bh=zYzZFTbAz7qdQuZ1q7nK2p5HzHEpHt31uE/UUpaWkMQ=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=qJVEy4KkN3mFED72kSoNa42P2BERVFgN5NNu8H7t3JsdrPSn9B93M7ltRv8MLgDVz
	 e5eb8DSqNs2a7xmJaieTBTofprw+9NCqGik5vDsurFaZ0pDpXCbHxx/SbKYc5TGTvN
	 l7RJu0Lu8GH3pg5twgAn5qEAdj/qu4DExL6IsunlB3+rSg25qqwWga69k6X4N94pan
	 CQ/3c+6WAxbpFArjjO/E0akYq9jca3nU3ehXqKeAXVkjt4iYkbPNmVHK2lTq7ZKagb
	 o3ALoEowiLETkvzuMTT7HVDBMoJ0Aj9KXrBwB53t4twBDgE9imAFabxwL8QcuCTxs8
	 weVQEoFsxs2IA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 9EADD2E015F; Thu, 19 Nov 2026 10:57:00 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 26/26] ext4: add KUnit regression tests for inode migration fixes
Date: Thu, 19 Nov 2026 10:56:58 -0500
Message-ID: <20261119155658.1940864-27-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119155658.1940864-1-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
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

Add KUnit regression tests in fs/ext4/migrate-test.c covering the
ext4_ext_migrate() bug fixes in the tree:

- test_ext_migrate_caps_long_run_at_init_max_len(): verify that a
  contiguous run longer than EXT_INIT_MAX_LEN is split into multiple
  initialized extents, covering commit b0a3f2c102e8 ("ext4: cap
  migration extent length at EXT_INIT_MAX_LEN").
- test_ext_migrate_survives_handle_restart(): verify that a handle
  restart during extent insertion does not abort migration, covering
  commit 3b6aee59883c ("ext4: clear journal restart indication after
  inserting extent").
- test_ext_migrate_reports_concurrent_allocation() and an -EIO check in
  test_ext_migrate_error_rollback_frees_tmp_extent_blocks(): verify that
  migration errors are returned to the caller instead of being
  overwritten, covering commit 82e2a5743b6a ("ext4: don't clobber the
  migration error in ext4_ext_migrate()").
- test_ext_migrate_credit_or_dirty_failure_keeps_live_blocks(): verify
  that post-swap ext4_journal_ensure_credits() or ext4_mark_inode_dirty()
  failures leave tmp_inode empty on eviction and do not free the
  migrated inode's extent blocks, covering commit 047061e6a6da ("ext4:
  don't free the tmp_inode tree after a partial migration swap"),
  commit ed8c07b7692c ("ext4: drop tmp inode ownership before migration
  cleanup"), and commit 7c1f0eea4a9b ("ext4: fix failed migrate freeing
  extent tree blocks").

Add KUNIT_STATIC_STUB_REDIRECT() hooks and EXPORT_SYMBOL_FOR_EXT4_TEST()
exports for ext4_datasem_ensure_credits() in fs/ext4/extents.c and
__ext4_journal_ensure_credits() in fs/ext4/ext4_jbd2.c so the KUnit
tests can emulate transaction restarts, concurrent block allocations,
and post-swap credit failures without a journal.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4_jbd2.c    |   4 +
 fs/ext4/extents.c      |   4 +
 fs/ext4/migrate-test.c | 329 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 334 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 3e6c9ce108ad..23e53c9cc0ce 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -186,6 +186,9 @@ handle_t *__ext4_journal_start_reserved(handle_t *handle, unsigned int line,
 int __ext4_journal_ensure_credits(handle_t *handle, int check_cred,
 				  int extend_cred, int revoke_cred)
 {
+	KUNIT_STATIC_STUB_REDIRECT(__ext4_journal_ensure_credits, handle,
+				   check_cred, extend_cred, revoke_cred);
+
 	if (!ext4_handle_valid(handle))
 		return 0;
 	if (is_handle_aborted(handle))
@@ -197,6 +200,7 @@ int __ext4_journal_ensure_credits(handle_t *handle, int check_cred,
 	revoke_cred = max(0, revoke_cred - handle->h_revoke_credits);
 	return ext4_journal_extend(handle, extend_cred, revoke_cred);
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(__ext4_journal_ensure_credits);
 
 static void ext4_journal_abort_handle(const char *caller, unsigned int line,
 				      const char *err_fn,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cbe187914fe2..10d36012ade4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -142,12 +142,16 @@ int ext4_datasem_ensure_credits(handle_t *handle, struct inode *inode,
 	int ret;
 	int dropped = 0;
 
+	KUNIT_STATIC_STUB_REDIRECT(ext4_datasem_ensure_credits, handle, inode,
+				   check_cred, restart_cred, revoke_cred);
+
 	ret = ext4_journal_ensure_credits_fn(handle, check_cred, restart_cred,
 		revoke_cred, ext4_ext_trunc_restart_fn(inode, &dropped));
 	if (dropped)
 		down_write(&EXT4_I(inode)->i_data_sem);
 	return ret;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_datasem_ensure_credits);
 
 /*
  * could return:
diff --git a/fs/ext4/migrate-test.c b/fs/ext4/migrate-test.c
index a17830489e36..5a616827e78c 100644
--- a/fs/ext4/migrate-test.c
+++ b/fs/ext4/migrate-test.c
@@ -68,6 +68,18 @@ struct migrate_test_ctx {
 	int new_inode_err;
 	ext4_fsblk_t freed_blks[MIGRATE_MAX_FREED_REC];
 	unsigned int freed_cnt;
+	unsigned int datasem_restarts;
+	struct inode *race_inode;
+	int mark_dirty_err;
+	struct inode *mark_dirty_err_inode;
+	int ensure_credits_err;
+	struct inode *ensure_credits_after_swap_inode;
+	bool evict_tmp_seen;
+	loff_t evict_tmp_isize;
+	blkcnt_t evict_tmp_iblocks;
+	u16 evict_tmp_eh_entries;
+	u16 evict_tmp_eh_depth;
+	__u32 evict_tmp_csum_seed;
 	bool rwsem_inited;
 	bool es_shrinker_inited;
 };
@@ -113,6 +125,19 @@ static void migrate_test_free_inode(struct inode *inode)
 
 static void migrate_test_evict_inode(struct inode *inode)
 {
+	struct kunit *test = active_migrate_test;
+
+	if (test && test->priv && inode->i_ino == 99) {
+		struct migrate_test_ctx *ctx = test->priv;
+		struct ext4_extent_header *eh = ext_inode_hdr(inode);
+
+		ctx->evict_tmp_seen = true;
+		ctx->evict_tmp_isize = i_size_read(inode);
+		ctx->evict_tmp_iblocks = inode->i_blocks;
+		ctx->evict_tmp_eh_entries = le16_to_cpu(eh->eh_entries);
+		ctx->evict_tmp_eh_depth = le16_to_cpu(eh->eh_depth);
+		ctx->evict_tmp_csum_seed = EXT4_I(inode)->i_csum_seed;
+	}
 	truncate_inode_pages_final(&inode->i_data);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
 	clear_inode(inode);
@@ -270,6 +295,31 @@ static int migrate_handle_dirty_metadata_stub(const char *where,
 static int migrate_mark_inode_dirty_stub(handle_t *handle, struct inode *inode,
 					 const char *func, unsigned int line)
 {
+	struct kunit *test = active_migrate_test;
+
+	if (test && test->priv) {
+		struct migrate_test_ctx *ctx = test->priv;
+
+		if (ctx->mark_dirty_err && inode == ctx->mark_dirty_err_inode)
+			return ctx->mark_dirty_err;
+	}
+	return 0;
+}
+
+static int migrate_ensure_credits_stub(handle_t *handle, int check_cred,
+				       int extend_cred, int revoke_cred)
+{
+	struct kunit *test = active_migrate_test;
+
+	if (test && test->priv) {
+		struct migrate_test_ctx *ctx = test->priv;
+
+		if (ctx->ensure_credits_err &&
+		    ctx->ensure_credits_after_swap_inode &&
+		    ext4_test_inode_flag(ctx->ensure_credits_after_swap_inode,
+					 EXT4_INODE_EXTENTS))
+			return ctx->ensure_credits_err;
+	}
 	return 0;
 }
 
@@ -365,6 +415,36 @@ static bool migrate_was_freed(struct migrate_test_ctx *ctx, ext4_fsblk_t blk)
 	return false;
 }
 
+/*
+ * Emulate ext4_datasem_ensure_credits() having to restart the transaction:
+ * i_data_sem is dropped and re-acquired and 1 is returned.
+ */
+static int migrate_datasem_restart_stub(handle_t *handle, struct inode *inode,
+					int check_cred, int restart_cred,
+					int revoke_cred)
+{
+	struct migrate_test_ctx *ctx = active_migrate_test->priv;
+
+	up_write(&EXT4_I(inode)->i_data_sem);
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ctx->datasem_restarts++;
+	return 1;
+}
+
+/*
+ * Emulate a block allocation racing with the migration of
+ * ctx->race_inode, which clears EXT4_STATE_EXT_MIGRATE on it.
+ */
+static int migrate_datasem_race_stub(handle_t *handle, struct inode *inode,
+				     int check_cred, int restart_cred,
+				     int revoke_cred)
+{
+	struct migrate_test_ctx *ctx = active_migrate_test->priv;
+
+	ext4_clear_inode_state(ctx->race_inode, EXT4_STATE_EXT_MIGRATE);
+	return 0;
+}
+
 KUNIT_DEFINE_ACTION_WRAPPER(migrate_iput_action, iput, struct inode *);
 
 static struct inode *migrate_make_test_inode(struct kunit *test, unsigned long ino,
@@ -849,8 +929,8 @@ static void test_ext_migrate_dind_tind_and_multilevel_tree(struct kunit *test)
 /*
  * Test 4: When reading an indirect block fails midway after tmp_inode has
  * already grown a depth-1 extent tree, free_ext_block() / free_ext_idx()
- * frees the allocated temporary extent metadata block and leaves the original
- * inode untouched.
+ * frees the allocated temporary extent metadata block, leaves the original
+ * inode untouched, and ext4_ext_migrate() returns the error.
  */
 static void test_ext_migrate_error_rollback_frees_tmp_extent_blocks(struct kunit *test)
 {
@@ -876,7 +956,8 @@ static void test_ext_migrate_error_rollback_frees_tmp_extent_blocks(struct kunit
 	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] =
 		cpu_to_le32(MIGRATE_TEST_TOTAL_BLKS + 50);
 
-	(void)ext4_ext_migrate(inode);
+	/* The read error is reported to the caller, not swallowed */
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), -EIO);
 
 	/* Temporary extent leaf block allocated during build must be freed */
 	KUNIT_EXPECT_TRUE(test, migrate_was_freed(ctx, expected_leaf_blk));
@@ -1038,6 +1119,244 @@ static void test_ind_migrate_rejections(struct kunit *test)
 	ext4_blocks_count_set(ctx->es, MIGRATE_TEST_TOTAL_BLKS);
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
+		return;
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
+		return;
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), (u32)max_len);
+	KUNIT_EXPECT_FALSE(test, ext4_ext_is_unwritten(&ex[1]));
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[1]),
+			(int)len - max_len);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[1]), data_pblk + max_len);
+
+	/* Indirect metadata blocks were released */
+	KUNIT_EXPECT_TRUE(test, migrate_was_freed(ctx, ind_pblk));
+	KUNIT_EXPECT_TRUE(test, migrate_was_freed(ctx, dind_pblk + 1));
+}
+
+/*
+ * Test 9: A transaction restart while inserting an extent into tmp_inode
+ * (ext4_datasem_ensure_credits() returning 1) is not an error; migration
+ * still completes and builds every extent.
+ */
+static void test_ext_migrate_survives_handle_restart(struct kunit *test)
+{
+	struct migrate_test_ctx *ctx = test->priv;
+	struct ext4_extent_header *eh;
+	struct ext4_extent *ex;
+	struct inode *inode;
+
+	kunit_activate_static_stub(test, ext4_datasem_ensure_credits,
+				   migrate_datasem_restart_stub);
+
+	inode = migrate_make_test_inode(test, 23, S_IFREG | 0644);
+	i_size_write(inode, 12 * MIGRATE_TEST_BLK_SIZE);
+	inode->i_blocks = 4 * (MIGRATE_TEST_BLK_SIZE >> 9);
+
+	/* Three discontiguous runs: [0..1] -> 100, [4] -> 200, [8] -> 300 */
+	EXT4_I(inode)->i_data[0] = cpu_to_le32(100);
+	EXT4_I(inode)->i_data[1] = cpu_to_le32(101);
+	EXT4_I(inode)->i_data[4] = cpu_to_le32(200);
+	EXT4_I(inode)->i_data[8] = cpu_to_le32(300);
+
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), 0);
+	KUNIT_EXPECT_EQ(test, ctx->datasem_restarts, 3U);
+	KUNIT_EXPECT_TRUE(test,
+			  ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		return;
+
+	eh = ext_inode_hdr(inode);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3U);
+	if (le16_to_cpu(eh->eh_entries) != 3)
+		return;
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 0U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 2);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[0]), 100ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), 4U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[1]), 200ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[2].ee_block), 8U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[2]), 300ULL);
+}
+
+/*
+ * Test 10: If a concurrent block allocation invalidates the migration,
+ * ext4_ext_migrate() reports -EAGAIN instead of claiming success, and the
+ * inode keeps its indirect block map.
+ */
+static void test_ext_migrate_reports_concurrent_allocation(struct kunit *test)
+{
+	struct migrate_test_ctx *ctx = test->priv;
+	struct inode *inode;
+
+	kunit_activate_static_stub(test, ext4_datasem_ensure_credits,
+				   migrate_datasem_race_stub);
+
+	inode = migrate_make_test_inode(test, 24, S_IFREG | 0644);
+	i_size_write(inode, 4 * MIGRATE_TEST_BLK_SIZE);
+	inode->i_blocks = 2 * (MIGRATE_TEST_BLK_SIZE >> 9);
+	EXT4_I(inode)->i_data[0] = cpu_to_le32(100);
+	EXT4_I(inode)->i_data[3] = cpu_to_le32(200);
+	ctx->race_inode = inode;
+
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), -EAGAIN);
+	KUNIT_EXPECT_FALSE(test,
+			   ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT4_I(inode)->i_data[0]), 100U);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT4_I(inode)->i_data[3]), 200U);
+
+	ctx->race_inode = NULL;
+}
+
+/*
+ * Test 11: Verify ext4_ext_migrate() clears tmp_inode's in-memory extent
+ * header, i_size, i_blocks, and csum_seed even when ext4_journal_ensure_credits()
+ * fails after swap or when ext4_mark_inode_dirty() fails inside
+ * ext4_ext_swap_inode_data(), so neither free_ext_block() nor
+ * ext4_evict_inode() frees the migrated inode's live blocks.
+ */
+static void test_ext_migrate_credit_or_dirty_failure_keeps_live_blocks(
+		struct kunit *test)
+{
+	struct migrate_test_ctx *ctx = test->priv;
+	struct inode *inode;
+	ext4_fsblk_t ext_idx_pblk;
+	unsigned int i;
+
+	/*
+	 * 1. Six discontiguous direct blocks produce a depth-1 extent tree
+	 * (exceeding the 4 inline root extents). Failing
+	 * __ext4_journal_ensure_credits() with -EROFS after swapping must
+	 * still leave tmp_inode empty when evicted.
+	 */
+	kunit_activate_static_stub(test, __ext4_journal_ensure_credits,
+				   migrate_ensure_credits_stub);
+	inode = migrate_make_test_inode(test, 25, S_IFREG | 0644);
+	i_size_write(inode, 12 * MIGRATE_TEST_BLK_SIZE);
+	inode->i_blocks = 6 * (MIGRATE_TEST_BLK_SIZE >> 9);
+	for (i = 0; i < 6; i++)
+		EXT4_I(inode)->i_data[i * 2] = cpu_to_le32(100 + i * 10);
+
+	ctx->evict_tmp_seen = false;
+	ctx->ensure_credits_after_swap_inode = inode;
+	ctx->ensure_credits_err = -EROFS;
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), -EROFS);
+	ctx->ensure_credits_err = 0;
+	ctx->ensure_credits_after_swap_inode = NULL;
+
+	KUNIT_EXPECT_TRUE(test,
+			  ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(ext_inode_hdr(inode)->eh_depth), 1U);
+	KUNIT_ASSERT_TRUE(test, ctx->evict_tmp_seen);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_isize, 0LL);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_iblocks, (blkcnt_t)0);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_eh_entries, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_eh_depth, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_csum_seed, 0xabcdef01U);
+
+	/*
+	 * 2. Failing ext4_mark_inode_dirty() inside ext4_ext_swap_inode_data()
+	 * after ownership moved to inode must NOT free inode's new extent index
+	 * block via free_ext_block(handle, tmp_inode).
+	 */
+	inode = migrate_make_test_inode(test, 26, S_IFREG | 0644);
+	i_size_write(inode, 12 * MIGRATE_TEST_BLK_SIZE);
+	inode->i_blocks = 6 * (MIGRATE_TEST_BLK_SIZE >> 9);
+	for (i = 0; i < 6; i++)
+		EXT4_I(inode)->i_data[i * 2] = cpu_to_le32(200 + i * 10);
+
+	ext_idx_pblk = ctx->next_alloc_pblk;
+	ctx->freed_cnt = 0;
+	ctx->evict_tmp_seen = false;
+	ctx->mark_dirty_err = -EIO;
+	ctx->mark_dirty_err_inode = inode;
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), -EIO);
+	ctx->mark_dirty_err = 0;
+	ctx->mark_dirty_err_inode = NULL;
+
+	KUNIT_EXPECT_FALSE(test, migrate_was_freed(ctx, ext_idx_pblk));
+	KUNIT_ASSERT_TRUE(test, ctx->evict_tmp_seen);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_isize, 0LL);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_iblocks, (blkcnt_t)0);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_eh_entries, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_eh_depth, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->evict_tmp_csum_seed, 0xabcdef01U);
+}
+
 static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ext_migrate_precondition_checks_and_fast_symlink),
 	KUNIT_CASE(test_ext_migrate_direct_and_ind_coalescing_and_holes),
@@ -1046,6 +1365,10 @@ static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ext_swap_inode_data_detects_concurrent_allocation),
 	KUNIT_CASE(test_ind_migrate_empty_and_single_direct_extent),
 	KUNIT_CASE(test_ind_migrate_rejections),
+	KUNIT_CASE(test_ext_migrate_caps_long_run_at_init_max_len),
+	KUNIT_CASE(test_ext_migrate_survives_handle_restart),
+	KUNIT_CASE(test_ext_migrate_reports_concurrent_allocation),
+	KUNIT_CASE(test_ext_migrate_credit_or_dirty_failure_keeps_live_blocks),
 	{}
 };
 
-- 
2.56.1.708.g77570a6a1d-goog

