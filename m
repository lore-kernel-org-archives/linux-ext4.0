Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456424;
	b=WuaRTPD/uxdoWFK0U+sNMOjzDNWorHNkYBnMri8o9rL6tgQx80R+XwG/qHSPTPNA7vM4
	 4oklQ4PtHovDw+SV6w++POZ2TuKPScjVC703f7BFdx82KSj36vqbqo5M+7/gZH0K2ngMX
	 cKssF3Gr49HgZ8/eboMdrp5pT8Xk8GcAZ/uvwwF4zVQ5KrDDNdsQPvb0V/Ux1JURS21rR
	 oPElde6rAlmmWDUOvXbm1PQz+8C6lr5xejh8xJwog2UoYWmtcFrEF/Qwwg67nh1Yf8BIo
	 918zfYgmXJcFMxOsPMIy7/kOOtsubX90eXhsDCmqYj9gNYTb3/QxFdXLKGrgzf3NdQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456424;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cThr/VOxuYrNQaNfyBHJ5RGgZnud/Gl6Gl26vx5s+F8=;
	b=pXK4xeAqGFG0rCgzrrHJq8//ijVA+MUXBGkPDVAVW2e1vFTXAeMRBYiJJoudiDGC900K
	 xPYV+Q01BlTxnaE8uCNd0DAMNTtnTXHD2p5kdJQ+bBf78+X9ID6zkxaFZ+depbuWqk2re
	 6udYjKTyMZP4f7KxEgeby99SFO5F3oRvZ/xbN2BLFhOlSSNnZYmIllHYGxP3nzle17TOj
	 CeWwfMJiOXUh/f6KsxDkibZQ4TkxSqfizY52dID1A1Ko9HtVmTztOewmm14c8laJVNyCd
	 BLlTkSAlbgfCX17J5+rjM+kK47y9+SDXYnC08G6eMzaXkVhQbu95Q8vgRk4RrV3iX3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Qt6AEpQb;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DB6606A335
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4DB6606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Qt6AEpQb
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46qHi016804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456414; bh=cThr/VOxuYrNQaNfyBHJ5RGgZnud/Gl6Gl26vx5s+F8=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Qt6AEpQbchZaF88pETdobxzPBuBFWWYwSLvICHReBVZk0rXU3XgaqQTcJ7coxVvZV
	 Tds0hmXd5c8dIkSPEc9Q5/5XLAQGXhMOplLioS/76Jc1cMAAtTQahhK0ZZb/edgzjo
	 8ntapWSjtFLcegvUh0lXceAkXV81aEqY9nVXXlAsZcvTqgpY6O7tvDtyomUnXl88KA
	 SBz8JDRTHVIyyEDA+vZxX0dAb7LT5WFmThPK3ZAVbDOA3tQ75NwpclNSsdDzYP+je4
	 YJ7MplC2bIYyU8oOh/6Rq2lre6EsvHB8mcqUC7Qbaeu6w0Z4ot62CpLglb3fEwMHqH
	 4OklTGQRuuW2g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4E63A2E0148; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 06/27] ext4: expand KUnit tests for fs/ext4/mballoc.c
Date: Wed, 11 Nov 2026 23:06:17 -0500
Message-ID: <20261112040638.1576836-7-tytso@mit.edu>
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

Expand the ext4_mballoc_test KUnit test suite in fs/ext4/mballoc-test.c
from 7 subtests (21 test cases) to 32 subtests (96 parameterized test
cases across 1K, 4K, and 64K block sizes) to comprehensively exercise
the multi-block allocator in fs/ext4/mballoc.c:

- Low-level bitmap helpers (mb_set_bit, mb_clear_bit, mb_test_bit,
  mb_find_next_zero_bit, mb_find_next_bit, mb_clear_bits, mb_set_bits,
  and mb_test_and_clear_bits across clean, partially clear, and fully
  clear ranges).
- Buddy bitmap lookup and extent discovery (mb_find_buddy,
  mb_find_order_for_block, mb_find_extent for free, used, and merged
  power-of-two ranges, and mb_regenerate_buddy).
- Corrupted block bitmap detection in ext4_mb_generate_buddy (setting
  EXT4_GROUP_INFO_BBITMAP_CORRUPT when bitmap free count mismatches
  grp->bb_free) and double-free / EXT4_STATE_FC_REPLAY handling in
  mb_free_blocks.
- Group fragment size order calculation (mb_avg_fragment_size_order),
  per-order XArray insertion/migration/removal
  (mb_update_avg_fragment_size and mb_set_largest_free_order), and
  largest free order tracking.
- Group eligibility filtering (ext4_mb_good_group_nolock and
  ext4_mb_good_group) across CR_POWER2_ALIGNED, CR_GOAL_LEN_FAST,
  CR_BEST_AVAIL_LEN, CR_GOAL_LEN_SLOW, and CR_ANY_FREE, including
  BBITMAP_CORRUPT, 0 free blocks, uninitialized bitmaps, and flex_bg
  metadata allocation rules.
- Goal-based allocation (ext4_mb_find_by_goal) covering power-of-two
  buddies, non-power-of-two extents, EXT4_MB_HINT_MERGE tail merging,
  stripe-aligned requests, and occupied goals.
- Buddy and bitmap group scanning (ext4_mb_simple_scan_group,
  ext4_mb_scan_aligned, ext4_mb_complex_scan_group,
  ext4_mb_measure_extent, and ext4_mb_try_best_found) including
  s_mb_max_to_scan limits and EXT4_MB_HINT_FIRST.
- Regular allocator orchestration (ext4_mb_regular_allocator) for
  EXT4_MB_HINT_GOAL_ONLY, stream allocation (EXT4_MB_STREAM_ALLOC) with
  s_mb_last_groups updates, and MB_OPTIMIZE_SCAN with CR_BEST_AVAIL_LEN
  goal length trimming.
- Block bitmap prefetching (ext4_mb_prefetch and ext4_mb_prefetch_fini)
  and allocation context initialization and request normalization
  (ext4_mb_initialize_context and ext4_mb_normalize_request across
  metadata/no-normalize, small/large/huge files, stripe alignment, and
  existing preallocation overlap avoidance).
- Inode and locality group preallocation lifecycles (ext4_mb_pa_alloc,
  ext4_mb_pa_put_free, ext4_mb_new_preallocation,
  ext4_mb_use_preallocated, ext4_mb_generate_from_pa,
  ext4_mb_discard_group_preallocations, ext4_discard_preallocations,
  ext4_mb_discard_preallocations, and locality group list trimming past
  PREALLOC_TB_SIZE).
- Top-level allocation and deallocation entry points
  (ext4_mb_new_blocks including PA satisfaction and ENOSPC retry after
  discarding group PAs, ext4_mb_mark_context, ext4_mb_mark_bb,
  ext4_free_blocks with EXT4_FREE_BLOCKS_NO_QUOT_UPDATE /
  VALIDATED / METADATA and cross-group extents, mb_free_metadata
  merging and splitting with ext4_process_freed_data,
  ext4_group_add_blocks, ext4_trim_fs with a static stub for
  ext4_issue_discard, and ext4_mballoc_query_range).

Export the tested functions with EXPORT_SYMBOL_FOR_EXT4_TEST and add a
KUNIT_STATIC_STUB_REDIRECT hook to ext4_issue_discard.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/mballoc-test.c | 1855 +++++++++++++++++++++++++++++++++++++++-
 fs/ext4/mballoc.c      |  201 ++++-
 fs/ext4/mballoc.h      |   49 ++
 3 files changed, 2089 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index d31780075c21..402f4efdf25a 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -79,6 +79,7 @@ static int mbt_mb_init(struct super_block *sb)
 	sb->s_bdev = kzalloc_obj(*sb->s_bdev);
 	if (sb->s_bdev == NULL)
 		return -ENOMEM;
