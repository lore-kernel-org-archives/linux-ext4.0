Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D39737C919
	for <linux-ext4@vger.kernel.org>; Thu,  7 May 2026 08:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778143438; cv=none; b=CJs8ynQe+EqJ/GbcLu+KpIAhFxFKHfSBAGfZb6WR8Xw5CtioEECeR22jEodoUaOPnaD7wNgylFGdKXy+A7PDVVaxC4RBy2uYyTeHVMTwCClpuV4I2HQYx7ldvW8iy3/OGhUWRRUCgzzWFYxMwj4gkH+U1WvCl5ZHSK/e3Q/2cBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778143438; c=relaxed/simple;
	bh=UhIMGD58FAGorhLoxRMIyHova3EsMH2ur4ik3w0oRXM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iqPu1/7/OfvvTkP3pnA5QDXdx/Vb8O7aDpqMuPWvibtkQNuSPhlBClL5ewWNIJShoySpVitoG4UdENRyhN6NoqyaP88yGYc90YL6fFpRApIofCcCHW1GeRQo43JQKhSyrjiFXU/OBdH/aXsWqo3cq6TRBJ39nHOcM6rsQASnGWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LJP1sjiY; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LJP1sjiY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778143417; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=PvhYX6W4amdO4b+ZhkNDACN/mpdJOK2OrVxRDSFD++o=;
	b=LJP1sjiYAsN3v/6TuylNhBmHdHheTCu2F4yUVTwF7a+LNrylJmwT0ur2nFzmipB3JwTg0qMpdMBlvhJx+5iW7/lOM5owF+wfQNXdfUXV4AJdL3x9Y/Tp/Fx+4os54zLYw+0nhQnPIz23E5P35fsb4RNjN5NBiupSyFECALosimQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2TwS4b_1778143079;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2TwS4b_1778143079 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 May 2026 16:38:20 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com
Subject: [PATCH v2] ext4: enable mballoc kunit tests for blocksize > PAGE_SIZE
Date: Thu,  7 May 2026 16:37:54 +0800
Message-ID: <20260507083754.1646636-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Large Block Size (LBS) support, ext4 can now use block sizes larger
than PAGE_SIZE. The mballoc kunit tests previously skipped three test
cases (test_mb_mark_used, test_mb_free_blocks, test_mb_mark_used_cost)
under this configuration because the buddy cache inode's folio mapping
order was never initialized in the test harness.

The real mount path configures s_min_folio_order and s_max_folio_order
in ext4_fill_super(), which allows ext4_set_inode_mapping_order() to
set up the correct folio order for the buddy cache inode. The kunit
test bypasses ext4_fill_super(), so the mapping order stayed at zero
and __filemap_get_folio() allocated order-0 folios too small for LBS.

Initialize s_min_folio_order and s_max_folio_order in mbt_init_sb_layout()
to mirror ext4_fill_super() behavior, enabling properly sized folio
allocations and removing the three blocksize > PAGE_SIZE skips.

Add mbt_check_lbs_support() to skip tests that use
ext4_mb_load_buddy_test() when blocksize > PAGE_SIZE without
CONFIG_TRANSPARENT_HUGEPAGE.  Without THP, mapping_set_folio_order_range()
is a no-op and __filemap_get_folio() allocates order-0 folios (PAGE_SIZE),
which are too small for the buddy cache bitmap/buddy data.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
Changes since v1:
 * Add mbt_check_lbs_support() to skip tests when blocksize > PAGE_SIZE
   without CONFIG_TRANSPARENT_HUGEPAGE. (Reported by sashiko.)

v1: https://patch.msgid.link/20260506075900.3649944-1-libaokun@linux.alibaba.com

 fs/ext4/mballoc-test.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index 90ed505fa4b1..72820bb2dcd4 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -206,6 +206,8 @@ static void mbt_init_sb_layout(struct super_block *sb,
 	sbi->s_desc_per_block_bits =
 		sb->s_blocksize_bits - (fls(layout->desc_size) - 1);
 	sbi->s_desc_per_block = 1 << sbi->s_desc_per_block_bits;
+	sbi->s_min_folio_order = get_order(sb->s_blocksize);
+	sbi->s_max_folio_order = sbi->s_min_folio_order;
 
 	es->s_first_data_block = cpu_to_le32(0);
 	es->s_blocks_count_lo = cpu_to_le32(layout->blocks_per_group *
@@ -781,6 +783,16 @@ test_mb_mark_used_range(struct kunit *test, struct ext4_buddy *e4b,
 	mbt_validate_group_info(test, grp, e4b->bd_info);
 }
 
+/*
+ * Skip if blocksize > PAGE_SIZE without THP.  The buddy cache folio
+ * allocation requires CONFIG_TRANSPARENT_HUGEPAGE for large blocks.
+ */
+static void mbt_check_lbs_support(struct kunit *test, struct super_block *sb)
+{
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && sb->s_blocksize > PAGE_SIZE)
+		kunit_skip(test, "blocksize > PAGE_SIZE requires CONFIG_TRANSPARENT_HUGEPAGE");
+}
+
 static void test_mb_mark_used(struct kunit *test)
 {
 	struct ext4_buddy e4b;
@@ -791,9 +803,7 @@ static void test_mb_mark_used(struct kunit *test)
 	struct test_range ranges[TEST_RANGE_COUNT];
 	int i;
 
-	/* buddy cache assumes that each page contains at least one block */
-	if (sb->s_blocksize > PAGE_SIZE)
-		kunit_skip(test, "blocksize exceeds pagesize");
+	mbt_check_lbs_support(test, sb);
 
 	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
@@ -858,9 +868,7 @@ static void test_mb_free_blocks(struct kunit *test)
 	int i;
 	struct test_range ranges[TEST_RANGE_COUNT];
 
-	/* buddy cache assumes that each page contains at least one block */
-	if (sb->s_blocksize > PAGE_SIZE)
-		kunit_skip(test, "blocksize exceeds pagesize");
+	mbt_check_lbs_support(test, sb);
 
 	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
@@ -905,9 +913,7 @@ static void test_mb_mark_used_cost(struct kunit *test)
 	int i, j;
 	unsigned long start, end, all = 0;
 
-	/* buddy cache assumes that each page contains at least one block */
-	if (sb->s_blocksize > PAGE_SIZE)
-		kunit_skip(test, "blocksize exceeds pagesize");
+	mbt_check_lbs_support(test, sb);
 
 	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
 	KUNIT_ASSERT_EQ(test, ret, 0);
-- 
2.43.7

