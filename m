Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D535A3B8;
	Wed, 22 Apr 2026 02:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824229; cv=none; b=JbeJ1FJfBMS3D7Jty1J9Mf5ANtOtamE39c5nqI3pwPw889K5JP51sLhaKubOINGP05YsAhGmjzj562XCbETfztZUG71qXSKJgzPzcR+2KzR6AMvnxcBDpXdsKb6BkpF51oeM6Yxatnuy4SxPtFt+H5UPdPPTrBFyY2AcUFGOW0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824229; c=relaxed/simple;
	bh=xPnRnv2vLgfMgk2Egdli1mi1SjXfj3Qdi0qbTQSB6o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByxTK7/61RBHpja2hgTNU9ujgaUcTIRcKt/9UX/Nz7LrP4etbhgG1e3NtYMbFz1iComt33MSQwJQ5P2qGKiHfya+Lmar17LN6b2+1z9wXLLJ+XyZ68F5mi4EdhLCJMKWabqGX3jgBRDHkWrbjjG79GFLj+tRFLxHtgBduWE0vrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0jWM5fs7zYQtrV;
	Wed, 22 Apr 2026 10:15:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id F22BB405D4;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S18;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
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
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 14/22] ext4: implement partial block zero range path using iomap
Date: Wed, 22 Apr 2026 10:10:34 +0800
Message-ID: <20260422021042.4157510-15-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S18
X-Coremail-Antispam: 1UD129KBjvJXoW3WF13Kw1DKFWrXF48ZFyxKrg_yoW7WF1UpF
	WDK345Gr47Wry29w4ftFsrXr1Yk3WxtrW8Wry3Grn0v3s8XayxKF48GFyF93W5tw47Cw12
	qF4UtryxGF1UAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
ext4_iomap_block_zero_range() to implement the iomap block zeroing range
for ext4. ext4_iomap_block_zero_range() invokes iomap_zero_range() and
passes ext4_iomap_zero_begin() to locate and zero out a mapped partial
block or a dirty, unwritten partial block.

Note that zeroing out under an active handle can cause deadlock since
the order of acquiring the folio lock and starting a handle is
inconsistent with the iomap writeback procedure. Therefore,
ext4_iomap_block_zero_range() cannot be called under an active handle,
and we also cannot use data=order mode to ensure zeroed data to be
unwritten back before updating i_disksize when performing post-EOF
append write or performing truncate up as well.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26e1366b85fd..701b912db6fb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4103,6 +4103,50 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int ext4_iomap_zero_begin(struct inode *inode,
+		loff_t offset, loff_t length, unsigned int flags,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
+	struct ext4_map_blocks map;
+	u8 blkbits = inode->i_blkbits;
+	unsigned int iomap_flags = 0;
+	int ret;
+
+	ret = ext4_emergency_state(inode->i_sb);
+	if (unlikely(ret))
+		return ret;
+
+	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
+		return -EINVAL;
+
+	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Look up dirty folios for unwritten mappings within EOF. Providing
+	 * this bypasses the flush iomap uses to trigger extent conversion
+	 * when unwritten mappings have dirty pagecache in need of zeroing.
+	 */
+	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
+		loff_t offset = ((loff_t)map.m_lblk) << blkbits;
+		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
+
+		iomap_fill_dirty_folios(iter, &offset, end, &iomap_flags);
+		if ((offset >> blkbits) < map.m_lblk + map.m_len)
+			map.m_len = (offset >> blkbits) - map.m_lblk;
+	}
+
+	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
+	iomap->flags |= iomap_flags;
+
+	return 0;
+}
+
+static const struct iomap_ops ext4_iomap_zero_ops = {
+	.iomap_begin = ext4_iomap_zero_begin,
+};
 
 const struct iomap_ops ext4_iomap_buffered_write_ops = {
 	.iomap_begin = ext4_iomap_buffered_write_begin,
@@ -4609,6 +4653,47 @@ static int ext4_block_journalled_zero_range(struct inode *inode, loff_t from,
 	return err;
 }
 
+static int ext4_block_iomap_zero_range(struct inode *inode, loff_t from,
+				       loff_t length, bool *did_zero,
+				       bool *zero_written)
+{
+	int ret;
+
+	/*
+	 * Zeroing out under an active handle can cause deadlock since
+	 * the order of acquiring the folio lock and starting a handle is
+	 * inconsistent with the iomap writeback procedure.
+	 */
+	if (WARN_ON_ONCE(ext4_handle_valid(journal_current_handle())))
+		return -EINVAL;
+
+	/* The zeroing scope should not extend across a block. */
+	if (WARN_ON_ONCE((from >> inode->i_blkbits) !=
+			 ((from + length - 1) >> inode->i_blkbits)))
+		return -EINVAL;
+
+	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS) &&
+	    !(inode_state_read_once(inode) & (I_NEW | I_FREEING)))
+		WARN_ON_ONCE(!inode_is_locked(inode) &&
+			!rwsem_is_locked(&inode->i_mapping->invalidate_lock));
+
+	ret = iomap_zero_range(inode, from, length, did_zero,
+			       &ext4_iomap_zero_ops, &ext4_iomap_write_ops,
+			       NULL);
+	if (ret)
+		return ret;
+
+	/*
+	 * TODO: The iomap does not distinguish between different types of
+	 * zeroing and always sets zero_written if a zeroing operation is
+	 * performed, which may result in unnecessary order operations.
+	 */
+	if (did_zero && zero_written)
+		*zero_written = *did_zero;
+
+	return 0;
+}
+
 /*
  * Zeros out a mapping of length 'length' starting from file offset
  * 'from'.  The range to be zero'd must be contained with in one block.
@@ -4635,6 +4720,9 @@ static int ext4_block_zero_range(struct inode *inode,
 	} else if (ext4_should_journal_data(inode)) {
 		return ext4_block_journalled_zero_range(inode, from, length,
 							did_zero);
+	} else if (ext4_inode_buffered_iomap(inode)) {
+		return ext4_block_iomap_zero_range(inode, from, length,
+						   did_zero, zero_written);
 	}
 	return ext4_block_do_zero_range(inode, from, length, did_zero,
 					zero_written);
@@ -4675,6 +4763,9 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * truncating up or performing an append write, because there might be
 	 * exposing stale on-disk data which may caused by concurrent post-EOF
 	 * mmap write during folio writeback.
+	 *
+	 * TODO: In the iomap path, handle this by updating i_disksize to
+	 * i_size after the zeroed data has been written back.
 	 */
 	if (ext4_should_order_data(inode) &&
 	    did_zero && zero_written && !IS_DAX(inode)) {
-- 
2.52.0

