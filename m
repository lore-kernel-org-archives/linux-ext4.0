Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6884AD7E0;
	Fri,  9 Oct 2026 10:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542251; cv=none; b=mJdriX01wiZslu9Rp5YzFLod6l336naABifRRRaHc9At+BpXjGTDXM5I6LSEJoVsIqatIlWV93bmWVGUMpLWDZqgTZp5VDIV0rc/4qN/Gxd+ZwmZso82b9kyDm8y21fDKCGZCnnk2QlKxnzBhS6YSI/kFwZwT/4IeRL33Wv2QWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542251; c=relaxed/simple;
	bh=bG78ErDTwMKI47WoKcfbCjECn8quNJpYfuXtVHxNl6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDvrWCQm1TIQs4etnR796n9VYv3OsTtQ3nmNGmsZsT59tsQxgQ6RBBMTmys7YckY2fqgHWpGD6iaAYZGY9zPJYJMJlX9oK1Rzrvnb4NfYyi9yps5a+RIBiN2zXNOh7/Fy0l9cBTnUlkdLUrCCDqBmAul8HAS9bJS1iUcOm3el0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZW2mHKzYQv43;
	Fri,  9 Oct 2026 18:36:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 903F640CDF;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S11;
	Fri, 09 Oct 2026 18:37:19 +0800 (CST)
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
Subject: [PATCH v7 07/31] ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents
Date: Fri,  9 Oct 2026 18:30:08 +0800
Message-ID: <20261009103033.2920530-8-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S11
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW8Jw1fuFWkJFyUJFWUArb_yoW8ZFWUpa
	sIkr1rGF48W343WaySyF4jgrWakw1xKFWUCF48try7ua43Kr1fKr1FqF1rGFWUKrWfAay5
	ZFWjk348C3Z5CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRRyxRDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

When ext4_map_blocks() finds an unwritten extent in the extent cache and
the caller is willing to accept unwritten extents without conversion,
there is no need to start a journal transaction since no metadata update
is required. This avoids unnecessary transaction overhead in the
upcoming iomap writeback path when overwriting already-allocated
unwritten extents.

One thing to be careful about, as the comment in ext4_map_blocks()
states, if the flags contain EXT4_GET_BLOCKS_CREATE, the function will
mark @map as mapped.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 553b767148c7b..6b0489cbb1319 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -812,14 +812,25 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * Note that if blocks have been preallocated
 	 * ext4_ext_map_blocks() returns with buffer head unmapped
 	 */
-	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
+	if (retval > 0) {
 		/*
-		 * If we need to convert extent to unwritten
-		 * we continue and do the actual work in
-		 * ext4_ext_map_blocks()
+		 * If we need to convert written extent to unwritten or
+		 * convert unwritten extent to written, continue and do
+		 * the actual work in ext4_ext_map_blocks().
 		 */
-		if (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
+		if (map->m_flags & EXT4_MAP_MAPPED &&
+		    !(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
 			goto out;
+		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
+		    (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) &&
+		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
+			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
+			ret = check_block_validity(inode, map);
+			if (!ret)
+				map->m_flags |= EXT4_MAP_MAPPED;
+			goto out;
+		}
+	}
 
 	if (!handle) {
 		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
-- 
2.52.0

