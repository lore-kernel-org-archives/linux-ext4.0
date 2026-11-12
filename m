Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458843;
	b=xA7wZs6EZngfpHbpTsFji65LSdRjPisyoBW+M540gWYKemGUilNzeXt8o6xZzWqQHiBq
	 1Lp+cXHv6dNlGPB0ByKhFq4OBtTSf5tl3srqq8Bm13jsEXRTLj+YMRnBBRk/Bu2RJpjEU
	 8j6ddd9vLIIspQYO2Q8Bij1fOkok3qNuwG/SVyIpDUtIb7Ncg1GqsFZoDVN0WIvuI+Iv9
	 ym1MtkqSwksduAiC72R/XVHE6CJbjC5O81Ks1tJo04k9iKtMHkNivRuhe5ACDzeLGj1Y9
	 M87Ijkn/25m4rz1dXgnjIHETP/2Tr45TDk+rkotgFTnKXWyiAmxnCmtjF2DpqLap15A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458843;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=O/4A7m7PLLF6aUbYHoMofYLwN8WFF7EuJN7FFAWbiG0=;
	b=jRuiuku0wdfWNZQfKFjgvCxEqyGpWXb4G7hqmhWSb5HLGjq1onf9D6hHXhOEi+zkqaVB
	 dPmVdPgF1A2nwAi4XNC64bZ6Ez0tYttWjq1hEXT7FouqMzww2mQxHUh6uDPoTWsUyykrn
	 jKxyP4wa63Ek6jx79WAB4SVzfAnZFA76iAeFY4GgahFDyeqD3X3/LM24HxLOpYEe+UW0d
	 0E/hNf4qnVXQpZmtcTfrfQa9g0+TOMzsm6si8dJe3qYhuRQpy298DXdJb14IOwMzxgn2I
	 w57vIFcQG5Wv2blvLLWrh0gSycwSZ9wOH7Jr+X1Vg13H7dC4UHQfMO5+oxbdQJnTbig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=lB+hYb20;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E5B606A339
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3E5B606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=lB+hYb20
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lJH2031147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458840; bh=O/4A7m7PLLF6aUbYHoMofYLwN8WFF7EuJN7FFAWbiG0=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=lB+hYb2043V3daHPBgq8a98sqQSg0B465YbxsHwnnBUWPoMi68cSe5vifTLtT3Qol
	 2v+ct8VQuqQn73z/J4dOcf9D2RC6T1B2fq/OGkcq5OnZmXgzZ6vsO7hxvc7wy74hte
	 rfBJdZLa5Jd6VGpeYSFu3o12J2YWkJtBQHU5zJQMBdwpUiQEJRgw6Ze3/RzNjxA1xB
	 +7mkho5S0Ve3yHbAx7rQtvJ2FxlIL1T4I1naav/anWeBFiJuurI+XifndZRCKdAI5E
	 rPzagVsJA0AoLPAe1IlkxWTKNaALS08ZbBIczcGFHheUoeHNqN5+60bmaMX0YPBQXp
	 9MW+uNESBT8aA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2D5662E0146; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 04/23] ext4: persist the htree hash seed when enabling dir_index online
Date: Wed, 11 Nov 2026 23:46:53 -0500
Message-ID: <20261112044712.1577296-5-tytso@mit.edu>
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

When EXT4_IOC_SET_TUNE_SB_PARAM enables the dir_index feature,
ext4_validate_tune_sb_params() generates a random sbi->s_hash_seed if
the current one is all zeroes, and picks the hash signedness in
sbi->s_hash_unsigned.  However, ext4_sb_setparams() only copies
s_def_hash_version to the superblocks; the hash seed and the
EXT2_FLAGS_{UNSIGNED,SIGNED}_HASH flag are never written out.

Any directory converted to an htree before the next unmount has its
names hashed with the random in-memory seed.  After a remount the seed
is reloaded from the (still all-zero) on-disk superblock, so lookups in
those directories compute different hashes and fail with -ENOENT, and
new entries are inserted into the wrong leaf blocks.

In addition, if the superblock already has EXT2_FLAGS_UNSIGNED_HASH
set (e.g. it was created by mke2fs on an unsigned-char platform with
dir_index disabled), sbi->s_hash_unsigned is left at 0, so names
containing bytes >= 0x80 are hashed differently than they will be
after the next mount, which honors the flag.

Write the hash seed and, if neither flag is present, the signedness
flag matching sbi->s_hash_unsigned to the primary and backup
superblocks, and set sbi->s_hash_unsigned from an existing
EXT2_FLAGS_UNSIGNED_HASH flag just like ext4_fill_super() does.

The in-memory values are still set up before the superblocks are
updated, since htree directories may be created as soon as the
feature bit is visible in the primary superblock.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 60 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c      | 23 +++++++++++++----
 2 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index fab2b9f8ff35..4641ba7b31ff 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -736,6 +736,65 @@ static void test_tune_sb_mount_opts_guard(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, (char *)es->s_mount_opts, "nodelalloc");
 }
 
