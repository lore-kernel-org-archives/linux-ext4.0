Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456424;
	b=p1ztWwI85UWFYe89uo2Df2M4pJoNkSk7UxRGDFcGSAASbZs4Cj9+hzSvLGZ8iuWz1fnf
	 vIlVBYNqbAeZCxLqJ/39p6Q6T0874UUMn+pJYTFwcD02Ek+xCwhnrESThOmGLvvMdn3aA
	 cvDDiNM5UShgFuFlQmgM1dudKxfwP/bQNeeRMor4xmZy5TV8ZO+CVvh9KJve8t1iH4nTS
	 m/n+T9cG3C+r4WCXhDqCoOughQdgXifcV7d0VS0SX/dANAmkqhaN96rV8PI1t86h74ygn
	 1o26nimhM36TKVOnenCYt4KlbKZCZ7ZzcgZdKa7deGjheLh2Cjyw5bgxYe75Mnvgn0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456424;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6BWnTHakq2Gwmw/rGM327GDqhrbHZPLbSWUEEWVGyQA=;
	b=SuQrf35Kh8Yx0xkrssqXRarorw/4oh1uaGUSybXRUz/8ib/yQyj8o1aEWsHKgkYLwNyn
	 SI52lUHLQk4UP/WzxL/JDNGjI+nDgghsn9sGtxEu+8G4jY+k+j93JuQhOA5GcCIX1bXj9
	 JhjqN/ZBPRxSb3gnMBu24ynhhppvFivw0081n8E9dO74LxL+LpzXdSKm8beNXJzBPpB/d
	 WyasGUHnFx/qA3456sBM00ebrzsd5EOcTbLr73d1G753EyQ7mfqE1DP3ZVCv6lr/pM1MU
	 gKYVlioKl1r4FSonBl2bAmJWHuySluAG9RcwglJZApe8mLz5QNXyEXEuaap6KzUbPAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PZpxcro1;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA88606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBA88606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PZpxcro1
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46pmN016764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456412; bh=6BWnTHakq2Gwmw/rGM327GDqhrbHZPLbSWUEEWVGyQA=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=PZpxcro1XK+Crxb1bX1NTE+JdCCLMH5cGGstEih+s3aB0CVF1csIO93rlcw2mACpj
	 6BGsHdVpi8u8SOsthUE2+l4BStSLlRAzJxIjAfJwTUM6Lx+xe4I6qoS2RHmyy5DxUq
	 LhDj8yK6ERGuhvFPFWyHDINxbahluVjRylge/ngQVUgr6j7eyY+OZ71LbECoP6ZXAa
	 xTKJGBuLitxfpdWptzENzOHkmgjzbRqAAeyr9tlwhFP+dpGb8cvHNtPj/vSIxWsgP9
	 yYSmlFh+v6li6GJFTfWyKBh0jrNhDT7VkLwg5OW3EDi3wfyu4m5jyiqfSutFlXkElD
	 TAq3VbmpLgV7w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3EE0B2E013B; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 02/27] ext4: add KUnit tests for fs/ext4/extents.c
Date: Wed, 11 Nov 2026 23:06:13 -0500
Message-ID: <20261112040638.1576836-3-tytso@mit.edu>
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

Expand the ext4_extents_test KUnit test suite in fs/ext4/extents-test.c
to cover the core extent tree operations in fs/ext4/extents.c:

- 48-bit physical block encoding/decoding (ext4_ext_pblock,
  ext4_ext_store_pblock, ext4_idx_pblock, ext4_idx_store_pblock) and
  unwritten extent length encoding (ext4_ext_mark_unwritten,
  ext4_ext_is_unwritten, ext4_ext_get_actual_len,
  ext4_ext_mark_initialized).
- Extent tree initialization (ext4_ext_tree_init) and header/entry
  validation (ext4_ext_check_inode, __ext4_ext_check) across 13
  parameterized corruption cases (magic, depth, max, entries, empty
  non-root index, zero-length extent, logical block wrap-around,
  out-of-bounds physical blocks, overlapping/unsorted extents and
  indexes, and parent/leaf logical block mismatch).
- Metadata checksum calculation and verification on external extent
  blocks when EXT4_FEATURE_RO_COMPAT_METADATA_CSUM is enabled.
- Root and multi-level (depth >= 1) extent tree lookup and navigation
  (ext4_find_extent, ext4_ext_search_left, ext4_ext_search_right,
  ext4_ext_next_allocated_block, ext4_ext_next_leaf_block) and extent
  status precaching (ext4_ext_precache) using in-memory simulated
  metadata buffer_heads via an ext4_ext_getblk() KUnit static stub.
- Extent merge rules (ext4_can_extents_be_merged) and insertion
  (ext4_ext_insert_extent), including forward/backward/three-way
  merging, nomerge flag handling, tree depth growth
  (ext4_ext_grow_indepth), node splitting (ext4_ext_split), and tree
  collapse back into the root inode (ext4_ext_try_to_merge_up).
- Extent space removal and truncation (ext4_ext_remove_space,
  ext4_ext_truncate) across tail truncates, partial trims, middle hole
  punches, multi-level index removal (ext4_ext_rm_idx), and bigalloc
  partial-cluster nofree and pending cluster rereservation
  (ext4_rereserve_cluster).
- Block mapping and allocation (ext4_ext_map_blocks), including hole
  lookup, delayed-extent hole adjustment, QUERY_LAST_IN_LEAF, block
  allocation, overlap clamping, ENOSPC handling, unwritten-to-written
  conversion with neighbor merging, and bigalloc implied cluster
  allocation (ext4_map_cluster_from_extent).
- Extent shifting (ext4_ext_shift_extents) for FALLOC_FL_COLLAPSE_RANGE
  and FALLOC_FL_INSERT_RANGE, extent swapping (ext4_swap_extents),
  cluster mapping queries (ext4_clu_mapped), JBD2 transaction credit
  calculations (ext4_ext_calc_credits_for_single_extent,
  ext4_ext_index_trans_blocks), and fast-commit replay helpers
  (ext4_ext_replay_update_ex, ext4_ext_replay_shrink_inode,
  ext4_ext_replay_set_iblocks).
- Fix ext4_ext_path memory leaks in the existing test_split_convert()
  helpers and isolate the mock extent status shrinker from background
  reclaim.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4_extents.h |   21 +
 fs/ext4/ext4_jbd2.c    |    8 +
 fs/ext4/extents-test.c | 1886 ++++++++++++++++++++++++++++++++++++++--
 fs/ext4/extents.c      |   83 +-
 fs/ext4/inode.c        |    5 +
 fs/ext4/mballoc.c      |    7 +
 6 files changed, 1938 insertions(+), 72 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index ebaf7cc42430..40e6b3a56f71 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -268,6 +268,8 @@ extern int __ext4_ext_dirty(const char *where, unsigned int line,
 			    handle_t *handle, struct inode *inode,
 			    struct ext4_ext_path *path);
 extern int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex);
+extern struct buffer_head *ext4_ext_getblk(struct inode *inode,
+					   ext4_fsblk_t pblk, gfp_t gfp_flags);
 #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
 extern int ext4_ext_space_root_idx_test(struct inode *inode, int check);
 extern struct ext4_ext_path *ext4_split_convert_extents_test(
@@ -275,6 +277,25 @@ extern struct ext4_ext_path *ext4_split_convert_extents_test(
 				struct ext4_map_blocks *map,
 				struct ext4_ext_path *path,
 				int flags, unsigned int *allocated);
+extern int ext4_ext_check_test(struct inode *inode,
+			       struct ext4_extent_header *eh, int depth,
+			       ext4_fsblk_t pblk, ext4_lblk_t lblk);
+extern void ext4_extent_block_csum_set_test(struct inode *inode,
+					    struct ext4_extent_header *eh);
+extern int ext4_can_extents_be_merged_test(struct inode *inode,
+					   struct ext4_extent *ex1,
+					   struct ext4_extent *ex2);
+extern int ext4_ext_search_left_test(struct inode *inode,
+				     struct ext4_ext_path *path,
+				     ext4_lblk_t *logical, ext4_fsblk_t *phys);
+extern int ext4_ext_search_right_test(struct inode *inode,
+				      struct ext4_ext_path *path,
+				      ext4_lblk_t *logical, ext4_fsblk_t *phys,
+				      struct ext4_extent *ret_ex, int flags);
+extern ext4_lblk_t ext4_ext_next_leaf_block_test(struct ext4_ext_path *path);
+extern int ext4_ext_shift_extents_test(struct inode *inode, handle_t *handle,
+				       ext4_lblk_t start, ext4_lblk_t shift,
+				       enum SHIFT_DIRECTION direction);
 #endif
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 53ddedb52a6f..d6ffb6f08606 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -4,6 +4,7 @@
  */
 
 #include "ext4_jbd2.h"
+#include <kunit/static_stub.h>
 
 #include <trace/events/ext4.h>
 
@@ -379,6 +380,9 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 {
 	int err = 0;
 
+	KUNIT_STATIC_STUB_REDIRECT(__ext4_handle_dirty_metadata, where, line,
+				   handle, inode, bh);
+
 	might_sleep();
 
 	set_buffer_meta(bh);
@@ -431,3 +435,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 	}
 	return err;
 }
+
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+EXPORT_SYMBOL_FOR_EXT4_TEST(__ext4_handle_dirty_metadata);
+#endif
diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index c3836ecb89f9..705648186218 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -3,60 +3,75 @@
  * Written by Ojaswin Mujoo <ojaswin@linux.ibm.com> (IBM)
  *
  * These Kunit tests are designed to test the functionality of
- * extent split and conversion in ext4.
- *
- * Currently, ext4 can split extents in 2 ways:
- * 1. By splitting the extents in the extent tree and optionally converting them
- *    to written or unwritten based on flags passed.
- * 2. In case 1 encounters an error, ext4 instead zerooes out the unwritten
- *    areas of the extent and marks the complete extent written.
- *
- * The primary function that handles this is ext4_split_convert_extents().
- *
- * We test both of the methods of split. The behavior we try to enforce is:
- * 1. When passing EXT4_GET_BLOCKS_CONVERT flag to ext4_split_convert_extents(),
- *    the split extent should be converted to initialized.
- * 2. When passing EXT4_GET_BLOCKS_CONVERT_UNWRITTEN flag to
- *    ext4_split_convert_extents(), the split extent should be converted to
- *    uninitialized.
- * 3. In case we use the zeroout method, then we should correctly write zeroes
- *    to the unwritten areas of the extent and we should not corrupt/leak any
- *    data.
- *
- * Enforcing 1 and 2 is straight forward, we just setup a minimal inode with
- * extent tree, call ext4_split_convert_extents() and check the final state of
- * the extent tree.
- *
- * For zeroout testing, we maintain a separate buffer which represents the disk
- * data corresponding to the extents. We then override ext4's zeroout functions
- * to instead write zeroes to our buffer. Then, we override
- * ext4_ext_insert_extent() to return -ENOSPC, which triggers the zeroout.
- * Finally, we check the state of the extent tree and zeroout buffer to confirm
- * everything went well.
+ * fs/ext4/extents.c, including extent tree initialization and validation,
+ * binary search and multi-level navigation, extent insertion, merging,
+ * splitting, tree depth growth and collapse, space removal and bigalloc
+ * partial cluster handling, block mapping, unwritten-to-written conversion,
+ * zeroout fallback, extent shifting, extent swapping, cluster mapping,
+ * transaction credit calculation, and fast-commit replay helpers.
  */
 
 #include <kunit/test.h>
 #include <kunit/static_stub.h>
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
 #include <linux/fs_context.h>
 #include <linux/gfp_types.h>
 #include <linux/stddef.h>
 
 #include "ext4.h"
 #include "ext4_extents.h"
+#include "ext4_jbd2.h"
 
 #define EXT_DATA_PBLK 100
 #define EXT_DATA_LBLK 10
 #define EXT_DATA_LEN 3
 
