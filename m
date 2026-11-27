Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.254.200.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795762296;
	b=N0Wd1IPrYK40TGvxvuePiwd7WwYfaqJg8ejbBPC1NH6RDX/wSWbqf3k50WDhguMn0+/L
	 D/H25Xe3v1Aeqscudrl7I8w/MCZua+5ALfA9iB1Wh0AJZwyxDumDb0lTRxfPfyee8UcID
	 TMYO94J0l/8+9VvNcQRer279xULiXZMuD2p8k3i2ujQwbl798xwV5E0WNVhoNcR3ZLhfg
	 CcCI1lQKnes5BcF1lDQrgZGvlLbqnQuWntT1V9xq/YLT+vQjX9ufqFDGit7bhBzEfKRqI
	 ZR29tp/enc6OIn+16aw6iNdIVKp6gmXbvYfVfxUrVXpMEBr8vJQnxaJXgYwOMDWTvDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762296;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=SynGTo3BWRH0dGUeUJpv8ilMoszn4n3lErGm8wxDGSI=;
	b=uPXpCJDO/2PTsriLw++1TiGWDCiU0UNgczlpvDW+dqn+010vqfcdoMIHZHQogKaC0ylF
	 3j0AxZWHUzAEyq7Gk5H1PvFpb6882imYonkDZew2fXKIDZ67yXmUdO7Avj+MrzZrwmODW
	 OdWSzFYnIVGynC3a10G7YiOhIPUUeMoqIrQkK7zXLuDIs2NgY1RpYeJxNhMXtxZ6Tc9N2
	 Ay+dyi+u+Y+S/wp+EQF2fIr99fg/AQYbkVc8U9MiFN2QoNvwUZJw7VgUD1hjaNz4BfPtk
	 FpIOra18X6eJvaDylQTWo74yn2nGHp099P1S4L6OEyCA8OXv6R5LuC7hdIAGJW+c/Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=GGMICwFj;
	arc=none smtp.remote-ip=54.254.200.128
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64D3606A31E;
	Fri, 27 Nov 2026 06:51:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E64D3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=GGMICwFj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1795762246;
	bh=SynGTo3BWRH0dGUeUJpv8ilMoszn4n3lErGm8wxDGSI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=GGMICwFjNLH11CIfyk1cRl1fg6uHmJEeFgcgV/sVE1struo0Gen9J/RfDNmIVenXC
	 IOCfaUwMb0xI9nyvkLvU7NXiIhG9/vO/DxFD0oL7hkO3TPhI7+a5NP5RnlkhUYrC0a
	 RYgE+/jH4hxIADnBIqR2dYE+0uHBEt+Ew0QPhofA=
X-QQ-mid: zesmtpgz7t1795762181t57916097
X-QQ-Originating-IP: W2xlnhcEqUEpbG6a/tVvO7RtSioXCmuweiXMwjttYck=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 27 Nov 2026 14:49:34 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6821860110329211317
EX-QQ-RecipientCnt: 15
From: jiazhenyuan <jiazhenyuan@uniontech.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	gouhao@uniontech.com,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com,
	caina@uniontech.com,
	zhaoshuang@uniontech.com,
	wangqing@uniontech.com