+	bdev_set_flag(sb->s_bdev, BD_READ_ONLY);
 
 	sb->s_bdev->bd_queue = kzalloc_obj(struct request_queue);
 	if (sb->s_bdev->bd_queue == NULL) {
@@ -162,10 +163,15 @@ static struct super_block *mbt_ext4_alloc_super_block(void)
 		goto out_deactivate;
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
+	spin_lock_init(&sbi->s_error_lock);
+	ratelimit_state_init(&sbi->s_err_ratelimit_state, 5 * HZ, 10);
+	ratelimit_state_init(&sbi->s_warning_ratelimit_state, 5 * HZ, 10);
+	ratelimit_state_init(&sbi->s_msg_ratelimit_state, 5 * HZ, 10);
 
 	sbi->s_es = &fsb->es;
 	sbi->s_sb = sb;
 	sb->s_fs_info = sbi;
+	set_opt(sb, ERRORS_CONT);
 
 	up_write(&sb->s_umount);
 	return sb;
@@ -341,15 +347,72 @@ ext4_mb_mark_context_stub(handle_t *handle, struct super_block *sb, bool state,
 {
 	struct mbt_grp_ctx *grp_ctx = MBT_GRP_CTX(sb, group);
 	struct buffer_head *bitmap_bh = &grp_ctx->bitmap_bh;
+	struct ext4_group_desc *gdp = &grp_ctx->desc;
+	ext4_grpblk_t i, already = 0, changed = len;
+	__u32 free;
 
-	if (state)
+	for (i = 0; i < len; i++) {
+		if (mb_test_bit_test(blkoff + i, bitmap_bh->b_data) == state)
+			already++;
+	}
+	if (flags & 0x0001 /* EXT4_MB_BITMAP_MARKED_CHECK */)
+		changed = len - already;
+
+	free = ext4_free_group_clusters(sb, gdp);
+	if (state) {
 		mb_set_bits(bitmap_bh->b_data, blkoff, len);
-	else
+		if (free >= changed)
+			ext4_free_group_clusters_set(sb, gdp, free - changed);
+	} else {
 		mb_clear_bits_test(bitmap_bh->b_data, blkoff, len);
+		ext4_free_group_clusters_set(sb, gdp, free + changed);
+	}
+
+	if (ret_changed)
+		*ret_changed = changed;
 
 	return 0;
 }
 
+static int
+ext4_issue_discard_stub(struct super_block *sb, ext4_group_t block_group,
+			ext4_grpblk_t cluster, int count)
+{
+	return 0;
+}
+
+static struct inode *mbt_alloc_test_inode(struct kunit *test,
+					  struct super_block *sb,
+					  umode_t mode)
+{
+	struct ext4_inode_info *ei;
+	struct inode *inode;
+
+	ei = kunit_kzalloc(test, sizeof(*ei), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ei);
+
+	INIT_LIST_HEAD(&ei->i_orphan);
+	init_rwsem(&ei->xattr_sem);
+	init_rwsem(&ei->i_data_sem);
+	ei->i_prealloc_node = RB_ROOT;
+	atomic_set(&ei->i_prealloc_active, 0);
+	rwlock_init(&ei->i_prealloc_lock);
+	spin_lock_init(&ei->i_block_reservation_lock);
+	spin_lock_init(&ei->i_raw_lock);
+
+	inode = &ei->vfs_inode;
+	inode_init_once(inode);
+	ext4_fc_init_inode(inode);
+	inode->i_sb = sb;
+	inode->i_ino = 12;
+	inode->i_mode = mode;
+	inode->i_flags |= S_NOQUOTA;
+	atomic_set(&inode->i_writecount, 1);
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+
+	return inode;
+}
+
 #define TEST_GOAL_GROUP 1
 static int mbt_kunit_init(struct kunit *test)
 {
@@ -382,6 +445,9 @@ static int mbt_kunit_init(struct kunit *test)
 	kunit_activate_static_stub(test,
 				   ext4_mb_mark_context,
 				   ext4_mb_mark_context_stub);
+	kunit_activate_static_stub(test,
+				   ext4_issue_discard,
+				   ext4_issue_discard_stub);
 
 	/* stub function will be called in mbt_mb_init->ext4_mb_init */
 	if (mbt_mb_init(sb) != 0) {
@@ -402,7 +468,10 @@ static void mbt_kunit_exit(struct kunit *test)
 	if (!sb)
 		return;
 
+	if (sb->s_blocksize <= PAGE_SIZE)
+		ext4_mb_discard_preallocations_test(sb, 0);
 	mbt_mb_release(sb);
+	rcu_barrier();
 	mbt_ctx_release(sb);
 	mbt_ext4_free_super_block(sb);
 }
@@ -417,11 +486,7 @@ static void test_new_blocks_simple(struct kunit *test)
 	ext4_fsblk_t found;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	inode = kunit_kzalloc(test, sizeof(*inode), GFP_KERNEL);
-	if (!inode)
-		return;
-
-	inode->i_sb = sb;
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
 	ar.inode = inode;
 
 	/* get block at goal */
@@ -527,10 +592,7 @@ test_free_blocks_simple_range(struct kunit *test, ext4_group_t goal_group,
 	struct inode *inode;
 	ext4_fsblk_t block;
 
-	inode = kunit_kzalloc(test, sizeof(*inode), GFP_KERNEL);
-	if (!inode)
-		return;
-	inode->i_sb = sb;
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
 
 	if (len == 0)
 		return;
@@ -601,10 +663,7 @@ static void test_mark_diskspace_used(struct kunit *test)
 
 	mbt_generate_test_ranges(sb, ranges, TEST_RANGE_COUNT);
 
-	inode = kunit_kzalloc(test, sizeof(*inode), GFP_KERNEL);
-	if (!inode)
-		return;
-	inode->i_sb = sb;
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
 
 	ac.ac_status = AC_STATUS_FOUND;
 	ac.ac_sb = sb;
@@ -949,6 +1008,1747 @@ static void test_mb_mark_used_cost(struct kunit *test)
 	ext4_mb_unload_buddy_test(&e4b);
 }
 
+static void test_mb_bit_ops(struct kunit *test)
+{
+	u8 *buf;
+	void *unaligned;
+	int bit, i;
+
+	buf = kunit_kzalloc(test, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
+
+	/*
+	 * Use an unaligned pointer (offset by 3 bytes) to exercise
+	 * mb_correct_addr_and_bit() on 64-bit/32-bit architectures.
+	 */
+	unaligned = buf + 3;
+
+	mb_set_bit_test(0, unaligned);
+	mb_set_bit_test(7, unaligned);
+	mb_set_bit_test(64, unaligned);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(0, unaligned), 0);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(1, unaligned), 0);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(7, unaligned), 0);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(64, unaligned), 0);
+
+	mb_clear_bit_test(7, unaligned);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(7, unaligned), 0);
+
+	bit = mb_find_next_bit_test(unaligned, 128, 1);
+	KUNIT_EXPECT_EQ(test, bit, 64);
+
+	/* Clamping when no set bit exists before max */
+	bit = mb_find_next_bit_test(unaligned, 60, 1);
+	KUNIT_EXPECT_EQ(test, bit, 60);
+
+	/* Zero-length mb_set_bits / mb_clear_bits should be a no-op */
+	memset(buf, 0, 128);
+	mb_set_bits(unaligned, 10, 0);
+	KUNIT_EXPECT_EQ(test, mb_find_next_bit_test(unaligned, 256, 0), 256);
+
+	/* Multi-word unaligned range spanning head bits, 32-bit words, and tail */
+	mb_set_bits(unaligned, 5, 75);
+	KUNIT_EXPECT_EQ(test, mb_find_next_bit_test(unaligned, 256, 0), 5);
+	KUNIT_EXPECT_EQ(test, mb_find_next_zero_bit_test(unaligned, 256, 5), 80);
+	/* Clamping when no zero bit exists before max */
+	KUNIT_EXPECT_EQ(test, mb_find_next_zero_bit_test(unaligned, 50, 5), 50);
+
+	/* Clear a sub-range across 32-bit boundaries */
+	mb_clear_bits_test(unaligned, 13, 50);
+	for (i = 0; i < 100; i++) {
+		int expected = (i >= 5 && i < 13) || (i >= 63 && i < 80);
+
+		KUNIT_EXPECT_EQ(test, !!mb_test_bit_test(i, unaligned), expected);
+	}
+}
+
+static void test_mb_test_and_clear_bits(struct kunit *test)
+{
+	u8 *buf;
+	void *bm;
+	int ret, i;
+
+	buf = kunit_kzalloc(test, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
+	bm = buf + 3;
+
+	/* Case 1: All bits in range [5, 85) are set -> returns -1 and clears all */
+	memset(buf, 0xff, 128);
+	ret = mb_test_and_clear_bits_test(bm, 5, 80);
+	KUNIT_EXPECT_EQ(test, ret, -1);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(4, bm), 0);
+	for (i = 5; i < 85; i++)
+		KUNIT_EXPECT_EQ(test, mb_test_bit_test(i, bm), 0);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(85, bm), 0);
+
+	/* Case 2: Zero bit in the unaligned head (bit 7) */
+	memset(buf, 0xff, 128);
+	mb_clear_bit_test(7, bm);
+	ret = mb_test_and_clear_bits_test(bm, 5, 80);
+	KUNIT_EXPECT_EQ(test, ret, 7);
+	for (i = 5; i < 85; i++)
+		KUNIT_EXPECT_EQ(test, mb_test_bit_test(i, bm), 0);
+
+	/* Case 3: Zero bit inside the 32-bit word fast-path region (bit 45) */
+	memset(buf, 0xff, 128);
+	mb_clear_bit_test(45, bm);
+	ret = mb_test_and_clear_bits_test(bm, 5, 80);
+	KUNIT_EXPECT_EQ(test, ret, 45);
+	for (i = 5; i < 85; i++)
+		KUNIT_EXPECT_EQ(test, mb_test_bit_test(i, bm), 0);
+}
+
+static void test_mb_find_buddy_and_order(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
+	struct ext4_free_extent ex;
+	void *bb;
+	int max = 0, ret;
+	int ord0, ord1, ord2, ord3;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/* Order 0 returns bitmap and bit count */
+	bb = mb_find_buddy_test(&e4b, 0, &max);
+	KUNIT_EXPECT_PTR_EQ(test, bb, e4b.bd_bitmap);
+	KUNIT_EXPECT_EQ(test, max, (int)(sb->s_blocksize << 3));
+
+	/* Valid higher order returns buddy offset */
+	bb = mb_find_buddy_test(&e4b, 1, &max);
+	KUNIT_EXPECT_PTR_EQ(test, bb, e4b.bd_buddy + sbi->s_mb_offsets[1]);
+	KUNIT_EXPECT_EQ(test, max, sbi->s_mb_maxs[1]);
+
+	/* Out-of-bounds order (> bd_blkbits + 1) returns NULL and max = 0 */
+	bb = mb_find_buddy_test(&e4b, MB_NUM_ORDERS(sb), &max);
+	KUNIT_EXPECT_NULL(test, bb);
+	KUNIT_EXPECT_EQ(test, max, 0);
+
+	/*
+	 * Mark cluster 0 used in group 1: this splits the group so that:
+	 * - cluster 1 is free at order 0
+	 * - clusters [2, 4) are free at order 1
+	 * - clusters [4, 8) are free at order 2
+	 * - clusters [8, 16) are free at order 3
+	 */
+	ex.fe_group = TEST_GOAL_GROUP;
+	ex.fe_start = 0;
+	ex.fe_len = 1;
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	mb_mark_used_test(&e4b, &ex);
+	ord0 = mb_find_order_for_block_test(&e4b, 1);
+	ord1 = mb_find_order_for_block_test(&e4b, 2);
+	ord2 = mb_find_order_for_block_test(&e4b, 4);
+	ord3 = mb_find_order_for_block_test(&e4b, 8);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	KUNIT_EXPECT_EQ(test, ord0, 0);
+	KUNIT_EXPECT_EQ(test, ord1, 1);
+	KUNIT_EXPECT_EQ(test, ord2, 2);
+	KUNIT_EXPECT_EQ(test, ord3, 3);
+
+	ext4_mb_unload_buddy_test(&e4b);
+}
+
+static void test_mb_find_extent(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_buddy e4b;
+	struct ext4_free_extent ex, found_used, found_small, found_coalesced, found_unaligned;
+	int ret, len_used, len_small, len_coalesced, len_unaligned;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/*
+	 * Leave only [10, 26) (16 clusters) free:
+	 * [10, 12) order 1 (2) + [12, 16) order 2 (4) +
+	 * [16, 24) order 3 (8) + [24, 26) order 1 (2).
+	 */
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	ex.fe_group = TEST_GOAL_GROUP;
+	ex.fe_start = 0;
+	ex.fe_len = 10;
+	mb_mark_used_test(&e4b, &ex);
+
+	ex.fe_start = 26;
+	ex.fe_len = EXT4_CLUSTERS_PER_GROUP(sb) - 26;
+	mb_mark_used_test(&e4b, &ex);
+
+	len_used = mb_find_extent_test(&e4b, 5, 8, &found_used);
+	len_small = mb_find_extent_test(&e4b, 10, 1, &found_small);
+	len_coalesced = mb_find_extent_test(&e4b, 10, 20, &found_coalesced);
+	len_unaligned = mb_find_extent_test(&e4b, 11, 20, &found_unaligned);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	/* Used block returns 0 */
+	KUNIT_EXPECT_EQ(test, len_used, 0);
+	KUNIT_EXPECT_EQ(test, found_used.fe_len, 0);
+
+	/* Needed = 1 at block 10 returns the order-1 buddy [10, 12) */
+	KUNIT_EXPECT_EQ(test, len_small, 2);
+	KUNIT_EXPECT_EQ(test, found_small.fe_start, 10);
+	KUNIT_EXPECT_EQ(test, found_small.fe_len, 2);
+
+	/* Needed = 20 at block 10 coalesces across orders 1, 2, 3, 1 -> 16 clusters */
+	KUNIT_EXPECT_EQ(test, len_coalesced, 16);
+	KUNIT_EXPECT_EQ(test, found_coalesced.fe_start, 10);
+	KUNIT_EXPECT_EQ(test, found_coalesced.fe_len, 16);
+
+	/* Unaligned start at block 11 coalesces [11, 26) -> 15 clusters */
+	KUNIT_EXPECT_EQ(test, len_unaligned, 15);
+	KUNIT_EXPECT_EQ(test, found_unaligned.fe_start, 11);
+	KUNIT_EXPECT_EQ(test, found_unaligned.fe_len, 15);
+
+	ext4_mb_unload_buddy_test(&e4b);
+}
+
+static void test_mb_generate_buddy_corrupt(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_group_info *grp;
+	void *bitmap, *buddy;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	bool is_corrupt;
+	ext4_grpblk_t corrected_free;
+	int i;
+
+	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
+	buddy = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buddy);
+
+	grp = ext4_get_group_info(sb, TEST_GOAL_GROUP);
+	KUNIT_ASSERT_NOT_NULL(test, grp);
+
+	/* Mark 10 clusters used in bitmap, so actual free is max - 10 */
+	mb_set_bits(bitmap, max, sb->s_blocksize * 8 - max);
+	mb_set_bits(bitmap, 0, 10);
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	for (i = 0; i < MB_NUM_ORDERS(sb); i++)
+		grp->bb_counters[i] = 0;
+	/* Intentionally set wrong bb_free = max (mismatch with max - 10) */
+	grp->bb_free = max;
+	memset(buddy, 0xff, sb->s_blocksize);
+	ext4_mb_generate_buddy_test(sb, buddy, bitmap, TEST_GOAL_GROUP, grp);
+	is_corrupt = EXT4_MB_GRP_BBITMAP_CORRUPT(grp);
+	corrected_free = grp->bb_free;
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	KUNIT_EXPECT_TRUE(test, is_corrupt);
+	KUNIT_EXPECT_EQ(test, corrected_free, max - 10);
+}
+
+static void test_mb_free_blocks_double_free_and_fc_replay(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
+	struct ext4_free_extent ex;
+	bool corrupt_normal, corrupt_fc;
+	ext4_grpblk_t free_after_fc;
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	/* Part 1: Normal mode double-free marks group bitmap corrupt */
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	/* Clusters [10, 14) are already free; freeing them again is a double free */
+	mb_free_blocks_test(NULL, &e4b, 10, 4);
+	corrupt_normal = EXT4_MB_GRP_BBITMAP_CORRUPT(e4b.bd_info);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_unload_buddy_test(&e4b);
+
+	KUNIT_EXPECT_TRUE(test, corrupt_normal);
+
+	/*
+	 * Part 2: In EXT4_FC_REPLAY mode, freeing an already-freed range
+	 * triggers mb_regenerate_buddy() instead of marking the group corrupt.
+	 */
+	ret = ext4_mb_load_buddy_test(sb, 2, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	ext4_lock_group(sb, 2);
+	ex.fe_group = 2;
+	ex.fe_start = 10;
+	ex.fe_len = 10;
+	mb_mark_used_test(&e4b, &ex);
+	/* Free sub-range [12, 16) first so [12, 16) is already free */
+	mb_free_blocks_test(NULL, &e4b, 12, 4);
+
+	/* Re-freeing [12, 16) in EXT4_FC_REPLAY mode regenerates buddy cleanly */
+	sbi->s_mount_state |= EXT4_FC_REPLAY;
+	mb_free_blocks_test(NULL, &e4b, 12, 4);
+	sbi->s_mount_state &= ~EXT4_FC_REPLAY;
+
+	corrupt_fc = EXT4_MB_GRP_BBITMAP_CORRUPT(e4b.bd_info);
+	free_after_fc = e4b.bd_info->bb_free;
+	ext4_unlock_group(sb, 2);
+	ext4_mb_unload_buddy_test(&e4b);
+
+	KUNIT_EXPECT_FALSE(test, corrupt_fc);
+	KUNIT_EXPECT_EQ(test, free_after_fc, EXT4_CLUSTERS_PER_GROUP(sb) - 6);
+}
+
+static void test_mb_xarray_orders_and_frag_size(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_info *grp;
+	int ord_1, ord_4, ord_7, ord_8;
+	int old_lfo, new_lfo, new_afso;
+	void *xa_lfo_entry, *xa_afso_entry, *xa_old_entry;
+	int i;
+
+	set_opt2(sb, MB_OPTIMIZE_SCAN);
+
+	/* mb_avg_fragment_size_order computes clamp(fls(len) - 2, 0, MB_NUM_ORDERS - 1) */
+	ord_1 = mb_avg_fragment_size_order_test(sb, 1);
+	ord_4 = mb_avg_fragment_size_order_test(sb, 4);
+	ord_7 = mb_avg_fragment_size_order_test(sb, 7);
+	ord_8 = mb_avg_fragment_size_order_test(sb, 8);
+	KUNIT_EXPECT_EQ(test, ord_1, 0);
+	KUNIT_EXPECT_EQ(test, ord_4, 1);
+	KUNIT_EXPECT_EQ(test, ord_7, 1);
+	KUNIT_EXPECT_EQ(test, ord_8, 2);
+
+	grp = ext4_get_group_info(sb, TEST_GOAL_GROUP);
+	KUNIT_ASSERT_NOT_NULL(test, grp);
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	old_lfo = grp->bb_largest_free_order;
+	for (i = 0; i < MB_NUM_ORDERS(sb); i++)
+		grp->bb_counters[i] = 0;
+	grp->bb_counters[3] = 2;
+	grp->bb_free = 16;
+	grp->bb_fragments = 2;
+
+	mb_set_largest_free_order_test(sb, grp);
+	mb_update_avg_fragment_size_test(sb, grp);
+
+	new_lfo = grp->bb_largest_free_order;
+	new_afso = grp->bb_avg_fragment_size_order;
+	xa_lfo_entry = xa_load(&sbi->s_mb_largest_free_orders[3], TEST_GOAL_GROUP);
+	xa_afso_entry = xa_load(&sbi->s_mb_avg_fragment_size[2], TEST_GOAL_GROUP);
+
+	/* Now mark group completely full and verify XArray entries are erased */
+	grp->bb_counters[3] = 0;
+	grp->bb_free = 0;
+	grp->bb_fragments = 0;
+	mb_set_largest_free_order_test(sb, grp);
+	mb_update_avg_fragment_size_test(sb, grp);
+	xa_old_entry = xa_load(&sbi->s_mb_largest_free_orders[3], TEST_GOAL_GROUP);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	KUNIT_EXPECT_EQ(test, old_lfo, -1);
+	KUNIT_EXPECT_EQ(test, new_lfo, 3);
+	KUNIT_EXPECT_EQ(test, new_afso, 2);
+	KUNIT_EXPECT_PTR_EQ(test, xa_lfo_entry, grp);
+	KUNIT_EXPECT_PTR_EQ(test, xa_afso_entry, grp);
+	KUNIT_EXPECT_NULL(test, xa_old_entry);
+}
+
+static void test_mb_good_group(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
+	struct ext4_allocation_context ac = {};
+	struct ext4_group_info *grp1, *grp2;
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	/* Initialize group 1 buddy cache so bb_fragments and orders are populated */
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ext4_mb_unload_buddy_test(&e4b);
+
+	grp1 = ext4_get_group_info(sb, TEST_GOAL_GROUP);
+	KUNIT_ASSERT_NOT_NULL(test, grp1);
+
+	ac.ac_sb = sb;
+	ac.ac_2order = 3;
+	ac.ac_g_ex.fe_len = 8;
+	ac.ac_flags = EXT4_MB_HINT_DATA;
+
+	/* Group 1 has all clusters free in 1 fragment -> eligible at all CRs */
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_POWER2_ALIGNED));
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_GOAL_LEN_FAST));
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_BEST_AVAIL_LEN));
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_GOAL_LEN_SLOW));
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_ANY_FREE));
+
+	/*
+	 * Simulate high fragmentation: free = 16, fragments = 8 (avg = 2 < 8),
+	 * largest_free_order = 1 (< ac_2order = 3).
+	 * CR_POWER2_ALIGNED, CR_GOAL_LEN_FAST, CR_BEST_AVAIL_LEN must reject,
+	 * while CR_GOAL_LEN_SLOW (free 16 >= 8) and CR_ANY_FREE accept.
+	 */
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	grp1->bb_free = 16;
+	grp1->bb_fragments = 8;
+	grp1->bb_largest_free_order = 1;
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	KUNIT_EXPECT_FALSE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							 CR_POWER2_ALIGNED));
+	KUNIT_EXPECT_FALSE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							 CR_GOAL_LEN_FAST));
+	KUNIT_EXPECT_FALSE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							 CR_BEST_AVAIL_LEN));
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_GOAL_LEN_SLOW));
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_ANY_FREE));
+
+	/* When free = 4 < fe_len = 8, CR_GOAL_LEN_SLOW rejects, CR_ANY_FREE accepts */
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	grp1->bb_free = 4;
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	KUNIT_EXPECT_FALSE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							 CR_GOAL_LEN_SLOW));
+	KUNIT_EXPECT_TRUE(test, ext4_mb_good_group_test(&ac, TEST_GOAL_GROUP,
+							CR_ANY_FREE));
+
+	/* Flex_bg first group avoidance at CR_POWER2_ALIGNED for data */
+	ret = ext4_mb_load_buddy_test(sb, 0, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ext4_mb_unload_buddy_test(&e4b);
+	sbi->s_log_groups_per_flex = 2; /* flex_size = 4 >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME */
+	KUNIT_EXPECT_FALSE(test, ext4_mb_good_group_test(&ac, 0, CR_POWER2_ALIGNED));
+	sbi->s_log_groups_per_flex = 0;
+
+	/*
+	 * Test ext4_mb_good_group_nolock on uninitialized group 2:
+	 * At inexpensive CR_POWER2_ALIGNED, it skips initializing group 2 and returns 0.
+	 * At expensive CR_GOAL_LEN_SLOW (with STRICT_CHECK), it initializes group 2
+	 * and returns 1.
+	 */
+	grp2 = ext4_get_group_info(sb, 2);
+	KUNIT_ASSERT_NOT_NULL(test, grp2);
+	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp2));
+
+	ac.ac_criteria = CR_POWER2_ALIGNED;
+	ret = ext4_mb_good_group_nolock_test(&ac, 2, CR_POWER2_ALIGNED);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp2));
+
+	ac.ac_flags |= EXT4_MB_STRICT_CHECK;
+	ac.ac_criteria = CR_GOAL_LEN_SLOW;
+	ret = ext4_mb_good_group_nolock_test(&ac, 2, CR_GOAL_LEN_SLOW);
+	KUNIT_EXPECT_EQ(test, ret, 1);
+	KUNIT_EXPECT_FALSE(test, EXT4_MB_GRP_NEED_INIT(grp2));
+}
+
+static void test_mb_find_by_goal(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
+	struct ext4_allocation_context ac = {};
+	struct inode *inode;
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+
+	/* Mark [24, 32) used in group 1 so [20, 24) has only 4 free clusters */
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 24, 8);
+	ext4_get_group_info(sb, TEST_GOAL_GROUP)->bb_free -= 8;
+
+	/* 1. Exact goal hit at [10, 14) */
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_flags = EXT4_MB_HINT_TRY_GOAL;
+	ac.ac_g_ex.fe_group = TEST_GOAL_GROUP;
+	ac.ac_g_ex.fe_start = 10;
+	ac.ac_g_ex.fe_len = 4;
+	ac.ac_o_ex = ac.ac_g_ex;
+
+	ret = ext4_mb_find_by_goal_test(&ac, &e4b);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_group, TEST_GOAL_GROUP);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 10);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 4);
+
+	/* 2. Partial goal at [20, 28) without HINT_MERGE fails to match */
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_flags = EXT4_MB_HINT_TRY_GOAL;
+	ac.ac_g_ex.fe_group = TEST_GOAL_GROUP;
+	ac.ac_g_ex.fe_start = 20;
+	ac.ac_g_ex.fe_len = 8;
+	ac.ac_o_ex = ac.ac_g_ex;
+
+	ret = ext4_mb_find_by_goal_test(&ac, &e4b);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_CONTINUE);
+
+	/* 3. Partial goal at [20, 28) WITH EXT4_MB_HINT_MERGE allocates [20, 24) */
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_flags = EXT4_MB_HINT_TRY_GOAL | EXT4_MB_HINT_MERGE;
+	ac.ac_g_ex.fe_group = TEST_GOAL_GROUP;
+	ac.ac_g_ex.fe_start = 20;
+	ac.ac_g_ex.fe_len = 8;
+	ac.ac_o_ex = ac.ac_g_ex;
+
+	ret = ext4_mb_find_by_goal_test(&ac, &e4b);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 20);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 4);
+
+	/*
+	 * 4. Stripe-aligned check: s_stripe = 8 clusters; unaligned start 36
+	 * rejected, aligned 40 accepted.
+	 */
+	sbi->s_stripe = EXT4_C2B(sbi, 8);
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_flags = EXT4_MB_HINT_TRY_GOAL;
+	ac.ac_g_ex.fe_group = TEST_GOAL_GROUP;
+	ac.ac_g_ex.fe_start = 36;
+	ac.ac_g_ex.fe_len = 8;
+	ac.ac_o_ex = ac.ac_g_ex;
+
+	ret = ext4_mb_find_by_goal_test(&ac, &e4b);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_CONTINUE);
+
+	ac.ac_g_ex.fe_start = 40;
+	ac.ac_o_ex = ac.ac_g_ex;
+	ret = ext4_mb_find_by_goal_test(&ac, &e4b);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 40);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 8);
+	sbi->s_stripe = 0;
+}
+
+static void test_mb_simple_and_aligned_scan(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
+	struct ext4_allocation_context ac = {};
+	struct inode *inode;
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+
+	/*
+	 * Mark cluster 0 used in group 1 so:
+	 * - order 3 buddy [8, 16) is the first order-3 buddy
+	 * - first 16-cluster stripe [0, 16) is not completely free, so
+	 *   stripe-aligned scan must skip to cluster 16.
+	 */
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 0, 1);
+
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/* 1. ext4_mb_simple_scan_group with ac_2order = 3 (8 clusters) */
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_criteria = CR_POWER2_ALIGNED;
+	ac.ac_2order = 3;
+	ac.ac_g_ex.fe_len = 8;
+	ac.ac_o_ex.fe_len = 8;
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_simple_scan_group_test(&ac, &e4b);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_release_context_test(&ac);
+
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_group, TEST_GOAL_GROUP);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 8);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 8);
+
+	/* 2. ext4_mb_scan_aligned with stripe = 16 clusters */
+	sbi->s_stripe = EXT4_C2B(sbi, 16);
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_criteria = CR_GOAL_LEN_FAST;
+	ac.ac_g_ex.fe_len = 16;
+	ac.ac_o_ex.fe_len = 16;
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_scan_aligned_test(&ac, &e4b);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_release_context_test(&ac);
+
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_group, TEST_GOAL_GROUP);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 16);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 16);
+
+	sbi->s_stripe = 0;
+	ext4_mb_unload_buddy_test(&e4b);
+}
+
+static void test_mb_complex_scan_and_measure(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
+	struct ext4_allocation_context ac = {};
+	struct inode *inode;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+
+	/*
+	 * Create 3 power-of-2 aligned free extents in TEST_GOAL_GROUP:
+	 * - [0, 4)   len 4  (order 2 buddy)
+	 * - [16, 32) len 16 (order 4 buddy)
+	 * - [40, 48) len 8  (order 3 buddy)
+	 * Mark everything else used (total free = 28 clusters).
+	 */
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 4, 12);
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 32, 8);
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 48, max - 48);
+	ext4_get_group_info(sb, TEST_GOAL_GROUP)->bb_free = 28;
+
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/*
+	 * Case 1: Goal len = 5 at CR_GOAL_LEN_SLOW.
+	 * Scans [0, 4) (len 4 < 5), [16, 32) (order 4 buddy -> len 16 > 5),
+	 * and [40, 48) (order 3 buddy -> len 8 > 5, smaller than 16 so preferred!),
+	 * then allocates 5 clusters from [40, 48) at finish_group.
+	 */
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_criteria = CR_GOAL_LEN_SLOW;
+	ac.ac_g_ex.fe_len = 5;
+	ac.ac_o_ex.fe_len = 5;
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_complex_scan_group_test(&ac, &e4b);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_release_context_test(&ac);
+
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 40);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 5);
+
+	/*
+	 * Case 2: Goal len = 32 (larger than any free extent) with s_mb_max_to_scan = 1.
+	 * Scanning [0, 4) and [16, 32) increments ac_found to 2 > s_mb_max_to_scan,
+	 * triggering AC_STATUS_BREAK with best smaller extent [16, 32) (len 16)
+	 * recorded in ac_b_ex. Calling ext4_mb_try_best_found() then claims [16, 32).
+	 */
+	sbi->s_mb_max_to_scan = 1;
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_criteria = CR_ANY_FREE;
+	ac.ac_g_ex.fe_len = 32;
+	ac.ac_o_ex.fe_len = 32;
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_complex_scan_group_test(&ac, &e4b);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_BREAK);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 16);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 16);
+
+	ext4_mb_try_best_found_test(&ac, &e4b);
+	ext4_mb_release_context_test(&ac);
+
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 16);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 16);
+
+	/*
+	 * Case 3: EXT4_MB_HINT_FIRST immediately takes the first free extent [0, 4).
+	 */
+	sbi->s_mb_max_to_scan = 200;
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_criteria = CR_ANY_FREE;
+	ac.ac_flags = EXT4_MB_HINT_FIRST;
+	ac.ac_g_ex.fe_len = 4;
+	ac.ac_o_ex.fe_len = 4;
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_complex_scan_group_test(&ac, &e4b);
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+	ext4_mb_release_context_test(&ac);
+
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_start, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 4);
+
+	ext4_mb_unload_buddy_test(&e4b);
+}
+
+static void test_mb_regular_allocator(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_allocation_context ac = {};
+	struct inode *inode;
+	int ret, hash;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+
+	/*
+	 * 1. EXT4_MB_HINT_GOAL_ONLY when goal block (group 0, cluster 0) is already
+	 * marked used: must stop immediately without scanning other blocks.
+	 */
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_flags = EXT4_MB_HINT_GOAL_ONLY;
+	ac.ac_g_ex.fe_group = 0;
+	ac.ac_g_ex.fe_start = 0;
+	ac.ac_g_ex.fe_len = 1;
+	ac.ac_o_ex = ac.ac_g_ex;
+
+	ret = ext4_mb_regular_allocator_test(&ac);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_CONTINUE);
+
+	/*
+	 * 2. Stream allocation (EXT4_MB_STREAM_ALLOC) with group 0 full:
+	 * allocates in group 1 and updates s_mb_last_groups[hash] to 1.
+	 */
+	mbt_ctx_mark_used(sb, 0, 0, EXT4_CLUSTERS_PER_GROUP(sb));
+	ext4_free_group_clusters_set(sb, &MBT_GRP_CTX(sb, 0)->desc, 0);
+	ext4_get_group_info(sb, 0)->bb_free = 0;
+
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_flags = EXT4_MB_STREAM_ALLOC | EXT4_MB_HINT_DATA;
+	ac.ac_g_ex.fe_len = 8;
+	ac.ac_orig_goal_len = 8;
+	ac.ac_o_ex.fe_len = 8;
+
+	ret = ext4_mb_regular_allocator_test(&ac);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_group, 1);
+
+	hash = (unsigned int)inode->i_ino % sbi->s_mb_nr_global_goals;
+	KUNIT_EXPECT_EQ(test, READ_ONCE(sbi->s_mb_last_groups[hash]), 1);
+
+	/*
+	 * 3. MB_OPTIMIZE_SCAN with CR_BEST_AVAIL_LEN goal length trimming:
+	 * Make group 2 the only group with free blocks, fragmented into two
+	 * 8-cluster chunks [0, 8) and [16, 24) so largest_free_order = 3
+	 * and avg_fragment_size = 8.
+	 * Note: group 2 may have already been prefetched during step 2, so
+	 * mark its blocks used via mb_mark_used_test on the loaded buddy.
+	 */
+	set_opt2(sb, MB_OPTIMIZE_SCAN);
+	mbt_ctx_mark_used(sb, 1, 0, EXT4_CLUSTERS_PER_GROUP(sb));
+	ext4_free_group_clusters_set(sb, &MBT_GRP_CTX(sb, 1)->desc, 0);
+	ext4_get_group_info(sb, 1)->bb_free = 0;
+	ext4_get_group_info(sb, 1)->bb_fragments = 0;
+	mb_set_largest_free_order_test(sb, ext4_get_group_info(sb, 1));
+	mb_update_avg_fragment_size_test(sb, ext4_get_group_info(sb, 1));
+
+	mbt_ctx_mark_used(sb, 3, 0, EXT4_CLUSTERS_PER_GROUP(sb));
+	ext4_free_group_clusters_set(sb, &MBT_GRP_CTX(sb, 3)->desc, 0);
+	ext4_get_group_info(sb, 3)->bb_free = 0;
+	ext4_get_group_info(sb, 3)->bb_fragments = 0;
+	mb_set_largest_free_order_test(sb, ext4_get_group_info(sb, 3));
+	mb_update_avg_fragment_size_test(sb, ext4_get_group_info(sb, 3));
+
+	{
+		struct ext4_buddy e4b;
+		struct ext4_free_extent ex;
+
+		ret = ext4_mb_load_buddy_test(sb, 2, &e4b);
+		KUNIT_ASSERT_EQ(test, ret, 0);
+		ext4_lock_group(sb, 2);
+		ex.fe_group = 2;
+		ex.fe_start = 8;
+		ex.fe_len = 8;
+		mb_mark_used_test(&e4b, &ex);
+		ex.fe_start = 24;
+		ex.fe_len = EXT4_CLUSTERS_PER_GROUP(sb) - 24;
+		mb_mark_used_test(&e4b, &ex);
+		ext4_unlock_group(sb, 2);
+		ext4_mb_unload_buddy_test(&e4b);
+	}
+
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_status = AC_STATUS_CONTINUE;
+	ac.ac_flags = EXT4_MB_HINT_DATA;
+	ac.ac_g_ex.fe_group = 0;
+	ac.ac_g_ex.fe_len = 16;
+	ac.ac_orig_goal_len = 16;
+	ac.ac_o_ex.fe_len = 8;
+
+	ret = ext4_mb_regular_allocator_test(&ac);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_status, AC_STATUS_FOUND);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_group, 2);
+	KUNIT_EXPECT_EQ(test, ac.ac_b_ex.fe_len, 8);
+}
+
+static void test_mb_prefetch(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_group_info *grp0, *grp1, *grp2;
+	ext4_group_t next_grp;
+	int ios = 0;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	grp0 = ext4_get_group_info(sb, 0);
+	grp1 = ext4_get_group_info(sb, 1);
+	grp2 = ext4_get_group_info(sb, 2);
+	KUNIT_ASSERT_NOT_NULL(test, grp0);
+	KUNIT_ASSERT_NOT_NULL(test, grp1);
+	KUNIT_ASSERT_NOT_NULL(test, grp2);
+
+	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp0));
+	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp1));
+	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp2));
+
+	next_grp = ext4_mb_prefetch(sb, 0, 2, &ios);
+	KUNIT_EXPECT_EQ(test, next_grp, 2);
+	/* First prefetch of uninitialized buffers increments ios count */
+	KUNIT_EXPECT_EQ(test, ios, 2);
+
+	/* Repeated prefetch on the same groups does not re-read bitmaps */
+	ios = 0;
+	ext4_mb_prefetch(sb, 0, 2, &ios);
+	KUNIT_EXPECT_EQ(test, ios, 0);
+
+	/* ext4_mb_prefetch_fini initializes the prefetched groups [0, 2) */
+	ext4_mb_prefetch_fini(sb, next_grp, 2);
+	KUNIT_EXPECT_FALSE(test, EXT4_MB_GRP_NEED_INIT(grp0));
+	KUNIT_EXPECT_FALSE(test, EXT4_MB_GRP_NEED_INIT(grp1));
+	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp2));
+}
+
+static void test_mb_initialize_context(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_allocation_context ac = {};
+	struct ext4_allocation_request ar = {};
+	struct inode *inode;
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+
+	/* 1. Small open file (<= s_mb_stream_request) uses locality group alloc */
+	i_size_write(inode, sb->s_blocksize);
+	ar.inode = inode;
+	ar.logical = 0;
+	ar.len = 1;
+	ar.goal = ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
+	ar.flags = EXT4_MB_HINT_DATA;
+
+	ext4_mb_initialize_context_test(&ac, &ar);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_NE(test, ac.ac_flags & EXT4_MB_HINT_GROUP_ALLOC, 0);
+	KUNIT_EXPECT_NOT_NULL(test, ac.ac_lg);
+	KUNIT_EXPECT_EQ(test, ac.ac_g_ex.fe_group, TEST_GOAL_GROUP);
+
+	/* 2. Large open file (> s_mb_stream_request) uses stream alloc */
+	memset(&ac, 0, sizeof(ac));
+	i_size_write(inode, (loff_t)(sbi->s_mb_stream_request + 64) << sb->s_blocksize_bits);
+	ext4_mb_initialize_context_test(&ac, &ar);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_NE(test, ac.ac_flags & EXT4_MB_STREAM_ALLOC, 0);
+	KUNIT_EXPECT_NULL(test, ac.ac_lg);
+
+	/*
+	 * 3. Closed file (i_writecount == 0) with size == isize and
+	 * size > s_mb_stream_request sets EXT4_MB_HINT_NOPREALLOC.
+	 */
+	memset(&ac, 0, sizeof(ac));
+	atomic_set(&inode->i_writecount, 0);
+	ar.logical = EXT4_LBLK_CMASK(sbi, sbi->s_mb_stream_request + EXT4_C2B(sbi, 2));
+	ar.len = 1;
+	i_size_write(inode, (loff_t)(ar.logical + EXT4_C2B(sbi, 1)) << sb->s_blocksize_bits);
+	/* Also test out-of-range ar.goal fallback to group 0 */
+	ar.goal = ext4_blocks_count(sbi->s_es) + 100;
+	ext4_mb_initialize_context_test(&ac, &ar);
+	ext4_mb_release_context_test(&ac);
+	KUNIT_EXPECT_NE(test, ac.ac_flags & EXT4_MB_HINT_NOPREALLOC, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_o_ex.fe_group, 0);
+	KUNIT_EXPECT_EQ(test, ac.ac_o_ex.fe_start, 0);
+}
+
+static void test_mb_normalize_request(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_allocation_context ac = {};
+	struct ext4_allocation_request ar = {};
+	struct inode *inode;
+	struct ext4_inode_info *ei;
+	struct ext4_prealloc_space left_pa = {}, right_pa = {};
+	int bsbits = sb->s_blocksize_bits;
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+	ei = EXT4_I(inode);
+
+	/* 1. Metadata request (no EXT4_MB_HINT_DATA) is not normalized */
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_o_ex.fe_logical = 0;
+	ac.ac_o_ex.fe_len = 1;
+	ac.ac_g_ex = ac.ac_o_ex;
+	ext4_mb_normalize_request_test(&ac, &ar);
+	KUNIT_EXPECT_EQ(test, ac.ac_g_ex.fe_len, 1);
+
+	/* 2. Locality group request normalizes fe_len to s_mb_group_prealloc */
+	memset(&ac, 0, sizeof(ac));
+	ac.ac_sb = sb;
+	ac.ac_inode = inode;
+	ac.ac_flags = EXT4_MB_HINT_DATA | EXT4_MB_HINT_GROUP_ALLOC;
+	ac.ac_lg = raw_cpu_ptr(sbi->s_locality_groups);
+	ac.ac_o_ex.fe_len = 1;
+	ac.ac_g_ex = ac.ac_o_ex;
+	ext4_mb_normalize_request_test(&ac, &ar);
+	KUNIT_EXPECT_EQ(test, ac.ac_g_ex.fe_len, sbi->s_mb_group_prealloc);
+
+	/* 3. Small file (<= 16KB) normalizes up to max(SZ_16K, cluster_size) */
+	if ((SZ_16K >> bsbits) >= sbi->s_cluster_ratio) {
+		memset(&ac, 0, sizeof(ac));
+		i_size_write(inode, 4096);
+		ac.ac_sb = sb;
+		ac.ac_inode = inode;
+		ac.ac_flags = EXT4_MB_HINT_DATA;
+		ac.ac_o_ex.fe_logical = 0;
+		ac.ac_o_ex.fe_len = 1;
+		ac.ac_g_ex = ac.ac_o_ex;
+		ext4_mb_normalize_request_test(&ac, &ar);
+		KUNIT_EXPECT_EQ(test, ac.ac_g_ex.fe_len,
+				EXT4_NUM_B2C(sbi, SZ_16K >> bsbits));
+	}
+
+	/* 4. 200KB file normalizes up to next power of two (256KB) */
+	if ((SZ_256K >> bsbits) >= sbi->s_cluster_ratio) {
+		memset(&ac, 0, sizeof(ac));
+		i_size_write(inode, 200 * 1024);
+		ac.ac_sb = sb;
+		ac.ac_inode = inode;
+		ac.ac_flags = EXT4_MB_HINT_DATA;
+		ac.ac_o_ex.fe_logical = 0;
+		ac.ac_o_ex.fe_len = 1;
+		ac.ac_g_ex = ac.ac_o_ex;
+		ext4_mb_normalize_request_test(&ac, &ar);
+		KUNIT_EXPECT_EQ(test, ac.ac_g_ex.fe_len,
+				EXT4_NUM_B2C(sbi, SZ_256K >> bsbits));
+	}
+
+	/*
+	 * 5. Trimming against left/right allocated neighbors (ar.pleft / ar.pright)
+	 * and against existing inode preallocations (ext4_mb_pa_adjust_overlap).
+	 */
+	if (((loff_t)EXT4_C2B(sbi, 16) << bsbits) <= SZ_1M) {
+		memset(&ac, 0, sizeof(ac));
+		memset(&ar, 0, sizeof(ar));
+		i_size_write(inode, (loff_t)EXT4_C2B(sbi, 16) << bsbits);
+		ac.ac_sb = sb;
+		ac.ac_inode = inode;
+		ac.ac_flags = EXT4_MB_HINT_DATA;
+		ac.ac_o_ex.fe_logical = EXT4_C2B(sbi, 4);
+		ac.ac_o_ex.fe_len = 1;
+		ac.ac_g_ex = ac.ac_o_ex;
+
+		/* Left neighbor ends at cluster 2 (logical block EXT4_C2B(sbi, 2) - 1) */
+		ar.lleft = EXT4_C2B(sbi, 2) - 1;
+		ar.pleft = ext4_group_first_block_no(sb, TEST_GOAL_GROUP) + ar.lleft;
+		/* Right neighbor starts at cluster 10 */
+		ar.lright = EXT4_C2B(sbi, 10);
+		ar.pright = ext4_group_first_block_no(sb, TEST_GOAL_GROUP) + ar.lright;
+
+		/*
+		 * Also insert a left PA covering clusters [2, 3) and a right PA covering
+		 * clusters [8, 10) into ei->i_prealloc_node so ext4_mb_pa_adjust_overlap
+		 * trims the range further to clusters [3, 8) (5 clusters).
+		 */
+		spin_lock_init(&left_pa.pa_lock);
+		left_pa.pa_lstart = EXT4_C2B(sbi, 2);
+		left_pa.pa_len = 1;
+		left_pa.pa_free = 1;
+		left_pa.pa_deleted = 0;
+
+		spin_lock_init(&right_pa.pa_lock);
+		right_pa.pa_lstart = EXT4_C2B(sbi, 8);
+		right_pa.pa_len = 2;
+		right_pa.pa_free = 2;
+		right_pa.pa_deleted = 0;
+
+		rb_link_node(&left_pa.pa_node.inode_node, NULL,
+			     &ei->i_prealloc_node.rb_node);
+		rb_insert_color(&left_pa.pa_node.inode_node, &ei->i_prealloc_node);
+		rb_link_node(&right_pa.pa_node.inode_node,
+			     &left_pa.pa_node.inode_node,
+			     &left_pa.pa_node.inode_node.rb_right);
+		rb_insert_color(&right_pa.pa_node.inode_node, &ei->i_prealloc_node);
+
+		ext4_mb_normalize_request_test(&ac, &ar);
+		ei->i_prealloc_node = RB_ROOT;
+
+		KUNIT_EXPECT_EQ(test, ac.ac_g_ex.fe_logical, EXT4_C2B(sbi, 3));
+		KUNIT_EXPECT_EQ(test, ac.ac_g_ex.fe_len, 5);
+	}
+}
+
+static void test_mb_inode_pa_lifecycle(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode;
+	struct ext4_inode_info *ei;
+	struct ext4_allocation_request ar = {};
+	struct ext4_group_info *grp;
+	ext4_group_t pa_grp;
+	ext4_grpblk_t pa_off, free_before;
+	ext4_fsblk_t blk1, blk2;
+	void *pa_bitmap;
+	int err = 0;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+	ei = EXT4_I(inode);
+	/* Large file size (> s_mb_stream_request) so inode PA is used */
+	i_size_write(inode, (loff_t)(sbi->s_mb_stream_request + 64) << sb->s_blocksize_bits);
+
+	ar.inode = inode;
+	ar.logical = 0;
+	ar.len = 1;
+	ar.goal = ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
+	ar.flags = EXT4_MB_HINT_DATA;
+
+	blk1 = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_NE(test, blk1, 0ULL);
+	KUNIT_EXPECT_EQ(test, ar.len, 1);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ei->i_prealloc_active), 1);
+	KUNIT_EXPECT_FALSE(test, RB_EMPTY_ROOT(&ei->i_prealloc_node));
+
+	ext4_get_group_no_and_offset(sb, blk1, &pa_grp, &pa_off);
+	grp = ext4_get_group_info(sb, pa_grp);
+	free_before = ext4_free_group_clusters(sb, &MBT_GRP_CTX(sb, pa_grp)->desc) + 1;
+
+	/* Verify ext4_mb_generate_from_pa marks the PA's clusters in a bitmap */
+	pa_bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pa_bitmap);
+	ext4_lock_group(sb, pa_grp);
+	ext4_mb_generate_from_pa_test(sb, pa_bitmap, pa_grp);
+	ext4_unlock_group(sb, pa_grp);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(pa_off, pa_bitmap), 0);
+
+	/* Second sequential allocation is served directly from the inode PA */
+	ar.logical = EXT4_C2B(sbi, 1);
+	ar.len = 1;
+	ar.goal = blk1 + EXT4_C2B(sbi, 1);
+	blk2 = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, blk2, blk1 + EXT4_C2B(sbi, 1));
+
+	/* Discard inode preallocations and verify cleanup */
+	ext4_discard_preallocations(inode);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ei->i_prealloc_active), 0);
+	KUNIT_EXPECT_TRUE(test, RB_EMPTY_ROOT(&ei->i_prealloc_node));
+	/* Only the 2 allocated clusters should remain used in the group */
+	KUNIT_EXPECT_EQ(test, grp->bb_free, free_before - 2);
+}
+
+static void test_mb_group_pa_lifecycle(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode1, *inode2;
+	struct ext4_allocation_request ar = {};
+	struct ext4_group_info *grp;
+	ext4_fsblk_t blk1, blk2;
+	int err = 0, discarded;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode1 = mbt_alloc_test_inode(test, sb, S_IFREG);
+	inode2 = mbt_alloc_test_inode(test, sb, S_IFREG);
+	inode2->i_ino = 13;
+
+	/* Small files (<= s_mb_stream_request) use locality group PA (MB_GROUP_PA) */
+	i_size_write(inode1, sb->s_blocksize);
+	i_size_write(inode2, sb->s_blocksize);
+
+	ar.inode = inode1;
+	ar.logical = 0;
+	ar.len = 1;
+	ar.goal = ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
+	ar.flags = EXT4_MB_HINT_DATA;
+
+	blk1 = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, blk1, ext4_group_first_block_no(sb, TEST_GOAL_GROUP));
+
+	/* Second small file allocation reuses the locality group PA */
+	ar.inode = inode2;
+	ar.logical = 0;
+	ar.len = 1;
+	ar.goal = ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
+	blk2 = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, blk2, blk1 + EXT4_C2B(sbi, 1));
+
+	/* Discard all group preallocations and verify free count is restored */
+	discarded = ext4_mb_discard_preallocations_test(sb, 0);
+	rcu_barrier();
+	KUNIT_EXPECT_EQ(test, discarded, (int)sbi->s_mb_group_prealloc - 2);
+
+	grp = ext4_get_group_info(sb, TEST_GOAL_GROUP);
+	KUNIT_EXPECT_EQ(test, grp->bb_free, EXT4_CLUSTERS_PER_GROUP(sb) - 2);
+}
+
+static void test_mb_lg_list_trim(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_locality_group *lg;
+	struct inode *inode;
+	struct ext4_buddy e4b;
+	struct ext4_prealloc_space *pa;
+	int i, ret, count = 0;
+	int order = fls(15) - 1; /* pa_free = 15 -> order 3 */
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+	sbi->s_mb_group_prealloc = 16;
+
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/*
+	 * Create 9 locality-group PAs in bucket order 3 (each of length 16 with
+	 * 1 cluster used -> pa_free = 15). When the 9th PA is added via
+	 * ext4_mb_release_context -> ext4_mb_add_n_trim, lg_prealloc_count > 8
+	 * triggers ext4_mb_discard_lg_preallocations() to trim the list to 5!
+	 */
+	for (i = 0; i < 9; i++) {
+		struct ext4_allocation_context ac = {};
+		struct ext4_free_extent ex = {
+			.fe_group = TEST_GOAL_GROUP,
+			.fe_start = i * 32,
+			.fe_len = 16,
+		};
+
+		ac.ac_sb = sb;
+		ac.ac_inode = inode;
+		ac.ac_flags = EXT4_MB_HINT_DATA | EXT4_MB_HINT_GROUP_ALLOC;
+		ac.ac_lg = raw_cpu_ptr(sbi->s_locality_groups);
+		mutex_lock(&ac.ac_lg->lg_mutex);
+
+		ret = ext4_mb_pa_alloc_test(&ac);
+		if (ret) {
+			mutex_unlock(&ac.ac_lg->lg_mutex);
+			ext4_mb_unload_buddy_test(&e4b);
+			KUNIT_ASSERT_EQ(test, ret, 0);
+		}
+
+		ext4_lock_group(sb, TEST_GOAL_GROUP);
+		mb_mark_used_test(&e4b, &ex);
+		ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+		ac.ac_status = AC_STATUS_FOUND;
+		ac.ac_o_ex.fe_len = 1;
+		ac.ac_b_ex = ex;
+		ac.ac_f_ex = ex;
+		ext4_mb_new_preallocation_test(&ac);
+		/* Release context updates pa_free to 15 and runs ext4_mb_add_n_trim */
+		ext4_mb_release_context_test(&ac);
+	}
+
+	ext4_mb_unload_buddy_test(&e4b);
+
+	lg = raw_cpu_ptr(sbi->s_locality_groups);
+	spin_lock(&lg->lg_prealloc_lock);
+	list_for_each_entry(pa, &lg->lg_prealloc_list[order], pa_node.lg_list)
+		count++;
+	spin_unlock(&lg->lg_prealloc_lock);
+
+	KUNIT_EXPECT_EQ(test, count, 5);
+}
+
+static void test_mb_new_blocks_and_enospc_retry(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode1, *inode2;
+	struct ext4_allocation_request ar = {};
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	ext4_fsblk_t blk;
+	int err = 0;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode1 = mbt_alloc_test_inode(test, sb, S_IFREG);
+	inode2 = mbt_alloc_test_inode(test, sb, S_IFREG);
+	inode2->i_ino = 14;
+	i_size_write(inode1, sb->s_blocksize);
+
+	/*
+	 * Leave only 16 free clusters in group 1 and mark groups 0, 2, 3 full.
+	 * Set s_mb_group_prealloc = 16 so allocating 1 cluster for inode1
+	 * preallocates the remaining 15 clusters into a group PA (leaving
+	 * 0 free clusters in buddy for all groups).
+	 */
+	mbt_ctx_mark_used(sb, 0, 0, max);
+	ext4_free_group_clusters_set(sb, &MBT_GRP_CTX(sb, 0)->desc, 0);
+	ext4_get_group_info(sb, 0)->bb_free = 0;
+
+	mbt_ctx_mark_used(sb, 1, 16, max - 16);
+	ext4_free_group_clusters_set(sb, &MBT_GRP_CTX(sb, 1)->desc, 16);
+	ext4_get_group_info(sb, 1)->bb_free = 16;
+
+	mbt_ctx_mark_used(sb, 2, 0, max);
+	ext4_free_group_clusters_set(sb, &MBT_GRP_CTX(sb, 2)->desc, 0);
+	ext4_get_group_info(sb, 2)->bb_free = 0;
+
+	mbt_ctx_mark_used(sb, 3, 0, max);
+	ext4_free_group_clusters_set(sb, &MBT_GRP_CTX(sb, 3)->desc, 0);
+	ext4_get_group_info(sb, 3)->bb_free = 0;
+
+	percpu_counter_set(&sbi->s_freeclusters_counter, 16);
+	sbi->s_mb_group_prealloc = 16;
+
+	ar.inode = inode1;
+	ar.logical = 0;
+	ar.len = 1;
+	ar.goal = ext4_group_first_block_no(sb, 1);
+	ar.flags = EXT4_MB_HINT_DATA;
+
+	blk = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, ext4_get_group_info(sb, 1)->bb_free, 0);
+
+	/*
+	 * Now request 4 metadata clusters (no EXT4_MB_HINT_DATA so it cannot
+	 * use the PA directly). First allocator pass finds 0 free clusters,
+	 * then ext4_mb_discard_preallocations_should_retry() discards the PA
+	 * (recovering 15 clusters) and retries, succeeding!
+	 */
+	memset(&ar, 0, sizeof(ar));
+	ar.inode = inode2;
+	ar.len = 4;
+	ar.goal = ext4_group_first_block_no(sb, 1);
+	ar.flags = 0;
+
+	blk = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_NE(test, blk, 0ULL);
+	KUNIT_EXPECT_EQ(test, ar.len, 4);
+
+	/*
+	 * The 4-cluster power-of-2 allocation claimed [4, 8), leaving two
+	 * fragments [1, 4) (3 clusters) and [8, 16) (8 clusters).
+	 * Requesting 11 clusters allocates the largest fragment (8 clusters),
+	 * then requesting 3 clusters allocates [1, 4), and the next request
+	 * returns -ENOSPC.
+	 */
+	ar.len = 11;
+	blk = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, ar.len, 8);
+
+	ar.len = 3;
+	blk = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, ar.len, 3);
+
+	ar.len = 1;
+	blk = ext4_mb_new_blocks(NULL, &ar, &err);
+	KUNIT_EXPECT_EQ(test, err, -ENOSPC);
+	KUNIT_EXPECT_EQ(test, blk, 0ULL);
+}
+
+static int
+ext4_handle_dirty_metadata_Updated_stub(const char *where, unsigned int line,
+					handle_t *handle, struct inode *inode,
+					struct buffer_head *bh)
+{
+	return 0;
+}
+
+static void test_mb_mark_context_and_mark_bb(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *gdp1, *gdp2;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	ext4_grpblk_t changed = 0;
+	ext4_fsblk_t boundary_blk;
+	__u32 free_before;
+	int ret;
+
+	/* Test the real ext4_mb_mark_context implementation */
+	kunit_deactivate_static_stub(test, ext4_mb_mark_context);
+	kunit_activate_static_stub(test, __ext4_handle_dirty_metadata,
+				   ext4_handle_dirty_metadata_Updated_stub);
+
+	gdp1 = ext4_get_group_desc(sb, 1, NULL);
+	gdp2 = ext4_get_group_desc(sb, 2, NULL);
+	KUNIT_ASSERT_NOT_NULL(test, gdp1);
+	KUNIT_ASSERT_NOT_NULL(test, gdp2);
+	free_before = ext4_free_group_clusters(sb, gdp1);
+
+	/* 1. Mark [10, 20) used with EXT4_MB_BITMAP_MARKED_CHECK (0x1) */
+	ret = ext4_mb_mark_context(NULL, sb, true, 1, 10, 10, 0x0001, &changed);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, changed, 10);
+	KUNIT_EXPECT_EQ(test, ext4_free_group_clusters(sb, gdp1), free_before - 10);
+
+	/* 2. Mark overlapping [15, 25) used -> only 5 new clusters changed */
+	ret = ext4_mb_mark_context(NULL, sb, true, 1, 15, 10, 0x0001, &changed);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, changed, 5);
+	KUNIT_EXPECT_EQ(test, ext4_free_group_clusters(sb, gdp1), free_before - 15);
+
+	/* 3. Clear [10, 25) -> 15 clusters freed */
+	ret = ext4_mb_mark_context(NULL, sb, false, 1, 10, 15, 0x0001, &changed);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, changed, 15);
+	KUNIT_EXPECT_EQ(test, ext4_free_group_clusters(sb, gdp1), free_before);
+
+	/*
+	 * 4. Test ext4_mb_mark_bb across the boundary between group 1 and group 2:
+	 * 2 clusters at the end of group 1 + 3 clusters at the start of group 2.
+	 */
+	kunit_activate_static_stub(test, ext4_mb_mark_context,
+				   ext4_mb_mark_context_stub);
+	boundary_blk = ext4_group_first_block_no(sb, 2) - EXT4_C2B(sbi, 2);
+	ext4_mb_mark_bb(sb, boundary_blk, EXT4_C2B(sbi, 5), true);
+
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(max - 2, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(max - 1, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(0, mbt_ctx_bitmap(sb, 2)), 0);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(2, mbt_ctx_bitmap(sb, 2)), 0);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(3, mbt_ctx_bitmap(sb, 2)), 0);
+
+	ext4_mb_mark_bb(sb, boundary_blk, EXT4_C2B(sbi, 5), false);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(max - 2, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(0, mbt_ctx_bitmap(sb, 2)), 0);
+}
+
+static void test_ext4_free_blocks_flags_and_cross_group(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode;
+	struct ext4_buddy e4b;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	ext4_fsblk_t grp1_first = ext4_group_first_block_no(sb, 1);
+	ext4_fsblk_t grp2_first = ext4_group_first_block_no(sb, 2);
+	s64 free_before;
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+
+	/* Mark clusters [10, 20) and [max - 2, max) in group 1, and [0, 3) in group 2 used */
+	mbt_ctx_mark_used(sb, 1, 10, 10);
+	mbt_ctx_mark_used(sb, 1, max - 2, 2);
+	mbt_ctx_mark_used(sb, 2, 0, 3);
+	ext4_get_group_info(sb, 1)->bb_free -= 12;
+	ext4_get_group_info(sb, 2)->bb_free -= 3;
+
+	ret = ext4_mb_load_buddy_test(sb, 1, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ext4_mb_unload_buddy_test(&e4b);
+	ret = ext4_mb_load_buddy_test(sb, 2, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ext4_mb_unload_buddy_test(&e4b);
+
+	/*
+	 * 1. EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER | EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER:
+	 * Freeing from cluster 10 + 2 blocks through cluster 12 + 3 blocks
+	 * skips partial clusters 10 and 12 and frees only full cluster 11!
+	 */
+	ext4_free_blocks(NULL, inode, NULL,
+			 grp1_first + EXT4_C2B(sbi, 10) + 2,
+			 EXT4_C2B(sbi, 2) - 2 + 3,
+			 EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER |
+			 EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER |
+			 EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(10, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(11, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_NE(test, mb_test_bit_test(12, mbt_ctx_bitmap(sb, 1)), 0);
+
+	/*
+	 * 2. EXT4_FREE_BLOCKS_RERESERVE_CLUSTER: frees cluster 12 in bitmap & buddy
+	 * without incrementing s_freeclusters_counter.
+	 */
+	free_before = percpu_counter_sum(&sbi->s_freeclusters_counter);
+	ext4_free_blocks(NULL, inode, NULL,
+			 grp1_first + EXT4_C2B(sbi, 12),
+			 EXT4_C2B(sbi, 1),
+			 EXT4_FREE_BLOCKS_RERESERVE_CLUSTER |
+			 EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(12, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_EQ(test, percpu_counter_sum(&sbi->s_freeclusters_counter),
+			free_before);
+
+	/*
+	 * 3. Cross-group boundary free: 2 clusters at end of group 1 + 3 clusters
+	 * at start of group 2.
+	 */
+	ext4_free_blocks(NULL, inode, NULL,
+			 grp2_first - EXT4_C2B(sbi, 2),
+			 EXT4_C2B(sbi, 5),
+			 EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(max - 2, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(max - 1, mbt_ctx_bitmap(sb, 1)), 0);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(0, mbt_ctx_bitmap(sb, 2)), 0);
+	KUNIT_EXPECT_EQ(test, mb_test_bit_test(2, mbt_ctx_bitmap(sb, 2)), 0);
+}
+
+static void test_mb_free_metadata_and_process_freed_data(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode;
+	struct ext4_buddy e4b;
+	struct ext4_group_info *grp;
+	struct ext4_free_data *entry;
+	transaction_t trans = { .t_tid = 42 };
+	handle_t handle = { .h_transaction = &trans };
+	ext4_fsblk_t grp1_first = ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
+	ext4_grpblk_t merged_start = 0, merged_count = 0;
+	int node_count = 0, ret;
+	struct rb_node *n;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+
+	/* Mark clusters [20, 28) used in group 1 and load buddy */
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 20, 8);
+	grp = ext4_get_group_info(sb, TEST_GOAL_GROUP);
+	grp->bb_free -= 8;
+
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ext4_mb_unload_buddy_test(&e4b);
+
+	/*
+	 * Free [20, 22), then [25, 28), then the middle [22, 25) as metadata
+	 * with a valid journal handle (tid = 42).
+	 * This exercises rbtree insertion and both prev and next extent merging!
+	 */
+	ext4_free_blocks(&handle, inode, NULL,
+			 grp1_first + EXT4_C2B(sbi, 20), EXT4_C2B(sbi, 2),
+			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+	ext4_free_blocks(&handle, inode, NULL,
+			 grp1_first + EXT4_C2B(sbi, 25), EXT4_C2B(sbi, 3),
+			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+	ext4_free_blocks(&handle, inode, NULL,
+			 grp1_first + EXT4_C2B(sbi, 22), EXT4_C2B(sbi, 3),
+			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+
+	KUNIT_EXPECT_EQ(test, atomic_read(&sbi->s_mb_free_pending), 8);
+	/* Blocks are not yet freed in buddy until transaction commit */
+	KUNIT_EXPECT_EQ(test, grp->bb_free, EXT4_CLUSTERS_PER_GROUP(sb) - 8);
+
+	ext4_lock_group(sb, TEST_GOAL_GROUP);
+	for (n = rb_first(&grp->bb_free_root); n; n = rb_next(n)) {
+		entry = rb_entry(n, struct ext4_free_data, efd_node);
+		merged_start = entry->efd_start_cluster;
+		merged_count = entry->efd_count;
+		node_count++;
+	}
+	ext4_unlock_group(sb, TEST_GOAL_GROUP);
+
+	/* All 3 freed extents for tid 42 must have merged into a single node [20, 28) */
+	KUNIT_EXPECT_EQ(test, node_count, 1);
+	KUNIT_EXPECT_EQ(test, merged_start, 20);
+	KUNIT_EXPECT_EQ(test, merged_count, 8);
+
+	/* Commit tid 42 -> ext4_process_freed_data releases [20, 28) into buddy */
+	ext4_process_freed_data(sb, 42);
+	KUNIT_EXPECT_EQ(test, atomic_read(&sbi->s_mb_free_pending), 0);
+	KUNIT_EXPECT_TRUE(test, RB_EMPTY_ROOT(&grp->bb_free_root));
+	KUNIT_EXPECT_EQ(test, grp->bb_free, EXT4_CLUSTERS_PER_GROUP(sb));
+}
+
+static void test_ext4_group_add_blocks(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_buddy e4b;
+	struct ext4_group_info *grp;
+	ext4_fsblk_t grp1_first = ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
+	s64 free_before;
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	/* Mark [50, 60) used in group 1 and initialize buddy */
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 50, 10);
+	grp = ext4_get_group_info(sb, TEST_GOAL_GROUP);
+	grp->bb_free -= 10;
+
+	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ext4_mb_unload_buddy_test(&e4b);
+
+	free_before = percpu_counter_sum(&sbi->s_freeclusters_counter);
+	ret = ext4_group_add_blocks(NULL, sb,
+				    grp1_first + EXT4_C2B(sbi, 50),
+				    EXT4_C2B(sbi, 10));
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, grp->bb_free, EXT4_CLUSTERS_PER_GROUP(sb));
+	KUNIT_EXPECT_EQ(test, percpu_counter_sum(&sbi->s_freeclusters_counter),
+			free_before + 10);
+
+	/* Cross-group boundary addition must fail with -EINVAL */
+	ret = ext4_group_add_blocks(NULL, sb,
+				    grp1_first + EXT4_C2B(sbi, EXT4_CLUSTERS_PER_GROUP(sb) - 2),
+				    EXT4_C2B(sbi, 5));
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	/* System zone block (block 0) must fail with -EINVAL */
+	ret = ext4_group_add_blocks(NULL, sb, 0, EXT4_C2B(sbi, 1));
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+}
+
+static int mbt_discard_calls;
+static int mbt_discard_clusters;
+
+static int
+ext4_issue_discard_count_stub(struct super_block *sb, ext4_group_t block_group,
+			      ext4_grpblk_t cluster, int count)
+{
+	mbt_discard_calls++;
+	mbt_discard_clusters += count;
+	return 0;
+}
+
+static void test_ext4_trim_fs(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct fstrim_range range = {};
+	struct ext4_group_info *grp1;
+	struct inode *inode;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	inode = mbt_alloc_test_inode(test, sb, S_IFREG);
+	kunit_activate_static_stub(test, ext4_issue_discard,
+				   ext4_issue_discard_count_stub);
+
+	/*
+	 * Mark groups 0, 2, 3 completely used.
+	 * In group 1, leave only [10, 14) (4 clusters) and [30, 50) (20 clusters) free.
+	 */
+	mbt_ctx_mark_used(sb, 0, 0, max);
+	ext4_get_group_info(sb, 0)->bb_free = 0;
+	mbt_ctx_mark_used(sb, 2, 0, max);
+	ext4_get_group_info(sb, 2)->bb_free = 0;
+	mbt_ctx_mark_used(sb, 3, 0, max);
+	ext4_get_group_info(sb, 3)->bb_free = 0;
+
+	mbt_ctx_mark_used(sb, 1, 0, 10);
+	mbt_ctx_mark_used(sb, 1, 14, 16);
+	mbt_ctx_mark_used(sb, 1, 50, max - 50);
+	grp1 = ext4_get_group_info(sb, 1);
+	grp1->bb_free = 24;
+
+	/* Invalid range checks */
+	range.start = 0;
+	range.len = sb->s_blocksize - 1;
+	range.minlen = 0;
+	KUNIT_EXPECT_EQ(test, ext4_trim_fs(sb, &range), -EINVAL);
+
+	/* Trim with minlen = 10 clusters: skips [10, 14) and trims only [30, 50) (20 clusters) */
+	mbt_discard_calls = 0;
+	mbt_discard_clusters = 0;
+	range.start = 0;
+	range.len = (u64)ext4_blocks_count(sbi->s_es) << sb->s_blocksize_bits;
+	range.minlen = (u64)EXT4_C2B(sbi, 10) << sb->s_blocksize_bits;
+
+	ret = ext4_trim_fs(sb, &range);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, mbt_discard_calls, 1);
+	KUNIT_EXPECT_EQ(test, mbt_discard_clusters, 20);
+	KUNIT_EXPECT_EQ(test, range.len,
+			(u64)EXT4_C2B(sbi, 20) << sb->s_blocksize_bits);
+	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_WAS_TRIMMED(grp1));
+
+	/* Second trim with same minlen is skipped because WAS_TRIMMED is set */
+	range.len = (u64)ext4_blocks_count(sbi->s_es) << sb->s_blocksize_bits;
+	ret = ext4_trim_fs(sb, &range);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, mbt_discard_calls, 1);
+	KUNIT_EXPECT_EQ(test, range.len, 0ULL);
+
+	/* Freeing a block clears WAS_TRIMMED, allowing subsequent trim */
+	ext4_free_blocks(NULL, inode, NULL,
+			 ext4_group_first_block_no(sb, 1) + EXT4_C2B(sbi, 50),
+			 EXT4_C2B(sbi, 1), EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+	KUNIT_EXPECT_FALSE(test, EXT4_MB_GRP_WAS_TRIMMED(grp1));
+}
+
+struct mbt_query_ctx {
+	int meta_calls;
+	ext4_grpblk_t meta_start;
+	ext4_grpblk_t meta_len;
+	int free_calls;
+	ext4_grpblk_t free_starts[4];
+	ext4_grpblk_t free_lens[4];
+	int stop_after;
+};
+
+static int mbt_query_meta_cb(struct super_block *sb, ext4_group_t agno,
+			     ext4_grpblk_t start, ext4_grpblk_t len, void *priv)
+{
+	struct mbt_query_ctx *q = priv;
+
+	q->meta_calls++;
+	q->meta_start = start;
+	q->meta_len = len;
+	return 0;
+}
+
+static int mbt_query_free_cb(struct super_block *sb, ext4_group_t agno,
+			     ext4_grpblk_t start, ext4_grpblk_t len, void *priv)
+{
+	struct mbt_query_ctx *q = priv;
+
+	if (q->free_calls < 4) {
+		q->free_starts[q->free_calls] = start;
+		q->free_lens[q->free_calls] = len;
+	}
+	q->free_calls++;
+	if (q->stop_after && q->free_calls >= q->stop_after)
+		return -ECANCELED;
+	return 0;
+}
+
+static void test_ext4_mballoc_query_range(struct kunit *test)
+{
+	struct super_block *sb = (struct super_block *)test->priv;
+	struct mbt_query_ctx q = {};
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	int ret;
+
+	if (sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize exceeds pagesize");
+
+	/*
+	 * In group 1:
+	 * [0, 10) used (before bb_first_free = 10 -> reported to meta_formatter)
+	 * [10, 15) free (len 5)
+	 * [15, 25) used
+	 * [25, 32) free (len 7)
+	 * [32, max) used
+	 */
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 0, 10);
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 15, 10);
+	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 32, max - 32);
+	ext4_get_group_info(sb, TEST_GOAL_GROUP)->bb_free = 12;
+
+	ret = ext4_mballoc_query_range(sb, TEST_GOAL_GROUP, 0, 100,
+				       mbt_query_meta_cb, mbt_query_free_cb, &q);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, q.meta_calls, 1);
+	KUNIT_EXPECT_EQ(test, q.meta_start, 0);
+	KUNIT_EXPECT_EQ(test, q.meta_len, 10);
+	KUNIT_EXPECT_EQ(test, q.free_calls, 2);
+	KUNIT_EXPECT_EQ(test, q.free_starts[0], 10);
+	KUNIT_EXPECT_EQ(test, q.free_lens[0], 5);
+	KUNIT_EXPECT_EQ(test, q.free_starts[1], 25);
+	KUNIT_EXPECT_EQ(test, q.free_lens[1], 7);
+
+	/* Early abort from formatter callback propagates error code */
+	memset(&q, 0, sizeof(q));
+	q.stop_after = 1;
+	ret = ext4_mballoc_query_range(sb, TEST_GOAL_GROUP, 0, 100,
+				       NULL, mbt_query_free_cb, &q);
+	KUNIT_EXPECT_EQ(test, ret, -ECANCELED);
+	KUNIT_EXPECT_EQ(test, q.free_calls, 1);
+}
+
 static const struct mbt_ext4_block_layout mbt_test_layouts[] = {
 	{
 		.blocksize_bits = 10,
@@ -991,6 +2791,31 @@ static struct kunit_case mbt_test_cases[] = {
 	KUNIT_CASE_PARAM(test_mb_mark_used, mbt_layouts_gen_params),
 	KUNIT_CASE_PARAM(test_mb_free_blocks, mbt_layouts_gen_params),
 	KUNIT_CASE_PARAM(test_mark_diskspace_used, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_bit_ops, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_test_and_clear_bits, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_find_buddy_and_order, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_find_extent, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_generate_buddy_corrupt, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_free_blocks_double_free_and_fc_replay, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_xarray_orders_and_frag_size, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_good_group, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_find_by_goal, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_simple_and_aligned_scan, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_complex_scan_and_measure, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_regular_allocator, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_prefetch, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_initialize_context, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_normalize_request, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_inode_pa_lifecycle, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_group_pa_lifecycle, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_lg_list_trim, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_new_blocks_and_enospc_retry, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_mark_context_and_mark_bb, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_ext4_free_blocks_flags_and_cross_group, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_mb_free_metadata_and_process_freed_data, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_ext4_group_add_blocks, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_ext4_trim_fs, mbt_layouts_gen_params),
+	KUNIT_CASE_PARAM(test_ext4_mballoc_query_range, mbt_layouts_gen_params),
 	KUNIT_CASE_PARAM_ATTR(test_mb_mark_used_cost, mbt_layouts_gen_params,
 			      { .speed = KUNIT_SPEED_SLOW }),
 	{}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0f73fb826dbf..46ba07e017a3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3957,11 +3957,14 @@ void ext4_mb_release(struct super_block *sb)
 	kfree(sbi->s_mb_last_groups);
 }
 
-static inline int ext4_issue_discard(struct super_block *sb,
+int ext4_issue_discard(struct super_block *sb,
 		ext4_group_t block_group, ext4_grpblk_t cluster, int count)
 {
 	ext4_fsblk_t discard_block;
 
+	KUNIT_STATIC_STUB_REDIRECT(ext4_issue_discard, sb, block_group,
+				   cluster, count);
+
 	discard_block = (EXT4_C2B(EXT4_SB(sb), cluster) +
 			 ext4_group_first_block_no(sb, block_group));
 	count = EXT4_C2B(EXT4_SB(sb), count);
@@ -7275,12 +7278,199 @@ void ext4_free_blocks_simple_test(struct inode *inode, ext4_fsblk_t block,
 }
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_blocks_simple_test);
 
+void mb_set_bit_test(int bit, void *addr)
+{
+	mb_set_bit(bit, addr);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_set_bit_test);
+
+int mb_test_and_clear_bits_test(void *bm, int cur, int len)
+{
+	return mb_test_and_clear_bits(bm, cur, len);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_test_and_clear_bits_test);
+
+void *mb_find_buddy_test(struct ext4_buddy *e4b, int order, int *max)
+{
+	return mb_find_buddy(e4b, order, max);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_find_buddy_test);
+
+int mb_find_order_for_block_test(struct ext4_buddy *e4b, int block)
+{
+	return mb_find_order_for_block(e4b, block);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_find_order_for_block_test);
+
+int mb_find_extent_test(struct ext4_buddy *e4b, int block, int needed,
+			struct ext4_free_extent *ex)
+{
+	return mb_find_extent(e4b, block, needed, ex);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_find_extent_test);
+
+void mb_regenerate_buddy_test(struct ext4_buddy *e4b)
+{
+	mb_regenerate_buddy(e4b);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_regenerate_buddy_test);
+
+int mb_avg_fragment_size_order_test(struct super_block *sb, ext4_grpblk_t len)
+{
+	return mb_avg_fragment_size_order(sb, len);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_avg_fragment_size_order_test);
+
+void mb_update_avg_fragment_size_test(struct super_block *sb,
+				      struct ext4_group_info *grp)
+{
+	mb_update_avg_fragment_size(sb, grp);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_update_avg_fragment_size_test);
+
+void mb_set_largest_free_order_test(struct super_block *sb,
+				    struct ext4_group_info *grp)
+{
+	mb_set_largest_free_order(sb, grp);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(mb_set_largest_free_order_test);
+
+bool ext4_mb_good_group_test(struct ext4_allocation_context *ac,
+			     ext4_group_t group, enum criteria cr)
+{
+	return ext4_mb_good_group(ac, group, cr);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_good_group_test);
+
+int ext4_mb_good_group_nolock_test(struct ext4_allocation_context *ac,
+				   ext4_group_t group, enum criteria cr)
+{
+	return ext4_mb_good_group_nolock(ac, group, cr);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_good_group_nolock_test);
+
+int ext4_mb_find_by_goal_test(struct ext4_allocation_context *ac,
+			      struct ext4_buddy *e4b)
+{
+	return ext4_mb_find_by_goal(ac, e4b);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_find_by_goal_test);
+
+void ext4_mb_simple_scan_group_test(struct ext4_allocation_context *ac,
+				    struct ext4_buddy *e4b)
+{
+	ext4_mb_simple_scan_group(ac, e4b);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_simple_scan_group_test);
+
+void ext4_mb_scan_aligned_test(struct ext4_allocation_context *ac,
+			       struct ext4_buddy *e4b)
+{
+	ext4_mb_scan_aligned(ac, e4b);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_scan_aligned_test);
+
+void ext4_mb_complex_scan_group_test(struct ext4_allocation_context *ac,
+				     struct ext4_buddy *e4b)
+{
+	ext4_mb_complex_scan_group(ac, e4b);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_complex_scan_group_test);
+
+void ext4_mb_measure_extent_test(struct ext4_allocation_context *ac,
+				 struct ext4_free_extent *ex,
+				 struct ext4_buddy *e4b)
+{
+	ext4_mb_measure_extent(ac, ex, e4b);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_measure_extent_test);
+
+void ext4_mb_try_best_found_test(struct ext4_allocation_context *ac,
+				 struct ext4_buddy *e4b)
+{
+	ext4_mb_try_best_found(ac, e4b);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_try_best_found_test);
+
+int ext4_mb_regular_allocator_test(struct ext4_allocation_context *ac)
+{
+	return ext4_mb_regular_allocator(ac);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_regular_allocator_test);
+
+void ext4_mb_initialize_context_test(struct ext4_allocation_context *ac,
+				     struct ext4_allocation_request *ar)
+{
+	ext4_mb_initialize_context(ac, ar);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_initialize_context_test);
+
+void ext4_mb_normalize_request_test(struct ext4_allocation_context *ac,
+				    struct ext4_allocation_request *ar)
+{
+	ext4_mb_normalize_request(ac, ar);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_normalize_request_test);
+
+bool ext4_mb_use_preallocated_test(struct ext4_allocation_context *ac)
+{
+	return ext4_mb_use_preallocated(ac);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_use_preallocated_test);
+
+void ext4_mb_new_preallocation_test(struct ext4_allocation_context *ac)
+{
+	ext4_mb_new_preallocation(ac);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_new_preallocation_test);
+
+void ext4_mb_release_context_test(struct ext4_allocation_context *ac)
+{
+	ext4_mb_release_context(ac);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_release_context_test);
+
+int ext4_mb_pa_alloc_test(struct ext4_allocation_context *ac)
+{
+	return ext4_mb_pa_alloc(ac);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_pa_alloc_test);
+
+void ext4_mb_pa_put_free_test(struct ext4_allocation_context *ac)
+{
+	ext4_mb_pa_put_free(ac);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_pa_put_free_test);
+
+void ext4_mb_generate_from_pa_test(struct super_block *sb, void *bitmap,
+				   ext4_group_t group)
+{
+	ext4_mb_generate_from_pa(sb, bitmap, group);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_generate_from_pa_test);
+
+int ext4_mb_discard_group_preallocations_test(struct super_block *sb,
+					      ext4_group_t group, int *busy)
+{
+	return ext4_mb_discard_group_preallocations(sb, group, busy);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_discard_group_preallocations_test);
+
+int ext4_mb_discard_preallocations_test(struct super_block *sb, int needed)
+{
+	return ext4_mb_discard_preallocations(sb, needed);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_discard_preallocations_test);
+
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_wait_block_bitmap);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_init);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_get_group_desc);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_count_free_clusters);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_get_group_info);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_group_clusters);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_group_clusters_set);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_get_group_no_and_offset);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_get_group_number);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_release);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_read_block_bitmap_nowait);
 EXPORT_SYMBOL_FOR_EXT4_TEST(mb_set_bits);
