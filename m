Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4214B8269;
	Fri,  9 Oct 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542253; cv=none; b=PB6aaYrw9fLw41hCK4MGY0R152NrknJXhVIn3wsgn5NC1GI1fU5BeNtY42j76/GkTP/s8sKJcVWrGtxW4DZgYLTd8LASPHsxRnmMDowZLmhkZzuBzT32/A6rlubY5F2l8bFjBpmAshxUp4CeogSIy4uyZpoxQAzgW6iYzFDkQ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542253; c=relaxed/simple;
	bh=lkgSarX/R4JKQZcW5M99Ga7QotJN2lLMZwmp+LjGMEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG0aDJV2D2UBQ0RRP/yiVYAsWFFz2/J4QQ/PRGe91ynJHH0M+E9oPlST7pIZoSP0cwQulgSfkDu1lr5ERfXmBRSIQS7/fSDtTUIeHdKFnj7AHf56kBA9DzxmzbbKFfnqlOQRScthEd7Vd+t0tup+DF+zOBrMBd5tRT4s8zb77+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZW3HD3zYQtt5;
	Fri,  9 Oct 2026 18:36:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A436640CC3;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S12;
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
Subject: [PATCH v7 08/31] ext4: skip block allocation for holes in the data submission path
Date: Fri,  9 Oct 2026 18:30:09 +0800
Message-ID: <20261009103033.2920530-9-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S12
X-Coremail-Antispam: 1UD129KBjvJXoWxAFyxXr18XF4DKw1kCryfJFb_yoW5WrW5pr
	9Ikry5Cr1qga43ua93A3W7JFySkw1rGFW7WFWfJrW5u3sxKF1SqFy5t3WYvFW8trWxJFWj
	qF4F9Fy8CFyvyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

When ext4_map_blocks() is called from the data submission path and I/O
end extent conversion path (EXT4_GET_BLOCKS_IO_SUBMIT), it should not
allocate blocks if the lookup returns a hole.

The writeback path can legitimately encounter dirty ranges that map to
holes. For example, when a folio straddles i_size and the tail beyond
i_size is dirtied via a mmap write. Allocating blocks for such ranges is
wrong because there is no data to write back, the dirty bits should
simply be discarded without submitting I/O.

This prepares for the buffered iomap writeback conversion, mirrors the
existing buffer_head writeback path, where mpage_add_bh_to_extent() skip
unmapped buffers and ext4_bio_write_folio() clears their dirty bits.
Since ext4_map_blocks() can now return zero for a hole,
mpage_map_one_extent() must handle it as well. However, because those
holes are already filtered out by mpage_add_bh_to_extent(), it only maps
buffers that are delayed or unwritten, so a hole can never occur in
normal operation. Add a WARN_ON_ONCE() and bail out with -EINVAL rather
than proceeding with an invalid physical block number of zero.

In the ioend extent conversion path, holes are also not expected because
we should wait for folio writeback before punching hole. If one is
encountered, it likely indicates a failure in the concurrency
protection, so ext4_map_blocks() returns zero, and we keep warning and
bail out with -EINVAL to surface the failure rather than continuing
conversion on torn data. Atomic writes in
ext4_convert_unwritten_extents_atomic() already bail out similarly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6b0489cbb1319..778cf539f6df2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -830,6 +830,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 				map->m_flags |= EXT4_MAP_MAPPED;
 			goto out;
 		}
+	} else if (retval == 0) {
+		/*
+		 * Do not allocate blocks for holes in the context of
+		 * data submission path.
+		 */
+		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
+			goto out;
 	}
 
 	if (!handle) {
@@ -2428,6 +2435,12 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
 	if (err < 0)
 		return err;
+	/*
+	 * A hole? This should never happen since mpage_add_bh_to_extent()
+	 * has filtered it out.
+	 */
+	if (WARN_ON_ONCE(!err))
+		return -EINVAL;
 	if (dioread_nolock && (map->m_flags & EXT4_MAP_UNWRITTEN)) {
 		if (!mpd->io_submit.io_end->handle &&
 		    ext4_handle_valid(handle)) {
-- 
2.52.0

