Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF4525A354
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774877578; cv=none; b=A8e8HNhz4sHcZDTpemFQJirImosIfAMMma9XXYAifcOkcoyNJdqqZI4UBgHKWDW6SlORAS3kpSYUkc8bcSYN2xy4f0sfWZv+KaELGWLA3NDloFTKV9YG1o61cHvkR8SnuHFfWKwph8HrEriUxQ3VYxoQrqNIf1NUZGCZ3EdefiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774877578; c=relaxed/simple;
	bh=PweKi1LkHN53l91mRWaOS45P8ZaWufFHSCc4hU7YNrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nNQZsNukP3RMJcf1lNX+5WI1gNpj7bxihXvFbi/JL135QwKWIdGyf8AcMPLDEOFwznkLJweRNVFh9R3L0/Bfr+rfLkVxEq7NN5VQVhGJOh0WXtt//Xw+SFiC0PunggDFP9gatzZZEYabSK75zo1ht8FS1aMzNMPsENA45iEKk6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fkscY67XZzYQtLf
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 21:32:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BF98B4058C
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 21:32:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDHn0p7e8pp7U0sCw--.17260S6;
	Mon, 30 Mar 2026 21:32:48 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v5 2/5] ext4: call deactivate_super() in extents_kunit_exit()
Date: Mon, 30 Mar 2026 21:30:32 +0800
Message-Id: <20260330133035.287842-3-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260330133035.287842-1-yebin@huaweicloud.com>
References: <20260330133035.287842-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHn0p7e8pp7U0sCw--.17260S6
X-Coremail-Antispam: 1UD129KBjvdXoWruFWUuF4ktF48CrW3KFyxGrg_yoWfArb_Aa
	47Cr1kWr4ayr18ua1rAr9rX3Z2ka1IgF13XF17CF95ua43Xr4kJFnFgrn3Zry5Cr4DJr9x
	trsxJr109Fy8ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbV8YFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
	8IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07URpBfUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Call deactivate_super() is called in extents_kunit_exit() to cleanup
the file system resource.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 82c59291e045..3d4663d99eb1 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -146,6 +146,7 @@ static void extents_kunit_exit(struct kunit *test)
 	struct ext4_sb_info *sbi = sb->s_fs_info;
 
 	ext4_es_unregister_shrinker(sbi);
+	deactivate_super(sbi->s_sb);
 	kfree(sbi);
 	kfree(k_ctx.k_ei);
 	kfree(k_ctx.k_data);
-- 
2.34.1

