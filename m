Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8234AD4C2;
	Fri,  9 Oct 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542251; cv=none; b=iclPPsCsUurvRiuTrIHkYVRE/0TDtAcFVktIlYvzfZnkW5oxnu/Ccs2Q6ho+mljBud5hjjwRJi4Mzl4aU99nkadv5lqKdNw1H7ViV20LE0HGc6CuFcN+b2VCaRlPP+JOFs45spGEKf3m39KOJf7p3IQXs/yyi6VII34Wq36rzQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542251; c=relaxed/simple;
	bh=Ms8BZqdDlCJTxLoVv4IrGULVmeY4GmADIKJE17nowpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+ALMtNmHLYm3+VhMENfaNtK5fTIA35iSTvEYwREbGdouw4YYXKC7xJiKu6u42Av6EtbDLT/HGuKzTZ6a+88C+VN3wVUtvXWo55F9e+iQNzMra48I3FJXqKWtMipxUbeo3E8WTDdhhZ/2LSncZ3msfRrMm01JzGx+b0DiH+7niA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZP5xybzKHMrS;
	Fri,  9 Oct 2026 18:36:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C05B440577;
	Fri,  9 Oct 2026 18:37:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S31;
	Fri, 09 Oct 2026 18:37:21 +0800 (CST)
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
Subject: [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
Date: Fri,  9 Oct 2026 18:30:28 +0800
Message-ID: <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S31
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWxXF4UurW8Cw17Xw48tFb_yoWxGry8p3
	y5K34rCr4DKr9F9w4SvFyIqr1F9ayrJa1UGFZ7Wr42vay5WF1IgFyxK348uFWUJrZxJay2
	qF45CFWku3WjyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnI
	WIevJa73UjIFyTuYvjTRRyxRDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In the iomap buffered I/O path, data=ordered mode is not used, so the
zeroed EOF block has no implicit ordering with later i_disksize updates.
Without the pending state being set, i_disksize can be advanced past the
zeroed block before writeback completes, exposing stale data after a
crash.

Previous patches added the consumer side of the
disksize-grow-pending mechanism: the state bit, clear and wait helpers,
and ioend tagging. Now add ext4_iomap_mark_disksize_pending() and call
it from ext4_block_zero_eof() after zeroing the tail of the block that
straddles i_disksize.

The helper locks the folio, waits for any in-flight writeback on it to
complete, then sets EXT4_STATE_DISKSIZE_GROW_PENDING only if the folio
is still dirty. Waiting for writeback prevents folio_test_dirty() from
returning false mid-writeback, which would cause us to skip the pending
state while zeroed data is still in flight. The dirty check then avoids
setting the bit when the data has already been written back.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 106 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 94 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b6916609000c..3bdb5f3b119ab 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4847,6 +4847,89 @@ static int ext4_block_zero_range(struct inode *inode,
 					zero_written);
 }
 
+/*
+ * Inodes using the iomap buffered I/O path do not use data=ordered mode.
+ * Therefore, we mark the inode as disksize-grow-pending after zeroing the
+ * EOF block. The zeroed block will be submitted before any subsequent
+ * data.
+ *
+ * In the I/O completion path, ext4_iomap_wb_disksize_pending_wait() will
+ * wait for I/O completion before advancing i_disksize if the write
+ * extends beyond the zeroed boundary.
+ *
+ * When zeroed I/O is in progress, operations that extend i_disksize are
+ * handled as follows:
+ *
+ *  - Truncate up, append fallocate and zero_range:
+ *    Defer the update. The file size will be updated to i_size by the
+ *    end_io handler once the ongoing pending I/O completes.
+ *
+ *  - Insert range and collapse range operations:
+ *    Wait synchronously for the relevant I/O to complete before updating
+ *    i_disksize.
+ */
+static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
+{
+	struct folio *folio;
+
+	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
+	if (IS_ERR(folio))
+		/* Already in writeback and cleared? */
+		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
+
+	/*
+	 * Ensure that in-flight writeback, possibly started after
+	 * iomap_zero_range() unlocked the folio, has completed. Without
+	 * this wait folio_test_dirty() below may miss the zeroed data
+	 * (writeback clears PG_dirty), causing us to skip the
+	 * disksize-grow-pending tracking and potentially expose stale
+	 * on-disk data.
+	 */
+	folio_wait_writeback(folio);
+	WARN_ON_ONCE(folio_test_writeback(folio));
+
+	/*
+	 * If the zeroed range does not overlap the existing on-disk tail
+	 * block, the zeroed data lies beyond the currently on-disk data
+	 * and will be written back before i_disksize is advanced past it,
+	 * so no stale data can be exposed.
+	 *
+	 * Checking i_disksize here (after folio_wait_writeback()) is
+	 * necessary and safe. If a delalloc writeback of this folio was
+	 * in-flight, it could be raced by a concurrent mmap write which
+	 * corrupts the tail block beyond i_size but the i_disksize is not
+	 * advanced. folio_wait_writeback() has waited for its completion
+	 * and the ioend has advanced i_disksize accordingly. If writeback
+	 * had not started, we don't need to mark any pending state because
+	 * any future writeback will carry the pagecache content that now
+	 * includes the zeroed data, so no stale data can appear on disk
+	 * even without the pending tracking.
+	 */
+	if (from >= round_up(READ_ONCE(EXT4_I(inode)->i_disksize),
+			     i_blocksize(inode)))
+		goto out;
+
+	/*
+	 * Mark the inode as disksize-grow-pending. The zeroed block will
+	 * be written out by the generic writepages cycle or any other
+	 * syncing operation.
+	 *
+	 * Multiple overlapping unaligned EOF writes should not happen,
+	 * because we only mark the pending state after zeroing the on-disk
+	 * EOF block, and i_disksize can only be updated after the previous
+	 * zeroed pending block has been written back or the dirty folio
+	 * has been discarded.
+	 */
+	if (likely(folio_test_dirty(folio) &&
+		   !ext4_test_inode_state(inode,
+					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
+		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
+out:
+	folio_unlock(folio);
+	folio_put(folio);
+	return 0;
+}
+
 /*
  * Submit and wait for the pending zeroed EOF block range to complete
  * if the given range [@offset, @end) fully covers it.  Must be called
@@ -4923,21 +5006,20 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * truncating up or performing an append write, because there might be
 	 * exposing stale on-disk data which may caused by concurrent post-EOF
 	 * mmap write during folio writeback.
-	 *
-	 * TODO: In the iomap path, handle this by tracking the ordered range
-	 * and updating i_disksize to i_size after the zeroed data has been
-	 * written back.
 	 */
-	if (ext4_should_order_data(inode) &&
-	    did_zero && zero_written && !IS_DAX(inode)) {
-		handle_t *handle;
+	if (did_zero && zero_written && !IS_DAX(inode)) {
+		if (ext4_should_order_data(inode)) {
+			handle_t *handle;
 
-		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
+			if (IS_ERR(handle))
+				return PTR_ERR(handle);
 
-		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
-		ext4_journal_stop(handle);
+			err = ext4_jbd2_inode_add_write(handle, inode, from,
+							length);
+			ext4_journal_stop(handle);
+		} else if (ext4_inode_buffered_iomap(inode))
+			err = ext4_iomap_mark_disksize_pending(inode, from);
 		if (err)
 			return err;
 	}
-- 
2.52.0

