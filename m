Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F094A0122;
	Thu,  3 Sep 2026 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439379; cv=none; b=aiHgbjCILqRfrR47M36eUsAiglyUSr10yKSFkLr61WkL8Is8yFb0ARhKBdZLVEI2/QXZygg04daV34tzCzY7KCLBPVGHfDKfjf419D7uy/qf4OeRGewAiwj6Sg100PgvZKCYoHUi27MNbHjvuzYuYgdll6Uf0WNi75DUpewfF3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439379; c=relaxed/simple;
	bh=tkByzAuijsPn4wdRJhGoh7ay3aJr9nw5VOb/YM5MwSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smqG2rfipQKPWnKCH0bFGDXSn8rz0AlQvhXtfz2Xs+zN74fset7Kqt8VaIWe7vlhg/KkjLWd7nPwKKQe1MRQcOhWsVMQXdxlKLS9/1KvVjJvIgfSwJU7nDcU9aQ1h1dmfulaNUYNPqqbA52/5CwtSbDA4pL4Yr5VPo8GNRQp4ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3n2mDFzKHMlJ;
	Thu,  3 Sep 2026 20:41:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 0A14840561;
	Thu,  3 Sep 2026 20:42:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S10;
	Thu, 03 Sep 2026 20:42:50 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v6 06/31] ext4: fix orig_mlen initialization in ext4_map_blocks()
Date: Thu,  3 Sep 2026 20:35:18 +0800
Message-ID: <20260903123543.2302999-7-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S10
X-Coremail-Antispam: 1UD129KBjvdXoWrZF4xur1UAF1fAF1rtr13urg_yoWkGFcEqa
	y2vr48Gw4rArnakr4kZF4fJFyvka48Wr18CFW7Xry0qFnYyFZ5Xw1vvF9rAr4DW3yYvrZ5
	ZFy8J34fKFW7ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb98FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRJ3kZUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Save orig_mlen after clamping map->m_len to INT_MAX. Otherwise, the
unclamped value may be passed below, bypassing its overflow protection.

Fixes: 5bb12b1837c0 ("ext4: Add support for EXT4_GET_BLOCKS_QUERY_LEAF_BLOCKS")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b71b1d2588ae..73af6d386985 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -703,7 +703,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	struct extent_status es;
 	int retval;
 	int ret = 0;
-	unsigned int orig_mlen = map->m_len;
+	unsigned int orig_mlen;
 #ifdef ES_AGGRESSIVE_TEST
 	struct ext4_map_blocks orig_map;
 
@@ -719,6 +719,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (unlikely(map->m_len > INT_MAX))
 		map->m_len = INT_MAX;
+	orig_mlen = map->m_len;
 
 	/* We can handle the block number less than EXT_MAX_BLOCKS */
 	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
-- 
2.52.0

