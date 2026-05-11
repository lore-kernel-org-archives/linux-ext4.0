Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E5F386C22;
	Mon, 11 May 2026 07:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484515; cv=none; b=Q2nO37h8HfIs0rI7sOigvu8V/iuzSlKj+BBqja4XIVZwAPYgIcMavnMUUYh7+q+GnQjfkjM4zr1BkD6HrNgRjKUZJ+mDXsiyofrAlGIJUx2MA+R5610ATHS8IIgI3NqqN7jNtfGk5AJgk7C2MN0coVdtV00MlZAr2OmgFr+TRwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484515; c=relaxed/simple;
	bh=Wpauh6dh+gZDkDxvmaaV/UYT72+kPYVxDhC/IIpMcgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVB2Lv3MKiJelQgOLklEub30NFbk8OaTI1fiyykpFRDqKDibhBMZfxqFa3c1scdNNG10hM9t3VrqU6slIJGUFUkh6WnSrN868dDqZQPoSQQe1W9iRJ62WzNmMkrWU3k1dVUYoJRvJEEb/N+9qMbLYGU5XMth0grO4JN6C3fDOpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gDWX53M65zKHMfg;
	Mon, 11 May 2026 15:27:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0330040571;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S21;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
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
Subject: [PATCH v4 17/23] ext4: submit zeroed post-EOF data immediately in the iomap buffered I/O path
Date: Mon, 11 May 2026 15:23:37 +0800
Message-ID: <20260511072344.191271-18-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S21
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1UKr1rKr1fAry8uFyUJrb_yoWrGw47p3
	y5K34rAr4DWF9F9wsaqF1xXr1akayfGw4UWFWxWw40vay3Ww18KF1Ik34FvFWUtr43Gay2
	qF45AFWDW3WjyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In the generic buffered_head I/O path, we rely on the data=order mode to
ensure that the zeroed EOF block data is written before updating
i_disksize, thus preventing stale data from being exposed.

However, the iomap buffered I/O path cannot use this mechanism. Instead,
we issue the I/O immediately after performing the zero operation
(without synchronous waiting for performance). This can reduce the risk
of exposing stale data, but it does not guarantee that the zero data
will be flushed to disk before the metadata of i_disksize is updated.
The subsequent patches will wait for this I/O to complete before
updating i_disksize.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 239d387ffaf2..e013aeb03d7b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
 					zero_written);
 }
 
+static int ext4_iomap_submit_zero_block(struct inode *inode,
+					loff_t from, loff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct folio *folio;
+	bool do_submit = false;
+
+	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
+	if (IS_ERR(folio))
+		/* Already writeback and clear? */
+		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
+
+	folio_wait_writeback(folio);
+	WARN_ON_ONCE(folio_test_writeback(folio));
+
+	if (likely(folio_test_dirty(folio)))
+		do_submit = true;
+	folio_unlock(folio);
+	folio_put(folio);
+
+	/* Submit zeroed block. */
+	if (do_submit)
+		return filemap_fdatawrite_range(mapping, from, end - 1);
+	return 0;
+}
+
 /*
  * Zero out a mapping from file offset 'from' up to the end of the block
  * which corresponds to 'from' or to the given 'end' inside this block.
@@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
 
-	if (length > blocksize - offset)
+	if (length > blocksize - offset) {
 		length = blocksize - offset;
+		end = from + length;
+	}
 
 	err = ext4_block_zero_range(inode, from, length,
 				    &did_zero, &zero_written);
@@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * TODO: In the iomap path, handle this by updating i_disksize to
 	 * i_size after the zeroed data has been written back.
 	 */
-	if (ext4_should_order_data(inode) &&
-	    did_zero && zero_written && !IS_DAX(inode)) {
-		handle_t *handle;
+	if (did_zero && zero_written && !IS_DAX(inode)) {
+		if (ext4_should_order_data(inode)) {
+			handle_t *handle;
 
-		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
+			if (IS_ERR(handle))
+				return PTR_ERR(handle);
 
-		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
-		ext4_journal_stop(handle);
-		if (err)
-			return err;
+			err = ext4_jbd2_inode_add_write(handle, inode, from,
+							length);
+			ext4_journal_stop(handle);
+			if (err)
+				return err;
+		/*
+		 * inodes using the iomap buffered I/O path do not use the
+		 * data=ordered mode. We submit zeroed range directly here.
+		 * Do not wait for I/O completion for performance.
+		 *
+		 * TODO: Any operation that extends i_disksize (including
+		 * append write end io past the zeroed boundary, truncate up,
+		 * and append fallocate) must wait for the relevant I/O to
+		 * complete before updating i_disksize.
+		 */
+		} else if (ext4_inode_buffered_iomap(inode)) {
+			err = ext4_iomap_submit_zero_block(inode, from, end);
+			if (err)
+				return err;
+		}
 	}
 
 	return 0;
-- 
2.52.0

