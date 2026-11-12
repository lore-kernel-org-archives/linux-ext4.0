Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456424;
	b=5UhV8i6Hi9nhFCVFNy/TsK7911G1faJwk5S+E6FG0VZqPJA4v5N/A4A832qCB6ucn39T
	 MsByCMWAOK7GSLW9i6Wny2wGKpIEg/OMd5eNHs066yUIjGxZ+aENbMF2PXVvpO+8Uo/0b
	 x5kcj455a6OCOyaBOVeG4P6usw4cTVHi8HSNNAdTjXgNOdn6st52zRBLJ4cLAXOzRvnb+
	 /547Q/6oVzamwL1awH5dakuO6QYcyJ+qE8J2EJiL473KJEcdTu7GN+x4+14nuRPHmglc4
	 cMHfyLExo1veS0Y0n1++nf8us3hpOM5mLMuyF/AZOihuWeqEprH7N8IkVYBgW1nAPdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456424;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ILFTZx/QQSTACyldWMkX9UfvGlEjEnUfM6qnNivwoyQ=;
	b=QZEf6IDvBoGq2pwSY6ig9qRuXOKaylDYCp8GXnFK6bANTHbDlkdJHr06oKCyEOb8lQbT
	 4BXpB6WfM/CkCFCLkT0Nhcg/nsw9SG3lQNQTdk7u/8uyQWo0BK+aJPGSTFhfa1gl5oqyY
	 s3ZfnWmJGY0W86RzNBUbk02sdw6MU7NlHkjqvLZ5y03AaTAzMD/Bg+FgCMRjqCwlrolf8
	 ICDdBYjTiYjH8i6CwcHDyEdTNdww08cnjTr/WSi3S4GwFv6usBsLYLNLjettG0DKTOSQH
	 d1zu9DlNIlJJ0h1S1LeEvGBFGO/0ioEiJ2/h0XLrA6LB1zUgo3niGlPy+14UdcrL7hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MkiStqtW;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C651E606A88D
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C651E606A88D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MkiStqtW
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46sNx016894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456416; bh=ILFTZx/QQSTACyldWMkX9UfvGlEjEnUfM6qnNivwoyQ=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=MkiStqtWksstDSciJavkUK41DBiuNEFw7AI2F7D9D4xtAonjlO3Q6n1AB+pmxeWzo
	 VrJootfFkC4hTJzecC7XgHOVGQJFHdDelLTVyg/EHBwGdiSuxDU70vvhsO2D+4RFCA
	 RUnWldapAyt3UIui/pKRYKYdfb/hmcSQhjaiOZelwYan5GxpgbvvQ16XyMSlwAU+Ra
	 4v/vPXioRlUdrQsjM4usphz6dml/nIbhLZ+yZC9nutCWShLDl/S++cqslWsCdL52ZJ
	 Hi3LrHNFddps/9IldBvoJpVUdJcokY15Yf07mGMAj43rNUzRJ2jvTJxU+shM87Q2aH
	 yqpuy0HunkGAg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 76AE32E0155; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 16/27] ext4: enable full feature coverage in fs/ext4/.kunitconfig
Date: Wed, 11 Nov 2026 23:06:27 -0500
Message-ID: <20261112040638.1576836-17-tytso@mit.edu>
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

Enable CONFIG_EXT4_FS_POSIX_ACL, CONFIG_EXT4_FS_SECURITY,
CONFIG_FS_VERITY, CONFIG_FS_ENCRYPTION, CONFIG_QUOTA, CONFIG_QFMT_V2,
and CONFIG_UNICODE in fs/ext4/.kunitconfig so conditional ext4 source
files and feature-gated code paths (POSIX ACLs, security xattrs,
fs-verity, fscrypt, quota accounting, and UTF-8 casefolding) are
compiled and exercised during KUnit runs.

Fix mock superblock and test setup bugs in existing KUnit suites exposed
by enabling these Kconfig options:

- Provide .get_dquots callbacks in mock super_operations under
  CONFIG_QUOTA in block_validity-test.c, extents-test.c,
  fast_commit-test.c, inline-test.c, inode-test.c, mballoc-test.c,
  namei-test.c, and xattr-test.c so dquot_drop() does not dereference a
  NULL callback during ext4_clear_inode().
- Populate sb->s_cop = &ext4_cryptops under CONFIG_FS_ENCRYPTION in
  balloc-test.c, extents-test.c, fast_commit-test.c, inline-test.c,
  inode-test.c, mballoc-test.c, and xattr-test.c so
  fscrypt_put_encryption_info() can resolve inode_info_offs safely on
  eviction.
