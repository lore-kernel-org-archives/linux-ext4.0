Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DA04A49BF;
	Thu,  3 Sep 2026 12:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439379; cv=none; b=Ih1bTkaWipdIPfO833iaR7TfITcRLx9jxowWVPe/uq4rw3HXMbbsuTI6QTPHZ+5ZT5Dh2UBwGZx7mVrwKWlEVlokKbfA11E7ehXbFj2moIRAx6TudgwCl1OtSsCdy1x0fpGj5SncDz8xNhhPDwPeBVsbbjBeTRclkYOgetwIh38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439379; c=relaxed/simple;
	bh=CDLmZ4nlaI5WMyasBnb5EwOUHPWpJeokd4vJHOniw+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsM5PpneDfcdcI+5ZbMjDFYw6ZyGlv/tNwsXYpeFb/vyji0Hpgj8qqEHaap3soLDEsScS6ewHmFo+kxhS3nvS0BMiqbGf5hCuswxfkDzMkULjf1yTR5R4au6V6q6sE3YuIk7nEFNVoouJdPHx0DZMSzsPA2E/7Ya3ca9AVh5H34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3p1kN6zKHMkX;
	Thu,  3 Sep 2026 20:41:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id DE0164058F;
	Thu,  3 Sep 2026 20:42:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S18;
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
Subject: [PATCH v6 14/31] ext4: implement buffered write path using iomap
Date: Thu,  3 Sep 2026 20:35:26 +0800
Message-ID: <20260903123543.2302999-15-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S18
X-Coremail-Antispam: 1UD129KBjvJXoWfGFyDXFyxZr45Gry7ZFy8uFg_yoWkZr13pr
	98Kry5GFsrXr97urs3KF4DZr1Fk3WxtrW7urW3Wrn8XF9FyrWIgF40gFyayF15trWxCr4j
	qF4j9ry8Wr47CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTR_nYFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Introduce two new iomap_ops instances for ext4 buffered writes:

 - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
   ext4_da_map_blocks() to map delalloc extents.
 - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
   ext4_map_blocks() to directly allocate blocks.

Also add ext4_iomap_valid() for the iomap infrastructure to check extent
validity. This is useful for the iomap buffered write path because it
does not hold the folio lock between mapping the inode extent and
copying data. So it can race with writeback, which may modify or stale
the extent type.

Key changes and considerations:

 - Unwritten extents for new blocks (dioread_nolock always on)
   Since data=ordered mode is not used to prevent stale data exposure in
   the non-delayed allocation path, new blocks are always allocated as
   unwritten extents.

 - Short write and write failure handling
   a. Delalloc path: On short write or failure, the stale delalloc range
      must be dropped and its space reservation released. Otherwise, a
      clean folio may cover leftover delalloc extents, causing
      inaccurate space reservation accounting.
   b. Non-delalloc path: No cleanup of allocated blocks is needed on
      short write since leaving the preallocated blocks behind doesn't
      cause any real issue. These blocks are visible to users and are
      not permanently leaked.

 - Lock ordering reversal
   The folio lock and transaction start ordering is reversed compared to
   the buffer_head buffered write path. To handle this, the journal
   handle must be stopped in iomap_begin() callbacks. The lock ordering
   documentation in super.c has been updated accordingly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h  |   4 ++
 fs/ext4/file.c  |  20 +++++++-
 fs/ext4/inode.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/super.c |  10 ++--
 4 files changed, 156 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 24ec205da2d7..98295ef7069a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3165,6 +3165,7 @@ int ext4_walk_page_buffers(handle_t *handle,
 int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
 void ext4_set_inode_mapping_order(struct inode *inode);
+int ext4_nonda_switch(struct super_block *sb);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define EXT4_WRITE_DATA_INLINE	 2
 
@@ -4047,6 +4048,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
+extern const struct iomap_ops ext4_iomap_buffered_write_ops;
+extern const struct iomap_ops ext4_iomap_buffered_da_write_ops;
+extern const struct iomap_write_ops ext4_iomap_write_ops;
 
 int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned flags, struct iomap *iomap, struct iomap *srcmap);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 374b4bc25bd5..50d3c92709c8 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -330,6 +330,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	return count;
 }
 
