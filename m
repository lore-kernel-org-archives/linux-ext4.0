Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43995383C84;
	Mon, 11 May 2026 07:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484520; cv=none; b=gKe+CWMsPYUDRYlCe9cTg3s0QPrj+8blwevfUcY/sV/pKE8OlRd54y6rDQAP9h/6f8CZq2t1EI5cVGi2v6lJ+SiuxDkc8UTulRgRQ+4GTDjLtaHIUnHhGficcN0PaJp493zcU1eGLtpofa3jzbsx1yrr/z+nwehS56ZP4xj+x+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484520; c=relaxed/simple;
	bh=kvPnJ7yVd9n6VcDpIsH2Rscp+rR5KnGoerAy64lgD1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0GLU0NdgZPs0AXPrT6JFwRUFWa0J0EJnuw0pTJBnXlM/d/s/v0wfArlMbdK9iM8iTmRTDTmD4S+polgm0WT7m2je/oj2+6T7P4yJQXoKQUuAY9OpmzTv2+Q+XS/oeRy1DC1YVI5p9ej+vXaaRUgh56OIDQGP+249Lew+5VkxJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXW33FLzYQv1r;
	Mon, 11 May 2026 15:27:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 198BA4056F;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S22;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
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
Subject: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap buffered I/O path
Date: Mon, 11 May 2026 15:23:38 +0800
Message-ID: <20260511072344.191271-19-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S22
X-Coremail-Antispam: 1UD129KBjvJXoW3KFW7Aw4rGry5GFy7ArWrKrg_yoWDKrWxpF
	ZxGryrGw48XF929rs2qw48Zr1F93WrKayrJFWfWw4qvay5GryIkF18tF15ZFyUtrZrJrWI
	qF48ArW7Wr1DJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

For append writes, wait for ordered I/O to complete before updating
i_disksize. This ensures that zeroed data is flushed to disk before the
metadata update, preventing stale data from being exposed during
unaligned post-EOF append writes.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    | 11 +++++++
 fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
 fs/ext4/super.c   | 23 ++++++++++----
 4 files changed, 161 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 078feda47e36..9ce2128eea3e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1195,6 +1195,15 @@ struct ext4_inode_info {
 #ifdef CONFIG_FS_ENCRYPTION
 	struct fscrypt_inode_info *i_crypt_info;
 #endif
+
+	/*
+	 * Track ordered zeroed data during post-EOF append writes, fallocate,
+	 * and truncate-up operations. These parameters are used only in the
+	 * iomap buffered I/O path.
+	 */
+	ext4_lblk_t i_ordered_lblk;
+	ext4_lblk_t i_ordered_len;
+	wait_queue_head_t i_ordered_wq;
 };
 
 /*
@@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			     __u64 len, __u64 *moved_len);
 
 /* page-io.c */
+#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
+
 extern int __init ext4_init_pageio(void);
 extern void ext4_exit_pageio(void);
 extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e013aeb03d7b..11fb369efeb1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 {
 	struct iomap_ioend *ioend = wpc->wb_ctx;
 	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
+	ext4_lblk_t start, end, order_lblk, order_len;
 
 	/*
 	 * After I/O completion, a worker needs to be scheduled when:
@@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
 		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
 
+	/*
+	 * Mark the I/O as ordered. Ordered I/O requires separate endio
+	 * handling and must not be merged with regular I/O operations.
+	 */
+	order_len = READ_ONCE(ei->i_ordered_len);
+	if (order_len) {
+		/*
+		 * Pair with smp_store_release() in ext4_block_zero_eof().
+		 * Ensure we see the updated i_ordered_lblk that was written
+		 * before the release store to i_ordered_len.
+		 */
+		smp_rmb();
+		order_lblk = READ_ONCE(ei->i_ordered_lblk);
+		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
+		end = EXT4_B_TO_LBLK(ioend->io_inode,
+				     ioend->io_offset + ioend->io_size);
+
+		if (start <= order_lblk && end >= order_lblk + order_len) {
+			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
+			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
+			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
+		}
+	}
+
 	return iomap_ioend_writeback_submit(wpc, error);
 }
 
