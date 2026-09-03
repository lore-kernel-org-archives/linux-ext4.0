Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910594A0143;
	Thu,  3 Sep 2026 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439378; cv=none; b=scbKJwPJ1igBuw9naTYMCsym96qeaSalzYlq4XXInVVkqb6t29FPGxYHqnWO/WjKz4owXF5FjGD0JWqofk+4gckYJb5hZ0aaZFabQjfny4E6x0QyJk7NjrR5geGKEp/xHWlFrX4XLuZ6wUTld01ov1Fs1njp/nZ2Dmr3Jq6IPy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439378; c=relaxed/simple;
	bh=eeU2X+A53ny4ZjUEOZK6rDsl02afkbeqeZMhC98FBzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqHQdosh14f1E06uD2R943bcgwy8vgkcIONKf2Hs/r+itVdkimlyp1BFBiLldWsmG+e5LCXo3tqQgI5CA2DqyLD4LhPpaCCe3ophr5Qpfyq8EUbiTp6hNaGm23+ILmaW7SCOHKiny7tWddvLSs/C6pFj2LK+DqRJLpnd0rZRBgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3n4qdPzKHMlT;
	Thu,  3 Sep 2026 20:41:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 554A34056E;
	Thu,  3 Sep 2026 20:42:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S13;
	Thu, 03 Sep 2026 20:42:51 +0800 (CST)
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
Subject: [PATCH v6 09/31] ext4: skip block allocation for holes in the data submission path
Date: Thu,  3 Sep 2026 20:35:21 +0800
Message-ID: <20260903123543.2302999-10-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S13
X-Coremail-Antispam: 1UD129KBjvJXoW7tF13CF4UGr47Xr15WFyUWrg_yoW8CF1kpr
	9xKry5Gr1DW3Wakan3Z3W7Ja4jka4rGFW7GFWfJ3yUXry3GF1IqFWUK3WYyFW8KrWxJFWI
	vF4F9ry8GFykA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTR_nYFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

When ext4_map_blocks() is called from the data submission path and I/O
end extent conversion path (EXT4_GET_BLOCKS_IO_SUBMIT), it should not
allocate blocks if the lookup returns a hole.

The writeback path can legitimately encounter dirty ranges that map to
holes. For example, when a folio straddles i_size and the tail beyond
i_size is dirtied via a mmap write. Allocating blocks for such ranges is
wrong because there is no data to write back, the dirty bits should
simply be discarded without submitting I/O. This prepares for the
buffered iomap writeback conversion, mirrors the existing buffer_head
writeback path, where mpage_add_bh_to_extent() skip unmapped buffers and
ext4_bio_write_folio() clears their dirty bits.

In the ioend extent conversion path, holes are also not expected because
we should wait for folio writeback before punching hole. If one is
encountered, it likely indicates a failure in the concurrency
protection, so ext4_map_blocks() returns zero, and we keep warning and
bail out with -EINVAL to surface the failure rather than continuing
conversion on torn data. Atomic writes in
ext4_convert_unwritten_extents_atomic() already bail out similarly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7a5c74af8ff3..2881596bff8b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -825,6 +825,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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

