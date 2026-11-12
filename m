Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458844;
	b=rrYmwV9b1Nr7yEOrBwSGz1Lq6kG5afqBejJDG1NJaSbY6b90jqkLly7fRbKUMuD9neWW
	 mMzv4GipqD0Xc0BfEYrIAMPa2z784IfrUdlFIkkeH3DsDv4tCBG7ihxidSxVluK1a2mf0
	 fq8fOIq2JebLnRGjrouyzkt5biwMUrje/ZlpnNgtNRYzUayJykd3I2URm/Mr86METTFL5
	 qLihTPNFo8b8g9JTI2p9gWcK6zE0CB/Dg1hvbiFiipvhOoCEA+CdFNe3Q22Ppk1NGMsll
	 1MpRiTrqk9dLqzw+6K7AwmOLAUBHE9YRTX485QNulD5ku2nUKfG68ff42FbHLEyUUFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458844;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iO1h+JkV6iFvoRRxGZterDtynF4YgT4FFyh3pZiVtwc=;
	b=lULlJFH0ZDJMXbTlQ4uJSw4Nv6OgSNiP/sn7UGXniuhtS1YTy8YboretlaOPLkowuRqU
	 I3RuBaF+0tNP9bx1+JJoXATmYHbOTVCaLBPwG6cj20SRZWnPqXO39Z2sxzugoNW8+H7ts
	 j4Jm1mohLD6RmjN2yDLEd1YUf5mqpVKNmn4QJI1Puex7TxEts7awf8dS6gd5yuaB/YuLN
	 2q4TbXcet6TJaS4lE6Vjo1gG39uWeAeQGt18Bex3ajlmk5HrsgIiwRSzKzunZqH2Rze1M
	 kl34jygzq9zx5vG+GabtRSb9eJEBIXakVMaoLGv7xgZLdJhAQEE4DVegjkwg5ig76sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FaTabNPo;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15BA606A8BD
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F15BA606A8BD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FaTabNPo
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lKW7031193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=iO1h+JkV6iFvoRRxGZterDtynF4YgT4FFyh3pZiVtwc=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=FaTabNPoqP5RaLZIXDHJ6DfC+AmWO+okFP1qZM/h06A0VpFMW3VwAsOaM3frUsNfj
	 nBmP9RTOKtPERxO0ac36HOGH5S90cpbDYs7Dr6+UEizC80G7lj40jeSFO0BPwShvqx
	 KAWSDcCiOupdI2Azcl1baxebzbUxqaYJ7PgE1MikU2llcVGm3ewHPqOFRzFlCurr4o
	 XavGL1nvBJ2myDm8W2RMWjNNE/7P1PQlXmpTzdBUqtbLoWfqy4rJBnY6hAv9g1rOwS
	 tXzI6n7km3SgR6bRJJ2/N3PDkcESwJkekB5WKKGhkcwi1+k3OVH5wbgCvBUCOQ/jDZ
	 ye/gvDiOPZA1A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3C77B2E014E; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 09/23] ext4: fix err_report_sec_store() timer and value handling
Date: Wed, 11 Nov 2026 23:46:58 -0500
Message-ID: <20261112044712.1577296-10-tytso@mit.edu>
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

err_report_sec_store() has several problems:

 - Writing 0 calls timer_delete_sync() and then jumps past the
   assignment, so s_err_report_sec keeps its old value.  Reading the
   attribute still returns the old interval, writing the old interval
   back to re-enable reporting is treated as a no-op, and the periodic
   report is restarted by the next error even though it was disabled.

 - Changing the interval from 0 to a non-zero value calls
   timer_setup() on s_err_report.  The timer is already initialized at
   mount time, and it may still be pending (e.g. armed by
   ext4_update_super() or the timer callback racing with the store), in
   which case re-initializing it corrupts the timer list.

 - Any non-zero write arms the timer even if no errors have ever been
   recorded, so print_daily_error_info() wakes up and re-arms itself
   forever without having anything to report.

 - Concurrent writers are not serialized, so the timer state can end
   up inconsistent with the stored interval.

