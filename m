Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80792310620;
	Wed, 22 Apr 2026 02:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824223; cv=none; b=lAC1zK0zRPASPDnnT+SOmIsv0h/TPSD82ReeYrtTHaKGubETvpPoHxt7OUMxILa7b3vN88EOMPHUMthLhwA/jqaCD25HWpk7K4y15hIzC37N2t33AuFI439XxRXSfmRdVSCkEasLEAUrknmUU3FJ5yh2g4D+n6OzlDSLlvAn3Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824223; c=relaxed/simple;
	bh=6HObb2LAWjwIuKdbRXu5Ab0/G5LsBqg7PpPg8bLypfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu/KeUSFUfg4O/RUZdGbTHqr/H7J6ZNm8xt9MVTzWPP/7RSmjcv1NBS2k9RUGVqWduCM/LjTtmG3rvkFP3W8DzrESpFsljdSu99E87A4LPtn9AdRBj7Xv+BWOWyEsj2+AbD2WwhkZeMDBCoy0MTRIzlNO0WR1ZNWHB4Zkq+k/b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0jX421tVzKHMQS;
	Wed, 22 Apr 2026 10:16:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 5152240604;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S12;
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
Subject: [PATCH v3 08/22] ext4: implement buffered write path using iomap
Date: Wed, 22 Apr 2026 10:10:28 +0800
Message-ID: <20260422021042.4157510-9-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S12
X-Coremail-Antispam: 1UD129KBjvJXoW3Aw1kJFWrAw1fWFW7WF18Grg_yoWkuF4kpF
	90kry5GFsrXr97uF4ftF47Zr1F93WxtrW7CrW3Wrn8XryqyrWIqF40gFyayF15trZ7Cr4j
	qF4Ykry8Wr4UCrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Introduce two new iomap_ops instances, ext4_iomap_buffered_write_ops and
ext4_iomap_buffered_da_write_ops, to implement the iomap write paths for
ext4. ext4_iomap_buffered_da_write_begin() invokes ext4_da_map_blocks()
to map delayed allocation extents, and ext4_iomap_buffer_write_begin()
invokes ext4_iomap_get_blocks() to directly allocate blocks in
non-delayed allocation mode. Additionally, add ext4_iomap_valid() to
check the validity of extents by the iomap infrastructure.

Key changes:

 - Since we don't use data=ordered mode to prevent exposing stale data
   in the non-delayed allocation path, we always allocate unwritten
   extents for new blocks.

 - The iomap write path maps multiple blocks at a time in the
   iomap_begin() callbacks, so we must remove the stale delayed
   allocation range in case of short writes and write failures.
   Otherwise, this could result in a range of delayed extents being
   covered by a clean folio, which would lead to inaccurate space
   reservation.

 - The lock ordering of the folio lock and transaction start is the
   opposite of that in the buffer_head buffered write path. So we have
   to stop journal handle in the iomap_begin() callbacks. The lock
   ordering documentation in super.c has been updated accordingly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h  |   4 ++
 fs/ext4/file.c  |  20 +++++-
 fs/ext4/inode.c | 164 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c |  10 ++-
 4 files changed, 191 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fe3491ad2129..be92ff648362 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
 int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
 void ext4_set_inode_mapping_order(struct inode *inode);
+int ext4_nonda_switch(struct super_block *sb);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
 
