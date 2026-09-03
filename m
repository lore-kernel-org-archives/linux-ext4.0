Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479BC4A8A37;
	Thu,  3 Sep 2026 12:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439386; cv=none; b=Ta7kQgYSrp2ZF/e5MGelPD0hjIxivVumW0KpQ73plbSDOXzxdZUQS5gPZdfrEJnpgl/qfZ57DzQ+fLK4q3ybG9sa/sFTjeFxJAQd8+tkCIebMToqN7J+SlYbpA/rEsgcsbhNjnYlvfROkWYGZnYPMpORi0OFBoZ38wVLaAea+hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439386; c=relaxed/simple;
	bh=SZMagkK25oSY05PCLhsOvzXaJ5cZ9+K47vUGegN5ZN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlMKaKd12Z283bpGT2iQQvKXOw8iCTBN/wqifPU8uO2LRxtzenG4i57YrdxxVlB6U0NGiZU68AWwxHaxtS2gYY/AS+LjAmN0UMNPMbpaSk0ygBDcqogdCmlVz7ldAsa8KMUZJzl06AY6ZvTfAV55KbGVT5S30HTWSLvEPCHlvX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3q4HWJzKHMn4;
	Thu,  3 Sep 2026 20:41:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 433374058F;
	Thu,  3 Sep 2026 20:42:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S31;
	Thu, 03 Sep 2026 20:42:52 +0800 (CST)
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
Subject: [PATCH v6 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
Date: Thu,  3 Sep 2026 20:35:39 +0800
Message-ID: <20260903123543.2302999-28-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S31
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWxXF4UurW8Cw17Xw48tFb_yoW7WFyfp3
	y5K3s5Cr4DKr9F9r4Sqw1Sqr1Y93yrJayUGFZ7WrW2va45W3WIgFyxt348uFyUJrZxWa12
	qF45GFWku3WjyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnI
	WIevJa73UjIFyTuYvjTR_nYFDUUUU
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
 fs/ext4/inode.c | 85 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8e8859c8f5b0..4cb0ea82f58c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4838,6 +4838,68 @@ static int ext4_block_zero_range(struct inode *inode,
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
+	 * Mark the inode as disksize-grow-pending. The zeroed block will
+	 * be written out by the generic writepages cycle or any other
+	 * syncing operation.
+	 *
+	 * Multiple overlapping unaligned EOF writes should not happen,
+	 * because we only mark the pending state after zeroing the on-disk
+	 * EOF block, and i_disksize can only be updated after the previous
+	 * zeroed pending block has been written back or the dirty folio
+	 * has been discared.
+	 */
+	if (likely(folio_test_dirty(folio) &&
+		   !ext4_test_inode_state(inode,
+					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
+		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
+
+	folio_unlock(folio);
+	folio_put(folio);
+	return 0;
+}
+
 /*
  * Submit and wait for the pending zeroed EOF block range to complete
  * if the given range [@offset, @end) fully covers it.  Must be called
@@ -4926,22 +4988,21 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * concurrent writeback that updates i_disksize. And if such a race
 	 * occurs, it means the previous unaligned EOF block has already been
 	 * zeroed (if needed) and persisted to disk.
-	 *
-	 * TODO: In the iomap path, handle this by tracking the ordered range
-	 * and updating i_disksize to i_size after the zeroed data has been
-	 * written back.
 	 */
-	if (ext4_should_order_data(inode) &&
-	    did_zero && zero_written && !IS_DAX(inode) &&
+	if (did_zero && zero_written && !IS_DAX(inode) &&
 	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
-		handle_t *handle;
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