+/*
+ * Verify that enabling DIR_INDEX online persists the (possibly freshly
+ * generated) hash seed and the hash signedness flag to the superblock, and
+ * that an existing signedness flag in s_flags is honored in memory.
+ */
+static void test_tune_sb_dir_index_hash_state(struct kunit *test)
+{
+	struct ioctl_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	struct ext4_sb_info *sbi = &ctx->sbi;
+	struct ext4_super_block *es = ctx->es;
+	struct ext4_tune_sb_params params;
+	__le32 hash_flags;
+	uuid_t uu;
+	int i;
+
+	memset(sbi->s_hash_seed, 0, sizeof(sbi->s_hash_seed));
+	memset(es->s_hash_seed, 0, sizeof(es->s_hash_seed));
+	sbi->s_def_hash_version = 0;
+	es->s_flags = 0;
+
+	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_FEATURES;
+	params.feature_compat = le32_to_cpu(es->s_feature_compat) |
+				EXT4_FEATURE_COMPAT_DIR_INDEX;
+	params.feature_incompat = le32_to_cpu(es->s_feature_incompat);
+	params.feature_ro_compat = le32_to_cpu(es->s_feature_ro_compat);
+	KUNIT_ASSERT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			0);
+	ext4_sb_setparams_test(sbi, es, &params);
+
+	KUNIT_EXPECT_TRUE(test, ext4_has_feature_dir_index(sb));
+	KUNIT_EXPECT_EQ(test, es->s_def_hash_version, DX_HASH_HALF_MD4);
+	memcpy(&uu, es->s_hash_seed, UUID_SIZE);
+	KUNIT_EXPECT_FALSE(test, uuid_is_null(&uu));
+	for (i = 0; i < ARRAY_SIZE(es->s_hash_seed); i++)
+		KUNIT_EXPECT_EQ(test, le32_to_cpu(es->s_hash_seed[i]),
+				sbi->s_hash_seed[i]);
+	hash_flags = es->s_flags & cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH |
+					       EXT2_FLAGS_SIGNED_HASH);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(hash_flags),
+			sbi->s_hash_unsigned ? EXT2_FLAGS_UNSIGNED_HASH :
+					       EXT2_FLAGS_SIGNED_HASH);
+
+	/* An existing unsigned-hash flag must be honored in memory */
+	ext4_clear_feature_dir_index(sb);
+	es->s_flags = cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
+	sbi->s_hash_unsigned = 0;
+	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_EDIT_FEATURES;
+	params.set_feature_compat_mask = EXT4_FEATURE_COMPAT_DIR_INDEX;
+	KUNIT_ASSERT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			0);
+	KUNIT_EXPECT_EQ(test, sbi->s_hash_unsigned, 3U);
+	ext4_sb_setparams_test(sbi, es, &params);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(es->s_flags),
+			EXT2_FLAGS_UNSIGNED_HASH);
+}
+
 /*
  * Verify ext4_update_backup_sb, ext4_update_superblocks_fn, and
  * ext4_update_overhead across primary + 4 sparse_super backup groups (1, 3,
@@ -1243,6 +1302,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_sb_callbacks_and_setparams),
 	KUNIT_CASE(test_validate_tune_sb_params),
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
+	KUNIT_CASE(test_tune_sb_dir_index_hash_state),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 8537d5766732..e2a5713a4562 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1392,8 +1392,20 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 		es->s_feature_ro_compat &=
 			~cpu_to_le32(params->clear_feature_ro_compat_mask);
 		if (params->set_feature_compat_mask &
-		    EXT4_FEATURE_COMPAT_DIR_INDEX)
+		    EXT4_FEATURE_COMPAT_DIR_INDEX) {
+			int i;
+
 			es->s_def_hash_version = sbi->s_def_hash_version;
+			for (i = 0; i < ARRAY_SIZE(es->s_hash_seed); i++)
+				es->s_hash_seed[i] =
+					cpu_to_le32(sbi->s_hash_seed[i]);
+			if (!(es->s_flags &
+			      cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH |
+					  EXT2_FLAGS_SIGNED_HASH)))
+				es->s_flags |= sbi->s_hash_unsigned ?
+					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH) :
+					cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
+		}
 		if (params->set_feature_incompat_mask &
 		    EXT4_FEATURE_INCOMPAT_CSUM_SEED)
 			es->s_checksum_seed = cpu_to_le32(sbi->s_csum_seed);
@@ -1488,10 +1500,11 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 				sbi->s_def_hash_version = params->def_hash_alg;
 			else if (sbi->s_def_hash_version == 0)
 				sbi->s_def_hash_version = DX_HASH_HALF_MD4;
-			if (!(es->s_flags &
-			      cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH)) &&
-			    !(es->s_flags &
-			      cpu_to_le32(EXT2_FLAGS_SIGNED_HASH))) {
+			if (es->s_flags &
+			    cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH)) {
+				sbi->s_hash_unsigned = 3;
+			} else if (!(es->s_flags &
+				     cpu_to_le32(EXT2_FLAGS_SIGNED_HASH))) {
 #ifdef __CHAR_UNSIGNED__
 				sbi->s_hash_unsigned = 3;
 #else
-- 
2.56.0.542.g3ef89b7020-goog

