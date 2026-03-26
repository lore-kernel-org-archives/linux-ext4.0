Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0CA3750CF;
	Thu, 26 Mar 2026 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523758; cv=none; b=I4YNuzkFDfeX18MrOGWOvvLOXEQ4TLL3+lqQ2S5PlEjJS6/KYEQuzXn9EhPwYud5d2wDYjmx6VbcNptKdKjtayH2a/c60hGC2kqDoPp1I6xcBVgjYp9kaUfCf9Y/wmdOTw6cib/XaB/XJgOrXk4mPs6TMgvPprkgYYwdD2sDvu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523758; c=relaxed/simple;
	bh=Fy/wrAn7UeduL9im/mFNfm4g1WOZfxbR7ZFljLh3Psw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYMXapPd+icpsVqcbEplGad2uB4RBJYPUzOGun2t6tYifMx9mCFDFoO/6l0bLBVyTPG5vyZ2Fjefz2/AxjaZk2yTltRIBNtRWN2iKq5DXHJy6MTXglTjfEEw/+OPiDlkb0gCnZXjWpG2wwP7e0Blj94966RrpV5L3Gg3D14tjLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhLmV0BDYzYQv75;
	Thu, 26 Mar 2026 19:15:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id F07B74056F;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S9;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 05/11] ext4: move ordered data handling out of ext4_block_do_zero_range()
Date: Thu, 26 Mar 2026 19:10:48 +0800
Message-ID: <20260326111054.907252-6-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260326111054.907252-1-yi.zhang@huaweicloud.com>
References: <20260326111054.907252-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S9
X-Coremail-Antispam: 1UD129KBjvJXoW3JF1UCFy8ZrW5Cr1kuFWxWFg_yoW7KrW3pF
	y5K345Cr47WF9F9Fs7JF17XF1ak3WfGFW8WrWxGr9Yv3y2qwn7KFyUKryFvF4Yq3y3W3W0
	qF45t34jg3W7AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VUbPC7UUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Remove the handle parameter from ext4_block_do_zero_range() and move the
ordered data handling to ext4_block_zero_eof().

This is necessary for truncate up and append writes across a range
extending beyond EOF. The ordered data must be committed before updating
i_disksize to prevent exposing stale on-disk data from concurrent
post-EOF mmap writes during previous folio writeback or in case of
system crash during append writes.

This is unnecessary for partial block hole punching because the entire
punch operation does not provide atomicity guarantees and can already
expose intermediate results in case of crash.

Hole punching can only ever expose data that was there before the punch
but missed zeroing during append / truncate could expose data that was
not visible in the file before the operation.

Since ordered data handling is no longer performed inside
ext4_zero_partial_blocks(), ext4_punch_hole() no longer needs to attach
jinode.

This is prepared for the conversion to the iomap infrastructure, which
does not use ordered data mode while zeroing post-EOF partial blocks.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 61 ++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 543f7e4a60fa..a480676193f4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4075,12 +4075,12 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 	return err ? ERR_PTR(err) : NULL;
 }
 
-static int ext4_block_do_zero_range(handle_t *handle, struct inode *inode,
-				    loff_t from, loff_t length, bool *did_zero)
+static int ext4_block_do_zero_range(struct inode *inode, loff_t from,
+				    loff_t length, bool *did_zero,
+				    bool *zero_written)
 {
 	struct buffer_head *bh;
 	struct folio *folio;
-	int err = 0;
 
 	bh = ext4_load_tail_bh(inode, from);
 	if (IS_ERR_OR_NULL(bh))
@@ -4091,19 +4091,14 @@ static int ext4_block_do_zero_range(handle_t *handle, struct inode *inode,
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	mark_buffer_dirty(bh);
-	/*
-	 * Only the written block requires ordered data to prevent exposing
-	 * stale data.
-	 */
-	if (ext4_should_order_data(inode) &&
-	    !buffer_unwritten(bh) && !buffer_delay(bh))
-		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
-	if (!err && did_zero)
+	if (did_zero)
 		*did_zero = true;
+	if (zero_written && !buffer_unwritten(bh) && !buffer_delay(bh))
+		*zero_written = true;
 
 	folio_unlock(folio);
 	folio_put(folio);
-	return err;
+	return 0;
 }
 
 static int ext4_block_journalled_zero_range(handle_t *handle,
@@ -4147,7 +4142,8 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
  * that corresponds to 'from'
  */
 static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
-				 loff_t from, loff_t length, bool *did_zero)
+				 loff_t from, loff_t length, bool *did_zero,
+				 bool *zero_written)
 {
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	unsigned int max = blocksize - (from & (blocksize - 1));
@@ -4166,7 +4162,8 @@ static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
 		return ext4_block_journalled_zero_range(handle, inode, from,
 							length, did_zero);
 	}
-	return ext4_block_do_zero_range(handle, inode, from, length, did_zero);
+	return ext4_block_do_zero_range(inode, from, length, did_zero,
+					zero_written);
 }
 
 /*
@@ -4182,6 +4179,9 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
 	unsigned int blocksize = i_blocksize(inode);
 	unsigned int offset;
 	loff_t length = end - from;
+	bool did_zero = false;
+	bool zero_written = false;
+	int err;
 
 	offset = from & (blocksize - 1);
 	if (!offset || from >= end)
@@ -4193,7 +4193,21 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
 	if (length > blocksize - offset)
 		length = blocksize - offset;
 
-	return ext4_block_zero_range(handle, inode, from, length, NULL);
+	err = ext4_block_zero_range(handle, inode, from, length,
+				    &did_zero, &zero_written);
+	if (err)
+		return err;
+	/*
+	 * It's necessary to order zeroed data before update i_disksize when
+	 * truncating up or performing an append write, because there might be
+	 * exposing stale on-disk data which may caused by concurrent post-EOF
+	 * mmap write during folio writeback.
+	 */
+	if (ext4_should_order_data(inode) &&
+	    did_zero && zero_written && !IS_DAX(inode))
+		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
+
+	return err;
 }
 
 int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
@@ -4215,13 +4229,13 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
 		err = ext4_block_zero_range(handle, inode, lstart,
-					    length, NULL);
+					    length, NULL, NULL);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
 		err = ext4_block_zero_range(handle, inode, lstart,
-					    sb->s_blocksize, NULL);
+					    sb->s_blocksize, NULL, NULL);
 		if (err)
 			return err;
 	}
@@ -4229,7 +4243,7 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 	if (partial_end != sb->s_blocksize - 1)
 		err = ext4_block_zero_range(handle, inode,
 					    byte_end - partial_end,
-					    partial_end + 1, NULL);
+					    partial_end + 1, NULL, NULL);
 	return err;
 }
 
@@ -4404,17 +4418,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		end = max_end;
 	length = end - offset;
 
-	/*
-	 * Attach jinode to inode for jbd2 if we do any zeroing of partial
-	 * block.
-	 */
-	if (!IS_ALIGNED(offset | end, sb->s_blocksize)) {
-		ret = ext4_inode_attach_jinode(inode);
-		if (ret < 0)
-			return ret;
-	}
-
-
 	ret = ext4_update_disksize_before_punch(inode, offset, length);
 	if (ret)
 		return ret;
-- 
2.52.0

