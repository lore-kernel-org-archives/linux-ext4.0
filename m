Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85243C3C01
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 12:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773925000; cv=none; b=ZeVeiwI+uFAn4cjCNdE69FLj/EOwVmlldHxEpkHoGf+joYsPie6G6VRj+SjbSSlIH8GIkeOxbAJxviX/OfzV2+3lWWWvqXe8J8+L75pF0RnzpDd2k6rNSYkzotuOpi3XuN+Cklpkg6MZ4OrpqW8gP6NVGVGMvG8B9C59i4VI2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773925000; c=relaxed/simple;
	bh=UrkU601mK+7zNpXdJ7lEV4EWHgJGvVsn8wb02sWGaao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=homoo57ZYiaLZ5Sn14ZZO3y4ZtnmPH0Pkyf2GvbohDdSX+ivMqWJIgB6qCHviwNfLDsUBZVFrPIMRHKdwJJwMJHZtt6SW+DRBBJyhhf8a5zVAfyVVIloxNk5G6F/EEtR1A2++aCAO1KLBKxSCBeXHJOt9P2ZN/tNg9OgKSQszQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fc5KX6v9wzKHMMR
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:56:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4B0B04056F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:56:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUx68rtpgy7uBQ--.23117S6;
	Thu, 19 Mar 2026 20:56:30 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v4 2/5] ext4: call deactivate_super() in extents_kunit_exit()
Date: Thu, 19 Mar 2026 20:54:31 +0800
Message-Id: <20260319125434.333117-3-yebin@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCHYUx68rtpgy7uBQ--.23117S6
X-Coremail-Antispam: 1UD129KBjvdXoWruFWUuF4ktF48CrW3KFyxGrg_yoW3KrX_Aa
	47Cr1kWr4ayr18ua1rAryUX3WIka1xKF43XF17CF95ua4fXr4kJrnFqrn3ury5Crs8Jr9x
	trsxtr109Fy8ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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

