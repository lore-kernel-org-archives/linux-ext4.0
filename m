Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115863;
	b=4DqsryJGy7K+VW5cV4VdWNB4kAPF1y2eLxs56dUBN4khTahk+AfCkhY27xHL5e+3wfuL
	 QnNedAYgFH3QjIEUap3Bs1tmOcPCM1Xz6DTo1haW9t7giPkTfIJ/Gtma71wTKbYuFFxJI
	 Bw8Ev0zyIu41TFdIFdMfxP73cTx6LdOqBeelE/h1BVGxRuUk+jcimQNdF8QmlM4zlbPmU
	 G0B3syLzxdi3v2Q31z3y4/Ro2Ct1tnz5Q6x7rnYgpEO3FnAFG0qqZRSa8BDKcSB62y8Bo
	 Yepn4ceZZMmG8GMAJIqGSrxE9+mRk/E2Zd9ratjxPdS4b9wq74PpX6YCv4W3F6pmH0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Jz9rszTLzhWPmROxLJCIwlTIYzff+l7u7mPH84e4rUk=;
	b=evegs4ORJQ+Ulxgu3x+AJ7XXBPfOA5H7nc78GHYqgHChBdBNGp3tjZhHGMkmZyLliXos
	 FiT01e2IodPP65Ju3qxHzWwYhxOx9GJ9FfXm/090ASChParrlKRTvViFZyAxecUlTISCP
	 Gx5Jjz9mPAFoNbX1um+3IXguI/SaRXgxrk/W2tPrwyym9VGV/MYx/dfbtHMT5pevemhoy
	 T+GBPM4XHZ70I3q0yVZwAPE4UqnroGFtWLBCgJ7ygQnMrIjFqceyiwfBuRNET96y4mxtr
	 LgX+10ALW60CVbkFgu1a6YvbK9rE9WJU1W9OlqLes7a/jGr8FwaxqkgPpyWiTPoWOmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=VeRdYFSv;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06B606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A06B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=VeRdYFSv
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYeJ030003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=Jz9rszTLzhWPmROxLJCIwlTIYzff+l7u7mPH84e4rUk=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=VeRdYFSv9/wzyJKh14qRrMKULFYZV8EA7uZMW+CTP30QVBLr1yWZOIWIupq2KFyrZ
	 0pnfCJvsOhgCkoxIy4cr819W14F1lEu90IcoGMEFlkmA2dpBjtLa6uGlvXOEx/orVC
	 OyfP2f9mE2vnYczgGaFLk7gwbXl+mvtDNO3hBI5DHwLhvgFvPg8t0rw3aqLSkLyusa
	 4289kIgBh+EMrAgruSMikWc/8Y+m2O9AbZtDKJXvDbfionFjRHnlZy+zTPiuyTgvip
	 ppgFxR6rB4/tU9kZorHy12F8To6D/yHFZtS5Ck4Gw0f+p2EJgyxP2pc0TU7tSGgbtt
	 bNRbIRudUBx7g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 6ED672E0162; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 29/32] ext4: reject atomic writes split by fscrypt without warning
Date: Thu, 19 Nov 2026 14:17:16 -0500
Message-ID: <20261119191719.1943298-30-tytso@mit.edu>
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

In ext4_iomap_begin(), map.m_len is clamped by fscrypt_limit_io_blocks()
before the IOMAP_ATOMIC length check.  For an encrypted inode using
IV_INO_LBLK_32, an unprivileged user issuing a multi-block atomic write
across a 32-bit DUN wraparound causes fscrypt_limit_io_blocks() to shorten
map.m_len below length >> blkbits, triggering WARN_ON_ONCE(1).

Check fscrypt_limit_io_blocks() for IOMAP_ATOMIC before allocating blocks
and return -EINVAL cleanly without warning if the write would have to be
split.  Also move the existing WARN_ON_ONCE(1) check on ext4's own mapping
length ahead of fscrypt_limit_io_blocks() and handle any post-mapping
truncation cleanly with -EINVAL.