+#define EXT_MAX_META_BLOCKS 16
+#define EXT_META_BASE_PBLK  500
+#define EXT_ALLOC_BASE_PBLK 1000
+#define EXT_TOTAL_BLOCKS    0x100000ULL
+
+struct kunit_meta_block {
+	ext4_fsblk_t pblk;
+	struct buffer_head bh;
+	char data[4096];
+	bool in_use;
+};
+
 struct kunit_ctx {
 	/*
-	 * Ext4 inode which has only 1 unwrit extent
+	 * Ext4 inode initialized with 1 extent by default
 	 */
 	struct ext4_inode_info *k_ei;
+	/*
+	 * Optional secondary inode (used for swap_extents tests)
+	 */
+	struct ext4_inode_info *k_ei2;
 	/*
 	 * Represents the underlying data area (used for zeroout testing)
 	 */
 	char *k_data;
+	/*
+	 * In-memory pool of external extent tree blocks (leaf/index blocks)
+	 */
+	struct kunit_meta_block *meta_blocks;
+	/*
+	 * Mock block allocator and free tracking
+	 */
+	ext4_fsblk_t next_alloc_pblk;
+	unsigned int alloc_calls;
+	ext4_fsblk_t last_alloc_pblk;
+	unsigned int last_alloc_len;
+	int fail_alloc_err;
+
+	unsigned int free_calls;
+	ext4_fsblk_t last_free_pblk;
+	unsigned long last_free_count;
+	int last_free_flags;
+	unsigned long total_freed_blocks;
+
+	bool fail_getblk;
 } k_ctx;
 
 /*
@@ -126,6 +141,31 @@ struct kunit_ext_test_param {
 	struct kunit_ext_data_state exp_data_state[3];
 };
 
+static unsigned long ext_dummy_shrinker_count(struct shrinker *shrink,
+					      struct shrink_control *sc)
+{
+	return 0;
+}
+
+static unsigned long ext_dummy_shrinker_scan(struct shrinker *shrink,
+					     struct shrink_control *sc)
+{
+	return SHRINK_STOP;
+}
+
+static const struct super_operations ext_dummy_sops = {};
+
+#ifdef CONFIG_QUOTA
+static qsize_t *ext_get_reserved_space(struct inode *inode)
+{
+	return &EXT4_I(inode)->i_reserved_quota;
+}
+
+static const struct dquot_operations ext_dummy_qops = {
+	.get_reserved_space = ext_get_reserved_space,
+};
+#endif
+
 static int ext_init_fs_context(struct fs_context *fc)
 {
 	return 0;
@@ -142,33 +182,201 @@ static struct file_system_type ext_fs_type = {
 	.kill_sb	 = kill_anon_super,
 };
 
+static void ext_init_mock_inode(struct ext4_inode_info *ei,
+				struct super_block *sb, unsigned long ino)
+{
+	struct inode *inode = &ei->vfs_inode;
+
+	memset(ei, 0, sizeof(*ei));
+	inode->i_sb = sb;
+	inode->i_ino = ino;
+	inode->i_mode = S_IFREG | 0644;
+	inode->i_blkbits = sb->s_blocksize_bits;
+	inode->i_flags |= S_NOQUOTA;
+	inode->i_mapping = &inode->i_data;
+
+	spin_lock_init(&inode->i_lock);
+	init_rwsem(&inode->i_rwsem);
+	init_rwsem(&inode->i_data.invalidate_lock);
+	inode_state_set_raw(inode, I_DIRTY_SYNC | I_DIRTY_DATASYNC);
+
+	ext4_es_init_tree(&ei->i_es_tree);
+	ext4_init_pending_tree(&ei->i_pending_tree);
+	rwlock_init(&ei->i_es_lock);
+	INIT_LIST_HEAD(&ei->i_es_list);
+	init_rwsem(&ei->i_data_sem);
+	spin_lock_init(&ei->i_block_reservation_lock);
+	rwlock_init(&ei->i_prealloc_lock);
+	ei->i_prealloc_node = RB_ROOT;
+	ei->i_csum_seed = 0x12345678;
+
+	ei->i_disksize = (EXT_DATA_LBLK + EXT_DATA_LEN + 10)
+			 << sb->s_blocksize_bits;
+	inode->i_size = ei->i_disksize;
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+}
+
+static void ext_cleanup_inode(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct rb_node *node;
+
+	down_write(&ei->i_data_sem);
+	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	up_write(&ei->i_data_sem);
+
+	while ((node = rb_first(&ei->i_pending_tree.root)) != NULL) {
+		struct pending_reservation *pr;
+
+		pr = rb_entry(node, struct pending_reservation, rb_node);
+		ext4_remove_pending(inode, EXT4_C2B(sbi, pr->lclu));
+	}
+}
+
 static void extents_kunit_exit(struct kunit *test)
 {
 	struct ext4_sb_info *sbi;
+	struct super_block *sb;
 
 	if (!k_ctx.k_ei)
 		return;
 
-	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
+	sb = k_ctx.k_ei->vfs_inode.i_sb;
+	sbi = sb->s_fs_info;
+
+	if (k_ctx.k_ei2) {
+		ext_cleanup_inode(&k_ctx.k_ei2->vfs_inode);
+		kfree(k_ctx.k_ei2);
+	}
+	ext_cleanup_inode(&k_ctx.k_ei->vfs_inode);
+
+	percpu_counter_destroy(&sbi->s_freeclusters_counter);
+	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
 	ext4_es_unregister_shrinker(sbi);
-	deactivate_super(sbi->s_sb);
+	deactivate_super(sb);
+
+	kfree(k_ctx.meta_blocks);
+	kfree(sbi->s_es);
+	kfree(sb->s_bdev->bd_mapping);
+	kfree(sb->s_bdev);
 	kfree(sbi);
 	kfree(k_ctx.k_ei);
 	kfree(k_ctx.k_data);
+	memset(&k_ctx, 0, sizeof(k_ctx));
 }
 
 static int __ext4_ext_dirty_stub(const char *where, unsigned int line,
 				 handle_t *handle, struct inode *inode,
 				 struct ext4_ext_path *path)
 {
+	if (path && path->p_bh) {
+		ext4_extent_block_csum_set_test(inode,
+						ext_block_hdr(path->p_bh));
+		set_buffer_verified(path->p_bh);
+	}
 	return 0;
 }
 
+static int __ext4_handle_dirty_metadata_stub(const char *where,
+					     unsigned int line,
+					     handle_t *handle,
+					     struct inode *inode,
+					     struct buffer_head *bh)
+{
+	if (bh)
+		set_buffer_uptodate(bh);
+	return 0;
+}
+
+static int __ext4_mark_inode_dirty_stub(handle_t *handle, struct inode *inode,
+					const char *func, unsigned int line)
+{
+	return 0;
+}
+
+static struct buffer_head *ext4_ext_getblk_stub(struct inode *inode,
+						ext4_fsblk_t pblk,
+						gfp_t gfp_flags)
+{
+	struct kunit_meta_block *slot = NULL;
+	int i;
+
+	if (k_ctx.fail_getblk || !k_ctx.meta_blocks)
+		return NULL;
+
+	for (i = 0; i < EXT_MAX_META_BLOCKS; i++) {
+		if (k_ctx.meta_blocks[i].in_use &&
+		    k_ctx.meta_blocks[i].pblk == pblk) {
+			slot = &k_ctx.meta_blocks[i];
+			break;
+		}
+	}
+
+	if (!slot) {
+		for (i = 0; i < EXT_MAX_META_BLOCKS; i++) {
+			if (!k_ctx.meta_blocks[i].in_use) {
+				slot = &k_ctx.meta_blocks[i];
+				break;
+			}
+		}
+		if (!slot)
+			return NULL;
+
+		memset(slot, 0, sizeof(*slot));
+		slot->in_use = true;
+		slot->pblk = pblk;
+		slot->bh.b_data = slot->data;
+		slot->bh.b_size = inode->i_sb->s_blocksize;
+		slot->bh.b_blocknr = pblk;
+		slot->bh.b_bdev = inode->i_sb->s_bdev;
+		atomic_set(&slot->bh.b_count, 1);
+		set_buffer_uptodate(&slot->bh);
+		set_buffer_mapped(&slot->bh);
+	}
+
+	get_bh(&slot->bh);
+	return &slot->bh;
+}
+
+static ext4_fsblk_t ext4_mb_new_blocks_stub(handle_t *handle,
+					    struct ext4_allocation_request *ar,
+					    int *errp)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(ar->inode->i_sb);
+	ext4_fsblk_t pblk;
+
+	k_ctx.alloc_calls++;
+	if (k_ctx.fail_alloc_err) {
+		*errp = k_ctx.fail_alloc_err;
+		return 0;
+	}
+
+	pblk = k_ctx.next_alloc_pblk;
+	k_ctx.next_alloc_pblk += EXT4_C2B(sbi, ar->len);
+	k_ctx.last_alloc_pblk = pblk;
+	k_ctx.last_alloc_len = ar->len;
+	*errp = 0;
+	return pblk;
+}
+
+static void ext4_free_blocks_stub(handle_t *handle, struct inode *inode,
+				  struct buffer_head *bh, ext4_fsblk_t block,
+				  unsigned long count, int flags)
+{
+	k_ctx.free_calls++;
+	k_ctx.last_free_pblk = block;
+	k_ctx.last_free_count = count;
+	k_ctx.last_free_flags = flags;
+	k_ctx.total_freed_blocks += count;
+}
+
 static struct ext4_ext_path *
 ext4_ext_insert_extent_stub(handle_t *handle, struct inode *inode,
 			    struct ext4_ext_path *path,
 			    struct ext4_extent *newext, int gb_flags)
 {
+	ext4_free_ext_path(path);
 	return ERR_PTR(-ENOSPC);
 }
 
@@ -227,10 +435,11 @@ static int extents_kunit_init(struct kunit *test)
 	struct super_block *sb;
 	struct fs_context *fc;
 	struct ext4_sb_info *sbi = NULL;
-	struct kunit_ext_test_param *param =
-		(struct kunit_ext_test_param *)(test->param_value);
 	int err;
 
+	memset(&k_ctx, 0, sizeof(k_ctx));
+	k_ctx.next_alloc_pblk = EXT_ALLOC_BASE_PBLK;
+
 	sbi = kzalloc_obj(struct ext4_sb_info);
 	if (sbi == NULL)
 		return -ENOMEM;
@@ -249,16 +458,76 @@ static int extents_kunit_init(struct kunit *test)
 
 	sbi->s_sb = sb;
 	sb->s_fs_info = sbi;
-
+	sb->s_op = &ext_dummy_sops;
+#ifdef CONFIG_QUOTA
+	sb->dq_op = &ext_dummy_qops;
+#endif
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = 12;
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	strscpy(sb->s_id, "extents_kunit", sizeof(sb->s_id));
+
+	sb->s_bdev = kzalloc_obj(struct block_device);
+	if (!sb->s_bdev) {
+		err = -ENOMEM;
+		goto out_deactivate;
+	}
+	bdev_set_flag(sb->s_bdev, BD_READ_ONLY);
+	sb->s_bdev->bd_mapping = kzalloc_obj(struct address_space);
+	if (!sb->s_bdev->bd_mapping) {
+		err = -ENOMEM;
+		goto out_bdev;
+	}
 
-	if (!param || !param->disable_zeroout)
-		sbi->s_extent_max_zeroout_kb = 32;
+	sbi->s_es = kzalloc_obj(struct ext4_super_block);
+	if (!sbi->s_es) {
+		err = -ENOMEM;
+		goto out_bdev_mapping;
+	}
+	sbi->s_es->s_first_data_block = cpu_to_le32(1);
+	sbi->s_es->s_rev_level = cpu_to_le32(EXT4_DYNAMIC_REV);
+	ext4_blocks_count_set(sbi->s_es, EXT_TOTAL_BLOCKS);
+	set_opt(sb, ERRORS_CONT);
+	sbi->s_blocks_per_group = 32768;
+	sbi->s_clusters_per_group = 32768;
+	sbi->s_cluster_ratio = 1;
+	sbi->s_cluster_bits = 0;
+	sbi->s_desc_per_block = 64;
+	sbi->s_groups_count = 32;
+	sbi->s_extent_max_zeroout_kb = 32;
+	spin_lock_init(&sbi->s_bdev_wb_lock);
+	spin_lock_init(&sbi->s_error_lock);
+	spin_lock_init(&sbi->s_md_lock);
+	ratelimit_state_init(&sbi->s_warning_ratelimit_state,
+			     DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
+
+	err = percpu_counter_init(&sbi->s_freeclusters_counter, 100000,
+				  GFP_KERNEL);
+	if (err)
+		goto out_es;
+	err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0,
+				  GFP_KERNEL);
+	if (err)
+		goto out_freeclusters;
 
 	err = ext4_es_register_shrinker(sbi);
 	if (err)
-		goto out_deactivate;
+		goto out_dirtyclusters;
+
+	/*
+	 * Isolate the mock shrinker from asynchronous background reclaim.
+	 */
+	sbi->s_es_shrinker->count_objects = ext_dummy_shrinker_count;
+	sbi->s_es_shrinker->scan_objects = ext_dummy_shrinker_scan;
+
+	k_ctx.meta_blocks = kcalloc(EXT_MAX_META_BLOCKS,
+				    sizeof(struct kunit_meta_block),
+				    GFP_KERNEL);
+	if (!k_ctx.meta_blocks) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/* setup the mock inode */
 	k_ctx.k_ei = kzalloc_obj(struct ext4_inode_info);