+static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
+					 struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	const struct iomap_ops *iomap_ops;
+
+	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
+		iomap_ops = &ext4_iomap_buffered_da_write_ops;
+	else
+		iomap_ops = &ext4_iomap_buffered_write_ops;
+
+	return iomap_file_buffered_write(iocb, from, iomap_ops,
+					 &ext4_iomap_write_ops, NULL);
+}
+
 static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 					struct iov_iter *from)
 {
@@ -351,7 +366,10 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 	if (ret <= 0)
 		goto out;
 
-	ret = generic_perform_write(iocb, from);
+	if (ext4_inode_buffered_iomap(inode))
+		ret = ext4_iomap_buffered_write(iocb, from);
+	else
+		ret = generic_perform_write(iocb, from);
 
 out:
 	inode_unlock(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4c63fdc36626..fd60397a3ea2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3138,7 +3138,7 @@ static int ext4_dax_writepages(struct address_space *mapping,
 	return ret;
 }
 
-static int ext4_nonda_switch(struct super_block *sb)
+int ext4_nonda_switch(struct super_block *sb)
 {
 	s64 free_clusters, dirty_clusters;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -3510,6 +3510,15 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
 
+static bool ext4_iomap_valid(struct inode *inode, const struct iomap *iomap)
+{
+	return iomap->validity_cookie == READ_ONCE(EXT4_I(inode)->i_es_seq);
+}
+
+const struct iomap_write_ops ext4_iomap_write_ops = {
+	.iomap_valid = ext4_iomap_valid,
+};
+
 static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
 			   struct ext4_map_blocks *map, loff_t offset,
 			   loff_t length, unsigned int flags)
@@ -3544,6 +3553,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
 	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		iomap->flags |= IOMAP_F_MERGED;
 
+	iomap->validity_cookie = map->m_seq;
+
 	/*
 	 * Flags passed to ext4_map_blocks() for direct I/O writes can result
 	 * in m_flags having both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN bits
@@ -3959,7 +3970,8 @@ const struct iomap_ops ext4_iomap_report_ops = {
 };
 
 static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
-		loff_t length, struct ext4_map_blocks *map)
+				 loff_t length, struct ext4_map_blocks *map,
+				 int flags)
 {
 	u8 blkbits = inode->i_blkbits;
 
@@ -3971,7 +3983,10 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
 	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
 			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
 
-	return ext4_map_blocks(NULL, inode, map, 0);
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
+		return ext4_da_map_blocks(inode, map);
+
+	return ext4_map_blocks(NULL, inode, map, flags);
 }
 
 static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
@@ -3988,7 +4003,7 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
 	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
 		return -ERANGE;
 
-	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
+	ret = ext4_iomap_map_blocks(inode, offset, length, &map, 0);
 	if (ret < 0)
 		return ret;
 
@@ -3996,6 +4011,113 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
+		loff_t offset, loff_t length, unsigned int flags,
+		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
+{
+	int ret, retries = 0;
+	struct ext4_map_blocks map;
+	int map_flags;
+
+	ret = ext4_emergency_state(inode->i_sb);
+	if (unlikely(ret))
+		return ret;
+
+	/* Inline data and non-extent are not supported. */
+	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
+		return -ERANGE;
+	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
+		return -EINVAL;
+
+	map_flags = delalloc ? EXT4_GET_BLOCKS_DELALLOC_RESERVE :
+			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
+retry:
+	ret = ext4_iomap_map_blocks(inode, offset, length, &map, map_flags);
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+	if (ret < 0)
+		return ret;
+
+	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
+	return 0;
+}
+
+static int ext4_iomap_buffered_write_begin(struct inode *inode,
+		loff_t offset, loff_t length, unsigned int flags,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
+						  iomap, srcmap, false);
+}
+
+static int ext4_iomap_buffered_da_write_begin(struct inode *inode,
+		loff_t offset, loff_t length, unsigned int flags,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
+						  iomap, srcmap, true);
+}
+
+/*
+ * On write failure, drop the stale delayed allocation range and release
+ * its reserved space for both start and end blocks. Otherwise, we may
+ * leave a range of delayed extents covered by a clean folio, which can
+ * result in inaccurate space reservation accounting.
+ */
+static void ext4_iomap_punch_delalloc(struct inode *inode, loff_t offset,
+				     loff_t length, struct iomap *iomap)
+{
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_es_remove_extent(inode, offset >> inode->i_blkbits,
+			DIV_ROUND_UP_ULL(length, EXT4_BLOCK_SIZE(inode->i_sb)));
+	up_write(&EXT4_I(inode)->i_data_sem);
+}
+
+static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
+					    loff_t length, ssize_t written,
+					    unsigned int flags,
+					    struct iomap *iomap)
+{
+	loff_t start_byte, end_byte;
+
+	/* If we didn't reserve the blocks, we're not allowed to punch them. */
+	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
+		return 0;
+
+	/* Nothing to do if we've written the entire delalloc extent */
+	start_byte = iomap_last_written_block(inode, offset, written);
+	end_byte = round_up(offset + length, i_blocksize(inode));
+	if (start_byte >= end_byte)
+		return 0;
+
+	filemap_invalidate_lock(inode->i_mapping);
+	iomap_write_delalloc_release(inode, start_byte, end_byte, flags,
+				     iomap, ext4_iomap_punch_delalloc);
+	filemap_invalidate_unlock(inode->i_mapping);
+	return 0;
+}
+
+/*
+ * Since we always allocate unwritten extents, there is no need for
+ * iomap_end to clean up allocated blocks on a short write.
+ */
+static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_write_next,
+			      ext4_iomap_buffered_write_begin);
+
+const struct iomap_ops ext4_iomap_buffered_write_ops = {
+	.iomap_next = ext4_iomap_buffered_write_next,
+};
+
+static DEFINE_IOMAP_ITER_NEXT_END(ext4_iomap_buffered_da_write_next,
+				  ext4_iomap_buffered_da_write_begin,
+				  ext4_iomap_buffered_da_write_end);
+
+const struct iomap_ops ext4_iomap_buffered_da_write_ops = {
+	.iomap_next = ext4_iomap_buffered_da_write_next,
+};
+
 static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_read_next,
 			      ext4_iomap_buffered_read_begin);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bca0dc87d0b7..30150094f2a5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -104,9 +104,13 @@ static const struct fs_parameter_spec ext4_param_specs[];
  *   -> page lock -> i_data_sem (rw)
  *
  * buffered write path:
- * sb_start_write -> i_mutex -> mmap_lock
- * sb_start_write -> i_mutex -> transaction start -> page lock ->
- *   i_data_sem (rw)
+ * sb_start_write -> i_rwsem (w) -> mmap_lock
+ * - buffer_head path:
+ *   sb_start_write -> i_rwsem (w) -> transaction start -> folio lock ->
+ *     i_data_sem (rw)
+ * - iomap path:
+ *   sb_start_write -> i_rwsem (w) -> transaction start -> i_data_sem (rw)
+ *   sb_start_write -> i_rwsem (w) -> folio lock (not under an active handle)
  *
  * truncate:
  * sb_start_write -> i_mutex -> invalidate_lock (w) -> i_mmap_rwsem (w) ->
-- 
2.52.0

