Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AC943CE64;
	Fri, 14 Aug 2026 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700410; cv=none; b=TpxkzbDw4cXQAbseITlhnxnI2tPUbPZ7B2jzYbY34jgPWF7jccDUp0p0gtDYma5SLUmbV51ZR/j+ZlYYIW5hCNiiR+7NWiCoHyEKsvMWXlvq1W1RBJYbDW4a8vZVvn9FJM6upOe8+/tij7HMNqKhJ0e/4Qjdk2XBkHrz1Cxs1pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700410; c=relaxed/simple;
	bh=Z2RtaHCbeerDdnWmNNCCKcU8AQItDLB0+3mXIUNdf0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EzVfceDNywYK1a3flIph36mLvYZmKVuVTd0uMeKAJ+1qd/I4s8YSb5WerySIPqZhd9hX1cCb8sZIkn4bCogzcyq5dvJ2r90CZZLm6AOwq7et5OTDG+V8ddD14/B4yIaLC9co+BsmGCoDtNG6yN7atKtxXqVTUGQA5bstHLf4mq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyR671zzKHNNK;
	Fri, 14 Aug 2026 17:39:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 95E8440561;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S18;
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
Subject: [PATCH -next v5 14/32] ext4: do not use data=ordered mode for inodes using buffered iomap path
Date: Fri, 14 Aug 2026 17:33:13 +0800
Message-ID: <20260814093331.1703882-15-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S18
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWktr1UWr1DCr1kJFWkJFb_yoW7Gryrpr
	W5K3s8JrZYva47ur1kuFW0qr40y3yUJr47Gry2gFsIgay5J3WIgFyrKa4SkFy5trsxGa4I
	qr48Ar97Wa1qyrJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Ar0_tr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNF4EDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The data=ordered mode introduces two fundamental conflicts with the
iomap buffered write path, leading to potential deadlocks.

1) Lock ordering conflict
   In the iomap writeback path, each folio is processed sequentially:
   the folio lock is acquired first, followed by starting a transaction
   to create block mappings.

   In data=ordered mode, writeback triggered by the journal commit
   process may attempt to acquire a folio lock that is already held by
   iomap background writeback process. Meanwhile, iomap, under that same
   folio lock, may start a new transaction to map other blocks on this
   folio and wait for the currently committing transaction to finish,
   resulting in a deadlock.

   Trans N commit                    background writeback(via iomap)

   journal_submit_data_buffers()
    ext4_journal_submit_inode_data_buffers()
     iomap_writepages()
                                     iomap_writepages()
                                     folio_lock()
      folio_lock()  -- wait
                                      iomap_writeback_folio()
                                       iomap_writeback_range()
                                        ext4_journal_start()
                                         start new transaction
                                          -- wait for trans N commit,
					     DEADLOCK
                                         ext4_map_blocks()

   Currently, in the buffer_head writeback path, this is handled by
   starting the transaction before taking any folio locks for writeback.

2) Partial folio submission not supported
   When block size < folio size, a folio may contain both mapped and
   unmapped blocks. In data=ordered mode, a deadlock can occur if the
   journal waits (pure JI_WAIT_DATA) for such a folio to be written back
   while background writeback has already started on it (with the
   writeback flag set). The problem is that mapping the remaining
   delalloc blocks can deadlock because the writeback flag is not
   cleared until the entire folio is processed and committed.

   T0: Assume we have a folio contains four blocks, from front to back,
       they are A, B, C, D. The block B and C are holes, and the last
       block D is written in delalloc mode (the block is not allocated
       yet).
   T1: The background writeback process starts to write back data, set
       writeback flag on the folio, allocates block D, and adds it to
       transaction N's order list of jbd2 in pure JI_WAIT_DATA mode.
   T2: This folio completes the writeback and clears the writeback flag.
   T3: Before transaction N commit, we buffered write block A to C.
   T4: Transaction N commit and folio writeback are running
       concurrently.

   Trans N commit                   background writeback(via iomap)

                                    iomap_writeback_folio()
                                     folio_start_writeback()
                                      -- set writeback flag
   jbd2_journal_finish_inode_data_buffers()
    __filemap_fdatawait_range()
     -- wait writeback flag to clear
                                      iomap_writeback_range()
                                       ext4_journal_start()
                                        start new transaction
                                         -- wait for trans N commit,
                                            DEADLOCK
                                       ext4_map_block() (B, C)

   Currently, in the buffer_head writeback path, this is handled by:

   1. Partial folio submission — already-allocated buffers can be
      submitted first. The writeback flag is cleared after I/O
      completes, preventing block allocation while the writeback flag is
      set.
   2. Allocation order — the transaction is started first, then blocks
      are allocated, the writeback flag is set, and finally the
      allocated buffers submission begins.

To support data=ordered mode, the iomap core would need two invasive
changes:
 - Acquire the transaction handle before locking any folio for
   writeback.
 - Support partial folio submission.

Both changes are complicated and risk performance regressions.
Therefore, we must avoid using data=ordered mode when converting to the
iomap path.

Currently, data=ordered mode is used in three scenarios:
 - Append write
 - Post-EOF partial block truncate-up followed by append write
 - Online defragmentation

We can address the first two without data=ordered mode:
 - For append write: always allocate unwritten blocks (i.e. always
   enable dioread_nolock), preserving the behavior of current
   extent-type inodes.
 - For post-EOF truncate-up + append write: postpone updating i_disksize
   until after the zeroed partial block has been written back.

Online defragmentation does not yet support iomap; this can be resolved
separately in the future.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 2fbf48b3dfe2..be54e93bde0b 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -379,7 +379,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
 
 static inline int ext4_should_order_data(struct inode *inode)
 {
-	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
+	/*
+	 * inodes using the iomap buffered I/O path do not use the
+	 * data=ordered mode.
+	 */
+	return !ext4_inode_buffered_iomap(inode) &&
+		(ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE);
 }
 
 static inline int ext4_should_writeback_data(struct inode *inode)
-- 
2.52.0

