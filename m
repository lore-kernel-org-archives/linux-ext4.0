Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113674BD108;
	Fri,  9 Oct 2026 10:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542256; cv=none; b=lOcN71hZ/xSthU2h8sFzVxocSvM6v4zVe8XpCGA0kzCRVRYtVK3G2DCFWmey0wcn+uU4vpIFhYT1o1cjiRY9IHdgO3CC6RvTgtsWqANcazso51N8VThPP2KPCCTjQZw3rYvMw8C3yw0fJvNSNQrgQwxxxo30uO4K+qsTgECDHkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542256; c=relaxed/simple;
	bh=xfj78OOy7wv8lKa7JZtVQaQvLeJeLFFDYwDWLly6fCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=au5jtnfmX4fExgDaeVzv2zQpT6PtFMDopmZ++z0/NO3HMq98YPEoYKVpFCDEL1z/bKX49DrLh8Fcr/5ajlDDQPbKAZ6GCNp/FzMF0A1D/WNMbX2fnDcOgZiULc2549KrnNAZa3xbSzKm7nBlIEqA8deNkZbQp2fsBUhZ34XXpo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZY0Zy9zYQv8f;
	Fri,  9 Oct 2026 18:36:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 4A09040561;
	Fri,  9 Oct 2026 18:37:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S27;
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
Subject: [PATCH v7 23/31] ext4: advance i_disksize to i_size upon disksize-grow I/O completion
Date: Fri,  9 Oct 2026 18:30:24 +0800
Message-ID: <20261009103033.2920530-24-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S27
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1kKF1UWF4kJw15Aw43Jrb_yoWruF1Dpr
	W5Krn8Gr48Xr1a9rsaqry0vr1Ska1rA3y8JFW7GrWjqFyYkrZagFWxKFyfWFy0yrs3Zw4q
	q34Dtr4UWw1kAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

When the disksize-grow-pending zeroed EOF I/O completes, i_disksize has
to be advanced. Advancing it only to the end of that specific I/O would
discard any later i_disksize updates from concurrent fallocate or
similar operations, causing filesystem inconsistency.

Scanning dirty or writeback folios beyond the current position to
compute a safe advance target is expensive and racy with concurrent
fallocate, so instead advance i_disksize directly to i_size. This may
expose zeroed data (not stale data) after crash recovery when dirty data
in the range is not yet on disk, but only for unaligned append writes,
which is deemed acceptable.

To support this, teach ext4_iomap_wb_update_disksize() to take an
is_disksize_grow flag and advance i_disksize to i_size when set, and
have ext4_iomap_finish_ioend() pass the flag based on the
EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO tag of the completing ioend.

Note that EXT4_STATE_DISKSIZE_GROW_PENDING is not set for now, and it
will be set after everthing is done.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/page-io.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 697e12a54a49a..4f1176b9332f2 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -578,9 +578,9 @@ static void ext4_iomap_wb_disksize_pending_wait(struct inode *inode,
 }
 
 static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
-					 loff_t end)
+					 loff_t end, bool is_disksize_grow)
 {
-	loff_t new_disksize = end;
+	loff_t new_disksize, i_size;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	int ret;
 
@@ -589,7 +589,34 @@ static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 	 * i_data_sem.
 	 */
 	down_write(&ei->i_data_sem);
-	new_disksize = min(new_disksize, i_size_read(inode));
+	i_size = i_size_read(inode);
+
+	/*
+	 * EXT4_STATE_DISKSIZE_GROW_PENDING is cleared when the pending
+	 * I/O completes. However, another thread may have re-set the bit
+	 * between that point and here, meaning i_disksize has already
+	 * been advanced and a new EOF zeroing has been initiated. In that
+	 * case, do not advance i_disksize to i_size; leave it to the
+	 * next pending grow ioend.
+	 */
+	if (is_disksize_grow &&
+	    ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
+		is_disksize_grow = false;
+
+	/*
+	 * Update i_disksize to i_size when EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO
+	 * completes. This is safe because we never directly allocate written
+	 * blocks during buffered writes.
+	 *
+	 * This ensures that i_disksize is correctly advanced during
+	 * truncate-up or append fallocate on a block-unaligned file,
+	 * preventing it from remaining stale. The tradeoff is that zeroed
+	 * data may be exposed after crash recovery if dirty data in this
+	 * range is not yet on disk, but stale data will never be exposed.
+	 * This is because the extent is only converted to written state
+	 * after the data has been persisted.
+	 */
+	new_disksize = is_disksize_grow ? i_size : min(end, i_size);
 	if (new_disksize > ei->i_disksize)
 		WRITE_ONCE(ei->i_disksize, new_disksize);
 	up_write(&ei->i_data_sem);
@@ -607,6 +634,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	loff_t pos = ioend->io_offset;
 	size_t size = ioend->io_size;
 	loff_t end = pos + size;
+	unsigned long io_mode = (unsigned long)ioend->io_private;
+	bool is_disksize_grow = (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO);
 	handle_t *handle;
 	int credits;
 	int ret, err;
@@ -619,7 +648,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	}
 
 	if (!(ioend->io_flags & IOMAP_IOEND_UNWRITTEN) &&
-	    end <= READ_ONCE(EXT4_I(inode)->i_disksize))
+	    end <= READ_ONCE(EXT4_I(inode)->i_disksize) && !is_disksize_grow)
 		goto out;
 
 	/* Wait for disksize-pending zeroed data to be written out. */
@@ -638,8 +667,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	}
 
 	/* Update on-disk size after I/O is completed. */
-	if (end > READ_ONCE(EXT4_I(inode)->i_disksize)) {
-		ret = ext4_iomap_wb_update_disksize(handle, inode, end);
+	if (end > READ_ONCE(EXT4_I(inode)->i_disksize) || is_disksize_grow) {
+		ret = ext4_iomap_wb_update_disksize(handle, inode, end,
+						    is_disksize_grow);
 		if (ret)
 			goto out_journal;
 	}
-- 
2.52.0

