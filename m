Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962EA441606;
	Wed, 29 Jul 2026 09:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316117; cv=none; b=BKN9oIepfEKpeFE7iVLrt9w1XOLPKHx0wrH8Ov2hyqCp3SZM+NKRSECEdSCeljQhzqmTn8ds8UEmG35UUDTdG8UAE2Wu9RgOAwtz0AK7K3NokrzRvOxt5794qDe5R7pdU8zn8Gp56ucJpB2IeJLnNjfpmdca5wWdcBptlvrJO4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316117; c=relaxed/simple;
	bh=vBl0BB7eWNLqSqI2+3uZnhG73QO/Z9uxZRzzq3R/gds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tC2pRl87J+SLGEw1NNzTuRrLfXU5AjaijkseHiOlxdgMMMyoMhgmmkclWh8GWkY/oyACY7TpV3D+SvQMoqla+VEqEkr/EB8zRtY6kBTJvoV2PV8EjyTVyzqH3cisMSiu/JXjALhJEZu7KN24AgYPpC/slSMiXg9S+FRcCMiAxmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h960y0GyVzKHMmm;
	Wed, 29 Jul 2026 17:07:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D31B64056D;
	Wed, 29 Jul 2026 17:08:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCX1EMCw2lq_g5uAQ--.47619S6;
	Wed, 29 Jul 2026 17:08:24 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH 2/2] ext4: protect WRITE_ZEROES written extents with orphan list
Date: Wed, 29 Jul 2026 16:59:18 +0800
Message-ID: <20260729085918.3336221-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCX1EMCw2lq_g5uAQ--.47619S6
X-Coremail-Antispam: 1UD129KBjvJXoWxKw1rtFy3AFWfZr4UtrWkJFb_yoW7Wryxpa
	y3Ar1rGFZ5Wasa9wsavF4UZr1Fkas7GrWUXrySgrWjvas8Xr1xKFyaqa4YvFWYqr48ZF1Y
	qr4jyryUGw4UZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUqYL9UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
extents to written in one transaction, while i_disksize is updated to
cover them only in a later transaction. A crash in between leaves
written extents beyond i_disksize on disk, which fsck will complain
about.

To fix this, add the inode to the orphan list in the same handle that
does the conversion, and remove it once i_disksize has caught up.
Also add a sanity check to ensure conversion does not extend beyond EOF.

Since ext4_alloc_file_blocks() is called from the fallocate() path,
partial allocation is safe. On partial conversion failure, advance
i_disksize only up to the boundary of successfully converted blocks, so
that orphan cleanup sees a consistent state. Document this behavior in
the function comment.

Reported-by: Jan Kara <jack@suse.cz>
Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 78 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1ab1a6e2ed83..a3dde7ba0d23 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4571,6 +4571,22 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
 	return err;
 }
 
+/*
+ * Pre-allocate blocks for the range [@offset, @offset + @len). Allocated
+ * blocks are marked as unwritten by default. If EXT4_GET_BLOCKS_ZERO is
+ * set, the allocated blocks are zeroed on disk and their extents are
+ * converted to written state.
+ *
+ * When @new_size is nonzero, the caller intends to extend the file, and
+ * the file size should be updated to the end of the allocated blocks.
+ *
+ * Allocation may partially succeed due to some non-fatal issues. In that
+ * case, i_disksize (and i_size) is advanced up to the successfully
+ * processed portion of the range.
+ *
+ * Return 0 on success, or a negative error code on failure or partial
+ * failure.
+ */
 static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 				  loff_t new_size, int flags)
 {
@@ -4585,6 +4601,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	loff_t epos = 0, old_size = i_size_read(inode);
 	unsigned int blkbits = inode->i_blkbits;
 	bool alloc_zero = false;
+	bool orphan = false;
 
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
 	map.m_lblk = offset >> blkbits;
@@ -4659,19 +4676,49 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 
 		if (alloc_zero &&
 		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
+			ext4_lblk_t converted;
+
+			WARN_ON_ONCE(map.m_lblk + map.m_len >
+				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
+
 			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
 						 map.m_len);
-			if (likely(!ret))
-				ret = ext4_convert_unwritten_extents(NULL,
-					inode, (loff_t)map.m_lblk << blkbits,
-					(loff_t)map.m_len << blkbits, NULL);
-			if (ret)
+			if (unlikely(ret))
 				break;
+
+			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+						    credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				break;
+			}
+
+			ret = ext4_convert_unwritten_extents(handle,
+					inode, (loff_t)map.m_lblk << blkbits,
+					(loff_t)map.m_len << blkbits,
+					&converted);
+			if (ret)
+				map.m_len = converted;
+
+			/*
+			 * If blocks beyond i_disksize are converted, add
+			 * the inode to the orphan list and advance the epos.
+			 */
+			if (new_size && converted) {
+				ret2 = ext4_orphan_add(handle, inode);
+				ret = ret ? ret : ret2;
+				orphan = true;
+			}
+
+			ret3 = ext4_journal_stop(handle);
+			ret = ret ? ret : ret3;
 		}
 
 		map.m_lblk += map.m_len;
 		map.m_len = len_lblk = len_lblk - map.m_len;
 		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
+		if (ret)
+			break;
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
@@ -4687,11 +4734,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	if (epos > new_size)
 		epos = new_size;
 
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-	if (IS_ERR(handle))
-		return ret ? ret : PTR_ERR(handle);
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
+	if (IS_ERR(handle)) {
+		/*
+		 * The conversion has successfully completed. Not much to
+		 * do with the error here so just cleanup the orphan list
+		 * and hope for the best.
+		 */
+		if (orphan && inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
+		ret2 = PTR_ERR(handle);
+		goto out;
+	}
 
 	ext4_update_inode_size(inode, epos);
+	if (orphan && inode->i_nlink)
+		ext4_orphan_del(handle, inode);
+
 	ret2 = ext4_mark_inode_dirty(handle, inode);
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 	ret3 = ext4_journal_stop(handle);
@@ -4699,6 +4758,9 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 
 	if (epos > old_size)
 		pagecache_isize_extended(inode, old_size, epos);
+out:
+	if (ret2)
+		ext4_std_error(inode->i_sb, ret2);
 
 	return ret ? ret : ret2;
 }
-- 
2.52.0

