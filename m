Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115858;
	b=orzeBtF2NANGFaN2tDhsTt27fiNYhoIXXMNDN56Wh47ym2u5V5V93HAwL95XR9HsdPEA
	 upgbuNmoQAroAh7MaTkE+aiTDq2gie7W6d7ihqAE/ldoHnT/mb85g7lEHybDor0lYXur5
	 bpP1NVbx7cxDvFeTgnAfUIvJ+jSZLVH9+kW+yKjLX+g0j7glFK2JuEeFYJ6qePAiB1gNH
	 QGN/WUaRTN9G7AM7vFx2ULCdwA4dg2X6JbnhdNjrcv32+N9d4VPR+mN3NdqWcas7TfGCx
	 aGrHx1QOS//+n7V6OL6eXby3lq02jEZcIHm/EFNRag1r+4wIMyVTjpF2nLdlxWNuuBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115858;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GwWu6unttHsTaV6K2LGOZoKyEBWTMsfPCL2nDTc53wo=;
	b=M1Nu7JaRLlyl9zPhfgCDHW3ny0a5TbNtJq0gG8+4gKqX+cHSwTb4YuXDQUXd+y/NcBmV
	 08qDLlF7hvQ3M9XzxYtazCJZKarQFLE3oDKMxMmeTHYMSzC4bXY91+aJ5wnfFN1xedCxL
	 L4nWbxevi4gmsZ898TAc2g6UEn66exr01poEIyCb3MBXv/OnDV/Up87vD73BjHj90oSlj
	 /aJj4+TntKzMaNHG/rChQ4J7Qt4lNvKzOqGtpZkz63eIZ4VsZUeXhfBUS2K6B2i5MixqX
	 NszuV9jXIm4TdMkj9m7GV2oP5h1FxafQNA+rMP9J/UR3e0ufKlYlOiNTIWHP9w799vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=AEqLRRnk;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7214960A262F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7214960A262F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=AEqLRRnk
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYBw029941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=GwWu6unttHsTaV6K2LGOZoKyEBWTMsfPCL2nDTc53wo=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=AEqLRRnkuJ7B+ghazndlXP5IZxqhM3YSn48NNOBtPH80khApLXpd7GXAX53X1IWGs
	 PkrA7lCRdoGPVCKMISBAadcGRQSsq2hl46mi0vZId6Io2QXsT/yaYSMQ94zaDOrpIk
	 i8zBwNpiPzydNWfmNi6OEzsnGAdkOc7ozccIWIM6vgbA/wst2aP1ix/iRmKL3TG9Xa
	 7HuOo8xWF5q/gFe3ShBLQA3V01j0mAWm2k+Ywrt8/7o304SsS4vn1zWHrjoG73rB/P
	 +Cas5AqiH5Lcd9ogZUUmXpxjBSG+UT5TQHT6+kGySlUHS8aW0fWWbMM7b7GThQc5y2
	 Kln5qTSoO/ecw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4CE222E0158; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 19/32] ext4: don't allocate over indirect branches that failed to load
Date: Thu, 19 Nov 2026 14:17:06 -0500
Message-ID: <20261119191719.1943298-20-tytso@mit.edu>
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

ext4_get_branch() stops walking an indirect block chain either because
it found an unallocated pointer (*err == 0) or because it failed to
load an indirect block whose pointer is non-zero: -EFSCORRUPTED when
the pointer is beyond the end of the filesystem, -ENOMEM when
ext4_sb_getblk() fails, and -EIO when the read fails or when
ext4_check_indirect_blockref() rejects the block contents.

ext4_ind_map_blocks() only checks for -EIO before starting allocation.
For -EFSCORRUPTED and -ENOMEM it treats the still populated slot as a
hole, allocates a new branch and has ext4_splice_branch() store it over
the existing pointer.  Every block reachable from the old indirect
block is then silently dropped from the file and leaked, and the
corruption is never reported to the caller.

Bail out on any error from ext4_get_branch() before using the partial
chain on both the lookup and the allocation paths, and return
-EFSCORRUPTED rather than -EIO when an indirect block fails
ext4_check_indirect_blockref(), so that it is reported consistently
with other indirect block corruption.