Rework the function to always store the new value (with WRITE_ONCE(),
since the timer callback and ext4_update_super() read it locklessly),
drop the timer_setup() call, delete the timer when the interval is set
to 0, and otherwise only (re)arm it when errors have been recorded;
ext4_update_super() starts it when the first error is recorded.
Serialize writers with a function-local mutex.  s_error_notify_mutex
cannot be used for this, since ext4_unregister_sysfs() holds it across
kobject_del(), which waits for active sysfs store callbacks to finish.

Also read s_err_report_sec once with READ_ONCE() in
print_daily_error_info(), so the value tested is the value used to
re-arm the timer.

Fixes: d518215c2719 ("ext4: add sysfs attribute err_report_sec to control s_err_report timer")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c      |  7 ++++--
 fs/ext4/sysfs-test.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/sysfs.c      | 21 ++++++++++-------
 3 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5f704c43c901..e89f37419266 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3756,6 +3756,7 @@ void print_daily_error_info(struct timer_list *t)
 	struct ext4_sb_info *sbi = timer_container_of(sbi, t, s_err_report);
 	struct super_block *sb = sbi->s_sb;
 	struct ext4_super_block *es = sbi->s_es;
+	unsigned long err_report_sec;
 
 	if (es->s_error_count)
 		/* fsck newer than v1.41.13 is needed to clean this condition. */
@@ -3792,8 +3793,10 @@ void print_daily_error_info(struct timer_list *t)
 		printk(KERN_CONT "\n");
 	}
 
-	if (sbi->s_err_report_sec)
-		mod_timer(&sbi->s_err_report, jiffies + secs_to_jiffies(sbi->s_err_report_sec));
+	err_report_sec = READ_ONCE(sbi->s_err_report_sec);
+	if (err_report_sec)
+		mod_timer(&sbi->s_err_report,
+			  jiffies + secs_to_jiffies(err_report_sec));
 }
 
 /* Find next suitable group and run ext4_init_inode_table */
diff --git a/fs/ext4/sysfs-test.c b/fs/ext4/sysfs-test.c
index c13785420aa1..4aefcdc4480a 100644
--- a/fs/ext4/sysfs-test.c
+++ b/fs/ext4/sysfs-test.c
@@ -477,6 +477,60 @@ static void test_validated_rw_attrs(struct kunit *test)
 			(ssize_t)-EINVAL);
 }
 
