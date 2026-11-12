Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458846;
	b=hXAouyBWCp3FC/OfVtMwVvZ+lM2y7WT4CRE/A0UcAhukJMlVAzfL58LzLtqviO6v0UxD
	 oxdTW2ksOO6K8PEBEc5ssvicUmjtf4xAuP5JiurTUEuycESLE0PQXADsCG/rz99rPaFWR
	 swZq7RxIAikBAR6GigeGn7dm/J7Rzz6yD1jbkdqgcPdUw2rqOih+naJU9Cq/pHG77iL7b
	 GKAOKR92YwKu+OkaosLY7Gl1ggWvAFyb92ctEYy+t4GxNChnm46Kb4lHd7Avwcf+J+G7l
	 LvhAhLcTWCw/rXL6ys9dG4HA+Jz00Ms4Wm+26HSqVqoq2OEyJRDZRYvARC65mO88hQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458846;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PK0ip+zTgebht41jD7/GC21WCEccymQfcBvhtoWh4Lg=;
	b=03OsD9CPA69MtG+J0K2xWOUnj4ry4qr3yW27/5GowXcFrlSftq8P3fxW3iOCqN7vXU6j
	 oYw7cjs+FyYYhFa+UquzlM88jtVvrfKakK4eFV8LurHTzucUKREmxw7HDyEAEAkbr6rDW
	 xUmut8MDXYNMYbHohsPKRHIgGfyLKjxMiGXFpLyyLAo6ptrobB9ybf0fBS4/sl9FAR+C8
	 87B+0eU9LdCXbLJVJTJObQyQCZclcbsHonFlkwjMQoyaIWzZm2EULyYBKjJ/BTW0vuJyz
	 kFS01j+fgxWftoxgs/yCMwX6/rUi92VUYQHxHS86pb1rKw9vE0JRLNXT9TubYABPV7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=J2KrsRKI;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E608160A263D
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E608160A263D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=J2KrsRKI
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lMOR031271
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458844; bh=PK0ip+zTgebht41jD7/GC21WCEccymQfcBvhtoWh4Lg=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=J2KrsRKIvDC34qpnGRtF5MhFIePFObqa56+ZNm2bgzq3k9im9rTXG5ViFYfIevoeN
	 pKnUDjO2QkztayqI+ARCzW/9FxQshfMrDXuIg0JRfMUZ3IW/qw+bewWjgIzWq2JQUE
	 j8DkRLfLFnvsZeXfHFY6sZfbcCTAbmZDoXPFDFNURtU6VWNeDM3CCCAe15/HQzambF
	 vnyw+P0QSMubGewR6ZX2AJBTZMElhBhoeD18wLMGsscfoe4j1I2tolN024Y17ogODN
	 AIcXFwLGIUs0U1kGqdSKpg1vsPVvh2L5/AIEvIV5lJnwjZyFLI9bvaHW7ySL0HHJzt
	 V3Oa2c4JI3T3g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5C50F2E0158; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 19/23] ext4: bound the MMP update and check intervals
Date: Wed, 11 Nov 2026 23:47:08 -0500
Message-ID: <20261112044712.1577296-20-tytso@mit.edu>
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

Neither kmmpd() nor ext4_multi_mount_protect() validate the
s_mmp_update_interval value from the superblock or the
mmp_check_interval value from the MMP block:

 - With s_mmp_update_interval == 0, the "diff < mmp_update_interval *
   HZ" test in kmmpd() is never true, so kmmpd never sleeps.  It
   rewrites the MMP block with REQ_SYNC | REQ_META | REQ_PRIO writes in
   a tight loop until the filesystem is unmounted.  e2fsprogs treats a
   zero interval as "use the default" (5 seconds), so such a value is
   not even necessarily the result of corruption.

 - Both fields are 16 bits wide and only have a lower bound applied at
   mount time.  A value of 65535 in either of them makes
   ext4_multi_mount_protect() sleep min(2 * 65535 + 1, 65535 + 60)
   seconds, i.e. more than 18 hours, up to twice, before mount(2)
   completes.  kmmpd() itself already caps the check interval it
   advertises to EXT4_MMP_MAX_CHECK_INTERVAL once it is running, and
   e2fsprogs refuses to set an update interval larger than 300 seconds.

