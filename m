Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458847;
	b=LaMa/7eI+VtIDGTKL2tUppcgVTpkjKlo+hKjAYG7es1w+OznbiepFuEAeYPNLnlJQCxg
	 MK45SAqPoXquqUcCQumXCa9Jl/UMGHMpwqyBFSCIv1P/EVobW0O+01bo8+FW4q02x76eO
	 jiYja1z/oyxQlvwHbOtVRrQF04lQ9/Od9Jmy+IvCW9IT6r1Vr0V7LniLs9xLGL/vGt3qI
	 1qIzTvmeMjo37oyosg7vVRx7Z2Fz10rMFseS12hXbTHw7FSEEvqEtkhsJ8e0/BmpLG91N
	 oHVRpfZ2RP9CTRfn83ihG+MjxvY0W7n6AQqad8gaUuV7JNTBCWgvomW33hqHmJfIGTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458847;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CEZotP8syqf8oyRzohMZbKzd8yZ/sQ7Sy/DrZZQ6FAU=;
	b=pQXzNB0nRZidOp1MorTWKhrKUR/36FESDvjNJZhE4hTQpf0QL1eQGzoI/jEzwsUD1E2p
	 hGhPi4JTSKeUozEEWCKDIdZUspmOUG7KPeA+vNzX2zW566LDzlYjFqyI173p6QOMzGah6
	 vkitQw+r7ck6esBEjmK+SeeLBqtwTKsb1LtVI08TI4EtSa9E3xKWdDi20z4g4waRH5ulm
	 LurS73HBE7sm7OxbDCOXCdLY/Aer3fZkD4hoOqpQC1eKtPnVCqWYHxw+uwRx0X7BCZ5Gh
	 cmgzzg31k25olL/joh+fIfS524rCq58el3S2HJe7YU5ORfL3xdCfsa0TcE4iGhey0OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=iLpH6MRM;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017D660A3815
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 017D660A3815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=iLpH6MRM
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lMdt031278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458844; bh=CEZotP8syqf8oyRzohMZbKzd8yZ/sQ7Sy/DrZZQ6FAU=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=iLpH6MRMEmHByZTNqoMX3vgwNbjyGxx1dlpWBTcIxzPzVsy07ENoBRas1qBXktK8q
	 c9jtBmy3XZETxIBSDiq3hpK9cJgml7jhujythtcb9IoBZ20L4i3ESEfqzBy9yQPs3+
	 FjM6ArJjVzjgy2jabRXCgm5xEfb5h4XvCUHKDaUMnueCM+Wg/3npW/olw9V74kW/wk
	 0SuBKuqBAOvjQGv2uPJerFr6bkKkuwlHCKFEPkq+MJpdvkvf3xElAJgJF1/dZt75e+
	 +v++lNW5AgO1uSOM8ZTttF1jERt1f1gJV9hHbggSJNPm5G6NXmqne/w4lgUgBpT7aI
	 4rVSyZ4YtwtOQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5FB962E0159; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 20/23] ext4: fix MMP claim of a cleanly unmounted filesystem
Date: Wed, 11 Nov 2026 23:47:09 -0500
Message-ID: <20261112044712.1577296-21-tytso@mit.edu>
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

ext4_multi_mount_protect() has several problems:

 - wait_time is initialised to 0 and only computed after the
   EXT4_MMP_SEQ_CLEAN check jumps to "skip".  For a cleanly unmounted
   filesystem the wait between writing our new sequence number and
   re-reading it to verify the claim is therefore zero.  If two nodes
   mount a clean shared device at about the same time, both read
   EXT4_MMP_SEQ_CLEAN, both write their own sequence and both
   immediately read back their own value, so both mount the filesystem
   read-write.  kmmpd only re-reads the MMP block when its own write
   was delayed, so this is not caught later either.  e2fsprogs waits
   after claiming a clean MMP block for exactly this reason.

 - The comment above EXT4_MMP_SEQ_MAX states that any unknown value
   above EXT4_MMP_SEQ_MAX must be treated as unsafe, like
   EXT4_MMP_SEQ_FSCK, and e2fsprogs refuses such values.  The kernel
   treats them as an ordinary stale sequence number instead and takes
   over the filesystem.

 - The claim is written with the node name, device name and time of
   the previous owner, so a racing mounter that now notices the claim
   reports stale information about who is using the device.

 - If starting kmmpd fails, s_mmp_bh is left pointing to the buffer
   head that is released on the error path, and our sequence number is
   left on disk, so the next mount attempt has to wait for it to go
   stale.

Compute wait_time before checking for EXT4_MMP_SEQ_CLEAN so that the
post-claim wait is always done, reject unknown sequence values with
-EBUSY like EXT4_MMP_SEQ_FSCK, fill in mmp_time, mmp_nodename and
mmp_bdevname before writing the claim, and on kmmpd creation failure
clear s_mmp_bh and mark the MMP block clean again, as kmmpd does on
unmount.

