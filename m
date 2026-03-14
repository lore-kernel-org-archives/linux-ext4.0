Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6DA275B18
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474656; cv=none; b=tqVxvARjieaBQyfy5/RXEHx00ge18Zib3L8rvRozklL6wnZKtaIY3m3IdjL/yUzYm2gkVvW4HugGoF0Aa/trrMHZ2PgrU17iK2i7neUzXkNjmHQLAoQfFYNJC/lYShpJx4GJizOeLfGoYYEKErqDOAXTPlz5UcCibfVsqAWGYw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474656; c=relaxed/simple;
	bh=nzYEMQqjtAQtr1Zz8Sv2s+uafonlSR/qW5iG+pq2WRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R/BdJ6Qx2ASoi8Cvwbi2IjLfVNfOjK40AD5zFUk4tFOdch3J2B6lOyr+nkJvmBeo2rHSbSf3H8YunGD1hgtRhG5rztVi3MfdvQJY5qyee8CEGEZQQ2AjSXLUQvzWlv9W8n77sQpJhmpM1E7FvpXV995D9tiJul7+a9FWPJfS9+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fXtnK2s1mzKHMck
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 963234058F
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhZE7Vpm1BvAw--.31250S8;
	Sat, 14 Mar 2026 15:50:50 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v3 4/5] ext4: fix possible null-ptr-deref in extents_kunit_exit()
Date: Sat, 14 Mar 2026 15:49:02 +0800
Message-Id: <20260314074903.1314851-5-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDX_UhZE7Vpm1BvAw--.31250S8
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyrtw48CF1fCr1ruw1fCrg_yoW8GFykpr
	sxCF4jgr48Zw1DCFWxGFyUJryakan7uFW7uryxJa13KayDCry8tryjkr1UtFW5XF48XFyY
	9F40v3yUK3W3KaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvKb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x07jeVbkUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's issue as follows:
KASAN: null-ptr-deref in range [0x00000000000002c0-0x00000000000002c7]
Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
RIP: 0010:extents_kunit_exit+0x2e/0xc0 [ext4_test]
Call Trace:
 <TASK>
 kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
 kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
 kthread+0x408/0x540
 ret_from_fork+0xa76/0xdf0
 ret_from_fork_asm+0x1a/0x30

Above issue happens as extents_kunit_init() init testcase failed.
So test if testcase is inited success.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/extents-test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 543236a31e13..6ae72986ca9c 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -142,9 +142,12 @@ static struct file_system_type ext_fs_type = {
 
 static void extents_kunit_exit(struct kunit *test)
 {
-	struct super_block *sb = k_ctx.k_ei->vfs_inode.i_sb;
-	struct ext4_sb_info *sbi = sb->s_fs_info;
+	struct ext4_sb_info *sbi;
 
+	if (!k_ctx.k_ei)
+		return;
+
+	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
 	ext4_es_unregister_shrinker(sbi);
 	deactivate_super(sbi->s_sb);
 	kfree(sbi);
-- 
2.34.1