Add a helper that returns s_mmp_update_interval with zero mapped to the
e2fsprogs default and larger values capped to the e2fsprogs maximum,
and use it in both kmmpd() and ext4_multi_mount_protect().  Also cap
the check interval used at mount time, and the initial one advertised
by kmmpd(), to EXT4_MMP_MAX_CHECK_INTERVAL, matching what kmmpd()
already does after its first update.  Since kmmpd now updates the MMP
block at least every EXT4_MMP_MAX_UPDATE_INTERVAL seconds, the
resulting maximum mount wait of 360 seconds is still long enough to
notice another node that is actively using the filesystem.

Add KUnit tests covering both the mount-time wait and, by running the
real kmmpd() in a thread with the I/O and sleep helpers stubbed out,
the kmmpd() update cadence.

Fixes: c5e06d101aaf ("ext4: add support for multiple mount protection")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h     |   8 +++
 fs/ext4/mmp-test.c | 170 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/mmp.c      |  31 +++++++--
 3 files changed, 205 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c7d64bb21c57..5d6d4876f487 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2866,6 +2866,13 @@ struct mmpd_data {
  */
 #define EXT4_MMP_MAX_CHECK_INTERVAL	300UL
 
+/*
+ * Default and maximum interval between MMP block updates in seconds, as
+ * used by e2fsprogs for s_mmp_update_interval.
+ */
+#define EXT4_MMP_UPDATE_INTERVAL	5UL
+#define EXT4_MMP_MAX_UPDATE_INTERVAL	300UL
+
 /*
  * Function prototypes
  */
@@ -4233,6 +4240,7 @@ extern int ext4_read_mmp_block_test(struct super_block *sb,
 				    ext4_fsblk_t mmp_block);
 extern int ext4_write_mmp_block_test(struct super_block *sb,
 				     struct buffer_head *bh);
+extern int ext4_kmmpd_test(void *data);
 #endif
 
 /* verity.c */
diff --git a/fs/ext4/mmp-test.c b/fs/ext4/mmp-test.c
index 008857631394..c36f625f88a5 100644
--- a/fs/ext4/mmp-test.c
+++ b/fs/ext4/mmp-test.c
@@ -7,6 +7,7 @@
 #include <kunit/test.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
 #include <linux/kthread.h>
@@ -62,6 +63,14 @@ struct mmp_test_ctx {
 
 	int run_thread_err;
 	unsigned int run_thread_calls;
+
+	/* Real kmmpd() run from the ext4_mmp_run_thread() stub */
+	bool run_kmmpd;
+	struct task_struct *kmmpd_thread;
+	unsigned int kmmpd_write_calls;
+	unsigned int kmmpd_wait_calls;
+	long kmmpd_wait_timeout;
+	u16 kmmpd_check_interval;
 };
 
 static struct kunit *active_mmp_test;
@@ -111,6 +120,20 @@ static int mmp_submit_write_stub(struct buffer_head *bh)
 	if (!test)
 		return -EIO;
 	ctx = test->priv;
+
+	if (current == READ_ONCE(ctx->kmmpd_thread)) {
+		struct mmp_struct *mmp = (struct mmp_struct *)bh->b_data;
+
+		if (!ctx->kmmpd_write_calls)
+			ctx->kmmpd_check_interval =
+				le16_to_cpu(mmp->mmp_check_interval);
+		WRITE_ONCE(ctx->kmmpd_write_calls, ctx->kmmpd_write_calls + 1);
+		/* Never let a misbehaving kmmpd monopolize the CPU */
+		schedule_timeout_interruptible(1);
+		set_buffer_uptodate(bh);
+		return 0;
+	}
+
 	ctx->write_calls++;
 	if (ctx->write_err_on_call &&
 	    ctx->write_calls == (unsigned int)ctx->write_err_on_call) {
@@ -160,6 +183,14 @@ static long mmp_wait_timeout_stub(long timeout)
 	if (!test)
 		return 1;
 	ctx = test->priv;
+
+	if (current == READ_ONCE(ctx->kmmpd_thread)) {
+		ctx->kmmpd_wait_timeout = timeout;
+		WRITE_ONCE(ctx->kmmpd_wait_calls, ctx->kmmpd_wait_calls + 1);
+		/* Really sleep; ext4_stop_mmpd() wakes us up */
+		return schedule_timeout_interruptible(timeout);
+	}
+
 	if (ctx->wait_calls < MMP_MAX_WAITS)
 		ctx->wait_timeouts[ctx->wait_calls] = timeout;
 	ctx->wait_calls++;
@@ -181,6 +212,17 @@ static long mmp_wait_timeout_stub(long timeout)
 	return 0;
 }
 
+static int mmp_kmmpd_thread_fn(void *data)
+{
+	struct kunit *test = active_mmp_test;
+	struct mmp_test_ctx *ctx = test->priv;
+
+	/* Let the static stubs redirect the calls made by kmmpd() too */
+	current->kunit_test = test;
+	WRITE_ONCE(ctx->kmmpd_thread, current);
+	return ext4_kmmpd_test(data);
+}
+
 static struct task_struct *mmp_run_thread_stub(struct super_block *sb,
 					       const char *bdevname,
 					       int bdevname_len)
@@ -194,6 +236,8 @@ static struct task_struct *mmp_run_thread_stub(struct super_block *sb,
 	ctx->run_thread_calls++;
 	if (ctx->run_thread_err)
 		return ERR_PTR(ctx->run_thread_err);
+	if (ctx->run_kmmpd)
+		return kthread_run(mmp_kmmpd_thread_fn, sb, "kunit-kmmpd");
 
 	return kthread_run(mmp_dummy_kthread_fn, NULL, "kunit-mmpd");
 }
@@ -229,6 +273,12 @@ static void mmp_reset_counters(struct mmp_test_ctx *ctx)
 	ctx->mutated_seq = 0;
 	ctx->run_thread_err = 0;
 	ctx->run_thread_calls = 0;
+	ctx->run_kmmpd = false;
+	ctx->kmmpd_thread = NULL;
+	ctx->kmmpd_write_calls = 0;
+	ctx->kmmpd_wait_calls = 0;
+	ctx->kmmpd_wait_timeout = 0;
+	ctx->kmmpd_check_interval = 0;
 }
 
 static void mmp_cleanup_ctx(void *data)
