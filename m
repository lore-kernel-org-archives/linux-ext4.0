Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456426;
	b=N6Qu2rRoGJJXhhJKfmGTt8o79L4Dc7mPhnUvYsUoHYG3iNRCh0t9JdpqbOBLEuuT5jV7
	 362h+o4aXJe6WhNZmiB96Qq+dAoAXJQXtiqyaJK1+Tez8kuAUPwM01ZCfqmk+EFnFv5dy
	 vzVEOaKYu/7t/TfnL7hjVFLGzQoMkjF4If47GNEdDja62q3vwdEpaxblbsS3+X0eWVeJl
	 oaEKavnfh97n0VoBWxes0AlsUjpn/X/Xw+sNYte6iHhzHIT1Zacl9vEGa5UYDzUPOlJeJ
	 qRxFe/iS/qIxoMNiW0nQt6uZy6XLBLlAOYpiMahnnWHJvlc6NzW8Wr3lxQsU2iUAyRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456426;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tdrUfipeTOilPHzahs8unqGmeFivi2RYlFXNC7olLNM=;
	b=ZkoBoZVHXuqbEqt93oqGAgroaluZ5r7P0FdGkrL81auiX+A6mJym3Xa8Uk6Y+YsfjltE
	 EKBYQ4yrjHOS7T+eify0z9n8XB/gL6p+NfdOnLITJW2Sd6dipUSnhpuELdm4COGQOhays
	 9/ddfy28q7e/skjHnvFp2x2t1Sg9mLjA1Jmh3cB4jKXRyODPc36vfIJib0GHo4Ebrcyh2
	 i8OuPnEwPX7KWQA0SX+Zem/LjIs8mr0MJB6i2MbFHVqz1vTAeIGqjy2Jx/k2KOd4FeNDH
	 2TihMNP/kmyTOO200Li5KceGiB+WE4aS75X7cC1c5QMiSOj+9Iff6EkCUiFZ/JOL0ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="lsm/+uN2";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91147606A894
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91147606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=lsm/+uN2
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46suB016945
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456416; bh=tdrUfipeTOilPHzahs8unqGmeFivi2RYlFXNC7olLNM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=lsm/+uN25IOzMu1a9M7enijQnOfmMyNvJ+YWVZHCatQTcRDkO2VfmYzZF5gb/4Yb+
	 YD1JIJc+AQE4jUfuGArItjDgTEji1JshN6bnVAdi/TNgr0kcgUDL1vF6KMwnhh388R
	 OzFdzTaxX20TgZ6fNN/TuqCwCH//r5MuLwdX5a1XxSCTQrgQouK2+CYB59XZNUYjKO
	 +FIXkU80QZy+GEYVabk9c3LM5GZfzyVDhQB0Rr6DtZV4G1HuROrF6NLUfI+JplUBKl
	 3vudwK3GMXgIFWfObbvhviylA3oC+qshlYKpeEt/T0ZEEqcYcQpTVNEN5INi36kxrv
	 HsT+qiRF07YIA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 9AC7B2E015F; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 26/27] ext4: add KUnit tests for fs/ext4/mmp.c
Date: Wed, 11 Nov 2026 23:06:37 -0500
Message-ID: <20261112040638.1576836-27-tytso@mit.edu>
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

Add a KUnit test suite (ext4_mmp_test) covering multi-mount protection
checksums, block I/O validation, and mount state transitions in
fs/ext4/mmp.c:

- CRC32C generation and verification in ext4_mmp_csum_set() and
  ext4_mmp_csum_verify() with and without METADATA_CSUM
- Block read/write error handling, magic validation (-EFSCORRUPTED),
  CRC mismatch handling (-EFSBADCRC), and buffer cleanup in
  read_mmp_block() and write_mmp_block()
- ext4_multi_mount_protect() validation of out-of-range MMP blocks,
  EXT4_MMP_SEQ_FSCK rejection (-EBUSY), EXT4_MMP_SEQ_CLEAN claim and
  ext4_stop_mmpd() teardown, active/racing node sequence conflicts,
  check_interval clamping, interrupted waits (-ETIMEDOUT), and kthread
  startup failure

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Makefile   |   2 +-
 fs/ext4/ext4.h     |  20 +-
 fs/ext4/mmp-test.c | 661 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/mmp.c      | 117 ++++++--
 4 files changed, 770 insertions(+), 30 deletions(-)
 create mode 100644 fs/ext4/mmp-test.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 5cf735df7656..cb0d7b6edf6d 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -24,7 +24,7 @@ ext4-test-objs				+= inode-test.o mballoc-test.o \
 					   sysfs-test.o ioctl-test.o \
 					   resize-test.o migrate-test.o \
 					   indirect-test.o fsmap-test.o \
-					   move_extent-test.o
+					   move_extent-test.o mmp-test.o
 obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
 ext4-$(CONFIG_FS_ENCRYPTION)		+= crypto.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8bc7269af580..aaf4722e709e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4207,9 +4207,25 @@ extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
 
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
-
-/* mmp.c */
 extern void ext4_stop_mmpd(struct ext4_sb_info *sbi);
