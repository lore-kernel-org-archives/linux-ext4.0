Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98632383C6E;
	Mon, 11 May 2026 07:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484519; cv=none; b=uvQJpA4WlFU/zZr9ATPotxh1HFUthnu0UCZuO2KXvG0oGp1kV0I45WT6KuEc5yx64Et9lyRLGL+gN1QoqkeD/Df6FZ89KpQ0+eYEk2bPdJigQYIid3s3Bnhmsfa5KEVFVEpDO+Cfhcang/NRcjL8612awm4e92CkB7Ee9q5BBMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484519; c=relaxed/simple;
	bh=4XPqWCyq2Y3ogBER+i2c5iOzaYK5IQNCluqZ1OW8c7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiVtCfDiHYOBpgM6LkFli78XQc5bsT+hJf0LxKUUckZtfgAxJAOUEDj3TzIB++BH3ifUPbLLKGmWHErU2gGTL2vSBW8XkK75DOmYXA/Lxrfq+J0w38nx7uxFo+foJbVnaaJLFhdR4O2kHXrsKbYCUJLoHy9B9lot944D2PbVwW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXV4VkwzYQv2y;
	Mon, 11 May 2026 15:27:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4AC6440579;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S14;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
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
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 10/23] ext4: implement mmap path using iomap
Date: Mon, 11 May 2026 15:23:30 +0800
Message-ID: <20260511072344.191271-11-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S14
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWfJr17Jryxuw47Xr18Zrb_yoW5KFWxpr
	95KrWrGrsIqwna9rs7WFsrZr1YkayxtFW7WrW3Wr15ZFy2y340qa18KFyYvF4rJ3yxAr4I
	qF4jkr18W3W7CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
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
---
 fs/ext4/inode.c | 32 +++++++++++++++++++++++++++++++-
 fs/ext4/super.c |  8 ++++++--
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a80195bd6f20..c6fe42d012fc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4020,7 +4020,7 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
 		return -ERANGE;
 	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EINVAL;
-	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
+	if (WARN_ON_ONCE(!(flags & (IOMAP_WRITE | IOMAP_FAULT))))
 		return -EINVAL;
 
 	if (delalloc)
@@ -4080,6 +4080,14 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
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
@@ -7191,6 +7199,23 @@ static int ext4_block_page_mkwrite(struct inode *inode, struct folio *folio,
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
@@ -7213,6 +7238,11 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 
 	filemap_invalidate_lock_shared(mapping);
 
+	if (ext4_inode_buffered_iomap(inode)) {
+		ret = ext4_iomap_page_mkwrite(vmf);
+		goto out;
+	}
+
 	err = ext4_convert_inline_data(inode);
 	if (err)
 		goto out_ret;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 51d87db53543..62bfe05a64bc 100644
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