Add an ext4_fscrypt_limit_io_blocks() wrapper with a KUnit static stub
redirect and extend inode_test_iomap_and_atomic_writes() in
fs/ext4/inode-test.c to cover both checks and non-atomic truncation.

Fixes: b86629c2b299 ("ext4: Add multi-fsblock atomic write support with bigalloc")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h       |  2 ++
 fs/ext4/inode-test.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c      | 36 +++++++++++++++++++-----
 3 files changed, 97 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 22500ade662b..ab94c7aea691 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3361,6 +3361,8 @@ struct buffer_head *ext4_sb_find_get_block(struct super_block *sb,
 					   ext4_fsblk_t block);
 struct buffer_head *ext4_sb_getblk_unmovable(struct super_block *sb,
 					     ext4_fsblk_t block);
+u64 ext4_fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
+				 u64 nr_blocks);
 #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
 int ext4_inode_csum_verify_test(struct inode *inode, struct ext4_inode *raw,
 				struct ext4_inode_info *ei);
diff --git a/fs/ext4/inode-test.c b/fs/ext4/inode-test.c
index 5671e674cffa..cf0c3859517f 100644
--- a/fs/ext4/inode-test.c
+++ b/fs/ext4/inode-test.c
@@ -366,6 +366,9 @@ struct inode_test_ctx {
 	unsigned int orphan_add_calls;
 	unsigned int orphan_del_calls;
 	unsigned int free_inode_calls;
+	u64 fscrypt_io_limit;
+	unsigned int fscrypt_limit_skip;
+	unsigned int fscrypt_limit_calls;
 };
 
 static unsigned long inode_test_shrinker_count(struct shrinker *shrink,
@@ -2897,6 +2900,24 @@ static void inode_test_get_block_bread_and_walk_buffers(struct kunit *test)
  * -------------------------------------------------------------------------
  */
 
+static u64 inode_test_fscrypt_limit_stub(const struct inode *inode, u64 lblk,
+					 u64 nr_blocks)
+{
+	struct kunit *test = kunit_get_current_test();
+	struct inode_test_ctx *ctx = test ? test->priv : NULL;
+
+	if (!ctx)
+		return nr_blocks;
+	ctx->fscrypt_limit_calls++;
+	if (ctx->fscrypt_limit_skip) {
+		ctx->fscrypt_limit_skip--;
+		return nr_blocks;
+	}
+	if (ctx->fscrypt_io_limit && nr_blocks > ctx->fscrypt_io_limit)
+		return ctx->fscrypt_io_limit;
+	return nr_blocks;
+}
+
 static void inode_test_iomap_and_atomic_writes(struct kunit *test)
 {
 	struct inode_test_ctx *ctx = inode_test_setup(test);
@@ -3040,6 +3061,51 @@ static void inode_test_iomap_and_atomic_writes(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, iomap.addr, (u64)INODE_TEST_DATA_BLK0 << 12);
 	KUNIT_EXPECT_TRUE(test, !!(iomap.flags & IOMAP_F_ATOMIC_BIO));
 	KUNIT_EXPECT_GT(test, ctx->zeroout_calls, 0U);
+
+	/*
+	 * 7. Atomic write truncated by fscrypt DUN wraparound returns -EINVAL
+	 * without triggering WARN_ON_ONCE(), both on the pre-allocation check
+	 * and on the post-mapping fallback check, while non-atomic I/O is
+	 * cleanly truncated to the limited block count.
+	 */
+	kunit_activate_static_stub(test, ext4_fscrypt_limit_io_blocks,
+				   inode_test_fscrypt_limit_stub);
+	inode_test_reset_mock_inode(ctx, S_IFREG | 0644);
+	inode->i_size = 16384;
+	inode_test_insert_leaf_extent(inode, 0, 2, INODE_TEST_DATA_BLK0, false);
+	ctx->next_alloc_pblk = INODE_TEST_DATA_BLK0 + 2;
+	ctx->alloc_calls = 0;
+	ctx->zeroout_calls = 0;
+	ctx->fscrypt_io_limit = 2;
+	ctx->fscrypt_limit_skip = 0;
+	ctx->fscrypt_limit_calls = 0;
+
+	err = ext4_iomap_begin(inode, 0, 16384,
+			       IOMAP_WRITE | IOMAP_DIRECT | IOMAP_ATOMIC,
+			       &iomap, &srcmap);
+	KUNIT_EXPECT_EQ(test, err, -EINVAL);
+	KUNIT_EXPECT_EQ(test, ctx->alloc_calls, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->zeroout_calls, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->fscrypt_limit_calls, 1U);
+
+	/* Skip the pre-alloc check to exercise the post-mapping check too */
+	ctx->fscrypt_limit_skip = 1;
+	ctx->fscrypt_limit_calls = 0;
+	err = ext4_iomap_begin(inode, 0, 16384,
+			       IOMAP_WRITE | IOMAP_DIRECT | IOMAP_ATOMIC,
+			       &iomap, &srcmap);
+	KUNIT_EXPECT_EQ(test, err, -EINVAL);
+	KUNIT_EXPECT_EQ(test, ctx->fscrypt_limit_calls, 2U);
+
+	/* Non-atomic mapping is truncated cleanly without error */
+	ctx->fscrypt_limit_skip = 0;
+	memset(&iomap, 0, sizeof(iomap));
+	err = ext4_iomap_begin(inode, 0, 16384, IOMAP_WRITE | IOMAP_DIRECT,
+			       &iomap, &srcmap);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, iomap.length, 8192ULL);
+
+	kunit_deactivate_static_stub(test, ext4_fscrypt_limit_io_blocks);
 }
 
 /* -------------------------------------------------------------------------
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d4371e94503b..3c2be0da5e2c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1140,6 +1140,15 @@ struct buffer_head *ext4_sb_getblk_unmovable(struct super_block *sb,
 }
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_sb_getblk_unmovable);
 
+u64 ext4_fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
+				 u64 nr_blocks)
+{
+	KUNIT_STATIC_STUB_REDIRECT(ext4_fscrypt_limit_io_blocks, inode, lblk,
+				   nr_blocks);
+	return fscrypt_limit_io_blocks(inode, lblk, nr_blocks);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fscrypt_limit_io_blocks);
+
 /*
  * `handle' can be NULL if create is zero
  */
