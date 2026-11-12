Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458845;
	b=YgAFLSZCIKqnLdpVWHuPdl3Z54+IF2WetPHoATycCQQHntvt8Z4gUuzqkgWCHYxFxVkS
	 BUlXgk2Iz/FMsRQhUwyWjv7CW3qokCRbWLi92fYU98eLq6yXjHDK08eVTj//s3L0s75Zo
	 iMv4D1g/+oltFZtyyBhCSY55IHB0OekaKHVuKMNIfUUz5H6fjBCt+x0G5AUkI1TprhmKH
	 ZL2Wsz90544VYU6fS/WOgO3uDnYk9zZuFJaI1fxjBN6n1jGAzO7uUL9yVdfF6BY7FawCv
	 NTPKUaJiydn3wJd4ijTT0eGpE0oqTCJZW9jAxNkBA2PvZTD+2oEItY2bbgqFGa4Zt6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458845;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8wzny8rhaO4zn7b+p44yqSUU+cfomZmeyN8I8yEZCT0=;
	b=blaMipytMXsa1rJrpfWLzeIZZ74o8BqFs2/KfuwNCO8MA2EBzr5UXGTLkp2ZyPy7fnI+
	 Ig56Mq1deFMMQw8x/j8bUyZ1stDnKWMWFR7Dsor2DGmUFfdv+xYVJofwBcIX5LPFXCVpd
	 NttQzwVbyqiMmO9m92nMsZDuccx4yUPPEHTT+TJJDbmqsr4cfVasq56LInWR6Z3RaUwbV
	 kTpwreIqFgv7OiRH4hmwhydrgJhtkT1Wj3LWYlqqxYfL7eCDIYz2zUs6t1ae10JZEY88u
	 0CJkUSr/XN3kDw44wXean6Uk+6z1UByQc5YgxoTlIqkJHobTRG/VmjCrSNIgdDYp2Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fmGs2ix2;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F81606A33A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83F81606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fmGs2ix2
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lK87031179
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=8wzny8rhaO4zn7b+p44yqSUU+cfomZmeyN8I8yEZCT0=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=fmGs2ix2HWO84HKaPYfHCX7FVfEn4ejHBrf+z7LMzMfXDZmZrTm2wquT1Qdc7D6R2
	 +gthWlXBiKKKg82i7KM+xTq+WQEQX6N5H1ihoL+QYajKnl72Y0NMOv5EMD5hx21k+h
	 xYm/Rvh6saaSFmMvl1TctdMVT+XgLucXcRDG3YqLu4rBdBV4wRMOyFKDoAp6Fa6hvV
	 Cw/j0KLbZ/IZJPdduAcWHYZptoLGKRtD0DODeikuy4UTYUt82Wsk0187lhHdc0NcS8
	 eETA8U7TfZeogON2YgFUM2N2wHlq+J9NV7hygdp77MS7I1oDt1xRRqmV4LhNkz144n
	 WNU54mFyHZ8bQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 304282E0147; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 05/23] ext4: enforce feature prerequisites when tuning a mounted fs
Date: Wed, 11 Nov 2026 23:46:54 -0500
Message-ID: <20261112044712.1577296-6-tytso@mit.edu>
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
index 4641ba7b31ff..fd7b4ff2cd81 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -795,6 +795,100 @@ static void test_tune_sb_dir_index_hash_state(struct kunit *test)
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
@@ -1303,6 +1397,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_validate_tune_sb_params),
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_tune_sb_dir_index_hash_state),
+	KUNIT_CASE(test_tune_sb_feature_prereqs),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e2a5713a4562..8bd4958217e0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1489,6 +1489,48 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
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
2.56.0.542.g3ef89b7020-goog