@@ -268,19 +537,7 @@ static int extents_kunit_init(struct kunit *test)
 	}
 	ei = k_ctx.k_ei;
 	inode = &ei->vfs_inode;
-
-	ext4_es_init_tree(&ei->i_es_tree);
-	rwlock_init(&ei->i_es_lock);
-	INIT_LIST_HEAD(&ei->i_es_list);
-	ei->i_es_all_nr = 0;
-	ei->i_es_shk_nr = 0;
-	ei->i_es_shrink_lblk = 0;
-
-	ei->i_disksize = (EXT_DATA_LBLK + EXT_DATA_LEN + 10)
-			 << sb->s_blocksize_bits;
-	ei->i_flags = 0;
-	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
-	inode->i_sb = sb;
+	ext_init_mock_inode(ei, sb, 12);
 
 	k_ctx.k_data = kzalloc(EXT_DATA_LEN * 4096, GFP_KERNEL);
 	if (k_ctx.k_data == NULL) {
@@ -293,9 +550,6 @@ static int extents_kunit_init(struct kunit *test)
 	 */
 	memset(k_ctx.k_data, 'X', EXT_DATA_LEN * 4096);
 
-	/* create a tree with depth 0 */
-	eh = (struct ext4_extent_header *)k_ctx.k_ei->i_data;
-
 	/* Fill extent header */
 	eh = ext_inode_hdr(&k_ctx.k_ei->vfs_inode);
 	eh->eh_depth = 0;
@@ -307,25 +561,34 @@ static int extents_kunit_init(struct kunit *test)
 
 	/*
 	 * add 1 extent in leaf node covering:
-	 * - lblks: [EXT_DATA_LBLK, EXT_DATA_LBLK * + EXT_DATA_LEN)
+	 * - lblks: [EXT_DATA_LBLK, EXT_DATA_LBLK + EXT_DATA_LEN)
 	 * - pblks: [EXT_DATA_PBLK, EXT_DATA_PBLK + EXT_DATA_LEN)
 	 */
 	EXT_FIRST_EXTENT(eh)->ee_block = cpu_to_le32(EXT_DATA_LBLK);
 	EXT_FIRST_EXTENT(eh)->ee_len = cpu_to_le16(EXT_DATA_LEN);
 	ext4_ext_store_pblock(EXT_FIRST_EXTENT(eh), EXT_DATA_PBLK);
-	if (!param || param->is_unwrit_at_start)
-		ext4_ext_mark_unwritten(EXT_FIRST_EXTENT(eh));
+	ext4_ext_mark_unwritten(EXT_FIRST_EXTENT(eh));
 
+	down_write(&ei->i_data_sem);
 	ext4_es_insert_extent(inode, EXT_DATA_LBLK, EXT_DATA_LEN, EXT_DATA_PBLK,
-			      ext4_ext_is_unwritten(EXT_FIRST_EXTENT(eh)) ?
-				      EXTENT_STATUS_UNWRITTEN :
-				      EXTENT_STATUS_WRITTEN,
-			      0);
+			      EXTENT_STATUS_UNWRITTEN, 0);
+	up_write(&ei->i_data_sem);
 
 	/* Add stubs */
 	kunit_activate_static_stub(test, __ext4_ext_dirty,
 				   __ext4_ext_dirty_stub);
-	kunit_activate_static_stub(test, ext4_ext_zeroout, ext4_ext_zeroout_stub);
+	kunit_activate_static_stub(test, __ext4_handle_dirty_metadata,
+				   __ext4_handle_dirty_metadata_stub);
+	kunit_activate_static_stub(test, __ext4_mark_inode_dirty,
+				   __ext4_mark_inode_dirty_stub);
+	kunit_activate_static_stub(test, ext4_ext_getblk,
+				   ext4_ext_getblk_stub);
+	kunit_activate_static_stub(test, ext4_mb_new_blocks,
+				   ext4_mb_new_blocks_stub);
+	kunit_activate_static_stub(test, ext4_free_blocks,
+				   ext4_free_blocks_stub);
+	kunit_activate_static_stub(test, ext4_ext_zeroout,
+				   ext4_ext_zeroout_stub);
 	kunit_activate_static_stub(test, ext4_issue_zeroout,
 				   ext4_issue_zeroout_stub);
 	up_write(&sb->s_umount);
@@ -333,13 +596,23 @@ static int extents_kunit_init(struct kunit *test)
 	return 0;
 
 out:
-	kfree(k_ctx.k_ei);
-	k_ctx.k_ei = NULL;
-
 	kfree(k_ctx.k_data);
 	k_ctx.k_data = NULL;
-
+	kfree(k_ctx.k_ei);
+	k_ctx.k_ei = NULL;
+	kfree(k_ctx.meta_blocks);
+	k_ctx.meta_blocks = NULL;
 	ext4_es_unregister_shrinker(sbi);
+out_dirtyclusters:
+	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+out_freeclusters:
+	percpu_counter_destroy(&sbi->s_freeclusters_counter);
+out_es:
+	kfree(sbi->s_es);
+out_bdev_mapping:
+	kfree(sb->s_bdev->bd_mapping);
+out_bdev:
+	kfree(sb->s_bdev);
 out_deactivate:
 	deactivate_locked_super(sb);
 	kfree(sbi);
