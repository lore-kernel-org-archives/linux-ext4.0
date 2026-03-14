Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963E4275B18
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474661; cv=none; b=me9frmqjOmfmWB6unTAdSEXMYO1ZNhD+9HhSLd33WPHV1f2nYswH1R17gq9j/fqF4I19YVmAstjYRlKcnHAJ19Kvo0o7YEm/GffdP4jZF/oo3J03Gw3U0/KbVRniVcNCPSeYYYeD3BsZT6qbhqQRt0JbNe9Rh68pAljmBm+V+uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474661; c=relaxed/simple;
	bh=D89zo2MNvGlZnd4KFWMq7kq+Acadbxg0c0e8BNDI/aQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rBE6g7uQHePfv/ClsDxHy6UwLUEqB51ZYjdW9eDFsmgnKwuFcXOqgR+YunaLKGb3sOZQsImMZ5Nl4PtKRgJpRdD9xHdfchZWF7cj/TjZIu/YoR997wOUSPLem961nr65gpg3L58MNB4R436XAham5grefT3quvjPrvfNrT04Ujo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fXtmk3VL3zYQtnw
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:49:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A939F40562
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhZE7Vpm1BvAw--.31250S9;
	Sat, 14 Mar 2026 15:50:50 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v3 5/5] ext4: fix possible null-ptr-deref in mbt_kunit_exit()
Date: Sat, 14 Mar 2026 15:49:03 +0800
Message-Id: <20260314074903.1314851-6-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260314074903.1314851-1-yebin@huaweicloud.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_UhZE7Vpm1BvAw--.31250S9
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4rXry3JF48Zw47Gr1UAwb_yoW8WFy8p3
	98CFyYgrW8ur1qyw47tryDAryIgws29F4UJryxC3WavFZxCryrAFn5KFyYqFW8uFW8Xa95
	ZF1jq34qgr1fAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvKb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x07jeVbkUUUUU=
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

