Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456425;
	b=ntCM1kG2eZ2pI2v7bho9jK7x93rGyx7pk5VVjnZoIGioMXlppPqBjFM5W6VzmWrIhwsK
	 BC4Gqg9IMRyBCVllX7eQjUijKXtpbkUhegsBrK3XjPu+qLB6zTMYopp2DHziH7/tR6g5i
	 IlHMGhRnvp6lroK0QSCbhJL8ZE4l8J0cogAfNnwZVmsslfz0tS2U6Vw3rqRhbsRoPH3AO
	 dWMElzIZrepsDdBjk9NipZEZTXxR2vNonfRVi06M/a8Bh5g+pjESgoaQy5NbDwEYMZ8zy
	 BvauD3Dp4bzMKgMSFRF4z4+HEvvbBfhUk/QArh14lNY2pvFVLbdJLyxhih47ySG1ZNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456425;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=quFrJdg4im+Pc3+e+v3r6gX+L0ZjrmV98ZhnhuGYFRo=;
	b=2zMtn2IG9ITFZtJQM7zNAltofwn0knv3szr/aU7Lckv7w/ZuUwgnfwHxeRqx/kHvxcXM
	 VsBGdA5c4ePzbpZHsFr/FAKLu7Sj21pZmsRNL1tk6K8JskFHRc7shz4giNDdO7Hu50GRH
	 htho1M/pQ0GHDtdtIOJZg7icVKf9t7Xfq38LMqAyb+pZGrVwMAVGWnupcQbjpqfyBp9eC
	 ryzsH7jso5UiiDRMdNKimt/w+RKemDRNLOq4kvO80ckl+kSPmJfzyqKJP8rfsxLp8ciGy
	 mAhrhPTOUZ/2RGgBB9hVpEFCcGSVk0Cjcgf8uzMDf4PXuDURoAGwlJtfQy77niLhKEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="U/Pqpn8G";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DA0606A885
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8DA0606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=U/Pqpn8G
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46seF016929
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456416; bh=quFrJdg4im+Pc3+e+v3r6gX+L0ZjrmV98ZhnhuGYFRo=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=U/Pqpn8GXWiM4/plxk/hkx9qoWYyXPEdEPB0DWGG5cxvePi97BQgZfj1yl77bARoX
	 FRfpWbxnlBhvYwAN31ckQMvsR3Ae/Y/T7i+fWve6Zga0DXJC43TyU1odolF9urtURC
	 +0oLVSXNSOCdYgEnaeZVuUpAb5EC6Fj6CPy9SVLR1QQFf4qh1FJJ9/UwoNjNhFLteC
	 nuo3f7fxQ7dS/LoIGxAsi9s40XgP8I53izd21SuZPUoaofiZ1TrKBosZ9qlJv2ViNe
	 dHXO01SvH3/yLcvvFAZJv4DnluTYSt50cQkgDPSgvd/OambywcMe/YgBZ1jfy3FOdr
	 14BgZuVb7fg7Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 9057A2E015C; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 23/27] ext4: expand KUnit tests in fs/ext4/extents-test.c for file range operations
Date: Wed, 11 Nov 2026 23:06:34 -0500
Message-ID: <20261112040638.1576836-24-tytso@mit.edu>
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

Expand ext4_extents_test to cover high-level file-range operations and
reporting entry points in fs/ext4/extents.c:

- ext4_fallocate() mode validation (unsupported flags, encrypted
  collapse/insert rejection, FALLOC_FL_WRITE_ZEROES device limit check,
  non-extent inode rejection), preallocation with and without
  FALLOC_FL_KEEP_SIZE, and hole punching via FALLOC_FL_PUNCH_HOLE
- ext4_zero_range() via FALLOC_FL_ZERO_RANGE (written-to-unwritten split
  and EOF extension) and FALLOC_FL_WRITE_ZEROES (block zeroouts,
  unwritten-to-written conversion, and orphan tracking across EOF)
- ext4_collapse_range() alignment/EOF validation, block freeing,
  left-shift of trailing extents, and adjacent extent coalescing
- ext4_insert_range() alignment/EOF/maxbytes validation, mid-extent
  splitting, right-shift of trailing extents, and i_size growth
