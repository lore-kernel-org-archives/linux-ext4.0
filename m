Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=tuJUkoN1z1nMbOl+ufF5RMVIcVGzcwHMmtWtNp4v61F0NpLJsMuc46pgC9AJvqqcManc
	 ZgonFTiDpbk4IB50eo3AWkfucYm679LmXSNuzljlcuG1IsvYiSXnpU1zYo3Y+vLXKoFt2
	 3A3znQXdlUOvaAFckzB6H33xhJtdF3gTnJl+x1oT5K/rED9GWMRhkfzhGlJ5MPG1YEHvC
	 PLfTUOKpPStQx4+EfWsD8kLEagmfn88wZItPO838sIALJg2H+Sf7bwrA0GSXxC8zlDCB1
	 B9IL557IR5ZrAQYTRdk6GLqwQoBL+d3wWzoHfv80vj8evyWifPFo18y1B0rUsNa7ogg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qotpTPaKMT9Ao8Sx7rPTd/bQjj/67sH9x7P9ctFsfr8=;
	b=G32U7pQNggEISvpnXXr040FynpZSNesqmR6R7vtylRJI0xBMG49C/tPlSOaysZyqWwcv
	 Vth3mNQVpvP5JS3Ox9QolPVZgs1p9Sg4862YZsP0FuC7Q615ZgCPdunyVjx3y5n5Yb8YL
	 Nv8ai+8y+MfLJvzLDBhyAAv5Mhgg4G0ndw5S5reegAv56gByen8sv+ClOxzBKu6dv6pVG
	 PQ+P2sdM+bxoZpD8dBG3NbY4OFfvyuZSJ172mOiK5tkbCqibbbk4rJotjSB9CsnSFd7x2
	 StqF1CTUKQpRTtt2zMeiwY1kI38u53RQD725iwUqzjUUztzZeisL3J1MAK8Betyn9lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ScN3Fa6C;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E955A606A32A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E955A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ScN3Fa6C
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHVkx029803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115852; bh=qotpTPaKMT9Ao8Sx7rPTd/bQjj/67sH9x7P9ctFsfr8=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=ScN3Fa6Co3bRu3cXjE7hohVGEFCHeOosz1/BhXkAJfh3oB5PL8EntgJYXpV7eGf/j
	 DAbtL6B0Y1l70a2fdLVrO9FAAVOq5Nf/jhFPVdqSRLd6eOacBw8nFeif4qagAbG/4Z
	 hRlDFaIfsReNpJQWq8ZVYsabzPfM/2pMtB2nf6PmqxGjYGloKNfBDq8RBKq4r78jqK
	 3rHHqscRImEpTEfpzwN7SjofFwCGKqBCXN36wyXuAqnFkfVMSYDMLM7MzsZHj420vq
	 2sxPZNOrXpbk3saMZLVUkvlnhEW3/S1FtnjdGJ0Z9y7nZ8cKuB1pBajdHc1mF2n/yy
	 wPwweFSYKd+YA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 13A4D2E00BC; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 01/32] ext4: only validate mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set
Date: Thu, 19 Nov 2026 14:16:48 -0500
Message-ID: <20261119191719.1943298-2-tytso@mit.edu>
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

Commit 981eec6c300b ("ext4: only update tune mount options when
requested") guarded the s_mount_opts copy in ext4_sb_setparams() with
EXT4_TUNE_FL_MOUNT_OPTS, but ext4_validate_tune_sb_params() still
rejects an unterminated mount_opts string even when the caller is not
asking to change it.  A caller that tunes an unrelated field and leaves
mount_opts uninitialized can therefore get a spurious -E2BIG.

Only validate mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set, and add a
KUnit test covering both the validation and copy guards.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c      |  3 ++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index 8cdb4f7dd639..a95388a215a0 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -609,6 +609,7 @@ static void test_validate_tune_sb_params(struct kunit *test)
 
 	/* Unterminated mount_opts -> -E2BIG */
 	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_MOUNT_OPTS;
 	memset(params.mount_opts, 'a', sizeof(params.mount_opts));
 	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
 			-E2BIG);
@@ -702,6 +703,44 @@ static void test_validate_tune_sb_params(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, params.encoding_flags, 0);
 }
 
+/*
+ * Verify that s_mount_opts is only validated and rewritten when
+ * EXT4_TUNE_FL_MOUNT_OPTS is set, so that tuning an unrelated field does
+ * not wipe the mount options stored in the superblock.
+ */
+static void test_tune_sb_mount_opts_guard(struct kunit *test)
+{
+	struct ioctl_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	struct ext4_sb_info *sbi = &ctx->sbi;
+	struct ext4_super_block *es = ctx->es;
+	struct ext4_tune_sb_params params;
+
+	strscpy_pad(es->s_mount_opts, "journal_checksum");
+
+	/* Garbage in mount_opts is ignored without EXT4_TUNE_FL_MOUNT_OPTS */
+	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_ERRORS_BEHAVIOR;
+	params.errors_behavior = EXT4_ERRORS_RO;
+	memset(params.mount_opts, 'a', sizeof(params.mount_opts));
+	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			0);
+
+	/* Tuning another field leaves s_mount_opts untouched */
+	memset(params.mount_opts, 0, sizeof(params.mount_opts));
+	ext4_sb_setparams_test(sbi, es, &params);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(es->s_errors), EXT4_ERRORS_RO);
+	KUNIT_EXPECT_STREQ(test, (char *)es->s_mount_opts, "journal_checksum");
+
+	/* With EXT4_TUNE_FL_MOUNT_OPTS the new value is written */
+	params.set_flags = EXT4_TUNE_FL_MOUNT_OPTS;
+	strscpy(params.mount_opts, "nodelalloc", sizeof(params.mount_opts));
+	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
+			0);
+	ext4_sb_setparams_test(sbi, es, &params);
+	KUNIT_EXPECT_STREQ(test, (char *)es->s_mount_opts, "nodelalloc");
+}
+
 /*
  * Verify ext4_update_backup_sb, ext4_update_superblocks_fn, and
  * ext4_update_overhead across primary + 4 sparse_super backup groups (1, 3,
@@ -1179,6 +1218,7 @@ static void test_force_shutdown_and_ioctl_dispatch(struct kunit *test)
 static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_sb_callbacks_and_setparams),
 	KUNIT_CASE(test_validate_tune_sb_params),
+	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
 	KUNIT_CASE(test_immutable_dax_and_fileattr),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 83630cd40712..5fdbb5133b27 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1409,7 +1409,8 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 	struct ext4_super_block *es = sbi->s_es;
 	int enabling_casefold = 0;
 
-	if (strnlen(params->mount_opts, sizeof(params->mount_opts)) ==
+	if ((params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS) &&
+	    strnlen(params->mount_opts, sizeof(params->mount_opts)) ==
 	    sizeof(params->mount_opts))
 		return -E2BIG;
 
-- 
2.56.1.708.g77570a6a1d-goog

