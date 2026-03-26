Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1F038239B;
	Thu, 26 Mar 2026 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523755; cv=none; b=cBOEuko+i5i/XBr26KfF0eA6tzGVsisCLt1No0FFCTUh18jQBICHS3dKwRazWmzi8c/WFNmK3etKUt/7lQumRgvRPclV5Wf7/SfGKVVdXL1QAHUzxMju7tFdSTPfxUoCCsveDwy2zrEMYcKMKt4bipFALUtvucuSwS/QNaRHAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523755; c=relaxed/simple;
	bh=9g2x6Qbjyhqkv1VxjCVvNgCfVDAo7IdAPNC9y4TjOd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IY7axBaHrxXTqNMSZ+8cGT13xVsKBNJQH2bc2GoWUNC/shxgKqjy3cT1HBtXRsH3HCaz+Pa5hH4f1qjPFmWROeucmq7Zw3FgVEffImvvNXhC7izDfeOAD4a16GF1Q9ZR7ATkV2eZnCdc4iiEiCZEvZ2bMbbBnA41FA2SJXsmyic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fhLlx6KMWzKHMlj;
	Thu, 26 Mar 2026 19:15:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 0D7704058D;
	Thu, 26 Mar 2026 19:15:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S10;
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
Subject: [PATCH v3 06/11] ext4: remove handle parameters from zero partial block functions
Date: Thu, 26 Mar 2026 19:10:49 +0800
Message-ID: <20260326111054.907252-7-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S10
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw1rKw47Kr4DGw4rWw17KFg_yoWfur4Dp3
	4UJw1UCr43uryv9F4IgF47Zr1a93WxGF48WryfGryFvaykX3Z7KF1DKF1FyF4jqr47Wa10
	vF4Yy34jg3WUJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Only journal data mode requires an active journal handle when zeroing
partial blocks. Stop passing handle_t *handle to
ext4_zero_partial_blocks() and related functions, and make
ext4_block_journalled_zero_range() start a handle independently.

This change has no practical impact now because all callers invoke these
functions within the context of an active handle. It prepares for moving
ext4_block_zero_eof() out of an active handle in the next patch, which
is a prerequisite for converting block zero range operations to iomap
infrastructure.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  7 ++---
 fs/ext4/extents.c |  5 ++--
 fs/ext4/inode.c   | 71 ++++++++++++++++++++++++++++-------------------
 3 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c62459ef9796..859ae05339ad 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3099,10 +3099,9 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 				  int pextents);
-extern int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
-			       loff_t from, loff_t end);
-extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
-			     loff_t lstart, loff_t lend);
+extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
+extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
+				    loff_t length);
 extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a265070c1b79..753a0f3418a4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4625,8 +4625,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 						      inode_get_ctime(inode));
 			if (epos > old_size) {
 				pagecache_isize_extended(inode, old_size, epos);
-				ext4_block_zero_eof(handle, inode, old_size,
-						    epos);
+				ext4_block_zero_eof(inode, old_size, epos);
 			}
 		}
 		ret2 = ext4_mark_inode_dirty(handle, inode);
@@ -4744,7 +4743,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	}
 
 	/* Zero out partial block at the edges of the range */
