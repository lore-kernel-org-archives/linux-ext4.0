Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458848;
	b=rPQ9QPajRj2kP5PLIRvmAb9GdY81wDc6XlobB7vx76hfEIxemn5A4/C9qOipDLcSz9er
	 ufU+P/7YuiJI3qHMGmNY7R0HlLPRw0WqeufaPc3+YfYUj+wXsMk3fy4C2Xn15aAi0bMLM
	 a+hp6XWih2WhmhK8qGL/J9KxKVsGpV+EbeZ4nRwPfdhtiPH/J9LdXMaU5q3t5eAG8GMe7
	 lDE6dfaXlaA+XLzF1CHClN9hW8UbEWPhuAFZC5+4tG+8nXuG9MTGCd+/y3w15S0uwTPEd
	 9k/kACn3Qp7tvFKt7hycnjDM7aQca1bZHcPg/lBrlKFuTrnz80kYDaZB6sG9+WnMPFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458848;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oAQT9RmKXsIABdopwZj5iIqugOgYbU4TLEkA7mQd9TI=;
	b=aHjabD4oSmitfujK2CtE8V9rZHCh5D+LPUZSadS8Yfr9Nmwsh5deiOiKpUjrh4HRLuYl
	 1GDvfixDQNv7k8KwlRyBzmXz3cQrUPWy2H7YQEue7vl7rT8cFKRpVOB09T5651zJqvSR6
	 Fy+qk0+wABVEwHs4Y3qDX69J4U4198AQUwUUcpFYIsetBbNjB4OLhHQmgn1NQSmUm/QEJ
	 mXa1lNtD7dPUJwRkPabS0jJNvza9YiOPqdSaSXYJT9ISJ1raUhIvIfWc8oyBqMMy84Hoh
	 yju9RjuMRA7SLHsxr0sKONUNqrgDB1G+w1dTtcypX6FvojFc3nhcXqOx9P9XNjnTJEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cp2tNdwb;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEC560A381D
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CEC560A381D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cp2tNdwb
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lJPb031127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458840; bh=oAQT9RmKXsIABdopwZj5iIqugOgYbU4TLEkA7mQd9TI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=cp2tNdwbLRuYFrrIXq+cPvnBKTCAwrTiNVAa9owad2XC/NN3UoY05TlI7FYpmHMmP
	 P1uQPKH1wi1R0UOK1cdhbinXBUBUB/T0+024YGcf7n8Y09X3hAhjEX4XAzH6cE387X
	 PGjZS+wphx/u8zx63licJMu1Z7MzVHXfO0916PHtvOA1mJ5lDTeAR/VguXkTNiNuGr
	 E+O3GsrXD6wCNpWSjkg9+l6LYEUk30itMmi2Vfzd4tjeMF7S7vu42pt0DOVI05A15+
	 MMB+rLiMBfphgzQk0xKEoF3CAO5cETKWVnmH1+FfTT176XeIeTLFQiIjZUVl7XjdP0
	 VY5ZRCm0X59VQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2392E2E00B9; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 01/23] ext4: only update s_mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set
Date: Wed, 11 Nov 2026 23:46:50 -0500
Message-ID: <20261112044712.1577296-2-tytso@mit.edu>
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

Every field written by ext4_sb_setparams() is guarded by its
EXT4_TUNE_FL_* bit in params->set_flags, except for s_mount_opts,
which is unconditionally overwritten with params->mount_opts.
Likewise, ext4_validate_tune_sb_params() rejects an unterminated
mount_opts string even when the caller is not asking to change it.

As a result, any EXT4_IOC_SET_TUNE_SB_PARAM call that tunes an
unrelated field (e.g. errors behavior or the reserved block count)
with a zeroed mount_opts silently wipes the default mount options
stored in the primary and all backup superblocks, and a caller that
leaves mount_opts uninitialized can get a spurious -E2BIG or have
stack garbage written into the superblock.

Only validate and copy mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is
set.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c      |  6 ++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index fa31a9cc5d92..ebe4a87f17e1 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -597,6 +597,7 @@ static void test_validate_tune_sb_params(struct kunit *test)
 
 	/* Unterminated mount_opts -> -E2BIG */
 	memset(&params, 0, sizeof(params));
+	params.set_flags = EXT4_TUNE_FL_MOUNT_OPTS;
 	memset(params.mount_opts, 'a', sizeof(params.mount_opts));
 	KUNIT_EXPECT_EQ(test, ext4_validate_tune_sb_params_test(sb, &params),
 			-E2BIG);
@@ -690,6 +691,44 @@ static void test_validate_tune_sb_params(struct kunit *test)
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
@@ -1150,6 +1189,7 @@ static void test_force_shutdown_and_ioctl_dispatch(struct kunit *test)
 static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_sb_callbacks_and_setparams),
 	KUNIT_CASE(test_validate_tune_sb_params),
+	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
 	KUNIT_CASE(test_immutable_dax_and_fileattr),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 61e59c30e761..286f4a3e459a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1374,7 +1374,8 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 		es->s_encoding = cpu_to_le16(params->encoding);
 	if (params->set_flags & EXT4_TUNE_FL_ENCODING_FLAGS)
 		es->s_encoding_flags = cpu_to_le16(params->encoding_flags);
-	strscpy_pad(es->s_mount_opts, params->mount_opts);
+	if (params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS)
+		strscpy_pad(es->s_mount_opts, params->mount_opts);
 	if (params->set_flags & EXT4_TUNE_FL_EDIT_FEATURES) {
 		es->s_feature_compat |=
 			cpu_to_le32(params->set_feature_compat_mask);
@@ -1406,7 +1407,8 @@ static int ext4_validate_tune_sb_params(struct super_block *sb,
 	struct ext4_super_block *es = sbi->s_es;
 	int enabling_casefold = 0;
 
-	if (strnlen(params->mount_opts, sizeof(params->mount_opts)) ==
+	if ((params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS) &&
+	    strnlen(params->mount_opts, sizeof(params->mount_opts)) ==
 	    sizeof(params->mount_opts))
 		return -E2BIG;
 
-- 
2.56.0.542.g3ef89b7020-goog

