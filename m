Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=0RZW3cuKDx7kmbJa6e8znPeIkTpinJPdGK6ldo6himo/HZyc9fLaQTRza2K0ib0rzb9z
	 3AKHKE/FW3dfTLffno0smry2UMslRVlhtozWyUIreWbmZDH+Uopc5lcGbI6BhH88LDahA
	 xoMkZpQYrL5dGhU0qrmcxhUH63hMrjric5ZbriEHeAeCZZCRW9Bvi98jpalGR0+gbmXm2
	 pDAW1ZVndiBqBIHIdy4eRvhc5gCr0SwWI6Twxq+pklmA+pz8tqtkQcSRvRO2DH3TsybZI
	 s6X7u9U8hG8vXPZY7K5vkGArxYDL8P22JTwGOWkZ9qzajsQL/P+u3YqmWSu9CzvPZBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o3XKI8i908VKkeetL/DAar4dDIvKFbOtTV96EVPtR1M=;
	b=LUPdBDR4RfDs6cA9cFp9YX/rK3QtH9eKue6GabbaoH87BGoX1a89DYysFaJ6Urpbf/un
	 rxpKertHGDU0WTxNv6AtbJeuHZOHlDz/qsJsB65q8fTeRxWtGycvk5DdBiNLL3h/GA7Va
	 gT2vY0gKY2tI3Bl0qtzxB5eLA10F/8Bgv/hEZ7U+7dwjOgsKs2hzr9LAUCJEn1mvunwGR
	 jJuIFexlw7Bit8w8KZRjcFU3HIoEnFD9DSh1bEO5QjJKZm5lbII/Uc75AS9t4/MQxnwLo
	 Hoq81aAKBK7psd/TUEDEt5lbfgrEucyQRkIy0xnd82VotMC1/sy1rwhOi+EjKYlEvTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=pw+HaD4I;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E945F606A326
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E945F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=pw+HaD4I
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHVeE029821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115852; bh=o3XKI8i908VKkeetL/DAar4dDIvKFbOtTV96EVPtR1M=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=pw+HaD4I1RrBwrDUWv3j+falEW1C9dogO23fO1UcYT87ce1ebsputZJYcu0L0BuJ7
	 q/Oh3PLS/FHpaamSelc1HN8vqkbIvKYbTLcKOYRYRIeNFToOpzw9WnP1qXof0nDkZ7
	 8Md/bsIhtpKkthsN7ysSfhutsPT/bUHsYMNbKUqSLqdxAXYM+sssfiFHt/7WZQlIZ9
	 pdK72TquQ1GIeyxkhVZs7YGm4uQbo4VmmPe0KnVxhwX7l0ot0nfbtv0G5XAaJPtONz
	 TFXLrhIQaor9DgeA0W3Zc803yZW1etFpHD/W40pNmfP/vYWbWKtz66ccDO7cH72HAG
	 110zsgnDqKtsg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1DB232E0146; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 04/32] ext4: persist the htree hash seed when enabling dir_index online
Date: Thu, 19 Nov 2026 14:16:51 -0500
Message-ID: <20261119191719.1943298-5-tytso@mit.edu>
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
index 4e4a2abd5189..b564178b7d77 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -748,6 +748,65 @@ static void test_tune_sb_mount_opts_guard(struct kunit *test)
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
@@ -1272,6 +1331,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_sb_callbacks_and_setparams),
 	KUNIT_CASE(test_validate_tune_sb_params),
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
+	KUNIT_CASE(test_tune_sb_dir_index_hash_state),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 228afe4bc26b..2d985ac5e222 100644
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
@@ -1490,10 +1502,11 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
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
2.56.1.708.g77570a6a1d-goog

