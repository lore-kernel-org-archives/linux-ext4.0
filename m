Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B912773E4;
	Thu, 26 Mar 2026 11:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523759; cv=none; b=cTvXeBuUjIh/bJb52BrazUMVRqGWUFPXk4G0yS0VcVL1CL2lIDFTS5DDULXqqerstiDJWYITg9xImB1JyU0Ue22gY/CnBnecpHyBE8J1op4yZRe86L3kj6LfzsM8Lj2I/oYzeNahMvkmuEUJu45D/BSxGQY2jYeAnEJ7CGl6iWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523759; c=relaxed/simple;
	bh=XmFUjlxOZHR+uzDYaPjlfunzjAttkhEg3O4QZ+98J+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhLQ6AaOrcn0db6IDbBw3bbba4xo5erVEsljFZY4fVegjVefLw9WQt1TOCzIuT/ehhQAVJ9u/W1EJ6fBypajqD84Nk75LCMhk4Zl2VPnVZXXIaDF399EWVVX5fAsO8W/2dHCDCUde/duxQC1zKEBU6EZJw60PM5uW99NNH/FqR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhLmV1Z3kzYQv7N;
	Thu, 26 Mar 2026 19:15:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 276BD4056E;
	Thu, 26 Mar 2026 19:15:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S11;
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
Subject: [PATCH v3 07/11] ext4: pass allocate range as loff_t to ext4_alloc_file_blocks()
Date: Thu, 26 Mar 2026 19:10:50 +0800
Message-ID: <20260326111054.907252-8-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S11
X-Coremail-Antispam: 1UD129KBjvJXoWxtrWfuF1kCryUKFyUZrW5Wrg_yoW7tFWrpF
	Z8Zr15GF4fWFyv9w40kwsrXr1fK3ZrKrWUXryagryFqa4DtF1xtan0yFW0gFySgrZ7Zrs0
	vF4Ykry7Ga1UG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Change ext4_alloc_file_blocks() to accept offset and len in byte
granularity instead of block granularity. This allows callers to pass
byte offsets and lengths directly, and this prepares for moving the
ext4_zero_partial_blocks() call from the while(len) loop for unaligned
append writes, where it only needs to be invoked once before doing block
allocation.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 753a0f3418a4..57a686b600d9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4542,15 +4542,15 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
 	return err;
 }
 
-static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
-				  ext4_lblk_t len, loff_t new_size,
-				  int flags)
+static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
+				  loff_t new_size, int flags)
 {
 	struct inode *inode = file_inode(file);
 	handle_t *handle;
 	int ret = 0, ret2 = 0, ret3 = 0;
 	int retries = 0;
 	int depth = 0;
+	ext4_lblk_t len_lblk;
 	struct ext4_map_blocks map;
 	unsigned int credits;
 	loff_t epos, old_size = i_size_read(inode);
@@ -4558,14 +4558,14 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	bool alloc_zero = false;
 
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
-	map.m_lblk = offset;
-	map.m_len = len;
+	map.m_lblk = offset >> blkbits;
+	map.m_len = len_lblk = EXT4_MAX_BLOCKS(len, offset, blkbits);
 	/*
 	 * Don't normalize the request if it can fit in one extent so
 	 * that it doesn't get unnecessarily split into multiple
 	 * extents.
 	 */
-	if (len <= EXT_UNWRITTEN_MAX_LEN)
+	if (len_lblk <= EXT_UNWRITTEN_MAX_LEN)
 		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 
 	/*
@@ -4582,16 +4582,16 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	/*
 	 * credits to insert 1 extent into extent tree
 	 */
-	credits = ext4_chunk_trans_blocks(inode, len);
+	credits = ext4_chunk_trans_blocks(inode, len_lblk);
 	depth = ext_depth(inode);
 
 retry:
-	while (len) {
+	while (len_lblk) {
 		/*
 		 * Recalculate credits when extent tree depth changes.
 		 */
 		if (depth != ext_depth(inode)) {
-			credits = ext4_chunk_trans_blocks(inode, len);
+			credits = ext4_chunk_trans_blocks(inode, len_lblk);
 			depth = ext_depth(inode);
 		}
 
@@ -4648,7 +4648,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 		}
 
 		map.m_lblk += ret;
-		map.m_len = len = len - ret;
+		map.m_len = len_lblk = len_lblk - ret;
 	}
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
@@ -4665,11 +4665,9 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 {
 	struct inode *inode = file_inode(file);
 	handle_t *handle = NULL;
-	loff_t new_size = 0;
+	loff_t align_start, align_end, new_size = 0;
 	loff_t end = offset + len;
-	ext4_lblk_t start_lblk, end_lblk;
 	unsigned int blocksize = i_blocksize(inode);
-	unsigned int blkbits = inode->i_blkbits;
 	int ret, flags, credits;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
@@ -4690,11 +4688,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
 	/* Preallocate the range including the unaligned edges */
 	if (!IS_ALIGNED(offset | end, blocksize)) {
-		ext4_lblk_t alloc_lblk = offset >> blkbits;
-		ext4_lblk_t len_lblk = EXT4_MAX_BLOCKS(len, offset, blkbits);
-
-		ret = ext4_alloc_file_blocks(file, alloc_lblk, len_lblk,
-					     new_size, flags);
+		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
+					     flags);
 		if (ret)
 			return ret;
 	}
@@ -4709,18 +4704,17 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		return ret;
 
 	/* Zero range excluding the unaligned edges */
-	start_lblk = EXT4_B_TO_LBLK(inode, offset);
-	end_lblk = end >> blkbits;
-	if (end_lblk > start_lblk) {
-		ext4_lblk_t zero_blks = end_lblk - start_lblk;
-
+	align_start = round_up(offset, blocksize);
+	align_end = round_down(end, blocksize);
+	if (align_end > align_start) {
 		if (mode & FALLOC_FL_WRITE_ZEROES)
 			flags = EXT4_GET_BLOCKS_CREATE_ZERO | EXT4_EX_NOCACHE;
 		else
 			flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
 				  EXT4_EX_NOCACHE);
-		ret = ext4_alloc_file_blocks(file, start_lblk, zero_blks,
-					     new_size, flags);
+		ret = ext4_alloc_file_blocks(file, align_start,
+					     align_end - align_start, new_size,
+					     flags);
 		if (ret)
 			return ret;
 	}
@@ -4768,15 +4762,11 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
 	struct inode *inode = file_inode(file);
 	loff_t end = offset + len;
 	loff_t new_size = 0;
-	ext4_lblk_t start_lblk, len_lblk;
 	int ret;
 
 	trace_ext4_fallocate_enter(inode, offset, len, mode);
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
-	start_lblk = offset >> inode->i_blkbits;
-	len_lblk = EXT4_MAX_BLOCKS(len, offset, inode->i_blkbits);
-
 	/* We only support preallocation for extent-based files only. */
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 		ret = -EOPNOTSUPP;
@@ -4791,7 +4781,7 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
 			goto out;
 	}
 
-	ret = ext4_alloc_file_blocks(file, start_lblk, len_lblk, new_size,
+	ret = ext4_alloc_file_blocks(file, offset, len, new_size,
 				     EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
 	if (ret)
 		goto out;
@@ -4801,7 +4791,8 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
 					EXT4_I(inode)->i_sync_tid);
 	}
 out:
-	trace_ext4_fallocate_exit(inode, offset, len_lblk, ret);
+	trace_ext4_fallocate_exit(inode, offset,
+			EXT4_MAX_BLOCKS(len, offset, inode->i_blkbits), ret);
 	return ret;
 }
 
-- 
2.52.0