@@ -392,12 +665,24 @@ static void test_split_convert(struct kunit *test)
 {
 	struct ext4_ext_path *path;
 	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
 	struct ext4_extent *ex;
 	struct ext4_map_blocks map;
 	const struct kunit_ext_test_param *param =
 		(const struct kunit_ext_test_param *)(test->param_value);
 	int blkbits = inode->i_sb->s_blocksize_bits;
 
+	if (param->disable_zeroout)
+		EXT4_SB(inode->i_sb)->s_extent_max_zeroout_kb = 0;
+
+	if (!param->is_unwrit_at_start) {
+		ext4_ext_mark_initialized(EXT_FIRST_EXTENT(eh));
+		down_write(&EXT4_I(inode)->i_data_sem);
+		ext4_es_insert_extent(inode, EXT_DATA_LBLK, EXT_DATA_LEN,
+				      EXT_DATA_PBLK, EXTENT_STATUS_WRITTEN, 0);
+		up_write(&EXT4_I(inode)->i_data_sem);
+	}
+
 	if (param->is_zeroout_test)
 		/*
 		 * Force zeroout by making ext4_ext_insert_extent return ENOSPC
@@ -406,6 +691,7 @@ static void test_split_convert(struct kunit *test)
 					   ext4_ext_insert_extent_stub);
 
 	path = ext4_find_extent(inode, EXT_DATA_LBLK, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
 	ex = path->p_ext;
 	KUNIT_EXPECT_EQ(test, EXT_DATA_LBLK, le32_to_cpu(ex->ee_block));
 	KUNIT_EXPECT_EQ(test, EXT_DATA_LEN, ext4_ext_get_actual_len(ex));
@@ -423,15 +709,21 @@ static void test_split_convert(struct kunit *test)
 	case TEST_SPLIT_CONVERT:
 		path = ext4_split_convert_extents_test(NULL, inode, &map,
 					path, param->split_flags, NULL);
+		if (!IS_ERR(path))
+			ext4_free_ext_path(path);
 		break;
 	case TEST_CREATE_BLOCKS:
+		ext4_free_ext_path(path);
 		ext4_map_create_blocks_helper(test, inode, &map, param->split_flags);
 		break;
 	default:
+		ext4_free_ext_path(path);
 		KUNIT_FAIL(test, "param->type %d not support.", param->type);
+		return;
 	}
 
 	path = ext4_find_extent(inode, EXT_DATA_LBLK, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
 	ex = path->p_ext;
 
 	for (int i = 0; i < param->nr_exp_ext; i++) {
@@ -494,6 +786,8 @@ static void test_split_convert(struct kunit *test)
 		ex = ex + 1;
 	}
 
+	ext4_free_ext_path(path);
+
 	if (!param->is_zeroout_test)
 		return;
 
@@ -512,8 +806,1439 @@ static void test_split_convert(struct kunit *test)
 				    "# corruption in byte range [%lld, %lld)",
 				    off, len);
 	}
+}
+
+/*
+ * Helper to reset an inode's extent tree and extent status cache to empty.
+ */
+static void ext_reset_tree(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	down_write(&ei->i_data_sem);
+	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	memset(ei->i_data, 0, sizeof(ei->i_data));
+	ext4_ext_tree_init(NULL, inode);
+	up_write(&ei->i_data_sem);
+}
+
+/*
+ * Helper to insert an extent into @inode's extent tree under i_data_sem.
+ */
+static int ext_insert_one(struct inode *inode, ext4_lblk_t lblk,
+			  unsigned short len, ext4_fsblk_t pblk,
+			  bool unwritten, int gb_flags)
+{
+	struct ext4_ext_path *path;
+	struct ext4_extent newex = {};
+
+	newex.ee_block = cpu_to_le32(lblk);
+	newex.ee_len = cpu_to_le16(len);
+	ext4_ext_store_pblock(&newex, pblk);
+	if (unwritten)
+		ext4_ext_mark_unwritten(&newex);
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+	path = ext4_find_extent(inode, lblk, NULL, EXT4_EX_NOCACHE);
+	if (IS_ERR(path)) {
+		up_write(&EXT4_I(inode)->i_data_sem);
+		return PTR_ERR(path);
+	}
+	path = ext4_ext_insert_extent(NULL, inode, path, &newex,
+				      gb_flags | EXT4_EX_NOCACHE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
+
+	ext4_free_ext_path(path);
+	return 0;
+}
+
+/*
+ * Verify 48-bit physical block number store and load helpers for both
+ * leaf extents (ext4_extent) and index entries (ext4_extent_idx).
+ */
+static void test_ext_pblock_48bit(struct kunit *test)
+{
+	struct ext4_extent ex = {};
+	struct ext4_extent_idx idx = {};
+	const ext4_fsblk_t pblk_48 = 0x123456789abcULL;
+	const ext4_fsblk_t pblk_max = 0xffffffffffffULL;
+
+	ext4_ext_store_pblock(&ex, 0);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex), 0ULL);
+
+	ext4_ext_store_pblock(&ex, 0xffffffffULL);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex), 0xffffffffULL);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(ex.ee_start_hi), 0);
+
+	ext4_ext_store_pblock(&ex, pblk_48);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex.ee_start_lo), 0x56789abcU);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(ex.ee_start_hi), 0x1234U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex), pblk_48);
+
+	ext4_ext_store_pblock(&ex, pblk_max);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex), pblk_max);
+
+	ext4_idx_store_pblock(&idx, pblk_48);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(idx.ei_leaf_lo), 0x56789abcU);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(idx.ei_leaf_hi), 0x1234U);
+	KUNIT_EXPECT_EQ(test, ext4_idx_pblock(&idx), pblk_48);
+
+	ext4_idx_store_pblock(&idx, pblk_max);
+	KUNIT_EXPECT_EQ(test, ext4_idx_pblock(&idx), pblk_max);
+}
+
+/*
+ * Verify extent length encoding and unwritten bit manipulation at boundaries:
+ * - EXT_INIT_MAX_LEN (32768 = 0x8000) is the maximum initialized extent length
+ *   and must NOT be treated as unwritten.
+ * - EXT_UNWRITTEN_MAX_LEN (32767 = 0x7fff) is the maximum unwritten extent
+ *   length (stored on disk as 0xffff).
+ */
+static void test_ext_unwritten_len_encoding(struct kunit *test)
+{
+	struct ext4_extent ex = {};
+
+	ex.ee_len = cpu_to_le16(1);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex), 0);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex), 1);
+
+	ext4_ext_mark_unwritten(&ex);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex), 1);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex), 1);
+
+	ext4_ext_mark_initialized(&ex);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex), 0);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex), 1);
+
+	ex.ee_len = cpu_to_le16(EXT_UNWRITTEN_MAX_LEN);
+	ext4_ext_mark_unwritten(&ex);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex), 1);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex),
+			EXT_UNWRITTEN_MAX_LEN);
+
+	ext4_ext_mark_initialized(&ex);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex), 0);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex),
+			EXT_UNWRITTEN_MAX_LEN);
+
+	ex.ee_len = cpu_to_le16(EXT_INIT_MAX_LEN);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex), 0);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex), EXT_INIT_MAX_LEN);
+}
+
+/*
+ * Verify ext4_ext_tree_init() initializes the in-inode extent header and
+ * ext4_ext_check_inode() accepts valid empty and populated root headers.
+ */
+static void test_ext_tree_init_and_check_inode(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+
+	memset(k_ctx.k_ei->i_data, 0xff, sizeof(k_ctx.k_ei->i_data));
+	ext4_ext_tree_init(NULL, inode);
+
+	KUNIT_EXPECT_EQ(test, eh->eh_magic, EXT4_EXT_MAGIC);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_depth), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_max), 4);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(eh->eh_generation), 0U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_check_inode(inode), 0);
+
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 5, 100, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, ext4_ext_check_inode(inode), 0);
+}
+
+enum ext_check_corrupt_type {
+	CORRUPT_BAD_MAGIC,
+	CORRUPT_BAD_DEPTH,
+	CORRUPT_ZERO_MAX,
+	CORRUPT_EXCESS_MAX,
+	CORRUPT_ENTRIES_GT_MAX,
+	CORRUPT_EMPTY_NONROOT_INDEX,
+	CORRUPT_ZERO_LEN_EXTENT,
+	CORRUPT_LBLK_OVERFLOW,
+	CORRUPT_PBLK_TOO_LOW,
+	CORRUPT_PBLK_TOO_HIGH,
+	CORRUPT_UNSORTED_EXTENTS,
+	CORRUPT_UNSORTED_INDEXES,
+	CORRUPT_NONROOT_LBLK_MISMATCH,
+};
+
+struct ext_check_corrupt_param {
+	const char *desc;
+	enum ext_check_corrupt_type type;
+};
+
+static const struct ext_check_corrupt_param ext_check_corrupt_params[] = {
+	{ "invalid eh_magic", CORRUPT_BAD_MAGIC },
+	{ "mismatched eh_depth", CORRUPT_BAD_DEPTH },
+	{ "eh_max == 0", CORRUPT_ZERO_MAX },
+	{ "eh_max exceeds root capacity", CORRUPT_EXCESS_MAX },
+	{ "eh_entries exceeds eh_max", CORRUPT_ENTRIES_GT_MAX },
+	{ "empty index block at depth > 0", CORRUPT_EMPTY_NONROOT_INDEX },
+	{ "extent with ee_len == 0", CORRUPT_ZERO_LEN_EXTENT },
+	{ "extent logical block 32-bit wrap-around", CORRUPT_LBLK_OVERFLOW },
+	{ "extent physical block <= first_data_block", CORRUPT_PBLK_TOO_LOW },
+	{ "extent physical block past blocks_count", CORRUPT_PBLK_TOO_HIGH },
+	{ "overlapping/unsorted leaf extents", CORRUPT_UNSORTED_EXTENTS },
+	{ "unsorted index entries", CORRUPT_UNSORTED_INDEXES },
+	{ "non-root leaf first ee_block != parent ei_block",
+	  CORRUPT_NONROOT_LBLK_MISMATCH },
+};
+
+static void ext_check_corrupt_get_desc(struct kunit *test, const void *p,
+				       char *desc)
+{
+	const struct ext_check_corrupt_param *param = p;
+
+	strscpy(desc, param->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+static int ext_check_corrupt_param_init(struct kunit *test)
+{
+	kunit_register_params_array(test, ext_check_corrupt_params,
+				    ARRAY_SIZE(ext_check_corrupt_params),
+				    ext_check_corrupt_get_desc);
+	return 0;
+}
+
+/*
+ * Verify __ext4_ext_check() detects and rejects all classes of corrupt
+ * extent headers, leaf extents, and index entries with -EFSCORRUPTED.
+ */
+static void test_ext_check_corruptions(struct kunit *test)
+{
+	const struct ext_check_corrupt_param *param = test->param_value;
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent *ex;
+	struct ext4_extent_idx *ix;
+	struct {
+		struct ext4_extent_header eh;
+		struct ext4_extent ex;
+	} nonroot_leaf;
+	int depth = 0;
+	ext4_fsblk_t pblk = 0;
+	ext4_lblk_t lblk = 0;
+	int err;
+
+	ext_reset_tree(inode);
+	eh->eh_entries = cpu_to_le16(1);
+	ex = EXT_FIRST_EXTENT(eh);
+	ex->ee_block = cpu_to_le32(10);
+	ex->ee_len = cpu_to_le16(4);
+	ext4_ext_store_pblock(ex, 100);
+
+	switch (param->type) {
+	case CORRUPT_BAD_MAGIC:
+		eh->eh_magic = cpu_to_le16(0xdead);
+		break;
+	case CORRUPT_BAD_DEPTH:
+		eh->eh_depth = cpu_to_le16(1);
+		depth = 0;
+		break;
+	case CORRUPT_ZERO_MAX:
+		eh->eh_max = 0;
+		break;
+	case CORRUPT_EXCESS_MAX:
+		eh->eh_max = cpu_to_le16(10);
+		break;
+	case CORRUPT_ENTRIES_GT_MAX:
+		eh->eh_entries = cpu_to_le16(5);
+		break;
+	case CORRUPT_EMPTY_NONROOT_INDEX:
+		eh->eh_depth = cpu_to_le16(1);
+		eh->eh_entries = 0;
+		depth = 1;
+		break;
+	case CORRUPT_ZERO_LEN_EXTENT:
+		ex->ee_len = 0;
+		break;
+	case CORRUPT_LBLK_OVERFLOW:
+		ex->ee_block = cpu_to_le32(0xfffffff0U);
+		ex->ee_len = cpu_to_le16(32);
+		break;
+	case CORRUPT_PBLK_TOO_LOW:
+		ext4_ext_store_pblock(ex, 1);
+		break;
+	case CORRUPT_PBLK_TOO_HIGH:
+		ext4_ext_store_pblock(ex, EXT_TOTAL_BLOCKS);
+		break;
+	case CORRUPT_UNSORTED_EXTENTS:
+		eh->eh_entries = cpu_to_le16(2);
+		ex[1].ee_block = cpu_to_le32(12);
+		ex[1].ee_len = cpu_to_le16(4);
+		ext4_ext_store_pblock(&ex[1], 200);
+		break;
+	case CORRUPT_UNSORTED_INDEXES:
+		eh->eh_depth = cpu_to_le16(1);
+		eh->eh_entries = cpu_to_le16(2);
+		depth = 1;
+		ix = EXT_FIRST_INDEX(eh);
+		ix[0].ei_block = cpu_to_le32(20);
+		ext4_idx_store_pblock(&ix[0], 500);
+		ix[1].ei_block = cpu_to_le32(10);
+		ext4_idx_store_pblock(&ix[1], 501);
+		break;
+	case CORRUPT_NONROOT_LBLK_MISMATCH:
+		eh->eh_depth = cpu_to_le16(1);
+		memset(&nonroot_leaf, 0, sizeof(nonroot_leaf));
+		nonroot_leaf.eh.eh_magic = EXT4_EXT_MAGIC;
+		nonroot_leaf.eh.eh_depth = 0;
+		nonroot_leaf.eh.eh_entries = cpu_to_le16(1);
+		nonroot_leaf.eh.eh_max = cpu_to_le16(340);
+		nonroot_leaf.ex.ee_block = cpu_to_le32(10);
+		nonroot_leaf.ex.ee_len = cpu_to_le16(4);
+		ext4_ext_store_pblock(&nonroot_leaf.ex, 100);
+		eh = &nonroot_leaf.eh;
+		depth = 0;
+		pblk = 500;
+		lblk = 20;
+		break;
+	}
+
+	/* Suppress __ext4_error_inode() log spam during expected failure */
+	set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
+	err = ext4_ext_check_test(inode, eh, depth, pblk, lblk);
+	clear_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
+
+	KUNIT_EXPECT_EQ(test, err, -EFSCORRUPTED);
+}
+
+/*
+ * Verify metadata checksum calculation and verification on external extent
+ * tree blocks when EXT4_FEATURE_RO_COMPAT_METADATA_CSUM is enabled.
+ */
+static void test_ext_block_csum_verify(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct buffer_head *bh;
+	struct ext4_extent_header *eh;
+	struct ext4_extent *ex;
+	struct ext4_extent_tail *et;
+	int max_entries;
+	int err;
+
+	ext_reset_tree(inode);
+	ext_inode_hdr(inode)->eh_depth = cpu_to_le16(1);
+	ext4_set_feature_metadata_csum(inode->i_sb);
+	bh = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+
+	max_entries = (inode->i_sb->s_blocksize -
+		       sizeof(struct ext4_extent_header) -
+		       sizeof(struct ext4_extent_tail)) /
+		      sizeof(struct ext4_extent);
+
+	eh = ext_block_hdr(bh);
+	eh->eh_magic = EXT4_EXT_MAGIC;
+	eh->eh_depth = 0;
+	eh->eh_entries = cpu_to_le16(1);
+	eh->eh_max = cpu_to_le16(max_entries);
+
+	ex = EXT_FIRST_EXTENT(eh);
+	ex->ee_block = cpu_to_le32(10);
+	ex->ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(ex, 100);
+
+	ext4_extent_block_csum_set_test(inode, eh);
+	err = ext4_ext_check_test(inode, eh, 0, EXT_META_BASE_PBLK, 10);
+	KUNIT_EXPECT_EQ(test, err, 0);
+
+	/* Flip a bit in the tail checksum and verify -EFSBADCRC */
+	et = find_ext4_extent_tail(eh);
+	et->et_checksum ^= cpu_to_le32(0x1);
+
+	set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
+	err = ext4_ext_check_test(inode, eh, 0, EXT_META_BASE_PBLK, 10);
+	clear_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
+
+	KUNIT_EXPECT_EQ(test, err, -EFSBADCRC);
+	brelse(bh);
+}
+
+/*
+ * Verify ext4_find_extent() binary search on an empty tree and a multi-extent
+ * root leaf, as well as extent status caching vs EXT4_EX_NOCACHE.
+ */
+static void test_find_extent_root_binsearch(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_ext_path *path;
+	struct extent_status es;
+
+	ext_reset_tree(inode);
+
+	/* Empty tree returns NULL p_ext */
+	path = ext4_find_extent(inode, 10, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_PTR_EQ(test, path[0].p_ext, NULL);
+	ext4_free_ext_path(path);
+
+	/* Populate 3 separated extents: [10, 15), [20, 25), [30, 35) */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 5, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 20, 5, 200, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 30, 5, 300, false, 0), 0);
+
+	/* Lookup before first extent (lblk 5) -> points to first extent */
+	path = ext4_find_extent(inode, 5, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_ASSERT_NOT_NULL(test, path[0].p_ext);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[0].p_ext->ee_block), 10U);
+	ext4_free_ext_path(path);
+
+	/* Lookup inside first extent (lblk 12) */
+	path = ext4_find_extent(inode, 12, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[0].p_ext->ee_block), 10U);
+	ext4_free_ext_path(path);
+
+	/* Lookup in hole between 1st and 2nd extent (lblk 17) -> 1st extent */
+	path = ext4_find_extent(inode, 17, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[0].p_ext->ee_block), 10U);
+	ext4_free_ext_path(path);
+
+	/* Lookup exact start of 2nd extent (lblk 20) */
+	path = ext4_find_extent(inode, 20, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[0].p_ext->ee_block), 20U);
+	ext4_free_ext_path(path);
+
+	/* Lookup past last extent (lblk 50) -> 3rd extent */
+	path = ext4_find_extent(inode, 50, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[0].p_ext->ee_block), 30U);
+	ext4_free_ext_path(path);
+
+	/* EXT4_EX_NOCACHE left i_es_tree empty */
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 10, NULL, &es, NULL),
+			0);
+
+	/* Lookup without EXT4_EX_NOCACHE populates extents and holes in es */
+	down_read(&EXT4_I(inode)->i_data_sem);
+	path = ext4_find_extent(inode, 20, NULL, 0);
+	up_read(&EXT4_I(inode)->i_data_sem);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	ext4_free_ext_path(path);
+
+	/*
+	 * Verify inter-extent hole [15, 20) and extents are cached in es
+	 * (ext4_cache_extents only caches holes where prev != 0).
+	 */
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 5, NULL, &es, NULL),
+			0);
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 17, NULL, &es, NULL),
+			1);
+	KUNIT_EXPECT_TRUE(test, ext4_es_is_hole(&es));
+	KUNIT_EXPECT_EQ(test, es.es_lblk, 15U);
+	KUNIT_EXPECT_EQ(test, es.es_len, 5U);
+
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 22, NULL, &es, NULL),
+			1);
+	KUNIT_EXPECT_TRUE(test, ext4_es_is_written(&es));
+	KUNIT_EXPECT_EQ(test, ext4_es_pblock(&es), 200ULL);
+}
+
+/*
+ * Helper to construct a depth-1 tree with two external leaf blocks:
+ *   Leaf 0 (pblk 500): [10, 15) -> 1000 (written), [20, 25) -> 1100 (written)
+ *   Leaf 1 (pblk 501): [40, 45) -> 2000 (unwritten), [50, 55) -> 2100 (written)
+ */
+static void setup_depth1_two_leaf_tree(struct kunit *test, struct inode *inode)
+{
+	struct ext4_extent_header *root_eh = ext_inode_hdr(inode);
+	struct ext4_extent_idx *idx;
+	struct buffer_head *bh0, *bh1;
+	struct ext4_extent_header *eh0, *eh1;
+	struct ext4_extent *ex;
+	int max_leaf = (inode->i_sb->s_blocksize -
+			sizeof(struct ext4_extent_header)) /
+		       sizeof(struct ext4_extent);
+
+	ext_reset_tree(inode);
+
+	root_eh->eh_depth = cpu_to_le16(1);
+	root_eh->eh_entries = cpu_to_le16(2);
+	root_eh->eh_max = cpu_to_le16(ext4_ext_space_root_idx_test(inode, 0));
+
+	idx = EXT_FIRST_INDEX(root_eh);
+	idx[0].ei_block = cpu_to_le32(10);
+	ext4_idx_store_pblock(&idx[0], EXT_META_BASE_PBLK);
+	idx[1].ei_block = cpu_to_le32(40);
+	ext4_idx_store_pblock(&idx[1], EXT_META_BASE_PBLK + 1);
+
+	bh0 = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh0);
+	eh0 = ext_block_hdr(bh0);
+	eh0->eh_magic = EXT4_EXT_MAGIC;
+	eh0->eh_depth = 0;
+	eh0->eh_entries = cpu_to_le16(2);
+	eh0->eh_max = cpu_to_le16(max_leaf);
+	ex = EXT_FIRST_EXTENT(eh0);
+	ex[0].ee_block = cpu_to_le32(10);
+	ex[0].ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(&ex[0], 1000);
+	ex[1].ee_block = cpu_to_le32(20);
+	ex[1].ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(&ex[1], 1100);
+	brelse(bh0);
+
+	bh1 = ext4_ext_getblk_stub(inode, EXT_META_BASE_PBLK + 1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bh1);
+	eh1 = ext_block_hdr(bh1);
+	eh1->eh_magic = EXT4_EXT_MAGIC;
+	eh1->eh_depth = 0;
+	eh1->eh_entries = cpu_to_le16(2);
+	eh1->eh_max = cpu_to_le16(max_leaf);
+	ex = EXT_FIRST_EXTENT(eh1);
+	ex[0].ee_block = cpu_to_le32(40);
+	ex[0].ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(&ex[0], 2000);
+	ext4_ext_mark_unwritten(&ex[0]);
+	ex[1].ee_block = cpu_to_le32(50);
+	ex[1].ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(&ex[1], 2100);
+	brelse(bh1);
+}
+
+/*
+ * Verify multi-level (depth 1) extent lookup and tree navigation helpers:
+ * ext4_ext_next_allocated_block(), ext4_ext_next_leaf_block(),
+ * ext4_ext_search_left(), and ext4_ext_search_right() across leaf boundaries.
+ */
+static void test_find_extent_multilevel_and_navigation(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_ext_path *path;
+	struct ext4_extent ret_ex;
+	ext4_lblk_t logical;
+	ext4_fsblk_t phys;
+	int ret;
+
+	setup_depth1_two_leaf_tree(test, inode);
+
+	/* Lookup first extent [10, 15) in leaf 0 */
+	path = ext4_find_extent(inode, 10, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, path->p_depth, 1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[1].p_ext->ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_next_allocated_block(path), 20U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_next_leaf_block_test(path), 40U);
+	ext4_free_ext_path(path);
+
+	/*
+	 * Lookup lblk 30 (in hole between leaf 0 and leaf 1):
+	 * path[1].p_ext points to [20, 25) (last extent in leaf 0).
+	 */
+	path = ext4_find_extent(inode, 30, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[1].p_ext->ee_block), 20U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_next_allocated_block(path), 40U);
+
+	/* Search left from lblk 30 finds last block of [20, 25) -> 24 @ 1104 */
+	logical = 30;
+	ret = ext4_ext_search_left_test(inode, path, &logical, &phys);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, logical, 24U);
+	KUNIT_EXPECT_EQ(test, phys, 1104ULL);
+
+	/* Search right from lblk 30 crosses into leaf 1 -> [40, 45) @ 2000 */
+	logical = 30;
+	ret = ext4_ext_search_right_test(inode, path, &logical, &phys, &ret_ex,
+					 EXT4_EX_NOCACHE);
+	KUNIT_EXPECT_EQ(test, ret, 1);
+	KUNIT_EXPECT_EQ(test, logical, 40U);
+	KUNIT_EXPECT_EQ(test, phys, 2000ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ret_ex.ee_block), 40U);
+	ext4_free_ext_path(path);
+
+	/* Lookup last extent [50, 55) in leaf 1 */
+	path = ext4_find_extent(inode, 52, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(path[1].p_ext->ee_block), 50U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_next_allocated_block(path),
+			EXT_MAX_BLOCKS);
+	KUNIT_EXPECT_EQ(test, ext4_ext_next_leaf_block_test(path),
+			EXT_MAX_BLOCKS);
+	ext4_free_ext_path(path);
+}
+
+/*
+ * Verify ext4_ext_precache() walks all leaf blocks of a multi-level extent
+ * tree, caches all extents and holes into the extent status tree, and sets
+ * EXT4_STATE_EXT_PRECACHED.
+ */
+static void test_ext_precache(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct extent_status es;
+	int err;
+
+	setup_depth1_two_leaf_tree(test, inode);
+	KUNIT_EXPECT_FALSE(test,
+			   ext4_test_inode_state(inode,
+						 EXT4_STATE_EXT_PRECACHED));
+
+	err = ext4_ext_precache(inode);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_TRUE(test,
+			  ext4_test_inode_state(inode,
+						EXT4_STATE_EXT_PRECACHED));
+
+	/* Verify cached inter-extent hole [15, 20) and extents from both leaves */
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 17, NULL, &es, NULL),
+			1);
+	KUNIT_EXPECT_TRUE(test, ext4_es_is_hole(&es));
+	KUNIT_EXPECT_EQ(test, es.es_lblk, 15U);
+	KUNIT_EXPECT_EQ(test, es.es_len, 5U);
+
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 10, NULL, &es, NULL),
+			1);
+	KUNIT_EXPECT_TRUE(test, ext4_es_is_written(&es));
+	KUNIT_EXPECT_EQ(test, ext4_es_pblock(&es), 1000ULL);
+
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 40, NULL, &es, NULL),
+			1);
+	KUNIT_EXPECT_TRUE(test, ext4_es_is_unwritten(&es));
+	KUNIT_EXPECT_EQ(test, ext4_es_pblock(&es), 2000ULL);
+
+	KUNIT_EXPECT_EQ(test, ext4_es_lookup_extent(inode, 50, NULL, &es, NULL),
+			1);
+	KUNIT_EXPECT_TRUE(test, ext4_es_is_written(&es));
+	KUNIT_EXPECT_EQ(test, ext4_es_pblock(&es), 2100ULL);
+}
+
+/*
+ * Verify ext4_can_extents_be_merged() rules for written/unwritten state,
+ * logical and physical contiguity, and maximum length limits.
+ */
+static void test_can_extents_be_merged(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent ex1 = {}, ex2 = {};
+
+	/* Contiguous written extents [10, 15) @ 100 and [15, 20) @ 105 */
+	ex1.ee_block = cpu_to_le32(10);
+	ex1.ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(&ex1, 100);
+	ex2.ee_block = cpu_to_le32(15);
+	ex2.ee_len = cpu_to_le16(5);
+	ext4_ext_store_pblock(&ex2, 105);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			1);
+
+	/* Mismatched written vs unwritten cannot merge */
+	ext4_ext_mark_unwritten(&ex2);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			0);
+
+	/* Both unwritten and contiguous can merge */
+	ext4_ext_mark_unwritten(&ex1);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			1);
+
+	/* Non-contiguous physical blocks cannot merge */
+	ext4_ext_mark_initialized(&ex1);
+	ext4_ext_mark_initialized(&ex2);
+	ext4_ext_store_pblock(&ex2, 200);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			0);
+
+	/* Non-contiguous logical blocks cannot merge */
+	ext4_ext_store_pblock(&ex2, 105);
+	ex2.ee_block = cpu_to_le32(16);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			0);
+
+	/* Written max length boundary (EXT_INIT_MAX_LEN = 32768) */
+	ex1.ee_block = cpu_to_le32(0);
+	ex1.ee_len = cpu_to_le16(32760);
+	ext4_ext_store_pblock(&ex1, 100);
+	ex2.ee_block = cpu_to_le32(32760);
+	ex2.ee_len = cpu_to_le16(8);
+	ext4_ext_store_pblock(&ex2, 100 + 32760);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			1);
+	ex2.ee_len = cpu_to_le16(9);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			0);
+
+	/* Unwritten max length boundary (EXT_UNWRITTEN_MAX_LEN = 32767) */
+	ex1.ee_len = cpu_to_le16(32760);
+	ext4_ext_mark_unwritten(&ex1);
+	ex2.ee_len = cpu_to_le16(7);
+	ext4_ext_mark_unwritten(&ex2);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			1);
+	ex2.ee_len = cpu_to_le16(8);
+	ext4_ext_mark_unwritten(&ex2);
+	KUNIT_EXPECT_EQ(test, ext4_can_extents_be_merged_test(inode, &ex1, &ex2),
+			0);
+}
+
+/*
+ * Verify ext4_ext_insert_extent() appending, prepending, 3-way bridge merging,
+ * and EXT4_GET_BLOCKS_SPLIT_NOMERGE suppression.
+ */
+static void test_insert_extent_merge_and_nomerge(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent *ex;
+
+	ext_reset_tree(inode);
+
+	/* Insert [10, 15) @ 100 and [20, 25) @ 110 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 5, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 20, 5, 110, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 2);
+
+	/* Append [15, 18) @ 105 -> merges with [10, 15) into [10, 18) */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 15, 3, 105, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 2);
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 8);
+
+	/* Insert [18, 20) @ 108 -> bridges [10, 18) and [20, 25) into [10, 25) */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 18, 2, 108, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 15);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[0]), 100ULL);
+
+	/* Insert contiguous [25, 30) @ 115 with SPLIT_NOMERGE -> stays separate */
+	KUNIT_ASSERT_EQ(test,
+			ext_insert_one(inode, 25, 5, 115, false,
+				       EXT4_GET_BLOCKS_SPLIT_NOMERGE),
+			0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 2);
+}
+
+/*
+ * Verify tree growth (depth 0 -> 1 via ext4_ext_grow_indepth), parent index
+ * update when inserting a new lowest lblk (ext4_ext_correct_indexes), and
+ * tree collapse back into the inode root (depth 1 -> 0 via
+ * ext4_ext_try_to_merge_up) when merging reduces leaf entries to <= 4.
+ */
+static void test_insert_extent_grow_and_merge_up(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent *ex;
+
+	ext_reset_tree(inode);
+
+	/*
+	 * Insert 4 non-contiguous extents that fill the root leaf (eh_max = 4):
+	 * [10, 12) @ 100, [14, 16) @ 104, [18, 20) @ 108, [22, 24) @ 112.
+	 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 2, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 14, 2, 104, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 18, 2, 108, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 22, 2, 112, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 4);
+
+	/*
+	 * Insert 5th extent [26, 28) @ 116: triggers ext4_ext_grow_indepth(),
+	 * moving the leaf to a newly allocated external block and increasing
+	 * tree depth to 1.
+	 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 26, 2, 116, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 1);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT_FIRST_INDEX(eh)->ei_block), 10U);
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 1U);
+
+	/*
+	 * Prepend [8, 10) @ 98 to [10, 12) @ 100: modifies first extent in the
+	 * leaf and triggers ext4_ext_correct_indexes(), updating root ei_block
+	 * from 10 to 8.
+	 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 8, 2, 98, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT_FIRST_INDEX(eh)->ei_block), 8U);
+
+	/*
+	 * Bridge two gaps ([12, 14) @ 102 and [16, 18) @ 106): leaf entries
+	 * shrink from 5 -> 4 -> 3. Once <= 4 (max_root), ext4_ext_try_to_merge_up()
+	 * copies the extents back into the inode root and frees the leaf block!
+	 */
+	k_ctx.free_calls = 0;
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 12, 2, 102, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 4);
+	KUNIT_EXPECT_EQ(test, k_ctx.free_calls, 1U);
+
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 16, 2, 106, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 8U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 12);
+}
+
+/*
+ * Verify ext4_ext_remove_space() for middle-of-extent hole punching, full
+ * extent removal with left-scooting, and ext4_ext_truncate() tail removal.
+ */
+static void test_remove_space_tail_and_hole_punch(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent *ex;
+	int err;
+
+	ext_reset_tree(inode);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 10, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 30, 10, 200, false, 0), 0);
+
+	/*
+	 * Punch hole [12, 17] inside [10, 20): splits [10, 20) into [10, 12)
+	 * and [18, 20), leaving 3 extents total.
+	 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_remove_space(inode, 12, 17);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), 18U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[1]), 2);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[1]), 108ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[2].ee_block), 30U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[2]), 10);
+
+	/*
+	 * Punch out the entire middle extent [18, 19]: scoots [30, 40) into
+	 * slot 1 and reduces eh_entries to 2.
+	 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_remove_space(inode, 18, 19);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), 30U);
+
+	/*
+	 * Truncate file to 11 blocks (i_size = 11 * 4096): removes [30, 40)
+	 * and trims [10, 12) down to [10, 11).
+	 */
+	inode->i_size = 11ULL << inode->i_sb->s_blocksize_bits;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_truncate(NULL, inode);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 1);
+}
+
+/*
+ * Verify ext4_ext_remove_space() on a depth-1 tree removes all leaf extents,
+ * removes empty index entries via ext4_ext_rm_idx(), frees the leaf metadata
+ * blocks, and resets the root header to eh_depth == 0.
+ */
+static void test_remove_space_multilevel_collapse(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	int err;
+
+	setup_depth1_two_leaf_tree(test, inode);
+	k_ctx.free_calls = 0;
+	k_ctx.total_freed_blocks = 0;
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_remove_space(inode, 0, EXT_MAX_BLOCKS - 1);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, ext_depth(inode), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_max), 4);
+	/* 4 data extents (5 blocks each = 20) + 2 leaf metadata blocks = 22 */
+	KUNIT_EXPECT_EQ(test, k_ctx.total_freed_blocks, 22UL);
+}
+
+/*
+ * Verify bigalloc partial cluster handling in ext4_ext_remove_space():
+ * 1. When a cluster is shared with a remaining extent (state == nofree),
+ *    the physical cluster is not freed.
+ * 2. When the entire unaligned extent is removed and has a pending reservation
+ *    in i_pending_tree, the cluster is freed with RERESERVE_CLUSTER and
+ *    ext4_rereserve_cluster() re-increments i_reserved_data_blocks and removes
+ *    the pending reservation.
+ */
+static void test_remove_space_bigalloc_partial_cluster(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int err;
+
+	sbi->s_cluster_bits = 2;
+	sbi->s_cluster_ratio = 4;
+
+	/*
+	 * Case 1: [0, 2) @ 100 and [2, 4) @ 102 share physical cluster 25
+	 * (blocks 100..103). Punching [0, 1] must NOT free cluster 25.
+	 */
+	ext_reset_tree(inode);
+	KUNIT_ASSERT_EQ(test,
+			ext_insert_one(inode, 0, 2, 100, false,
+				       EXT4_GET_BLOCKS_SPLIT_NOMERGE),
+			0);
+	KUNIT_ASSERT_EQ(test,
+			ext_insert_one(inode, 2, 2, 102, false,
+				       EXT4_GET_BLOCKS_SPLIT_NOMERGE),
+			0);
+
+	k_ctx.free_calls = 0;
+	k_ctx.total_freed_blocks = 0;
+	down_write(&ei->i_data_sem);
+	err = ext4_ext_remove_space(inode, 0, 1);
+	up_write(&ei->i_data_sem);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	/*
+	 * ext4_remove_blocks() is called with NOFREE_FIRST_CLUSTER |
+	 * NOFREE_LAST_CLUSTER, and partial cluster 25 is marked nofree.
+	 */
+	KUNIT_EXPECT_EQ(test, k_ctx.free_calls, 1U);
+	KUNIT_EXPECT_TRUE(test,
+			  (k_ctx.last_free_flags &
+			   EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) != 0);
+
+	/*
+	 * Case 2: Single unaligned extent [1, 3) @ 101 in cluster 0 (pclu 25)
+	 * with a pending reservation on cluster 0. Truncating from 1 frees
+	 * cluster 25 with RERESERVE_CLUSTER and calls ext4_rereserve_cluster().
+	 */
+	ext_reset_tree(inode);
+	set_opt(inode->i_sb, DELALLOC);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 1, 2, 101, true, 0), 0);
+
+	down_write(&ei->i_data_sem);
+	/* Insert delayed extent at lblk 0 in already-allocated cluster 0 */
+	ext4_es_insert_delayed_extent(inode, 0, 1, true, false);
+	up_write(&ei->i_data_sem);
+	KUNIT_ASSERT_TRUE(test, ext4_is_pending(inode, 0));
+
+	ei->i_reserved_data_blocks = 0;
+	k_ctx.free_calls = 0;
+	down_write(&ei->i_data_sem);
+	err = ext4_ext_remove_space(inode, 1, EXT_MAX_BLOCKS - 1);
+	up_write(&ei->i_data_sem);
+
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, k_ctx.last_free_pblk, 100ULL);
+	KUNIT_EXPECT_EQ(test, k_ctx.last_free_count, 4UL);
+	KUNIT_EXPECT_TRUE(test,
+			  (k_ctx.last_free_flags &
+			   EXT4_FREE_BLOCKS_RERESERVE_CLUSTER) != 0);
+	KUNIT_EXPECT_EQ(test, ei->i_reserved_data_blocks, 1U);
+	KUNIT_EXPECT_FALSE(test, ext4_is_pending(inode, 0));
+}
+
+/*
+ * Verify ext4_ext_map_blocks() hole lookup, delayed-extent hole truncation
+ * (ext4_ext_determine_insert_hole), and EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF.
+ */
+static void test_map_blocks_lookup_hole_and_query_last_in_leaf(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_map_blocks map = {};
+	int ret;
+
+	ext_reset_tree(inode);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 5, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 20, 5, 200, false, 0), 0);
+
+	/* Hole lookup at [2, 22) returns 0 and trims m_len to [2, 10) (len 8) */
+	map.m_lblk = 2;
+	map.m_len = 20;
+	map.m_flags = 0;
+	down_read(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map, 0);
+	up_read(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, map.m_pblk, 0ULL);
+	KUNIT_EXPECT_EQ(test, map.m_len, 8U);
+
+	/*
+	 * Insert a delayed extent at [5, 7) in the es tree: hole lookup at
+	 * [2, 22) must stop at the delayed extent -> [2, 5) (len 3).
+	 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	ext4_es_insert_delayed_extent(inode, 5, 2, false, false);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	map.m_lblk = 2;
+	map.m_len = 20;
+	map.m_flags = 0;
+	down_read(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map, EXT4_EX_NOCACHE);
+	up_read(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, map.m_len, 3U);
+
+	/* QUERY_LAST_IN_LEAF on first extent [10, 15) -> flag NOT set */
+	map.m_lblk = 10;
+	map.m_len = 5;
+	map.m_flags = 0;
+	down_read(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map,
+				  EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF);
+	up_read(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, ret, 5);
+	KUNIT_EXPECT_FALSE(test,
+			   (map.m_flags & EXT4_MAP_QUERY_LAST_IN_LEAF) != 0);
+
+	/* QUERY_LAST_IN_LEAF on last extent [20, 25) -> flag IS set */
+	map.m_lblk = 20;
+	map.m_len = 5;
+	map.m_flags = 0;
+	down_read(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map,
+				  EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF);
+	up_read(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, ret, 5);
+	KUNIT_EXPECT_TRUE(test,
+			  (map.m_flags & EXT4_MAP_QUERY_LAST_IN_LEAF) != 0);
+}
+
+/*
+ * Verify ext4_ext_map_blocks() block allocation with overlap clamping
+ * (ext4_ext_check_overlap) and freeing of newly allocated blocks when
+ * ext4_ext_insert_extent() fails with -ENOSPC.
+ */
+static void test_map_blocks_alloc_overlap_and_enospc(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_map_blocks map = {};
+	int ret;
+
+	ext_reset_tree(inode);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 15, 5, 200, false, 0), 0);
+
+	/*
+	 * Request allocation for [10, 20) (len 10): ext4_ext_check_overlap()
+	 * clamps the allocation to [10, 15) (len 5) to avoid overlapping [15, 20).
+	 */
+	k_ctx.alloc_calls = 0;
+	map.m_lblk = 10;
+	map.m_len = 10;
+	map.m_flags = 0;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	KUNIT_EXPECT_EQ(test, ret, 5);
+	KUNIT_EXPECT_EQ(test, map.m_len, 5U);
+	KUNIT_EXPECT_EQ(test, map.m_pblk, EXT_ALLOC_BASE_PBLK);
+	KUNIT_EXPECT_TRUE(test,
+			  (map.m_flags & (EXT4_MAP_NEW | EXT4_MAP_MAPPED)) ==
+				  (EXT4_MAP_NEW | EXT4_MAP_MAPPED));
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 1U);
+	KUNIT_EXPECT_EQ(test, k_ctx.last_alloc_len, 5U);
+
+	/*
+	 * Force ext4_ext_insert_extent() to return -ENOSPC and verify that
+	 * ext4_ext_map_blocks() frees the newly allocated blocks.
+	 */
+	kunit_activate_static_stub(test, ext4_ext_insert_extent,
+				   ext4_ext_insert_extent_stub);
+	k_ctx.free_calls = 0;
+	map.m_lblk = 30;
+	map.m_len = 4;
+	map.m_flags = 0;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map,
+				  EXT4_GET_BLOCKS_CREATE |
+					  EXT4_GET_BLOCKS_DELALLOC_RESERVE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	KUNIT_EXPECT_EQ(test, ret, -ENOSPC);
+	KUNIT_EXPECT_EQ(test, k_ctx.free_calls, 1U);
+	KUNIT_EXPECT_EQ(test, k_ctx.last_free_pblk, k_ctx.last_alloc_pblk);
+	KUNIT_EXPECT_EQ(test, k_ctx.last_free_count, 4UL);
+	KUNIT_EXPECT_EQ(test, k_ctx.last_free_flags,
+			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE);
+}
+
+/*
+ * Verify ext4_ext_convert_to_initialized() fastpath block transfers to
+ * abutting left (ex - 1) and right (ex + 1) initialized neighbors without
+ * splitting into new extent entries.
+ */
+static void test_convert_to_initialized_abut_neighbors(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent *ex;
+	struct ext4_map_blocks map = {};
+	int ret;
+
+	EXT4_SB(inode->i_sb)->s_extent_max_zeroout_kb = 0;
+	ext_reset_tree(inode);
+
+	/*
+	 * Setup: [10, 12) @ 100 (written), [12, 16) @ 102 (unwritten),
+	 * [16, 18) @ 106 (written).
+	 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 2, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 12, 4, 102, true, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 16, 2, 106, false, 0), 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+
+	/*
+	 * Convert head of unwritten extent [12, 14): transfers 2 blocks to
+	 * left neighbor [10, 12) -> [10, 14) written, [14, 16) unwritten.
+	 */
+	map.m_lblk = 12;
+	map.m_len = 2;
+	map.m_flags = 0;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, ret, 2);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 4);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex[0]), 0);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), 14U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[1]), 2);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex[1]), 1);
+
+	/*
+	 * Convert tail of unwritten extent [15, 16): transfers 1 block to
+	 * right neighbor [16, 18) -> [14, 15) unwritten, [15, 18) written.
+	 */
+	map.m_lblk = 15;
+	map.m_len = 1;
+	map.m_flags = 0;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, ret, 1);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), 14U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[1]), 1);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex[1]), 1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[2].ee_block), 15U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[2]), 3);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[2]), 105ULL);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex[2]), 0);
+}
+
+/*
+ * Verify bigalloc get_implied_cluster_alloc() in ext4_ext_map_blocks() when
+ * an existing extent to the left or right already maps the same logical
+ * cluster, avoiding a duplicate physical cluster allocation.
+ */
+static void test_map_blocks_bigalloc_implied_cluster(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_map_blocks map = {};
+	int ret;
+
+	sbi->s_cluster_bits = 2;
+	sbi->s_cluster_ratio = 4;
+
+	/*
+	 * Case 1: Left extent [8, 9) @ 100 in logical cluster 2 (lblks 8..11).
+	 * Allocating [10, 12) reuses physical cluster 25 (pblks 102..103)
+	 * without calling ext4_mb_new_blocks().
+	 */
+	ext_reset_tree(inode);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 8, 1, 100, false, 0), 0);
+
+	k_ctx.alloc_calls = 0;
+	map.m_lblk = 10;
+	map.m_len = 2;
+	map.m_flags = 0;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	KUNIT_EXPECT_EQ(test, ret, 2);
+	KUNIT_EXPECT_EQ(test, map.m_pblk, 102ULL);
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 0U);
+
+	/*
+	 * Case 2: Right extent [10, 12) @ 102 in logical cluster 2 (lblks 8..11).
+	 * Allocating [8, 10) searches right, finds [10, 12), and reuses
+	 * physical cluster 25 (pblks 100..101) without calling ext4_mb_new_blocks().
+	 */
+	ext_reset_tree(inode);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 2, 102, false, 0), 0);
+
+	k_ctx.alloc_calls = 0;
+	map.m_lblk = 8;
+	map.m_len = 2;
+	map.m_flags = 0;
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_map_blocks(NULL, inode, &map, EXT4_GET_BLOCKS_CREATE);
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+	KUNIT_EXPECT_EQ(test, ret, 2);
+	KUNIT_EXPECT_EQ(test, map.m_pblk, 100ULL);
+	KUNIT_EXPECT_EQ(test, k_ctx.alloc_calls, 0U);
+}
+
+/*
+ * Verify ext4_ext_shift_extents() for SHIFT_LEFT (collapse range) with
+ * neighbor merging, SHIFT_RIGHT (insert range), and -EINVAL boundary checks.
+ */
+static void test_ext_shift_extents(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent *ex;
+	int err;
+
+	ext_reset_tree(inode);
+	/* [10, 15) @ 100 and [20, 25) @ 105 (physically contiguous!) */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 5, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 20, 5, 105, false, 0), 0);
+
+	/* Shifting [20, 25) left by 6 overlaps [10, 15) -> -EINVAL */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_shift_extents_test(inode, NULL, 20, 6, SHIFT_LEFT);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, err, -EINVAL);
+
+	/* Shifting [20, 25) left by 5 merges with [10, 15) into [10, 20) @ 100 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_shift_extents_test(inode, NULL, 20, 5, SHIFT_LEFT);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 1);
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 10);
+
+	/* Shifting [10, 20) right by 4 moves it to [14, 24) @ 100 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_shift_extents_test(inode, NULL, 10, 4, SHIFT_RIGHT);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 14U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 10);
+
+	/* Shifting right past EXT_MAX_BLOCKS -> -EINVAL */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	err = ext4_ext_shift_extents_test(inode, NULL, 14, EXT_MAX_BLOCKS,
+					  SHIFT_RIGHT);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	KUNIT_EXPECT_EQ(test, err, -EINVAL);
+}
+
+/*
+ * Verify ext4_swap_extents() splits unaligned boundaries on both inodes,
+ * swaps physical block mappings for the requested subrange, and marks
+ * the donor inode's swapped extent unwritten when requested.
+ */
+static void test_swap_extents(struct kunit *test)
+{
+	struct inode *inode1 = &k_ctx.k_ei->vfs_inode;
+	struct inode *inode2;
+	struct ext4_extent_header *eh1, *eh2;
+	struct ext4_extent *ex1, *ex2;
+	int replaced, err = 0;
+
+	k_ctx.k_ei2 = kzalloc_obj(struct ext4_inode_info);
+	KUNIT_ASSERT_NOT_NULL(test, k_ctx.k_ei2);
+	ext_init_mock_inode(k_ctx.k_ei2, inode1->i_sb, 13);
+	inode2 = &k_ctx.k_ei2->vfs_inode;
+
+	ext_reset_tree(inode1);
+	ext_reset_tree(inode2);
+
+	/* inode1: [10, 20) @ 100; inode2: [10, 20) @ 200 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode1, 10, 10, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode2, 10, 10, 200, false, 0), 0);
+
+	inode_lock(inode1);
+	inode_lock(inode2);
+	down_write(&EXT4_I(inode1)->i_data_sem);
+	down_write(&EXT4_I(inode2)->i_data_sem);
+
+	replaced = ext4_swap_extents(NULL, inode1, inode2, 12, 12, 5, 1, &err);
+
+	up_write(&EXT4_I(inode2)->i_data_sem);
+	up_write(&EXT4_I(inode1)->i_data_sem);
+	inode_unlock(inode2);
+	inode_unlock(inode1);
+
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, replaced, 5);
+
+	eh1 = ext_inode_hdr(inode1);
+	eh2 = ext_inode_hdr(inode2);
+	KUNIT_ASSERT_EQ(test, le16_to_cpu(eh1->eh_entries), 3);
+	KUNIT_ASSERT_EQ(test, le16_to_cpu(eh2->eh_entries), 3);
+
+	ex1 = EXT_FIRST_EXTENT(eh1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex1[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex1[0]), 100ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex1[1].ee_block), 12U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex1[1]), 5);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex1[1]), 202ULL);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex1[1]), 0);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex1[2].ee_block), 17U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex1[2]), 107ULL);
+
+	ex2 = EXT_FIRST_EXTENT(eh2);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex2[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex2[0]), 200ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex2[1].ee_block), 12U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex2[1]), 5);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex2[1]), 102ULL);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex2[1]), 1);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex2[2].ee_block), 17U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex2[2]), 207ULL);
+}
+
+/*
+ * Verify ext4_clu_mapped() across inline-data inodes, empty trees, clusters
+ * mapped at the start or end of a cluster, and unmapped clusters.
+ */
+static void test_clu_mapped(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	sbi->s_cluster_bits = 2;
+	sbi->s_cluster_ratio = 4;
+
+	ext_reset_tree(inode);
+	/* Empty tree -> unmapped */
+	KUNIT_EXPECT_EQ(test, ext4_clu_mapped(inode, 0), 0);
+
+	/*
+	 * Insert [0, 2) @ 100 (in lclu 0 = lblks 0..3) and
+	 * [6, 8) @ 106 (in lclu 1 = lblks 4..7).
+	 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 0, 2, 100, false, 0), 0);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 6, 2, 106, false, 0), 0);
+
+	/* Inline-data state returns 0 immediately */
+	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	KUNIT_EXPECT_EQ(test, ext4_clu_mapped(inode, 0), 0);
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+
+	/* lclu 0 (lblk 0) is mapped directly by [0, 2) */
+	KUNIT_EXPECT_EQ(test, ext4_clu_mapped(inode, 0), 1);
+	/* lclu 1 (lblk 4) is mapped by next allocated extent [6, 8) */
+	KUNIT_EXPECT_EQ(test, ext4_clu_mapped(inode, 1), 1);
+	/* lclu 2 (lblk 8..11) is unmapped */
+	KUNIT_EXPECT_EQ(test, ext4_clu_mapped(inode, 2), 0);
+}
+
+/*
+ * Verify ext4_ext_index_trans_blocks() and
+ * ext4_ext_calc_credits_for_single_extent() credit calculations.
+ */
+static void test_ext_credits_calculation(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_ext_path *path;
+	int credits_with_space, credits_full;
+
+	/* 1 extent vs multiple extents */
+	KUNIT_EXPECT_EQ(test, ext4_ext_index_trans_blocks(inode, 1),
+			EXT4_MAX_EXTENT_DEPTH * 2 + 1);
+	KUNIT_EXPECT_EQ(test, ext4_ext_index_trans_blocks(inode, 2),
+			EXT4_MAX_EXTENT_DEPTH * 3 + 2);
+
+	/* Inline data inode needs only 1 index block credit */
+	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+	EXT4_I(inode)->i_inline_off = 1;
+	KUNIT_EXPECT_EQ(test, ext4_ext_index_trans_blocks(inode, 2), 1);
+	EXT4_I(inode)->i_inline_off = 0;
+	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+
+	ext_reset_tree(inode);
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 2, 100, false, 0), 0);
+
+	path = ext4_find_extent(inode, 10, NULL, EXT4_EX_NOCACHE);
+	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(path));
+	/* Leaf has free space (eh_entries = 1 < eh_max = 4) */
+	credits_with_space =
+		ext4_ext_calc_credits_for_single_extent(inode, 1, path);
+
+	/* Mark leaf full (eh_entries == eh_max) */
+	eh->eh_entries = eh->eh_max;
+	credits_full = ext4_ext_calc_credits_for_single_extent(inode, 1, path);
+	eh->eh_entries = cpu_to_le16(1);
+	ext4_free_ext_path(path);
+
+	KUNIT_EXPECT_LT(test, credits_with_space, credits_full);
+	KUNIT_EXPECT_EQ(test, credits_full,
+			ext4_ext_calc_credits_for_single_extent(inode, 1, NULL));
+}
+
+/*
+ * Verify fast-commit replay extent helpers:
+ * - ext4_ext_replay_update_ex() splits and updates extent state/pblk
+ * - ext4_ext_replay_shrink_inode() merges adjacent compatible extents
+ * - ext4_ext_replay_set_iblocks() counts data and extent tree blocks and
+ *   updates inode->i_blocks.
+ */
+static void test_ext_fast_commit_replay(struct kunit *test)
+{
+	struct inode *inode = &k_ctx.k_ei->vfs_inode;
+	struct ext4_extent_header *eh = ext_inode_hdr(inode);
+	struct ext4_extent *ex;
+	int err;
 
-	return;
+	ext_reset_tree(inode);
+	/* Start with unwritten extent [10, 20) @ 100 */
+	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 10, 100, true, 0), 0);
+
+	/* Replay update converting middle [12, 16) to written @ 102 */
+	err = ext4_ext_replay_update_ex(inode, 12, 4, 0, 102);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+
+	/* Replay update converting [10, 12) @ 100 and [16, 20) @ 106 to written */
+	KUNIT_ASSERT_EQ(test, ext4_ext_replay_update_ex(inode, 10, 2, 0, 100),
+			0);
+	KUNIT_ASSERT_EQ(test, ext4_ext_replay_update_ex(inode, 16, 4, 0, 106),
+			0);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
+
+	/* Shrink inode merges the 3 contiguous written extents into [10, 20) */
+	ext4_ext_replay_shrink_inode(inode, 25);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 1);
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 10U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 10);
+	KUNIT_EXPECT_EQ(test, ext4_ext_is_unwritten(&ex[0]), 0);
+
+	/* Recalculate i_blocks for the 10-block extent (10 * 8 = 80 sectors) */
+	inode->i_size = 30ULL << inode->i_sb->s_blocksize_bits;
+	inode->i_blocks = 0;
+	err = ext4_ext_replay_set_iblocks(inode);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, inode->i_blocks,
+			10ULL << (inode->i_sb->s_blocksize_bits - 9));
 }
 
 static const struct kunit_ext_test_param test_split_convert_params[] = {
@@ -1049,6 +2774,31 @@ static struct kunit_case extents_test_cases[] = {
 				   test_convert_initialized_param_init, NULL),
 	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
 				   test_handle_unwritten_init, NULL),
