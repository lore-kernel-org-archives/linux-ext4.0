Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D115387584
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773924994; cv=none; b=qkyl9Jk11FuF47xlJNcDK2U9u1gcgwar88ADgQTZhlVZBqdtUBznFbjGAgjBJVHEJX/wcLEeRHJJ3CnjxkDDegX0TyQUyRTRSo7oJ9aObQBqlk/HhYL2Znfh4FoRyucmMdADfcaG6aJAm1XQ9lvK3yQ7whmJ0sWeGB3n6i62KSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773924994; c=relaxed/simple;
	bh=+QDtAEsBI1gDchYuDE709d+T5ht/IFm2kEk7um0KS/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hg0yRzUxnRj6rKfrvxg09rVKtgW6Tg48+QCEQhGEEILS1iFourohzLqhpgMzGafe+pY63VrCvLue8iTYpigi0ZQgXg9JwdKcBp9KdIVnnLoZkZu4kwk2ElrK5rVw1+fwVF9o6p+QLa18MQEb4rbaWys+8OPI4dItcM5ujajiyUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fc5Jx2blgzYQtkh
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:55:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 61AF440594
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:56:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUx68rtpgy7uBQ--.23117S7;
	Thu, 19 Mar 2026 20:56:30 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v4 3/5] ext4: fix the error handling process in extents_kunit_init).
Date: Thu, 19 Mar 2026 20:54:32 +0800
Message-Id: <20260319125434.333117-4-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319125434.333117-1-yebin@huaweicloud.com>
References: <20260319125434.333117-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYUx68rtpgy7uBQ--.23117S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar18Gry8tr18Cw1rur1xZrb_yoW5JF4xpF
	93CFW5trWrZ3ZrCFZ3tr18AF13C3WFyr4xCry2vasIqayUZ3sYgw1xtryj9F909rW8Jr4Y
	va10qa17uF43CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxU2ApnDUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

The error processing in extents_kunit_init() is improper, causing
resource leakage.
Reconstruct the error handling process to prevent potential resource
leaks

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 fs/ext4/extents-test.c | 43 ++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 3d4663d99eb1..4ce3f81f6409 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -225,33 +225,37 @@ static int extents_kunit_init(struct kunit *test)
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
@@ -267,8 +271,10 @@ static int extents_kunit_init(struct kunit *test)
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
@@ -313,6 +319,19 @@ static int extents_kunit_init(struct kunit *test)
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
+	ext4_es_unregister_shrinker(sbi);
+	deactivate_locked_super(sb);
+	kfree(sbi);
+
+	return err;
 }
 
 /*
-- 
2.34.1