@@ -4746,8 +4771,10 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
 					loff_t from, loff_t end)
 {
 	struct address_space *mapping = inode->i_mapping;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct folio *folio;
 	bool do_submit = false;
+	int ret;
 
 	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
 	if (IS_ERR(folio))
@@ -4757,14 +4784,50 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
 	folio_wait_writeback(folio);
 	WARN_ON_ONCE(folio_test_writeback(folio));
 
-	if (likely(folio_test_dirty(folio)))
+	/*
+	 * Mark the ordered range. It will be cleared upon I/O completion
+	 * in ext4_iomap_end_bio(). Any operation that extends i_disksize
+	 * (including append write end io past the zeroed boundary,
+	 * truncate up and append fallocate) must wait for this I/O to
+	 * complete before updating i_disksize.
+	 *
+	 * When multiple overlapping unaligned EOF writes are in flight, we
+	 * only need to track and wait for the first one. Subsequent writes
+	 * will zero the gap in memory and ensure that the zeroed data is
+	 * written out along with the valid data in the same block before
+	 * i_disksize is updated.
+	 */
+	if (likely(folio_test_dirty(folio) &&
+		   READ_ONCE(ei->i_ordered_len) == 0)) {
+		WRITE_ONCE(ei->i_ordered_lblk,
+			   from >> inode->i_blkbits);
+		/*
+		 * Pairs with smp_rmb() in ext4_iomap_writeback_submit()
+		 * and ext4_iomap_wb_ordered_wait(). Ensure the updated
+		 * i_ordered_lblk is visible when i_ordered_len becomes
+		 * non-zero.
+		 */
+		smp_store_release(&ei->i_ordered_len, 1);
 		do_submit = true;
+	}
 	folio_unlock(folio);
 	folio_put(folio);
 
 	/* Submit zeroed block. */
-	if (do_submit)
-		return filemap_fdatawrite_range(mapping, from, end - 1);
+	if (do_submit) {
+		ret = filemap_fdatawrite_range(mapping, from, end - 1);
+		if (ret) {
+			/*
+			 * Pairs with wait_event() in
+			 * ext4_iomap_wb_ordered_wait(). Ensure
+			 * i_ordered_len = 0 is visible before waking up
+			 * waiters.
+			 */
+			smp_store_release(&ei->i_ordered_len, 0);
+			wake_up_all(&ei->i_ordered_wq);
+			return ret;
+		}
+	}
 	return 0;
 }
 
@@ -4827,10 +4890,13 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 		 * data=ordered mode. We submit zeroed range directly here.
 		 * Do not wait for I/O completion for performance.
 		 *
-		 * TODO: Any operation that extends i_disksize (including
-		 * append write end io past the zeroed boundary, truncate up,
-		 * and append fallocate) must wait for the relevant I/O to
-		 * complete before updating i_disksize.
+		 * The end_io handler ext4_iomap_wb_ordered_wait() will wait
+		 * for I/O completion before updating i_disksize if the write
+		 * extends beyond the zeroed boundary.
+		 *
+		 * TODO: Any other operation that extends i_disksize
+		 * (including truncate up and append fallocate) must wait for
+		 * the relevant I/O to complete before updating i_disksize.
 		 */
 		} else if (ext4_inode_buffered_iomap(inode)) {
 			err = ext4_iomap_submit_zero_block(inode, from, end);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 3050c887329f..ad05ebb49bf6 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -613,6 +613,46 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 	return 0;
 }
 
