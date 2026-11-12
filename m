Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456427;
	b=WmkcKPoJ/WhtEOQbbJN9OhvhNr5YDp6UpBMNhC9gc6LbwsKB6Ef5rmRPBr97mWxeZpae
	 39kLY/BUPZpAW5rrLYgdcSSG4QycehVPvvpLpQkayZd3s06e71YkyTlu2OHiQthY2OpM2
	 kbT9z7GAxip+J5FmqhuS87+IjcCrG7oQzIOpe0FLwu7zRHh6fegUlOQCyM2Ibt8uClU4G
	 +rA+9+hFxl7Q4sxWZQHW9BZDcZk2CV7OoK+t9oacO0Q1+W5FjH79+T5UCZwW8FklEEl1Z
	 FcVp45GekVQ2BJYC1YENmKxfy39lCkHbP5zDVd8nOxB+beIvJ09AeyopWbV5mpVzIDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456427;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zm74OKkpf9xHvFd+xZi+QNJaeoLW25lZoKsmbJV84g8=;
	b=q3zXl0A4SF45IJNGHpVF16iKobh16zTXo3TbfG3mY6NoFYbxROiPXS+73I04EyAiWQUZ
	 t9uWxuC+SiGhftEDilkYaY9Q+Wu9Cv19bclAoK1mdIlmwLV53DwEQyjRcHIqXCRSrXmZ0
	 QnnOU/E4ztD2tBl0cRTLxmg987O3z7ukw6daF6FwdTYIPpW9q8raY+u0OuGfbmEMo+wou
	 95a1hopKghsECq9QFkoEUZYshAwfj+auUra2Hz4XgI8ucnjtr0AFG5wiX9j4B5jNZoZGy
	 K09T3J9Aq0Fx9M9Qi1qmSjiT+4Tf0v7RHwOramGZ5D7Cy56TAfDxZ7b2EVrDBQyLyng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=aKAs67xe;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1C606A899
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFB1C606A899
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=aKAs67xe
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46sCh016934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456416; bh=zm74OKkpf9xHvFd+xZi+QNJaeoLW25lZoKsmbJV84g8=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=aKAs67xe9pCHIWGb55/QPzQEaKh4S6X3AtIn6xOc6jA0Hf0c/h4BCKEJFEWsHRrwc
	 7JHip82SJHIuh4sxFDpsecgtwQwitk/ETAzHb3lILjqE0MwO845I7UR0dP4XcHO+uq
	 RKzAAU7AVOvJjRUQgIgEEoy+XGnEVp+CrDPVspOeVN3ylmouUGUznSxuKGeLN0MSnG
	 5y2+FhcQT5jNYW8Uez7LckjwL1cS2k0Ebd9VJOTWhx1tA9/59EcmfcM0HvpiOeJRaa
	 JB4EyH1lnwtig7rWJLLs/dW6tT6wx0n5rWgP4Ugm00w9VvP4/FU/HJQGbZVZjMi0dc
	 oWV1ipN6XOSJw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 93C502E015D; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 24/27] ext4: add KUnit tests for fs/ext4/fsmap.c
Date: Wed, 11 Nov 2026 23:06:35 -0500
Message-ID: <20261112040638.1576836-25-tytso@mit.edu>
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

Add KUnit test suite ext4_fsmap_test in fs/ext4/fsmap-test.c covering
FS_IOC_GETFSMAP reverse-mapping queries in fs/ext4/fsmap.c:

- ext4_fsmap_from_internal() and ext4_fsmap_to_internal() block/byte
  conversions across 1K, 4K, and 64K block sizes
- ext4_getfsmap() validation of flags, device IDs, inverted keys,
  out-of-range physical offsets, and missing group descriptors
- fixed per-group metadata synthesis (superblock, GDT, reserved GDT,
  block bitmap, inode bitmap, inode table), free extents, and
  EXT4_FMR_OWN_UNKNOWN gaps in the middle and at EOFS
- flex_bg adjacent fixed-metadata merging and cross-group free-extent
  coalescing via gfi_lastfree
- 1K s_first_data_block offset handling, bigalloc cluster scaling, and
  META_BG reserved-GDT suppression
- count-only queries, bounded continuation-key pagination, formatter
  abort propagation, and external journal device reporting

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Makefile     |   2 +-
 fs/ext4/fsmap-test.c | 787 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/fsmap.c      |   3 +
 fs/ext4/mballoc.c    |   3 +
 4 files changed, 794 insertions(+), 1 deletion(-)
 create mode 100644 fs/ext4/fsmap-test.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 503acc946409..e1964407be24 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -23,7 +23,7 @@ ext4-test-objs				+= inode-test.o mballoc-test.o \
 					   block_validity-test.o super-test.o \
 					   sysfs-test.o ioctl-test.o \
 					   resize-test.o migrate-test.o \
-					   indirect-test.o
+					   indirect-test.o fsmap-test.o
 obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
 ext4-$(CONFIG_FS_ENCRYPTION)		+= crypto.o
