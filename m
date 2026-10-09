Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55AC4BFE8E;
	Fri,  9 Oct 2026 10:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542259; cv=none; b=bq5S5EiaOKjBmM0y21c/3eqb8wp+85Ti/L5xb3xRN8jHwoEwzfJGhLzcwmfFigZQnFZvv3XBc0kQSy+8yvqdtL2OKqhPaCSYjWrvh9XL+Ij2zMg6Hicm3DLP0hm1FVPHziJulCSU7DL2vgOSPFha4QyocYD6eIB7//1Z69wLN40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542259; c=relaxed/simple;
	bh=gIiPyvHzc60sIfyYjIfG4tdOIP8JLYpknalFH9/eJeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0DMTEKwgLql1zJ2zXZIDugNjTRXEpIe+lAk9TZkk+IiV9GVtWDIRBT40h9i1fmwLM7quXyLYosZdOOgW4b+hHi29JXWMVs1BIlLF48vnCITRa0ghr0Phfw/aIoU2xMO27o9/PUTGDy/ISldWX7w8q8JDJT3Q4L0Uk7WllYDC1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZY2LcWzYQv9M;
	Fri,  9 Oct 2026 18:36:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 871E04056F;
	Fri,  9 Oct 2026 18:37:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S29;
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
Subject: [PATCH v7 25/31] ext4: submit and wait for disksize-grow I/O in fallocate paths
Date: Fri,  9 Oct 2026 18:30:26 +0800
Message-ID: <20261009103033.2920530-26-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S29
X-Coremail-Antispam: 1UD129KBjvJXoW3GrykXrW8AF4xKw1rZw1xGrg_yoWxtr4Dpr
	W5Gry5Gr4kWryxur4SqF4UXr1Yya1fKr48WrZ7ur12vry5C34xKF1YyFyY9FyUJrZ5Cw4j
	qF4qg3y5Cw17A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Collapse range and insert range update i_disksize directly under
i_data_sem. If the operation runs while the zeroed EOF block is still
awaiting writeback, i_disksize could advance past the zeroed boundary
before the zeroed data is persisted, exposing stale data on crash.

Deferring i_disksize updates like fallocate and zero_range is not an
option here because the shift would move written extents beyond the
current i_disksize. So flush and wait for the pending zeroed EOF block
before these operations advance i_disksize. Since these operations
already perform writeback, the extra flush does not add significant
overhead.

In addition, for ext4_update_disksize_before_punch(), if the punch
discards the pending block, the zeroed data will never be written back
before advancing i_disksize, so it is also necessary to sync the
pending EOF range there.

Finally, for the SYNC variants of zero_range and fallocate, this also
guarantees the i_disksize update is persisted on the synchronous
return.

Note that EXT4_STATE_DISKSIZE_GROW_PENDING is not set for now, and it
will be set after everything is done.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  2 ++
 fs/ext4/extents.c | 50 ++++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/inode.c   | 41 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b26ce3183bacb..504dce9fdc6b9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3226,6 +3226,8 @@ void ext4_iomap_clear_disksize_pending(struct inode *inode);
 void ext4_iomap_wait_disksize_pending(struct inode *inode);
 unsigned int ext4_iomap_get_disksize_pending_range(struct inode *inode,
 						   loff_t *start);
+extern int ext4_iomap_sync_zeroed_eof(struct inode *inode,
+				      loff_t offset, loff_t end);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
 
 #define EXT4_PARTIAL_ZERO_START	0x1
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b52e5fb156894..a10d8c6e3cf1f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4857,6 +4857,17 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		if (ret)
 			return ret;
 	}
+
+	/*
+	 * In SYNC mode, sync the pending zeroed EOF block to ensure the
+	 * i_disksize update is persisted.
+	 */
+	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && new_size) {
+		ret = ext4_iomap_sync_zeroed_eof(inode, 0, LLONG_MAX);
+		if (ret)
+			return ret;
+	}
+
 	/* Finish zeroing out if it doesn't contain partial block */
 	if (IS_ALIGNED(offset | end, blocksize))
 		return ret;
@@ -4928,10 +4939,20 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
 	if (ret)
 		goto out;
 