- ext4_convert_unwritten_extents(),
  ext4_convert_unwritten_extents_atomic(), and
  ext4_convert_unwritten_io_end_vec() IO completion conversions
- ext4_fiemap() and ext4_get_es_cache() range checks, FIEMAP_FLAG_CACHE
  precaching, external xattr reporting, and status extent reporting

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents-test.c | 519 ++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/extents.c      |   6 +
 2 files changed, 522 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 7565a8aa4e10..4f1746be323f 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -15,8 +15,11 @@
 #include <kunit/static_stub.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/falloc.h>
+#include <linux/fiemap.h>
 #include <linux/fs_context.h>
 #include <linux/gfp_types.h>
+#include <linux/iversion.h>
 #include <linux/stddef.h>
 
 #include "ext4.h"
@@ -71,6 +74,13 @@ struct kunit_ctx {
 	int last_free_flags;
 	unsigned long total_freed_blocks;
 
+	unsigned int zeroout_calls;
+	ext4_lblk_t last_zeroout_lblk;
+	ext4_lblk_t last_zeroout_len;
+	unsigned int orphan_add_calls;
+	unsigned int orphan_del_calls;
+	struct dentry k_dentry;
+
 	bool fail_getblk;
 } k_ctx;
 
@@ -200,20 +210,29 @@ static void ext_init_mock_inode(struct ext4_inode_info *ei,
 	inode->i_sb = sb;
 	inode->i_ino = ino;
 	inode->i_mode = S_IFREG | 0644;
+	set_nlink(inode, 1);
 	inode->i_blkbits = sb->s_blocksize_bits;
-	inode->i_flags |= S_NOQUOTA;
+	inode->i_flags |= S_NOQUOTA | S_NOSEC;
 	inode->i_mapping = &inode->i_data;
+	inode_set_iversion(inode, 1);
 
 	spin_lock_init(&inode->i_lock);
 	init_rwsem(&inode->i_rwsem);
-	init_rwsem(&inode->i_data.invalidate_lock);
+	address_space_init_once(&inode->i_data);
+	inode->i_data.host = inode;
 	inode_state_set_raw(inode, I_DIRTY_SYNC | I_DIRTY_DATASYNC);
 
 	ext4_es_init_tree(&ei->i_es_tree);
 	ext4_init_pending_tree(&ei->i_pending_tree);
 	rwlock_init(&ei->i_es_lock);
 	INIT_LIST_HEAD(&ei->i_es_list);
+	INIT_LIST_HEAD(&ei->i_orphan);
+	INIT_LIST_HEAD(&ei->i_fc_list);
+	INIT_LIST_HEAD(&ei->i_fc_dilist);
+	spin_lock_init(&ei->i_fc_lock);
 	init_rwsem(&ei->i_data_sem);
+	init_rwsem(&ei->xattr_sem);
+	spin_lock_init(&ei->i_raw_lock);
 	spin_lock_init(&ei->i_block_reservation_lock);
 	rwlock_init(&ei->i_prealloc_lock);
 	ei->i_prealloc_node = RB_ROOT;
@@ -267,6 +286,7 @@ static void extents_kunit_exit(struct kunit *test)
 
 	kfree(k_ctx.meta_blocks);
 	kfree(sbi->s_es);
+	kfree(sb->s_bdev->bd_queue);
 	kfree(sb->s_bdev->bd_mapping);
 	kfree(sb->s_bdev);
 	kfree(sbi);
@@ -490,16 +510,22 @@ static int extents_kunit_init(struct kunit *test)
 		err = -ENOMEM;
 		goto out_bdev;
 	}
+	sb->s_bdev->bd_queue = kzalloc_obj(struct request_queue);
+	if (!sb->s_bdev->bd_queue) {
+		err = -ENOMEM;
+		goto out_bdev_mapping;
+	}
 
 	sbi->s_es = kzalloc_obj(struct ext4_super_block);
 	if (!sbi->s_es) {
 		err = -ENOMEM;
-		goto out_bdev_mapping;
+		goto out_bdev_queue;
 	}
 	sbi->s_es->s_first_data_block = cpu_to_le32(1);
 	sbi->s_es->s_rev_level = cpu_to_le32(EXT4_DYNAMIC_REV);
 	ext4_blocks_count_set(sbi->s_es, EXT_TOTAL_BLOCKS);
 	set_opt(sb, ERRORS_CONT);