diff --git a/fs/ext4/fsmap-test.c b/fs/ext4/fsmap-test.c
new file mode 100644
index 000000000000..63a1061b413a
--- /dev/null
+++ b/fs/ext4/fsmap-test.c
@@ -0,0 +1,787 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for fs/ext4/fsmap.c (FS_IOC_GETFSMAP reverse-mapping queries).
+ */
+
+#include <kunit/static_stub.h>
+#include <kunit/test.h>
+#include <linux/bitmap.h>
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/fs_context.h>
+#include <linux/fsmap.h>
+#include <linux/kdev_t.h>
+#include <linux/log2.h>
+#include <linux/part_stat.h>
+#include <linux/percpu.h>
+
+#include "ext4.h"
+#include "fsmap.h"
+#include "mballoc.h"
+
+#define FSMAP_TEST_MAX_GROUPS		4
+#define FSMAP_TEST_MAX_CLUSTERS_PER_GRP	1024
+#define FSMAP_TEST_MAX_RECS		24
+#define FSMAP_TEST_DATADEV		MKDEV(8, 1)
+#define FSMAP_TEST_LOGDEV		MKDEV(8, 2)
+
+/*
+ * Matches struct bdev_inode layout in block/bdev.c so file_bdev() resolves
+ * &bdev via container_of(bdev_file->f_mapping->host, ...).
+ */
+struct fsmap_mock_bdev_inode {
+	struct block_device bdev;
+	struct inode vfs_inode;
+};
+
+struct fsmap_rec_sink {
+	struct ext4_fsmap recs[FSMAP_TEST_MAX_RECS];
+	unsigned int count;
+	unsigned int abort_after;
+	int fail_err;
+};
+
+struct fsmap_test_ctx {
+	struct super_block *sb;
+	struct ext4_sb_info sbi;
+	struct ext4_super_block es;
+	struct buffer_head sbh;
+	char sbh_data[4096];
+
+	struct fsmap_mock_bdev_inode data_bdev;
+	struct fsmap_mock_bdev_inode log_bdev;
+	struct file log_bdev_file;
+	journal_t mock_journal;
+
+	struct buffer_head gdb_bh;
+	struct buffer_head *gdb_bh_arr[1];
+	u8 gdb_data[4096];
+
+	DECLARE_BITMAP(grp_bms[FSMAP_TEST_MAX_GROUPS],
+		       FSMAP_TEST_MAX_CLUSTERS_PER_GRP);
+};
+
+static struct fsmap_test_ctx *fsmap_active_ctx;
+
+static void fsmap_noop_work(struct work_struct *work)
+{
+}
+
+static void fsmap_noop_timer(struct timer_list *timer)
+{
+}
+
+static const struct super_operations fsmap_test_sops = {};
+
+static int fsmap_test_init_fs_context(struct fs_context *fc)
+{
+	return 0;
+}
+
+static int fsmap_test_set_super(struct super_block *sb, struct fs_context *fc)
+{
+	return set_anon_super_fc(sb, fc);
+}
+
+static struct file_system_type fsmap_test_fs_type = {
+	.name		= "ext4-fsmap-test",
+	.init_fs_context = fsmap_test_init_fs_context,
+	.kill_sb	= kill_anon_super,
+};
+
+static void fsmap_cleanup_ctx(void *data)
+{
+	struct fsmap_test_ctx *ctx = data;
+
+	fsmap_active_ctx = NULL;
+	cancel_work_sync(&ctx->sbi.s_sb_upd_work);
+	timer_delete_sync(&ctx->sbi.s_err_report);
+
+	if (ctx->sb)
+		deactivate_super(ctx->sb);
+	if (ctx->data_bdev.bdev.bd_stats)
+		free_percpu(ctx->data_bdev.bdev.bd_stats);
+	if (ctx->log_bdev.bdev.bd_stats)
+		free_percpu(ctx->log_bdev.bdev.bd_stats);
+}
+
+static int fsmap_query_range_stub(struct super_block *sb,
+				  ext4_group_t group,
+				  ext4_grpblk_t first,
+				  ext4_grpblk_t end,
+				  ext4_mballoc_query_range_fn meta_formatter,
+				  ext4_mballoc_query_range_fn formatter,
+				  void *priv)
+{
+	struct fsmap_test_ctx *ctx = fsmap_active_ctx;
+	ext4_grpblk_t max_clu = EXT4_CLUSTERS_PER_GROUP(sb);
+	ext4_grpblk_t first_free, start, next;
+	unsigned long *bm;
+	int error;
+
+	if (!ctx || group >= FSMAP_TEST_MAX_GROUPS)
+		return -EINVAL;
+
+	bm = ctx->grp_bms[group];
+	if ((unsigned long)end >= EXT4_CLUSTERS_PER_GROUP(sb))
+		end = max_clu - 1;
+
+	first_free = find_next_zero_bit(bm, max_clu, 0);
+	start = max_t(ext4_grpblk_t, first_free, first);
+
+	if (meta_formatter && start != first) {
+		if (start > end)
+			start = end;
+		error = meta_formatter(sb, group, first, start - first, priv);
+		if (error)
+			return error;
+	}
+
+	while (start <= end) {
+		start = find_next_zero_bit(bm, end + 1, start);
+		if (start > end)
+			break;
+		next = find_next_bit(bm, end + 1, start);
+
+		error = formatter(sb, group, start, next - start, priv);
+		if (error)
+			return error;
+
+		start = next + 1;
+	}
+
+	return 0;
+}
+
+static int fsmap_collect_cb(struct ext4_fsmap *fmr, void *priv)
+{
+	struct fsmap_rec_sink *sink = priv;
+
+	if (sink->fail_err)
+		return sink->fail_err;
+
+	if (sink->count < FSMAP_TEST_MAX_RECS)
+		sink->recs[sink->count] = *fmr;
+	sink->count++;
+
+	if (sink->abort_after && sink->count >= sink->abort_after)
+		return EXT4_QUERY_RANGE_ABORT;
+
+	return EXT4_QUERY_RANGE_CONTINUE;
+}
+
+static void fsmap_mark_clusters_used(struct fsmap_test_ctx *ctx,
+				     ext4_group_t agno,
+				     ext4_grpblk_t start_clu,
+				     ext4_grpblk_t len_clu)
+{
+	bitmap_set(ctx->grp_bms[agno], start_clu, len_clu);
+}
+
+static void fsmap_set_group_tables(struct fsmap_test_ctx *ctx,
+				   ext4_group_t agno,
+				   ext4_fsblk_t blk_bm,
+				   ext4_fsblk_t ino_bm,
+				   ext4_fsblk_t itable)
+{
+	struct super_block *sb = ctx->sb;
+	struct ext4_group_desc *gdp;
+
+	gdp = (struct ext4_group_desc *)(ctx->gdb_data +
+					 agno * EXT4_DESC_SIZE(sb));
+	ext4_block_bitmap_set(sb, gdp, blk_bm);
+	ext4_inode_bitmap_set(sb, gdp, ino_bm);
+	ext4_inode_table_set(sb, gdp, itable);
+}
+
+static struct fsmap_test_ctx *fsmap_create_ctx(struct kunit *test,
+					       unsigned int blocksize_bits,
+					       unsigned int cluster_bits,
+					       ext4_group_t groups_count,
+					       ext4_grpblk_t blocks_per_group)
+{
+	struct fsmap_test_ctx *ctx;
+	struct fs_context *fc;
+	struct super_block *sb;
+	struct ext4_sb_info *sbi;
+	unsigned int blocksize = 1U << blocksize_bits;
+	ext4_fsblk_t bofs = (blocksize == 1024) ? 1 : 0;
+	int err;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+
+	inode_init_once(&ctx->data_bdev.vfs_inode);
+	address_space_init_once(&ctx->data_bdev.vfs_inode.i_data);
+	ctx->data_bdev.vfs_inode.i_data.host = &ctx->data_bdev.vfs_inode;
+	ctx->data_bdev.bdev.bd_dev = FSMAP_TEST_DATADEV;
+	ctx->data_bdev.bdev.bd_mapping = &ctx->data_bdev.vfs_inode.i_data;
+	ctx->data_bdev.bdev.bd_stats = alloc_percpu(struct disk_stats);
+	KUNIT_ASSERT_NOT_NULL(test, ctx->data_bdev.bdev.bd_stats);
+
+	inode_init_once(&ctx->log_bdev.vfs_inode);
+	address_space_init_once(&ctx->log_bdev.vfs_inode.i_data);
+	ctx->log_bdev.vfs_inode.i_data.host = &ctx->log_bdev.vfs_inode;
+	ctx->log_bdev.bdev.bd_dev = FSMAP_TEST_LOGDEV;
+	ctx->log_bdev.bdev.bd_mapping = &ctx->log_bdev.vfs_inode.i_data;
+	ctx->log_bdev.bdev.bd_stats = alloc_percpu(struct disk_stats);
+	KUNIT_ASSERT_NOT_NULL(test, ctx->log_bdev.bdev.bd_stats);
+	ctx->log_bdev_file.f_mapping = &ctx->log_bdev.vfs_inode.i_data;
+
+	sbi = &ctx->sbi;
+	INIT_WORK(&sbi->s_sb_upd_work, fsmap_noop_work);
+	timer_setup(&sbi->s_err_report, fsmap_noop_timer, 0);
+	spin_lock_init(&sbi->s_error_lock);
+	spin_lock_init(&sbi->s_bdev_wb_lock);
+	ratelimit_state_init(&sbi->s_err_ratelimit_state,
+			     DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
+
+	fc = fs_context_for_mount(&fsmap_test_fs_type, 0);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(fc));
+	sb = sget_fc(fc, NULL, fsmap_test_set_super);
+	put_fs_context(fc);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(sb));
+	up_write(&sb->s_umount);
+
+	ctx->sb = sb;
+	err = kunit_add_action_or_reset(test, fsmap_cleanup_ctx, ctx);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	sb->s_fs_info = sbi;
+	sb->s_op = &fsmap_test_sops;
+	sb->s_bdev = &ctx->data_bdev.bdev;
+	sb->s_blocksize = blocksize;
+	sb->s_blocksize_bits = blocksize_bits;
+	strscpy(sb->s_id, "ext4-fsmap", sizeof(sb->s_id));
+
+	ctx->sbh.b_data = ctx->sbh_data;
+	ctx->sbh.b_size = blocksize;
+	ctx->sbh.b_bdev = sb->s_bdev;
+	atomic_set(&ctx->sbh.b_count, 2);
+	set_buffer_uptodate(&ctx->sbh);
+	clear_buffer_mapped(&ctx->sbh);
+
+	sbi->s_sb = sb;
+	sbi->s_es = &ctx->es;
+	sbi->s_sbh = &ctx->sbh;
+	set_opt(sb, ERRORS_CONT);
+
+	ctx->es.s_magic = cpu_to_le16(EXT4_SUPER_MAGIC);
+	ctx->es.s_rev_level = cpu_to_le32(EXT4_DYNAMIC_REV);
+	ctx->es.s_first_data_block = cpu_to_le32(bofs);
+	ctx->es.s_feature_incompat = cpu_to_le32(EXT4_FEATURE_INCOMPAT_64BIT);
+	ctx->es.s_desc_size = cpu_to_le16(64);
+	ext4_blocks_count_set(&ctx->es,
+			      bofs + (ext4_fsblk_t)groups_count *
+			      blocks_per_group);
+
+	sbi->s_desc_size = 64;
+	sbi->s_desc_per_block = blocksize / sbi->s_desc_size;
+	sbi->s_desc_per_block_bits = ilog2(sbi->s_desc_per_block);
+	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
+	sbi->s_groups_count = groups_count;
+	sbi->s_blocks_per_group = blocks_per_group;
+	sbi->s_cluster_bits = cluster_bits;
+	sbi->s_cluster_ratio = 1U << cluster_bits;
+	sbi->s_clusters_per_group = blocks_per_group >> cluster_bits;
+	sbi->s_itb_per_group = 8;
+	sbi->s_gdb_count = 1;
+
+	ctx->gdb_bh.b_data = ctx->gdb_data;
+	ctx->gdb_bh.b_size = blocksize;
+	ctx->gdb_bh.b_bdev = sb->s_bdev;
+	atomic_set(&ctx->gdb_bh.b_count, 2);
+	set_buffer_uptodate(&ctx->gdb_bh);
+	ctx->gdb_bh_arr[0] = &ctx->gdb_bh;
+	rcu_assign_pointer(sbi->s_group_desc, ctx->gdb_bh_arr);
+
+	fsmap_active_ctx = ctx;
+	kunit_activate_static_stub(test, ext4_mballoc_query_range,
+				   fsmap_query_range_stub);
+
+	return ctx;
+}
+
+static void fsmap_init_full_range_head(struct ext4_fsmap_head *head,
+				       unsigned int count)
+{
+	memset(head, 0, sizeof(*head));
+	head->fmh_count = count;
+	head->fmh_keys[1].fmr_device = UINT_MAX;
+	head->fmh_keys[1].fmr_physical = U64_MAX;
+	head->fmh_keys[1].fmr_owner = U64_MAX;
+	head->fmh_keys[1].fmr_flags = UINT_MAX;
+}
+
+static void fsmap_expect_rec(struct kunit *test, const struct ext4_fsmap *rec,
+			     u32 exp_dev, u64 exp_phys, u64 exp_len,
+			     u64 exp_owner)
+{
+	KUNIT_EXPECT_EQ(test, (u32)rec->fmr_device, exp_dev);
+	KUNIT_EXPECT_EQ(test, rec->fmr_physical, exp_phys);
+	KUNIT_EXPECT_EQ(test, rec->fmr_length, exp_len);
+	KUNIT_EXPECT_EQ(test, rec->fmr_owner, exp_owner);
+	KUNIT_EXPECT_EQ(test, rec->fmr_flags, (u32)FMR_OF_SPECIAL_OWNER);
+}
+
+/*
+ * Verify ext4_fsmap_from_internal() and ext4_fsmap_to_internal() block-to-byte
+ * and byte-to-block scaling across 1K, 4K, and 64K block sizes.
+ */
+static void test_fsmap_unit_conversions(struct kunit *test)
+{
+	static const unsigned int shifts[] = { 10, 12, 16 };
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap internal = {};
+	struct ext4_fsmap roundtrip = {};
+	struct fsmap uapi = {};
+	int i;
+
+	ctx = fsmap_create_ctx(test, 12, 0, 1, 256);
+
+	for (i = 0; i < ARRAY_SIZE(shifts); i++) {
+		unsigned int bits = shifts[i];
+
+		ctx->sb->s_blocksize_bits = bits;
+		ctx->sb->s_blocksize = 1U << bits;
+
+		memset(&uapi, 0xaa, sizeof(uapi));
+		internal.fmr_device = new_encode_dev(FSMAP_TEST_DATADEV);
+		internal.fmr_flags = FMR_OF_SPECIAL_OWNER;
+		internal.fmr_physical = 42;
+		internal.fmr_owner = EXT4_FMR_OWN_INODES;
+		internal.fmr_length = 17;
+
+		ext4_fsmap_from_internal(ctx->sb, &uapi, &internal);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_device,
+				(u32)internal.fmr_device);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_flags, internal.fmr_flags);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_physical, 42ULL << bits);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_owner, EXT4_FMR_OWN_INODES);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_offset, 0ULL);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_length, 17ULL << bits);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_reserved[0], 0U);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_reserved[1], 0U);
+		KUNIT_EXPECT_EQ(test, uapi.fmr_reserved[2], 0U);
+
+		/* Non-block-aligned byte tails truncate down to whole blocks */
+		uapi.fmr_physical += (1ULL << bits) - 1;
+		uapi.fmr_length += (1ULL << bits) - 1;
+		ext4_fsmap_to_internal(ctx->sb, &roundtrip, &uapi);
+		KUNIT_EXPECT_EQ(test, roundtrip.fmr_device,
+				internal.fmr_device);
+		KUNIT_EXPECT_EQ(test, roundtrip.fmr_flags, internal.fmr_flags);
+		KUNIT_EXPECT_EQ(test, roundtrip.fmr_physical, 42ULL);
+		KUNIT_EXPECT_EQ(test, roundtrip.fmr_owner, EXT4_FMR_OWN_INODES);
+		KUNIT_EXPECT_EQ(test, roundtrip.fmr_length, 17ULL);
+	}
+}
+
+/*
+ * Verify ext4_getfsmap() input flag, device ID, key ordering, out-of-range
+ * physical start, and missing group descriptor (-EFSCORRUPTED) checks.
+ */
+static void test_getfsmap_invalid_flags_devices_and_keys(struct kunit *test)
+{
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap_head head;
+	struct fsmap_rec_sink *sink;
+	u32 datadev = new_encode_dev(FSMAP_TEST_DATADEV);
+	int err;
+
+	sink = kunit_kzalloc(test, sizeof(*sink), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sink);
+	ctx = fsmap_create_ctx(test, 12, 0, 1, 256);
+	fsmap_set_group_tables(ctx, 0, 2, 3, 4);
+	fsmap_mark_clusters_used(ctx, 0, 0, 12);
+
+	/* Invalid fmh_iflags -> -EINVAL */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_iflags = ~FMH_IF_VALID;
+	KUNIT_EXPECT_EQ(test, ext4_getfsmap(ctx->sb, &head,
+					    fsmap_collect_cb, sink), -EINVAL);
+
+	/* Unrecognized low or high device ID -> -EINVAL */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = new_encode_dev(MKDEV(9, 9));
+	KUNIT_EXPECT_EQ(test, ext4_getfsmap(ctx->sb, &head,
+					    fsmap_collect_cb, sink), -EINVAL);
+
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[1].fmr_device = new_encode_dev(MKDEV(9, 9));
+	KUNIT_EXPECT_EQ(test, ext4_getfsmap(ctx->sb, &head,
+					    fsmap_collect_cb, sink), -EINVAL);
+
+	/* Inverted device, physical block, or owner keys -> -EINVAL */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = UINT_MAX;
+	head.fmh_keys[1].fmr_device = 0;
+	KUNIT_EXPECT_EQ(test, ext4_getfsmap(ctx->sb, &head,
+					    fsmap_collect_cb, sink), -EINVAL);
+
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = datadev;
+	head.fmh_keys[1].fmr_device = datadev;
+	head.fmh_keys[0].fmr_physical = 50;
+	head.fmh_keys[1].fmr_physical = 40;
+	KUNIT_EXPECT_EQ(test, ext4_getfsmap(ctx->sb, &head,
+					    fsmap_collect_cb, sink), -EINVAL);
+
+	/* Equal low+len and high physical with owner 0 == 0 -> -EINVAL */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = datadev;
+	head.fmh_keys[1].fmr_device = datadev;
+	head.fmh_keys[0].fmr_physical = 20;
+	head.fmh_keys[0].fmr_length = 10;
+	head.fmh_keys[1].fmr_physical = 30;
+	head.fmh_keys[1].fmr_owner = 0;
+	KUNIT_EXPECT_EQ(test, ext4_getfsmap(ctx->sb, &head,
+					    fsmap_collect_cb, sink), -EINVAL);
+
+	/* Low key starting past eofs returns 0 entries cleanly */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = datadev;
+	head.fmh_keys[1].fmr_device = datadev;
+	head.fmh_keys[0].fmr_physical = 500;
+	head.fmh_keys[1].fmr_physical = 600;
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, head.fmh_entries, 0U);
+	KUNIT_EXPECT_EQ(test, head.fmh_oflags, (u32)FMH_OF_DEV_T);
+
+	/* Missing group descriptor returns -EFSCORRUPTED */
+	ctx->gdb_bh_arr[0] = NULL;
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	set_bit(EXT4_FLAGS_SHUTDOWN, &ctx->sbi.s_ext4_flags);
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	clear_bit(EXT4_FLAGS_SHUTDOWN, &ctx->sbi.s_ext4_flags);
+	ctx->gdb_bh_arr[0] = &ctx->gdb_bh;
+	KUNIT_EXPECT_EQ(test, err, -EFSCORRUPTED);
+}
+
+/*
+ * Verify synthesis of fixed per-group metadata (SB, GDT, reserved GDT, block
+ * bitmap, inode bitmap, inode table), free extents, and EXT4_FMR_OWN_UNKNOWN
+ * gaps both in the middle and at the very end of the filesystem.
+ */
+static void test_getfsmap_fixed_metadata_and_unknown_gaps(struct kunit *test)
+{
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap_head head;
+	struct fsmap_rec_sink *sink;
+	u32 datadev = new_encode_dev(FSMAP_TEST_DATADEV);
+	int err;
+
+	sink = kunit_kzalloc(test, sizeof(*sink), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sink);
+	ctx = fsmap_create_ctx(test, 12, 0, 1, 256);
+	ctx->es.s_reserved_gdt_blocks = cpu_to_le16(2);
+
+	/*
+	 * Group 0 layout [0, 256):
+	 *   0      : superblock (OWN_FS, len 1)
+	 *   1      : GDT (OWN_GDT, len 1)
+	 *   2..3   : reserved GDT (OWN_RESV_GDT, len 2)
+	 *   4      : block bitmap (OWN_BLKBM, len 1)
+	 *   5      : inode bitmap (OWN_INOBM, len 1)
+	 *   6..13  : inode table (OWN_INODES, len 8)
+	 *   14..19 : allocated user data (OWN_UNKNOWN, len 6)
+	 *   20..99 : free space (OWN_FREE, len 80)
+	 *   100..109: allocated user data (OWN_UNKNOWN, len 10)
+	 *   110..249: free space (OWN_FREE, len 140)
+	 *   250..255: allocated user data at EOFS (OWN_UNKNOWN, len 6)
+	 */
+	fsmap_set_group_tables(ctx, 0, 4, 5, 6);
+	fsmap_mark_clusters_used(ctx, 0, 0, 20);
+	fsmap_mark_clusters_used(ctx, 0, 100, 10);
+	fsmap_mark_clusters_used(ctx, 0, 250, 6);
+
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_ASSERT_EQ(test, head.fmh_entries, 11U);
+	KUNIT_ASSERT_EQ(test, sink->count, 11U);
+
+	fsmap_expect_rec(test, &sink->recs[0], datadev, 0, 1, EXT4_FMR_OWN_FS);
+	fsmap_expect_rec(test, &sink->recs[1], datadev, 1, 1, EXT4_FMR_OWN_GDT);
+	fsmap_expect_rec(test, &sink->recs[2], datadev, 2, 2,
+			 EXT4_FMR_OWN_RESV_GDT);
+	fsmap_expect_rec(test, &sink->recs[3], datadev, 4, 1,
+			 EXT4_FMR_OWN_BLKBM);
+	fsmap_expect_rec(test, &sink->recs[4], datadev, 5, 1,
+			 EXT4_FMR_OWN_INOBM);
+	fsmap_expect_rec(test, &sink->recs[5], datadev, 6, 8,
+			 EXT4_FMR_OWN_INODES);
+	fsmap_expect_rec(test, &sink->recs[6], datadev, 14, 6,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[7], datadev, 20, 80,
+			 EXT4_FMR_OWN_FREE);
+	fsmap_expect_rec(test, &sink->recs[8], datadev, 100, 10,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[9], datadev, 110, 140,
+			 EXT4_FMR_OWN_FREE);
+	fsmap_expect_rec(test, &sink->recs[10], datadev, 250, 6,
+			 EXT4_FMR_OWN_UNKNOWN);
+}
+
+/*
+ * Verify flex_bg adjacent fixed-metadata merging via
+ * ext4_getfsmap_merge_fixed_metadata() and cross-group free-extent coalescing
+ * via info->gfi_lastfree.
+ */
+static void test_getfsmap_cross_group_free_and_fixed_meta_coalescing(
+							struct kunit *test)
+{
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap_head head;
+	struct fsmap_rec_sink *sink;
+	u32 datadev = new_encode_dev(FSMAP_TEST_DATADEV);
+	int err;
+
+	sink = kunit_kzalloc(test, sizeof(*sink), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sink);
+	ctx = fsmap_create_ctx(test, 12, 0, 2, 256);
+	/* SPARSE_SUPER2 with 0 backup groups -> group 1 has no SB/GDT */
+	ctx->es.s_feature_compat = cpu_to_le32(EXT4_FEATURE_COMPAT_SPARSE_SUPER2);
+
+	/*
+	 * Flex_bg-packed metadata in group 0 for both groups 0 and 1:
+	 *   0      : SB (len 1)
+	 *   1      : GDT (len 1)
+	 *   2..3   : group 0 + group 1 block bitmaps -> merged len 2!
+	 *   4..5   : group 0 + group 1 inode bitmaps -> merged len 2!
+	 *   6..21  : group 0 + group 1 inode tables (8 + 8) -> merged len 16!
+	 *   22..255 (grp 0) + 256..511 (grp 1): contiguous free space across
+	 *   group boundary -> coalesced via gfi_lastfree into [22, 512) len 490!
+	 */
+	fsmap_set_group_tables(ctx, 0, 2, 4, 6);
+	fsmap_set_group_tables(ctx, 1, 3, 5, 14);
+	fsmap_mark_clusters_used(ctx, 0, 0, 22);
+
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, head.fmh_entries, 6U);
+
+	fsmap_expect_rec(test, &sink->recs[0], datadev, 0, 1, EXT4_FMR_OWN_FS);
+	fsmap_expect_rec(test, &sink->recs[1], datadev, 1, 1, EXT4_FMR_OWN_GDT);
+	fsmap_expect_rec(test, &sink->recs[2], datadev, 2, 2,
+			 EXT4_FMR_OWN_BLKBM);
+	fsmap_expect_rec(test, &sink->recs[3], datadev, 4, 2,
+			 EXT4_FMR_OWN_INOBM);
+	fsmap_expect_rec(test, &sink->recs[4], datadev, 6, 16,
+			 EXT4_FMR_OWN_INODES);
+	fsmap_expect_rec(test, &sink->recs[5], datadev, 22, 490,
+			 EXT4_FMR_OWN_FREE);
+}
+
+/*
+ * Verify 1K blocksize (s_first_data_block == 1), bigalloc cluster-to-block
+ * scaling, and META_BG suppression of reserved GDT blocks.
+ */
+static void test_getfsmap_1k_bofs_bigalloc_and_meta_bg(struct kunit *test)
+{
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap_head head;
+	struct fsmap_rec_sink *sink;
+	u32 datadev = new_encode_dev(FSMAP_TEST_DATADEV);
+	int err;
+
+	sink = kunit_kzalloc(test, sizeof(*sink), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sink);
+
+	/*
+	 * 1K blocks (s_first_data_block = 1), cluster_bits = 2 (4 blks/clu),
+	 * 1 group of 256 blocks (64 clusters) covering fsblks [1, 257).
+	 * Enable META_BG with s_first_meta_bg = 0 and verify s_reserved_gdt_blocks
+	 * is ignored.
+	 */
+	ctx = fsmap_create_ctx(test, 10, 2, 1, 256);
+	ext4_set_feature_meta_bg(ctx->sb);
+	ext4_set_feature_bigalloc(ctx->sb);
+	ctx->es.s_first_meta_bg = 0;
+	ctx->es.s_reserved_gdt_blocks = cpu_to_le16(5);
+
+	/*
+	 * Cluster 0 = fsblks [1, 5): SB(1), GDT(2), BLKBM(3), INOBM(4)
+	 * Clusters 1..2 = fsblks [5, 13): INODES (len 8)
+	 * Clusters 3..4 = fsblks [13, 21): allocated data (OWN_UNKNOWN, len 8)
+	 * Clusters 5..63 = fsblks [21, 257): free (OWN_FREE, len 236)
+	 */
+	fsmap_set_group_tables(ctx, 0, 3, 4, 5);
+	fsmap_mark_clusters_used(ctx, 0, 0, 5);
+
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	/* Note: block 0 before s_first_data_block=1 is reported as gap [0, 1) */
+	KUNIT_ASSERT_EQ(test, head.fmh_entries, 8U);
+
+	fsmap_expect_rec(test, &sink->recs[0], datadev, 0, 1,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[1], datadev, 1, 1, EXT4_FMR_OWN_FS);
+	fsmap_expect_rec(test, &sink->recs[2], datadev, 2, 1, EXT4_FMR_OWN_GDT);
+	fsmap_expect_rec(test, &sink->recs[3], datadev, 3, 1,
+			 EXT4_FMR_OWN_BLKBM);
+	fsmap_expect_rec(test, &sink->recs[4], datadev, 4, 1,
+			 EXT4_FMR_OWN_INOBM);
+	fsmap_expect_rec(test, &sink->recs[5], datadev, 5, 8,
+			 EXT4_FMR_OWN_INODES);
+	fsmap_expect_rec(test, &sink->recs[6], datadev, 13, 8,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[7], datadev, 21, 236,
+			 EXT4_FMR_OWN_FREE);
+}
+
+/*
+ * Verify count-only queries (fmh_count == 0), bounded pagination with
+ * continuation keys (non-zero low fmr_length), and formatter abort propagation.
+ */
+static void test_getfsmap_count_only_pagination_and_abort(struct kunit *test)
+{
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap_head head;
+	struct fsmap_rec_sink *full, *page, *cb_abort;
+	unsigned int collected = 0;
+	int err;
+
+	full = kunit_kzalloc(test, sizeof(*full), GFP_KERNEL);
+	page = kunit_kzalloc(test, sizeof(*page), GFP_KERNEL);
+	cb_abort = kunit_kzalloc(test, sizeof(*cb_abort), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, full);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_NOT_NULL(test, cb_abort);
+
+	ctx = fsmap_create_ctx(test, 12, 0, 1, 256);
+	fsmap_set_group_tables(ctx, 0, 2, 3, 4);
+	fsmap_mark_clusters_used(ctx, 0, 0, 16);
+
+	/* Reference full run: SB(0), GDT(1), BLKBM(2), INOBM(3), INODES(4..11),
+	 * UNKNOWN(12..15), FREE(16..255) -> 7 records.
+	 */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, full);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_ASSERT_EQ(test, full->count, 7U);
+
+	/* 1. Count-only mode (fmh_count == 0) does not invoke formatter */
+	fsmap_init_full_range_head(&head, 0);
+	err = ext4_getfsmap(ctx->sb, &head, NULL, NULL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, head.fmh_entries, 7U);
+
+	/* 2. Paginate 2 records at a time using last record as low key */
+	fsmap_init_full_range_head(&head, 2);
+	while (true) {
+		unsigned int prev_count = page->count;
+
+		err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, page);
+		collected += head.fmh_entries;
+		if (err == 0)
+			break;
+		KUNIT_ASSERT_EQ(test, err, EXT4_QUERY_RANGE_ABORT);
+		KUNIT_ASSERT_EQ(test, head.fmh_entries, 2U);
+		KUNIT_ASSERT_GT(test, page->count, prev_count);
+		head.fmh_keys[0] = page->recs[page->count - 1];
+	}
+	KUNIT_ASSERT_EQ(test, collected, 7U);
+	KUNIT_ASSERT_EQ(test, page->count, 7U);
+	for (unsigned int i = 0; i < 7; i++) {
+		KUNIT_EXPECT_EQ(test, page->recs[i].fmr_physical,
+				full->recs[i].fmr_physical);
+		KUNIT_EXPECT_EQ(test, page->recs[i].fmr_length,
+				full->recs[i].fmr_length);
+		KUNIT_EXPECT_EQ(test, page->recs[i].fmr_owner,
+				full->recs[i].fmr_owner);
+	}
+
+	/* 3. Formatter-initiated abort stops immediately */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	cb_abort->abort_after = 3;
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, cb_abort);
+	KUNIT_EXPECT_EQ(test, err, EXT4_QUERY_RANGE_ABORT);
+	KUNIT_EXPECT_EQ(test, cb_abort->count, 3U);
+}
+
+/*
+ * Verify external journal device reporting (EXT4_FMR_OWN_LOG and leading gap)
+ * across multi-device wildcard queries and log-device-targeted queries.
+ */
+static void test_getfsmap_external_logdev_and_multi_device(struct kunit *test)
+{
+	struct fsmap_test_ctx *ctx;
+	struct ext4_fsmap_head head;
+	struct fsmap_rec_sink *sink;
+	u32 datadev = new_encode_dev(FSMAP_TEST_DATADEV);
+	u32 logdev = new_encode_dev(FSMAP_TEST_LOGDEV);
+	int err;
+
+	sink = kunit_kzalloc(test, sizeof(*sink), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, sink);
+	ctx = fsmap_create_ctx(test, 12, 0, 1, 128);
+	fsmap_set_group_tables(ctx, 0, 2, 3, 4);
+	fsmap_mark_clusters_used(ctx, 0, 0, 12);
+
+	KUNIT_ASSERT_PTR_EQ(test, file_bdev(&ctx->log_bdev_file),
+			    &ctx->log_bdev.bdev);
+	ctx->mock_journal.j_blk_offset = 16;
+	ctx->mock_journal.j_total_len = 64;
+	ctx->sbi.s_journal = &ctx->mock_journal;
+	ctx->sbi.s_journal_bdev_file = &ctx->log_bdev_file;
+
+	/* Multi-device query [0, UINT_MAX] emits datadev (6 recs) + logdev (2) */
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_ASSERT_EQ(test, head.fmh_entries, 8U);
+	KUNIT_EXPECT_EQ(test, (u32)sink->recs[0].fmr_device, datadev);
+	fsmap_expect_rec(test, &sink->recs[6], logdev, 0, 16,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[7], logdev, 16, 64,
+			 EXT4_FMR_OWN_LOG);
+
+	/* Targeted query against only logdev starting at 0 */
+	memset(sink, 0, sizeof(*sink));
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = logdev;
+	head.fmh_keys[1].fmr_device = logdev;
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_ASSERT_EQ(test, head.fmh_entries, 2U);
+	fsmap_expect_rec(test, &sink->recs[0], logdev, 0, 16,
+			 EXT4_FMR_OWN_UNKNOWN);
+	fsmap_expect_rec(test, &sink->recs[1], logdev, 16, 64,
+			 EXT4_FMR_OWN_LOG);
+
+	/* Logdev query with physical > 0 returns 0 entries */
+	memset(sink, 0, sizeof(*sink));
+	fsmap_init_full_range_head(&head, FSMAP_TEST_MAX_RECS);
+	head.fmh_keys[0].fmr_device = logdev;
+	head.fmh_keys[0].fmr_physical = 80;
+	head.fmh_keys[1].fmr_device = logdev;
+	err = ext4_getfsmap(ctx->sb, &head, fsmap_collect_cb, sink);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, head.fmh_entries, 0U);
+}
+
+static struct kunit_case fsmap_test_cases[] = {
+	KUNIT_CASE(test_fsmap_unit_conversions),
+	KUNIT_CASE(test_getfsmap_invalid_flags_devices_and_keys),
+	KUNIT_CASE(test_getfsmap_fixed_metadata_and_unknown_gaps),
+	KUNIT_CASE(test_getfsmap_cross_group_free_and_fixed_meta_coalescing),
+	KUNIT_CASE(test_getfsmap_1k_bofs_bigalloc_and_meta_bg),
+	KUNIT_CASE(test_getfsmap_count_only_pagination_and_abort),
+	KUNIT_CASE(test_getfsmap_external_logdev_and_multi_device),
+	{}
+};
+
+static struct kunit_suite fsmap_test_suite = {
+	.name = "ext4_fsmap_test",
+	.test_cases = fsmap_test_cases,
+};
+
+kunit_test_suites(&fsmap_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for ext4 FS_IOC_GETFSMAP implementation");
+MODULE_LICENSE("GPL");
diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index 8b1138d2dc8e..f41c2298d196 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -26,6 +26,7 @@ void ext4_fsmap_from_internal(struct super_block *sb, struct fsmap *dest,
 	dest->fmr_reserved[1] = 0;
 	dest->fmr_reserved[2] = 0;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fsmap_from_internal);
 
 /* Convert an fsmap to an ext4_fsmap. */
 void ext4_fsmap_to_internal(struct super_block *sb, struct ext4_fsmap *dest,
@@ -37,6 +38,7 @@ void ext4_fsmap_to_internal(struct super_block *sb, struct ext4_fsmap *dest,
 	dest->fmr_owner = src->fmr_owner;
 	dest->fmr_length = src->fmr_length >> sb->s_blocksize_bits;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fsmap_to_internal);
 
 /* getfsmap query state */
 struct ext4_getfsmap_info {
@@ -790,3 +792,4 @@ int ext4_getfsmap(struct super_block *sb, struct ext4_fsmap_head *head,
 	head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_getfsmap);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3f06b0996063..3d3512ede16f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -7151,6 +7151,9 @@ ext4_mballoc_query_range(
 	struct ext4_buddy		e4b;
 	int				error;
 
+	KUNIT_STATIC_STUB_REDIRECT(ext4_mballoc_query_range, sb, group, first,
+				   end, meta_formatter, formatter, priv);
+
 	error = ext4_mb_load_buddy(sb, group, &e4b);
 	if (error)
 		return error;
-- 
2.56.0.542.g3ef89b7020-goog

