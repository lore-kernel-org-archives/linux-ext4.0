Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2136A4AC16C;
	Thu,  3 Sep 2026 12:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439392; cv=none; b=l7ePzepvPu8i8Mn2+Fu8Il1p7SoCySQ+gzOj7sAzUY9cdrvqEgy4IZIBv/hjQYXBItCG+/btJfxrBJimMAwh++SK+WUpGbHq2c48YF4APeedOfL1foga4NW57fVI+flfYzcyaurTq1XIX7ecSG5tyqF70Am1SC4sLfEjJknC5U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439392; c=relaxed/simple;
	bh=MP4vXNnpGuSKq9YK76LeVTZRMi/NAxzPVWUWKUdLnME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTAeIMkSxIxjtXoPVXVqYswLhApwuM/LKPltxyZM6WkzFgm9uJWkyCT0eLLUiqROqLlIYrKTYzYICUq8s3wHM5ji+LVHaZcdwPOuI149GsFBdqm5uSdZ8ZvlEcJjCcYxeFNG1Gihnc74CjGYd0H+RH4+ycVeX2Ctqf+SjSMZYiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK4126z8zYQv4j;
	Thu,  3 Sep 2026 20:42:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1D47040EE1;
	Thu,  3 Sep 2026 20:42:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S20;
	Thu, 03 Sep 2026 20:42:51 +0800 (CST)
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
Subject: [PATCH v6 16/31] ext4: implement mmap path using iomap
Date: Thu,  3 Sep 2026 20:35:28 +0800
Message-ID: <20260903123543.2302999-17-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S20
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWfJr17JryxtF43Kw1DGFg_yoWrGrWUp3
	sYk3yrGrsIqwnF9rs7WFs8Zr1FkayxtFW7WrW3Wr13Za42y340qF48KF1YvF45J3yfur42
	qF4Ykr18Wa47ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTR_nYFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Introduce ext4_iomap_page_mkwrite() to implement the mmap iomap path
for ext4. The heavy lifting is delegated to iomap_page_mkwrite(), which
only requires ext4_iomap_buffered_write_ops and
ext4_iomap_buffered_da_write_ops to allocate and map blocks.

Note that the lock ordering between folio lock and transaction start in
this path is reversed compared to the buffer_head buffered write path.
The lock ordering documentation in super.c has been updated accordingly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 32 +++++++++++++++++++++++++++++++-
 fs/ext4/super.c |  8 ++++++--
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 88dbbe14d2d7..88d9b48ee828 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4029,7 +4029,7 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
 		return -ERANGE;
 	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EINVAL;
-	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
+	if (WARN_ON_ONCE(!(flags & (IOMAP_WRITE | IOMAP_FAULT))))
 		return -EINVAL;
 
 	map_flags = delalloc ? EXT4_GET_BLOCKS_DELALLOC_RESERVE :
@@ -4087,6 +4087,14 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
 	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
 		return 0;
 
+	/*
+	 * iomap_page_mkwrite() will never fail in a way that requires delalloc
+	 * extents that it allocated to be revoked.  Hence never try to release
+	 * them here.
+	 */
+	if (flags & IOMAP_FAULT)
+		return 0;
+
 	/* Nothing to do if we've written the entire delalloc extent */
 	start_byte = iomap_last_written_block(inode, offset, written);
 	end_byte = round_up(offset + length, i_blocksize(inode));
@@ -7304,6 +7312,23 @@ static int ext4_block_page_mkwrite(struct inode *inode, struct folio *folio,
 	return ret;
 }
 
+static vm_fault_t ext4_iomap_page_mkwrite(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	const struct iomap_ops *iomap_ops;
+
+	/*
+	 * ext4_nonda_switch() could writeback this folio, so have to
+	 * call it before lock folio.
+	 */
+	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
+		iomap_ops = &ext4_iomap_buffered_da_write_ops;
+	else
+		iomap_ops = &ext4_iomap_buffered_write_ops;
+
+	return iomap_page_mkwrite(vmf, iomap_ops, NULL);
+}
+
 vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -7330,6 +7355,11 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 	if (err)
 		goto out_ret;
 
+	if (ext4_inode_buffered_iomap(inode)) {
+		ret = ext4_iomap_page_mkwrite(vmf);
+		goto out;
+	}
+
 	/*
 	 * On data journalling we skip straight to the transaction handle:
 	 * there's no delalloc; page truncated will be checked later; the
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6d2d323604f9..1c2395aa1d53 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -100,8 +100,12 @@ static const struct fs_parameter_spec ext4_param_specs[];
  * Lock ordering
  *
  * page fault path:
- * mmap_lock -> sb_start_pagefault -> invalidate_lock (r) -> transaction start
- *   -> page lock -> i_data_sem (rw)
+ * - buffer_head path:
+ *   mmap_lock -> sb_start_pagefault -> invalidate_lock (r) ->
+ *     transaction start -> folio lock -> i_data_sem (rw)
+ * - iomap path:
+ *   mmap_lock -> sb_start_pagefault -> invalidate_lock (r) ->
+ *     folio lock -> transaction start -> i_data_sem (rw)
  *
  * buffered write path:
  * sb_start_write -> i_rwsem (w) -> mmap_lock
-- 
2.52.0