@@ -640,6 +690,124 @@ static void test_mmp_interrupted_waits_and_kthread_failure(struct kunit *test)
 	ctx->sbi.s_mmp_bh = NULL;
 }
 
+static void test_mmp_update_interval_bounds(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+	int ret;
+
+	/*
+	 * A bogus s_mmp_update_interval must not stall mount for hours:
+	 * the check interval is capped to EXT4_MMP_MAX_CHECK_INTERVAL, so
+	 * wait_time = min(2 * 300 + 1, 300 + 60) = 360s.
+	 */
+	ctx->es->s_mmp_update_interval = cpu_to_le16(U16_MAX);
+	mmp_init_disk_block(ctx, 100, 5);
+	mmp_reset_counters(ctx);
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 2U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(360 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[1], (long)(360 * HZ));
+	ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
+
+	/* Same for a bogus mmp_check_interval in the MMP block */
+	ctx->es->s_mmp_update_interval = cpu_to_le16(EXT4_MMP_UPDATE_INTERVAL);
+	mmp_init_disk_block(ctx, 100, U16_MAX);
+	mmp_reset_counters(ctx);
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 2U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(360 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[1], (long)(360 * HZ));
+	ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
+
+	/* Zero selects the default interval: wait_time = 2 * 5 + 1 = 11s */
+	ctx->es->s_mmp_update_interval = 0;
+	mmp_init_disk_block(ctx, 100, 0);
+	mmp_reset_counters(ctx);
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 2U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(11 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[1], (long)(11 * HZ));
+	ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
+}
+
+/*
+ * Mount with a real kmmpd() thread, then give it time to either go to sleep
+ * after its first MMP block update or rewrite the block several times in a
+ * row without sleeping.
+ */
+static int mmp_start_kmmpd(struct mmp_test_ctx *ctx, u16 update_interval)
+{
+	int ret, i;
+
+	ctx->es->s_mmp_update_interval = cpu_to_le16(update_interval);
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
+	mmp_reset_counters(ctx);
+	ctx->run_kmmpd = true;
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < 100; i++) {
+		if (READ_ONCE(ctx->kmmpd_wait_calls) ||
+		    READ_ONCE(ctx->kmmpd_write_calls) >= 3)
+			break;
+		msleep(20);
+	}
+	return 0;
+}
+
+static void test_kmmpd_update_interval_bounds(struct kunit *test)
+{
+	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+	unsigned int write_calls, wait_calls;
+
+	/*
+	 * s_mmp_update_interval == 0 must not make kmmpd rewrite the MMP
+	 * block in a busy loop; it uses the default interval instead.
+	 * No KUNIT_ASSERT while kmmpd runs: it must be stopped before the
+	 * static stubs are torn down.
+	 */
+	KUNIT_ASSERT_EQ(test, mmp_start_kmmpd(ctx, 0), 0);
+	write_calls = READ_ONCE(ctx->kmmpd_write_calls);
+	wait_calls = READ_ONCE(ctx->kmmpd_wait_calls);
+	ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
+
+	KUNIT_EXPECT_EQ(test, write_calls, 1U);
+	KUNIT_EXPECT_EQ(test, wait_calls, 1U);
+	KUNIT_EXPECT_GT(test, ctx->kmmpd_wait_timeout, 0L);
+	KUNIT_EXPECT_LE(test, ctx->kmmpd_wait_timeout,
+			(long)(EXT4_MMP_UPDATE_INTERVAL * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->kmmpd_check_interval,
+			EXT4_MMP_CHECK_MULT * EXT4_MMP_UPDATE_INTERVAL);
+
+	/* A huge s_mmp_update_interval is capped */
+	KUNIT_ASSERT_EQ(test, mmp_start_kmmpd(ctx, U16_MAX), 0);
+	write_calls = READ_ONCE(ctx->kmmpd_write_calls);
+	wait_calls = READ_ONCE(ctx->kmmpd_wait_calls);
+	ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
+
+	KUNIT_EXPECT_EQ(test, write_calls, 1U);
+	KUNIT_EXPECT_EQ(test, wait_calls, 1U);
+	KUNIT_EXPECT_GT(test, ctx->kmmpd_wait_timeout,
+			(long)((EXT4_MMP_MAX_UPDATE_INTERVAL - 1) * HZ));
+	KUNIT_EXPECT_LE(test, ctx->kmmpd_wait_timeout,
+			(long)(EXT4_MMP_MAX_UPDATE_INTERVAL * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->kmmpd_check_interval,
+			EXT4_MMP_MAX_CHECK_INTERVAL);
+}
+
 static struct kunit_case mmp_test_cases[] = {
 	KUNIT_CASE(test_mmp_csum_set_and_verify),
 	KUNIT_CASE(test_read_and_write_mmp_block),
@@ -647,6 +815,8 @@ static struct kunit_case mmp_test_cases[] = {
 	KUNIT_CASE(test_mmp_clean_and_fsck_sequences),
 	KUNIT_CASE(test_mmp_active_seq_conflict_and_claim),
 	KUNIT_CASE(test_mmp_interrupted_waits_and_kthread_failure),
+	KUNIT_CASE(test_mmp_update_interval_bounds),
+	KUNIT_CASE(test_kmmpd_update_interval_bounds),
 	{}
 };
 
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 025c9f332726..050263ad4015 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -151,6 +151,20 @@ void __dump_mmp_msg(struct super_block *sb, struct mmp_struct *mmp,
 		       (int)sizeof(mmp->mmp_bdevname), mmp->mmp_bdevname);
 }
 
+/*
+ * Return s_mmp_update_interval, using the default if it is zero and capping
+ * it to the maximum that e2fsprogs allows, so that a bogus value can neither
+ * make kmmpd rewrite the MMP block in a busy loop nor stall mount for hours.
+ */
+static unsigned int ext4_mmp_update_interval(struct ext4_super_block *es)
+{
+	unsigned int interval = le16_to_cpu(es->s_mmp_update_interval);
+
+	if (!interval)
+		return EXT4_MMP_UPDATE_INTERVAL;
+	return min_t(unsigned int, interval, EXT4_MMP_MAX_UPDATE_INTERVAL);
+}
+
 /*
  * kmmpd will update the MMP sequence every s_mmp_update_interval seconds
  */
@@ -163,7 +177,7 @@ static int kmmpd(void *data)
 	ext4_fsblk_t mmp_block;
 	u32 seq = 0;
 	unsigned long failed_writes = 0;
-	int mmp_update_interval = le16_to_cpu(es->s_mmp_update_interval);
+	unsigned int mmp_update_interval = ext4_mmp_update_interval(es);
 	unsigned mmp_check_interval;
 	unsigned long last_update_time;
 	unsigned long diff;
@@ -176,8 +190,9 @@ static int kmmpd(void *data)
 	 * Start with the higher mmp_check_interval and reduce it if
 	 * the MMP block is being updated on time.
 	 */
-	mmp_check_interval = max(EXT4_MMP_CHECK_MULT * mmp_update_interval,
-				 EXT4_MMP_MIN_CHECK_INTERVAL);
+	mmp_check_interval = clamp(EXT4_MMP_CHECK_MULT * mmp_update_interval,
+				   EXT4_MMP_MIN_CHECK_INTERVAL,
+				   EXT4_MMP_MAX_CHECK_INTERVAL);
 	mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
 
 	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
@@ -314,7 +329,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	struct buffer_head *bh = NULL;
 	struct mmp_struct *mmp = NULL;
 	u32 seq;
-	unsigned int mmp_check_interval = le16_to_cpu(es->s_mmp_update_interval);
+	unsigned int mmp_check_interval = ext4_mmp_update_interval(es);
 	unsigned int wait_time = 0;
 	int retval;
 
@@ -340,6 +355,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	 */
 	if (le16_to_cpu(mmp->mmp_check_interval) > mmp_check_interval)
 		mmp_check_interval = le16_to_cpu(mmp->mmp_check_interval);
+	if (mmp_check_interval > EXT4_MMP_MAX_CHECK_INTERVAL)
+		mmp_check_interval = EXT4_MMP_MAX_CHECK_INTERVAL;
 
 	seq = le32_to_cpu(mmp->mmp_seq);
 	if (seq == EXT4_MMP_SEQ_CLEAN)
@@ -463,4 +480,10 @@ int ext4_write_mmp_block_test(struct super_block *sb, struct buffer_head *bh)
 	return write_mmp_block(sb, bh);
 }
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_write_mmp_block_test);
+
+int ext4_kmmpd_test(void *data)
+{
+	return kmmpd(data);
+}
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_kmmpd_test);
 #endif
-- 
2.56.0.542.g3ef89b7020-goog

