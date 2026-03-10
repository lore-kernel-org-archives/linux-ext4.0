Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ABE2D73B9;
	Tue, 10 Mar 2026 01:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773107102; cv=none; b=V5FINAMV35POjpJ381rA1XlS+RD1sjUCFnBGRUwlKhCKOd+OdwEQwPqozP9aHBBE4cbNe9Lkb9rMQO8x0alsuHokF+Ua3cUpDorGqJp3k4V12nqpDxheCGbcC2owwT7Gdfo+KPa+f91p9UVEFtiH5IJPNU4jsrL9gVv0XYJu7yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773107102; c=relaxed/simple;
	bh=jscshX5VWpXiv8u5ATLZUQOAe8/KIW+AXWJ16z8S6vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNS+bCJWQy5uIquMJBEzHEUHJvw+2oqw6AWwmWYVmfJonXAIfWj1lnrgLZvafKTCajcMATc3cdBE08hfu0I5nUaYv5tpTrrc/UplihhjW56AH3+GbBtSfebTIfs9Sj0v6MpaRrQixgqrjsOy6GJ4QIg5oW0LsDq7nagJsziKd6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fVGrX5tXLzYQv0c;
	Tue, 10 Mar 2026 09:44:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C65754058C;
	Tue, 10 Mar 2026 09:44:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgB3edmQd69pXNliAQ--.11692S7;
	Tue, 10 Mar 2026 09:44:57 +0800 (CST)
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
Subject: [PATCH 03/10] ext4: rename and extend ext4_block_truncate_page()
Date: Tue, 10 Mar 2026 09:40:54 +0800
Message-ID: <20260310014101.4140698-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3edmQd69pXNliAQ--.11692S7
X-Coremail-Antispam: 1UD129KBjvJXoW3XF18Ar15tF17Gw1xJrW3trb_yoW7uw1fp3
	4ayw15Cr1j9ryq9F4IgFsrXr4a93WkGF4UGrWfKryrZasrXF1xKF1DtF1rtFWjqrWxXa1j
	qFs8KrWjgw17J3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUF3kuDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Rename ext4_block_truncate_page() to ext4_block_zero_eof() and extend
its signature to accept an explicit 'end' offset instead of calculating
the block boundary. This helper function now can replace all cases
requiring zeroing of the partial EOF block, including the append
buffered write paths in ext4_*_write_end().

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  2 ++
 fs/ext4/extents.c |  4 ++--
 fs/ext4/inode.c   | 43 +++++++++++++++++++++++--------------------
 3 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..c62459ef9796 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3099,6 +3099,8 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 				  int pextents);
+extern int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
+			       loff_t from, loff_t end);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae3804f36535..a265070c1b79 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4625,8 +4625,8 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 						      inode_get_ctime(inode));
 			if (epos > old_size) {
 				pagecache_isize_extended(inode, old_size, epos);
-				ext4_zero_partial_blocks(handle, inode,
-						     old_size, epos - old_size);
+				ext4_block_zero_eof(handle, inode, old_size,
+						    epos);
 			}
 		}
 		ret2 = ext4_mark_inode_dirty(handle, inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a737ce05e768..52c6a86ad9f9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1458,7 +1458,7 @@ static int ext4_write_end(const struct kiocb *iocb,
 
 	if (old_size < pos && !verity) {
 		pagecache_isize_extended(inode, old_size, pos);
-		ext4_zero_partial_blocks(handle, inode, old_size, pos - old_size);
+		ext4_block_zero_eof(handle, inode, old_size, pos);
 	}
 	/*
 	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
@@ -1576,7 +1576,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	if (old_size < pos && !verity) {
 		pagecache_isize_extended(inode, old_size, pos);
-		ext4_zero_partial_blocks(handle, inode, old_size, pos - old_size);
+		ext4_block_zero_eof(handle, inode, old_size, pos);
 	}
 
 	if (size_changed) {
@@ -3252,7 +3252,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	if (zero_len)
-		ext4_zero_partial_blocks(handle, inode, old_size, zero_len);
+		ext4_block_zero_eof(handle, inode, old_size, pos);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
 
@@ -4132,29 +4132,32 @@ static int ext4_block_zero_page_range(handle_t *handle,
 }
 
 /*
- * ext4_block_truncate_page() zeroes out a mapping from file offset `from'
- * up to the end of the block which corresponds to `from'.
- * This required during truncate. We need to physically zero the tail end
- * of that block so it doesn't yield old data if the file is later grown.
- * Return the zeroed length on success.
+ * Zero out a mapping from file offset 'from' up to the end of the block
+ * which corresponds to 'from' or to the given 'end' inside this block.
+ * This required during truncate up and performing append writes. We need
+ * to physically zero the tail end of that block so it doesn't yield old
+ * data if the file is grown. Return the zeroed length on success.
  */
-static int ext4_block_truncate_page(handle_t *handle,
-		struct address_space *mapping, loff_t from)
+int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
+			loff_t from, loff_t end)
 {
-	unsigned length;
-	unsigned blocksize;
-	struct inode *inode = mapping->host;
+	unsigned int blocksize = i_blocksize(inode);
+	unsigned int offset;
+	loff_t length = end - from;
 	bool did_zero = false;
 	int err;
 
+	offset = from & (blocksize - 1);
+	if (!offset || from >= end)
+		return 0;
 	/* If we are processing an encrypted inode during orphan list handling */
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
 
-	blocksize = i_blocksize(inode);
-	length = blocksize - (from & (blocksize - 1));
+	if (length > blocksize - offset)
+		length = blocksize - offset;
 
-	err = ext4_block_zero_page_range(handle, mapping, from, length,
+	err = ext4_block_zero_page_range(handle, inode->i_mapping, from, length,
 					 &did_zero);
 	if (err)
 		return err;
@@ -4508,7 +4511,6 @@ int ext4_truncate(struct inode *inode)
 	unsigned int credits;
 	int err = 0, err2;
 	handle_t *handle;
-	struct address_space *mapping = inode->i_mapping;
 
 	/*
 	 * There is a possibility that we're either freeing the inode
@@ -4551,8 +4553,9 @@ int ext4_truncate(struct inode *inode)
 		goto out_trace;
 	}
 
+	/* Zero to the end of the block containing i_size */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
-		ext4_block_truncate_page(handle, mapping, inode->i_size);
+		ext4_block_zero_eof(handle, inode, inode->i_size, LLONG_MAX);
 
 	/*
 	 * We add the inode to the orphan list, so that if this
@@ -5911,8 +5914,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 				inode_set_mtime_to_ts(inode,
 						      inode_set_ctime_current(inode));
 				if (oldsize & (inode->i_sb->s_blocksize - 1))
-					ext4_block_truncate_page(handle,
-							inode->i_mapping, oldsize);
+					ext4_block_zero_eof(handle, inode,
+							    oldsize, LLONG_MAX);
 			}
 
 			if (shrink)
-- 
2.52.0

