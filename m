Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086613C6603
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773321291; cv=none; b=KntdjEESOEZbNDjKxxv2AnFGcfCH1PaPybbNtVLEWcLtLjaChl1hhz01JEJY1CgH4hN5a+R5cQoUCqw94XYLihjChBVhkxK3tmlz1MYh99XsbZxXQmj/2Vn6f04tgm7zz7xygIKjzdbZSwJ77cFJ4qm/j+jWGsLAEABwUiI/W3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773321291; c=relaxed/simple;
	bh=D89zo2MNvGlZnd4KFWMq7kq+Acadbxg0c0e8BNDI/aQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AuSo0UbbjNtnzuQfql0/GxkcwGdHZbUVUa6SxbfOYava/WRGxAtoQrqHjuioMxE0G1r30ETcmUW5k0fObox6pHHYR7RGaEYqEF62q2JGI38lRVPMs2Mc+4ftmaB4KN46JODvORWuyi1JOfv9OaIqO1v5152UQ9ZkuXlxlYLsT5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fWp3w5qWnzKHMpr
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:14:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3F79540572
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:14:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_Ug8vLJpGVeVAg--.45112S12;
	Thu, 12 Mar 2026 21:14:39 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 8/8] ext4: fix possible null-ptr-deref in mbt_kunit_exit()
Date: Thu, 12 Mar 2026 21:12:53 +0800
Message-Id: <20260312131253.366296-9-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312131253.366296-1-yebin@huaweicloud.com>
References: <20260312131253.366296-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_Ug8vLJpGVeVAg--.45112S12
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4rXry3JF48Zw47Gr1UAwb_yoW8WFy8p3
	98CFyYgrW8ur1qyw47tryDAryIgws29F4UJryxC3WavFZxCryrAFn5KFyYqFW8uFW8Xa95
	ZF1jq34qgr1fAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjxUFgAwUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's issue as follows:
    # test_new_blocks_simple: failed to initialize: -12
KASAN: null-ptr-deref in range [0x0000000000000638-0x000000000000063f]
Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
RIP: 0010:mbt_kunit_exit+0x5e/0x3e0 [ext4_test]
Call Trace:
 <TASK>
 kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
 kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
 kthread+0x408/0x540
 ret_from_fork+0xa76/0xdf0
 ret_from_fork_asm+0x1a/0x30

If mbt_kunit_init() init testcase failed will lead to null-ptr-deref.
So add test if 'sb' is inited success in mbt_kunit_exit().

Fixes: 7c9fa399a369 ("ext4: add first unit test for ext4_mb_new_blocks_simple in mballoc")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/mballoc-test.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index c75b91ae0cf0..90ed505fa4b1 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -362,7 +362,6 @@ static int mbt_kunit_init(struct kunit *test)
 		return ret;
 	}
 
-	test->priv = sb;
 	kunit_activate_static_stub(test,
 				   ext4_read_block_bitmap_nowait,
 				   ext4_read_block_bitmap_nowait_stub);
@@ -383,6 +382,8 @@ static int mbt_kunit_init(struct kunit *test)
 		return -ENOMEM;
 	}
 
+	test->priv = sb;
+
 	return 0;
 }
 
@@ -390,6 +391,9 @@ static void mbt_kunit_exit(struct kunit *test)
 {
 	struct super_block *sb = (struct super_block *)test->priv;
 
+	if (!sb)
+		return;
+
 	mbt_mb_release(sb);
 	mbt_ctx_release(sb);
 	mbt_ext4_free_super_block(sb);
-- 
2.34.1