@@ -3943,6 +3944,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
+extern const struct iomap_ops ext4_iomap_buffered_write_ops;
+extern const struct iomap_ops ext4_iomap_buffered_da_write_ops;
+extern const struct iomap_write_ops ext4_iomap_write_ops;
 
 static inline int ext4_buffer_uptodate(struct buffer_head *bh)
 {
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index eb1a323962b1..7f9bfbbc4a4e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -299,6 +299,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
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
@@ -313,7 +328,10 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
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
index 5ffd6aeb3485..0ca303a90249 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3097,7 +3097,7 @@ static int ext4_dax_writepages(struct address_space *mapping,
 	return ret;
 }
 
-static int ext4_nonda_switch(struct super_block *sb)
+int ext4_nonda_switch(struct super_block *sb)
 {
 	s64 free_clusters, dirty_clusters;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -3467,6 +3467,15 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
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
@@ -3501,6 +3510,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
 	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		iomap->flags |= IOMAP_F_MERGED;
 
+	iomap->validity_cookie = map->m_seq;
+
 	/*
 	 * Flags passed to ext4_map_blocks() for direct I/O writes can result
 	 * in m_flags having both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN bits
@@ -3908,8 +3919,12 @@ const struct iomap_ops ext4_iomap_report_ops = {
 	.iomap_begin = ext4_iomap_begin_report,
 };
 
+/* Map blocks */
+typedef int (ext4_get_blocks_t)(struct inode *, struct ext4_map_blocks *);
+
 static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
-		loff_t length, struct ext4_map_blocks *map)
+		loff_t length, ext4_get_blocks_t get_blocks,
+		struct ext4_map_blocks *map)
 {
 	u8 blkbits = inode->i_blkbits;
 
@@ -3921,6 +3936,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
 	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
 			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
 
+	if (get_blocks)
+		return get_blocks(inode, map);
+
 	return ext4_map_blocks(NULL, inode, map, 0);
 }
 
@@ -3938,7 +3956,7 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
 	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
 		return -ERANGE;
 
-	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
+	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
 	if (ret < 0)
 		return ret;
 
@@ -3946,6 +3964,146 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int ext4_iomap_get_blocks(struct inode *inode,
+				 struct ext4_map_blocks *map)
+{
+	loff_t i_size = i_size_read(inode);
+	handle_t *handle;
+	int ret, needed_blocks;
+
+	/*
+	 * Check if the blocks have already been allocated, this could
+	 * avoid initiating a new journal transaction and return the
+	 * mapping information directly.
+	 */
+	if ((map->m_lblk + map->m_len) <=
+	    round_up(i_size, i_blocksize(inode)) >> inode->i_blkbits) {
+		ret = ext4_map_blocks(NULL, inode, map, 0);
+		if (ret < 0)
+			return ret;
+		if (map->m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN |
+				    EXT4_MAP_DELAYED))
+			return 0;
+	}
+
+	/*
+	 * Reserve one block more for addition to orphan list in case
+	 * we allocate blocks but write fails for some reason.
+	 */
+	needed_blocks = ext4_chunk_trans_blocks(inode, map->m_len) + 1;
+	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	ret = ext4_map_blocks(handle, inode, map,
+			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
+	/*
+	 * Stop handle here following the lock ordering of the folio lock
+	 * and the transaction start.
+	 */
+	ext4_journal_stop(handle);
+
+	return ret;
+}
+
+static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
+		loff_t offset, loff_t length, unsigned int flags,
+		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
+{
+	int ret, retries = 0;
+	struct ext4_map_blocks map;
+	ext4_get_blocks_t *get_blocks;
+
+	ret = ext4_emergency_state(inode->i_sb);
+	if (unlikely(ret))
+		return ret;
+
+	/* Inline data support is not yet available. */
+	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
+		return -ERANGE;
+	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
+		return -EINVAL;
+
+	if (delalloc)
+		get_blocks = ext4_da_map_blocks;
+	else
+		get_blocks = ext4_iomap_get_blocks;
+retry:
+	ret = ext4_iomap_map_blocks(inode, offset, length, get_blocks, &map);
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
+ * Drop the staled delayed allocation range from the write failure,
+ * including both start and end blocks. If not, we could leave a range
+ * of delayed extents covered by a clean folio, it could lead to
+ * inaccurate space reservation.
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
+
+const struct iomap_ops ext4_iomap_buffered_write_ops = {
+	.iomap_begin = ext4_iomap_buffered_write_begin,
+};
+
+const struct iomap_ops ext4_iomap_buffered_da_write_ops = {
+	.iomap_begin = ext4_iomap_buffered_da_write_begin,
+	.iomap_end = ext4_iomap_buffered_da_write_end,
+};
+
 const struct iomap_ops ext4_iomap_buffered_read_ops = {
 	.iomap_begin = ext4_iomap_buffered_read_begin,
 };
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..9bc294b769db 100644
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

