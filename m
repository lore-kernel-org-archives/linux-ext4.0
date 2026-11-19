Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=adcVF2ZALn95Bb2SuIRxhRkj2lW7P/qcPDSpTkdycB6YyBtdzWy01h1sDTEvSdF8mCny
	 j3gbWXgTa9C9XH63A18hYobHpdcWJI7X/VvXDMOj3yvw/NGjidw2vsikDKjhqoRgFAfch
	 zTbQR4pb0E2C5Jiu7XbWXNeYrJH/+FZ3RtwYksv1Y08zdw6oyQ9caQNCD0AU3Hq9kq+m3
	 IU6iDDyPMJKpLMfB1vtJidZjgA6bQPy9LXkhEi9vlv2jUlG1CH6vN+Qxzk5BL1WtI6p8d
	 Wo0Gf6oNjNB4b//r5M4uyGeccetF3C9iSVIraDchy4ZUhJbE64xtNqVtg0ReTBQRfig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eSoWiu46jvIPRqbQipYB5l7p1e7eduLbKoDObVe7YfE=;
	b=pnZ0ePo0w8v5inCdpe3nM64YNf48N9kl9o606FicCSIsmU7ZemPiNucABHGLuFwSYqFr
	 qMbXrVoUedU0fw2zpQJhkAbP2sMTz3ZA7WF2rDr7qd3qRlm0YIZ0NR9s4T0SWNPhVyZEt
	 VWvEpNuiVI87QxUtSpvsV5Rfa5VYK9AXiPnMGATBhEcDePcGHyaASXgb0UJ0pfRfP3bXB
	 xrmEWO8z4d234yFUaLL7IU4hhTQv/0W2xcLyypaaPRaRAOnWkrN3bB7ZbCnj8ZycPz9a6
	 mYtJJ0b9NAc5j7uAwnYna4BH1wydNHUQ/QX8L4PwBQhCYnVXBwBnH27g9KJiGpbirXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="L/B+RpPH";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86983606A32C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86983606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=L/B+RpPH
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHVFb029801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115852; bh=eSoWiu46jvIPRqbQipYB5l7p1e7eduLbKoDObVe7YfE=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=L/B+RpPHLuaID0e4xjPFCFhCPLO9YFOCNSxboJG6kGsfjYRw0BPxfcX1mDQRN01oe
	 3wKfPpyKFVgeQHYz7xbMbwhcbbV6BRzZFmysH8DbwGU6srs0UrN33WK4C3TgS+7mUI
	 wlShUrgxL92kJhmsLYBpqnkUDs/cmKt9m2bR1Mj55fIOXCkoe0gy9noxM5+rKKJlJ7
	 i7YFQyz4iO3JpE5ScPt6UcwRsGLmRhYZWJJy5mhgdVEQAwEgrRsutA6L0wYyaG5Wly
	 jBEoxN5/Ynen/qurFUj+0kENn9Ld18KbyZOXlHuY8j4J7Vk2ljxQhWt45cAa10q7pH
	 p2gc0plveq8pg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1AB102E013F; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 03/32] ext4: don't allow enabling casefold via EXT4_IOC_SET_TUNE_SB_PARAM
Date: Thu, 19 Nov 2026 14:16:50 -0500
Message-ID: <20261119191719.1943298-4-tytso@mit.edu>
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
index bc5e4f26ee14..4e4a2abd5189 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -534,8 +534,6 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 			   EXT4_TUNE_FL_DEF_HASH_ALG |
 			   EXT4_TUNE_FL_RAID_STRIDE |
 			   EXT4_TUNE_FL_RAID_STRIPE_WIDTH |
-			   EXT4_TUNE_FL_ENCODING |
-			   EXT4_TUNE_FL_ENCODING_FLAGS |
 			   EXT4_TUNE_FL_MOUNT_OPTS |
 			   EXT4_TUNE_FL_EDIT_FEATURES |
 			   EXT4_TUNE_FL_FORCE_FSCK;
@@ -551,8 +549,6 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 	params.def_hash_alg = DX_HASH_HALF_MD4;
 	params.raid_stride = 16;
 	params.raid_stripe_width = 128;
-	params.encoding = EXT4_ENC_UTF8_12_1;
-	params.encoding_flags = SB_ENC_STRICT_MODE_FL;
 	strscpy(params.mount_opts, "nodelalloc,noatime",
 		sizeof(params.mount_opts));
 	params.set_feature_compat_mask = EXT4_FEATURE_COMPAT_DIR_INDEX;
@@ -575,9 +571,6 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, es->s_def_hash_version, DX_HASH_TEA);
 	KUNIT_EXPECT_EQ(test, le16_to_cpu(es->s_raid_stride), 16);
 	KUNIT_EXPECT_EQ(test, le32_to_cpu(es->s_raid_stripe_width), 128U);
-	KUNIT_EXPECT_EQ(test, le16_to_cpu(es->s_encoding), EXT4_ENC_UTF8_12_1);
-	KUNIT_EXPECT_EQ(test, le16_to_cpu(es->s_encoding_flags),
-			SB_ENC_STRICT_MODE_FL);
 	KUNIT_EXPECT_STREQ(test, (char *)es->s_mount_opts,
 			   "nodelalloc,noatime");
 	KUNIT_EXPECT_NE(test,
@@ -595,8 +588,9 @@ static void test_sb_callbacks_and_setparams(struct kunit *test)
 
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
@@ -687,20 +681,33 @@ static void test_validate_tune_sb_params(struct kunit *test)
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
index 78be111606e7..228afe4bc26b 100644
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
@@ -1413,7 +1409,6 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	int enabling_casefold = 0;
 
 	if ((params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS) &&
 	    strnlen(params->mount_opts, sizeof(params->mount_opts)) ==
@@ -1484,20 +1479,6 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
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
@@ -1521,20 +1502,6 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
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
2.56.1.708.g77570a6a1d-goog

