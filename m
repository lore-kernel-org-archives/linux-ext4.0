Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=fcoQhsfRQepCNxhGJkisQsErEQYfGOaDsgRnU5MI5O3Mc0Wlsz8ZQOscfawhawYdVAuY
	 3x4zMhAwjpzhWSgAtUcHfwQ8ZyODhlUwojUixiXfWsF4v4/Mr1vqxfE+7vpFrU03Zslll
	 3XqHvfFyDaupZrBAFBTgulkd0or1PFJTp37zwhAhPMg0muBhmL2e5gXv8eadz7rWgTm5+
	 o5CNs4k7+9GwTnl0Pt6HWqn3MSX5kddD4RzGy2eGk8+6npK9kjYZZmRMJNF2rCudbKq4J
	 jIukRig13qTeLDXHC70fgK60/erNkngifAbhyX7znELt6PFdaHM46M8761ezn2WYrYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cDUmeQW5LDloPh5mNSykRSsC8asq8uUobfGOsgAplWE=;
	b=pPHJeqFi42t/bKLWeP7FElxOkXtKSzUa+LFkwQVfqqgXbktTyGyzWFCD+ti7dwQWwDPT
	 Z/4Eb/8Z60R+AvrRSsc7RgBu+K2IW4PzLSeGVkLfykBoGSHtmKEXlZ9/VYWsu1b85ue7v
	 wGiudA4wqvH0hYUiXQsXqZC/YR1y5OYATGIUUHVQ0qKso41urErdQyWBTblMUs0fYU4QP
	 uylAsOXGonhm1BPU8su3qY9L7PThWcCbwh38p8CKI8t+gO4MLexv5WSGC8FJIZDmEuHiR
	 CAU9k3dhdlgqpxmTNemEFKb8NE3z5FU2OpU03NAzYIVZARJC85TxIshb1Wi232sce6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PqpCv0WG;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679D360A2604
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 679D360A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=PqpCv0WG
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHWGw029891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=cDUmeQW5LDloPh5mNSykRSsC8asq8uUobfGOsgAplWE=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=PqpCv0WGHoU58je7lfNeIf4+Tn9ue/yYDAP3mnS0TAA1UPDG70HsOruQ0kCLaCxJN
	 tOab2BGVQJLy0qdqpCErzqQpfC/HNkvP4pTHJbmUcC3t9nh4Xk+BcueI1a2jtQhmIs
	 44IuXrZmkuuNkB8jEfoXhsFXX75W64J//uEZ3pvAfVKw3Gh1fYfWKB2fR0y14HaBaB
	 TBYQ92vzkDW2u4wJRvJWloSq3Buwcp4ZYJSplOxS6fsZD4kBoKODSshGR0GM8tMM2H
	 AOBLnTMgRmzz4nefd1OXYTviSnZAkoHAswdO4iScxnXxEJ0uA71F5//cGC6NTYsfR6
	 oasQVdbEoqtDA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 399662E0152; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 13/32] ext4: propagate ext4_alloc_group_tables() errors from ext4_resize_fs()
Date: Thu, 19 Nov 2026 14:17:00 -0500
Message-ID: <20261119191719.1943298-14-tytso@mit.edu>
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

When ext4_alloc_group_tables() cannot place the bitmaps and inode
tables of the next flex group, ext4_resize_fs() just breaks out of its
loop without recording the error.  err is still 0 (from its
initialization or from the previous successful ext4_flex_group_add()),
so:

 - EXT4_IOC_RESIZE_FS returns success to resize2fs although the file
   system was not grown to the requested size, and

 - if the first pass was capped by the reserved GDT blocks
   (n_blocks_count_retry != 0), the "!err && n_blocks_count_retry" test
   jumps back to retry and carries on as if nothing had happened.

Ignoring the failure was introduced to avoid a BUG_ON() when the last
block group was too small for its metadata.  That case has since been
handled up front by trimming such a final group in ext4_resize_fs()
(commit f0a459dec549 ("ext4: fix online resize's handling of a
too-small final block group")), so a failure here is a real error that
should be reported.  Store the return value in err.

Fixes: 03c1c29053f6 ("ext4: ignore last group w/o enough space when resizing instead of BUG'ing")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/resize-test.c | 24 ++++++++++++++++++++++++
 fs/ext4/resize.c      |  3 ++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/resize-test.c b/fs/ext4/resize-test.c
index 8bfca3c53aef..36b7f0b8167f 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -1403,6 +1403,29 @@ static void test_resize_fs_flex_group_straddles_first_meta_bg(struct kunit *test
 			  ext4_group_first_block_no(sb, 49) + 2));
 }
 
+/*
+ * Test 10: ext4_resize_fs() must report a failure of ext4_alloc_group_tables()
+ * instead of returning success without growing the file system.  With one
+ * reserved GDT block, sparse group 3 has 1021 usable blocks, which cannot
+ * hold two bitmaps plus a 1020-block inode table.
+ */
+static void test_resize_fs_alloc_group_tables_enospc(struct kunit *test)
+{
+	struct resize_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	ext4_fsblk_t o_blks, target_blks;
+
+	resize_configure_fs(test, 3, 1, 0, RESIZE_TEST_BLOCKS_PER_GRP);
+	ctx->sbi.s_itb_per_group = 1020;
+	o_blks = ext4_blocks_count(ctx->es);
+	target_blks = RESIZE_TEST_FIRST_DATA_BLK +
+		      5ULL * RESIZE_TEST_BLOCKS_PER_GRP;
+
+	KUNIT_EXPECT_EQ(test, ext4_resize_fs(sb, target_blks), -ENOSPC);
+	KUNIT_EXPECT_EQ(test, ctx->sbi.s_groups_count, 3U);
+	KUNIT_EXPECT_EQ(test, ext4_blocks_count(ctx->es), o_blks);
+}
+
 static struct kunit_case ext4_resize_test_cases[] = {
 	KUNIT_CASE(test_resize_begin_and_end_guards),
 	KUNIT_CASE(test_list_backups_and_verify_reserved_gdb),
@@ -1413,6 +1436,7 @@ static struct kunit_case ext4_resize_test_cases[] = {
 	KUNIT_CASE(test_convert_meta_bg_validation_and_conversion),
 	KUNIT_CASE(test_resize_fs_across_resize_inode_to_meta_bg),
 	KUNIT_CASE(test_resize_fs_flex_group_straddles_first_meta_bg),
+	KUNIT_CASE(test_resize_fs_alloc_group_tables_enospc),
 	{}
 };
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f28bcdb71a12..dc09fcc91c38 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2192,7 +2192,8 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 					 ext4_blocks_count(es));
 			last_update_time = jiffies;
 		}
-		if (ext4_alloc_group_tables(sb, flex_gd, flexbg_size) != 0)
+		err = ext4_alloc_group_tables(sb, flex_gd, flexbg_size);
+		if (err)
 			break;
 		err = ext4_flex_group_add(sb, resize_inode, flex_gd);
 		if (unlikely(err))
-- 
2.56.1.708.g77570a6a1d-goog

