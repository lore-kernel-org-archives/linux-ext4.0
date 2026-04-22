Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C7B318EE4;
	Wed, 22 Apr 2026 02:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824229; cv=none; b=ry/cNvpNgRfdFENvBwi4YaRq1oU4rFl6zRkN1B+gVv+vTFg/2OZQPP1opkWBpZNE5t8dkSs6gUxMoeF4fS/QlrkDyilRC75yi4+nD9fTAh5A9w8dIF7xdGaYrGNZXz+Qv2zB8hmDp8j2C1xu9jaOi1BYAi99KqUXqvDHXNo8ihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824229; c=relaxed/simple;
	bh=Az1p7Z0+js2vdk8ppJIgCWml4zi9NJHrRJulMljaR50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP4Z9+L83nqYOxnQmp4AFnWh/rYMAl+TtUxDXbH0wHK8UotEmQMbIqwSWeqvzH5Sz7q6BprgEukzHFGc+A/0WXKXI1+O0XpcagXArMCdF7YVhBjn9i2ijpUQjKkGF2mty/5qYyTzpNVtRwnuyrp0X9ZPu5pWcBpUb0ynbnfTmLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0jX53mNGzKHMVC;
	Wed, 22 Apr 2026 10:16:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 8C63B4059E;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S25;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
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
Subject: [PATCH v3 21/22] ext4: update i_disksize to i_size on ordered I/O completion
Date: Wed, 22 Apr 2026 10:10:41 +0800
Message-ID: <20260422021042.4157510-22-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S25
X-Coremail-Antispam: 1UD129KBjvJXoW3WF13JFWxZw1kXr4kuF45KFg_yoWfXrWkpF
	W5K34rAw18XasF9rs2qryUXw1Fva18Gw48JFy7ur4vvFy5Awn2vFyxtryfCFW8trZ5Xw4j
	qFWktr48Wr1kAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Currently, i_disksize is updated after ordered data writeback to prevent
exposing stale data in the post-EOF block. However, operations like
fallocate and truncate update i_disksize directly. If the new i_disksize
exceeds the original value, metadata may be written back before the
zeroed data is persisted. To avoid this, we defer i_disksize updates
when i_ordered_len is non-zero, only applying them after ordered I/O
completes.

But this deferral introduces a new problem: on ordered I/O completion,
i_disksize is updated only to the end of that specific I/O, discarding
any later updates (e.g., from fallocate) and causing filesystem
inconsistency. A potential fix would involve scanning for dirty or
writeback folios beyond the current position, then updating i_disksize
to the start of the first such folio or to i_size. However, folio
scanning is expensive and concurrency with operations like fallocate
makes this approach prohibitively complex.

Instead, update i_disksize directly to i_size upon ordered I/O
completion. This may expose zeroed data if dirty data within the range
is not yet written to disk after crash recovery, but it will never
expose stale data. The is limited to unaligned append writes and is
deemed acceptable.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    | 40 +++++++++++++++++++++++++++++++---------
 fs/ext4/extents.c |  9 +++------
 fs/ext4/inode.c   |  3 ---
 fs/ext4/page-io.c | 23 ++++++++++++++++++-----
 4 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 760400395cb7..59dcec47675f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3495,13 +3495,21 @@ do {								\
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
@@ -3515,7 +3523,8 @@ static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
 		i_size_write(inode, newsize);
 		changed = 1;
 	}
-	if (newsize > EXT4_I(inode)->i_disksize) {
+	if (newsize > EXT4_I(inode)->i_disksize &&
+	    READ_ONCE(EXT4_I(inode)->i_ordered_len) == 0) {
 		ext4_update_i_disksize(inode, newsize);
 		changed |= 2;
 	}
@@ -3523,19 +3532,32 @@ static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
 }
 
 /*
- * Set i_size and i_disksize to 'newsize'.
+ * Set i_size and i_disksize to 'newsize'.  In the iomap buffered I/O path,
+ * if i_ordered_len is non-zero and newsize exceeds the current i_disksize,
+ * the actual i_disksize update is deferred until after the ordered data is
+ * written out. In that case, i_disksize will be set to i_size upon I/O
+ * completion.
  *
  * Both i_rwsem and i_data_sem are required here to avoid races between
- * generic append writeback and concurrent truncate that also modify
- * i_size and i_disksize.
+ * generic append writeback (or ordered I/O writeback) and concurrent
+ * operations like fallocate and truncate that also modify i_size and
+ * i_disksize.
  */