Extend the indirect KUnit suite to cover allocation through a branch
that hits -ENOMEM or -EFSCORRUPTED, and the buffer_head reference
count on the bigalloc rejection path, whose leak was fixed by
commit 79dd565874b3 ("ext4: fix buffer_head leak in ext4_ind_map_blocks()
error path").

Fixes: 860d21e2c585 ("ext4: return ENOMEM if sb_getblk() fails")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/indirect-test.c | 90 ++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/indirect.c      | 17 ++++++--
 2 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/indirect-test.c b/fs/ext4/indirect-test.c
index 8d4a430ecb27..34659f222cf6 100644
--- a/fs/ext4/indirect-test.c
+++ b/fs/ext4/indirect-test.c
@@ -80,6 +80,7 @@ struct ind_test_ctx {
 	unsigned int fail_alloc_on_call;
 	int fail_alloc_err;
 	int read_bh_err;
+	ext4_fsblk_t getblk_fail_blk;
 	ext4_fsblk_t freed_blks[IND_TEST_MAX_FREED_REC];
 	unsigned int freed_cnt;
 	bool rwsem_inited;
@@ -231,6 +232,9 @@ static struct buffer_head *ind_sb_getblk_stub(struct super_block *sb,
 	ctx = test->priv;
 	if (!ctx || sb != ctx->sb)
 		return NULL;
+	/* Simulate sb_getblk() failure for one specific block */
+	if (ctx->getblk_fail_blk && block == ctx->getblk_fail_blk)
+		return NULL;
 
 	return ind_get_or_create_bh(ctx, block);
 }
@@ -967,14 +971,15 @@ static void test_ind_map_blocks_errors_and_alloc_branch_unwind(struct kunit *tes
 
 	/*
 	 * 5. Non-uptodate IND block containing invalid blockref (block 1 ==
-	 * s_first_data_block) fails ext4_check_indirect_blockref() -> -EIO.
+	 * s_first_data_block) fails ext4_check_indirect_blockref() ->
+	 * -EFSCORRUPTED.
 	 */
 	((__le32 *)ind_bh->b_data)[0] = cpu_to_le32(IND_TEST_FIRST_DATA_BLK);
 	clear_buffer_uptodate(ind_bh);
 	down_read(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_ind_map_blocks(NULL, inode, &map, 0);
 	up_read(&EXT4_I(inode)->i_data_sem);
-	KUNIT_EXPECT_EQ(test, ret, -EIO);
+	KUNIT_EXPECT_EQ(test, ret, -EFSCORRUPTED);
 	brelse(ind_bh);
 	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] = 0;
 
@@ -1270,6 +1275,86 @@ static void test_ind_free_corrupt_block_numbers(struct kunit *test)
 	iput(inode);
 }
 
+/*
+ * Test 8: ext4_ind_map_blocks(EXT4_GET_BLOCKS_CREATE) must fail, rather than
+ * treat the branch as a hole and splice a new one over the existing pointer,
+ * when ext4_get_branch() fails with -ENOMEM or -EFSCORRUPTED, and must not
+ * leak indirect buffer_heads when rejecting allocation on bigalloc.
+ */
+static void test_ind_map_blocks_create_branch_errors(struct kunit *test)
+{
+	struct ind_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	struct inode *inode = ind_make_test_inode(test, 19);
+	struct ext4_map_blocks map;
+	struct buffer_head *ind_bh;
+	ext4_fsblk_t bad_blk = IND_TEST_TOTAL_BLKS + 10;
+	handle_t *handle;
+	int count, ret;
+
+	handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS, 8);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(handle));
+
+	/* Populated IND block 300 mapping IND_BASE -> data block 400 */
+	ind_blk_ptrs(test, 300)[0] = cpu_to_le32(400);
+	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] = cpu_to_le32(300);
+
+	/* 1. sb_getblk() of the IND block fails -> -ENOMEM, IND preserved */
+	ctx->getblk_fail_blk = 300;
+	ctx->alloc_calls = 0;
+	memset(&map, 0, sizeof(map));
+	map.m_lblk = IND_TEST_IND_BASE + 1;
+	map.m_len = 1;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ind_map_blocks(handle, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	ctx->getblk_fail_blk = 0;
+	KUNIT_EXPECT_EQ(test, ret, -ENOMEM);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT4_I(inode)->i_data[EXT4_IND_BLOCK]),
+			300U);
+	KUNIT_EXPECT_EQ(test, ctx->alloc_calls, 0U);
+	KUNIT_EXPECT_FALSE(test, map.m_flags & EXT4_MAP_NEW);
+
+	/* 2. Out-of-range IND pointer -> -EFSCORRUPTED, pointer preserved */
+	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] = cpu_to_le32(bad_blk);
+	ctx->alloc_calls = 0;
+	memset(&map, 0, sizeof(map));
+	map.m_lblk = IND_TEST_IND_BASE;
+	map.m_len = 1;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ind_map_blocks(handle, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, ret, -EFSCORRUPTED);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT4_I(inode)->i_data[EXT4_IND_BLOCK]),
+			(u32)bad_blk);
+	KUNIT_EXPECT_EQ(test, ctx->alloc_calls, 0U);
+
+	/*
+	 * 3. bigalloc rejection after ext4_get_branch() has read the IND
+	 * block must drop the IND buffer_head reference it holds.
+	 */
+	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] = cpu_to_le32(300);
+	ind_bh = ind_lookup_bh(ctx, 300);
+	KUNIT_ASSERT_NOT_NULL(test, ind_bh);
+	count = atomic_read(&ind_bh->b_count);
+	ctx->alloc_calls = 0;
+	ext4_set_feature_bigalloc(sb);
+	memset(&map, 0, sizeof(map));
+	map.m_lblk = IND_TEST_IND_BASE + 1;
+	map.m_len = 1;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ind_map_blocks(handle, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	ext4_clear_feature_bigalloc(sb);
+	KUNIT_EXPECT_EQ(test, ret, -EFSCORRUPTED);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ind_bh->b_count), count);
+	KUNIT_EXPECT_EQ(test, ctx->alloc_calls, 0U);
+
+	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] = 0;
+	ext4_journal_stop(handle);
+	iput(inode);
+}
+
 static struct kunit_case ext4_indirect_test_cases[] = {
 	KUNIT_CASE(test_block_to_path_and_trans_blocks),
 	KUNIT_CASE(test_ind_map_blocks_lookup_mapped_and_holes),
@@ -1278,6 +1363,7 @@ static struct kunit_case ext4_indirect_test_cases[] = {
 	KUNIT_CASE(test_ind_truncate_partial_and_full),
 	KUNIT_CASE(test_ind_remove_space_levels_and_convergence),
 	KUNIT_CASE(test_ind_free_corrupt_block_numbers),
+	KUNIT_CASE(test_ind_map_blocks_create_branch_errors),
 	{}
 };
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index fd6d60f0323d..ce20401d60a9 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -135,6 +135,10 @@ static int ext4_block_to_path(struct inode *inode,
  *		(pointer to last triple returned, *@err == 0)
  *	or when it gets an IO error reading an indirect block
  *		(ditto, *@err == -EIO)
+ *	or when it finds a corrupted indirect block reference
+ *		(ditto, *@err == -EFSCORRUPTED)
+ *	or when it fails to get a buffer for an indirect block
+ *		(ditto, *@err == -ENOMEM)
  *	or when it reads all @depth-1 indirect blocks successfully and finds
  *	the whole chain, all way to the data (returns %NULL, *err == 0).
  *
@@ -177,6 +181,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 			/* validate block references */
 			if (ext4_check_indirect_blockref(inode, bh)) {
 				put_bh(bh);
+				ret = -EFSCORRUPTED;
 				goto failure;
 			}
 		}
@@ -572,6 +577,14 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 		goto got_it;
 	}
 
+	/*
+	 * Failed to read the indirect branch (-EIO, -ENOMEM, -EFSCORRUPTED).
+	 * Never treat this as a hole: allocating here would overwrite the
+	 * existing, still referenced, indirect block pointer.
+	 */
+	if (err)
+		goto cleanup;
+
 	/* Next simple case - plain lookup failed */
 	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
 		unsigned epb = inode->i_sb->s_blocksize / sizeof(u32);
@@ -610,10 +623,6 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 		goto cleanup;
 	}
 
-	/* Failed read of indirect block */
-	if (err == -EIO)
-		goto cleanup;
-
 	/*
 	 * Okay, we need to do block allocation.
 	*/
-- 
2.56.1.708.g77570a6a1d-goog