@@ -4032,6 +4041,16 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			  EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
 	orig_mlen = map.m_len;
 
+	/*
+	 * Atomic writes must be issued as a single contiguous bio, so reject
+	 * requests that fscrypt would have to split across a DUN wraparound
+	 * before allocating blocks.
+	 */
+	if ((flags & IOMAP_ATOMIC) &&
+	    ext4_fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len) <
+	    map.m_len)
+		return -EINVAL;
+
 	if (flags & IOMAP_WRITE) {
 		/*
 		 * We check here if the blocks are already allocated, then we
@@ -4067,13 +4086,6 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 out:
-	/*
-	 * Sometimes I/O to an encrypted file has to be broken up to guarantee
-	 * DUN contiguity.  Handle this by limiting the length of the mapping
-	 * returned.
-	 */
-	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
-
 	/*
 	 * Before returning to iomap, let's ensure the allocated mapping
 	 * covers the entire requested length for atomic writes.
@@ -4084,6 +4096,16 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			return -EINVAL;
 		}
 	}
+
+	/*
+	 * Sometimes I/O to an encrypted file has to be broken up to guarantee
+	 * DUN contiguity.  Handle this by limiting the length of the mapping
+	 * returned.
+	 */
+	map.m_len = ext4_fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
+	if ((flags & IOMAP_ATOMIC) && map.m_len < (length >> blkbits))
+		return -EINVAL;
+
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 
 	return 0;
-- 
2.56.1.708.g77570a6a1d-goog