Note that this makes mounting a clean MMP-enabled filesystem wait for
wait_time (11 seconds with the default interval), which is the
documented behaviour of MMP and matches e2fsprogs.

Extend the KUnit tests to check the post-claim wait for a clean MMP
block, detection of a racing mounter, rejection of unknown sequence
values, the contents of the claim and the kmmpd failure cleanup.

Fixes: c5e06d101aaf ("ext4: add support for multiple mount protection")
Fixes: 618f003199c6 ("ext4: fix memory leak in ext4_fill_super")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/mmp-test.c | 52 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/mmp.c      | 36 +++++++++++++++++++++++++-------
 2 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/mmp-test.c b/fs/ext4/mmp-test.c
index c36f625f88a5..4498eef73168 100644
--- a/fs/ext4/mmp-test.c
+++ b/fs/ext4/mmp-test.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
+#include <linux/utsname.h>
 #include <linux/workqueue.h>
 
 #include "ext4.h"
@@ -578,7 +579,9 @@ static void test_mmp_clean_and_fsck_sequences(struct kunit *test)
 
 	/*
 	 * EXT4_MMP_SEQ_CLEAN skips pre-claim wait, writes a valid sequence
-	 * <= EXT4_MMP_SEQ_MAX, starts kmmpd, and ext4_stop_mmpd() cleans up.
+	 * <= EXT4_MMP_SEQ_MAX along with our node and device names, still
+	 * waits the full wait_time (2 * 5 + 1 = 11s) before verifying the
+	 * claim, starts kmmpd, and ext4_stop_mmpd() cleans up.
 	 */
 	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
 	mmp_reset_counters(ctx);
@@ -587,9 +590,14 @@ static void test_mmp_clean_and_fsck_sequences(struct kunit *test)
 	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 1U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(11 * HZ));
 	KUNIT_EXPECT_EQ(test, ctx->write_calls, 1U);
 	KUNIT_EXPECT_EQ(test, ctx->run_thread_calls, 1U);
 	KUNIT_EXPECT_LE(test, le32_to_cpu(disk_mmp->mmp_seq), EXT4_MMP_SEQ_MAX);
+	KUNIT_EXPECT_EQ(test, memcmp(disk_mmp->mmp_nodename,
+				     init_utsname()->nodename,
+				     sizeof(disk_mmp->mmp_nodename)), 0);
+	KUNIT_EXPECT_STREQ(test, disk_mmp->mmp_bdevname, "mmp_bdev");
 	KUNIT_EXPECT_NOT_NULL(test, ctx->sbi.s_mmp_tsk);
 	KUNIT_EXPECT_PTR_EQ(test, ctx->sbi.s_mmp_bh, &ctx->mmp_bh);
 	KUNIT_EXPECT_STREQ(test,
@@ -600,6 +608,38 @@ static void test_mmp_clean_and_fsck_sequences(struct kunit *test)
 	KUNIT_EXPECT_NULL(test, ctx->sbi.s_mmp_tsk);
 	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->mmp_bh.b_count), base_ref);
 	ctx->sbi.s_mmp_bh = NULL;
+
+	/* A racing mounter claiming a clean MMP block is detected */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
+	mmp_reset_counters(ctx);
+	ctx->mutate_seq_on_wait_call = 1;
+	ctx->mutated_seq = 0x1234U;
+
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_EXPECT_EQ(test, ret, -EBUSY);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 1U);
+	KUNIT_EXPECT_EQ(test, ctx->wait_timeouts[0], (long)(11 * HZ));
+	KUNIT_EXPECT_EQ(test, ctx->run_thread_calls, 0U);
+
+	/*
+	 * Unknown sequence values above EXT4_MMP_SEQ_MAX are reserved and
+	 * must be treated like EXT4_MMP_SEQ_FSCK, not as a stale sequence.
+	 */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_FSCK + 1, 5);
+	mmp_reset_counters(ctx);
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_EXPECT_EQ(test, ret, -EBUSY);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->write_calls, 0U);
+
+	/* EXT4_MMP_SEQ_MAX itself is a valid (stale) sequence */
+	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_MAX, 5);
+	mmp_reset_counters(ctx);
+	ret = ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx->wait_calls, 2U);
+	ext4_stop_mmpd(&ctx->sbi);
+	ctx->sbi.s_mmp_bh = NULL;
 }
 
 static void test_mmp_active_seq_conflict_and_claim(struct kunit *test)
@@ -660,6 +700,7 @@ static void test_mmp_active_seq_conflict_and_claim(struct kunit *test)
 static void test_mmp_interrupted_waits_and_kthread_failure(struct kunit *test)
 {
 	struct mmp_test_ctx *ctx = mmp_setup_ctx(test);
+	struct mmp_struct *disk_mmp = (struct mmp_struct *)ctx->disk_buf;
 
 	/* Signal interruption on pre-claim wait returns -ETIMEDOUT */
 	mmp_init_disk_block(ctx, 77, 5);
@@ -679,7 +720,10 @@ static void test_mmp_interrupted_waits_and_kthread_failure(struct kunit *test)
 			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
 			-ETIMEDOUT);
 