+static void test_err_report_sec_timer(struct kunit *test)
+{
+	struct sysfs_test_ctx *ctx = test->priv;
+	struct ext4_sb_info *sbi = &ctx->sbi;
+	struct ext4_super_block *es = &ctx->es;
+	char *buf;
+
+	buf = kunit_kzalloc(test, PAGE_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+
+	/* Mount-time default; no errors recorded yet */
+	sbi->s_err_report_sec = 86400;
+	es->s_error_count = 0;
+
+	/* Changing the interval on a clean fs must not arm the timer */
+	KUNIT_EXPECT_EQ(test,
+			ext4_sysfs_attr_store_test(sbi, "err_report_sec",
+						   "3600", 4),
+			(ssize_t)4);
+	KUNIT_EXPECT_EQ(test, sbi->s_err_report_sec, 3600UL);
+	KUNIT_EXPECT_FALSE(test, timer_pending(&sbi->s_err_report));
+
+	/* With recorded errors a new interval (re)arms the timer */
+	es->s_error_count = cpu_to_le32(1);
+	KUNIT_EXPECT_EQ(test,
+			ext4_sysfs_attr_store_test(sbi, "err_report_sec",
+						   "7200", 4),
+			(ssize_t)4);
+	KUNIT_EXPECT_EQ(test, sbi->s_err_report_sec, 7200UL);
+	KUNIT_EXPECT_TRUE(test, timer_pending(&sbi->s_err_report));
+
+	/* Writing 0 disables the timer and is reflected on read */
+	KUNIT_EXPECT_EQ(test,
+			ext4_sysfs_attr_store_test(sbi, "err_report_sec",
+						   "0", 1),
+			(ssize_t)1);
+	KUNIT_EXPECT_EQ(test, sbi->s_err_report_sec, 0UL);
+	KUNIT_EXPECT_FALSE(test, timer_pending(&sbi->s_err_report));
+	KUNIT_EXPECT_GT(test,
+			ext4_sysfs_attr_show_test(sbi, "err_report_sec", buf),
+			(ssize_t)0);
+	KUNIT_EXPECT_STREQ(test, buf, "0\n");
+
+	/* Re-enabling with the old value re-arms the existing timer */
+	KUNIT_EXPECT_EQ(test,
+			ext4_sysfs_attr_store_test(sbi, "err_report_sec",
+						   "7200", 4),
+			(ssize_t)4);
+	KUNIT_EXPECT_EQ(test, sbi->s_err_report_sec, 7200UL);
+	KUNIT_EXPECT_TRUE(test, timer_pending(&sbi->s_err_report));
+	KUNIT_EXPECT_TRUE(test,
+			  sbi->s_err_report.function == sysfs_test_err_timer);
+}
+
 static void test_computed_ro_and_error_time_attrs(struct kunit *test)
 {
 	struct sysfs_test_ctx *ctx = test->priv;
@@ -635,6 +689,7 @@ static void test_sysfs_register_notify_and_unregister(struct kunit *test)
 static struct kunit_case ext4_sysfs_test_cases[] = {
 	KUNIT_CASE(test_generic_pointer_attrs),
 	KUNIT_CASE(test_validated_rw_attrs),
+	KUNIT_CASE(test_err_report_sec_timer),
 	KUNIT_CASE(test_computed_ro_and_error_time_attrs),
 	KUNIT_CASE(test_feature_attrs_and_trigger_error),
 	KUNIT_CASE(test_sysfs_register_notify_and_unregister),
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index faa76f021099..0168ea6faac7 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -134,6 +134,7 @@ static ssize_t trigger_test_error(struct ext4_sb_info *sbi,
 static ssize_t err_report_sec_store(struct ext4_sb_info *sbi,
 				    const char *buf, size_t count)
 {
+	static DEFINE_MUTEX(err_report_sec_mutex);
 	unsigned long t;
 	int ret;
 
@@ -145,19 +146,23 @@ static ssize_t err_report_sec_store(struct ext4_sb_info *sbi,
 	if (t > (365*24*60*60))
 		return -EINVAL;
 
+	mutex_lock(&err_report_sec_mutex);
 	if (sbi->s_err_report_sec == t)		/*nothing to do*/
 		goto out;
-	else if (!sbi->s_err_report_sec && t) {
-		timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
-	} else if (sbi->s_err_report_sec && !t) {
-		timer_delete_sync(&sbi->s_err_report);
-		goto out;
-	}
 
-	sbi->s_err_report_sec = t;
-	mod_timer(&sbi->s_err_report, jiffies + secs_to_jiffies(sbi->s_err_report_sec));
+	WRITE_ONCE(sbi->s_err_report_sec, t);
+	/*
+	 * The timer is initialized at mount time.  Only (re)arm it if errors
+	 * have been recorded; otherwise ext4_update_super() will start it
+	 * when the first error is written to the superblock.
+	 */
+	if (!t)
+		timer_delete_sync(&sbi->s_err_report);
+	else if (sbi->s_es->s_error_count)
+		mod_timer(&sbi->s_err_report, jiffies + secs_to_jiffies(t));
 
 out:
+	mutex_unlock(&err_report_sec_mutex);
 	return count;
 }
 
-- 
2.56.0.542.g3ef89b7020-goog