@@ -7288,4 +7478,13 @@ EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fc_init_inode);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_mark_context);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_new_blocks);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_blocks);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_prefetch);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_prefetch_fini);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_discard_preallocations);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_mark_bb);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_process_freed_data);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_group_add_blocks);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_trim_fs);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mballoc_query_range);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_issue_discard);
 #endif
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 39333ce72cbd..17751ed6c9f5 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -275,6 +275,8 @@ extern int ext4_mb_mark_context(handle_t *handle,
 		ext4_group_t group, ext4_grpblk_t blkoff,
 		ext4_grpblk_t len, int flags,
 		ext4_grpblk_t *ret_changed);
+extern int ext4_issue_discard(struct super_block *sb,
+		ext4_group_t block_group, ext4_grpblk_t cluster, int count);
 #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
 extern void mb_clear_bits_test(void *bm, int cur, int len);
 extern ext4_fsblk_t
@@ -283,7 +285,54 @@ ext4_mb_new_blocks_simple_test(struct ext4_allocation_request *ar,
 extern int mb_find_next_zero_bit_test(void *addr, int max, int start);
 extern int mb_find_next_bit_test(void *addr, int max, int start);
 extern void mb_clear_bit_test(int bit, void *addr);
+extern void mb_set_bit_test(int bit, void *addr);
 extern int mb_test_bit_test(int bit, void *addr);
+extern int mb_test_and_clear_bits_test(void *bm, int cur, int len);
+extern void *mb_find_buddy_test(struct ext4_buddy *e4b, int order, int *max);
+extern int mb_find_order_for_block_test(struct ext4_buddy *e4b, int block);
+extern int mb_find_extent_test(struct ext4_buddy *e4b, int block, int needed,
+			       struct ext4_free_extent *ex);
+extern void mb_regenerate_buddy_test(struct ext4_buddy *e4b);
+extern int mb_avg_fragment_size_order_test(struct super_block *sb,
+					   ext4_grpblk_t len);
+extern void mb_update_avg_fragment_size_test(struct super_block *sb,
+					     struct ext4_group_info *grp);
+extern void mb_set_largest_free_order_test(struct super_block *sb,
+					   struct ext4_group_info *grp);
+extern bool ext4_mb_good_group_test(struct ext4_allocation_context *ac,
+				    ext4_group_t group, enum criteria cr);
+extern int ext4_mb_good_group_nolock_test(struct ext4_allocation_context *ac,
+					  ext4_group_t group, enum criteria cr);
+extern int ext4_mb_find_by_goal_test(struct ext4_allocation_context *ac,
+				     struct ext4_buddy *e4b);
+extern void ext4_mb_simple_scan_group_test(struct ext4_allocation_context *ac,
+					   struct ext4_buddy *e4b);
+extern void ext4_mb_scan_aligned_test(struct ext4_allocation_context *ac,
+				      struct ext4_buddy *e4b);
+extern void ext4_mb_complex_scan_group_test(struct ext4_allocation_context *ac,
+					    struct ext4_buddy *e4b);
+extern void ext4_mb_measure_extent_test(struct ext4_allocation_context *ac,
+					struct ext4_free_extent *ex,
+					struct ext4_buddy *e4b);
+extern void ext4_mb_try_best_found_test(struct ext4_allocation_context *ac,
+					struct ext4_buddy *e4b);
+extern int ext4_mb_regular_allocator_test(struct ext4_allocation_context *ac);
+extern void ext4_mb_initialize_context_test(struct ext4_allocation_context *ac,
+					    struct ext4_allocation_request *ar);
+extern void ext4_mb_normalize_request_test(struct ext4_allocation_context *ac,
+					   struct ext4_allocation_request *ar);
+extern bool ext4_mb_use_preallocated_test(struct ext4_allocation_context *ac);
+extern void ext4_mb_new_preallocation_test(struct ext4_allocation_context *ac);
+extern void ext4_mb_release_context_test(struct ext4_allocation_context *ac);
+extern int ext4_mb_pa_alloc_test(struct ext4_allocation_context *ac);
+extern void ext4_mb_pa_put_free_test(struct ext4_allocation_context *ac);
+extern void ext4_mb_generate_from_pa_test(struct super_block *sb, void *bitmap,
+					  ext4_group_t group);
+extern int ext4_mb_discard_group_preallocations_test(struct super_block *sb,
+						     ext4_group_t group,
+						     int *busy);
+extern int ext4_mb_discard_preallocations_test(struct super_block *sb,
+					       int needed);
 extern int
 ext4_mb_mark_diskspace_used_test(struct ext4_allocation_context *ac,
 				 handle_t *handle);
-- 
2.56.0.542.g3ef89b7020-goog