-	/* kthread creation failure returns -ENOMEM and leaves s_mmp_tsk NULL */
+	/*
+	 * kthread creation failure returns -ENOMEM, leaves s_mmp_tsk and
+	 * s_mmp_bh NULL, and marks the MMP block clean again.
+	 */
 	mmp_init_disk_block(ctx, EXT4_MMP_SEQ_CLEAN, 5);
 	mmp_reset_counters(ctx);
 	ctx->run_thread_err = -ENOMEM;
@@ -687,6 +731,10 @@ static void test_mmp_interrupted_waits_and_kthread_failure(struct kunit *test)
 			ext4_multi_mount_protect(ctx->sb, MMP_TEST_VALID_BLK),
 			-ENOMEM);
 	KUNIT_EXPECT_NULL(test, ctx->sbi.s_mmp_tsk);
+	KUNIT_EXPECT_NULL(test, ctx->sbi.s_mmp_bh);
+	KUNIT_EXPECT_EQ(test, ctx->write_calls, 2U);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(disk_mmp->mmp_seq),
+			EXT4_MMP_SEQ_CLEAN);
 	ctx->sbi.s_mmp_bh = NULL;
 }
 
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 050263ad4015..7ac06ffd33d6 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -330,7 +330,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	struct mmp_struct *mmp = NULL;
 	u32 seq;
 	unsigned int mmp_check_interval = ext4_mmp_update_interval(es);
-	unsigned int wait_time = 0;
+	unsigned int wait_time;
 	int retval;
 
 	if (mmp_block < le32_to_cpu(es->s_first_data_block) ||
@@ -358,6 +358,14 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	if (mmp_check_interval > EXT4_MMP_MAX_CHECK_INTERVAL)
 		mmp_check_interval = EXT4_MMP_MAX_CHECK_INTERVAL;
 
+	/*
+	 * Even if the MMP block was released cleanly, another node may be
+	 * claiming it at the same time, so the wait after writing our own
+	 * sequence number below is needed in all cases.
+	 */
+	wait_time = min(mmp_check_interval * 2 + 1,
+			mmp_check_interval + 60);
+
 	seq = le32_to_cpu(mmp->mmp_seq);
 	if (seq == EXT4_MMP_SEQ_CLEAN)
 		goto skip;
@@ -368,8 +376,12 @@ int ext4_multi_mount_protect(struct super_block *sb,
 		goto failed;
 	}
 
-	wait_time = min(mmp_check_interval * 2 + 1,
-			mmp_check_interval + 60);
+	if (seq > EXT4_MMP_SEQ_MAX) {
+		dump_mmp_msg(sb, mmp,
+			     "Unknown MMP sequence, filesystem may be in use");
+		retval = -EBUSY;
+		goto failed;
+	}
 
 	/* Print MMP interval if more than 20 secs. */
 	if (wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4)
@@ -395,10 +407,17 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 skip:
 	/*
-	 * write a new random sequence number.
+	 * write a new random sequence number, and identify ourselves to
+	 * anybody who finds the MMP block in use while we wait.
 	 */
 	seq = mmp_new_seq();
 	mmp->mmp_seq = cpu_to_le32(seq);
+	mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
+	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
+	       sizeof(mmp->mmp_nodename));
+	BUILD_BUG_ON(sizeof(mmp->mmp_bdevname) < BDEVNAME_SIZE);
+	snprintf(mmp->mmp_bdevname, sizeof(mmp->mmp_bdevname),
+		 "%pg", bh->b_bdev);
 
 	/*
 	 * On mount / remount we are protected against fs freezing (by s_umount
@@ -430,10 +449,6 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	EXT4_SB(sb)->s_mmp_bh = bh;
 
-	BUILD_BUG_ON(sizeof(mmp->mmp_bdevname) < BDEVNAME_SIZE);
-	snprintf(mmp->mmp_bdevname, sizeof(mmp->mmp_bdevname),
-		 "%pg", bh->b_bdev);
-
 	/*
 	 * Start a kernel thread to update the MMP block periodically.
 	 */
@@ -441,8 +456,13 @@ int ext4_multi_mount_protect(struct super_block *sb,
 					     (int)sizeof(mmp->mmp_bdevname));
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
 		EXT4_SB(sb)->s_mmp_tsk = NULL;
+		EXT4_SB(sb)->s_mmp_bh = NULL;
 		ext4_warning(sb, "Unable to create kmmpd thread for %s.",
 			     sb->s_id);
+		/* Release the MMP block again, as kmmpd does on unmount. */
+		mmp->mmp_seq = cpu_to_le32(EXT4_MMP_SEQ_CLEAN);
+		mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
+		write_mmp_block_thawed(sb, bh);
 		retval = -ENOMEM;
 		goto failed;
 	}
-- 
2.56.0.542.g3ef89b7020-goog

