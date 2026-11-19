Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=AQyW0ALld+Y4T+qpIOnBN7O1xL8DiAwoDH/V1X6x4QswxDuk4DcQVvoFy034M1HxQFnT
	 YB12tmeh/J3ertqbPoWp8u/5mqFWWv7GiiLufcRdZu1oPC3mTGkhXIb+evUim/PhtAURb
	 Ik6zzmEexsHWDgM9xlbzQP78nvQ780aYjQFpeIjFDhEnN9+HgutIGcl9U/33V+H8ieGfR
	 ox/A0apTGwnj1s732ThhrLnjMmYMhcvYNmoEJtZoXZ3MjDGtNzZzJXzH0qVMJk0chxYw9
	 ievb73TbkFkJKGCZCU9S7kkMebgcVEAgHl6WupfLhK53tyD9zovpuqJq1VLK0PElQ6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AZRK7Vsw23riUz2hpcfuYi3BRmUNnzIYaC8OWieOziY=;
	b=Fm6zrSaENRdYrPpoDkkitAIO1LYxDdeEXr2Opej8lHtyrn1cTSmfS/cl+I3VoxpMoFtc
	 QopSMlRPlaUCEIGw8He5YeFrOb8pWeHMtkMZwCEQsrWbCrXKtnBH0zND5UMB72Eer39HV
	 aS40zWq3kXejOVNzErUeZlfAWrgfnsjAp2VvflMct3/YJvPVAe6wj0jMBwCBrz6lf7Zhu
	 YOAOxE3MagiylK5dgtiC1/fM43mH1TJPrqEYMLwzxgJp5YOvdbcpqVyyqU5+KXDGyGGGl
	 ra37Cv7i6pGjNpMqABPVb2HG4HsoT/835fMFE6SZuAcs78FcRcruw1ojiCd7DZ4rADQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cCBZS0Mw;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F8C606A32F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4F8C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cCBZS0Mw
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHW5o029851
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=AZRK7Vsw23riUz2hpcfuYi3BRmUNnzIYaC8OWieOziY=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=cCBZS0Mwaf7iWFHljrypkguiKrbWr70DE6th/Qo8j6bf68j636d9YWdtcPeFmv2oi
	 oAr3QEyh20oypXNPhOGsetzfYQFc4plRR8Tl5fu5j/UtJ83qmEzq1x6KLEju5wW6n0
	 DVV7x64YZmnPZEiT+RbYy6mPwkXIFMkZWdrd5mrLJKlAKZ30i5Sxx8sGvVipj2Iowp
	 Jnrzxk4dS8wwQ96NtKA5KOQQU/KCokGUXADtXhTtW36RMi+/suY6ef8FVTZn+nibC8
	 mPSR7rWQmpTUnN4VX4gxfV4iQVVQlTSXHlSyP6H0P5B86UfKBJ+V91wnkBqBoAx1Ig
	 hdwXXNt20nV0w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 212802E0147; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 05/32] ext4: enforce feature prerequisites when tuning a mounted fs
Date: Thu, 19 Nov 2026 14:16:52 -0500
Message-ID: <20261119191719.1943298-6-tytso@mit.edu>
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

EXT4_IOC_SET_TUNE_SB_PARAM lets userspace enable a number of features
on a mounted file system, but it skips prerequisites that are
otherwise enforced when the file system is mounted (or by tune2fs),
leading to corrupted metadata or file systems that can no longer be
mounted read-write:

 - metadata_csum_seed: ext4_sb_setparams() stores sbi->s_csum_seed in
   s_checksum_seed, but that is only initialized when metadata_csum
   (or ea_inode) is enabled; otherwise a zero seed is written.
   tune2fs likewise requires metadata_csum for this feature.

 - ea_inode: EA inode hashes are seeded with sbi->s_csum_seed, which
   is zero unless metadata_csum or csum_seed was enabled at mount
   time.  After a remount the seed is computed from the UUID, so all
   EA inodes written before the remount fail hash verification.  The
   feature is also refused at mount time in Hurd compat mode.

 - encrypt: ext4 disables large folios at mount time when encryption
   is enabled, since fscrypt can't handle them.  Enabling it online
   while large folios are in use lets new encrypted files use large
   folios, tripping VM_BUG_ON_FOLIO() in
   fscrypt_encrypt_pagecache_blocks().

 - project: a kernel built without CONFIG_QUOTA and CONFIG_QFMT_V2
   refuses to mount a file system with this feature read-write.
   Project ids (like the fields covered by extra_isize) also need
   inodes larger than 128 bytes; tune2fs refuses to enable project
   quotas otherwise.

Reject these cases with -EINVAL or -EOPNOTSUPP, and when ea_inode is
enabled on a file system without metadata_csum or csum_seed, compute
sbi->s_csum_seed the same way the next mount will.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 95 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c      | 42 ++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index b564178b7d77..bcc150a83d8f 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -807,6 +807,100 @@ static void test_tune_sb_dir_index_hash_state(struct kunit *test)
 			EXT2_FLAGS_UNSIGNED_HASH);
 }
 
