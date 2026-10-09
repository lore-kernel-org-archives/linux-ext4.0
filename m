Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116FD4BD342;
	Fri,  9 Oct 2026 10:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542258; cv=none; b=laEPzNNIGTfcg6BeICth1vyprmksn2iJ+04F4u6RHf1Ch9/CQd183vWhb56wTFcMlrf1XsIX9HR1XCAhWPC2zNHcLXjgjs7a/+d5BKgAE7//YVwzvcBgcaawQvKjagL7TL3O2NjxKJC64gxVy0ffi5b3MSyTQfODT2hgLXn2HBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542258; c=relaxed/simple;
	bh=lDFnsjRv0vQaIp2s1lqwhi+eYPRUOQRwrRT8z/a4qVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6NhxjW7oWuge/F8JIySAtSuArUbRz4l9qN6pQZHqJbeD4iuLENRvQv4kmN6Mh89R00xR20vdfRrnO9mRRw35+F27YiUcSuL/MbfiGYIVO1sGleAMCCfRULmobP6qIdHMVqLHHtHfoZMW+2acglrzxzEn1j4JMDdv8p8eCVP1Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZX60MCzYQv94;
	Fri,  9 Oct 2026 18:36:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 0E5B740D34;
	Fri,  9 Oct 2026 18:37:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S25;
	Fri, 09 Oct 2026 18:37:20 +0800 (CST)
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
Subject: [PATCH v7 21/31] ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING state bit and helpers
Date: Fri,  9 Oct 2026 18:30:22 +0800
Message-ID: <20261009103033.2920530-22-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S25
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4kCr4fJF1rZw4rtr48Xrb_yoWrZFy5pr
	srKry5Gr15Xr9F9w4SqFy7Zr1Yka1rJw48GFW3Gr4qqFW5WryxKF1ktFy3ua48trs5Aw42
	qFs0grW7Cw18ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRRyxRDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Inodes using the iomap buffered I/O path do not use data=ordered
mode, so the zeroed EOF block that straddles i_disksize needs explicit
tracking to ensure it is written back before i_disksize is advanced.

Add the EXT4_STATE_DISKSIZE_GROW_PENDING inode state bit and three
helpers: ext4_iomap_clear_disksize_pending() to atomically clear the
bit and wake waiters, ext4_iomap_wait_disksize_pending() to block until
the bit is cleared, and ext4_iomap_get_disksize_pending_range() to
compute the pending range from i_disksize.

These will be used by subsequent patches to serialize i_disksize
updates with the writeback of the zeroed EOF block.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h  |  7 ++++++
 fs/ext4/inode.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 03fa90d2986ff..1c3d736fb700b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2052,6 +2052,9 @@ enum {
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
 	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
 	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
+	EXT4_STATE_DISKSIZE_GROW_PENDING,
+					/* Has zeroed EOF block straddles
+					 * i_disksize awaiting writeback */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
@@ -3219,6 +3222,10 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 				  int pextents, int alloc_extents);
+void ext4_iomap_clear_disksize_pending(struct inode *inode);
+void ext4_iomap_wait_disksize_pending(struct inode *inode);
+unsigned int ext4_iomap_get_disksize_pending_range(struct inode *inode,
+						   loff_t *start);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
 
 #define EXT4_PARTIAL_ZERO_START	0x1
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1c7083a9293e9..9c45a0c01d1c1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -126,6 +126,63 @@ void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw,
 		raw->i_checksum_hi = cpu_to_le16(csum >> 16);
 }
 
+/*
+ * Clear the disksize-grow-pending state and wake up all waiters.
+ * Called when the pending zeroed EOF block which straddles i_disksize
+ * has completed writeback or its folio is discarded.
+ */
+void ext4_iomap_clear_disksize_pending(struct inode *inode)
+{
+	clear_and_wake_up_bit(
+		ext4_inode_state_wait_bit(EXT4_STATE_DISKSIZE_GROW_PENDING),
+		ext4_inode_state_wait_word(inode));
+}
+
+/*
+ * Wait for the disksize-grow-pending zeroed EOF block which straddles
+ * i_disksize to be written back or cleared.
+ */
+void ext4_iomap_wait_disksize_pending(struct inode *inode)
+{
+	wait_on_bit(ext4_inode_state_wait_word(inode),
+		    ext4_inode_state_wait_bit(EXT4_STATE_DISKSIZE_GROW_PENDING),
+		    TASK_UNINTERRUPTIBLE);
+}
+
+/*
+ * Get the range of the disksize-grow-pending zeroed EOF block range
+ * which straddles i_disksize if the EXT4_STATE_DISKSIZE_GROW_PENDING
+ * bit is set.
+ *
+ * Return the pending range, or zero if the BIT has already been cleared.
+ */
+unsigned int ext4_iomap_get_disksize_pending_range(struct inode *inode,
+						   loff_t *start)
+{
+	unsigned int blocksize = i_blocksize(inode);
+	loff_t disksize;
+
+	if (!ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
+		return 0;
+
+	/*
+	 * The pending bit should be set only when i_disksize is not
+	 * block-size aligned. While set, i_disksize must not be advanced,
+	 * and the bit must be cleared when i_disksize is shrunk.
+	 */
+	down_read(&EXT4_I(inode)->i_data_sem);
+	disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
+	if (!ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING) ||
+	    WARN_ON_ONCE(IS_ALIGNED(disksize, blocksize))) {
+		up_read(&EXT4_I(inode)->i_data_sem);
+		return 0;
+	}
+
+	up_read(&EXT4_I(inode)->i_data_sem);
+	*start = disksize;
+	return blocksize - (disksize & (blocksize - 1));
+}
+
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
-- 
2.52.0

