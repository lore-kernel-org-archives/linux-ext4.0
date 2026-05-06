Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4845175A99
	for <linux-ext4@vger.kernel.org>; Wed,  6 May 2026 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778054370; cv=none; b=YJmrOhejzNaXmHAXj4Cg5ZVuOw3ciimw0wUgp7J+gbcl0fIcquU+D7wKQnecJNwefwVpA6XPxnbGq4JPAdNvGGcVYgyIyXtMKQ6Id9xuSKqf18sw6S0/DsUA6xPekjZjGPNF69A5Xp6Urcebt5XvX+ULjHJsGL1BSRfyMH7QMHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778054370; c=relaxed/simple;
	bh=4Vb9bxi6YN8kP5rRd5nyb3Sr7NSKQDWV51h6DBoHaq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SPKuSDWhlC6ue8Zs93BrlCfNivR/Rqfu4IO4/HCtCVh9zrpmWWlAOYLmKaCUrQf8mgFePfDEdBKYMncuaMS2VeVc0orJblRKfb0SwwEpsTofGXLyE3MoQKIYI6bsMhBRc61z1z4fALzzN+xutmsGxc99+xOeZ6T3BKZtRMbayjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jgh+oeU7; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jgh+oeU7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778054360; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=tj2qyGlTzEhJKk0g2FB3xZdcuU2hlPJGLK2Tdm/8io0=;
	b=jgh+oeU7FWLlaHkcIANt+HaS+gLfq3KPmLuAYTNcxDDcmby80tgXigWMv0R0Yv997csv7zDOZlyMA9kTNoxcFBaLxPVave2T8RoEj6qTXAHM8oCoBcdlGnNvpn1hrXkwMDyFhJ9MA0/yvktMOXn1UMa/6QGlL3UcA8cMfaS67QY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2NNNzH_1778054345;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2NNNzH_1778054345 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 06 May 2026 15:59:19 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com
Subject: [PATCH] ext4: enable mballoc kunit tests for blocksize > PAGE_SIZE
Date: Wed,  6 May 2026 15:59:00 +0800
Message-ID: <20260506075900.3649944-1-libaokun@linux.alibaba.com>
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

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/mballoc-test.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index 90ed505fa4b1..04bc9f773d63 100644
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
@@ -791,10 +793,6 @@ static void test_mb_mark_used(struct kunit *test)
 	struct test_range ranges[TEST_RANGE_COUNT];
 	int i;
 
-	/* buddy cache assumes that each page contains at least one block */
-	if (sb->s_blocksize > PAGE_SIZE)
-		kunit_skip(test, "blocksize exceeds pagesize");
-
 	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
 	buddy = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
@@ -858,10 +856,6 @@ static void test_mb_free_blocks(struct kunit *test)
 	int i;
 	struct test_range ranges[TEST_RANGE_COUNT];
 
-	/* buddy cache assumes that each page contains at least one block */
-	if (sb->s_blocksize > PAGE_SIZE)
-		kunit_skip(test, "blocksize exceeds pagesize");
-
 	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
 	buddy = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
@@ -905,10 +899,6 @@ static void test_mb_mark_used_cost(struct kunit *test)
 	int i, j;
 	unsigned long start, end, all = 0;
 
-	/* buddy cache assumes that each page contains at least one block */
-	if (sb->s_blocksize > PAGE_SIZE)
-		kunit_skip(test, "blocksize exceeds pagesize");
-
 	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
-- 
2.43.7

