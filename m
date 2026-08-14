Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5BC37A83F;
	Fri, 14 Aug 2026 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700396; cv=none; b=LBPvk3ZIIHWCCuBsZRLclN1oN9qSgwfR4y0ypnypPtiUzP+kiNyRYJkyPsR2Wh+2ke8TZd9pWGPuk35PziHOSCWMRrpWdLE6Ydv+6I+LMRphgrNTikVOrB4Fuse7GcV49SYeAMcZny7onrAajIpj1vgeq8RlK+3bzqJGaeWJHTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700396; c=relaxed/simple;
	bh=H1oWZGvtPgJom00NhUthqXLncw8xGcA4wK1lsyNMcgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOOqWoXStJsT53bgqVquUeUJT8jtUZQZoaUje0+9ef04yyWGT6QXVbi/6YZAzZJ4RgU575O73xZNwoGhoRMwXDwG9ei4J57hQ0C4PBBEP/HK219/u79/vj0kLX/mvqYRhSx5IJsPoz+FrmpZzMzOGpnKyhQpyzID7mxUyRwbu/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyg64TKzYQvPN;
	Fri, 14 Aug 2026 17:39:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 17A7C40571;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S13;
	Fri, 14 Aug 2026 17:39:47 +0800 (CST)
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
	yukuai@fnnas.com
Subject: [PATCH -next v5 09/32] ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents
Date: Fri, 14 Aug 2026 17:33:08 +0800
Message-ID: <20260814093331.1703882-10-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S13
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW8Jw1fuFWkJFyUJFWUArb_yoW8Cw1fpa
	sIkr1rCF40g343WaySyF4jgFWakw1xKFWDuF48KryUZa43Kr1SgF10qF1rGFWUKrWfAay5
	XFWjkw18C3Z5CrDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Ar0_tr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNF4EDUUUU
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
---
 fs/ext4/inode.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c9904c274347..5dcc3f7b2ffd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -807,14 +807,23 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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
 			goto out_handle;
+		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
+		    (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) &&
+		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
+			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
+			map->m_flags |= EXT4_MAP_MAPPED;
+			goto out_handle;
+		}
+	}
 
 	if (!handle) {
 		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
-- 
2.52.0

