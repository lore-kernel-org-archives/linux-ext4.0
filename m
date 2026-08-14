Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED18415F33;
	Fri, 14 Aug 2026 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700404; cv=none; b=U+vcg12eIWYiwG1H8H76xwziNdI/Nb5hbv0sWl145O53f3Ck03P2WRg4/QcmwdZSteI6xBCaY7zzJbHLWxw+mDQSZIb6V3Yu2mozpHaavsQXqWwgYNHOO6nKOFOZCJqYPfHq62W4xkL1d+A0X2t7W7rLc/KYZKUvJMmXHLgWFPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700404; c=relaxed/simple;
	bh=3Ady3wt/uC5/25alJKtbTUQ/GfPseQtUw5Ix/YPfleI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ztd0rkXzqVAIDbvHlQQpu3HZtiAYAoVXOUz9V/1jiDrhhmoCHC9R5zYfibMIyoPycL+e3rVgMfV9YeSO0O+0dhKbnd/WEwtx978/sTvfWQU7fRat2axlqhuGq/XnOaGLB6/xWRgoExoyRkySo0Bn2txDN7RF+dxH5qRHMa7mep0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyj3tRCzYQvZ6;
	Fri, 14 Aug 2026 17:39:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id BE54C4056D;
	Fri, 14 Aug 2026 17:39:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S30;
	Fri, 14 Aug 2026 17:39:49 +0800 (CST)
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
Subject: [PATCH -next v5 26/32] ext4: submit and wait for disksize-grow I/O in fallocate paths
Date: Fri, 14 Aug 2026 17:33:25 +0800
Message-ID: <20260814093331.1703882-27-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S30
X-Coremail-Antispam: 1UD129KBjvJXoW3GryDur18CF15Kr4Dur17ZFb_yoWxZF1Dp3
	y5Kr15Gr48Wr97ur4SqF4UXr1Yya1xKr48WrZ7ur12vFy5C34xKF1YyFyY9Fy8JrZ5Cw4j
	vF4qg3y5Cw17A3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW7JVWDJwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNF4EDUUUU
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

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  2 ++
 fs/ext4/extents.c | 53 ++++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/inode.c   | 34 ++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b26ce3183bac..504dce9fdc6b 100644
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
index fc5aa2dbefcf..dda6d50e96e3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4876,6 +4876,16 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 			return ret;
 	}
 
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
 	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -4928,10 +4938,20 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
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
@@ -5668,6 +5688,14 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
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
@@ -5715,9 +5743,11 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 		goto out_handle;
 	}
 
+	WARN_ON_ONCE(ext4_test_inode_state(inode,
+				EXT4_STATE_DISKSIZE_GROW_PENDING));
 	new_size = inode->i_size - len;
 	i_size_write(inode, new_size);
-	EXT4_I(inode)->i_disksize = new_size;
+	__ext4_set_i_disksize(inode, new_size);
 
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_mark_inode_dirty(handle, inode);
@@ -5770,6 +5800,14 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
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
@@ -5789,8 +5827,9 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	/* Expand file to avoid data loss if there is error while shifting */
-	inode->i_size += len;
-	EXT4_I(inode)->i_disksize += len;
+	WARN_ON_ONCE(ext4_test_inode_state(inode,
+				EXT4_STATE_DISKSIZE_GROW_PENDING));
+	ext4_update_inode_size(inode, inode->i_size + len);
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (ret)
 		goto out_handle;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0fdc31b21be5..056937e27859 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4823,6 +4823,32 @@ static int ext4_block_zero_range(struct inode *inode,
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
+	ret = filemap_fdatawrite_range(inode->i_mapping, pstart,
+				       pstart + plen - 1);
+	if (ret)
+		return ret;
+
+	ext4_iomap_wait_disksize_pending(inode);
+	return 0;
+}
+
 /*
  * Zero out a mapping from file offset 'from' up to the end of the block
  * which corresponds to 'from' or to the given 'end' inside this block.
@@ -4988,6 +5014,14 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
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

