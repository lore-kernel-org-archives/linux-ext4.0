Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4734C3815CF;
	Mon, 11 May 2026 07:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484510; cv=none; b=f2ECEGzO4zjG5Fipau/NWti3X1l9K60szUGBLGbvXK+jXdoCl+NsvDao68bBHberfKYOyp85NBFQrZHltanZY1REmWJNbJe8YkKBJxpR8wxVUpdnwuN6KWDUBcPK6l+4Sn6U+l45ZNq1M170oOx6mSplK/a2vPmwSkUPZk8GTYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484510; c=relaxed/simple;
	bh=Xj1sKocGpz6KmqLc67YM9o6EWYK7tQFHy9OP+TKDDIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXLYE/Y4/V6gPOScYkn73ce83U8PT+zTX4bvvFxHXLB5gcgcYgokc2fFRGopnbQH6G4ae/OOfPpJ4yPNI+xrkBAAmFLZ2AuHGp2EveAcXjcpdRBblYg4LuqRVo1CEzSUQ8bAaUOKj0UmQ92OLgQvEiOs4DzsLQuOTEpxFPZFV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gDWX44vl0zKHMdm;
	Mon, 11 May 2026 15:27:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 348484056B;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S13;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
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
Subject: [PATCH v4 09/23] ext4: implement writeback path using iomap
Date: Mon, 11 May 2026 15:23:29 +0800
Message-ID: <20260511072344.191271-10-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S13
X-Coremail-Antispam: 1UD129KBjvAXoWfGFy3KFyDXFWrAFW8KF4rKrg_yoW8ArW8Ko
	Waqa13Xr48Jry5tayrGr1ftFyUuan7Gw4rJr45ZrsFva43Ja4Yvw4fKw43W3W7Xw4FkFWS
	yrWxJa1rGr48JF1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUOV7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s0DM28Irc
	Ia0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l
	84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJV
	WxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add the iomap writeback path for ext4 buffered I/O. This introduces:

 - ext4_iomap_writepages(): the main writeback entry point.
 - ext4_writeback_ops: a new iomap_writeback_ops instance to handle
   block mapping and I/O submission.
 - A new end I/O worker for converting unwritten extents, updating file
   size, and handling DATA_ERR_ABORT after I/O completion.

Core implementation details:

 - ->writeback_range() callback
   Calls ext4_iomap_map_writeback_range() to query the longest range of
   existing mapped extents. For performance, when a block range is not
   yet allocated, it allocates based on the writeback length and delalloc
   extent length, rather than allocating for a single folio at a time.
   The folio is then added to an iomap_ioend instance.

 - ->writeback_submit() callback
   Registers ext4_iomap_end_bio() as the end bio callback. This callback
   schedules a worker to handle:
   - Unwritten extent conversion.
   - i_disksize update after data is written back.
   - Journal abort on writeback I/O failure.

Key changes and considerations:

- Append write and unwritten extents
  Since data=ordered mode is not used to prevent stale data exposure
  during append writebacks, new blocks are always allocated as unwritten
  extents (i.e. always enable dioread_nolock), and i_disksize update is
  postponed until I/O completion. Additionally, the deadlock that the
  reserve handle was expected to resolve does not occur anymore.
  Therefore, the end I/O worker can start a normal journal handle
  instead of a reserve handle when converting unwritten extents.

