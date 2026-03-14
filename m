Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632A261388
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474661; cv=none; b=HCnmouiVHwxzoHWPn/yFdnNbjcqm6dsutAWeKTqMYlSY3UToTVN9SdG+TXDVUlIVPDfWrmIFJBz0IHumk1iCwy5k48uWxHKpUWs1521hRVRnJJxO9QDOyL95yztY8XQdshhSATYXcVSdGeglCuSkiFc0P9Ieuqj1/FFKI9Iw8hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474661; c=relaxed/simple;
	bh=nHRuPa0qzhHax+xDe+Q2GflmIr3xr4I5fhT3wb7+Phk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U53COBCLi/pIKBcnOwC8Lws97rQQ9zdNdm4oT+HzwMVTyT36L1YV1PVl20cX88Qfs1hA5XrpiQtOeGvRI05o0v7RHDWZd8uh6GI7UEQ55SczwMnlWoINfNAH/HmzpvHHz5mm5tzidN1VUC0s4+aRUgAXEH6dq33fTYar58jA6/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fXtmk2n2HzYQv1Q
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:49:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 90ECC40574
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 15:50:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_UhZE7Vpm1BvAw--.31250S7;
	Sat, 14 Mar 2026 15:50:50 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v3 3/5] ext4: fix the error handling process in extents_kunit_init).
Date: Sat, 14 Mar 2026 15:49:01 +0800
Message-Id: <20260314074903.1314851-4-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDX_UhZE7Vpm1BvAw--.31250S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar18Gry8tr18Cw1rur1xZrb_yoW8KFWDpF
	Z3CFW5tr4rZ3ZrCFZ3tF18AF13C3WFyr4xCry2vasIyayUZ34Fgw1xtryj9F909rW8Xr4Y
	va10qa13ursxCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07jec_-UUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

The error processing in extents_kunit_init() is improper, causing
resource leakage.
Reconstruct the error handling process to prevent potential resource
leaks

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/extents-test.c | 44 ++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 3d4663d99eb1..543236a31e13 100644
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
@@ -313,6 +319,20 @@ static int extents_kunit_init(struct kunit *test)
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
+	if (sbi->s_es_shrinker)
+		ext4_es_unregister_shrinker(sbi);
+	deactivate_locked_super(sb);
+	kfree(sbi);
+
+	return err;
 }
 
 /*
-- 
2.34.1

