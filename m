Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458844;
	b=3giWxpvr/qjXV+lWP+W9v6I8Wv9oCngLReN8uwAFt0urnftNDgdZHe90HBuekGpXG8NR
	 2obxDhYbbTO00CD83ooEpOgP1IPu0saXOgMR8bmM68vLoI6wDELMXu2EH+XJW6pSCeask
	 e8QeK8nSNkrNE9eD8K/9J3k//6rkHvCe6oDM2FY0ZuRXQ00xrHu0csG2I65MXB4IJ8Qaz
	 zrPNYfmsjQrtGE6WQKafShiQDEDeRsrU30Cfo0OEnBvvP9XDJRPvTDon++kjgl5yWAdpY
	 C5b1a3D4bZe7CpKol7MYUFQQYi/zNSg0roouFp9ASZicSA0XVSNB0qU9r0i/HdgvQpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458844;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7msgmCWn5akA4f5j8sGY1pnDltY75K7Y0n+Q5RJi/+E=;
	b=vXyV7cm8vBaB3MVeqMeNiPGt0aAf0TmszApum/GTLag1MLDVzcnUBxOZdWFw4e7cdCOg
	 XqSgzE1QYz1FcoEPwKQ+L69gyeG08ULBIMVZKazzoa3h21SYK74DdMLWFWYj+XyDdTAcR
	 Q8Mfm7CYmTfL/H1mObRBxNOaNePr2g+OsUvCj46fvKmzEAO3HGVgBc73jw+Uojh+eigPD
	 kc56MXlaYsMIPWg6igI8n9AhUN08Weu9esIc4bk4xADj4gyCtc6YOj5TgsMK8mcSaxd2u
	 R+6ML22+1yt6HBSXLlBiI4ywvRm35+C2pW6tJ59XLhejgF8rzOd+UjEu76/XW2VN7JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=l97ZyDFJ;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D69606A33C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54D69606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=l97ZyDFJ
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lKwl031220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=7msgmCWn5akA4f5j8sGY1pnDltY75K7Y0n+Q5RJi/+E=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=l97ZyDFJFxjI2COPctCTEjR9l1MXaD53uwdv3+BFkGO198kiDiIjT/l8zXWedW7pY
	 a9roW32xgLVSzfsPJqJJ+/tAmZTVZeIPOmLyykHjnLDgcQ5vjqdeZ6GBCc7nWLRYLC
	 xbOqtid7EZ1MHBXx7DH6p2cn9y+tEMXfnrrVdoHKSOneEeOQdh91aicKGPgt5zo8Aq
	 NyWlsdG4XDKmqvjDk7D0X7dYH8CZ813N+IlWQYrgwm/vrRf+btgg2JhCnn2WfOT4nC
	 7LN0VeAoONpd0JA5gQRKTVIHYJMwbTDnGZzF6H0MPEv/B0bSIutR0vkSRCPGObQLay
	 0SQQmy8GgsB+Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4981E2E0152; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 13/23] ext4: propagate ext4_alloc_group_tables() errors from ext4_resize_fs()
Date: Wed, 11 Nov 2026 23:47:02 -0500
Message-ID: <20261112044712.1577296-14-tytso@mit.edu>
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
index 4a08a47b3481..0fd097d58a59 100644
--- a/fs/ext4/resize-test.c
+++ b/fs/ext4/resize-test.c
@@ -1408,6 +1408,29 @@ static void test_resize_fs_flex_group_straddles_first_meta_bg(struct kunit *test
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
@@ -1418,6 +1441,7 @@ static struct kunit_case ext4_resize_test_cases[] = {
 	KUNIT_CASE(test_convert_meta_bg_validation_and_conversion),
 	KUNIT_CASE(test_resize_fs_across_resize_inode_to_meta_bg),
 	KUNIT_CASE(test_resize_fs_flex_group_straddles_first_meta_bg),
+	KUNIT_CASE(test_resize_fs_alloc_group_tables_enospc),
 	{}
 };
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5e3b4e9f99f8..d3507b175382 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2190,7 +2190,8 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
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
2.56.0.542.g3ef89b7020-goog

