Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911074A483D;
	Thu,  3 Sep 2026 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439378; cv=none; b=K4p9GsrYO6P88wCcd7Maq1F00QmgfpVhizChtam3U4xDuQMyOeGlXjGh/d02+utZT+EPs0/BPJLHxJsRU1crLtKxc5ulnTDahDnVLLEI5Wi//S82QaoTAopsZZzhCqJkL2q76O1UXoVCgnZKWuuDSo7HnBOPXCs9fIzcxBiLMUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439378; c=relaxed/simple;
	bh=+EKhVdqv3p8r1A06W61NHGrKxX2hg/mDn643J0UXrHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQl0RrXbSy8N3Ih6VFTf1dbsqGYOLbZ7Q3e24khODhUOfibfkQikDiTG485ALtoYZEOohMrLWd1l9qTKBddTO7guLSWENDUseaehzgH/nYTFfBKMMFo/w2/zCP7y9X+nSAuPyp2ftHvt5FcLB9iSpbmpbL/zHp5otCjjhUfwDLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3n0XKKzKHMkg;
	Thu,  3 Sep 2026 20:41:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id AE34D40570;
	Thu,  3 Sep 2026 20:42:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S6;
	Thu, 03 Sep 2026 20:42:50 +0800 (CST)
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
Subject: [PATCH v6 02/31] ext4: factor out ext4_truncate_[up|down]()
Date: Thu,  3 Sep 2026 20:35:14 +0800
Message-ID: <20260903123543.2302999-3-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S6
X-Coremail-Antispam: 1UD129KBjvJXoW3WF48ur1xWFykXrW7ZF4ktFb_yoWxZw4kpF
	W2ka4Fkw18uFyDWF4Igr4UZF4fta18K3yUGFy2krs2v3Wqyw1ftF1xt3yFgFWUtrWDWw4Y
	qF4Dtrs3Gw4kJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTR_3kZDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Refactor ext4_setattr() by introducing two helper functions,
ext4_truncate_up() and ext4_truncate_down(), to handle size changes. The
current ATTR_SIZE processing consolidates checks for both shrinking and
non-shrinking cases, leading to cluttered code. Separating the
truncation paths improves readability.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 199 +++++++++++++++++++++++++++---------------------
 1 file changed, 112 insertions(+), 87 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 14eab46f4750..8654006a57ef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5982,6 +5982,112 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
 	}
 }
 