-static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
+static inline void __ext4_set_inode_size(struct inode *inode, loff_t newsize)
 {
 	WARN_ON_ONCE(S_ISREG(inode->i_mode) && !inode_is_locked(inode));
+	WARN_ON_ONCE(!rwsem_is_locked(&EXT4_I(inode)->i_data_sem));
 
-	down_write(&EXT4_I(inode)->i_data_sem);
 	i_size_write(inode, newsize);
-	EXT4_I(inode)->i_disksize = newsize;
+	if (READ_ONCE(EXT4_I(inode)->i_ordered_len) == 0 ||
+	    newsize < EXT4_I(inode)->i_disksize)
+		EXT4_I(inode)->i_disksize = newsize;
+}
+
+static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
+{
+	down_write(&EXT4_I(inode)->i_data_sem);
+	__ext4_set_inode_size(inode, newsize);
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 125f628e738a..e0c36cd920bf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5531,7 +5531,7 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 	ext4_lblk_t start_lblk, end_lblk;
 	handle_t *handle;
 	unsigned int credits;
-	loff_t start, new_size;
+	loff_t start;
 	int ret;
 
 	trace_ext4_collapse_range(inode, offset, len);
@@ -5597,9 +5597,7 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 		goto out_handle;
 	}
 
-	new_size = inode->i_size - len;
-	i_size_write(inode, new_size);
-	EXT4_I(inode)->i_disksize = new_size;
+	__ext4_set_inode_size(inode, inode->i_size - len);
 
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_mark_inode_dirty(handle, inode);
@@ -5671,8 +5669,7 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	/* Expand file to avoid data loss if there is error while shifting */
-	inode->i_size += len;
-	EXT4_I(inode)->i_disksize += len;
+	ext4_set_inode_size(inode, inode->i_size + len);
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (ret)
 		goto out_handle;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 17bd4403c782..d983336390c7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4805,9 +4805,6 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * truncating up or performing an append write, because there might be
 	 * exposing stale on-disk data which may caused by concurrent post-EOF
 	 * mmap write during folio writeback.
-	 *
-	 * TODO: In the iomap path, handle this by updating i_disksize to
-	 * i_size after the zeroed data has been written back.
 	 */
 	if (did_zero && zero_written && !IS_DAX(inode)) {
 		if (ext4_should_order_data(inode)) {
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 9c88671836fe..589c74b9f8a3 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -647,13 +647,13 @@ static void ext4_iomap_wb_ordered_wait(struct inode *inode,
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
@@ -661,7 +661,18 @@ static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 	 * are avoided by checking i_size under i_data_sem.
 	 */
 	down_write(&ei->i_data_sem);
-	new_disksize = min(new_disksize, i_size_read(inode));
+	i_size = i_size_read(inode);
+
+	/*
+	 * Update i_disksize to i_size when completing an ordered I/O that
+	 * zeroes the old EOF partial block. This ensures i_disksize is
+	 * correctly advanced during truncate-up on a blocksize-unaligned
+	 * file, preventing it from remaining stale. A downside is that
+	 * zeroed data may be exposed after crash recovery if the dirty
+	 * data in this range is not yet on disk, but stale data will
+	 * never be exposed.
+	 */
+	new_disksize = is_ordered ? i_size : min(end, i_size);
 	if (new_disksize > ei->i_disksize)
 		ei->i_disksize = new_disksize;
 	up_write(&ei->i_data_sem);
@@ -678,6 +689,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	struct super_block *sb = inode->i_sb;
 	loff_t pos = ioend->io_offset;
 	size_t size = ioend->io_size;
+	unsigned long io_mode = (unsigned long)ioend->io_private;
 	handle_t *handle;
 	int credits;
 	int ret, err;
@@ -707,7 +719,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
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

