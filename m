Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04094ACC9A;
	Fri,  9 Oct 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542251; cv=none; b=Nh21VJYxhl/8dBRX0wwy43btQgldnZGDB7h6OXTGmRIYK7x+K/s+JRsjIt25ytXRzQwre00JmldGRybmVUDNbbg5vVbb16pJ4wzT2RXbmdiGem7ZH8+aQjTrCn20e8WYb19+IfWIOsVCMryz5cVN2ilVsRJ4PZhrX8vvhG+9XEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542251; c=relaxed/simple;
	bh=BAyUaUhInYlxD4SEpFOa76zNp3fwTLm+98YCs3HIu6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFOfQWRDk1pmPdxXLUBEVpzYiYQDGhh9kAAgsVq8o9f/O10tCPILKv2skkachSOy5Ynnmwk+m/mA4MB3z16+9HC4GMOQvhnAnvEkVItAZ/VoiTzIWuxFunffVB8IMER9ovX7wLRmKuIH5DNgXSLmtNG6lTotj+Kvfhl08H3Nw+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZV6Jc5zYQv3q;
	Fri,  9 Oct 2026 18:36:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 1AE204056B;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S6;
	Fri, 09 Oct 2026 18:37:18 +0800 (CST)
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
Subject: [PATCH v7 02/31] ext4: factor out ext4_truncate_[up|down]()
Date: Fri,  9 Oct 2026 18:30:03 +0800
Message-ID: <20261009103033.2920530-3-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S6
X-Coremail-Antispam: 1UD129KBjvJXoW3WF48ur1xWFykXrW7ZF4ktFb_yoWxur18pF
	W7C34Fkw18uFyDWF4Iqr4UZF4rta18K3yUGFy2krs2v3Wqyw1ftF1xt3yrKFWUtr4DWw4Y
	qF4Dtrs3Gw4kJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7sRREfO5UUUUU==
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
index ddee4c50bd859..d0ccafa554f8d 100644
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