- Fix test_namei_casefold_lookup_and_strict() under CONFIG_UNICODE in
  namei-test.c to use SB_ENC_STRICT_MODE_FL (instead of undeclared
  SB_STRICT_ENCODING) and propagate EXT4_INODE_CASEFOLD to S_CASEFOLD on
  the VFS directory inode via ext4_set_inode_flags().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/.kunitconfig          |  7 +++++++
 fs/ext4/balloc-test.c         |  3 +++
 fs/ext4/block_validity-test.c | 10 ++++++++++
 fs/ext4/extents-test.c        | 16 ++++++++++++++--
 fs/ext4/fast_commit-test.c    | 16 ++++++++++++++--
 fs/ext4/inline-test.c         | 16 +++++++++++++++-
 fs/ext4/inode-test.c          | 27 +++++++++++++++++++--------
 fs/ext4/mballoc-test.c        | 13 +++++++++++++
 fs/ext4/namei-test.c          | 18 ++++++++++++++----
 fs/ext4/xattr-test.c          | 16 ++++++++++++++--
 10 files changed, 123 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/.kunitconfig b/fs/ext4/.kunitconfig
index bf51da7cd9fc..17103c583fdb 100644
--- a/fs/ext4/.kunitconfig
+++ b/fs/ext4/.kunitconfig
@@ -1,3 +1,10 @@
 CONFIG_KUNIT=y
 CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
 CONFIG_EXT4_KUNIT_TESTS=y
+CONFIG_FS_VERITY=y
+CONFIG_FS_ENCRYPTION=y
+CONFIG_QUOTA=y
+CONFIG_QFMT_V2=y
+CONFIG_UNICODE=y
diff --git a/fs/ext4/balloc-test.c b/fs/ext4/balloc-test.c
index f3f3479d6afb..96e8aafe231d 100644
--- a/fs/ext4/balloc-test.c
+++ b/fs/ext4/balloc-test.c
@@ -516,6 +516,9 @@ static int balloc_test_init(struct kunit *test)
 	sb->s_op = &balloc_test_sops;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &balloc_test_qops;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
 #endif
 	sb->s_flags |= SB_ACTIVE;
 	sb->s_blocksize = BALLOC_TEST_BLK_SIZE;
diff --git a/fs/ext4/block_validity-test.c b/fs/ext4/block_validity-test.c
index 5b50f56b3453..ce1e8172c66c 100644
--- a/fs/ext4/block_validity-test.c
+++ b/fs/ext4/block_validity-test.c
@@ -228,12 +228,22 @@ static void bv_test_free_inode_mem(struct inode *inode)
 	kfree(EXT4_I(inode));
 }
 
+#ifdef CONFIG_QUOTA
+static struct dquot __rcu **bv_test_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+#endif
+
 static const struct super_operations bv_test_sops = {
 	.alloc_inode	= bv_test_alloc_inode,
 	.evict_inode	= bv_test_evict_inode,
 	.destroy_inode	= bv_test_destroy_inode,
 	.free_inode	= bv_test_free_inode_mem,
 	.drop_inode	= inode_just_drop,
+#ifdef CONFIG_QUOTA
+	.get_dquots	= bv_test_get_dquots,
+#endif
 };
 
 static int bv_test_init_fs_context(struct fs_context *fc)
diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 47ddeb94e2bf..7565a8aa4e10 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -153,9 +153,12 @@ static unsigned long ext_dummy_shrinker_scan(struct shrinker *shrink,
 	return SHRINK_STOP;
 }
 
-static const struct super_operations ext_dummy_sops = {};
-
 #ifdef CONFIG_QUOTA