Subject: [PATCH 2/2] ext4: add KUnit test for ext4_ext_precache() buffer head leak
Date: Fri, 27 Nov 2026 14:49:26 +0800
Message-Id: <20261127064926.135945-2-jiazhenyuan@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261127064926.135945-1-jiazhenyuan@uniontech.com>
References: <20261127064926.135945-1-jiazhenyuan@uniontech.com>
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
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: NGKAM81q4BTsBqyUCXkaJ4K4aXwawbibtrWHVw8iHPIkIpraF+XN70Db
	jXC6fKNS9cOjpty1z/VZs9uf0kaqNlHorJzKrIh6OUBBRCMz+bRg6r0vdWsuMktFazkdo5e
	IZts2tGAmmDbEhuDfHzN5CVKfsWsc1Eye+zl4LbzTiql+ClsbcWYFSsm5IqnINjHSzUbSXx
	66Bwoyh+h/jiBxSdNGRyi8rlFAmcsGBJ98MJKmKYQNgDv6gSbvmARZYqm+KSVhEdgCw/ovF
	CcqcTrff5D0smEVy8aP83M0cIQ4JZjORsDw9h7iyLwYm3/qYGd2KRzsaGSGhvz7tq03UAbu
	2DSl9abDO1rwPh8r0nYoPDw8f+waDzjJ3jfee8MIdse/0BcqJ1HRO/PLQHTrRJ82YEr8Nlz
	ceVGqoXdL9A4+oG7NX64D7y6gdTcJK/3LQsjikW/P50EqVqXvLnZypuv6kl847qMtEhX3bD
	is2+EvFWlrcT1LS8xul/SH4ofljgogZ60w8y2fpIeohIgLbIX1z6rKQ9G13HZ4R8F8+fK6L
	jWp6+UQzNrVTmhQft9Fdx3Hqs3KNcGt2XWYqQ/uXCEEDXUz3KVHBVBWfxgM70rECfjT1l72
	LjanxNLTYTzfLRGPCemHRJJBR+Tt6gbe/PqzJ7vINGQVSv4jNxeh10WxjpHsZyRHJ/n50oR
	xT+0eFG3UIShk6Q9QIFSxPvQIFu0yPh/Mht+6hsnHpQw7sU+NYroX/WE9DTp7ZEBX6Evkln
	u3ZCKzfMSnZ5KU5dR+ADrJNK4GYT3TF3DiQsloWVkfPcMT6dBQakgzblkOgxGk2hmcoJ2uH
	RYcD4+WXffO0xJfF1OItnNJlOlYSpWU75HzhVCmaDZbasT3UGSF+k4Y/y+4IKd/ignEeeR7
	WUC7rXFqJXstQotnpTSHhFMGru+N2n+rQh5vG2o8UIx5YvX0ojwiAQdQyMazzACzwxdyoxM
	awxLtKUE8WKg4TzfsVqCjosuaHVhYJE9n9wwp+AEtuzNGmQBqicpc3w5hmkqxIuTROJCU9U
	vnyA/PbBoMUEchbCoO4WiUr6dTKrAlPBy5Yx3dQV/1yefExoU/mdlIV9J/AaUq7jpXSDNPg
	jM2dsLSgnJm9F7fQ1TX+uOKZStRAzBVQQfwzT+EytKGQ4M0QTQqHZjuFG07IOrxa3CF2Ftb
	vcEX
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Add a KUnit regression test that builds a depth-2 extent tree with two
leaves under a shared intermediate index block. Hold a reference to the
index block, make the second leaf read fail, and verify that its
buffer-head reference is released after ext4_ext_precache() returns.

Using a per-block failure flag is needed because a global getblk failure
would fail the first metadata read before any ancestor reference is
held.