+extern int ext4_mmp_submit_write(struct buffer_head *bh);
+extern int ext4_mmp_load_bh(struct super_block *sb, struct buffer_head **bh,
+			    ext4_fsblk_t mmp_block);
+extern long ext4_mmp_wait_timeout(long timeout);
+extern struct task_struct *ext4_mmp_run_thread(struct super_block *sb,
+					       const char *bdevname,
+					       int bdevname_len);
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+extern int ext4_mmp_csum_verify_test(struct super_block *sb,
+				     struct mmp_struct *mmp);
+extern void ext4_mmp_csum_set_test(struct super_block *sb,
+				   struct mmp_struct *mmp);
+extern int ext4_read_mmp_block_test(struct super_block *sb,
+				    struct buffer_head **bh,
+				    ext4_fsblk_t mmp_block);
+extern int ext4_write_mmp_block_test(struct super_block *sb,
+				     struct buffer_head *bh);
+#endif
 
 /* verity.c */
 extern const struct fsverity_operations ext4_verityops;
diff --git a/fs/ext4/mmp-test.c b/fs/ext4/mmp-test.c
new file mode 100644
index 000000000000..008857631394
--- /dev/null
+++ b/fs/ext4/mmp-test.c
@@ -0,0 +1,661 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for fs/ext4/mmp.c
+ */
+
+#include <kunit/static_stub.h>
+#include <kunit/test.h>
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/fs.h>
+#include <linux/fs_context.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/part_stat.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+
+#include "ext4.h"
+
+#define MMP_TEST_BLK_SIZE	4096U
+#define MMP_TEST_BLK_BITS	12U
+#define MMP_TEST_FIRST_DATA_BLK	1ULL
+#define MMP_TEST_TOTAL_BLKS	1024ULL
+#define MMP_TEST_VALID_BLK	10ULL
+#define MMP_MAX_WAITS		8U
+
+struct mmp_test_ctx {
+	struct super_block *sb;
+	struct ext4_sb_info sbi;
+	struct ext4_super_block *es;
+	struct gendisk bdev_disk;
+	struct block_device bdev;
+	struct request_queue bdev_queue;
+	struct address_space bdev_mapping;
+	struct buffer_head sbh;
+	u8 sbh_data[MMP_TEST_BLK_SIZE];
+
+	/* Simulated on-disk MMP block and in-memory buffer_head */
+	u8 disk_buf[MMP_TEST_BLK_SIZE];
+	struct buffer_head mmp_bh;
+	u8 bh_buf[MMP_TEST_BLK_SIZE];
+
+	/* Deterministic I/O, sleep, and kthread fault injection */
+	int load_nomem;
+	int load_err_on_call;
+	unsigned int load_calls;
+	ext4_fsblk_t last_load_blk;
+
+	int write_err_on_call;
+	unsigned int write_calls;
+
+	unsigned int wait_calls;
+	long wait_timeouts[MMP_MAX_WAITS];
+	long wait_ret_on_call;
+	unsigned int wait_ret_target_call;
+	unsigned int mutate_seq_on_wait_call;
+	u32 mutated_seq;
+
+	int run_thread_err;
+	unsigned int run_thread_calls;
+};
+
+static struct kunit *active_mmp_test;
+
+static void mmp_noop_work(struct work_struct *work)
+{
+}
+
+static void mmp_noop_timer(struct timer_list *t)
+{
+}
+
+static const struct super_operations mmp_test_sops = {};
+
+static int mmp_init_fs_context(struct fs_context *fc)
+{
+	return 0;
+}
+
+static int mmp_set_super(struct super_block *sb, struct fs_context *fc)
+{
+	return set_anon_super_fc(sb, fc);
+}
+
+static struct file_system_type mmp_test_fs_type = {
+	.name			= "ext4_mmp_test",
+	.init_fs_context	= mmp_init_fs_context,
+	.kill_sb		= kill_anon_super,
+};
+
+static int mmp_dummy_kthread_fn(void *data)
+{
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!kthread_should_stop())
+			schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+static int mmp_submit_write_stub(struct buffer_head *bh)
+{
+	struct kunit *test = active_mmp_test;
+	struct mmp_test_ctx *ctx;
+
+	if (!test)
+		return -EIO;
+	ctx = test->priv;
+	ctx->write_calls++;
+	if (ctx->write_err_on_call &&
+	    ctx->write_calls == (unsigned int)ctx->write_err_on_call) {
+		clear_buffer_uptodate(bh);
+		return -EIO;
+	}
+
+	memcpy(ctx->disk_buf, bh->b_data, MMP_TEST_BLK_SIZE);
+	set_buffer_uptodate(bh);
+	return 0;
+}
+
+static int mmp_load_bh_stub(struct super_block *sb, struct buffer_head **bh,
+			    ext4_fsblk_t mmp_block)
+{
+	struct kunit *test = active_mmp_test;
+	struct mmp_test_ctx *ctx;
+
+	if (!test)
+		return -EIO;
+	ctx = test->priv;
+	ctx->load_calls++;
+	ctx->last_load_blk = mmp_block;
+
+	if (ctx->load_nomem && !*bh)
+		return -ENOMEM;
+
+	if (!*bh) {
+		*bh = &ctx->mmp_bh;
+		get_bh(*bh);
+	}
+
+	if (ctx->load_err_on_call &&
+	    ctx->load_calls == (unsigned int)ctx->load_err_on_call)
+		return -EIO;
+
+	memcpy((*bh)->b_data, ctx->disk_buf, MMP_TEST_BLK_SIZE);
+	set_buffer_uptodate(*bh);
+	return 0;
+}
+
+static long mmp_wait_timeout_stub(long timeout)
+{
+	struct kunit *test = active_mmp_test;
+	struct mmp_test_ctx *ctx;
+
+	if (!test)
+		return 1;
+	ctx = test->priv;
+	if (ctx->wait_calls < MMP_MAX_WAITS)
+		ctx->wait_timeouts[ctx->wait_calls] = timeout;
+	ctx->wait_calls++;
+
+	if (ctx->mutate_seq_on_wait_call &&
+	    ctx->wait_calls == ctx->mutate_seq_on_wait_call) {
+		struct mmp_struct *disk_mmp = (struct mmp_struct *)ctx->disk_buf;
+
+		disk_mmp->mmp_seq = cpu_to_le32(ctx->mutated_seq);
+		strscpy(disk_mmp->mmp_nodename, "other-node",
+			sizeof(disk_mmp->mmp_nodename));
+		ext4_mmp_csum_set_test(ctx->sb, disk_mmp);
+	}
+
+	if (ctx->wait_ret_target_call &&
+	    ctx->wait_calls == ctx->wait_ret_target_call)
+		return ctx->wait_ret_on_call;
+
+	return 0;
+}
+
+static struct task_struct *mmp_run_thread_stub(struct super_block *sb,
+					       const char *bdevname,
+					       int bdevname_len)
+{
+	struct kunit *test = active_mmp_test;
+	struct mmp_test_ctx *ctx;
+
+	if (!test)
+		return ERR_PTR(-EINVAL);
+	ctx = test->priv;
+	ctx->run_thread_calls++;
+	if (ctx->run_thread_err)
+		return ERR_PTR(ctx->run_thread_err);
+
+	return kthread_run(mmp_dummy_kthread_fn, NULL, "kunit-mmpd");
+}
+
+static void mmp_init_disk_block(struct mmp_test_ctx *ctx, u32 seq,
+				u16 check_interval)
+{
+	struct mmp_struct *mmp = (struct mmp_struct *)ctx->disk_buf;
+
+	memset(ctx->disk_buf, 0, sizeof(ctx->disk_buf));
+	mmp->mmp_magic = cpu_to_le32(EXT4_MMP_MAGIC);
+	mmp->mmp_seq = cpu_to_le32(seq);
+	mmp->mmp_time = cpu_to_le64(1700000000ULL);
+	strscpy(mmp->mmp_nodename, "init-node", sizeof(mmp->mmp_nodename));
+	strscpy(mmp->mmp_bdevname, "init-bdev", sizeof(mmp->mmp_bdevname));
+	mmp->mmp_check_interval = cpu_to_le16(check_interval);
+	ext4_mmp_csum_set_test(ctx->sb, mmp);
+}
+
+static void mmp_reset_counters(struct mmp_test_ctx *ctx)
+{
+	ctx->load_nomem = 0;
+	ctx->load_err_on_call = 0;
+	ctx->load_calls = 0;
+	ctx->last_load_blk = 0;
+	ctx->write_err_on_call = 0;
+	ctx->write_calls = 0;
+	ctx->wait_calls = 0;
+	memset(ctx->wait_timeouts, 0, sizeof(ctx->wait_timeouts));
+	ctx->wait_ret_on_call = 0;
+	ctx->wait_ret_target_call = 0;
+	ctx->mutate_seq_on_wait_call = 0;
+	ctx->mutated_seq = 0;
+	ctx->run_thread_err = 0;
+	ctx->run_thread_calls = 0;
+}
+
+static void mmp_cleanup_ctx(void *data)
+{
+	struct mmp_test_ctx *ctx = data;
+
+	active_mmp_test = NULL;
+
+	if (ctx->sbi.s_mmp_tsk)
+		ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
+
+	cancel_work_sync(&ctx->sbi.s_sb_upd_work);
+	timer_delete_sync(&ctx->sbi.s_err_report);
+
+	if (ctx->sb) {
+		ctx->sb->s_fs_info = NULL;
+		deactivate_super(ctx->sb);
+		ctx->sb = NULL;
+	}
+	if (ctx->bdev.bd_stats) {
+		free_percpu(ctx->bdev.bd_stats);
+		ctx->bdev.bd_stats = NULL;
+	}
+}
+
+static struct mmp_test_ctx *mmp_setup_ctx(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx;
+	struct fs_context *fc;
+	struct super_block *sb;
+	int err;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	ctx->es = kunit_kzalloc(test, sizeof(*ctx->es), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ctx->es);
+
+	fc = fs_context_for_mount(&mmp_test_fs_type, 0);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(fc));
+	sb = sget_fc(fc, NULL, mmp_set_super);
+	put_fs_context(fc);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(sb));
+	up_write(&sb->s_umount);
+	ctx->sb = sb;
+
+	INIT_WORK(&ctx->sbi.s_sb_upd_work, mmp_noop_work);
+	timer_setup(&ctx->sbi.s_err_report, mmp_noop_timer, 0);
+
+	err = kunit_add_action_or_reset(test, mmp_cleanup_ctx, ctx);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	ctx->bdev.bd_stats = alloc_percpu(struct disk_stats);
+	KUNIT_ASSERT_NOT_NULL(test, ctx->bdev.bd_stats);
+	strscpy(ctx->bdev_disk.disk_name, "mmp_bdev",
+		sizeof(ctx->bdev_disk.disk_name));
+	ctx->bdev_disk.queue = &ctx->bdev_queue;
+	ctx->bdev.bd_disk = &ctx->bdev_disk;
+	ctx->bdev.bd_queue = &ctx->bdev_queue;
+	ctx->bdev.bd_mapping = &ctx->bdev_mapping;
+
+	sb->s_bdev = &ctx->bdev;
+	sb->s_blocksize = MMP_TEST_BLK_SIZE;
+	sb->s_blocksize_bits = MMP_TEST_BLK_BITS;
+	sb->s_magic = EXT4_SUPER_MAGIC;
+	sb->s_op = &mmp_test_sops;
+	sb->s_fs_info = &ctx->sbi;
+	strscpy(sb->s_id, "ext4_mmp_kunit", sizeof(sb->s_id));
+
+	ctx->sbh.b_data = ctx->sbh_data;
+	ctx->sbh.b_size = MMP_TEST_BLK_SIZE;
+	ctx->sbh.b_bdev = &ctx->bdev;
+	atomic_set(&ctx->sbh.b_count, 2);
+	set_buffer_uptodate(&ctx->sbh);
+	clear_buffer_mapped(&ctx->sbh);
+
+	ctx->mmp_bh.b_data = ctx->bh_buf;
+	ctx->mmp_bh.b_size = MMP_TEST_BLK_SIZE;
+	ctx->mmp_bh.b_blocknr = MMP_TEST_VALID_BLK;
+	ctx->mmp_bh.b_bdev = &ctx->bdev;
+	atomic_set(&ctx->mmp_bh.b_count, 2);
+	set_buffer_mapped(&ctx->mmp_bh);
+
+	ctx->es->s_magic = cpu_to_le16(EXT4_SUPER_MAGIC);
+	ctx->es->s_first_data_block = cpu_to_le32(MMP_TEST_FIRST_DATA_BLK);
+	ctx->es->s_mmp_block = cpu_to_le64(MMP_TEST_VALID_BLK);
+	ctx->es->s_mmp_update_interval = cpu_to_le16(EXT4_MMP_MIN_CHECK_INTERVAL);
+	ctx->es->s_feature_incompat = cpu_to_le32(EXT4_FEATURE_INCOMPAT_MMP);
+	ctx->es->s_feature_ro_compat =
+		cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+	ext4_blocks_count_set(ctx->es, MMP_TEST_TOTAL_BLKS);
+
+	ctx->sbi.s_sb = sb;
+	ctx->sbi.s_es = ctx->es;
+	ctx->sbi.s_sbh = &ctx->sbh;
+	ctx->sbi.s_csum_seed = 0x9abcdef0U;
+	set_opt(sb, ERRORS_CONT);
+	spin_lock_init(&ctx->sbi.s_bdev_wb_lock);
+	spin_lock_init(&ctx->sbi.s_error_lock);
+	ratelimit_state_init(&ctx->sbi.s_err_ratelimit_state,
+			     DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
+	ratelimit_state_init(&ctx->sbi.s_warning_ratelimit_state,
+			     DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
+	ratelimit_state_init(&ctx->sbi.s_msg_ratelimit_state,
+			     DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
+
+	test->priv = ctx;
+	active_mmp_test = test;
+
+	kunit_activate_static_stub(test, ext4_mmp_submit_write,
+				   mmp_submit_write_stub);
+	kunit_activate_static_stub(test, ext4_mmp_load_bh,
+				   mmp_load_bh_stub);
+	kunit_activate_static_stub(test, ext4_mmp_wait_timeout,
+				   mmp_wait_timeout_stub);
+	kunit_activate_static_stub(test, ext4_mmp_run_thread,
+				   mmp_run_thread_stub);
+
+	return ctx;
+}
+
+static void test_mmp_csum_set_and_verify(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+	struct mmp_struct *mmp;
+	__le32 orig_csum;
+
+	mmp = kunit_kzalloc(test, sizeof(*mmp), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, mmp);
+
+	mmp->mmp_magic = cpu_to_le32(EXT4_MMP_MAGIC);
+	mmp->mmp_seq = cpu_to_le32(EXT4_MMP_SEQ_CLEAN);
+	strscpy(mmp->mmp_nodename, "node-a", sizeof(mmp->mmp_nodename));
+
+	/* Without METADATA_CSUM, set is a no-op and verify always returns 1 */
+	ext4_clear_feature_metadata_csum(ctx->sb);
+	mmp->mmp_checksum = cpu_to_le32(0xdeadbeefU);
+	ext4_mmp_csum_set_test(ctx->sb, mmp);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(mmp->mmp_checksum), 0xdeadbeefU);
+	KUNIT_EXPECT_EQ(test, ext4_mmp_csum_verify_test(ctx->sb, mmp), 1);
+
+	/* With METADATA_CSUM, set computes CRC32C and verify detects tampering */
+	ext4_set_feature_metadata_csum(ctx->sb);
+	mmp->mmp_checksum = 0;
+	ext4_mmp_csum_set_test(ctx->sb, mmp);
+	orig_csum = mmp->mmp_checksum;
+	KUNIT_EXPECT_NE(test, le32_to_cpu(orig_csum), 0U);
+	KUNIT_EXPECT_EQ(test, ext4_mmp_csum_verify_test(ctx->sb, mmp), 1);
+
+	/* Flipping payload field or csum seed invalidates verification */
+	mmp->mmp_seq = cpu_to_le32(7);
+	KUNIT_EXPECT_EQ(test, ext4_mmp_csum_verify_test(ctx->sb, mmp), 0);
+	mmp->mmp_seq = cpu_to_le32(EXT4_MMP_SEQ_CLEAN);
+	KUNIT_EXPECT_EQ(test, ext4_mmp_csum_verify_test(ctx->sb, mmp), 1);
+
+	ctx->sbi.s_csum_seed ^= 1U;
+	KUNIT_EXPECT_EQ(test, ext4_mmp_csum_verify_test(ctx->sb, mmp), 0);
+}
+
+static void test_read_and_write_mmp_block(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+	struct buffer_head *bh = NULL;
+	struct mmp_struct *mmp;
+	int base_ref;
+	int ret;
+
+	/* Write populates checksum and persists block into disk_buf */
+	mmp = (struct mmp_struct *)ctx->mmp_bh.b_data;
+	memset(ctx->mmp_bh.b_data, 0, MMP_TEST_BLK_SIZE);
+	mmp->mmp_magic = cpu_to_le32(EXT4_MMP_MAGIC);
+	mmp->mmp_seq = cpu_to_le32(19);
+	ret = ext4_write_mmp_block_test(ctx->sb, &ctx->mmp_bh);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx->write_calls, 1U);
+	KUNIT_EXPECT_EQ(test,
+			ext4_mmp_csum_verify_test(ctx->sb,
+				(struct mmp_struct *)ctx->disk_buf), 1);
+
+	/* Simulated write I/O error returns -EIO */
+	ctx->write_err_on_call = 2;
+	KUNIT_EXPECT_EQ(test, ext4_write_mmp_block_test(ctx->sb, &ctx->mmp_bh),
+			-EIO);
+	ctx->write_err_on_call = 0;
+
+	/* Valid read allocates/populates bh and verifies magic + checksum */
+	base_ref = atomic_read(&ctx->mmp_bh.b_count);
+	ret = ext4_read_mmp_block_test(ctx->sb, &bh, MMP_TEST_VALID_BLK);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_ASSERT_PTR_EQ(test, bh, &ctx->mmp_bh);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->mmp_bh.b_count), base_ref + 1);
+
+	/* Re-reading with existing bh refreshes contents without leaking ref */
+	((struct mmp_struct *)ctx->disk_buf)->mmp_seq = cpu_to_le32(23);
+	ext4_mmp_csum_set_test(ctx->sb, (struct mmp_struct *)ctx->disk_buf);
+	ret = ext4_read_mmp_block_test(ctx->sb, &bh, MMP_TEST_VALID_BLK);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test,
+			le32_to_cpu(((struct mmp_struct *)bh->b_data)->mmp_seq),
+			23U);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->mmp_bh.b_count), base_ref + 1);
+	brelse(bh);
+	bh = NULL;
+
+	/* -ENOMEM when bh allocation fails */
+	ctx->load_nomem = 1;
+	KUNIT_EXPECT_EQ(test,
+			ext4_read_mmp_block_test(ctx->sb, &bh,
+						 MMP_TEST_VALID_BLK),
+			-ENOMEM);
+	KUNIT_EXPECT_NULL(test, bh);
+	ctx->load_nomem = 0;
+
+	/* -EIO read failure releases bh and resets *bh to NULL */
+	mmp_reset_counters(ctx);
+	ctx->load_err_on_call = 1;
+	KUNIT_EXPECT_EQ(test,
+			ext4_read_mmp_block_test(ctx->sb, &bh,
+						 MMP_TEST_VALID_BLK),
+			-EIO);
+	KUNIT_EXPECT_NULL(test, bh);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->mmp_bh.b_count), base_ref);
+
+	/* Bad magic returns -EFSCORRUPTED and cleans up bh */
+	mmp_reset_counters(ctx);
+	((struct mmp_struct *)ctx->disk_buf)->mmp_magic = cpu_to_le32(0x1234U);
+	KUNIT_EXPECT_EQ(test,
+			ext4_read_mmp_block_test(ctx->sb, &bh,
+						 MMP_TEST_VALID_BLK),
+			-EFSCORRUPTED);
+	KUNIT_EXPECT_NULL(test, bh);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->mmp_bh.b_count), base_ref);
+
+	/* Bad checksum returns -EFSBADCRC and cleans up bh */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
+	((struct mmp_struct *)ctx->disk_buf)->mmp_checksum ^= cpu_to_le32(1U);
+	KUNIT_EXPECT_EQ(test,
+			ext4_read_mmp_block_test(ctx->sb, &bh,
+						 MMP_TEST_VALID_BLK),
+			-EFSBADCRC);
+	KUNIT_EXPECT_NULL(test, bh);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->mmp_bh.b_count), base_ref);
+}
+
+static void test_mmp_invalid_block_and_io_errors(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+
+	/* Block below s_first_data_block (1) or >= blocks_count (1024) */
+	KUNIT_EXPECT_EQ(test, ext4_multi_mount_protect(ctx->sb, 0), -EINVAL);
+	KUNIT_EXPECT_EQ(test,
+			ext4_multi_mount_protect(ctx->sb, MMP_TEST_TOTAL_BLKS),
+			-EINVAL);
+	KUNIT_EXPECT_EQ(test, ctx->load_calls, 0U);
+
+	/* Initial read failure propagates error */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
+	mmp_reset_counters(ctx);
+	ctx->load_err_on_call = 1;
+	KUNIT_EXPECT_EQ(test,
+			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
+			-EIO);
+
+	/* Write failure when claiming MMP block */
+	mmp_reset_counters(ctx);
+	ctx->write_err_on_call = 1;
+	KUNIT_EXPECT_EQ(test,
+			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
+			-EIO);
+
+	/* Post-write verification read failure */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
+	mmp_reset_counters(ctx);
+	ctx->load_err_on_call = 2;
+	KUNIT_EXPECT_EQ(test,
+			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
+			-EIO);
+}
+
+static void test_mmp_clean_and_fsck_sequences(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+	struct mmp_struct *disk_mmp = (struct mmp_struct *)ctx->disk_buf;
+	int base_ref;
+	int ret;
+
+	/* EXT4_MMP_SEQ_FSCK fails immediately with -EBUSY without sleeping */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_FSCK, 5);
+	mmp_reset_counters(ctx);
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_EXPECT_EQ(test, ret, -EBUSY);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->write_calls, 0U);
+
+	/*
+	 * EXT4_MMP_SEQ_CLEAN skips pre-claim wait, writes a valid sequence
+	 * <= EXT4_MMP_SEQ_MAX, starts kmmpd, and ext4_stop_mmpd() cleans up.
+	 */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
+	mmp_reset_counters(ctx);
+	base_ref = atomic_read(&ctx->mmp_bh.b_count);
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 1U);
+	KUNIT_EXPECT_EQ(test, ctx->write_calls, 1U);
+	KUNIT_EXPECT_EQ(test, ctx->run_thread_calls, 1U);
+	KUNIT_EXPECT_LE(test, le32_to_cpu(disk_mmp->mmp_seq), EXT4_MMP_SEQ_MAX);
+	KUNIT_EXPECT_NOT_NULL(test, ctx->sbi.s_mmp_tsk);
+	KUNIT_EXPECT_PTR_EQ(test, ctx->sbi.s_mmp_bh, &ctx->mmp_bh);
+	KUNIT_EXPECT_STREQ(test,
+			   ((struct mmp_struct *)ctx->mmp_bh.b_data)->mmp_bdevname,
+			   "mmp_bdev");
+
+	ext4_stop_mmpd(&ctx->sbi);
+	KUNIT_EXPECT_NULL(test, ctx->sbi.s_mmp_tsk);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->mmp_bh.b_count), base_ref);
+	ctx->sbi.s_mmp_bh = NULL;
+}
+
+static void test_mmp_active_seq_conflict_and_claim(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+	int ret;
+
+	/*
+	 * Case 1: Active sequence on disk; s_mmp_update_interval = 3 (floored
+	 * to 5), disk mmp_check_interval = 12 (overrides 5 -> wait_time = 25s).
+	 * Remote node updates mmp_seq during wait #1 -> fails with -EBUSY.
+	 */
+	ctx->es->s_mmp_update_interval = cpu_to_le16(3);
+	mmp_init_disk_block(ctx, 100, 12);
+	mmp_reset_counters(ctx);
+	ctx->mutate_seq_on_wait_call = 1;
+	ctx->mutated_seq = 101;
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_EXPECT_EQ(test, ret, -EBUSY);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 1U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(25 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->write_calls, 0U);
+
+	/*
+	 * Case 2: Stale sequence unchanged on wait #1, but racing mounter
+	 * overwrites mmp_seq during post-claim wait #2 -> fails with -EBUSY.
+	 */
+	mmp_init_disk_block(ctx, 100, 12);
+	mmp_reset_counters(ctx);
+	ctx->mutate_seq_on_wait_call = 2;
+	ctx->mutated_seq = 0x5555U;
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_EXPECT_EQ(test, ret, -EBUSY);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 2U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(25 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[1], (long)(25 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->write_calls, 1U);
+
+	/*
+	 * Case 3: Stale sequence with large check_interval = 80 (wait_time
+	 * capped to 80 + 60 = 140s via min(2*x+1, x+60)) succeeds cleanly.
+	 */
+	mmp_init_disk_block(ctx, 100, 80);
+	mmp_reset_counters(ctx);
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 2U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(140 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[1], (long)(140 * HZ));
+
+	ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
+}
+
+static void test_mmp_interrupted_waits_and_kthread_failure(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+
+	/* Signal interruption on pre-claim wait returns -ETIMEDOUT */
+	mmp_init_disk_block(ctx, 77, 5);
+	mmp_reset_counters(ctx);
+	ctx->wait_ret_target_call = 1;
+	ctx->wait_ret_on_call = 3 * HZ;
+	KUNIT_EXPECT_EQ(test,
+			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
+			-ETIMEDOUT);
+
+	/* Signal interruption on post-claim wait returns -ETIMEDOUT */
+	mmp_init_disk_block(ctx, 77, 5);
+	mmp_reset_counters(ctx);
+	ctx->wait_ret_target_call = 2;
+	ctx->wait_ret_on_call = 2 * HZ;
+	KUNIT_EXPECT_EQ(test,
+			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
+			-ETIMEDOUT);
+
+	/* kthread creation failure returns -ENOMEM and leaves s_mmp_tsk NULL */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
+	mmp_reset_counters(ctx);
+	ctx->run_thread_err = -ENOMEM;
+	KUNIT_EXPECT_EQ(test,
+			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
+			-ENOMEM);
+	KUNIT_EXPECT_NULL(test, ctx->sbi.s_mmp_tsk);
+	ctx->sbi.s_mmp_bh = NULL;
+}
+
+static struct kunit_case mmp_test_cases[] = {
+	KUNIT_CASE(test_mmp_csum_set_and_verify),
+	KUNIT_CASE(test_read_and_write_mmp_block),
+	KUNIT_CASE(test_mmp_invalid_block_and_io_errors),
+	KUNIT_CASE(test_mmp_clean_and_fsck_sequences),
+	KUNIT_CASE(test_mmp_active_seq_conflict_and_claim),
+	KUNIT_CASE(test_mmp_interrupted_waits_and_kthread_failure),
+	{}
+};
+
+static struct kunit_suite mmp_test_suite = {
+	.name = "ext4_mmp_test",
+	.test_cases = mmp_test_cases,
+};
+
+kunit_test_suites(&mmp_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for ext4 multi-mount protection (MMP)");
+MODULE_LICENSE("GPL");
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 7ce361484b38..025c9f332726 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <kunit/static_stub.h>
 #include <linux/fs.h>
 #include <linux/random.h>
 #include <linux/buffer_head.h>
@@ -35,6 +36,20 @@ static void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
 	mmp->mmp_checksum = ext4_mmp_csum(sb, mmp);
 }
 
+int ext4_mmp_submit_write(struct buffer_head *bh)
+{
+	KUNIT_STATIC_STUB_REDIRECT(ext4_mmp_submit_write, bh);
+
+	lock_buffer(bh);
+	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
+		  bh_end_write);
+	wait_on_buffer(bh);
+	if (unlikely(!buffer_uptodate(bh)))
+		return -EIO;
+	return 0;
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mmp_submit_write);
+
 /*
  * Write the MMP block using REQ_SYNC to try to get the block on-disk
  * faster.
@@ -45,13 +60,7 @@ static int write_mmp_block_thawed(struct super_block *sb,
 	struct mmp_struct *mmp = (struct mmp_struct *)(bh->b_data);
 
 	ext4_mmp_csum_set(sb, mmp);
-	lock_buffer(bh);
-	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
-			bh_end_write);
-	wait_on_buffer(bh);
-	if (unlikely(!buffer_uptodate(bh)))
-		return -EIO;
-	return 0;
+	return ext4_mmp_submit_write(bh);
 }
 
 static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
@@ -64,6 +73,35 @@ static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
 		return write_mmp_block_thawed(sb, bh);
 }
 
+int ext4_mmp_load_bh(struct super_block *sb, struct buffer_head **bh,
+		     ext4_fsblk_t mmp_block)
+{
+	KUNIT_STATIC_STUB_REDIRECT(ext4_mmp_load_bh, sb, bh, mmp_block);
+
+	/*
+	 * This would be sb_bread(sb, mmp_block), except we need to be sure
+	 * that the MD RAID device cache has been bypassed, and that the read
+	 * is not blocked in the elevator.
+	 */
+	if (!*bh) {
+		*bh = sb_getblk(sb, mmp_block);
+		if (!*bh)
+			return -ENOMEM;
+	}
+
+	lock_buffer(*bh);
+	return ext4_read_bh(*bh, REQ_META | REQ_PRIO, NULL, false);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mmp_load_bh);
+
+long ext4_mmp_wait_timeout(long timeout)
+{
+	KUNIT_STATIC_STUB_REDIRECT(ext4_mmp_wait_timeout, timeout);
+
+	return schedule_timeout_interruptible(timeout);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mmp_wait_timeout);
+
 /*
  * Read the MMP block. It _must_ be read from disk and hence we clear the
  * uptodate flag on the buffer.
@@ -77,19 +115,7 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	if (*bh)
 		clear_buffer_uptodate(*bh);
 
-	/* This would be sb_bread(sb, mmp_block), except we need to be sure
-	 * that the MD RAID device cache has been bypassed, and that the read
-	 * is not blocked in the elevator. */
-	if (!*bh) {
-		*bh = sb_getblk(sb, mmp_block);
-		if (!*bh) {
-			ret = -ENOMEM;
-			goto warn_exit;
-		}
-	}
-
-	lock_buffer(*bh);
-	ret = ext4_read_bh(*bh, REQ_META | REQ_PRIO, NULL, false);
+	ret = ext4_mmp_load_bh(sb, bh, mmp_block);
 	if (ret)
 		goto warn_exit;
 