-	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) &&
-	    EXT4_SB(inode->i_sb)->s_journal) {
-		ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
-					EXT4_I(inode)->i_sync_tid);
+	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+		/*
+		 * Sync the pending zeroed EOF block to ensure the
+		 * i_disksize update is persisted.
+		 */
+		if (new_size) {
+			ret = ext4_iomap_sync_zeroed_eof(inode, 0, LLONG_MAX);
+			if (ret)
+				goto out;
+		}
+		if (EXT4_SB(inode->i_sb)->s_journal) {
+			ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
+						EXT4_I(inode)->i_sync_tid);
+		}
 	}
 out:
 	trace_ext4_fallocate_exit(inode, offset,
@@ -5673,6 +5694,14 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 	if (end >= inode->i_size)
 		return -EINVAL;
 
+	/*
+	 * Persist the pending zeroed EOF block to ensure i_disksize
+	 * can be safely updated thereafter.
+	 */
+	ret = ext4_iomap_sync_zeroed_eof(inode, 0, LLONG_MAX);
+	if (ret)
+		return ret;
+
 	/*
 	 * Write tail of the last page before removed range and data that
 	 * will be shifted since they will get removed from the page cache
@@ -5722,7 +5751,7 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 
 	new_size = inode->i_size - len;
 	i_size_write(inode, new_size);
-	EXT4_I(inode)->i_disksize = new_size;
+	__ext4_set_i_disksize(inode, new_size);
 
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_mark_inode_dirty(handle, inode);
@@ -5775,6 +5804,14 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 	if (len > inode->i_sb->s_maxbytes - inode->i_size)
 		return -EFBIG;
 
+	/*
+	 * Persist the pending zeroed EOF block to ensure i_disksize
+	 * can be safely updated thereafter.
+	 */
+	ret = ext4_iomap_sync_zeroed_eof(inode, 0, LLONG_MAX);
+	if (ret)
+		return ret;
+
 	/*
 	 * Write out all dirty pages. Need to round down to align start offset
 	 * to page size boundary for page size > block size.
@@ -5794,8 +5831,7 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	/* Expand file to avoid data loss if there is error while shifting */
-	inode->i_size += len;
-	EXT4_I(inode)->i_disksize += len;
+	ext4_update_inode_size(inode, inode->i_size + len);
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (ret)
 		goto out_handle;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5644807cc875b..55f77b52e1685 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4836,6 +4836,39 @@ static int ext4_block_zero_range(struct inode *inode,
 					zero_written);
 }
 
+/*
+ * Submit and wait for the pending zeroed EOF block range to complete
+ * if the given range [@offset, @end) fully covers it.  Must be called
+ * outside the context of an active journal handle and hold the i_rwsem.
+ */
+int ext4_iomap_sync_zeroed_eof(struct inode *inode, loff_t offset, loff_t end)
+{
+	loff_t pstart, plen;
+	int ret;
+
+	if (!ext4_inode_buffered_iomap(inode))
+		return 0;
+
+	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
+	if (!plen || offset > pstart || end < pstart + plen)
+		return 0;
+
+	ret = filemap_write_and_wait_range(inode->i_mapping, pstart,
+					   pstart + plen - 1);
+	if (ret)
+		return ret;
+
+	/*
+	 * The pending bit should have been cleared by the ioend worker,
+	 * which runs before the folio writeback flag is cleared.  The
+	 * caller holds i_rwsem, so no concurrent ext4_block_zero_eof()
+	 * can re-set it.
+	 */
+	WARN_ON_ONCE(ext4_test_inode_state(inode,
+				EXT4_STATE_DISKSIZE_GROW_PENDING));
+	return 0;
+}
+
 /*
  * Zero out a mapping from file offset 'from' up to the end of the block
  * which corresponds to 'from' or to the given 'end' inside this block.
@@ -4994,6 +5027,14 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 	if (offset > size)
 		return 0;
 
+	/*
+	 * We are going to punch the pending zeroed EOF block, persist
+	 * it to ensure i_disksize can be safely updated thereafter.
+	 */
+	ret = ext4_iomap_sync_zeroed_eof(inode, offset, offset + len);
+	if (ret)
+		return ret;
+
 	if (offset + len < size)
 		size = offset + len;
 	if (EXT4_I(inode)->i_disksize >= size)
-- 
2.52.0

