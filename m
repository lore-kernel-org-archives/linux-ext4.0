Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458846;
	b=yJNWeUKU/1NMdxi1MPlur82OOTlK21T0LmAt5fonvabmdA/xFVjtKplqAB5X/WTI2J4S
	 3Rkd2NJmrKFUMlcvgUtOa7nSc0L1fZWL8Yz9vVxtqJKHMeefNA8cS4mSXuh48iv4viyDi
	 6o7/kMijV4zGuGZXiCeJM7jL5b6jRszzi71jtxyMA73hRTOZ3RXb+QdnDhxEmE+FVY3KZ
	 k9xk4RYSyX094+BMtawhX6I8254kNkVso88UVTsFAx1TIE9QEJvwUbEpEfrcdJtvA80Zs
	 J6WAHEC2X0Zy64d6YCYlTD/4L1DECcWjEjbC1BBExPd8AxlPkF0ynniscfTL7fwEkRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458846;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QNJScpC28zHNkmznSaRCulzM/aKXOxbZtqQaTEq6uEo=;
	b=F8FI+K4x55nGOTFSkICIvH7zgTOzk76LmIjEoj3+qGG1jL4ltvvO5S+8/MKxU4kFCgQy
	 8f7iuoKUmL+MmMYaNG6pLQezyIGCNB+ICxUbW4BydflgJGPLRJGfo8vvWNqiP1YlUs5jl
	 YTVwuBpvPh+a+/P8gVTwg5+Xv2UZapUXfD8IgHyu4JvdZEY2LoDY8KkvXnKXlovqeJ95R
	 z4+V9EOyTorf1q0DMU0+25ysdcaWIZgryvDeYVrye2+ntuUfKPyEfoj4XFaVzh800InOi
	 cgaQmwfNVT9DKGd04cQ1Zv4v1G3tVQ37kKIzVLFCzgTI3HZuaZ5sbfw+zshUGtBAchA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Ta3GV9Xd;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742F760A262C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 742F760A262C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Ta3GV9Xd
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lM1o031257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458844; bh=QNJScpC28zHNkmznSaRCulzM/aKXOxbZtqQaTEq6uEo=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Ta3GV9XdfmyCJF+e821uDHzIFG8NPtcHobZf9oBrmUsQJqHxQX+szKPSq/VohfTYq
	 ONA0rtIw138aFPAbKhiMqloiJFBzwv2nm9CvBsGdpR1eVB3o5tZSEyHpcycd/knSM5
	 l2br1ckyBkZopGHSPFqbJKSG1PqDcefi8V5vkE2ty22rSngoCcqMmEnXDnKmzD5Ory
	 STJ6q3wQF9ErQ58ZSYMqkRcOWs0XD/noUECZ3RnwlbLEaRYD1iUbWz+jQuPNMXUOep
	 Pbp+Ia6tlMfo4+qjuKRLdzFdY/QFFymPAN59hwrp4YWvhP7O4Jfel2AOf77O5bcAyM
	 vixsmKhUUie8A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 55FB32E0156; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 17/23] ext4: don't clobber the migration result in ext4_ext_migrate()
Date: Wed, 11 Nov 2026 23:47:06 -0500
Message-ID: <20261112044712.1577296-18-tytso@mit.edu>
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

After building the extent tree and (on success) swapping it into the
inode, ext4_ext_migrate() makes sure the handle has a credit left for
resetting tmp_inode, storing the result of ext4_journal_ensure_credits()
in retval.  This throws away the outcome of the migration itself:

 - If anything failed before (an I/O error reading an indirect block,
   ENOSPC while growing the temporary extent tree, or EAGAIN from
   ext4_ext_swap_inode_data() because a block was allocated
   concurrently), the error is replaced by 0 and EXT4_IOC_MIGRATE or
   "chattr +e" reports success although the inode is still
   indirect-mapped.

 - If the handle had to be restarted to obtain the credit,
   ext4_journal_ensure_credits() returns 1, which is then returned to
   userspace from EXT4_IOC_MIGRATE and treated as a failure by
   ext4_ioctl_setflags().

Use a separate variable for the credit check and only let its error
override retval if the migration itself succeeded.

