Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458843;
	b=qkdCml3paE+GbyRs8JMqnAC5e2xo8tRpYKMt1S1JopI63Fc8tn04TaC3hbP2+KyPLvxS
	 aRE/pew4HeWAr13hqIJBrDVxYhAEMJu0altYHjr7Ms0EAINQIxb63ru+58t6f7wCIKmKC
	 vNgrhrOCt6M7pZ6MWWslytkcB4l3eRuekWyM5MVyOVxFuTTPxqHJ0l01dtPHCsSfn4HJJ
	 dh4ftLPbPTt0faou2tM55rT+rmbYLTe56ZYK5goDOc835W9RDcifamrnAmmCPykOApeG6
	 72toFqbkU+7ID7kZ+4a95LJnmqW8gjGTLFBUl2ZqmguTifWu/4XgT1w4wBpBkbcvfNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458843;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KGtLuqGO4EmlbYQIALfu7opBNYnoiDN+6GNWbjP39Eg=;
	b=k74zghVvQzRgHdHdqoT4BJrODgx+63FAzX9SDebRk+FCU14YkkhRl4vsnrsyv2gmJe2D
	 lJaPvVpROJcQkS/svezDFUtnbd6LQmIpplWpoASoEhePwzCDOB6TwkHoOa8qrcarougcK
	 qjUfrVzCtXFz0980uMfiXZPXZP8qO1sG/skinaEweJT0buUOWpHiztRbwzotO41tcw7Wh
	 N7MEaLgYyKydhfZQXK4YIS9ohKjOAHeMmHLfyTwJGskadT4tH1ZTPRdurFsbaGagt3BAj
	 I0/RGP/0yd+zcpA0Nrgywp6MUm8ZkMtF5P81+ZOhdzsZqaL9OC8Ob3XcnYrYT2bhXvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Oc2qVmJm;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7766606A33C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7766606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Oc2qVmJm
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lJ9A031129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458840; bh=KGtLuqGO4EmlbYQIALfu7opBNYnoiDN+6GNWbjP39Eg=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Oc2qVmJmedPO1CdODfsfqz7N2Ngpgv3YSqtGv+WvRnNZmgt6UQ3gOWiLnim1DJ19i
	 SES34KyvgVIzyC/GJ3iyR2lDN2m/KMNRhEQPlGKBvMnhCVXNemNZWM2FwJcmOXyz3Y
	 WGh9ULjPOyPOsfw35ckUXy8Rsx8s32OQFU+ECHyius4fQ2rwtmD5KBVMV6vDCXEL/D
	 5PKV9vOqd3Xs7J8iTds84Ijzd6UtoeB1CJijhtQoty1kdqYrbQo5bmvpCqboz/nQW8
	 69UAiwT/L3X4MAaT9WVOz+QLWHibN/I7uNdwZqo4MIy+G5cBK6L1L6fdEbQzrQgXOU
	 8xXNr1Mb3/v2A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2A50B2E013F; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 03/23] ext4: don't allow enabling casefold via EXT4_IOC_SET_TUNE_SB_PARAM
Date: Wed, 11 Nov 2026 23:46:52 -0500
Message-ID: <20261112044712.1577296-4-tytso@mit.edu>
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

EXT4_IOC_SET_TUNE_SB_PARAM allows setting the casefold feature (along
with s_encoding and s_encoding_flags) on a mounted file system, but it
only updates the on-disk superblock.  The in-memory state needed by
casefolding is set up exclusively at mount time:

 - sb->s_encoding is loaded by ext4_encoding_init(), so it stays NULL;
 - the casefolding dentry operations are installed before the root
   dentry is created, and can't be retrofitted onto a live dcache;
 - nothing checks for CONFIG_UNICODE, so a kernel without it can set
   a feature that then prevents the file system from being mounted.

Since ext4_has_feature_casefold() becomes true as soon as the primary
superblock is updated, userspace can then set EXT4_CASEFOLD_FL on an
empty directory, and the next lookup or create in it passes the NULL
sb->s_encoding to utf8_casefold(), crashing the kernel.

Casefolding has to be enabled while the file system is unmounted, so
stop advertising and accepting the casefold feature and the
EXT4_TUNE_FL_ENCODING{,_FLAGS} operations, and remove the code that
handled them.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 35 ++++++++++++++++++++-------------
 fs/ext4/ioctl.c      | 47 +++++++-------------------------------------
 2 files changed, 28 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index c3eee774bcfa..fab2b9f8ff35 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -522,8 +522,6 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 			   EXT4_TUNE_FL_DEF_HASH_ALG |
 			   EXT4_TUNE_FL_RAID_STRIDE |
 			   EXT4_TUNE_FL_RAID_STRIPE_WIDTH |