@@ -185,8 +211,7 @@ static int kmmpd(void *data)
 
 		diff = jiffies - last_update_time;
 		if (diff < mmp_update_interval * HZ)
-			schedule_timeout_interruptible(mmp_update_interval *
-						       HZ - diff);
+			ext4_mmp_wait_timeout(mmp_update_interval * HZ - diff);
 
 		/*
 		 * We need to make sure that more than mmp_check_interval
@@ -250,6 +275,16 @@ static int kmmpd(void *data)
 	return retval;
 }
 
+struct task_struct *ext4_mmp_run_thread(struct super_block *sb,
+					const char *bdevname, int bdevname_len)
+{
+	KUNIT_STATIC_STUB_REDIRECT(ext4_mmp_run_thread, sb, bdevname,
+				   bdevname_len);
+
+	return kthread_run(kmmpd, sb, "kmmpd-%.*s", bdevname_len, bdevname);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mmp_run_thread);
+
 void ext4_stop_mmpd(struct ext4_sb_info *sbi)
 {
 	if (sbi->s_mmp_tsk) {
@@ -258,6 +293,7 @@ void ext4_stop_mmpd(struct ext4_sb_info *sbi)
 		sbi->s_mmp_tsk = NULL;
 	}
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_stop_mmpd);
 
 /*
  * Get a random new sequence number but make sure it is not greater than
@@ -323,7 +359,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 		ext4_warning(sb, "MMP interval %u higher than expected, please"
 			     " wait.\n", wait_time * 2);
 
-	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
+	if (ext4_mmp_wait_timeout(HZ * wait_time) != 0) {
 		ext4_warning(sb, "MMP startup interrupted, failing mount\n");
 		retval = -ETIMEDOUT;
 		goto failed;
@@ -358,7 +394,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	/*
 	 * wait for MMP interval and check mmp_seq.
 	 */
