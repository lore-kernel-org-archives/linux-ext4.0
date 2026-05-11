Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626E639934A;
	Mon, 11 May 2026 07:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484526; cv=none; b=SXAITSUejsHYtsFow8DWkEVKql4khecOrAcBxW1Bs8+OYvZzK7MWB+f9m7YTAIAmDR2ekprcDOJmJU9YvqwbtOHjpM6UuF4sftvQ3oIcRLBGWtah/hSFCr1V0tTqdkIx0HfjPSxKBtmz7lTpP0hY5Cqbgn2srOkr7uhqM/auMxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484526; c=relaxed/simple;
	bh=ICkPKQHha3eXpAuWdrMJR8Vcj4myBIwUbNb1f1AnKJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUykNk7LPGURPrPlLf4ulsKEQoLkstyuvYPp+ERAvFnOLSIhb8UZGXYW5G1nuEGt+3K1tUgxKrRb54RMNsmXCXVH+o/TYIE5oqcSdw2z6vlZxMq3vNHfGZ7OZ65OlLLqeepNxFXm7RkJG1QWCFZJuJ8tk9yPrefleXCKV6syfJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXW3ZzFzYQv3s;
	Mon, 11 May 2026 15:27:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2A8A84056B;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S23;
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
Subject: [PATCH v4 19/23] ext4: update i_disksize to i_size on ordered I/O completion
Date: Mon, 11 May 2026 15:23:39 +0800
Message-ID: <20260511072344.191271-20-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S23
X-Coremail-Antispam: 1UD129KBjvJXoWxtr47uryxur1kJFyxtw17GFg_yoWfGr17pr
	W5K34rAw1vq3sa9rs7Xry0qw1Fva1rGw48JFy7ur4vvFy5Cws2vF1xtryfuFW8trZ3Jw4j
	qFWktr48Wr1kAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Currently, i_disksize is updated after ordered data writeback to prevent
exposing stale data in the post-EOF block. However, operations like
append allocate, zero range and truncate update i_disksize directly. If
the new i_disksize exceeds the original value, metadata may be written
back before the zeroed data is persisted. To avoid this, we defer
i_disksize updates when i_ordered_len is non-zero, only applying them
after ordered I/O completes.

However, this deferral introduces a new problem: on ordered I/O
completion, i_disksize is updated only to the end of that specific I/O,
discarding any later updates (e.g., from fallocate) and causing
filesystem inconsistency. A potential fix would involve scanning for
dirty or writeback folios beyond the current position, then updating
i_disksize to the start of the first such folio or to i_size. However,
folio scanning is expensive and concurrency with operations like
fallocate makes this approach prohibitively complex.