Fixes: a413036791d0 ("ext4: Provide function to handle transaction restarts")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/migrate-test.c | 53 +++++++++++++++++++++++++++++++++++++++---
 fs/ext4/migrate.c      |  9 ++++---
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/migrate-test.c b/fs/ext4/migrate-test.c
index 1cc7c6fe3b80..59e34c2fd0db 100644
--- a/fs/ext4/migrate-test.c
+++ b/fs/ext4/migrate-test.c
@@ -68,6 +68,7 @@ struct migrate_test_ctx {
 	ext4_fsblk_t freed_blks[MIGRATE_MAX_FREED_REC];
 	unsigned int freed_cnt;
 	unsigned int datasem_restarts;
+	struct inode *race_inode;
 	bool rwsem_inited;
 	bool es_shrinker_inited;
 	bool counters_inited;
@@ -382,6 +383,20 @@ static int migrate_datasem_restart_stub(handle_t *handle, struct inode *inode,
 	return 1;
 }
 
+/*
+ * Emulate a block allocation racing with the migration of
+ * ctx->race_inode, which clears EXT4_STATE_EXT_MIGRATE on it.
+ */
+static int migrate_datasem_race_stub(handle_t *handle, struct inode *inode,
+				     int check_cred, int restart_cred,
+				     int revoke_cred)
+{
+	struct migrate_test_ctx *ctx = active_migrate_test->priv;
+
+	ext4_clear_inode_state(ctx->race_inode, EXT4_STATE_EXT_MIGRATE);
+	return 0;
+}
+
 static struct inode *migrate_make_test_inode(struct kunit *test, unsigned long ino,
 					     umode_t mode)
 {
@@ -859,8 +874,8 @@ static void test_ext_migrate_dind_tind_and_multilevel_tree(struct kunit *test)
 /*
  * Test 4: When reading an indirect block fails midway after tmp_inode has
  * already grown a depth-1 extent tree, free_ext_block() / free_ext_idx()
- * frees the allocated temporary extent metadata block and leaves the original
- * inode untouched.
+ * frees the allocated temporary extent metadata block, leaves the original
+ * inode untouched, and ext4_ext_migrate() returns the error.
  */
 static void test_ext_migrate_error_rollback_frees_tmp_extent_blocks(struct kunit *test)
 {
@@ -886,7 +901,8 @@ static void test_ext_migrate_error_rollback_frees_tmp_extent_blocks(struct kunit
 	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] =
 		cpu_to_le32(MIGRATE_TEST_TOTAL_BLKS + 50);
 
-	(void)ext4_ext_migrate(inode);
+	/* The read error is reported to the caller, not swallowed */
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), -EIO);
 
 	/* Temporary extent leaf block allocated during build must be freed */
 	KUNIT_EXPECT_TRUE(test, migrate_was_freed(ctx, expected_leaf_blk));
@@ -1196,6 +1212,36 @@ static void test_ext_migrate_survives_handle_restart(struct kunit *test)
 	iput(inode);
 }
 
+/*
+ * Test 10: If a concurrent block allocation invalidates the migration,
+ * ext4_ext_migrate() reports -EAGAIN instead of claiming success, and the
+ * inode keeps its indirect block map.
+ */
+static void test_ext_migrate_reports_concurrent_allocation(struct kunit *test)
+{
+	struct migrate_test_ctx *ctx = test->priv;
+	struct inode *inode;
+
+	kunit_activate_static_stub(test, ext4_datasem_ensure_credits,
+				   migrate_datasem_race_stub);
+
+	inode = migrate_make_test_inode(test, 24, S_IFREG | 0644);
+	i_size_write(inode, 4 * MIGRATE_TEST_BLK_SIZE);
+	inode->i_blocks = 2 * (MIGRATE_TEST_BLK_SIZE >> 9);
+	EXT4_I(inode)->i_data[0] = cpu_to_le32(100);
+	EXT4_I(inode)->i_data[3] = cpu_to_le32(200);
+	ctx->race_inode = inode;
+
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), -EAGAIN);
+	KUNIT_EXPECT_FALSE(test,
+			   ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT4_I(inode)->i_data[0]), 100U);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(EXT4_I(inode)->i_data[3]), 200U);
+
+	ctx->race_inode = NULL;
+	iput(inode);
+}
+
 static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ext_migrate_precondition_checks_and_fast_symlink),
 	KUNIT_CASE(test_ext_migrate_direct_and_ind_coalescing_and_holes),
@@ -1206,6 +1252,7 @@ static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ind_migrate_rejections),
 	KUNIT_CASE(test_ext_migrate_caps_long_run_at_init_max_len),
 	KUNIT_CASE(test_ext_migrate_survives_handle_restart),
+	KUNIT_CASE(test_ext_migrate_reports_concurrent_allocation),
 	{}
 };
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index dd132a6b6060..c80710f5a43d 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -417,7 +417,7 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 int ext4_ext_migrate(struct inode *inode)
 {
 	handle_t *handle;
-	int retval = 0, i;
+	int retval = 0, err, i;
 	__le32 *i_data;
 	struct ext4_inode_info *ei;
 	struct inode *tmp_inode = NULL;
@@ -574,9 +574,12 @@ int ext4_ext_migrate(struct inode *inode)
 	}
 
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
-	retval = ext4_journal_ensure_credits(handle, 1, 0);
-	if (retval < 0)
+	err = ext4_journal_ensure_credits(handle, 1, 0);
+	if (err < 0) {
+		if (!retval)
+			retval = err;
 		goto out_stop;
+	}
 	/*
 	 * Mark the tmp_inode as of size zero
 	 */
-- 
2.56.0.542.g3ef89b7020-goog

