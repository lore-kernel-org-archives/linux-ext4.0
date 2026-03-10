Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7A3BA239
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147961; cv=none; b=iJSt7DGfo5EB5rV7Z+pzeOPbtvhMY4PyUkN0rh030V+C/6NOPWXWdV/OIHXwfx6Unv5exdGx/k+AG8iqlaquSTsY6kgme4gaaEmANzGwwodqXzmfbcTIK4Wq937xjEHyjC4qgEPK1FQ4mak3mdzn8D8BC+ZZZ1e1n8py2XEv0cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147961; c=relaxed/simple;
	bh=0ugUEN80MBN+X5aKIDYa+3MchrXXFPnhXrxu93kPX3I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ehd2cH12faBpglYsmTbrSXDxyMW3On5z7NHSm8mI6JTm2rovQA7FtrDwhEy8Z9b5/wRDDzAZYaBkrtQwckePROZSLhXd16+m/u4gS88wBa8wkPOOS4I4kYEvvTAzkO4Zh/zmwTHwzY8aCviR4rZKjykxewzvoVZAPuYupGIC7Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fVYyG72HrzYQv9Q
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BDD104058D
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:05:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUwxF7BpaX6fAQ--.37695S10;
	Tue, 10 Mar 2026 21:05:56 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH -next 6/8] ext4: fix the error handling process in extents_kunit_init).
Date: Tue, 10 Mar 2026 21:04:10 +0800
Message-Id: <20260310130412.3156753-7-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCHYUwxF7BpaX6fAQ--.37695S10
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar18Gry8tr18Cw1rur1xZrb_yoW8Kr1DpF
	Z3CFW5KrWrZ3ZrCFZ3trn7AF13C3WFyr47CryavasFvayUZ34Fgw1ftr1jvF909rW8Xr4Y
	ya1qqa13ursxJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

The error processing in extents_kunit_init() is improper, causing
resource leakage.
Reconstruct the error handling process to prevent potential resource
leaks

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/extents-test.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 70d84c0a18e2..7e2796f72d45 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -222,33 +222,37 @@ static int extents_kunit_init(struct kunit *test)
 		(struct kunit_ext_test_param *)(test->param_value);
 	int err;
 
-	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
-	if (IS_ERR(sb))
-		return PTR_ERR(sb);
-
-	sb->s_blocksize = 4096;
-	sb->s_blocksize_bits = 12;
-
 	sbi = kzalloc_obj(struct ext4_sb_info);
 	if (sbi == NULL)
 		return -ENOMEM;
 
+	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
+	if (IS_ERR(sb)) {
+		kfree(sbi);
+		return PTR_ERR(sb);
+	}
+
 	sbi->s_sb = sb;
 	sb->s_fs_info = sbi;
 
+	sb->s_blocksize = 4096;
+	sb->s_blocksize_bits = 12;
+
 	if (!param || !param->disable_zeroout)
 		sbi->s_extent_max_zeroout_kb = 32;
 
 	/* setup the mock inode */
 	k_ctx.k_ei = kzalloc_obj(struct ext4_inode_info);
-	if (k_ctx.k_ei == NULL)
-		return -ENOMEM;
+	if (k_ctx.k_ei == NULL) {
+		err = -ENOMEM;
+		goto out_deactivate;
+	}
 	ei = k_ctx.k_ei;
 	inode = &ei->vfs_inode;
 
 	err = ext4_es_register_shrinker(sbi);
 	if (err)
-		return err;
+		goto out_deactivate;
 
 	ext4_es_init_tree(&ei->i_es_tree);
 	rwlock_init(&ei->i_es_lock);
@@ -264,8 +268,10 @@ static int extents_kunit_init(struct kunit *test)
 	inode->i_sb = sb;
 
 	k_ctx.k_data = kzalloc(EXT_DATA_LEN * 4096, GFP_KERNEL);
-	if (k_ctx.k_data == NULL)
-		return -ENOMEM;
+	if (k_ctx.k_data == NULL) {
+		err = -ENOMEM;
+		goto out_deactivate;
+	}
 
 	/*
 	 * set the data area to a junk value
@@ -310,6 +316,17 @@ static int extents_kunit_init(struct kunit *test)
 	up_write(&sb->s_umount);
 
 	return 0;
+
+out_deactivate:
+	kfree(k_ctx.k_ei);
+	k_ctx.k_ei = NULL;
+
+	kfree(k_ctx.k_data);
+	k_ctx.k_data = NULL;
+
+	deactivate_locked_super(sb);
+
+	return err;
 }
 
 /*
-- 
2.34.1

