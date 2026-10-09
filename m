Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5AC4B826B;
	Fri,  9 Oct 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542253; cv=none; b=Jdy7SxVgu/4m++eIPbHgSlrOgv10E4K1wXlWY52I4h83gy90kFz9I4CRQBGKi2yxo8IdyJ5uTiPzMhEfh6qkrLPDM5WV2gbRXU/X4Ebmhp11P4HMHuQGkGTk7DBD6QIpkxuqWxgdgGMexstURz2ioDwV8oPkoNNHcmj337+gUKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542253; c=relaxed/simple;
	bh=StYDm4BzQfpBVFinc8SapzjJBAtq3EMYWUYFEwxs49k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTQw3h2Fmi3M1cNAhzFq5ig2HP18XYeDl5beVkrWimBhVrLnRflsgjnqQT5sGP/LLu8iamKp44OqHag3BtNOcFi3+h7eJCsFjWOWtMOfb7GjVQz2fHMolDWKqg5GafKHnftdq7qlshIMvRD0R+n3fCkXkbi1OhmtJoquO34NGmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZW4ccYzYQv1S;
	Fri,  9 Oct 2026 18:36:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D4F9D40561;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S14;
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
Subject: [PATCH v7 10/31] ext4: implement buffered read path using iomap
Date: Fri,  9 Oct 2026 18:30:11 +0800
Message-ID: <20261009103033.2920530-11-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S14
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW3tr4DXry8JFWkKryUZFb_yoW5Ww43pF
	90kFy5Gr47Wr9F9F4SqFZrAr1Yka1xJa1UWrWfGwnxWF90krW2gayUKF1Yva15t3y7Ar48
	XF4Ykry8Wa1UArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRRyxRDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Implement the iomap read path for ext4 by introducing a new
ext4_iomap_buffered_read_ops instance. This provides the read_folio()
and readahead() callbacks for ext4_iomap_aops. The implementation
introduces:

 - ext4_iomap_map_blocks(): Helper function to query extent mappings for
   a given read range using ext4_map_blocks() and convert the mapping
   information to iomap type
 - ext4_iomap_buffered_read_begin(): The iomap_begin callbacks that maps
   blocks, validates filesystem state, and populates the iomap. It
   returns -ERANGE for inline data which is not yet supported.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fc2aae64e2fb0..2d6494c5b56c1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3969,14 +3969,60 @@ const struct iomap_ops ext4_iomap_report_ops = {
 	.iomap_next = ext4_iomap_next_report,
 };
 
+static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
+		loff_t length, struct ext4_map_blocks *map)
+{
+	u8 blkbits = inode->i_blkbits;
+
+	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
+		return -EINVAL;
+
+	/* Calculate the first and last logical blocks respectively. */
+	map->m_lblk = offset >> blkbits;
+	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
+			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
+
+	return ext4_map_blocks(NULL, inode, map, 0);
+}
+
+static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
+		loff_t length, unsigned int flags, struct iomap *iomap,
+		struct iomap *srcmap)
+{
+	struct ext4_map_blocks map;
+	int ret;
+
+	if (unlikely(ext4_forced_shutdown(inode->i_sb)))
+		return -EIO;
+
+	/* Inline data support is not yet available. */
+	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
+		return -ERANGE;
+
+	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
+	if (ret < 0)
+		return ret;
+
+	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
+	return 0;
+}
+
+static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_read_next,
+			      ext4_iomap_buffered_read_begin);
+
+static const struct iomap_ops ext4_iomap_buffered_read_ops = {
+	.iomap_next = ext4_iomap_buffered_read_next,
+};
+
 static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
 {
+	iomap_bio_read_folio(folio, &ext4_iomap_buffered_read_ops);
 	return 0;
 }
 
 static void ext4_iomap_readahead(struct readahead_control *rac)
 {
-
+	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
 }
 
 static int ext4_iomap_writepages(struct address_space *mapping,
-- 
2.52.0

