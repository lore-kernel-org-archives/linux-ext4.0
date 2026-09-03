Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771294AE13C;
	Thu,  3 Sep 2026 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439394; cv=none; b=gu43owstMg2DE34Rs3CDy5/3Pq3DljvYYceI8RECIDgzKMK9Izm1AJOJTj3gQ+CrLA3ee84z7kHbqRTzhJeK/EU0LZfPX5yVHgQGGEt9tD2aUQRMQrwj037c2y/9ykPVHD7I9RaCz7tPuMPrddmsi9JRUrHellodScoQr6O4Qkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439394; c=relaxed/simple;
	bh=nocHEuUKx068DNGYMTHZNj3420elWhMKgB7+zpJlk80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzKDPPsGocNknVYKgGgTORTYFnFj+y1rmCc6uen4fDt7oZJBGvYmqHCGEvpc2d821DpeEU+FZJmaM6HwiA/VxbqeNaS0I+H0cC/rdLK13eqRNfXNhz+yqyeRRE2gpafVi45fmX2W57Nt9D+Ulfv2jjPBWUg6ht/JzJ2bH0V5ugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK416kzwzYQv3v;
	Thu,  3 Sep 2026 20:42:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C8DD740F33;
	Thu,  3 Sep 2026 20:42:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S27;
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
Subject: [PATCH v6 23/31] ext4: advance i_disksize to i_size upon disksize-grow I/O completion
Date: Thu,  3 Sep 2026 20:35:35 +0800
Message-ID: <20260903123543.2302999-24-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S27
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1kKF1UWF4kJw15Aw43Jrb_yoWruF13pr
	W5Krn8Gr48Xr1a9rsaqry0vw1Ska1rA3y8JFW7GrWjqFyYkrZagFWxKFyfWFy0yrs3Zw4q
	q34Dtr4UW3WkAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index 697e12a54a49..4f1176b9332f 100644
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

