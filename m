Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879B6435510;
	Fri, 14 Aug 2026 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700408; cv=none; b=EZkG2Me65Iojj0s027WzltnKkJrtLyqkyF8UxIWwsFtjA3Bh3rDYvvJ9TxNNlE3NRYgmk0RUAxidgJFNpiuAe8PhXvtvL1HtVA+5+M2Gep9RzpTWl4sCq/viViLMnwode8bUy92EjZZwarfLmVkYEDHTMlY7SpBPUKiphuOLKDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700408; c=relaxed/simple;
	bh=0knHU9HZeRjVrxQFt8k3u902l9ts7OwbHwT9wLhw/qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO+8N8VUvOoz+sVkcXMnKnAcx/IRxZn5kZscRuAB4Xf++t1UgaklWp/P/gg8P7IWAdJ7wgjAHE8IyeKd5jFg/uIC5Msbjf/jDIrpcRJH+tNfspjFwmFmsJiGt3OLXDaS+u81uJSLXr8XjEV7f2G0FrJ/UWa1QgzMx8bGzwgHjco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyS0bqZzKHNNj;
	Fri, 14 Aug 2026 17:39:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id CAB424056D;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S20;
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
Subject: [PATCH -next v5 16/32] ext4: implement writeback path using iomap
Date: Fri, 14 Aug 2026 17:33:15 +0800
Message-ID: <20260814093331.1703882-17-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S20
X-Coremail-Antispam: 1UD129KBjvAXoWfGFy3KFyDXFWrWFWDGrW5Awb_yoW8GF17uo
	W3ta15Xr48GryYyayF9r1IyryUuan7Gw48Jr45Zrs2va47JF1Y93yfG3y3Wa47Xw4FkFWf
	AryxJa1rGr4xJF1rn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUO37AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s0DM28Irc
	Ia0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l
	84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJV
	WxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl
	6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x
	IIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26F1j6w1U
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJV
	WUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRiyxR3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add the iomap writeback path for ext4 buffered I/O. This introduces:

 - ext4_iomap_writepages(): the main writeback entry point.
 - ext4_writeback_ops: a new iomap_writeback_ops instance to handle
   block mapping and I/O submission.
 - A new end I/O work handler for converting unwritten extents, updating
   file size, and handling DATA_ERR_ABORT after I/O completion.

Core implementation details:

 - ->writeback_range() callback
   Calls ext4_iomap_map_writeback_range() to map and allocate blocks
   using the enhanced ext4_map_blocks(). ext4_map_blocks() now starts
   its own transaction internally when it needs to allocate blocks.
   For performance, when a block range is not yet allocated, it
   allocates based on the writeback length and delalloc extent length,
   rather than allocating for a single folio at a time.  The folio is
   then added to an iomap_ioend instance.

 - ->writeback_submit() callback
   Registers ext4_iomap_end_bio() as the end bio callback. This callback
   schedules a worker to handle:
   - Unwritten extent conversion.
   - i_disksize update after data is written back.
   - Journal abort on writeback I/O failure.

