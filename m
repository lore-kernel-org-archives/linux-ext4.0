Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6519A2DFF3F;
	Tue, 10 Mar 2026 01:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773107106; cv=none; b=kYtu0besuDQJ2TNIKZBXviYqA1vEZkYTxaryLL5Ulv0rELe1Pt7fs6bgkX0q4P4SC2JfYiRu5RP+MH92k6bWEsaJpydHhYdTsLBAqTePgOHp5Y6/wEVAF2xvIv0F4LhqcpHjfAARuIQNr6KHxyrrgy3Q7EbGsJ7uDVWJ8kidkR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773107106; c=relaxed/simple;
	bh=6Vv1bid1XCoNbI0LntuF4Zqwg6hO2KoRZOzgf0PNhZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdOiRuGvnIaBjO6hi3cgji0lF2j+u0/E57iAdS4ex08qZfvjpL9dActh3MC30TJiFl8z84CfZI7qE1TPxXBz5Jy466u6Q+TKmZlUucON7cc7npUvFZPYCcKonONBScT6RZSA1Lrs0BQ/C+Y8HYt8LD8ossINOjOhKKA9Y9l4d8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fVGrY2NH0zYQv3h;
	Tue, 10 Mar 2026 09:44:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4C02940570;
	Tue, 10 Mar 2026 09:44:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgB3edmQd69pXNliAQ--.11692S13;
	Tue, 10 Mar 2026 09:44:58 +0800 (CST)
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
Subject: [PATCH 09/10] ext4: move zero partial block range functions out of active handle
Date: Tue, 10 Mar 2026 09:41:00 +0800
Message-ID: <20260310014101.4140698-10-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgB3edmQd69pXNliAQ--.11692S13
X-Coremail-Antispam: 1UD129KBjvJXoWxuFW3XFykCFyxCw13Xry5Jwb_yoW7tw1xp3
	98Aa4fKr1kWF909F4IkF47Zr4Yk3WxGr4UGrWxCryFqa4DZw1SkFnIya40vFWUKrWUur4Y
	vF4jkryUG3WUC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Move ext4_block_zero_eof() and ext4_zero_partial_blocks() calls out of
the active handle context, making them independent operations. This is
safe because it still ensures data is updated before metadata for
data=ordered mode and data=journal mode because we still zero data and
ordering data before modifying the metadata.

This change is required for iomap infrastructure conversion because the
iomap buffered I/O path does not use the same journal infrastructure for
partial block zeroing. The lock ordering of folio lock and starting
transactions is "folio lock -> transaction start", which is opposite of
the current path. Therefore, zeroing partial blocks cannot be performed
under the active handle.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 29 ++++++++++++-----------------
 fs/ext4/inode.c   | 36 ++++++++++++++++++------------------
 2 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57a686b600d9..81b9d5b4ad71 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4585,6 +4585,10 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	credits = ext4_chunk_trans_blocks(inode, len_lblk);
 	depth = ext_depth(inode);
 
+	/* Zero to the end of the block containing i_size */
+	if (new_size && offset > old_size)
+		ext4_block_zero_eof(inode, old_size, LLONG_MAX);
+
 retry:
 	while (len_lblk) {
 		/*
@@ -4623,10 +4627,8 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 			if (ext4_update_inode_size(inode, epos) & 0x1)
 				inode_set_mtime_to_ts(inode,
 						      inode_get_ctime(inode));
-			if (epos > old_size) {
+			if (epos > old_size)
 				pagecache_isize_extended(inode, old_size, epos);
-				ext4_block_zero_eof(inode, old_size, epos);
-			}
 		}
 		ret2 = ext4_mark_inode_dirty(handle, inode);
 		ext4_update_inode_fsync_trans(handle, inode, 1);
@@ -4668,7 +4670,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	loff_t align_start, align_end, new_size = 0;
 	loff_t end = offset + len;
 	unsigned int blocksize = i_blocksize(inode);
-	int ret, flags, credits;
+	int ret, flags;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
 	WARN_ON_ONCE(!inode_is_locked(inode));
@@ -4722,25 +4724,18 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (IS_ALIGNED(offset | end, blocksize))
 		return ret;
 
-	/*
-	 * In worst case we have to writeout two nonadjacent unwritten
-	 * blocks and update the inode
-	 */
-	credits = (2 * ext4_ext_index_trans_blocks(inode, 2)) + 1;
-	if (ext4_should_journal_data(inode))
-		credits += 2;
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
+	/* Zero out partial block at the edges of the range */
+	ret = ext4_zero_partial_blocks(inode, offset, len);
+	if (ret)
+		return ret;
+
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		ext4_std_error(inode->i_sb, ret);
 		return ret;
 	}
 
-	/* Zero out partial block at the edges of the range */
-	ret = ext4_zero_partial_blocks(inode, offset, len);
-	if (ret)
-		goto out_handle;
-
 	if (new_size)
 		ext4_update_inode_size(inode, new_size);
 	ret = ext4_mark_inode_dirty(handle, inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d5b783a7c814..5288d36b0f09 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4443,8 +4443,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	if (ret)
 		return ret;
 
+	ret = ext4_zero_partial_blocks(inode, offset, length);
+	if (ret)
+		return ret;
+
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		credits = ext4_chunk_trans_extent(inode, 2);
+		credits = ext4_chunk_trans_extent(inode, 0);
 	else
 		credits = ext4_blocks_for_truncate(inode);
 	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
@@ -4454,10 +4458,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		return ret;
 	}
 
-	ret = ext4_zero_partial_blocks(inode, offset, length);
-	if (ret)
-		goto out_handle;
-
 	/* If there are blocks to remove, do it */
 	start_lblk = EXT4_B_TO_LBLK(inode, offset);
 	end_lblk = end >> inode->i_blkbits;
@@ -4589,6 +4589,9 @@ int ext4_truncate(struct inode *inode)
 		err = ext4_inode_attach_jinode(inode);
 		if (err)
 			goto out_trace;
+
+		/* Zero to the end of the block containing i_size */
+		ext4_block_zero_eof(inode, inode->i_size, LLONG_MAX);
 	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
@@ -4602,10 +4605,6 @@ int ext4_truncate(struct inode *inode)
 		goto out_trace;
 	}
 
-	/* Zero to the end of the block containing i_size */
-	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
-		ext4_block_zero_eof(inode, inode->i_size, LLONG_MAX);
-
 	/*
 	 * We add the inode to the orphan list, so that if this
 	 * truncate spans multiple transactions, and we crash, we will
@@ -5945,15 +5944,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 					goto out_mmap_sem;
 			}
 
-			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
-			if (IS_ERR(handle)) {
-				error = PTR_ERR(handle);
-				goto out_mmap_sem;
-			}
-			if (ext4_handle_valid(handle) && shrink) {
-				error = ext4_orphan_add(handle, inode);
-				orphan = 1;
-			}
 			/*
 			 * Update c/mtime and tail zero the EOF folio on
 			 * truncate up. ext4_truncate() handles the shrink case
@@ -5967,6 +5957,16 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 							    LLONG_MAX);
 			}
 
+			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
+			if (IS_ERR(handle)) {
+				error = PTR_ERR(handle);
+				goto out_mmap_sem;
+			}
+			if (ext4_handle_valid(handle) && shrink) {
+				error = ext4_orphan_add(handle, inode);
+				orphan = 1;
+			}
+
 			if (shrink)
 				ext4_fc_track_range(handle, inode,
 					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
-- 
2.52.0