-			   EXT4_TUNE_FL_ENCODING |
-			   EXT4_TUNE_FL_ENCODING_FLAGS |
 			   EXT4_TUNE_FL_MOUNT_OPTS |
 			   EXT4_TUNE_FL_EDIT_FEATURES |
 			   EXT4_TUNE_FL_FORCE_FSCK;
@@ -539,8 +537,6 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 	params.def_hash_alg = DX_HASH_HALF_MD4;
 	params.raid_stride = 16;
 	params.raid_stripe_width = 128;
-	params.encoding = EXT4_ENC_UTF8_12_1;
-	params.encoding_flags = SB_ENC_STRICT_MODE_FL;
 	strscpy(params.mount_opts, "nodelalloc,noatime",
 		sizeof(params.mount_opts));
 	params.set_feature_compat_mask = EXT4_FEATURE_COMPAT_DIR_INDEX;
@@ -563,9 +559,6 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, es->s_def_hash_version, DX_HASH_TEA);
 	KUNIT_EXPECT_EQ(test, le16_to_cpu(es->s_raid_stride), 16);
 	KUNIT_EXPECT_EQ(test, le32_to_cpu(es->s_raid_stripe_width), 128U);
-	KUNIT_EXPECT_EQ(test, le16_to_cpu(es->s_encoding), EXT4_ENC_UTF8_12_1);
-	KUNIT_EXPECT_EQ(test, le16_to_cpu(es->s_encoding_flags),
-			SB_ENC_STRICT_MODE_FL);
 	KUNIT_EXPECT_STREQ(test, (char *)es->s_mount_opts,
 			   "nodelalloc,noatime");
 	KUNIT_EXPECT_NE(test,
@@ -583,8 +576,9 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 
 /*
  * Verify ext4_validate_tune_sb_params rejects malformed mount_opts, invalid
- * flags, out-of-range parameters, unsupported feature edits, and standalone
- * encoding updates, while normalizing DIR_INDEX and CASEFOLD enablement.
+ * flags, out-of-range parameters, unsupported feature edits, encoding
+ * updates and online casefold enablement, while normalizing DIR_INDEX
+ * enablement.
  */
 static void test_validate_tune_sb_params(struct kunit *test)
 {
@@ -675,20 +669,33 @@ static void test_validate_tune_sb_params(struct kunit *test)
 	KUNIT_EXPECT_FALSE(test, uuid_is_null(&uu));
 	KUNIT_EXPECT_EQ(test, sbi->s_def_hash_version, DX_HASH_HALF_MD4);
 
-	/* Encoding without CASEFOLD -> -EINVAL; with CASEFOLD -> UTF8_12_1 */
+	/* Encoding changes and online casefold enablement -> -EOPNOTSUPP */
 	memset(&params, 0, sizeof(params));
 	params.set_flags = EXT4_TUNE_FL_ENCODING;
 	params.encoding = EXT4_ENC_UTF8_12_1;
 	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
-			-EINVAL);
+			-EOPNOTSUPP);
+
+	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_ENCODING_FLAGS;
+	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			-EOPNOTSUPP);
 
 	memset(&params, 0, sizeof(params));
 	params.set_flags = EXT4_TUNE_FL_EDIT_FEATURES;
 	params.set_feature_incompat_mask = EXT4_FEATURE_INCOMPAT_CASEFOLD;
 	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
-			0);
-	KUNIT_EXPECT_EQ(test, params.encoding, EXT4_ENC_UTF8_12_1);
-	KUNIT_EXPECT_EQ(test, params.encoding_flags, 0);
+			-EOPNOTSUPP);
+
+	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_FEATURES;
+	params.feature_compat = le32_to_cpu(es->s_feature_compat);
+	params.feature_incompat = le32_to_cpu(es->s_feature_incompat) |
+				  EXT4_FEATURE_INCOMPAT_CASEFOLD;
+	params.feature_ro_compat = le32_to_cpu(es->s_feature_ro_compat);
+	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			-EOPNOTSUPP);
+	KUNIT_EXPECT_FALSE(test, ext4_has_feature_casefold(sb));
 }
 
 /*
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 37ad549ad693..8537d5766732 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1269,9 +1269,13 @@ static int ext4_ioctl_setuuid(struct file *filp,
 	EXT4_TUNE_FL_DEF_HASH_ALG | EXT4_TUNE_FL_RAID_STRIDE | \
 	EXT4_TUNE_FL_RAID_STRIPE_WIDTH | EXT4_TUNE_FL_MOUNT_OPTS | \
 	EXT4_TUNE_FL_FEATURES | EXT4_TUNE_FL_EDIT_FEATURES | \
-	EXT4_TUNE_FL_FORCE_FSCK | EXT4_TUNE_FL_ENCODING | \
-	EXT4_TUNE_FL_ENCODING_FLAGS)
+	EXT4_TUNE_FL_FORCE_FSCK)
 
+/*
+ * Casefolding can't be enabled on a mounted file system: sb->s_encoding
+ * and the casefolding dentry operations are only set up at mount time,
+ * before any dentries exist.
+ */
 #define EXT4_TUNE_SET_COMPAT_SUPP \
 		(EXT4_FEATURE_COMPAT_DIR_INDEX |	\
 		 EXT4_FEATURE_COMPAT_STABLE_INODES)