+/*
+ * Set i_size and i_disksize to 'newsize'.
+ *
+ * Both i_rwsem and i_data_sem are required here to avoid races between
+ * generic append writeback and concurrent truncate that also modify
+ * i_size and i_disksize.
+ */
+static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
+{
+	WARN_ON_ONCE(S_ISREG(inode->i_mode) && !inode_is_locked(inode));
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+	i_size_write(inode, newsize);
+	EXT4_I(inode)->i_disksize = newsize;
+	up_write(&EXT4_I(inode)->i_data_sem);
+}
+
+static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
+{
+	ext4_lblk_t old_lblk, new_lblk;
+	handle_t *handle;
+	int ret;
+
+	if (!IS_ALIGNED(oldsize | newsize, i_blocksize(inode))) {
+		ret = ext4_inode_attach_jinode(inode);
+		if (ret)
+			return ret;
+	}
+
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	if (!IS_ALIGNED(oldsize, i_blocksize(inode))) {
+		ret = ext4_block_zero_eof(inode, oldsize, LLONG_MAX);
+		if (ret)
+			return ret;
+	}
+
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	old_lblk = oldsize > 0 ? (oldsize - 1) >> inode->i_blkbits : 0;
+	new_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
+	ext4_fc_track_range(handle, inode, old_lblk, new_lblk);
+
+	ext4_set_inode_size(inode, newsize);
+
+	ret = ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+	if (ret)
+		return ret;
+	/*
+	 * isize extend must be called outside an active handle due to
+	 * the lock ordering of transaction start and folio lock in the
+	 * iomap buffered I/O path (folio lock -> transaction start).
+	 */
+	pagecache_isize_extended(inode, oldsize, newsize);
+	return 0;
+}
+
+static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
+			      loff_t newsize, int *orphan)
+{
+	ext4_lblk_t start_lblk;
+	handle_t *handle;
+	int ret;
+
+	/* Do not change i_size. */
+	if (newsize == oldsize)
+		goto truncate;
+
+	/* Shrink. */
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	if (ext4_handle_valid(handle)) {
+		ret = ext4_orphan_add(handle, inode);
+		*orphan = 1;
+		if (ret) {
+			ext4_journal_stop(handle);
+			return ret;
+		}
+	}
+
+	start_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
+	ext4_fc_track_range(handle, inode, start_lblk, EXT_MAX_BLOCKS - 1);
+
+	ext4_set_inode_size(inode, newsize);
+
+	ret = ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+	if (ret)
+		return ret;
+
+	if (ext4_should_journal_data(inode))
+		ext4_wait_for_tail_page_commit(inode);
+truncate:
+	/*
+	 * Truncate pagecache after we've waited for commit in data=journal
+	 * mode to make pages freeable.  Call ext4_truncate() even if
+	 * i_size didn't change to truncate possible preallocated blocks.
+	 */
+	truncate_pagecache(inode, newsize);
+	return ext4_truncate(inode);
+}
+
 /*
  * ext4_setattr()
  *
@@ -6078,7 +6184,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		handle_t *handle;
 		loff_t oldsize = inode->i_size;
 		int shrink = (attr->ia_size < inode->i_size);
 
@@ -6130,94 +6235,14 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			goto err_out;
 		}
 
-		if (attr->ia_size != inode->i_size) {
-			/* attach jbd2 jinode for EOF folio tail zeroing */
-			if (attr->ia_size & (inode->i_sb->s_blocksize - 1) ||
-			    oldsize & (inode->i_sb->s_blocksize - 1)) {
-				error = ext4_inode_attach_jinode(inode);
-				if (error)
-					goto out_mmap_sem;
-			}
-
-			/*
-			 * Update c/mtime and tail zero the EOF folio on
-			 * truncate up. ext4_truncate() handles the shrink case
-			 * below.
-			 */
-			if (!shrink) {
-				inode_set_mtime_to_ts(inode,
-						      inode_set_ctime_current(inode));
-				if (oldsize & (inode->i_sb->s_blocksize - 1)) {
-					error = ext4_block_zero_eof(inode,
-							oldsize, LLONG_MAX);
-					if (error)
-						goto out_mmap_sem;
-				}
-			}
-
-			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
-			if (IS_ERR(handle)) {
-				error = PTR_ERR(handle);
-				goto out_mmap_sem;
-			}
-			if (ext4_handle_valid(handle) && shrink) {
-				error = ext4_orphan_add(handle, inode);
-				orphan = 1;
-				if (error)
-					goto out_handle;
-			}
-
-			if (shrink)
-				ext4_fc_track_range(handle, inode,
-					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
-					inode->i_sb->s_blocksize_bits,
-					EXT_MAX_BLOCKS - 1);
-			else
-				ext4_fc_track_range(
-					handle, inode,
-					(oldsize > 0 ? oldsize - 1 : oldsize) >>
-					inode->i_sb->s_blocksize_bits,
-					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
-					inode->i_sb->s_blocksize_bits);
-
-			/*
-			 * We have to update i_size under i_data_sem together
-			 * with i_disksize to avoid races with writeback code
-			 * updating disksize in mpage_map_and_submit_extent().
-			 */
-			down_write(&EXT4_I(inode)->i_data_sem);
-			i_size_write(inode, attr->ia_size);
-			EXT4_I(inode)->i_disksize = attr->ia_size;
-			up_write(&EXT4_I(inode)->i_data_sem);
-
-			error = ext4_mark_inode_dirty(handle, inode);
-out_handle:
-			ext4_journal_stop(handle);
-			if (error)
-				goto out_mmap_sem;
-			if (!shrink) {
-				pagecache_isize_extended(inode, oldsize,
-							 inode->i_size);
-			} else if (ext4_should_journal_data(inode)) {
-				ext4_wait_for_tail_page_commit(inode);
-			}
+		if (attr->ia_size > oldsize)
+			error = ext4_truncate_up(inode, oldsize, attr->ia_size);
+		else {
+			/* Shrink or do not change i_size. */
+			error = ext4_truncate_down(inode, oldsize,
+						   attr->ia_size, &orphan);
 		}
 
-		/*
-		 * Truncate pagecache after we've waited for commit
-		 * in data=journal mode to make pages freeable.
-		 */
-		truncate_pagecache(inode, inode->i_size);
-		/*
-		 * Call ext4_truncate() even if i_size didn't change to
-		 * truncate possible preallocated blocks.
-		 */
-		if (attr->ia_size <= oldsize) {
-			rc = ext4_truncate(inode);
-			if (rc)
-				error = rc;
-		}
-out_mmap_sem:
 		filemap_invalidate_unlock(inode->i_mapping);
 	}
 
-- 
2.52.0