Signed-off-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 fs/ext4/extents-test.c | 101 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 6458345ea958..2815156d7b3d 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -82,6 +82,7 @@ static struct kunit_ctx {
 	struct dentry k_dentry;
 
 	bool fail_getblk;
+	ext4_fsblk_t fail_getblk_pblk;
 } k_ctx;
 
 /*
@@ -336,7 +337,9 @@ static struct buffer_head *ext4_ext_getblk_stub(struct inode *inode,
 	struct kunit_meta_block *slot = NULL;
 	int i;
 
-	if (k_ctx.fail_getblk || !k_ctx.meta_blocks)
+	if (k_ctx.fail_getblk || !k_ctx.meta_blocks ||
+	    (k_ctx.fail_getblk_pblk &&
+	     pblk == k_ctx.fail_getblk_pblk))
 		return NULL;
 
 	for (i = 0; i < EXT_MAX_META_BLOCKS; i++) {
@@ -1364,6 +1367,74 @@ static void setup_depth1_two_leaf_tree(struct kunit *test, struct inode *inode)
 	brelse(bh1);
 }
 
+/*
+ * Helper to construct a depth-2 tree with two leaves under a shared
+ * intermediate index block:
+ *   Root (pblk none): index -> 500
+ *   Index 0 (pblk 500): leaf 0 -> 600, leaf 1 -> 601
+ *   Leaf 0 (pblk 600): [10, 15) -> 1000
+ *   Leaf 1 (pblk 601): [40, 45) -> 2000
+ */
+static void setup_depth2_shared_index_tree(struct kunit *test,
+					   struct inode *inode)
+{
+	struct ext4_extent_header *root_eh = ext_inode_hdr(inode);
+	struct ext4_extent_header *index_eh;
+	struct ext4_extent_header *leaf_eh;
+	struct ext4_extent_idx *idx;
+	struct ext4_extent *ex;
+	struct buffer_head *bh;
+
+	ext_reset_tree(inode);
+
+	root_eh->eh_depth = cpu_to_le16(2);
+	root_eh->eh_entries = cpu_to_le16(1);
+	root_eh->eh_max = cpu_to_le16(ext4_ext_space_root_idx_test(inode, 0));
+	idx = EXT_FIRST_INDEX(root_eh);
+	idx->ei_block = cpu_to_le32(10);
+	ext4_idx_store_pblock(idx, EXT_META_BASE_PBLK);
+
+	bh = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	index_eh = ext_block_hdr(bh);
+	index_eh->eh_magic = EXT4_EXT_MAGIC;
+	index_eh->eh_depth = cpu_to_le16(1);
+	index_eh->eh_entries = cpu_to_le16(2);
+	index_eh->eh_max = cpu_to_le16(2);
+	idx = EXT_FIRST_INDEX(index_eh);
+	idx[0].ei_block = cpu_to_le32(10);
+	ext4_idx_store_pblock(&idx[0], EXT_META_BASE_PBLK + 100);
+	idx[1].ei_block = cpu_to_le32(40);
+	ext4_idx_store_pblock(&idx[1], EXT_META_BASE_PBLK + 101);
+	brelse(bh);
+
+	bh = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK + 100, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	leaf_eh = ext_block_hdr(bh);
+	leaf_eh->eh_magic = EXT4_EXT_MAGIC;
+	leaf_eh->eh_depth = 0;
+	leaf_eh->eh_entries = cpu_to_le16(1);
+	leaf_eh->eh_max = cpu_to_le16(1);
+	ex = EXT_FIRST_EXTENT(leaf_eh);
+	ex->ee_block = cpu_to_le32(10);
+	ex->ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(ex, 1000);
+	brelse(bh);
+
+	bh = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK + 101, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	leaf_eh = ext_block_hdr(bh);
+	leaf_eh->eh_magic = EXT4_EXT_MAGIC;
+	leaf_eh->eh_depth = 0;
+	leaf_eh->eh_entries = cpu_to_le16(1);
+	leaf_eh->eh_max = cpu_to_le16(1);
+	ex = EXT_FIRST_EXTENT(leaf_eh);
+	ex->ee_block = cpu_to_le32(40);
+	ex->ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(ex, 2000);
+	brelse(bh);
+}
+
 /*
  * Verify multi-level (depth 1) extent lookup and tree navigation helpers:
  * ext4_ext_next_allocated_block(), ext4_ext_next_leaf_block(),
@@ -1471,6 +1542,33 @@ static void test_ext_precache(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, ext4_es_pblock(&es), 2100ULL);
 }
 
+/*
+ * Verify that a failed precache traversal drops the buffer-head reference
+ * held for the ancestor extent block. The shared depth-1 index block is
+ * deliberately held by the test; failing the second leaf leaves it
+ * referenced by path[1]. A missing path depth causes ext4_free_ext_path()
+ * to leak that reference.
+ */
+static void test_ext_precache_read_failure_bh_leak(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct buffer_head *bh;
+	int err;
+
+	setup_depth2_shared_index_tree(test, inode);
+	bh = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	KUNIT_ASSERT_EQ(test, atomic_read(&bh->b_count), 2);
+
+	k_ctx.fail_getblk_pblk = EXT_META_BASE_PBLK + 101;
+	err = ext4_ext_precache(inode);
+	k_ctx.fail_getblk_pblk = 0;
+
+	KUNIT_EXPECT_EQ(test, err, -ENOMEM);
+	KUNIT_EXPECT_EQ(test, atomic_read(&bh->b_count), 2);
+	brelse(bh);
+}
+
 /*
  * Verify ext4_can_extents_be_merged() rules for written/unwritten state,
  * logical and physical contiguity, and maximum length limits.
@@ -3519,6 +3617,7 @@ static struct kunit_case extents_test_cases[] = {
 	KUNIT_CASE(test_find_extent_root_binsearch),
 	KUNIT_CASE(test_find_extent_multilevel_and_navigation),
 	KUNIT_CASE(test_ext_precache),
+	KUNIT_CASE(test_ext_precache_read_failure_bh_leak),
 	KUNIT_CASE(test_can_extents_be_merged),
 	KUNIT_CASE(test_insert_extent_merge_and_nomerge),
 	KUNIT_CASE(test_insert_extent_grow_and_merge_up),
-- 
2.20.1

