Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E09D3B9DB2
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147961; cv=none; b=Ax+zlJ5dU81+21FVS8ffVUizDwqL80OnKXWmMnhoe1uebfBL5/fTyXGGqsMd5cOyKb9WgyxU/AkLawvfcsjA26K3CTpwrDXo8XwItZqATbffAXVM9rGD8VOV+nMbr+7tZPYLQegAL8n6C0MQ8bkish11pG19WACs+l1aYu+CLGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147961; c=relaxed/simple;
	bh=K4lMAB5iyM1tKT1ql1roLVcmrucwGvXHJGf4wJXn0UU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g1U9ngSHTTT/EEVweDvxmxsIY9tUqRD8R+pkyoz72j95G3CMcPjw2yB25izDRj9tOJvLuwXq0CcETaBg6XdkNhGZF901ZC5Mf4YnbuHA43GhV1/z1jPtM2avhk8kBbcFUdHhawHIeV365ry/JcduUw2ZztyNN408Urs+2Hr26b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVYys3Px8zKHMqJ
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C39784058F
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUwxF7BpaX6fAQ--.37695S11;
	Tue, 10 Mar 2026 21:05:56 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH -next 7/8] ext4: fix possible null-ptr-deref in extents_kunit_exit()
Date: Tue, 10 Mar 2026 21:04:11 +0800
Message-Id: <20260310130412.3156753-8-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310130412.3156753-1-yebin@huaweicloud.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYUwxF7BpaX6fAQ--.37695S11
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyrtw48CF1fCr1ruw1fCrg_yoW8GrW3pr
	sxAF4j9r4rZw1DCFWxGFyUJryaka92kFW7uryxJF43KayUury8KryUtr1jqFW5XF48XFy5
	Ar40v34UK3ZxG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjxUFgAwUUUUU
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
 fs/ext4/extents-test.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 7e2796f72d45..b1ea37e74f12 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -142,8 +142,12 @@ static struct file_system_type ext_fs_type = {
 
 static void extents_kunit_exit(struct kunit *test)
 {
-	struct ext4_sb_info *sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
+	struct ext4_sb_info *sbi;
 
+	if (!k_ctx.k_ei)
+		return;
+
+	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
 	deactivate_super(sbi->s_sb);
 	kfree(k_ctx.k_ei);
 	kfree(k_ctx.k_data);
-- 
2.34.1