-	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
+	if (ext4_mmp_wait_timeout(HZ * wait_time) != 0) {
 		ext4_warning(sb, "MMP startup interrupted, failing mount");
 		retval = -ETIMEDOUT;
 		goto failed;
@@ -384,9 +420,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	/*
 	 * Start a kernel thread to update the MMP block periodically.
 	 */
-	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, sb, "kmmpd-%.*s",
-					     (int)sizeof(mmp->mmp_bdevname),
-					     mmp->mmp_bdevname);
+	EXT4_SB(sb)->s_mmp_tsk = ext4_mmp_run_thread(sb, mmp->mmp_bdevname,
+					     (int)sizeof(mmp->mmp_bdevname));
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
 		EXT4_SB(sb)->s_mmp_tsk = NULL;
 		ext4_warning(sb, "Unable to create kmmpd thread for %s.",
@@ -401,3 +436,31 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	brelse(bh);
 	return retval;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_multi_mount_protect);
+
+#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
+int ext4_mmp_csum_verify_test(struct super_block *sb, struct mmp_struct *mmp)
+{
+	return ext4_mmp_csum_verify(sb, mmp);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mmp_csum_verify_test);
+
+void ext4_mmp_csum_set_test(struct super_block *sb, struct mmp_struct *mmp)
+{
+	ext4_mmp_csum_set(sb, mmp);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mmp_csum_set_test);
+
+int ext4_read_mmp_block_test(struct super_block *sb, struct buffer_head **bh,
+			     ext4_fsblk_t mmp_block)
+{
+	return read_mmp_block(sb, bh, mmp_block);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_read_mmp_block_test);
+
+int ext4_write_mmp_block_test(struct super_block *sb, struct buffer_head *bh)
+{
+	return write_mmp_block(sb, bh);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_write_mmp_block_test);
+#endif
-- 
2.56.0.542.g3ef89b7020-goog

