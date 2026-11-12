Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458846;
	b=QssSeoforx79pw/lYj8XSHghydk1Staa6XO3vQdFJkDY7n9zkJaMB3TN8wwfHI4teDEd
	 E/fq4IDm3gr7sjkfzQ3vH4CKUDAKXPJEB/y7pspaH50YcOp48J9FFXqemp9X7XI62dGY8
	 /zEN94InBr2fecOnmVXLtbcVlKqe5Y1ICZ32UkDhWf1g/5tTH0NfmeyTQE+oTCThTyWPn
	 slXIRNFSRwLpCF7uP6RGkpSQnrQ2knahxh2nET47axE++SL5X4Qh+mEKfs9+eOR+aU05/
	 LmyrHwpb4TGNV7xU47sIqInIqkSKvbj7VrFWZU+nGZ7PbpxuYHrrbEm2d/kMpOFZOCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458846;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UaxIa8+yfF+FeL3B2idDVzJFX734hbqlORB6wscN48w=;
	b=gjZTT2pYQFB9RVL4u8EYZ8hWVm0mWjyS2LEEarO0kDTQE0Y925HMUGHlHD/WtQWfIDq1
	 OvUpmzbFV1U66HPeZmg8ID37KqS9guFL6myDImXlbxwA0pnOrpGaNhuwlki6YH9OYoVpf
	 4rdjJVDUWx7eJP+HV9VgWeMDnUbRb1/LNj1YIPR31Lfhn2z293Z0/IdfJOHxTSV7YXmq/
	 RAp9SsdG8CHLvmNVd0ovnqq10/QV081JF1mophW+5JDtg1IVBRRfaBK9SKLxwYrpAIXJb
	 lETpui3hUJUbWxXeUNiBnltQfvbhD0HLPEhL1SbBEASIL0merORoNrzZswGbEl48iww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TuiSxxgd;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07F960A2637
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B07F960A2637
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TuiSxxgd
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lMdL031252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458843; bh=UaxIa8+yfF+FeL3B2idDVzJFX734hbqlORB6wscN48w=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=TuiSxxgdR2uysbj+63uM1ANBdfdP2dbpiLwSqXU2suHBDpWrgk3KsfLwGK2lJk/y4
	 gJCj4FpAV3ZnwWz5bu3LItPJV+0O2XKpZ4Hgwgd1LjjxXAJ/RvqwQ6IZeGK7M8OyIt
	 DU9Ovrs2zEFN8+EdsbS/N/L2IuMhkdtXeHWFifjK5oOxY5jrxBNQnLGKf4tVcAn++x
	 2PKqEVd7Pryb6gvNNMdDitjHNhYSiv+aHGbElgk7Hjg4SN1PdDRPZvMYwqed2xKLVZ
	 JQhFIICMtbUS4q6dGUWoeTtz66v9CE/0cruLR7y6ygWeA94izi2YoysM3bUKJ1LlrU
	 RdqYIwgxUVIrw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 52FD92E0155; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 16/23] ext4: don't treat a handle restart as an error in finish_range()
Date: Wed, 11 Nov 2026 23:47:05 -0500
Message-ID: <20261112044712.1577296-17-tytso@mit.edu>
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

ext4_datasem_ensure_credits() returns 1 when it had to restart the
transaction to get the requested credits.  finish_range() only bails
out on a negative value, but it then leaves the 1 in retval, and since
ext4_ext_insert_extent() was converted to return the path, a successful
insertion no longer overwrites retval.  finish_range() therefore
returns 1, which all its callers treat as a failure.

As a result, whenever the handle has to be restarted while building
the extent tree of the temporary inode (which is likely for fragmented
files that need many extent insertions), the migration is aborted and
the extent blocks built so far are thrown away.  Because the error
code is later clobbered in ext4_ext_migrate(), userspace is even told
that the migration succeeded while the inode stays indirect-mapped.

A restart is not an error: reset retval to 0 after a successful
ext4_datasem_ensure_credits().  The path does not need to be looked up
again since tmp_inode is private to the migration and cannot change
while i_data_sem is briefly dropped.

Add a KUnit static stub hook to ext4_datasem_ensure_credits() so that
a transaction restart can be emulated without a journal.

Fixes: f7d1331f16a8 ("ext4: get rid of ppath in ext4_ext_insert_extent()")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c      |  4 +++
 fs/ext4/migrate-test.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/migrate.c      |  5 ++++
 3 files changed, 75 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cbada2846190..7872ddc21544 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -142,12 +142,16 @@ int ext4_datasem_ensure_credits(handle_t *handle, struct inode *inode,
 	int ret;
 	int dropped = 0;
 
+	KUNIT_STATIC_STUB_REDIRECT(ext4_datasem_ensure_credits, handle, inode,
+				   check_cred, restart_cred, revoke_cred);
+
 	ret = ext4_journal_ensure_credits_fn(handle, check_cred, restart_cred,
 		revoke_cred, ext4_ext_trunc_restart_fn(inode, &dropped));
 	if (dropped)
 		down_write(&EXT4_I(inode)->i_data_sem);
 	return ret;
 }
+EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_datasem_ensure_credits);
 
 /*
  * could return:
diff --git a/fs/ext4/migrate-test.c b/fs/ext4/migrate-test.c
index 7a7d6607b67f..1cc7c6fe3b80 100644
--- a/fs/ext4/migrate-test.c
+++ b/fs/ext4/migrate-test.c
@@ -67,6 +67,7 @@ struct migrate_test_ctx {
 	int new_inode_err;
 	ext4_fsblk_t freed_blks[MIGRATE_MAX_FREED_REC];
 	unsigned int freed_cnt;
+	unsigned int datasem_restarts;
 	bool rwsem_inited;
 	bool es_shrinker_inited;
 	bool counters_inited;
@@ -365,6 +366,22 @@ static bool migrate_was_freed(struct migrate_test_ctx *ctx, ext4_fsblk_t blk)
 	return false;
 }
 
+/*
+ * Emulate ext4_datasem_ensure_credits() having to restart the transaction:
+ * i_data_sem is dropped and re-acquired and 1 is returned.
+ */
+static int migrate_datasem_restart_stub(handle_t *handle, struct inode *inode,
+					int check_cred, int restart_cred,
+					int revoke_cred)
+{
+	struct migrate_test_ctx *ctx = active_migrate_test->priv;
+
+	up_write(&EXT4_I(inode)->i_data_sem);
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ctx->datasem_restarts++;
+	return 1;
+}
+
 static struct inode *migrate_make_test_inode(struct kunit *test, unsigned long ino,
 					     umode_t mode)
 {
@@ -1131,6 +1148,54 @@ static void test_ext_migrate_caps_long_run_at_init_max_len(struct kunit *test)
 	iput(inode);
 }
 
+/*
+ * Test 9: A transaction restart while inserting an extent into tmp_inode
+ * (ext4_datasem_ensure_credits() returning 1) is not an error; migration
+ * still completes and builds every extent.
+ */
+static void test_ext_migrate_survives_handle_restart(struct kunit *test)
+{
+	struct migrate_test_ctx *ctx = test->priv;
+	struct ext4_extent_header *eh;
+	struct ext4_extent *ex;
+	struct inode *inode;
+
+	kunit_activate_static_stub(test, ext4_datasem_ensure_credits,
+				   migrate_datasem_restart_stub);
+
+	inode = migrate_make_test_inode(test, 23, S_IFREG | 0644);
+	i_size_write(inode, 12 * MIGRATE_TEST_BLK_SIZE);
+	inode->i_blocks = 4 * (MIGRATE_TEST_BLK_SIZE >> 9);
+
+	/* Three discontiguous runs: [0..1] -> 100, [4] -> 200, [8] -> 300 */
+	EXT4_I(inode)->i_data[0] = cpu_to_le32(100);
+	EXT4_I(inode)->i_data[1] = cpu_to_le32(101);
+	EXT4_I(inode)->i_data[4] = cpu_to_le32(200);
+	EXT4_I(inode)->i_data[8] = cpu_to_le32(300);
+
+	KUNIT_EXPECT_EQ(test, ext4_ext_migrate(inode), 0);
+	KUNIT_EXPECT_EQ(test, ctx->datasem_restarts, 3U);
+	KUNIT_EXPECT_TRUE(test,
+			  ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		goto out;
+
+	eh = ext_inode_hdr(inode);
+	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3U);
+	if (le16_to_cpu(eh->eh_entries) != 3)
+		goto out;
+	ex = EXT_FIRST_EXTENT(eh);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[0].ee_block), 0U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(&ex[0]), 2);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[0]), 100ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[1].ee_block), 4U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[1]), 200ULL);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex[2].ee_block), 8U);
+	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(&ex[2]), 300ULL);
+out:
+	iput(inode);
+}
+
 static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ext_migrate_precondition_checks_and_fast_symlink),
 	KUNIT_CASE(test_ext_migrate_direct_and_ind_coalescing_and_holes),
@@ -1140,6 +1205,7 @@ static struct kunit_case ext4_migrate_test_cases[] = {
 	KUNIT_CASE(test_ind_migrate_empty_and_single_direct_extent),
 	KUNIT_CASE(test_ind_migrate_rejections),
 	KUNIT_CASE(test_ext_migrate_caps_long_run_at_init_max_len),
+	KUNIT_CASE(test_ext_migrate_survives_handle_restart),
 	{}
 };
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index e4c1603e1402..dd132a6b6060 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -52,6 +52,11 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	retval = ext4_datasem_ensure_credits(handle, inode, needed, needed, 0);
 	if (retval < 0)
 		goto err_out;
+	/*
+	 * A positive return only means the handle was restarted.  The
+	 * path is still valid because nobody else can modify tmp_inode.
+	 */
+	retval = 0;
 	path = ext4_ext_insert_extent(handle, inode, path, &newext, 0);
 	if (IS_ERR(path))
 		retval = PTR_ERR(path);
-- 
2.56.0.542.g3ef89b7020-goog

