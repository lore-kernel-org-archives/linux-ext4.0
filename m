Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49483388E5A;
	Mon, 11 May 2026 07:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484517; cv=none; b=k6d1eWEt3l8l1QsdAfmNZpQLbnOIkImMoZbged5h3/dm1OJX3UimEE/0hY3LVNFY9DDgHlcp6WmHz/VQOHKNXW8A/6Tu3EbdC679R/ZygOWI27Oo0XzqjG8iJAxyeRJ8AIt1RCQbBaaT0cBm3Gn8KdekixoFgPls/T+KOft3n0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484517; c=relaxed/simple;
	bh=lpABSLQe57xHGvtOsXpd4YUWod4lWlx6xy4V7JrXUL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ba5aag2YdK88KpAFhbGdcPMus0wXk25aWcmbjAKDva8xumt7rlyZfHUZsmAwgr55Y+P59UTV1o5UsSc2T6YaaBxyPN3wizLaS7tVFjO6KFvR/AmetAUnETKARBstqcNEpcKoVyTNIofq+ZybPJ0UqUayBXquLt+gTDYkIQCa0lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gDWX54x6DzKHMfw;
	Mon, 11 May 2026 15:27:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 382634056E;
	Mon, 11 May 2026 15:28:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S24;
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
Subject: [PATCH v4 20/23] ext4: wait for ordered I/O to complete during insert and collapse range
Date: Mon, 11 May 2026 15:23:40 +0800
Message-ID: <20260511072344.191271-21-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S24
X-Coremail-Antispam: 1UD129KBjvJXoWxGF18GFyUur1Duw1kuFWfKrg_yoW5KFWkpr
	WfK3y8GF48X34q9rs2qFZrZw1Fga1rKw48JFWfurWqvay5G34IvFn0yFy0kFW8trZ8JrWj
	qF4kK3y7Xw18A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Currently, i_disksize is updated after ordered data writeback to prevent
exposing stale data in the post-EOF block, and operations like append
allocate, zero range, and truncate defer the i_disksize update until
ordered I/O completes.

However, insert range and collapse range still directly update
i_disksize. This is safe because they have already called
filemap_write_and_wait_range() to flush data up to LLONG_MAX, ensuring
that ordered I/O has completed if any dirty data was present.

One exception is when the ordered I/O is caused by a previous truncate
up. In this case, there is no dirty data to flush. Therefore, add an
explicit wait for I/O completion to handle this case. This will not have
significant impact on performance.

Finally, also add a WARN_ON_ONCE check before updating i_disksize to
detect any unexpected cases that could still expose stale data.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 18 ++++++++++++++++++
 fs/ext4/inode.c   |  4 +++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 125f628e738a..85c74c37f0ca 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5565,6 +5565,14 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 	if (ret)
 		return ret;
 
+	/*
+	 * Wait for ordered I/O to be complete. Updating i_disksize beyond
+	 * the current i_disksize here risks exposuring stale data.
+	 */
+	if (ext4_inode_buffered_iomap(inode))
+		wait_event(EXT4_I(inode)->i_ordered_wq,
+			   READ_ONCE(EXT4_I(inode)->i_ordered_len) == 0);
+
 	truncate_pagecache(inode, start);
 
 	credits = ext4_chunk_trans_extent(inode, 0);
@@ -5597,6 +5605,7 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 		goto out_handle;
 	}
 
+	WARN_ON_ONCE(READ_ONCE(EXT4_I(inode)->i_ordered_len) != 0);
 	new_size = inode->i_size - len;
 	i_size_write(inode, new_size);
 	EXT4_I(inode)->i_disksize = new_size;
@@ -5661,6 +5670,14 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 	if (ret)
 		return ret;
 
+	/*
+	 * Wait for ordered I/O to be complete. Updating i_disksize beyond
+	 * the current i_disksize here risks exposuring stale data.
+	 */
+	if (ext4_inode_buffered_iomap(inode))
+		wait_event(EXT4_I(inode)->i_ordered_wq,
+			   READ_ONCE(EXT4_I(inode)->i_ordered_len) == 0);
+
 	truncate_pagecache(inode, start);
 
 	credits = ext4_chunk_trans_extent(inode, 0);
@@ -5671,6 +5688,7 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	/* Expand file to avoid data loss if there is error while shifting */
+	WARN_ON_ONCE(READ_ONCE(EXT4_I(inode)->i_ordered_len) != 0);
 	inode->i_size += len;
 	EXT4_I(inode)->i_disksize += len;
 	ret = ext4_mark_inode_dirty(handle, inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 23efb44f0c27..e47b504e85c9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4899,7 +4899,9 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 		 *    i_size by the end_io handler once the ongoing I/O
 		 *    completes.
 		 *
-		 *  - TODO: handle insert range and collapse range.
+		 *  - Insert range and collapse range operations:
+		 *    Wait synchronously for the relevant I/O to complete
+		 *    before updating i_disksize.
 		 */
 		} else if (ext4_inode_buffered_iomap(inode)) {
 			err = ext4_iomap_submit_zero_block(inode, from, end);
-- 
2.52.0

