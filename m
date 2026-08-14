Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E971843B3D5;
	Fri, 14 Aug 2026 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700408; cv=none; b=V9Aew4VPQrW7qYI/nBKpCbIsQNWbKNeAnHN7P+s3kDJli7tjz/SK7J5DOZKSkag+ifalLQFBXEbFnFuTejeEjUmRTQ0KzlTY8KYuH72dBhD6L914L5PTe0V7ideLhEl5H8CNnr4c1ViQ7htZPKGfW4T9byNuB9vrgDX7n22OV74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700408; c=relaxed/simple;
	bh=FZtNPEg5aF+ddVQ22+g1fVIG2upqmDvAOr2Tqs5h1pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alqaYoLAwHORRvUG8xWF/Z2+MtpvFtb8LqBRg9FW6ZNf8lsWxtJ3rV8VEoV4nxX1dldktXOj9ya9GekBTyZbT9p4iHxPM44g99P1sr3UYfslIpoX514rcLlWbFl+HgXMV0MTO0ZcbS+3rZiMAE8tXmCn6YPl37FLolBRMZyoQAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyR4mqbzKHNNF;
	Fri, 14 Aug 2026 17:39:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 6590B40BFF;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S16;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
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
Subject: [PATCH -next v5 12/32] ext4: implement buffered read path using iomap
Date: Fri, 14 Aug 2026 17:33:11 +0800
Message-ID: <20260814093331.1703882-13-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S16
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW3tr4DXry8JFWkKryUZFb_yoW5Ww1DpF
	90kFy5Gr4UWrnF9F4SqFZrAr1Yka1xJa1UWrWfGwnxWF90krWagayUGF1YvF45t3y7AF18
	XF4Ykry8Wa1UArDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index dda78cf1f68d..376cb9783835 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3956,14 +3956,60 @@ const struct iomap_ops ext4_iomap_report_ops = {
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
+const struct iomap_ops ext4_iomap_buffered_read_ops = {
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