+	sbi->s_bitmap_maxbytes = 1ULL << 40;
 	sbi->s_blocks_per_group = 32768;
 	sbi->s_clusters_per_group = 32768;
 	sbi->s_cluster_ratio = 1;
@@ -507,12 +533,20 @@ static int extents_kunit_init(struct kunit *test)
 	sbi->s_desc_per_block = 64;
 	sbi->s_groups_count = 32;
 	sbi->s_extent_max_zeroout_kb = 32;
+	mutex_init(&sbi->s_orphan_lock);
+	INIT_LIST_HEAD(&sbi->s_orphan);
 	spin_lock_init(&sbi->s_bdev_wb_lock);
 	spin_lock_init(&sbi->s_error_lock);
 	spin_lock_init(&sbi->s_md_lock);
+	ratelimit_state_init(&sbi->s_err_ratelimit_state,
+			     DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
 	ratelimit_state_init(&sbi->s_warning_ratelimit_state,
 			     DEFAULT_RATELIMIT_INTERVAL,
 			     DEFAULT_RATELIMIT_BURST);
+	ratelimit_state_init(&sbi->s_msg_ratelimit_state,
+			     DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
 
 	err = percpu_counter_init(&sbi->s_freeclusters_counter, 100000,
 				  GFP_KERNEL);
@@ -621,6 +655,8 @@ static int extents_kunit_init(struct kunit *test)
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 out_es:
 	kfree(sbi->s_es);
+out_bdev_queue:
+	kfree(sb->s_bdev->bd_queue);
 out_bdev_mapping:
 	kfree(sb->s_bdev->bd_mapping);
 out_bdev:
@@ -2441,6 +2477,477 @@ static void test_ext_fast_commit_replay(struct kunit *test)
 			10ULL << (inode->i_sb->s_blocksize_bits - 9));
 }
 