+static struct dquot __rcu **ext_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+
 static qsize_t *ext_get_reserved_space(struct inode *inode)
 {
 	return &EXT4_I(inode)->i_reserved_quota;
@@ -166,6 +169,12 @@ static const struct dquot_operations ext_dummy_qops = {
 };
 #endif
 
+static const struct super_operations ext_dummy_sops = {
+#ifdef CONFIG_QUOTA
+	.get_dquots	= ext_get_dquots,
+#endif
+};
+
 static int ext_init_fs_context(struct fs_context *fc)
 {
 	return 0;
@@ -461,6 +470,9 @@ static int extents_kunit_init(struct kunit *test)
 	sb->s_op = &ext_dummy_sops;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &ext_dummy_qops;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
 #endif
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = 12;
diff --git a/fs/ext4/fast_commit-test.c b/fs/ext4/fast_commit-test.c
index 57745e51bea6..fdc57dc0d9a8 100644
--- a/fs/ext4/fast_commit-test.c
+++ b/fs/ext4/fast_commit-test.c
@@ -134,9 +134,12 @@ struct fc_test_ctx {
 	int custom_es_ret;
 };
 
-static const struct super_operations fc_test_sops = {};
-
 #ifdef CONFIG_QUOTA
+static struct dquot __rcu **fc_test_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+
 static qsize_t *fc_test_get_reserved_space(struct inode *inode)
 {
 	return &EXT4_I(inode)->i_reserved_quota;
@@ -147,6 +150,12 @@ static const struct dquot_operations fc_test_qops = {
 };
 #endif
 
+static const struct super_operations fc_test_sops = {
+#ifdef CONFIG_QUOTA
+	.get_dquots	= fc_test_get_dquots,
+#endif
+};
+
 static unsigned long fc_dummy_shrinker_count(struct shrinker *shrink,
 					     struct shrink_control *sc)
 {
@@ -867,6 +876,9 @@ static int fast_commit_test_init(struct kunit *test)
 	sb->s_op = &fc_test_sops;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &fc_test_qops;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
 #endif
 	strscpy(sb->s_id, "ext4-fc-test", sizeof(sb->s_id));
 
diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index a75f46475c4a..96ea716d0d61 100644
--- a/fs/ext4/inline-test.c
+++ b/fs/ext4/inline-test.c
@@ -66,7 +66,18 @@ struct inline_test_ctx {
 
 static struct inline_test_ctx *t_ctx;
 
-static const struct super_operations inline_test_sops = {};
+#ifdef CONFIG_QUOTA
+static struct dquot __rcu **inline_test_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+#endif
+
+static const struct super_operations inline_test_sops = {
+#ifdef CONFIG_QUOTA
+	.get_dquots	= inline_test_get_dquots,
+#endif
+};
 
 static bool test_release_folio(struct folio *folio, gfp_t wait)
 {
@@ -265,6 +276,9 @@ static int inline_test_init(struct kunit *test)
 	ctx->sb.s_bdi = &noop_backing_dev_info;
 	ctx->sb.s_fs_info = &ctx->sbi;
 	ctx->sb.s_op = &inline_test_sops;
+#ifdef CONFIG_FS_ENCRYPTION
+	ctx->sb.s_cop = &ext4_cryptops;
+#endif
 	snprintf(ctx->sb.s_id, sizeof(ctx->sb.s_id), "ext4-inline-test");
 	init_rwsem(&ctx->sb.s_umount);
 
diff --git a/fs/ext4/inode-test.c b/fs/ext4/inode-test.c
index e8d19c1d4270..181023d1ae83 100644
--- a/fs/ext4/inode-test.c
+++ b/fs/ext4/inode-test.c
@@ -462,15 +462,12 @@ static void inode_test_free_inode(struct inode *inode)
 	kfree(EXT4_I(inode));
 }
 
-static const struct super_operations inode_test_sops = {
-	.alloc_inode	= inode_test_alloc_inode,
-	.evict_inode	= ext4_evict_inode,
-	.destroy_inode	= inode_test_destroy_inode,
-	.free_inode	= inode_test_free_inode,
-	.drop_inode	= inode_just_drop,
-};
-
 #ifdef CONFIG_QUOTA
+static struct dquot __rcu **inode_test_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+
 static qsize_t *inode_test_get_reserved_space(struct inode *inode)
 {
 	return &EXT4_I(inode)->i_reserved_quota;
@@ -481,6 +478,17 @@ static const struct dquot_operations inode_test_qops = {
 };
 #endif
 
+static const struct super_operations inode_test_sops = {
+	.alloc_inode	= inode_test_alloc_inode,
+	.evict_inode	= ext4_evict_inode,
+	.destroy_inode	= inode_test_destroy_inode,
+	.free_inode	= inode_test_free_inode,
+	.drop_inode	= inode_just_drop,
+#ifdef CONFIG_QUOTA
+	.get_dquots	= inode_test_get_dquots,
+#endif
+};
+
 static int inode_test_init_fs_context(struct fs_context *fc)
 {
 	return 0;
@@ -950,6 +958,9 @@ static struct inode_test_ctx *inode_test_setup(struct kunit *test)
 	sb->s_op = &inode_test_sops;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &inode_test_qops;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
 #endif
 	sb->s_flags |= SB_ACTIVE;
 	sb->s_blocksize = INODE_TEST_BLK_SIZE;
diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index 402f4efdf25a..48048359f255 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -54,9 +54,19 @@ static void mbt_free_inode(struct inode *inode)
 	kfree(EXT4_I(inode));
 }
 
+#ifdef CONFIG_QUOTA
+static struct dquot __rcu **mbt_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+#endif
+
 static const struct super_operations mbt_sops = {
 	.alloc_inode	= mbt_alloc_inode,
 	.free_inode	= mbt_free_inode,
+#ifdef CONFIG_QUOTA
+	.get_dquots	= mbt_get_dquots,
+#endif
 };
 
 static int mbt_init_fs_context(struct fs_context *fc)
@@ -93,6 +103,9 @@ static int mbt_mb_init(struct super_block *sb)
 	 */
 	INIT_LIST_HEAD(&sb->s_inodes);
 	sb->s_op = &mbt_sops;
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
+#endif
 
 	ret = ext4_mb_init(sb);
 	if (ret != 0)
diff --git a/fs/ext4/namei-test.c b/fs/ext4/namei-test.c
index df5affef1289..2eec9a1102ce 100644
--- a/fs/ext4/namei-test.c
+++ b/fs/ext4/namei-test.c
@@ -84,9 +84,12 @@ struct namei_test_ctx {
 	unsigned int mark_inode_dirty_calls;
 };
 
-static const struct super_operations namei_test_sops = {};
-
 #ifdef CONFIG_QUOTA
+static struct dquot __rcu **namei_test_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+
 static qsize_t *namei_test_get_reserved_space(struct inode *inode)
 {
 	return &EXT4_I(inode)->i_reserved_quota;
@@ -97,6 +100,12 @@ static const struct dquot_operations namei_test_qops = {
 };
 #endif
 
+static const struct super_operations namei_test_sops = {
+#ifdef CONFIG_QUOTA
+	.get_dquots	= namei_test_get_dquots,
+#endif
+};
+
 static void init_mock_inode_slot(struct namei_test_ctx *ctx,
 				 struct mock_inode_slot *slot,
 				 unsigned long ino, umode_t mode)
@@ -2245,6 +2254,7 @@ static void test_namei_casefold_lookup_and_strict(struct kunit *test)
 	ctx->es.s_feature_incompat |=
 		cpu_to_le32(EXT4_FEATURE_INCOMPAT_CASEFOLD);
 	ext4_set_inode_flag(dir, EXT4_INODE_CASEFOLD);
+	ext4_set_inode_flags(dir, true);
 
 	KUNIT_ASSERT_EQ(test, ext4_init_new_dir(NULL, root_dir, dir), 0);
 	init_mock_dentry(&parent_dentry, NULL, "cfdir", dir, &ctx->sb);
@@ -2261,8 +2271,8 @@ static void test_namei_casefold_lookup_and_strict(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, le32_to_cpu(de->inode), TEST_FILE1_INO);
 	brelse(bh);
 
-	/* Enable SB_STRICT_ENCODING -> invalid UTF-8 sequence is rejected */
-	ctx->sb.s_encoding_flags |= SB_STRICT_ENCODING;
+	/* Enable SB_ENC_STRICT_MODE_FL -> invalid UTF-8 sequence is rejected */
+	ctx->sb.s_encoding_flags |= SB_ENC_STRICT_MODE_FL;
 	add_dentry.__d_name = bad_utf8;
 	KUNIT_EXPECT_EQ(test,
 			ext4_add_entry_test(NULL, &add_dentry, file1),
diff --git a/fs/ext4/xattr-test.c b/fs/ext4/xattr-test.c
index 35be150353a2..8f85fa481fce 100644
--- a/fs/ext4/xattr-test.c
+++ b/fs/ext4/xattr-test.c
@@ -79,9 +79,12 @@ struct xattr_test_ctx {
 	unsigned int dirty_metadata_calls;
 };
 
-static const struct super_operations xattr_test_sops = {};
-
 #ifdef CONFIG_QUOTA
+static struct dquot __rcu **xattr_test_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+
 static qsize_t *xattr_test_get_reserved_space(struct inode *inode)
 {
 	return &EXT4_I(inode)->i_reserved_quota;
@@ -92,6 +95,12 @@ static const struct dquot_operations xattr_test_qops = {
 };
 #endif
 
+static const struct super_operations xattr_test_sops = {
+#ifdef CONFIG_QUOTA
+	.get_dquots	= xattr_test_get_dquots,
+#endif
+};
+
 static void init_mock_inode_slot(struct xattr_test_ctx *ctx,
 				 struct mock_inode_slot *slot,
 				 unsigned long ino)
@@ -476,6 +485,9 @@ static int xattr_test_init(struct kunit *test)
 	sb->s_op = &xattr_test_sops;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &xattr_test_qops;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
 #endif
 	sb->s_blocksize = TEST_BLK_SIZE;
 	sb->s_blocksize_bits = TEST_BLK_BITS;
-- 
2.56.0.542.g3ef89b7020-goog