Key changes and considerations:

 - Append write and unwritten extents
   Since data=ordered mode is not used to prevent stale data exposure
   during append writebacks, new blocks are always allocated as
   unwritten extents (i.e. always enable dioread_nolock), and i_disksize
   update is postponed until I/O completion. Additionally, the deadlock
   that the reserve handle was expected to resolve does not occur
   anymore. Therefore, the end I/O worker can start a normal journal
   handle instead of a reserve handle when converting unwritten extents.

 - Lock ordering
   The ->writeback_range() callback runs under the folio lock, requiring
   the journal handle to be started under that same lock. This reverses
   the order compared to the buffer_head writeback path. The lock
   ordering documentation in super.c has been updated accordingly.

 - Don't cache writes
   The iomap infrastructure sets the BIO_COMPLETE_IN_TASK flag when
   submitting I/O, so the ioend will be processed in task context.
   However, if a private defer worker is to be started, this flag must
   be cleared explicitly to avoid double deferral. In the future, all
   private defer work should be moved to the generic bio complete in
   task framework.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |   8 ++-
 fs/ext4/inode.c   | 147 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/page-io.c | 122 ++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c   |   5 +-
 4 files changed, 278 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 98295ef7069a..03fa90d2986f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1208,8 +1208,10 @@ struct ext4_inode_info {
 	/* Lock protecting lists below */
 	spinlock_t i_completed_io_lock;
 	/*
-	 * Completed IOs that need unwritten extents handling and have
-	 * transaction reserved
+	 * Completed IOs that need unwritten extents handling and have a
+	 * transaction reserved for the buffer_head writeback path, and
+	 * also used by the iomap writeback path to queue ioends needing
+	 * unwritten extents conversion, i_disksize update, etc.
 	 */
 	struct list_head i_rsv_conversion_list;
 	struct work_struct i_rsv_conversion_work;
@@ -3991,6 +3993,8 @@ void ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *page,
 		size_t len);
 extern struct ext4_io_end_vec *ext4_alloc_io_end_vec(ext4_io_end_t *io_end);
 extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
+extern void ext4_iomap_end_io(struct work_struct *work);
+extern void ext4_iomap_end_bio(struct bio *bio);
 
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d831d1911a6f..0b3e54e12b78 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -44,6 +44,7 @@
 #include <linux/iversion.h>
 
 #include "ext4_jbd2.h"
+#include "ext4_extents.h"
 #include "xattr.h"
 #include "acl.h"
 #include "truncate.h"
@@ -4134,10 +4135,154 @@ static void ext4_iomap_readahead(struct readahead_control *rac)
 	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
 }
 
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
+			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
+			      EXT4_GET_BLOCKS_METADATA_NOFAIL |
+			      EXT4_GET_BLOCKS_IO_SUBMIT |
+			      EXT4_EX_NOCACHE);
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
+
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
+	/*
+	 * ext4_iomap_end_bio() always defers endio processing, disable
+	 * generic BIO in task to avoid double deferral since we will use
+	 * a private defer endio handler in process context.
+	 *
+	 * TODO: Switch all defer handlers to the generic bio complete
+	 * in task framework.
+	 */
+	if (ioend->io_bio.bi_end_io)
+		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
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
index 0236b6b9785a..2888e0057561 100644
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
@@ -547,3 +548,124 @@ void ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 		io_submit_add_bh(io, inode, folio, bh);
 	} while ((bh = bh->b_this_page) != head);
 }
+
+static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
+					 loff_t end)
+{
+	loff_t new_disksize = end;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int ret;
+
+	/*
+	 * Races with truncate are avoided by checking i_size under
+	 * i_data_sem.
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
+	loff_t end = pos + size;
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
+	if (!(ioend->io_flags & IOMAP_IOEND_UNWRITTEN) &&
+	    end <= READ_ONCE(EXT4_I(inode)->i_disksize))
+		goto out;
+
+	/*
+	 * We may need to convert one extent, update the i_disksize and
+	 * dirty the inode.
+	 */
+	credits = ext4_chunk_trans_blocks(inode,
+			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
+	handle = ext4_journal_start(inode, EXT4_HT_EXT_CONVERT, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_err;
+	}
+
+	/* Update on-disk size after I/O is completed. */
+	if (end > READ_ONCE(EXT4_I(inode)->i_disksize)) {
+		ret = ext4_iomap_wb_update_disksize(handle, inode, end);
+		if (ret)
+			goto out_journal;
+	}
+
+	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
+		ret = ext4_convert_unwritten_extents(handle, inode, pos,
+						     size, NULL);
+
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
+						  i_rsv_conversion_work);
+	struct iomap_ioend *ioend;
+	struct list_head ioend_list;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	list_replace_init(&ei->i_rsv_conversion_list, &ioend_list);
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
+	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	if (list_empty(&ei->i_rsv_conversion_list))
+		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
+			   &ei->i_rsv_conversion_work);
+	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 30150094f2a5..6d2d323604f9 100644
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
-- 
2.52.0