+/*
+ * If the old disk size is not block size aligned and the current
+ * writeback range is entirely beyond the old EOF block, we should
+ * wait for the zeroed data written in ext4_block_zero_eof() to be
+ * written out, otherwise, it may expose stale data in that block.
+ */
+static void ext4_iomap_wb_ordered_wait(struct inode *inode,
+				       loff_t pos, loff_t end)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int blocksize = i_blocksize(inode);
+	loff_t disksize = READ_ONCE(ei->i_disksize);
+	ext4_lblk_t order_lblk, order_len;
+
+	/*
+	 * Waiting for ordered I/O is unnecessary when:
+	 * - The on-disk size is block-aligned (no stale data exists).
+	 * - The write start is within the block of the old EOF
+	 *   (overwriting, or appending to a block that already contains
+	 *   valid data).
+	 */
+	if (!(disksize & (blocksize - 1)) ||
+	    pos < round_up(disksize, blocksize))
+		return;
+
+	order_len = READ_ONCE(ei->i_ordered_len);
+	if (!order_len)
+		return;
+
+	/*
+	 * Pair with smp_store_release() in ext4_iomap_end_bio() and
+	 * ext4_block_zero_eof(). Ensure we see the updated i_ordered_lblk
+	 * that was written before the release store to i_ordered_len.
+	 */
+	smp_rmb();
+	order_lblk = READ_ONCE(ei->i_ordered_lblk);
+	if ((pos >> inode->i_blkbits) >= order_lblk + order_len)
+		wait_event(ei->i_ordered_wq, READ_ONCE(ei->i_ordered_len) == 0);
+}
+
 static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 					 loff_t end)
 {
@@ -656,6 +696,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 		goto out;
 	}
 
+	/* Wait ordered zero data to be written out. */
+	ext4_iomap_wb_ordered_wait(inode, pos, pos + size);
+
 	/* We may need to convert one extent and dirty the inode. */
 	credits = ext4_chunk_trans_blocks(inode,
 			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
@@ -717,8 +760,25 @@ void ext4_iomap_end_bio(struct bio *bio)
 	struct inode *inode = ioend->io_inode;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned long io_mode = (unsigned long)ioend->io_private;
 	unsigned long flags;
 
+	/*
+	 * This is an ordered I/O, clear the ordered range set in
+	 * ext4_block_zero_eof() and wake up all waiters that will update
+	 * the inode i_disksize.
+	 */
+	if (io_mode == EXT4_IOMAP_IOEND_ORDER_IO) {
+		/*
+		 * Pairs with wait_event() in ext4_iomap_wb_ordered_wait().
+		 * Ensure i_ordered_len = 0 is visible before waking up
+		 * waiters.
+		 */
+		smp_store_release(&ei->i_ordered_len, 0);
+		wake_up_all(&ei->i_ordered_wq);
+		goto defer;
+	}
+
 	/* Needs to convert unwritten extents or update the i_disksize. */
 	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
 	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 62bfe05a64bc..9c0a00e716f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1444,6 +1444,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
 	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
+	ei->i_ordered_lblk = 0;
+	ei->i_ordered_len = 0;
+	init_waitqueue_head(&ei->i_ordered_wq);
 	return &ei->vfs_inode;
 }
 
@@ -1480,12 +1483,20 @@ static void ext4_destroy_inode(struct inode *inode)
 		dump_stack();
 	}
 
-	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
-	    WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
-		ext4_msg(inode->i_sb, KERN_ERR,
-			 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
-			 inode->i_ino, EXT4_I(inode),
-			 EXT4_I(inode)->i_reserved_data_blocks);
+	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS)) {
+		if (WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
+			ext4_msg(inode->i_sb, KERN_ERR,
+				 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
+				 inode->i_ino, EXT4_I(inode),
+				 EXT4_I(inode)->i_reserved_data_blocks);
+
+		if (WARN_ON_ONCE(EXT4_I(inode)->i_ordered_len))
+			ext4_msg(inode->i_sb, KERN_ERR,
+				 "Inode %llu (%p): i_ordered_lblk (%u) and i_ordered_len (%u) not cleared!",
+				 inode->i_ino, EXT4_I(inode),
+				 EXT4_I(inode)->i_ordered_lblk,
+				 EXT4_I(inode)->i_ordered_len);
+	}
 }
 
 static void ext4_shutdown(struct super_block *sb)
-- 
2.52.0

