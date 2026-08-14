Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7E74195A7;
	Fri, 14 Aug 2026 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700404; cv=none; b=s8SfomuJSb9bVgFEGNhm6OOuXKtf3Qj52pfBlNYP9bSQFCZrGK4bz+CMVVskY7i/xG7QJqK37WLGJFX3vkxFGCBSNxULS8CZcvUK/UDXD6gKZJUWlZ2t4SsorbT1KTB8Sru5Ug88PE9yL/x16srVA4k3lXTZ7A3+5Ze5SaOlljQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700404; c=relaxed/simple;
	bh=rUnFLhM5VwcrvZHLo7VUt9NhobUQbGgmasMsOUkkes0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H595ZdFq38riMjTs6ZX3cIVE1hBvMadABxmhLLFUSHnvlEAcAUvk1oZwTMYu+5rX1T/ZLEXr4/ltGRESlPFAeTcV9+XAEayLQ/EXFbluzU7r5cmtLrZfsiW26zBRGhotYS6aqQ+xsQ6GEcAMadfLkn7o6g/QLHRIA7gJAYRKOCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyh5vvDzYQvTZ;
	Fri, 14 Aug 2026 17:39:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 0DC574056D;
	Fri, 14 Aug 2026 17:39:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S22;
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
Subject: [PATCH -next v5 18/32] ext4: implement partial block zero range path using iomap
Date: Fri, 14 Aug 2026 17:33:17 +0800
Message-ID: <20260814093331.1703882-19-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S22
X-Coremail-Antispam: 1UD129KBjvJXoW3GF47CF4DWw4kKF18ArW5Wrg_yoW3Gr1kpF
	ZxKry5GrsrX3sF9w4fJFnrXr1Ykw1ftFWUWry3GrnYvas8ZrWxKF1UGFWFvFyUJ3y7Gr12
	qF4jy34xKF1UA3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRiyxR3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
ext4_iomap_block_zero_range() to implement block zeroing via the iomap
infrastructure for ext4.

ext4_iomap_block_zero_range() calls iomap_zero_range() with
ext4_iomap_zero_begin() as the callback. The callback locates the
range and populates the iomap mapping. If the range is mapped,
iomap_zero_iter() in the iomap core zeros the partial block
directly. If the range is an unwritten extent within EOF, the
callback collects a dirty folio batch via iomap_fill_dirty_folios()
so that iomap_zero_iter() can zero those folios directly, bypassing
a separate slow flush operation that would otherwise be needed to
convert the unwritten extent.

Note that ext4_iomap_zero_begin() can race with concurrent writeback:
after it queries an unwritten extent, writeback may convert it to
written and complete on the folio before iomap_fill_dirty_folios() scans
the range. The empty batch then makes iomap_zero_iter() skip zeroing,
leaving stale on-disk data.

  zero_range                      writeback
  ----------------------          ----------------------
  ext4_block_zero_range()
    iomap_zero_range()
      iomap_iter()
        ext4_iomap_zero_begin()
          ext4_iomap_map_blocks()
            -> extent is UNWRITTEN
                                  ext4_convert_unwritten_extents_endio()
                                    -> extent is converted to WRITTEN
                                    -> folio is clean
          iomap_fill_dirty_folios()
            filemap_get_folios_dirty()
            -> folio is clean, not added to batch
          ext4_set_iomap() -> IOMAP_UNWRITTEN
      iomap_zero_iter()
        __iomap_get_folio() -> NULL (empty batch)
        iomap_iter_advance_full()  <-- zeroing skipped

  [later read returns stale on-disk data]   <--   CORRUPTION

Therefore, we retry the extent lookup when iomap_fill_dirty_folios()
adds nothing and the i_es_seq cookie captured at the first lookup has
advanced, indicating the race actually occurred.

Other important constraints:

Zeroing out under an active journal handle can cause deadlock, as the
lock/handle ordering is inconsistent with the iomap writeback path.
Therefore, ext4_iomap_block_zero_range() must not be called under an
active handle. In addition, for post-EOF zeroing, the caller cannot
rely on data=ordered mode to persist the zeroed data before
i_disksize is updated.

Subsequent patches will address this by deferring i_disksize update
to i_size until after the zeroed data has been written back.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a05445625895..d4b4153077bb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4106,6 +4106,67 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int ext4_iomap_zero_begin(struct inode *inode,
+		loff_t offset, loff_t length, unsigned int flags,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
+	struct ext4_map_blocks map;
+	u8 blkbits = inode->i_blkbits;
+	unsigned int iomap_flags;
+	int ret;
+
+	ret = ext4_emergency_state(inode->i_sb);
+	if (unlikely(ret))
+		return ret;
+
+	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
+		return -EINVAL;
+
+again:
+	ret = ext4_iomap_map_blocks(inode, offset, length, &map, 0);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Look up dirty folios for unwritten mappings within EOF. Providing
+	 * this bypasses the flush iomap uses to trigger extent conversion
+	 * when unwritten mappings have dirty pagecache in need of zeroing.
+	 */
+	iomap_flags = 0;
+	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
+		loff_t start = ((loff_t)map.m_lblk) << blkbits;
+		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
+		unsigned int count;
+
+		count = iomap_fill_dirty_folios(iter, &start, end,
+						&iomap_flags);
+		if ((start >> blkbits) < map.m_lblk + map.m_len)
+			map.m_len = (start >> blkbits) - map.m_lblk;
+
+		/*
+		 * This can be raced by a concurrent writeback that cleans
+		 * the folio and converts the unwritten extent to written.
+		 * Recheck the mapping after a folio lock round in
+		 * iomap_fill_dirty_folios().
+		 */
+		if (count == 0 &&
+		    map.m_seq != READ_ONCE(EXT4_I(inode)->i_es_seq))
+			goto again;
+	}
+
+	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
+	iomap->flags |= iomap_flags;
+
+	return 0;
+}
+
+static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_zero_next, ext4_iomap_zero_begin);
+
+static const struct iomap_ops ext4_iomap_zero_ops = {
+	.iomap_next = ext4_iomap_zero_next,
+};
+
 /*
  * Since we always allocate unwritten extents, there is no need for
  * iomap_end to clean up allocated blocks on a short write.
@@ -4569,6 +4630,48 @@ static int ext4_block_journalled_zero_range(struct inode *inode, loff_t from,
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
+	 * TODO: The iomap does not distinguish between different types
+	 * of zeroing operations. So we always set zero_written whenever
+	 * zeroing is performed, which may cause unnecessary folio
+	 * flushing when zeroing occurs on delayed-allocated blocks.
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
@@ -4595,6 +4698,9 @@ static int ext4_block_zero_range(struct inode *inode,
 	} else if (ext4_should_journal_data(inode)) {
 		return ext4_block_journalled_zero_range(inode, from, length,
 							did_zero);
+	} else if (ext4_inode_buffered_iomap(inode)) {
+		return ext4_block_iomap_zero_range(inode, from, length,
+						   did_zero, zero_written);
 	}
 	return ext4_block_do_zero_range(inode, from, length, did_zero,
 					zero_written);
@@ -4649,6 +4755,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * block, the zeroed data lies beyond the existing on-disk data. It
 	 * will be written out before i_disksize is later extended past
 	 * i_size, so no stale data can be exposed.
+	 *
+	 * TODO: In the iomap path, handle this by tracking the ordered range
+	 * and updating i_disksize to i_size after the zeroed data has been
+	 * written back.
 	 */
 	if (ext4_should_order_data(inode) &&
 	    did_zero && zero_written && !IS_DAX(inode) &&
-- 
2.52.0

