Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B989A4A8A08;
	Thu,  3 Sep 2026 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439384; cv=none; b=oD3Uw/NmUEnJkzS/tSoB3w/WkN0JodIA/PnKK99x8XO4KVvDykSr/Uc4POvWo3tzycW2EfxmpP4u+JZ6V/J3J5CgmJJzQL3Fm43x1UmhhuVvZP7FmdXBzDVwJrrO/dlyRdPE1naSAMNsP+rf4Qt1A54er/pyMeJyCLr4AiRdPKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439384; c=relaxed/simple;
	bh=z4oyh0rHBnDTLlFqHBrV6gv0U6mQq7a1ixunl0MS3k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYUGgtupiHD1XfA1+L0vgomGV0ig/ELJQ9XaKC5PtvpZpS6nFDFfT4+oxb1DPqYpjaDUbpwuzVFWnMv4kVx+0PQ7amG/XFn8JruOD8LB6C4D4A7LRmRytKtVJOXIdl+vt5JhtPqWhXH6Nuh2xSL0mgq8Pg3E54ZRW/SqEvqwmT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3q1qL4zKHMll;
	Thu,  3 Sep 2026 20:41:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id DCE0C4058C;
	Thu,  3 Sep 2026 20:42:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S28;
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
Subject: [PATCH v6 24/31] ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
Date: Thu,  3 Sep 2026 20:35:36 +0800
Message-ID: <20260903123543.2302999-25-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S28
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4rAF43XryfJFWxJFWkZwb_yoW7Kw4kpr
	nIkFyrJr1vq3sF9ws2qryIvr4Fya18Jw4UJFy29r4qvFy5Aw4IqF1xtry7GFW8trZ5Ja1j
	qFZ5Gr4rCw1rC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTR_nYFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Operations like append allocate, zero range, and truncate update
i_disksize directly. If the new i_disksize exceeds the original value
while the zeroed EOF block is still awaiting writeback, metadata may be
persisted before the zeroed data, exposing stale data on crash.

Defer i_disksize updates while EXT4_STATE_DISKSIZE_GROW_PENDING is set;
the ioend worker for the pending block will advance i_disksize to i_size
once the zeroed data is written back. The tradeoff is that i_disksize
may lag i_size transiently, but this is observable only to callers that
read i_disksize directly.

Introduce __ext4_set_i_disksize() to centralize the bit check for
callers already holding i_data_sem (ext4_ext_truncate and
ext4_set_inode_size), and refactor ext4_update_inode_size() to take
i_data_sem itself and check the bit atomically with i_size_write(), so
the ioend worker observes the latest i_size under the same lock.

Note that in the O_SYNC mode of ext4_do_fallocate() or
ext4_zero_range(), we need to flush out pending blocks that can update
i_disksize synchronously. This will be handled later, and
EXT4_STATE_DISKSIZE_GROW_PENDING will also be set after everything is
done.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    | 47 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/extents.c |  2 +-
 fs/ext4/inode.c   |  8 +++++---
 3 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 089dbd39c5c2..b26ce3183bac 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3605,30 +3605,67 @@ do {								\
 #define EXT4_FREECLUSTERS_WATERMARK 0
 #endif
 
-/* Update i_disksize. Requires i_rwsem to avoid races with truncate */
+/*
+ * Update i_disksize. Requires i_rwsem to avoid races with truncate.
+ *
+ * In the iomap buffered I/O path, the EXT4_STATE_DISKSIZE_GROW_PENDING
+ * inode state bit indicates that the zeroed EOF partial block which
+ * straddles i_disksize is still waiting writeback.  In that case,
+ * i_disksize will be updated after the pending zeroed data has been
+ * written out.
+ */
 static inline void ext4_update_i_disksize(struct inode *inode, loff_t newsize)
 {
 	WARN_ON_ONCE(S_ISREG(inode->i_mode) &&
 		     !inode_is_locked(inode));
 	down_write(&EXT4_I(inode)->i_data_sem);
-	if (newsize > EXT4_I(inode)->i_disksize)
+	if (newsize > EXT4_I(inode)->i_disksize &&
+	    !ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
 		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
-/* Update i_size, i_disksize. Requires i_rwsem to avoid races with truncate */
+static inline void __ext4_set_i_disksize(struct inode *inode, loff_t newsize)
+{
+	WARN_ON_ONCE(!rwsem_is_locked(&EXT4_I(inode)->i_data_sem));
+
+	if (newsize < EXT4_I(inode)->i_disksize ||
+	    !ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
+		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
+}
+
+/*
+ * Update i_size and i_disksize to @newsize.  Requires i_rwsem to avoid
+ * races with truncate.
+ *
+ * In the iomap buffered I/O path, i_disksize is updated only if no zeroed
+ * pending block straddles i_disksize (EXT4_STATE_DISKSIZE_GROW_PENDING
+ * clear), otherwise the ioend worker for the pending block will advance
+ * i_disksize once the pending block is written back.  Both updates happen
+ * under i_data_sem so that the writeback ioend worker can always see the
+ * latest i_size under the same semaphore.
+ *
+ * Returns 0 if nothing changed, 1 if i_size was raised, 2 if i_disksize
+ * was raised, or 3 if both were.
+ */
 static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
 {
 	int changed = 0;
 
+	if (newsize <= inode->i_size && newsize <= EXT4_I(inode)->i_disksize)
+		return 0;
+
+	down_write(&EXT4_I(inode)->i_data_sem);
 	if (newsize > inode->i_size) {
 		i_size_write(inode, newsize);
 		changed = 1;
 	}
-	if (newsize > EXT4_I(inode)->i_disksize) {
-		ext4_update_i_disksize(inode, newsize);
+	if (newsize > EXT4_I(inode)->i_disksize &&
+	    !ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING)) {
+		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
 		changed |= 2;
 	}
+	up_write(&EXT4_I(inode)->i_data_sem);
 	return changed;
 }
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6c3655..7e5e2caf49fb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4561,7 +4561,7 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
 	 */
 
 	/* we have to know where to truncate from in crash case */
-	EXT4_I(inode)->i_disksize = inode->i_size;
+	__ext4_set_i_disksize(inode, inode->i_size);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err)
 		return err;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4239be5a769f..d2c0be691a1c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6639,8 +6639,10 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
  * Set i_size and i_disksize to 'newsize'.
  *
  * Both i_rwsem and i_data_sem are required here to avoid races between
- * generic append writeback and concurrent truncate that also modify
- * i_size and i_disksize.
+ * generic append writeback (or zeroed pending I/O writeback) and
+ * concurrent operations (e.g., fallocate, truncate) that also modify
+ * i_size and i_disksize. This also ensures that the writeback ioend worker
+ * observes the latest i_size under the same lock protection.
  */
 static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
 {
@@ -6648,7 +6650,7 @@ static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	i_size_write(inode, newsize);
-	EXT4_I(inode)->i_disksize = newsize;
+	__ext4_set_i_disksize(inode, newsize);
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
-- 
2.52.0

