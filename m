Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561073DA7DF;
	Fri, 27 Mar 2026 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774607683; cv=none; b=MvXUeqFWEXiVX0t1AL7/5ATf3HggaESuGDdIfivEBI16vTOmX8M3C/tEP11ORpXnTY0tAh39M9A+qAaYXUZdQaLtBf04oMTJhmZWhleN0UDVgDYay+JiEWySTFULHKHFp1J7g0HBhKIuiZOvc6xt+jCKz5zAdc+KFzWXlLCRY/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774607683; c=relaxed/simple;
	bh=QfbPo7seK4B0TDu2BB5BbSBr8hShQvihn/uS493D+9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdWpXFvZ4oXeaHLd06vAYeJqI/YeDr14rVgpNwp6cLlSRLoFLmVLramnhGQ7lf2Mphzx7QC39VQYQS0NC1T4BapwDF9cwDC9oAwbz0qDdulhN8yUNvA/KqfTCjchPaSuFZ2uQyCJsKm00OKT4IeAKcypHorB6N0NE4M2Yj9MMMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhxpM09n0zYQv6M;
	Fri, 27 Mar 2026 18:34:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 980DF40575;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgC3utouXcZp_T2cCQ--.28730S12;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
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
Subject: [PATCH v4 08/13] ext4: move zero partial block range functions out of active handle
Date: Fri, 27 Mar 2026 18:29:34 +0800
Message-ID: <20260327102939.1095257-9-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3utouXcZp_T2cCQ--.28730S12
X-Coremail-Antispam: 1UD129KBjvJXoWxuFWfKF13GFWrAFyDGF15Jwb_yoWxXr4Up3
	y3Aa4fGr1kuF9Y9F4Skr47ZF4ak3WxKr4UWry7Cr10qayDZw1fKF1ayFy0vFWjgrWUZr4Y
	vF4jkry7G3WUC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
the active handle context, making them independent operations, and also
add return value checks. This is safe because it still ensures data is
updated before metadata for data=ordered mode and data=journal mode
because we still zero data and ordering data before modifying the
metadata.

This change is required for iomap infrastructure conversion because the
iomap buffered I/O path does not use the same journal infrastructure for
partial block zeroing. The lock ordering of folio lock and starting
transactions is "folio lock -> transaction start", which is opposite of
the current path. Therefore, zeroing partial blocks cannot be performed
under the active handle.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 32 +++++++++++++++-----------------
 fs/ext4/inode.c   | 47 ++++++++++++++++++++++++++---------------------
 2 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57a686b600d9..002b1ec8cee2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4585,6 +4585,13 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	credits = ext4_chunk_trans_blocks(inode, len_lblk);
 	depth = ext_depth(inode);
 
+	/* Zero to the end of the block containing i_size */
+	if (new_size > old_size) {
+		ret = ext4_block_zero_eof(inode, old_size, LLONG_MAX);
+		if (ret)
+			return ret;
+	}
+
 retry:
 	while (len_lblk) {
 		/*
@@ -4623,10 +4630,8 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
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
@@ -4668,7 +4673,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	loff_t align_start, align_end, new_size = 0;
 	loff_t end = offset + len;
 	unsigned int blocksize = i_blocksize(inode);
-	int ret, flags, credits;
+	int ret, flags;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
 	WARN_ON_ONCE(!inode_is_locked(inode));
@@ -4722,25 +4727,18 @@ static long ext4_zero_range(struct file *file, loff_t offset,
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
index 13655ea709fe..8aa4369e3150 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4441,8 +4441,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
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
@@ -4452,10 +4456,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		return ret;
 	}
 
-	ret = ext4_zero_partial_blocks(inode, offset, length);
-	if (ret)
-		goto out_handle;
-
 	/* If there are blocks to remove, do it */
 	start_lblk = EXT4_B_TO_LBLK(inode, offset);
 	end_lblk = end >> inode->i_blkbits;
@@ -4587,6 +4587,11 @@ int ext4_truncate(struct inode *inode)
 		err = ext4_inode_attach_jinode(inode);
 		if (err)
 			goto out_trace;
+
+		/* Zero to the end of the block containing i_size */
+		err = ext4_block_zero_eof(inode, inode->i_size, LLONG_MAX);
+		if (err)
+			goto out_trace;
 	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
@@ -4600,10 +4605,6 @@ int ext4_truncate(struct inode *inode)
 		goto out_trace;
 	}
 
-	/* Zero to the end of the block containing i_size */
-	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
-		ext4_block_zero_eof(inode, inode->i_size, LLONG_MAX);
-
 	/*
 	 * We add the inode to the orphan list, so that if this
 	 * truncate spans multiple transactions, and we crash, we will
@@ -5961,15 +5962,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
@@ -5978,9 +5970,22 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			if (!shrink) {
 				inode_set_mtime_to_ts(inode,
 						      inode_set_ctime_current(inode));
-				if (oldsize & (inode->i_sb->s_blocksize - 1))
-					ext4_block_zero_eof(inode, oldsize,
-							    LLONG_MAX);
+				if (oldsize & (inode->i_sb->s_blocksize - 1)) {
+					error = ext4_block_zero_eof(inode,
+							oldsize, LLONG_MAX);
+					if (error)
+						goto out_mmap_sem;
+				}
+			}
+
+			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
+			if (IS_ERR(handle)) {
+				error = PTR_ERR(handle);
+				goto out_mmap_sem;
+			}
+			if (ext4_handle_valid(handle) && shrink) {
+				error = ext4_orphan_add(handle, inode);
+				orphan = 1;
 			}
 
 			if (shrink)
-- 
2.52.0