+static int ioctl_test_set_features(struct super_block *sb, u32 incompat,
+				   u32 ro_compat)
+{
+	struct ext4_tune_sb_params params;
+
+	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_EDIT_FEATURES;
+	params.set_feature_incompat_mask = incompat;
+	params.set_feature_ro_compat_mask = ro_compat;
+	return ext4_validate_tune_sb_params_test(sb, &params);
+}
+
+/*
+ * Verify that features whose prerequisites are otherwise only enforced at
+ * mount time are rejected when they can't be satisfied, and that enabling
+ * ea_inode online initializes the checksum seed used for EA inode hashes.
+ */
+static void test_tune_sb_feature_prereqs(struct kunit *test)
+{
+	struct ioctl_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	struct ext4_sb_info *sbi = &ctx->sbi;
+	struct ext4_super_block *es = ctx->es;
+	u32 seed = ext4_chksum(~0, es->s_uuid, sizeof(es->s_uuid));
+	int expected;
+
+	/* csum_seed requires metadata_csum */
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb,
+					EXT4_FEATURE_INCOMPAT_CSUM_SEED, 0),
+			0);
+
+	/* ea_inode is refused in Hurd compat mode */
+	set_opt2(sb, HURD_COMPAT);
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb,
+					EXT4_FEATURE_INCOMPAT_EA_INODE, 0),
+			-EINVAL);
+	clear_opt2(sb, HURD_COMPAT);
+
+	/* encrypt is refused while large folios are in use */
+	sbi->s_max_folio_order = 2;
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb,
+					EXT4_FEATURE_INCOMPAT_ENCRYPT, 0),
+			-EOPNOTSUPP);
+	sbi->s_max_folio_order = 0;
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb,
+					EXT4_FEATURE_INCOMPAT_ENCRYPT, 0),
+			0);
+
+	/* project needs quota support and large inodes */
+	expected = IS_ENABLED(CONFIG_QUOTA) && IS_ENABLED(CONFIG_QFMT_V2) ?
+		   0 : -EOPNOTSUPP;
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb, 0,
+					EXT4_FEATURE_RO_COMPAT_PROJECT),
+			expected);
+
+	ext4_clear_feature_extra_isize(sb);
+	es->s_inode_size = cpu_to_le16(EXT4_GOOD_OLD_INODE_SIZE);
+	sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb, 0,
+					EXT4_FEATURE_RO_COMPAT_PROJECT),
+			-EINVAL);
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb, 0,
+					EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE),
+			-EINVAL);
+	es->s_inode_size = cpu_to_le16(IOCTL_TEST_INODE_SIZE);
+	sbi->s_inode_size = IOCTL_TEST_INODE_SIZE;
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb, 0,
+					EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE),
+			0);
+
+	/* Without metadata_csum, csum_seed is refused ... */
+	ext4_clear_feature_metadata_csum(sb);
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb,
+					EXT4_FEATURE_INCOMPAT_CSUM_SEED, 0),
+			-EINVAL);
+
+	/* ... and enabling ea_inode sets up the checksum seed */
+	sbi->s_csum_seed = 0;
+	KUNIT_EXPECT_EQ(test,
+			ioctl_test_set_features(sb,
+					EXT4_FEATURE_INCOMPAT_EA_INODE, 0),
+			0);
+	KUNIT_EXPECT_EQ(test, sbi->s_csum_seed, seed);
+}
+
 /*
  * Verify ext4_update_backup_sb, ext4_update_superblocks_fn, and
  * ext4_update_overhead across primary + 4 sparse_super backup groups (1, 3,
@@ -1332,6 +1426,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_validate_tune_sb_params),
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_tune_sb_dir_index_hash_state),
+	KUNIT_CASE(test_tune_sb_feature_prereqs),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 2d985ac5e222..4ccdf98ed7a0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1491,6 +1491,48 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 			~le32_to_cpu(es->s_feature_incompat);
 		params->set_feature_ro_compat_mask &=
 			~le32_to_cpu(es->s_feature_ro_compat);
+
+		/*
+		 * Reject features whose prerequisites are otherwise only
+		 * checked at mount time.  The checksum seed must already be
+		 * initialized from metadata_csum, ea_inode is unsupported
+		 * in Hurd compat mode, encryption is incompatible with
+		 * large folios, and project quotas / extra_isize need
+		 * large inodes (and project quotas need quota support).
+		 */
+		if ((params->set_feature_incompat_mask &
+		     EXT4_FEATURE_INCOMPAT_CSUM_SEED) &&
+		    !ext4_has_feature_metadata_csum(sb))
+			return -EINVAL;
+		if ((params->set_feature_incompat_mask &
+		     EXT4_FEATURE_INCOMPAT_EA_INODE) &&
+		    test_opt2(sb, HURD_COMPAT))
+			return -EINVAL;
+		if ((params->set_feature_incompat_mask &
+		     EXT4_FEATURE_INCOMPAT_ENCRYPT) &&
+		    sbi->s_max_folio_order)
+			return -EOPNOTSUPP;
+		if ((params->set_feature_ro_compat_mask &
+		     (EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE |
+		      EXT4_FEATURE_RO_COMPAT_PROJECT)) &&
+		    EXT4_INODE_SIZE(sb) <= EXT4_GOOD_OLD_INODE_SIZE)
+			return -EINVAL;
+		if ((params->set_feature_ro_compat_mask &
+		     EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+		    (!IS_ENABLED(CONFIG_QUOTA) || !IS_ENABLED(CONFIG_QFMT_V2)))
+			return -EOPNOTSUPP;
+
+		/*
+		 * ea_inode hashes use s_csum_seed, which is only computed
+		 * at mount time if metadata_csum or csum_seed is enabled.
+		 * Initialize it the same way the next mount will.
+		 */
+		if ((params->set_feature_incompat_mask &
+		     EXT4_FEATURE_INCOMPAT_EA_INODE) &&
+		    !ext4_has_feature_metadata_csum(sb) &&
+		    !ext4_has_feature_csum_seed(sb))
+			sbi->s_csum_seed = ext4_chksum(~0, es->s_uuid,
+						       sizeof(es->s_uuid));
 		if (params->set_feature_compat_mask &
 		    EXT4_FEATURE_COMPAT_DIR_INDEX) {
 			uuid_t uu;
-- 
2.56.1.708.g77570a6a1d-goog