+static int ext_range_ext_zeroout_stub(struct inode *inode,
+				      struct ext4_extent *ex)
+{
+	k_ctx.zeroout_calls++;
+	k_ctx.last_zeroout_lblk = le32_to_cpu(ex->ee_block);
+	k_ctx.last_zeroout_len = ext4_ext_get_actual_len(ex);
+	return 0;
+}
+
+static int ext_range_issue_zeroout_stub(struct inode *inode, ext4_lblk_t lblk,
+					ext4_fsblk_t pblk, ext4_lblk_t len)
+{
+	k_ctx.zeroout_calls++;
+	k_ctx.last_zeroout_lblk = lblk;
+	k_ctx.last_zeroout_len = len;
+	return 0;
+}
+
+static int ext_orphan_add_stub(handle_t *handle, struct inode *inode)
+{
+	k_ctx.orphan_add_calls++;
+	return 0;
+}
+
+static int ext_orphan_del_stub(handle_t *handle, struct inode *inode)
+{
+	k_ctx.orphan_del_calls++;
+	return 0;
+}
+
+static void ext_setup_range_test(struct kunit *test, struct inode *inode,
+				 struct file *file)
+{
+	kunit_activate_static_stub(test, ext4_ext_zeroout,
+				   ext_range_ext_zeroout_stub);
+	kunit_activate_static_stub(test, ext4_issue_zeroout,
+				   ext_range_issue_zeroout_stub);
+	kunit_activate_static_stub(test, ext4_orphan_add, ext_orphan_add_stub);
+	kunit_activate_static_stub(test, ext4_orphan_del, ext_orphan_del_stub);
+
+	ext_reset_tree(inode);
+	inode->i_size = 0;
+	EXT4_I(inode)->i_disksize = 0;
+	inode->i_blocks = 0;
+
+	k_ctx.next_alloc_pblk = EXT_ALLOC_BASE_PBLK;
+	k_ctx.alloc_calls = 0;
+	k_ctx.free_calls = 0;
+	k_ctx.total_freed_blocks = 0;
+	k_ctx.zeroout_calls = 0;
+	k_ctx.orphan_add_calls = 0;
+	k_ctx.orphan_del_calls = 0;
+
+	if (file) {
+		struct file tmp = {
+			.f_path		= { .dentry = &k_ctx.k_dentry },
+			.f_inode	= inode,
+			.f_mapping	= inode->i_mapping,
+			.f_mode		= FMODE_READ | FMODE_WRITE |
+					  FMODE_NOCMTIME,
+		};
+
+		memset(&k_ctx.k_dentry, 0, sizeof(k_ctx.k_dentry));
+		k_ctx.k_dentry.d_inode = inode;
+		memcpy(file, &tmp, sizeof(tmp));
+	}
+}
+
+static void ext_expect_extent_at(struct kunit *test, struct inode *inode,
+				 ext4_lblk_t lblk, unsigned short exp_len,
+				 ext4_fsblk_t exp_pblk, bool exp_unwritten)
+{
+	struct ext4_ext_path *path;
+	struct ext4_extent *ex;
+
+	down_read(&EXT4_I(inode)->i_data_sem);
+	path = ext4_find_extent(inode, lblk, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(path));
+	ex = path[path->p_depth].p_ext;
+	KUNIT_ASSERT_NOT_NULL(test, ex);
+
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex->ee_block), lblk);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(ex), exp_len);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(ex), exp_pblk);
+	KUNIT_EXPECT_EQ(test, !!ext4_ext_is_unwritten(ex), exp_unwritten);
+
+	ext4_free_ext_path(path);
+	up_read(&EXT4_I(inode)->i_data_sem);
+}
+
+/*
+ * Verify ext4_fallocate() mode validation (unsupported flags, encrypted
+ * collapse/insert rejection, WRITE_ZEROES without bdev support, non-extent
+ * preallocation rejection), preallocation with and without FALLOC_FL_KEEP_SIZE,
+ * and hole punching via FALLOC_FL_PUNCH_HOLE.
+ */
+static void test_fallocate_modes_and_prealloc(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct file file;
+	long ret;
+
+	ext_setup_range_test(test, inode, &file);
+
+	/* Unsupported mode flag -> -EOPNOTSUPP */
+	ret = ext4_fallocate(&file, 0x40000000, 0, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EOPNOTSUPP);
+
+	/* FALLOC_FL_WRITE_ZEROES without unmap sectors -> -EOPNOTSUPP */
+	ret = ext4_fallocate(&file, FALLOC_FL_WRITE_ZEROES, 0, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EOPNOTSUPP);
+
+	/* Encrypted inode rejects COLLAPSE_RANGE and INSERT_RANGE */
+	inode->i_flags |= S_ENCRYPTED;
+	ret = ext4_fallocate(&file, FALLOC_FL_COLLAPSE_RANGE, 0, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EOPNOTSUPP);
+	ret = ext4_fallocate(&file, FALLOC_FL_INSERT_RANGE, 0, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EOPNOTSUPP);
+	inode->i_flags &= ~S_ENCRYPTED;
+
+	/* Non-extent (indirect) inode rejects fallocate preallocation */
+	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
+	ret = ext4_fallocate(&file, 0, 0, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EOPNOTSUPP);
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+
+	/* Preallocate [0, 4 blocks) with FALLOC_FL_KEEP_SIZE: i_size stays 0 */
+	ret = ext4_fallocate(&file, FALLOC_FL_KEEP_SIZE, 0, 4 * 4096);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, inode->i_size, 0LL);
+	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_disksize, 0LL);
+	ext_expect_extent_at(test, inode, 0, 4, EXT_ALLOC_BASE_PBLK, true);
+
+	/* Extend allocation across [2, 6 blocks) without KEEP_SIZE */
+	ret = ext4_fallocate(&file, 0, 2 * 4096, 4 * 4096);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, inode->i_size, 6LL * 4096);
+	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_disksize, 6LL * 4096);
+	ext_expect_extent_at(test, inode, 0, 6, EXT_ALLOC_BASE_PBLK, true);
+
+	/* Punch middle [2, 4) with FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE */
+	ret = ext4_fallocate(&file, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			     2 * 4096, 2 * 4096);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, inode->i_size, 6LL * 4096);
+	KUNIT_EXPECT_EQ(test, k_ctx.total_freed_blocks, 2UL);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(ext_inode_hdr(inode)->eh_entries), 2);
+	ext_expect_extent_at(test, inode, 0, 2, EXT_ALLOC_BASE_PBLK, true);
+	ext_expect_extent_at(test, inode, 4, 2, EXT_ALLOC_BASE_PBLK + 4, true);
+}
+
+/*
+ * Verify ext4_zero_range() via both FALLOC_FL_ZERO_RANGE (splitting written
+ * extents to unwritten and allocating unwritten blocks past EOF) and
+ * FALLOC_FL_WRITE_ZEROES (issuing block zeroouts, converting to written, and
+ * tracking orphan state when extending i_disksize).
+ */
+static void test_zero_range_and_write_zeroes(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct super_block *sb = inode->i_sb;
+	struct file file;
+	long ret;
+
+	/* Part A: FALLOC_FL_ZERO_RANGE across written tail + past EOF */
+	ext_setup_range_test(test, inode, &file);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 6, 200, false, 0), 0);
+	inode->i_size = 6LL * 4096;
+	EXT4_I(inode)->i_disksize = 6LL * 4096;
+
+	ret = ext4_fallocate(&file, FALLOC_FL_ZERO_RANGE, 2 * 4096, 6 * 4096);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, inode->i_size, 8LL * 4096);
+	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_disksize, 8LL * 4096);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(ext_inode_hdr(inode)->eh_entries), 3);
+	ext_expect_extent_at(test, inode, 0, 2, 200, false);
+	ext_expect_extent_at(test, inode, 2, 4, 202, true);
+	ext_expect_extent_at(test, inode, 6, 2, EXT_ALLOC_BASE_PBLK, true);
+
+	/* Part B: FALLOC_FL_WRITE_ZEROES over unwritten + hole past EOF */
+	ext_setup_range_test(test, inode, &file);
+	sb->s_bdev->bd_queue->limits.max_wzeroes_unmap_sectors = 1024;
+
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 2, 300, true, 0), 0);
+	inode->i_size = 2LL * 4096;
+	EXT4_I(inode)->i_disksize = 2LL * 4096;
+
+	ret = ext4_fallocate(&file, FALLOC_FL_WRITE_ZEROES, 0, 4 * 4096);
+	sb->s_bdev->bd_queue->limits.max_wzeroes_unmap_sectors = 0;
+
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_GE(test, k_ctx.zeroout_calls, 2U);
+	KUNIT_EXPECT_GE(test, k_ctx.orphan_add_calls, 1U);
+	KUNIT_EXPECT_EQ(test, k_ctx.orphan_del_calls, 1U);
+	KUNIT_EXPECT_EQ(test, inode->i_size, 4LL * 4096);
+	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_disksize, 4LL * 4096);
+	ext_expect_extent_at(test, inode, 0, 2, 300, false);
+	ext_expect_extent_at(test, inode, 2, 2, EXT_ALLOC_BASE_PBLK, false);
+}
+
+/*
+ * Verify ext4_collapse_range() validation checks, block removal, left-shift of
+ * subsequent extents, adjacent extent coalescing after collapse, and i_size
+ * reduction.
+ */
+static void test_collapse_range(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct file file;
+	long ret;
+
+	ext_setup_range_test(test, inode, &file);
+	inode->i_size = 10LL * 4096;
+	EXT4_I(inode)->i_disksize = 10LL * 4096;
+
+	/* Block-unaligned offset or length -> -EINVAL */
+	ret = ext4_fallocate(&file, FALLOC_FL_COLLAPSE_RANGE, 512, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+	ret = ext4_fallocate(&file, FALLOC_FL_COLLAPSE_RANGE, 4096, 512);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	/* Non-extent inode -> -EOPNOTSUPP */
+	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
+	ret = ext4_fallocate(&file, FALLOC_FL_COLLAPSE_RANGE, 0, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EOPNOTSUPP);
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+
+	/* Collapsing up to or beyond i_size -> -EINVAL */
+	ret = ext4_fallocate(&file, FALLOC_FL_COLLAPSE_RANGE,
+			     8 * 4096, 2 * 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	/*
+	 * Build [0, 2)@200 writ, [2, 4)@500 writ, [4, 7)@202 writ, and
+	 * [8, 10)@600 unwrit. Collapsing [2, 4) frees [2, 4)@500, shifts
+	 * [4, 7)@202 left to [2, 5)@202 where it merges with [0, 2)@200 into
+	 * [0, 5)@200, and shifts [8, 10)@600 left to [6, 8)@600.
+	 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 2, 200, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 2, 2, 500, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 4, 3, 202, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 8, 2, 600, true, 0), 0);
+
+	ret = ext4_fallocate(&file, FALLOC_FL_COLLAPSE_RANGE,
+			     2 * 4096, 2 * 4096);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, k_ctx.total_freed_blocks, 2UL);
+	KUNIT_EXPECT_EQ(test, inode->i_size, 8LL * 4096);
+	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_disksize, 8LL * 4096);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(ext_inode_hdr(inode)->eh_entries), 2);
+	ext_expect_extent_at(test, inode, 0, 5, 200, false);
+	ext_expect_extent_at(test, inode, 6, 2, 600, true);
+}
+
+/*
+ * Verify ext4_insert_range() alignment, EOF, and s_maxbytes checks, as well as
+ * mid-extent splitting, right-shift of trailing extents, and i_size growth.
+ */
+static void test_insert_range(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct file file;
+	long ret;
+
+	ext_setup_range_test(test, inode, &file);
+	inode->i_size = 10LL * 4096;
+	EXT4_I(inode)->i_disksize = 10LL * 4096;
+
+	/* Block-unaligned offset or length -> -EINVAL */
+	ret = ext4_fallocate(&file, FALLOC_FL_INSERT_RANGE, 1024, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+	ret = ext4_fallocate(&file, FALLOC_FL_INSERT_RANGE, 4096, 1024);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	/* Non-extent inode -> -EOPNOTSUPP */
+	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
+	ret = ext4_fallocate(&file, FALLOC_FL_INSERT_RANGE, 0, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EOPNOTSUPP);
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+
+	/* Offset at or beyond i_size -> -EINVAL */
+	ret = ext4_fallocate(&file, FALLOC_FL_INSERT_RANGE, 10 * 4096, 4096);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	/* Length exceeding s_maxbytes - i_size -> -EFBIG */
+	ret = ext4_fallocate(&file, FALLOC_FL_INSERT_RANGE, 4096,
+			     round_down(inode->i_sb->s_maxbytes, 4096));
+	KUNIT_EXPECT_EQ(test, ret, -EFBIG);
+
+	/*
+	 * Insert 3-block hole at lblk 2 inside [0, 6)@200 writ with trailing
+	 * [8, 10)@400 unwrit: produces [0, 2)@200 writ, [5, 9)@202 writ, and
+	 * [11, 13)@400 unwrit, with i_size = 13 blocks.
+	 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 6, 200, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 8, 2, 400, true, 0), 0);
+
+	ret = ext4_fallocate(&file, FALLOC_FL_INSERT_RANGE,
+			     2 * 4096, 3 * 4096);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, inode->i_size, 13LL * 4096);
+	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_disksize, 13LL * 4096);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(ext_inode_hdr(inode)->eh_entries), 3);
+	ext_expect_extent_at(test, inode, 0, 2, 200, false);
+	ext_expect_extent_at(test, inode, 5, 4, 202, false);
+	ext_expect_extent_at(test, inode, 11, 2, 400, true);
+}
+
+/*
+ * Verify unwritten-to-written IO completion conversion helpers:
+ * ext4_convert_unwritten_extents(), ext4_convert_unwritten_extents_atomic()
+ * across a split unwritten mapping, and ext4_convert_unwritten_io_end_vec().
+ */
+static void test_convert_unwritten_extents_and_io_end(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	ext4_io_end_t io_end = {};
+	struct ext4_io_end_vec vec1 = {}, vec2 = {};
+	ext4_lblk_t converted = 0;
+	int err;
+
+	/* 1. ext4_convert_unwritten_extents() on middle of unwritten extent */
+	ext_setup_range_test(test, inode, NULL);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 6, 200, true, 0), 0);
+
+	err = ext4_convert_unwritten_extents(NULL, inode, 2 * 4096, 2 * 4096,
+					     &converted);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, converted, 2U);
+	ext_expect_extent_at(test, inode, 0, 2, 200, true);
+	ext_expect_extent_at(test, inode, 2, 2, 202, false);
+	ext_expect_extent_at(test, inode, 4, 2, 204, true);
+
+	/* 2. ext4_convert_unwritten_extents_atomic() across split unwritten */
+	ext_setup_range_test(test, inode, NULL);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 2, 200, true, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 2, 3, 300, true, 0), 0);
+
+	err = ext4_convert_unwritten_extents_atomic(NULL, inode, 0, 5 * 4096);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	ext_expect_extent_at(test, inode, 0, 2, 200, false);
+	ext_expect_extent_at(test, inode, 2, 3, 300, false);
+
+	/* 3. ext4_convert_unwritten_io_end_vec() across multiple vecs */
+	ext_setup_range_test(test, inode, NULL);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 8, 200, true, 0), 0);
+
+	io_end.inode = inode;
+	INIT_LIST_HEAD(&io_end.list_vec);
+	vec1.offset = 1 * 4096;
+	vec1.size = 2 * 4096;
+	vec2.offset = 5 * 4096;
+	vec2.size = 2 * 4096;
+	list_add_tail(&vec1.list, &io_end.list_vec);
+	list_add_tail(&vec2.list, &io_end.list_vec);
+
+	err = ext4_convert_unwritten_io_end_vec(NULL, &io_end);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	ext_expect_extent_at(test, inode, 0, 1, 200, true);
+	ext_expect_extent_at(test, inode, 1, 2, 201, false);
+	ext_expect_extent_at(test, inode, 3, 2, 203, true);
+	ext_expect_extent_at(test, inode, 5, 2, 205, false);
+	ext_expect_extent_at(test, inode, 7, 1, 207, true);
+}
+
+/*
+ * Verify ext4_fiemap() (range checks, FIEMAP_FLAG_CACHE precaching, data and
+ * external xattr reporting) and ext4_get_es_cache() (flag checks, precaching,
+ * and reporting mapped + delayed status extents).
+ */
+static void test_ext_fiemap_and_get_es_cache(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct fiemap_extent_info fieinfo = {};
+	struct extent_status es = {};
+	int err;
+
+	ext_setup_range_test(test, inode, NULL);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 3, 200, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 6, 2, 300, true, 0), 0);
+	inode->i_size = 10LL * 4096;
+	EXT4_I(inode)->i_disksize = 10LL * 4096;
+
+	/* Zero-length FIEMAP -> -EINVAL */
+	err = ext4_fiemap(inode, &fieinfo, 0, 0);
+	KUNIT_EXPECT_EQ(test, err, -EINVAL);
+
+	/* Start past maxbytes on non-extent inode -> -EFBIG */
+	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
+	err = ext4_fiemap(inode, &fieinfo,
+			  EXT4_SB(inode->i_sb)->s_bitmap_maxbytes + 4096, 4096);
+	KUNIT_EXPECT_EQ(test, err, -EFBIG);
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+
+	/* Count-only data FIEMAP with FIEMAP_FLAG_CACHE populates ES cache */
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	fieinfo.fi_flags = FIEMAP_FLAG_CACHE;
+	err = ext4_fiemap(inode, &fieinfo, 0, 10 * 4096);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_flags & FIEMAP_FLAG_CACHE, 0U);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_extents_mapped, 2U);
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 0, NULL, &es, NULL),
+			1);
+
+	/* FIEMAP_FLAG_XATTR with no xattrs vs external i_file_acl block */
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	fieinfo.fi_flags = FIEMAP_FLAG_XATTR;
+	err = ext4_fiemap(inode, &fieinfo, 0, 4096);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_extents_mapped, 0U);
+
+	EXT4_I(inode)->i_file_acl = 750;
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	fieinfo.fi_flags = FIEMAP_FLAG_XATTR;
+	err = ext4_fiemap(inode, &fieinfo, 0, 4096);
+	EXT4_I(inode)->i_file_acl = 0;
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_extents_mapped, 1U);
+
+	/* ext4_get_es_cache: unsupported flag -> -EBADR, len == 0 -> -EINVAL */
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	fieinfo.fi_flags = FIEMAP_FLAG_XATTR;
+	err = ext4_get_es_cache(inode, &fieinfo, 0, 4096);
+	KUNIT_EXPECT_EQ(test, err, -EBADR);
+
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	err = ext4_get_es_cache(inode, &fieinfo, 0, 0);
+	KUNIT_EXPECT_EQ(test, err, -EINVAL);
+
+	/*
+	 * Populate ES tree with written, hole, delayed, and unwritten entries
+	 * and verify ext4_get_es_cache reports all 4 entries.
+	 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	ext4_es_insert_extent(inode, 0, 3, 200, EXTENT_STATUS_WRITTEN, 0);
+	ext4_es_insert_extent(inode, 3, 1, ~0, EXTENT_STATUS_HOLE, 0);
+	ext4_es_insert_delayed_extent(inode, 4, 2, false, false);
+	ext4_es_insert_extent(inode, 6, 2, 300, EXTENT_STATUS_UNWRITTEN, 0);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	err = ext4_get_es_cache(inode, &fieinfo, 0, 10 * 4096);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_extents_mapped, 4U);
+
+	/*
+	 * Build a depth-1 tree (5 discontiguous extents), clear ES cache, and
+	 * verify FIEMAP_FLAG_CACHE precaches external leaf extents + holes.
+	 */
+	ext_setup_range_test(test, inode, NULL);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 1, 200, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 2, 1, 202, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 4, 1, 204, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 6, 1, 206, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 8, 1, 208, false, 0), 0);
+	inode->i_size = 10LL * 4096;
+	EXT4_I(inode)->i_disksize = 10LL * 4096;
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	fieinfo.fi_flags = FIEMAP_FLAG_CACHE;
+	err = ext4_get_es_cache(inode, &fieinfo, 0, 10 * 4096);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_flags & FIEMAP_FLAG_CACHE, 0U);
+	KUNIT_EXPECT_GE(test, fieinfo.fi_extents_mapped, 5U);
+}
+
 static const struct kunit_ext_test_param test_split_convert_params[] = {
 	/* unwrit to writ splits */
 	{ .desc = "split unwrit extent to 2 extents and convert 1st half writ",
@@ -3001,6 +3508,12 @@ static struct kunit_case extents_test_cases[] = {
 	KUNIT_CASE(test_clu_mapped),
 	KUNIT_CASE(test_ext_credits_calculation),
 	KUNIT_CASE(test_ext_fast_commit_replay),
+	KUNIT_CASE(test_fallocate_modes_and_prealloc),
+	KUNIT_CASE(test_zero_range_and_write_zeroes),
+	KUNIT_CASE(test_collapse_range),
+	KUNIT_CASE(test_insert_range),
+	KUNIT_CASE(test_convert_unwritten_extents_and_io_end),
+	KUNIT_CASE(test_ext_fiemap_and_get_es_cache),
 	{}
 };
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index efbee7aaa95d..cbada2846190 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5034,6 +5034,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	inode_unlock(inode);
 	return ret;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fallocate);
 
 /*
  * This function converts a range of blocks to written extents. The caller of
@@ -5121,6 +5122,7 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
 
 	return ret > 0 ? ret2 : ret;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_convert_unwritten_extents_atomic);
 
 /*
  * This function convert a range of blocks to written extents
@@ -5202,6 +5204,7 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 
 	return ret;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_convert_unwritten_extents);
 
 int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 {
@@ -5233,6 +5236,7 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 
 	return ret < 0 ? ret : err;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_convert_unwritten_io_end_vec);
 
 static int ext4_iomap_xattr_fiemap(struct inode *inode, struct iomap *iomap)
 {
@@ -5345,6 +5349,7 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	inode_unlock_shared(inode);
 	return error;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fiemap);
 
 int ext4_get_es_cache(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		      __u64 start, __u64 len)
@@ -5392,6 +5397,7 @@ int ext4_get_es_cache(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	 */
 	return ext4_fill_es_cache_info(inode, start_blk, len_blks, fieinfo);
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_get_es_cache);
 
 /*
  * ext4_ext_shift_path_extents:
-- 
2.56.0.542.g3ef89b7020-goog

