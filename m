Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456422;
	b=NhFQc7zGAWvhpyz/SRHTj/2jlkdt5cXWnMOrxv3Blwk7V0v9JoShh/VW8oGp9SVbH/Mr
	 tyiuwmfSfz8FOhOq0h3iYbrlRQ9YQDVdkIx1CaGbyfpEw7rZ7jL7z9QHEc+0J6/p9u9Uk
	 3LaLGu8A+kvoLuTI5Hje10U0v5B9uzGF6Hlh4Zr235WrPpjMm6mL6lcB/KJf42pBr1dFe
	 MMYqhigcs6QTHeD3T30/0bAb/x7QuGI3Lb9LskCVOzZknhGwkcZrLRm2sowscahkcILt0
	 T0GF1HVdYPLCz1+DTuF1GajMSFOE3zE/tdJGtqYOGp639WjcEixeZYZRunZakAGCGBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456422;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CbGFs5qJmQbFHXTSVX8oKKeT+DyA8acIpJIZz8+ylgw=;
	b=h5wlyWh/xlc5bbGaXrANSIOmPA4imD7AMkrVuZ3M7Wdcuumt708usppwYO+QdemgCy85
	 w9oPnGq3zToLpa5Jl8/ixbj4Zg3oE0JW3MEArdu2dATHF0uxMARoroKR6KkxbPKQcIEkx
	 4qOP9KjbrpFv8t4ulEFhqBSewhm648CSW3WO5gGqQIVMBW9sYx9uFphCb3P1SX1LW6sxr
	 c9uK4xSyxFfsiq2Vdyjg4hf8sChx2PJJVr30CMhVpjxPMZkHK8lzCH7aALuiQGLIkTapH
	 kqXCRhGfduOoY9cWuZwqrOHlV0dXXrvqRc8m2WGqZ8SDTNmNiUTEzrOrCRAuO9dsoGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="A/aacnm9";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAB3606A324
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBAB3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=A/aacnm9
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46ppF016763
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456412; bh=CbGFs5qJmQbFHXTSVX8oKKeT+DyA8acIpJIZz8+ylgw=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=A/aacnm9AJd7O9SPDRYE3DOukUNezZEJmUMC4axUuOqeYs1U5shPtnGisB/zWq6fS
	 L1nm59mCv0GHPCHijcjoQUr4SJSJ9SNYRmkLPEv9zUJALP1Q4RPn+mvwEg/vnUkcWh
	 BodOleBFnt3HfBKiSpJRXLfjVWxWV456Ht2VT1oI4W9WNE47FvCZxuORcv8wbTrbhb
	 pAn4ERL73xWL6YtFbp2S+4iBVk2S4zu84DDIJRo9TZ1GYzCJyhqHqqPoHSid6IsCpS
	 x9/X05okw9w9XLvJzCVEfy8ddKWCK78HoDxsNm4/9HO+IVdD6OPNl/JulGmW4e6/t3
	 q8J/e6+bKjmig==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 420802E013F; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 03/27] ext4: add KUnit tests for ext4_ext_split() leaf and index splitting
Date: Wed, 11 Nov 2026 23:06:14 -0500
Message-ID: <20261112040638.1576836-4-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112040638.1576836-1-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
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

Commit 7831b3664109 ("ext4: add KUnit tests for fs/ext4/extents.c")
updated both block-allocation paths in ext4_ext_split() to call
ext4_ext_getblk() and noted node splitting in the commit message, but
none of the test cases in fs/ext4/extents-test.c actually reached
ext4_ext_split(). In test_insert_extent_grow_and_merge_up(), inserting a
5th extent into a full depth-0 root triggers ext4_ext_grow_indepth(),
moving the 4 extents into an external leaf block with eh_max == 340 and
returning from ext4_ext_create_new_leaf() without splitting.

Add two KUnit test cases to exercise ext4_ext_split() across leaf and
intermediate index levels:

- test_insert_extent_leaf_split(): fills a depth-1 external leaf block
  to capacity (340 extents), inserts in the middle to trigger a leaf
  split that moves tail extents into a new leaf block, and then fills
  the second leaf and appends past its end to exercise the m == 0
  leaf-addition path.
- test_insert_extent_index_split(): exercises depth 1 -> 2 tree growth
  followed by leaf splitting via the repeat loop in
  ext4_ext_create_new_leaf(), and then clamps the depth-1 index block's
  eh_max to exercise simultaneous leaf and intermediate index block
  splitting (k == 1) in ext4_ext_split().

Fixes: 7831b3664109 ("ext4: add KUnit tests for fs/ext4/extents.c")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents-test.c | 206 +++++++++++++++++++++++++++++++++++++++--
 fs/ext4/move_extent.c  |   5 +
 2 files changed, 203 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 705648186218..47ddeb94e2bf 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -1584,6 +1584,198 @@ static void test_insert_extent_grow_and_merge_up(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 12);
 }
 
