Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115857;
	b=K7JCANLUucUvnETCeGBARPQFuIRITdcl0TUXBTksxLvo6i+41YCB5G02J+3NX2fZdt0J
	 zICLm7c55w828hXypeKXVGAsvTGUulaAW7zcBl/54p+8iVH5beU/ha79hNgcMhTqbNnhy
	 WwCTryd6ZJtFZDpzV/TQOxxwfxf7ydu4caO9v3MdzjJKVPLAh3CppXRhaBEj6Ee7tHQub
	 vp86+IZrrHaaULtmo5q4yXz0iKEHRV50PHwHypSScRTxeMIHrAyOwHB5STyVn/OBHg+wc
	 iMx0A5R8CiaXU4mrCBYp+Jr107e1zbxXsh/uHIfZ9H2HVa3UYDe0Rd3ddHde9fcg3tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115857;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SUUfNxph2oJNfWS69uBzlb0PRLRAIE1vxSVTudBWMCI=;
	b=I/POkGBNj+zD5RIEW8k/F0mwbl7UlPn7Xk1+pH/QaCgkwDjvqoVFBprzEX/bbL/g3tim
	 j6IDPVEgdg7tTTYuVmkHBs6nwsHQgv3Ydwm9PBQZ3jGxzJiPgisdE4J5bJ2QnoGAxEEI5
	 ZIq3VA6GCyTxJhOXyBKlFVpFefiJybTEIlEgnliQJ3vdMiw1M9MKB4cbTIqxb0epzF2/4
	 YadwEROZDDpb3X63UouFmTdftdqdOtgwq54Pp5aqE75CedOjabrBWISz6udVCgpis30GU
	 LBKRoTUtRS8pVLpa34c8hbO2RN+6ZE8v6sBYF/UkLHmHEiGaHrLWRgUZJ/DBTVBkScw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Uws76oLS;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C7960A2619
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9C7960A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Uws76oLS
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHY9l029940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=SUUfNxph2oJNfWS69uBzlb0PRLRAIE1vxSVTudBWMCI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Uws76oLSYU4HppR1RozoGEUF1HMmKCTej/Z1dqQiO1rEP4zeiUUKyzHDpHFhEX1nn
	 gISZeo2wuGrcVHHo4b+61pv17vAhFJ7eaUFfVbQFa8fAtz1I1+RArMsaaBJ7KfoGpq
	 d0x97ch8Zfr9AldpIRX3yrKTfsDBwUofvgxMnhuFa0FuVcEAJyCELUXW86dMXRND+m
	 EXcUQZkNuCYKDgyoc9MumlFXXS1OEXy8EeFW7Po6LWSFtQ0GRmkmBINfZ+BYYaG+H3
	 xmTslzWx//HkFSklRWY/oHu6yjFH3k8vVBaWv7jKxfPZ7Y94C2emiLcqutBrT6ExI6
	 Zlmz2XoESeICA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 45B592E0156; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 17/32] ext4: fix MMP claim of a cleanly unmounted filesystem
Date: Thu, 19 Nov 2026 14:17:04 -0500
Message-ID: <20261119191719.1943298-18-tytso@mit.edu>
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
index e9575d917502..90fc5b48ddca 100644
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
index 59f7169350ea..714b30dfb412 100644
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
2.56.1.708.g77570a6a1d-goog

