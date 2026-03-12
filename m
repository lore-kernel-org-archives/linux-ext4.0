Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A373C6616
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773321291; cv=none; b=QLIxVsWIQ+o39AlZJKFoqSlnyaviWXQ+GbofvxTbNVdMKC/rn3QQ6K6VgzTU+I011rfPa+55TGOYsYcMSMr7MXllSW/NHfaR+EWpQuNba5oBXjISguAIZy8GFYHYWTdPTsiI63O261PuKmw8ygsXe5G7cdgPsI1lgr01vnxKT/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773321291; c=relaxed/simple;
	bh=/PZetG2PW4tgqszt3+wifOxv229sHsQagqoe5EoLt20=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=khj7jO5meEi8nvOBWt+J6NP3ERh/LE8fg+nOjfShcXiresK7WL4b+T2xRBojUKnSvL8dIvch1J/suAfwnBvu6OEk6H+DGDu4qTDb9w/O/ztmRmEnImA1zly9leMt9L6kjYvvk+RG9TFxDWl0kc55ry9n7y3aFW0w+8vmkM/4Mx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fWp3K6brzzYQv7b
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:13:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1CD9D40591
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:14:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_Ug8vLJpGVeVAg--.45112S9;
	Thu, 12 Mar 2026 21:14:39 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 5/8] ext4: fix miss free super_block in extents_kunit_exit()
Date: Thu, 12 Mar 2026 21:12:50 +0800
Message-Id: <20260312131253.366296-6-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDX_Ug8vLJpGVeVAg--.45112S9
X-Coremail-Antispam: 1UD129KBjvJXoW7trWrtw4rGF45tr1fArykGrg_yoW8Gr15pr
	ZxAF1jkr48uw1qkFZrJF1kJryfCa1DCr4UuryfAF43KFZxC340kFyYkF1jgFW5XFW8Jrn8
	ZF4qq3y5Za13Ga7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjxU2CJmUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's issue as follows:
ODEBUG: free active (active state 0) object: ffff88812f2d68a0 object type: percpu_counter hint: 0x0
 <TASK>
 debug_check_no_obj_freed+0x3d9/0x4d0
 kfree+0x2bb/0x6c0
 extents_kunit_exit+0x65/0x90 [ext4_test]
 kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
 kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
 kthread+0x408/0x540
 ret_from_fork+0xa76/0xdf0
 ret_from_fork_asm+0x1a/0x30

The above issue was caused because the super_block cleanup process
was not properly performed.
Therefore, deactivate_super() is called in extents_kunit_exit() to
cleanup the super_block.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/extents-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 5a5016ea1ecc..70d84c0a18e2 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -144,7 +144,7 @@ static void extents_kunit_exit(struct kunit *test)
 {
 	struct ext4_sb_info *sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
 
-	kfree(sbi);
+	deactivate_super(sbi->s_sb);
 	kfree(k_ctx.k_ei);
 	kfree(k_ctx.k_data);
 }
-- 
2.34.1