+/*
+ * Verify ext4_ext_split() at depth 1 both when splitting a full leaf in the
+ * middle (moving tail extents to a newly allocated leaf block) and when
+ * appending past the end of a full leaf (m == 0).
+ */
+static void test_insert_extent_leaf_split(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_ext_path *path;
+	int i;
+
+	ext_reset_tree(inode);
+
+	/*
+	 * Insert 340 non-contiguous extents [i * 4, i * 4 + 2) @ 2000 + i * 4
+	 * to grow from depth 0 to depth 1 and completely fill the external
+	 * 4096-byte leaf block (eh_max = 340).
+	 */
+	for (i = 0; i < 340; i++) {
+		KUNIT_ASSERT_EQ_MSG(test,
+				    ext_insert_one(inode, i * 4, 2,
+						   2000 + i * 4, false, 0),
+				    0, "i=%d", i);
+	}
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 1);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 1);
+
+	/*
+	 * Insert [402, 403) @ 9000 in the middle of the full leaf between
+	 * [400, 402) and [404, 406): triggers ext4_ext_split() with m = 239,
+	 * moving [404..1358) into a newly allocated second leaf block.
+	 */
+	k_ctx.alloc_calls = 0;
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 402, 1, 9000, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 1U);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 1);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT_FIRST_INDEX(eh)[0].ei_block), 0U);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT_FIRST_INDEX(eh)[1].ei_block),
+			404U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_check_inode(inode), 0);
+
+	path = ext4_find_extent(inode, 402, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(path[1].p_hdr->eh_entries), 102);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[1].p_ext->ee_block), 402U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(path[1].p_ext), 9000ULL);
+	ext4_free_ext_path(path);
+
+	path = ext4_find_extent(inode, 404, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(path[1].p_hdr->eh_entries), 239);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[1].p_ext->ee_block), 404U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(path[1].p_ext), 2404ULL);
+	ext4_free_ext_path(path);
+
+	/*
+	 * Fill the second leaf to capacity (239 + 101 = 340 entries), then
+	 * append [1764, 1766) @ 3764 past its end to exercise ext4_ext_split()
+	 * with m == 0 (adding a new leaf without moving existing entries).
+	 */
+	for (i = 340; i < 441; i++) {
+		KUNIT_ASSERT_EQ_MSG(test,
+				    ext_insert_one(inode, i * 4, 2,
+						   2000 + i * 4, false, 0),
+				    0, "i=%d", i);
+	}
+	k_ctx.alloc_calls = 0;
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 1764, 2, 3764, false, 0),
+			0);
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 1U);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 1);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT_FIRST_INDEX(eh)[2].ei_block),
+			1764U);
+
+	path = ext4_find_extent(inode, 1764, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(path[1].p_hdr->eh_entries), 1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[1].p_ext->ee_block), 1764U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(path[1].p_ext), 3764ULL);
+	ext4_free_ext_path(path);
+}
+
+/*
+ * Verify multi-level tree growth from depth 1 -> 2 followed by leaf split
+ * (ext4_ext_create_new_leaf repeat loop), and intermediate index block
+ * splitting in ext4_ext_split() when both leaf and depth-1 index are full.
+ */
+static void test_insert_extent_index_split(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent_idx *idx;
+	struct ext4_ext_path *path;
+	struct buffer_head *bh;
+	int i;
+
+	ext_reset_tree(inode);
+
+	/*
+	 * Build a full depth-1 root index (eh_entries = eh_max = 4) pointing
+	 * to 4 full leaf blocks (eh_entries = eh_max = 2).
+	 */
+	eh->eh_depth = cpu_to_le16(1);
+	eh->eh_entries = cpu_to_le16(4);
+	eh->eh_max = cpu_to_le16(ext4_ext_space_root_idx_test(inode, 0));
+	idx = EXT_FIRST_INDEX(eh);
+
+	for (i = 0; i < 4; i++) {
+		struct ext4_extent_header *leaf_eh;
+		struct ext4_extent *ex;
+		ext4_lblk_t lblk = 10 + i * 10;
+
+		idx[i].ei_block = cpu_to_le32(lblk);
+		ext4_idx_store_pblock(&idx[i], EXT_META_BASE_PBLK + i);
+
+		bh = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK + i,
+					  GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, bh);
+		leaf_eh = ext_block_hdr(bh);
+		leaf_eh->eh_magic = EXT4_EXT_MAGIC;
+		leaf_eh->eh_depth = 0;
+		leaf_eh->eh_entries = cpu_to_le16(2);
+		leaf_eh->eh_max = cpu_to_le16(2);
+		ex = EXT_FIRST_EXTENT(leaf_eh);
+		ex[0].ee_block = cpu_to_le32(lblk);
+		ex[0].ee_len = cpu_to_le16(2);
+		ext4_ext_store_pblock(&ex[0], 2000 + i * 10);
+		ex[1].ee_block = cpu_to_le32(lblk + 4);
+		ex[1].ee_len = cpu_to_le16(2);
+		ext4_ext_store_pblock(&ex[1], 2004 + i * 10);
+		brelse(bh);
+	}
+
+	/*
+	 * Inserting [48, 50) @ 2038 finds both leaf 3 and the root index full:
+	 * ext4_ext_grow_indepth() grows depth 1 -> 2, and the repeat loop in
+	 * ext4_ext_create_new_leaf() calls ext4_ext_split() at depth 1.
+	 */
+	k_ctx.alloc_calls = 0;
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 48, 2, 2038, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 2U);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 2);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 1);
+
+	/*
+	 * Clamp the depth-1 index block's eh_max to its current 5 entries so
+	 * inserting [12, 13) @ 9000 into full leaf 0 splits both leaf 0 and
+	 * the intermediate depth-1 index block (depth = 2, at = 0, k = 1).
+	 */
+	bh = ext4_ext_getblk_stub(inode, ext4_idx_pblock(EXT_FIRST_INDEX(eh)),
+				  GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	KUNIT_ASSERT_EQ(test, le16_to_cpu(ext_block_hdr(bh)->eh_entries), 5);
+	ext_block_hdr(bh)->eh_max = cpu_to_le16(5);
+	brelse(bh);
+
+	k_ctx.alloc_calls = 0;
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 12, 1, 9000, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 2U);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 2);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT_FIRST_INDEX(eh)[0].ei_block),
+			10U);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT_FIRST_INDEX(eh)[1].ei_block),
+			14U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_check_inode(inode), 0);
+
+	path = ext4_find_extent(inode, 12, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, path->p_depth, 2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[2].p_ext->ee_block), 12U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(path[2].p_ext), 9000ULL);
+	ext4_free_ext_path(path);
+
+	path = ext4_find_extent(inode, 14, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, path->p_depth, 2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[2].p_ext->ee_block), 14U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(path[2].p_ext), 2004ULL);
+	ext4_free_ext_path(path);
+
+	path = ext4_find_extent(inode, 48, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, path->p_depth, 2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[2].p_ext->ee_block), 48U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(path[2].p_ext), 2038ULL);
+	ext4_free_ext_path(path);
+}
+
 /*
  * Verify ext4_ext_remove_space() for middle-of-extent hole punching, full
  * extent removal with left-scooting, and ext4_ext_truncate() tail removal.
@@ -2073,17 +2265,13 @@ static void test_swap_extents(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, ext_insert_one(inode1, 10, 10, 100, false, 0), 0);
 	KUNIT_ASSERT_EQ(test, ext_insert_one(inode2, 10, 10, 200, false, 0), 0);
 
-	inode_lock(inode1);
-	inode_lock(inode2);
-	down_write(&EXT4_I(inode1)->i_data_sem);
-	down_write(&EXT4_I(inode2)->i_data_sem);
+	lock_two_nondirectories(inode1, inode2);
+	ext4_double_down_write_data_sem(inode1, inode2);
 
 	replaced = ext4_swap_extents(NULL, inode1, inode2, 12, 12, 5, 1, &err);
 
-	up_write(&EXT4_I(inode2)->i_data_sem);
-	up_write(&EXT4_I(inode1)->i_data_sem);
-	inode_unlock(inode2);
-	inode_unlock(inode1);
+	ext4_double_up_write_data_sem(inode1, inode2);
+	unlock_two_nondirectories(inode1, inode2);
 
 	KUNIT_EXPECT_EQ(test, err, 0);
 	KUNIT_EXPECT_EQ(test, replaced, 5);
@@ -2787,6 +2975,8 @@ static struct kunit_case extents_test_cases[] = {
 	KUNIT_CASE(test_can_extents_be_merged),
 	KUNIT_CASE(test_insert_extent_merge_and_nomerge),
 	KUNIT_CASE(test_insert_extent_grow_and_merge_up),
+	KUNIT_CASE(test_insert_extent_leaf_split),
+	KUNIT_CASE(test_insert_extent_index_split),
 	KUNIT_CASE(test_remove_space_tail_and_hole_punch),
 	KUNIT_CASE(test_remove_space_multilevel_collapse),
 	KUNIT_CASE(test_remove_space_bigalloc_partial_cluster),
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 3329b7ad5dbd..d1405e763912 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -656,3 +656,8 @@ int ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 	unlock_two_nondirectories(orig_inode, donor_inode);
 	return ret;
 }
+
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_double_down_write_data_sem);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_double_up_write_data_sem);
+#endif
-- 
2.56.0.542.g3ef89b7020-goog

