Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103826;
	b=2XI21u0eTMyfKgR1yKSjew0bOE81hHlXcf7kvzztmFpsSUA7Jz1kQzmiEu8X31N8U0My
	 FDXl81/l6J/eLQQSFos639ZS/vIA5sm2o4W884Jg+ygVCYwuB0Ntabw0s2jzq3Aqs/0Q/
	 MHRVPb1XFBFYDDQwwOEIHnqvI+fDOm+zfdZrkFY8cBkCOTdnqpcln8Y3xqfOwA/lsmps4
	 qW6pZQjGAyX1Ly3S0pR8lFwFjIExptuz0PRNi+UPESaHFyyheuql1iETPJRQRG57A/bpN
	 UVgSFapVdnu1FmNjMpEqtIqpNLP4u0XvsOWOLnU2GVhpEXRgAQz8CT5uqnDDtiCRFew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103826;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=amuiCLWl+KP2Y1zcB90r+DLxDmnzdPWBP9ed8z7bId0=;
	b=glbD+vwrH3gM+oiH6aaCQHUJ57rtJqS2ews1QpM9m2PKUr4dd2Oqt8MTE1T8SbeZlEWa
	 4SoUI5vqd5ZBWk2j0p0H5uFDC6VVGrQPBaOd649E3Jxoeg2pAnyGfiJpiENEIWGz1831A
	 9HF5WpnuwG9OafJdBKfHGp4jl0z3kR9C6FM9rLx6FajTt9g7YRN/r64wA4w2VF/1xkSc6
	 BOTxGypKH9gG78oIrATp39k8OsAZzOGDp2kxzQEewjTlFDVpelNpikTnEAFEa8BucnzXW
	 2ySbh0eNwsuZG8HXoCCajcgHwfr0sLZ1XqGXPJCpWmZaFDhgBd5Uc/oZ1z3aWIdIlFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=KVrLty5w;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2405606A333
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 15:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2405606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=KVrLty5w
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJFv1j7001566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 10:57:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795103823; bh=amuiCLWl+KP2Y1zcB90r+DLxDmnzdPWBP9ed8z7bId0=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=KVrLty5wyL82u22DRT3gtmdd5QRbxQvd//ogK8l8tDPg8wobXE8ui8hPz1MIcVZbT
	 jozpBjCH0jrkm+xBzNGx7WU3ncUAeQ7uxjGOgkL18kRn/kLkwR/YCLGfyyjPpQfX2W
	 k87z2bNOenzRVr0KvziLHeQx542YlR5N8raNtgvwlSEKtXoxkXVq8Yqs8F+sXbDIFL
	 Rw+a74IK/isSJoaVJDa9aQs3FM586mp8d6PY9YpLW1zqQO2sEVb9nZz9hQJ4/csuuw
	 YbdzoQRt6mhyO46cygClNwDKsG0nKYtQRZuZTll85/QPdCCqdCh4umpWJ4+Y8JNWHh
	 I/LPtBO5qPLdQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 73E6F2E0153; Thu, 19 Nov 2026 10:57:00 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 14/26] ext4: enable full feature coverage in fs/ext4/.kunitconfig
Date: Thu, 19 Nov 2026 10:56:46 -0500
Message-ID: <20261119155658.1940864-15-tytso@mit.edu>
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
  namei-test.c to propagate EXT4_INODE_CASEFOLD to S_CASEFOLD on the VFS
  directory inode via ext4_set_inode_flags().

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
 fs/ext4/namei-test.c          | 14 ++++++++++++--
 fs/ext4/xattr-test.c          | 16 ++++++++++++++--
 10 files changed, 121 insertions(+), 17 deletions(-)

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
index b15d50907324..ab076c0edf99 100644
--- a/fs/ext4/balloc-test.c
+++ b/fs/ext4/balloc-test.c
@@ -535,6 +535,9 @@ static int balloc_test_init(struct kunit *test)
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
index 8d3af4093a3c..97817befd6e7 100644
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
index cb1ef31490d0..bc5488293103 100644
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
@@ -467,6 +476,9 @@ static int extents_kunit_init(struct kunit *test)
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
index be416cb3653e..07cb9c043cd2 100644
--- a/fs/ext4/fast_commit-test.c
+++ b/fs/ext4/fast_commit-test.c
@@ -135,9 +135,12 @@ struct fc_test_ctx {
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
@@ -148,6 +151,12 @@ static const struct dquot_operations fc_test_qops = {
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
@@ -886,6 +895,9 @@ static int fast_commit_test_init(struct kunit *test)
 	sb->s_op = &fc_test_sops;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &fc_test_qops;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
 #endif
 	strscpy(sb->s_id, "ext4-fc-test", sizeof(sb->s_id));
 
diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index efc068c1f823..0198ce8311c7 100644
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
index 4881736e8742..8a3d753b7079 100644
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
@@ -960,6 +968,9 @@ static struct inode_test_ctx *inode_test_setup(struct kunit *test)
 	sb->s_op = &inode_test_sops;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &inode_test_qops;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
 #endif
 	sb->s_blocksize = INODE_TEST_BLK_SIZE;
 	sb->s_blocksize_bits = INODE_TEST_BLK_BITS;
diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index 6f70bff5c83a..bd5dabf74b6f 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -56,9 +56,19 @@ static void mbt_free_inode(struct inode *inode)
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
@@ -95,6 +105,9 @@ static int mbt_mb_init(struct super_block *sb)
 	 */
 	INIT_LIST_HEAD(&sb->s_inodes);
 	sb->s_op = &mbt_sops;
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &ext4_cryptops;
+#endif
 
 	ret = ext4_mb_init(sb);
 	if (ret != 0)
diff --git a/fs/ext4/namei-test.c b/fs/ext4/namei-test.c
index 6dde9e5cc332..cce3f8d5b36d 100644
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
@@ -2278,6 +2287,7 @@ static void test_namei_casefold_lookup_and_strict(struct kunit *test)
 	ctx->es.s_feature_incompat |=
 		cpu_to_le32(EXT4_FEATURE_INCOMPAT_CASEFOLD);
 	ext4_set_inode_flag(dir, EXT4_INODE_CASEFOLD);
+	ext4_set_inode_flags(dir, true);
 
 	KUNIT_ASSERT_EQ(test, ext4_init_new_dir(NULL, root_dir, dir), 0);
 	init_mock_dentry(&parent_dentry, NULL, "cfdir", dir, &ctx->sb);
diff --git a/fs/ext4/xattr-test.c b/fs/ext4/xattr-test.c
index 30ee5c337284..981bf1455851 100644
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
@@ -477,6 +486,9 @@ static int xattr_test_init(struct kunit *test)
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
2.56.1.708.g77570a6a1d-goog

