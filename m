Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91B4BD106;
	Fri,  9 Oct 2026 10:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542257; cv=none; b=eWTrC00DelQOmyuoB7wgZZG5H0ITR8xNMjHZIRfuzQI03lB4RrV2sg4AadLNtMorVOQ1wl6z9wRToUJfiKW1SqNShgkA9vDv9aIM3Rp53kE2kWzj7B90k9Odz+HhpGrfStKE1kJ6dSb7gCVlxNWOt4/2yGVIN0OxMo+kqRhDUJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542257; c=relaxed/simple;
	bh=0cmH9u0anDqJitGZHtlrpiQRGV6BWN1RPhjWlIaUFSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHvlJ8W8BNq9osWjOv2/IGyNYX7KpbeKSZdXJvCg94sK16RQ2kRvo5meMLZIxp5mkPKOQ8vGj3Hs3yN+95KhNdpP+w0strEjQfV80iqWnsAPVUT9p+vVGlFE3Uvkg7PRNmSuHanu0BVbUxtMfRBb9bV7W+sF+GQPQmYfC8ZtavA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZY1QCnzYQv95;
	Fri,  9 Oct 2026 18:36:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 660264056D;
	Fri,  9 Oct 2026 18:37:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S28;
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
Subject: [PATCH v7 24/31] ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
Date: Fri,  9 Oct 2026 18:30:25 +0800
Message-ID: <20261009103033.2920530-25-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S28
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4rAF4rCF4UtrW7KFW7urg_yoWxJr1xpr
	9xKF95Jr1vq3sF9ws2qryIvr4Fya18Jw4UGry29F4qvFy5Cw4IqF1xtry7GFW8trZ5Ja1j
	qFZ5Gr4rCw1rCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index 089dbd39c5c24..b26ce3183bacb 100644
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
index 83d040e36b682..b52e5fb156894 100644
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
index 76e070eaa6f89..5644807cc875b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6635,8 +6635,10 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
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
@@ -6644,7 +6646,7 @@ static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	i_size_write(inode, newsize);
-	EXT4_I(inode)->i_disksize = newsize;
+	__ext4_set_i_disksize(inode, newsize);
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
-- 
2.52.0