Instead, when ordered zero I/O completes, update i_disksize directly to
i_size. This may expose zeroed data (if dirty data within the range is
not yet on disk after crash recovery), but it will never expose stale
data. This limitation is restricted to unaligned append writes and is
deemed acceptable.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    | 29 +++++++++++++++++++++++++----
 fs/ext4/inode.c   | 30 ++++++++++++++++++++----------
 fs/ext4/page-io.c | 25 ++++++++++++++++++++-----
 3 files changed, 65 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9ce2128eea3e..0a3bb44f1e6e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3493,13 +3493,21 @@ do {								\
 #define EXT4_FREECLUSTERS_WATERMARK 0
 #endif
 
-/* Update i_disksize. Requires i_rwsem to avoid races with truncate */
+/*
+ * Update i_disksize. Requires i_rwsem to avoid races with truncate.
+ *
+ * In the iomap buffered I/O path, a non-zero i_ordered_len indicates that
+ * an ordered I/O (zeroing the EOF partial block) is still in progress.
+ * In that case, i_disksize will be updated after the ordered data has
+ * been written out.
+ */
 static inline void ext4_update_i_disksize(struct inode *inode, loff_t newsize)
 {
 	WARN_ON_ONCE(S_ISREG(inode->i_mode) &&
 		     !inode_is_locked(inode));
 	down_write(&EXT4_I(inode)->i_data_sem);
-	if (newsize > EXT4_I(inode)->i_disksize)
+	if (newsize > EXT4_I(inode)->i_disksize &&
+	    READ_ONCE(EXT4_I(inode)->i_ordered_len) == 0)
 		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
@@ -3514,8 +3522,21 @@ static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
 		changed = 1;
 	}
 	if (newsize > EXT4_I(inode)->i_disksize) {
-		ext4_update_i_disksize(inode, newsize);
-		changed |= 2;
+		/*
+		 * Pairs with smp_store_release() in ext4_iomap_end_bio()
+		 * that clears i_ordered_len.  The smp_mb() ensures the
+		 * i_size store above is globally visible before we read
+		 * i_ordered_len.  This way, if we skip the i_disksize
+		 * update because i_ordered_len is still non-zero, the
+		 * ordered-I/O completion path (which reads i_size under
+		 * i_data_sem) is guaranteed to see the new i_size and will
+		 * update i_disksize correctly.
+		 */
+		smp_mb();
+		if (READ_ONCE(EXT4_I(inode)->i_ordered_len) == 0) {
+			ext4_update_i_disksize(inode, newsize);
+			changed |= 2;
+		}
 	}
 	return changed;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 11fb369efeb1..1e208b3fad34 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4868,9 +4868,6 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * truncating up or performing an append write, because there might be
 	 * exposing stale on-disk data which may caused by concurrent post-EOF
 	 * mmap write during folio writeback.
-	 *
-	 * TODO: In the iomap path, handle this by updating i_disksize to
-	 * i_size after the zeroed data has been written back.
 	 */
 	if (did_zero && zero_written && !IS_DAX(inode)) {
 		if (ext4_should_order_data(inode)) {
@@ -4894,9 +4891,15 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 		 * for I/O completion before updating i_disksize if the write
 		 * extends beyond the zeroed boundary.
 		 *
-		 * TODO: Any other operation that extends i_disksize
-		 * (including truncate up and append fallocate) must wait for
-		 * the relevant I/O to complete before updating i_disksize.
+		 * When zeroed I/O is in progress, operations that extend
+		 * i_disksize are handled as follows:
+		 *
+		 *  - Truncate up, append fallocate and zero_range:
+		 *    Defer the update. The file size will be updated to
+		 *    i_size by the end_io handler once the ongoing I/O
+		 *    completes.
+		 *
+		 *  - TODO: handle insert range and collapse range.
 		 */
 		} else if (ext4_inode_buffered_iomap(inode)) {
 			err = ext4_iomap_submit_zero_block(inode, from, end);
@@ -6512,11 +6515,16 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
 }
 
 /*
- * Set i_size and i_disksize to 'newsize'.
+ * Set i_size and i_disksize to 'newsize'.  In the iomap buffered I/O path,
+ * if i_ordered_len is non-zero and newsize exceeds the current i_disksize,
+ * the actual i_disksize update is deferred until after the ordered data is
+ * written out.  In that case, i_disksize will be set to i_size upon I/O
+ * completion.
  *
  * Both i_rwsem and i_data_sem are required here to avoid races between
- * generic append writeback and concurrent truncate that also modify
- * i_size and i_disksize.
+ * generic append writeback (or ordered I/O writeback) and concurrent
+ * operations (e.g., fallocate, truncate) that also modify i_size and
+ * i_disksize.
  */
 static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
 {
@@ -6524,7 +6532,9 @@ static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	i_size_write(inode, newsize);
-	EXT4_I(inode)->i_disksize = newsize;
+	if (READ_ONCE(EXT4_I(inode)->i_ordered_len) == 0 ||
+	    newsize < EXT4_I(inode)->i_disksize)
+		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index ad05ebb49bf6..2ad9f900c9f3 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -654,13 +654,13 @@ static void ext4_iomap_wb_ordered_wait(struct inode *inode,
 }
 
 static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
-					 loff_t end)
+					 loff_t end, bool is_ordered)
 {
-	loff_t new_disksize = end;
+	loff_t new_disksize, i_size;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	int ret;
 
-	if (new_disksize <= READ_ONCE(ei->i_disksize))
+	if (end <= READ_ONCE(ei->i_disksize) && !is_ordered)
 		return 0;
 
 	/*
@@ -668,7 +668,20 @@ static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 	 * are avoided by checking i_size under i_data_sem.
 	 */
 	down_write(&ei->i_data_sem);
-	new_disksize = min(new_disksize, i_size_read(inode));
+	i_size = i_size_read(inode);
+
+	/*
+	 * Update i_disksize to i_size when completing an ordered I/O that
+	 * zeroes the old EOF partial block.  This is safe because we never
+	 * directly allocate written blocks during buffered writes.
+	 *
+	 * This ensures i_disksize is correctly advanced during truncate-up
+	 * or append fallocate on a block-unaligned file, preventing it
+	 * from remaining stale.  A downside is that zeroed data may be
+	 * exposed after crash recovery if the dirty data in this range is
+	 * not yet on disk, but stale data will never be exposed.
+	 */
+	new_disksize = is_ordered ? i_size : min(end, i_size);
 	if (new_disksize > ei->i_disksize)
 		ei->i_disksize = new_disksize;
 	up_write(&ei->i_data_sem);
@@ -685,6 +698,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	struct super_block *sb = inode->i_sb;
 	loff_t pos = ioend->io_offset;
 	size_t size = ioend->io_size;
+	unsigned long io_mode = (unsigned long)ioend->io_private;
 	handle_t *handle;
 	int credits;
 	int ret, err;
@@ -714,7 +728,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 			goto out_journal;
 	}
 
-	ret = ext4_iomap_wb_update_disksize(handle, inode, pos + size);
+	ret = ext4_iomap_wb_update_disksize(handle, inode, pos + size,
+			io_mode == EXT4_IOMAP_IOEND_ORDER_IO);
 out_journal:
 	err = ext4_journal_stop(handle);
 	if (!ret)
-- 
2.52.0