+	KUNIT_CASE(test_ext_pblock_48bit),
+	KUNIT_CASE(test_ext_unwritten_len_encoding),
+	KUNIT_CASE(test_ext_tree_init_and_check_inode),
+	KUNIT_CASE_PARAM_WITH_INIT(test_ext_check_corruptions,
+				   kunit_array_gen_params,
+				   ext_check_corrupt_param_init, NULL),
+	KUNIT_CASE(test_ext_block_csum_verify),
+	KUNIT_CASE(test_find_extent_root_binsearch),
+	KUNIT_CASE(test_find_extent_multilevel_and_navigation),
+	KUNIT_CASE(test_ext_precache),
+	KUNIT_CASE(test_can_extents_be_merged),
+	KUNIT_CASE(test_insert_extent_merge_and_nomerge),
+	KUNIT_CASE(test_insert_extent_grow_and_merge_up),
+	KUNIT_CASE(test_remove_space_tail_and_hole_punch),
+	KUNIT_CASE(test_remove_space_multilevel_collapse),
+	KUNIT_CASE(test_remove_space_bigalloc_partial_cluster),
+	KUNIT_CASE(test_map_blocks_lookup_hole_and_query_last_in_leaf),
+	KUNIT_CASE(test_map_blocks_alloc_overlap_and_enospc),
+	KUNIT_CASE(test_convert_to_initialized_abut_neighbors),
+	KUNIT_CASE(test_map_blocks_bigalloc_implied_cluster),
+	KUNIT_CASE(test_ext_shift_extents),
+	KUNIT_CASE(test_swap_extents),
+	KUNIT_CASE(test_clu_mapped),
+	KUNIT_CASE(test_ext_credits_calculation),
+	KUNIT_CASE(test_ext_fast_commit_replay),
 	{}
 };
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6c018bcc0118..efbee7aaa95d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -547,6 +547,13 @@ static void ext4_cache_extents(struct inode *inode,
 	}
 }
 