@@ -1280,8 +1284,7 @@ static int ext4_ioctl_setuuid(struct file *filp,
 		 EXT4_FEATURE_INCOMPAT_EA_INODE |	\
 		 EXT4_FEATURE_INCOMPAT_ENCRYPT |	\
 		 EXT4_FEATURE_INCOMPAT_CSUM_SEED |	\
-		 EXT4_FEATURE_INCOMPAT_LARGEDIR |	\
-		 EXT4_FEATURE_INCOMPAT_CASEFOLD)
+		 EXT4_FEATURE_INCOMPAT_LARGEDIR)
 #define EXT4_TUNE_SET_RO_COMPAT_SUPP \
 		(EXT4_FEATURE_RO_COMPAT_LARGE_FILE |	\
 		 EXT4_FEATURE_RO_COMPAT_DIR_NLINK |	\
@@ -1293,9 +1296,6 @@ static int ext4_ioctl_setuuid(struct file *filp,
 #define EXT4_TUNE_CLEAR_INCOMPAT_SUPP (0)
 #define EXT4_TUNE_CLEAR_RO_COMPAT_SUPP (0)
 
-#define SB_ENC_SUPP_MASK (SB_ENC_STRICT_MODE_FL |	\
-			  SB_ENC_NO_COMPAT_FALLBACK_FL)
-
 static int ext4_ioctl_get_tune_sb(struct ext4_sb_info *sbi,
 				  struct ext4_tune_sb_params __user *params)
 {
@@ -1376,10 +1376,6 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 	if (params->set_flags & EXT4_TUNE_FL_RAID_STRIPE_WIDTH)
 		es->s_raid_stripe_width =
 			cpu_to_le32(params->raid_stripe_width);
-	if (params->set_flags & EXT4_TUNE_FL_ENCODING)
-		es->s_encoding = cpu_to_le16(params->encoding);
-	if (params->set_flags & EXT4_TUNE_FL_ENCODING_FLAGS)
-		es->s_encoding_flags = cpu_to_le16(params->encoding_flags);
 	if (params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS)
 		strscpy_pad(es->s_mount_opts, params->mount_opts);
 	if (params->set_flags & EXT4_TUNE_FL_EDIT_FEATURES) {
@@ -1411,7 +1407,6 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	int enabling_casefold = 0;
 
 	if ((params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS) &&
 	    strnlen(params->mount_opts, sizeof(params->mount_opts)) ==
@@ -1482,20 +1477,6 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 			~le32_to_cpu(es->s_feature_incompat);
 		params->set_feature_ro_compat_mask &=
 			~le32_to_cpu(es->s_feature_ro_compat);
-		if (params->set_feature_incompat_mask &
-		    EXT4_FEATURE_INCOMPAT_CASEFOLD) {
-			enabling_casefold = 1;
-			if (!(params->set_flags & EXT4_TUNE_FL_ENCODING)) {
-				params->encoding = EXT4_ENC_UTF8_12_1;
-				params->set_flags |= EXT4_TUNE_FL_ENCODING;
-			}
-			if (!(params->set_flags &
-			      EXT4_TUNE_FL_ENCODING_FLAGS)) {
-				params->encoding_flags = 0;
-				params->set_flags |=
-					EXT4_TUNE_FL_ENCODING_FLAGS;
-			}
-		}
 		if (params->set_feature_compat_mask &
 		    EXT4_FEATURE_COMPAT_DIR_INDEX) {
 			uuid_t uu;
@@ -1519,20 +1500,6 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 			}
 		}
 	}
-	if (params->set_flags & EXT4_TUNE_FL_ENCODING) {
-		if (!enabling_casefold)
-			return -EINVAL;
-		if (params->encoding == 0)
-			params->encoding = EXT4_ENC_UTF8_12_1;
-		else if (params->encoding != EXT4_ENC_UTF8_12_1)
-			return -EINVAL;
-	}
-	if (params->set_flags & EXT4_TUNE_FL_ENCODING_FLAGS) {
-		if (!enabling_casefold)
-			return -EINVAL;
-		if (params->encoding_flags & ~SB_ENC_SUPP_MASK)
-			return -EINVAL;
-	}
 
 	return 0;
 }
-- 
2.56.0.542.g3ef89b7020-goog

