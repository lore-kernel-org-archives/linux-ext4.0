Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500EC436BCE;
	Fri, 14 Aug 2026 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700407; cv=none; b=qp3g3KVftB5jFIB0/JoptuQi9hLLY0wzgRmGr/Db21DxtAL7bTyk1Gbs2/E06vqwZPIh9utR+ojJUa+u1qS8ACBFSlY0INt3GMVkdx6JL/9ioLGqeHXe+w31pnxcUnqWpC4RRxLGK7hMO4dnXqQt+MRRKdPv88NTEWYXvORuw1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700407; c=relaxed/simple;
	bh=ZUs5OSB0xwNvtzbSBvm0XwZqA//Lf5s0xp6XF97fK50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkTbYfojJVFUTuQ8AKWeUgTqV6JQ3/ZUjGXA/BFw1SpVO/Px6ZGhp1xyyoKOVBL60vfo+ZIzkfMSaPvHxH9/0F3KUa8F2eiV3eu2xjU09SKMxEa+DdeAoQHmFnF2KWjbaM6bkby/fjsKEi32tqtWW+sTw2mr3mqj8oi3TsGTDHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyR35r3zKHNM0;
	Fri, 14 Aug 2026 17:39:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 2B6964056B;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S14;
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
Subject: [PATCH -next v5 10/32] ext4: skip block allocation for holes in the data submission path
Date: Fri, 14 Aug 2026 17:33:09 +0800
Message-ID: <20260814093331.1703882-11-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S14
X-Coremail-Antispam: 1UD129KBjvJXoWxAFyxXr18XF17GF1DJFW5KFg_yoW5Jw43pr
	9IkryrGr4qgw1a9a97Ca1UXF1Yk3WxGF47CFWrJrWjgry3JF1SqFWUK3WYyFWrKrW8XFWS
	qF4F934rAr9Yy3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

When ext4_map_blocks() is called from the data submission path and I/O
end extent conversion path (EXT4_GET_BLOCKS_IO_SUBMIT), it should not
allocate blocks if the lookup returns a hole.

The writeback path can legitimately encounter dirty ranges that map to
holes. For example, when a folio straddles i_size and the tail beyond
i_size is dirtied via a mmap write. Allocating blocks for such ranges is
wrong because there is no data to write back, the dirty bits should
simply be discarded without submitting I/O. This mirrors the existing
buffer_head writeback path, where mpage_add_bh_to_extent() skips
unmapped buffers and ext4_bio_write_folio() clears their dirty bits.

In the ioend extent conversion path, holes are also not expected because
we should wait for folio writeback before punching hole. If one is
encountered, it likely indicates a failure in the concurrency
protection. In this case, to avoid losing data beyond the hole, do not
stop conversion, continue on the remaining ranges. This prepares for the
buffered iomap writeback conversion.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 8 ++++++--
 fs/ext4/inode.c   | 7 +++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6c3655..0d62d9312284 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5167,11 +5167,15 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
 				      EXT4_EX_NOCACHE);
 		if (ret <= 0) {
+			/*
+			 * If the ret is zero, an unexpected hole may cause
+			 * conversion to fail.  To avoid data loss during I/O
+			 * end conversion, skip the hole and continue
+			 * converting subsequent blocks.
+			 */
 			ext4_warning(inode->i_sb,
 				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
 				     inode->i_ino, map.m_lblk, map.m_len, ret);
-			if (unlikely(ret == 0))
-				ret = -EINVAL;
 		} else {
 			conv_blocks += map.m_len;
 		}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5dcc3f7b2ffd..d8c3e5e13b8a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -823,6 +823,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			map->m_flags |= EXT4_MAP_MAPPED;
 			goto out_handle;
 		}
+	} else if (retval == 0) {
+		/*
+		 * Do not allocate blocks for holes in the context of
+		 * data submission path.
+		 */
+		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
+			goto out_handle;
 	}
 
 	if (!handle) {
-- 
2.52.0