+struct buffer_head *ext4_ext_getblk(struct inode *inode, ext4_fsblk_t pblk,
+				    gfp_t gfp_flags)
+{
+	KUNIT_STATIC_STUB_REDIRECT(ext4_ext_getblk, inode, pblk, gfp_flags);
+	return sb_getblk_gfp(inode->i_sb, pblk, gfp_flags);
+}
+
 static struct buffer_head *
 __read_extent_tree_block(const char *function, unsigned int line,
 			 struct inode *inode, struct ext4_extent_idx *idx,
@@ -561,7 +568,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
 		gfp_flags |= __GFP_NOFAIL;
 
 	pblk = ext4_idx_pblock(idx);
-	bh = sb_getblk_gfp(inode->i_sb, pblk, gfp_flags);
+	bh = ext4_ext_getblk(inode, pblk, gfp_flags);
 	if (unlikely(!bh))
 		return ERR_PTR(-ENOMEM);
 
@@ -1124,7 +1131,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		err = -EFSCORRUPTED;
 		goto cleanup;
 	}
-	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
+	bh = ext4_ext_getblk(inode, newblock, __GFP_MOVABLE | GFP_NOFS);
 	if (unlikely(!bh)) {
 		err = -ENOMEM;
 		goto cleanup;
@@ -1203,7 +1210,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	while (k--) {
 		oldblock = newblock;
 		newblock = ablocks[--a];
-		bh = sb_getblk(inode->i_sb, newblock);
+		bh = ext4_ext_getblk(inode, newblock, __GFP_MOVABLE | GFP_NOFS);
 		if (unlikely(!bh)) {
 			err = -ENOMEM;
 			goto cleanup;
@@ -1332,7 +1339,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	if (newblock == 0)
 		return err;
 
-	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
+	bh = ext4_ext_getblk(inode, newblock, __GFP_MOVABLE | GFP_NOFS);
 	if (unlikely(!bh))
 		return -ENOMEM;
 	lock_buffer(bh);
@@ -6405,11 +6412,79 @@ struct ext4_ext_path *ext4_split_convert_extents_test(handle_t *handle,
 }
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_split_convert_extents_test);
 
+int ext4_ext_check_test(struct inode *inode, struct ext4_extent_header *eh,
+			int depth, ext4_fsblk_t pblk, ext4_lblk_t lblk)
+{
+	return __ext4_ext_check(__func__, __LINE__, inode, eh, depth, pblk,
+				lblk);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_check_test);
+
+void ext4_extent_block_csum_set_test(struct inode *inode,
+				     struct ext4_extent_header *eh)
+{
+	ext4_extent_block_csum_set(inode, eh);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_extent_block_csum_set_test);
+
+int ext4_can_extents_be_merged_test(struct inode *inode,
+				    struct ext4_extent *ex1,
+				    struct ext4_extent *ex2)
+{
+	return ext4_can_extents_be_merged(inode, ex1, ex2);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_can_extents_be_merged_test);
+
+int ext4_ext_search_left_test(struct inode *inode, struct ext4_ext_path *path,
+			      ext4_lblk_t *logical, ext4_fsblk_t *phys)
+{
+	return ext4_ext_search_left(inode, path, logical, phys);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_search_left_test);
+
+int ext4_ext_search_right_test(struct inode *inode, struct ext4_ext_path *path,
+			       ext4_lblk_t *logical, ext4_fsblk_t *phys,
+			       struct ext4_extent *ret_ex, int flags)
+{
+	return ext4_ext_search_right(inode, path, logical, phys, ret_ex, flags);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_search_right_test);
+
+ext4_lblk_t ext4_ext_next_leaf_block_test(struct ext4_ext_path *path)
+{
+	return ext4_ext_next_leaf_block(path);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_next_leaf_block_test);
+
+int ext4_ext_shift_extents_test(struct inode *inode, handle_t *handle,
+				ext4_lblk_t start, ext4_lblk_t shift,
+				enum SHIFT_DIRECTION direction)
+{
+	return ext4_ext_shift_extents(inode, handle, start, shift, direction);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_shift_extents_test);
+
 EXPORT_SYMBOL_FOR_EXT4_TEST(__ext4_ext_dirty);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_getblk);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_zeroout);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_map_create_blocks);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_insert_extent);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_find_extent);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_issue_zeroout);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_map_query_blocks);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_ext_path);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_tree_init);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_check_inode);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_precache);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_next_allocated_block);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_calc_credits_for_single_extent);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_index_trans_blocks);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_remove_space);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_truncate);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_map_blocks);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_swap_extents);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_clu_mapped);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_replay_update_ex);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_replay_shrink_inode);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_replay_set_iblocks);
 #endif
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 966a760f64e6..289f7fa35090 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6699,6 +6699,9 @@ int __ext4_mark_inode_dirty(handle_t *handle, struct inode *inode,
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int err;
 
+	KUNIT_STATIC_STUB_REDIRECT(__ext4_mark_inode_dirty, handle, inode,
+				   func, line);
+
 	might_sleep();
 	trace_ext4_mark_inode_dirty(inode, _RET_IP_);
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
@@ -6982,4 +6985,6 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_da_update_reserve_space);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_da_release_space);
+EXPORT_SYMBOL_FOR_EXT4_TEST(__ext4_mark_inode_dirty);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_map_blocks);
 #endif
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 06171a11db12..0f73fb826dbf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6239,6 +6239,8 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	int retries = 0;
 	u64 seq;
 
+	KUNIT_STATIC_STUB_REDIRECT(ext4_mb_new_blocks, handle, ar, errp);
+
 	might_sleep();
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
@@ -6697,6 +6699,9 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	unsigned int overflow;
 	struct ext4_sb_info *sbi;
 
+	KUNIT_STATIC_STUB_REDIRECT(ext4_free_blocks, handle, inode, bh, block,
+				   count, flags);
+
 	sbi = EXT4_SB(sb);
 
 	if (bh) {
@@ -7281,4 +7286,6 @@ EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_read_block_bitmap_nowait);
 EXPORT_SYMBOL_FOR_EXT4_TEST(mb_set_bits);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fc_init_inode);
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_mark_context);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_new_blocks);
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_blocks);
 #endif
-- 
2.56.0.542.g3ef89b7020-goog