-	ret = ext4_zero_partial_blocks(handle, inode, offset, len);
+	ret = ext4_zero_partial_blocks(inode, offset, len);
 	if (ret)
 		goto out_handle;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a480676193f4..94c8e8c3984f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1458,7 +1458,7 @@ static int ext4_write_end(const struct kiocb *iocb,
 
 	if (old_size < pos && !verity) {
 		pagecache_isize_extended(inode, old_size, pos);
-		ext4_block_zero_eof(handle, inode, old_size, pos);
+		ext4_block_zero_eof(inode, old_size, pos);
 	}
 	/*
 	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
@@ -1576,7 +1576,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	if (old_size < pos && !verity) {
 		pagecache_isize_extended(inode, old_size, pos);
-		ext4_block_zero_eof(handle, inode, old_size, pos);
+		ext4_block_zero_eof(inode, old_size, pos);
 	}
 
 	if (size_changed) {
@@ -3252,7 +3252,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	if (zero_len)
-		ext4_block_zero_eof(handle, inode, old_size, pos);
+		ext4_block_zero_eof(inode, old_size, pos);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
 
@@ -4101,16 +4101,23 @@ static int ext4_block_do_zero_range(struct inode *inode, loff_t from,
 	return 0;
 }
 
-static int ext4_block_journalled_zero_range(handle_t *handle,
-		struct inode *inode, loff_t from, loff_t length, bool *did_zero)
+static int ext4_block_journalled_zero_range(struct inode *inode, loff_t from,
+					    loff_t length, bool *did_zero)
 {
 	struct buffer_head *bh;
 	struct folio *folio;
+	handle_t *handle;
 	int err;
 
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
 	bh = ext4_load_tail_bh(inode, from);
-	if (IS_ERR_OR_NULL(bh))
-		return PTR_ERR_OR_ZERO(bh);
+	if (IS_ERR_OR_NULL(bh)) {
+		err = PTR_ERR_OR_ZERO(bh);
+		goto out_handle;
+	}
 	folio = bh->b_folio;
 
 	BUFFER_TRACE(bh, "get write access");
@@ -4131,6 +4138,8 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
 out:
 	folio_unlock(folio);
 	folio_put(folio);
+out_handle:
+	ext4_journal_stop(handle);
 	return err;
 }
 
@@ -4141,7 +4150,7 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
  * the end of the block it will be shortened to end of the block
  * that corresponds to 'from'
  */
-static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
+static int ext4_block_zero_range(struct inode *inode,
 				 loff_t from, loff_t length, bool *did_zero,
 				 bool *zero_written)
 {
@@ -4159,8 +4168,8 @@ static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
 		return dax_zero_range(inode, from, length, did_zero,
 				      &ext4_iomap_ops);
 	} else if (ext4_should_journal_data(inode)) {
-		return ext4_block_journalled_zero_range(handle, inode, from,
-							length, did_zero);
+		return ext4_block_journalled_zero_range(inode, from, length,
+							did_zero);
 	}
 	return ext4_block_do_zero_range(inode, from, length, did_zero,
 					zero_written);
@@ -4173,8 +4182,7 @@ static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
  * to physically zero the tail end of that block so it doesn't yield old
  * data if the file is grown.
  */
-int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
-			loff_t from, loff_t end)
+int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 {
 	unsigned int blocksize = i_blocksize(inode);
 	unsigned int offset;
@@ -4193,7 +4201,7 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
 	if (length > blocksize - offset)
 		length = blocksize - offset;
 
-	err = ext4_block_zero_range(handle, inode, from, length,
+	err = ext4_block_zero_range(inode, from, length,
 				    &did_zero, &zero_written);
 	if (err)
 		return err;
@@ -4204,14 +4212,23 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
 	 * mmap write during folio writeback.
 	 */
 	if (ext4_should_order_data(inode) &&
-	    did_zero && zero_written && !IS_DAX(inode))
-		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
+	    did_zero && zero_written && !IS_DAX(inode)) {
+		handle_t *handle;
 
-	return err;
+		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
+		ext4_journal_stop(handle);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
-int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
-			     loff_t lstart, loff_t length)
+int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned partial_start, partial_end;
@@ -4228,21 +4245,19 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 	/* Handle partial zero within the single block */
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
-		err = ext4_block_zero_range(handle, inode, lstart,
-					    length, NULL, NULL);
+		err = ext4_block_zero_range(inode, lstart, length, NULL, NULL);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
-		err = ext4_block_zero_range(handle, inode, lstart,
-					    sb->s_blocksize, NULL, NULL);
+		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
+					    NULL, NULL);
 		if (err)
 			return err;
 	}
 	/* Handle partial zero out on the end of the range */
 	if (partial_end != sb->s_blocksize - 1)
-		err = ext4_block_zero_range(handle, inode,
-					    byte_end - partial_end,
+		err = ext4_block_zero_range(inode, byte_end - partial_end,
 					    partial_end + 1, NULL, NULL);
 	return err;
 }
@@ -4438,7 +4453,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		return ret;
 	}
 
-	ret = ext4_zero_partial_blocks(handle, inode, offset, length);
+	ret = ext4_zero_partial_blocks(inode, offset, length);
 	if (ret)
 		goto out_handle;
 
@@ -4588,7 +4603,7 @@ int ext4_truncate(struct inode *inode)
 
 	/* Zero to the end of the block containing i_size */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
-		ext4_block_zero_eof(handle, inode, inode->i_size, LLONG_MAX);
+		ext4_block_zero_eof(inode, inode->i_size, LLONG_MAX);
 
 	/*
 	 * We add the inode to the orphan list, so that if this
@@ -5965,8 +5980,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 				inode_set_mtime_to_ts(inode,
 						      inode_set_ctime_current(inode));
 				if (oldsize & (inode->i_sb->s_blocksize - 1))
-					ext4_block_zero_eof(handle, inode,
-							    oldsize, LLONG_MAX);
+					ext4_block_zero_eof(inode, oldsize,
+							    LLONG_MAX);
 			}
 
 			if (shrink)
-- 
2.52.0

