Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9622C441600;
	Wed, 29 Jul 2026 09:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316117; cv=none; b=ubIz3EBW17Nyp4s1w5LLxEfEslywgncamwx3UtyP6ZuLBFvktPO0u036H7gNml0EM5d5SnE8/x4/Vm5NZJkuRzzInjpQ8mv7Bima2lvpX7q2sGAk+3xqEKh2wWFp7aAhTvvusULe6noexfNGq25Iab8mfjHaku29t4F6qK/qFS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316117; c=relaxed/simple;
	bh=uFg7UqoKukBYlw3t0p1MRLZNnxnzzA7cJ5ngCnFVp/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTGqZOiEoU9rZveD3CALZor4h4itjGu/REvLqSJoj+DrmVHie0oiU4XLoL/95aCs/XwdBJCffIHhU8X/5c8PKcl+ouQzpuuqXl7b8wOaCKdYEabVAfXx+p07kJ61uN9fx0MTh1/EBxryUJ9w90P8raHNluMuwAmJGHS3UBfH75U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h960y0BtMzKHMml;
	Wed, 29 Jul 2026 17:07:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C7A8840539;
	Wed, 29 Jul 2026 17:08:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCX1EMCw2lq_g5uAQ--.47619S5;
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
Subject: [PATCH 1/2] ext4: export converted block count from ext4_convert_unwritten_extents()
Date: Wed, 29 Jul 2026 16:59:17 +0800
Message-ID: <20260729085918.3336221-2-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgCX1EMCw2lq_g5uAQ--.47619S5
X-Coremail-Antispam: 1UD129KBjvJXoW3JrW3XF4DZr43Kr48JrWfAFb_yoW7try8pa
	43CryrCF4Yg3929FWfCF4UZr1a9a4xGF4UZrW3Gry0ka4qqrnaqF1UKFyYyFW5t3yxZF1Y
	qF48tryUXa13ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUU9YwUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_convert_unwritten_extents() currently returns only a success or a
failure indication. A zero return means all requested blocks were
converted, and a negative value means the conversion failed. However,
some blocks may have already been converted when the function fails
partway through, and callers have no way to learn how many were done.

The WRITE_ZEROES caller in ext4_alloc_file_blocks() needs this
information to decide whether to add the inode to the orphan list before
updating i_disksize to cover the already-converted written extents, so
that a crash before i_disksize catches up can be recovered via orphan
truncation.

Switch the function to pass out the number of converted blocks through
the new output parameter @converted, which will be used by later
patches.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  3 ++-
 fs/ext4/extents.c | 53 ++++++++++++++++++++++++++++++-----------------
 fs/ext4/file.c    |  3 ++-
 3 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4e3b3165ee8f..f36d84ff0d5e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3901,7 +3901,8 @@ extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
 			  loff_t len);
 extern int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
-					  loff_t offset, ssize_t len);
+					  loff_t offset, ssize_t len,
+					  ext4_lblk_t *converted);
 extern int ext4_convert_unwritten_extents_atomic(handle_t *handle,
 			struct inode *inode, loff_t offset, ssize_t len);
 extern int ext4_convert_unwritten_io_end_vec(handle_t *handle,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d5f87a7f6c05..1ab1a6e2ed83 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4664,7 +4664,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 			if (likely(!ret))
 				ret = ext4_convert_unwritten_extents(NULL,
 					inode, (loff_t)map.m_lblk << blkbits,
-					(loff_t)map.m_len << blkbits);
+					(loff_t)map.m_len << blkbits, NULL);
 			if (ret)
 				break;
 		}
@@ -5051,21 +5051,26 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
  * all unwritten extents within this range will be converted to
  * written extents.
  *
- * This function is called from the direct IO end io call back
- * function, to convert the fallocated extents after IO is completed.
- * Returns 0 on success.
+ * This function is called from the direct/buffered I/O end io call back
+ * function and FALLOC_FL_WRITE_ZEROES, to convert the fallocated
+ * unwritten extents after data I/O is completed.
+ *
+ * Returns 0 on full success, or a negative error code on partial
+ * success or failure. The number of blocks converted is returned via
+ * @converted.
  */
 int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
-				   loff_t offset, ssize_t len)
+				   loff_t offset, ssize_t len,
+				   ext4_lblk_t *converted)
 {
-	unsigned int max_blocks;
+	ext4_lblk_t max_blocks, conv_blocks = 0;
 	int ret = 0, ret2 = 0, ret3 = 0;
 	struct ext4_map_blocks map;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned int credits = 0;
 
 	map.m_lblk = offset >> blkbits;
-	max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
+	map.m_len = max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
 
 	if (!handle) {
 		/*
@@ -5073,9 +5078,8 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 		 */
 		credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	}
-	while (ret >= 0 && ret < max_blocks) {
-		map.m_lblk += ret;
-		map.m_len = (max_blocks -= ret);
+
+	while (max_blocks) {
 		if (credits) {
 			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
 						    credits);
@@ -5092,23 +5096,34 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 		ret = ext4_map_blocks(handle, inode, &map,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
 				      EXT4_EX_NOCACHE);
-		if (ret <= 0)
+		if (ret <= 0) {
 			ext4_warning(inode->i_sb,
-				     "inode #%llu: block %u: len %u: "
-				     "ext4_ext_map_blocks returned %d",
-				     inode->i_ino, map.m_lblk,
-				     map.m_len, ret);
+				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
+				     inode->i_ino, map.m_lblk, map.m_len, ret);
+			if (unlikely(ret == 0))
+				ret = -EINVAL;
+		} else {
+			conv_blocks += map.m_len;
+		}
+
 		ret2 = ext4_mark_inode_dirty(handle, inode);
 		if (credits) {
 			ret3 = ext4_journal_stop(handle);
 			if (unlikely(ret3))
 				ret2 = ret3;
 		}
-
-		if (ret <= 0 || ret2)
+		ret = ret < 0 ? ret : ret2;
+		if (ret)
 			break;
+
+		map.m_lblk += map.m_len;
+		map.m_len = (max_blocks -= map.m_len);
 	}
-	return ret > 0 ? ret2 : ret;
+	/* Converted some or all blocks successfully? */
+	if (converted)
+		*converted = conv_blocks;
+
+	return ret;
 }
 
 int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
@@ -5131,7 +5146,7 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
 	list_for_each_entry(io_end_vec, &io_end->list_vec, list) {
 		ret = ext4_convert_unwritten_extents(handle, io_end->inode,
 						     io_end_vec->offset,
-						     io_end_vec->size);
+						     io_end_vec->size, NULL);
 		if (ret)
 			break;
 	}
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 9a16071b719d..45e16799d0c2 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -436,7 +436,8 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
 		error = ext4_convert_unwritten_extents_atomic(NULL, inode, pos,
 							      size);
 	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
-		error = ext4_convert_unwritten_extents(NULL, inode, pos, size);
+		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
+						       NULL);
 	if (error)
 		return error;
 	/*
-- 
2.52.0