- Lock ordering
  The ->writeback_range() callback runs under the folio lock, requiring
  the journal handle to be started under that same lock. This reverses
  the order compared to the buffer_head writeback path. The lock ordering
  documentation in super.c has been updated accordingly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h        |   4 +
 fs/ext4/inode.c       | 208 +++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/page-io.c     | 126 +++++++++++++++++++++++++
 fs/ext4/super.c       |   7 +-
 fs/iomap/ioend.c      |   3 +-
 include/linux/iomap.h |   1 +
 6 files changed, 346 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4832e7f7db82..078feda47e36 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1173,6 +1173,8 @@ struct ext4_inode_info {
 	 */
 	struct list_head i_rsv_conversion_list;
 	struct work_struct i_rsv_conversion_work;
+	struct list_head i_iomap_ioend_list;
+	struct work_struct i_iomap_ioend_work;
 
 	/*
 	 * Transactions that contain inode's metadata needed to complete
@@ -3870,6 +3872,8 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *page,
 		size_t len);
 extern struct ext4_io_end_vec *ext4_alloc_io_end_vec(ext4_io_end_t *io_end);
 extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
+extern void ext4_iomap_end_io(struct work_struct *work);
+extern void ext4_iomap_end_bio(struct bio *bio);
 
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1ae7d3f4a1c8..a80195bd6f20 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -44,6 +44,7 @@
 #include <linux/iversion.h>
 
 #include "ext4_jbd2.h"
+#include "ext4_extents.h"
 #include "xattr.h"
 #include "acl.h"
 #include "truncate.h"
@@ -4120,10 +4121,215 @@ static void ext4_iomap_readahead(struct readahead_control *rac)
 	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
 }
 
+static int ext4_iomap_map_one_extent(struct inode *inode,
+				     struct ext4_map_blocks *map)
+{
+	struct extent_status es;
+	handle_t *handle = NULL;
+	int credits, map_flags;
+	int retval;
+
+	credits = ext4_chunk_trans_blocks(inode, map->m_len);
+	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, credits);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	map->m_flags = 0;
+	/*
+	 * It is necessary to look up extent and map blocks under i_data_sem
+	 * in write mode, otherwise, the delalloc extent may become stale
+	 * during concurrent truncate operations.
+	 */
+	ext4_fc_track_inode(handle, inode);
+	down_write(&EXT4_I(inode)->i_data_sem);
+	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
+		retval = es.es_len - (map->m_lblk - es.es_lblk);
+		map->m_len = min_t(unsigned int, retval, map->m_len);
+
+		if (ext4_es_is_delayed(&es)) {
+			map->m_flags |= EXT4_MAP_DELAYED;
+			trace_ext4_da_write_pages_extent(inode, map);
+			/*
+			 * Call ext4_map_create_blocks() to allocate any
+			 * delayed allocation blocks. It is possible that
+			 * we're going to need more metadata blocks, however
+			 * we must not fail because we're in writeback and
+			 * there is nothing we can do so it might result in
+			 * data loss. So use reserved blocks to allocate
+			 * metadata if possible.
+			 */
+			map_flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
+				    EXT4_GET_BLOCKS_METADATA_NOFAIL |
+				    EXT4_EX_NOCACHE;
+
+			retval = ext4_map_create_blocks(handle, inode, map,
+							map_flags);
+			if (retval > 0)
+				ext4_fc_track_range(handle, inode, map->m_lblk,
+						map->m_lblk + map->m_len - 1);
+			goto out;
+		} else if (unlikely(ext4_es_is_hole(&es)))
+			goto out;
+
+		/* Found written or unwritten extent. */
+		map->m_pblk = ext4_es_pblock(&es) + map->m_lblk - es.es_lblk;
+		map->m_flags = ext4_es_is_written(&es) ?
+			       EXT4_MAP_MAPPED : EXT4_MAP_UNWRITTEN;
+		goto out;
+	}
+
+	retval = ext4_map_query_blocks(handle, inode, map, EXT4_EX_NOCACHE);
+out:
+	up_write(&EXT4_I(inode)->i_data_sem);
+	ext4_journal_stop(handle);
+	return retval < 0 ? retval : 0;
+}
+
+static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
+					  loff_t offset, unsigned int dirty_len)
+{
+	struct inode *inode = wpc->inode;
+	struct super_block *sb = inode->i_sb;
+	struct journal_s *journal = EXT4_SB(sb)->s_journal;
+	struct ext4_map_blocks map;
+	unsigned int blkbits = inode->i_blkbits;
+	unsigned int index = offset >> blkbits;
+	unsigned int blk_end, blk_len;
+	int ret;
+
+	ret = ext4_emergency_state(sb);
+	if (unlikely(ret))
+		return ret;
+
+	/* Check validity of the cached writeback mapping. */
+	if (offset >= wpc->iomap.offset &&
+	    offset < wpc->iomap.offset + wpc->iomap.length &&
+	    ext4_iomap_valid(inode, &wpc->iomap))
+		return 0;
+
+	blk_len = dirty_len >> blkbits;
+	blk_end = min_t(unsigned int, (wpc->wbc->range_end >> blkbits),
+				      (UINT_MAX - 1));
+	if (blk_end > index + blk_len)
+		blk_len = blk_end - index + 1;
+
+retry:
+	map.m_lblk = index;
+	map.m_len = min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
+	ret = ext4_map_blocks(NULL, inode, &map,
+			      EXT4_GET_BLOCKS_IO_SUBMIT | EXT4_EX_NOCACHE);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * The map is not a delalloc extent, it must either be a hole
+	 * or an extent which have already been allocated.
+	 */
+	if (!(map.m_flags & EXT4_MAP_DELAYED))
+		goto out;
+
+	/* Map one delalloc extent. */
+	ret = ext4_iomap_map_one_extent(inode, &map);
+	if (ret < 0) {
+		if (ext4_emergency_state(sb))
+			return ret;
+
+		/*
+		 * Retry transient ENOSPC errors, if
+		 * ext4_count_free_blocks() is non-zero, a commit
+		 * should free up blocks.
+		 */
+		if (ret == -ENOSPC && journal && ext4_count_free_clusters(sb)) {
+			jbd2_journal_force_commit_nested(journal);
+			goto retry;
+		}
+
+		ext4_msg(sb, KERN_CRIT,
+			 "Delayed block allocation failed for inode %llu at logical offset %llu with max blocks %u with error %d",
+			 inode->i_ino, (unsigned long long)map.m_lblk,
+			 (unsigned int)map.m_len, -ret);
+		ext4_msg(sb, KERN_CRIT,
+			 "This should not happen!! Data will be lost\n");
+		if (ret == -ENOSPC)
+			ext4_print_free_blocks(inode);
+		return ret;
+	}
+out:
+	ext4_set_iomap(inode, &wpc->iomap, &map, offset, dirty_len, 0);
+	return 0;
+}
+
+static void ext4_iomap_discard_folio(struct folio *folio, loff_t pos)
+{
+	struct inode *inode = folio->mapping->host;
+	loff_t length = folio_pos(folio) + folio_size(folio) - pos;
+
+	ext4_iomap_punch_delalloc(inode, pos, length, NULL);
+}
+
+static ssize_t ext4_iomap_writeback_range(struct iomap_writepage_ctx *wpc,
+					  struct folio *folio, u64 offset,
+					  unsigned int len, u64 end_pos)
+{
+	ssize_t ret;
+
+	ret = ext4_iomap_map_writeback_range(wpc, offset, len);
+	if (!ret)
+		ret = iomap_add_to_ioend(wpc, folio, offset, end_pos, len);
+	if (ret < 0)
+		ext4_iomap_discard_folio(folio, offset);
+	return ret;
+}
+
+static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
+				       int error)
+{
+	struct iomap_ioend *ioend = wpc->wb_ctx;
+	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
+
+	/*
+	 * After I/O completion, a worker needs to be scheduled when:
+	 * 1) Unwritten extents require conversion.
+	 * 2) The file size needs to be extended.
+	 * 3) The journal needs to be aborted due to an I/O error.
+	 */
+	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
+	    (ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize)) ||
+	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
+		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
+
+	return iomap_ioend_writeback_submit(wpc, error);
+}
+
+static const struct iomap_writeback_ops ext4_writeback_ops = {
+	.writeback_range = ext4_iomap_writeback_range,
+	.writeback_submit = ext4_iomap_writeback_submit,
+};
+
 static int ext4_iomap_writepages(struct address_space *mapping,
 				 struct writeback_control *wbc)
 {
-	return 0;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+	long nr = wbc->nr_to_write;
+	int alloc_ctx, ret;
+	struct iomap_writepage_ctx wpc = {
+		.inode = inode,
+		.wbc = wbc,
+		.ops = &ext4_writeback_ops,
+	};
+
+	ret = ext4_emergency_state(sb);
+	if (unlikely(ret))
+		return ret;
+
+	alloc_ctx = ext4_writepages_down_read(sb);
+	trace_ext4_writepages(inode, wbc);
+	ret = iomap_writepages(&wpc);
+	trace_ext4_writepages_result(inode, wbc, ret, nr - wbc->nr_to_write);
+	ext4_writepages_up_read(sb, alloc_ctx);
+
+	return ret;
 }
 
 /*
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dc82e7b57e75..3050c887329f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -22,6 +22,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/kernel.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
@@ -611,3 +612,128 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 
 	return 0;
 }
+
+static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
+					 loff_t end)
+{
+	loff_t new_disksize = end;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int ret;
+
+	if (new_disksize <= READ_ONCE(ei->i_disksize))
+		return 0;
+
+	/*
+	 * Update on-disk size after IO is completed. Races with truncate
+	 * are avoided by checking i_size under i_data_sem.
+	 */
+	down_write(&ei->i_data_sem);
+	new_disksize = min(new_disksize, i_size_read(inode));
+	if (new_disksize > ei->i_disksize)
+		ei->i_disksize = new_disksize;
+	up_write(&ei->i_data_sem);
+	ret = ext4_mark_inode_dirty(handle, inode);
+	if (ret)
+		EXT4_ERROR_INODE_ERR(inode, -ret, "Failed to mark inode dirty");
+
+	return ret;
+}
+
+static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
+{
+	struct inode *inode = ioend->io_inode;
+	struct super_block *sb = inode->i_sb;
+	loff_t pos = ioend->io_offset;
+	size_t size = ioend->io_size;
+	handle_t *handle;
+	int credits;
+	int ret, err;
+
+	ret = blk_status_to_errno(ioend->io_bio.bi_status);
+	if (unlikely(ret)) {
+		if (test_opt(sb, DATA_ERR_ABORT) && !ext4_emergency_state(sb))
+			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
+		goto out;
+	}
+
+	/* We may need to convert one extent and dirty the inode. */
+	credits = ext4_chunk_trans_blocks(inode,
+			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
+	handle = ext4_journal_start(inode, EXT4_HT_EXT_CONVERT, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_err;
+	}
+
+	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN) {
+		ret = ext4_convert_unwritten_extents(handle, inode, pos, size);
+		if (ret)
+			goto out_journal;
+	}
+
+	ret = ext4_iomap_wb_update_disksize(handle, inode, pos + size);
+out_journal:
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
+out_err:
+	if (ret < 0 && !ext4_emergency_state(sb)) {
+		ext4_msg(sb, KERN_EMERG,
+			 "failed to convert unwritten extents to written extents or update inode size -- potential data loss! (inode %llu, error %d)",
+			 inode->i_ino, ret);
+	}
+out:
+	iomap_finish_ioends(ioend, ret);
+}
+
+/*
+ * Work on buffered iomap completed IO, to convert unwritten extents to
+ * mapped extents
+ */
+void ext4_iomap_end_io(struct work_struct *work)
+{
+	struct ext4_inode_info *ei = container_of(work, struct ext4_inode_info,
+						  i_iomap_ioend_work);
+	struct iomap_ioend *ioend;
+	struct list_head ioend_list;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	list_replace_init(&ei->i_iomap_ioend_list, &ioend_list);
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+
+	iomap_sort_ioends(&ioend_list);
+	while (!list_empty(&ioend_list)) {
+		ioend = list_entry(ioend_list.next, struct iomap_ioend, io_list);
+		list_del_init(&ioend->io_list);
+		iomap_ioend_try_merge(ioend, &ioend_list);
+		ext4_iomap_finish_ioend(ioend);
+	}
+}
+
+void ext4_iomap_end_bio(struct bio *bio)
+{
+	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
+	struct inode *inode = ioend->io_inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned long flags;
+
+	/* Needs to convert unwritten extents or update the i_disksize. */
+	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
+	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
+		goto defer;
+
+	/* Needs to abort the journal on data_err=abort.  */
+	if (unlikely(ioend->io_bio.bi_status))
+		goto defer;
+
+	iomap_finish_ioend(ioend, 0);
+	return;
+defer:
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	if (list_empty(&ei->i_iomap_ioend_list))
+		queue_work(sbi->rsv_conversion_wq, &ei->i_iomap_ioend_work);
+	list_add_tail(&ioend->io_list, &ei->i_iomap_ioend_list);
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9bc294b769db..51d87db53543 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -123,7 +123,10 @@ static const struct fs_parameter_spec ext4_param_specs[];
  * sb_start_write -> i_mutex -> transaction start -> i_data_sem (rw)
  *
  * writepages:
- * transaction start -> page lock(s) -> i_data_sem (rw)
+ * - buffer_head path:
+ *   transaction start -> folio lock(s) -> i_data_sem (rw)
+ * - iomap path:
+ *   folio lock -> transaction start -> i_data_sem (rw)
  */
 
 static const struct fs_context_operations ext4_context_ops = {
@@ -1428,10 +1431,12 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 #endif
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
+	INIT_LIST_HEAD(&ei->i_iomap_ioend_list);
 	spin_lock_init(&ei->i_completed_io_lock);
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
+	INIT_WORK(&ei->i_iomap_ioend_work, ext4_iomap_end_io);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
 	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..89bbd3027b81 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -305,7 +305,7 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(iomap_add_to_ioend);
 
-static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
+u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 {
 	if (ioend->io_parent) {
 		struct bio *bio = &ioend->io_bio;
@@ -333,6 +333,7 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 		return iomap_finish_ioend_buffered_read(ioend);
 	return iomap_finish_ioend_buffered_write(ioend);
 }
+EXPORT_SYMBOL_GPL(iomap_finish_ioend);
 
 /*
  * Ioend completion routine for merged bios. This can only be called from task
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 2c5685adf3a9..7974ed441300 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -479,6 +479,7 @@ struct iomap_ioend *iomap_init_ioend(struct inode *inode, struct bio *bio,
 		loff_t file_offset, u16 ioend_flags);
 struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
 		unsigned int max_len, bool is_append);
+u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error);
 void iomap_finish_ioends(struct iomap_ioend *ioend, int error);
 void iomap_ioend_try_merge(struct iomap_ioend *ioend,
 		struct list_head *more_ioends);
-- 
2.52.0

