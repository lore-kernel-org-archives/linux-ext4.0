Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9977642885E;
	Fri, 14 Aug 2026 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700409; cv=none; b=rFZkgbIFj6FfR7hdkwoVcewMU8JWAVfKK5ff7zmvydSJfwGV02a+h03Xf+Fp5M/qQFF3qVNrraeX99eyGSNoGyH1SVE4lMkG+Usakl8yZucwHu+lA/o3vGKsVNiwOtJHIznirSvi7EL4CQAkdwxhSHRLSt50JtDU88++jDRht/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700409; c=relaxed/simple;
	bh=0hrCPBl4XycUSx+v4yYTiOWPbIJZxhHgDfqQbOgrXD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly9SGN7s8PvRsU69nT0mSlbEp0jAfdULVt0jla7nXHa6vTTGU6S3Lme5fu2YNk1Q+/Buz7Td8OASOSEVTn0nFl4JHzH516miOIpxThlYpmTdrr1rx4v9G3wBWUfaPWf+HcX1uONXue64PdtlO0j3Bjw/ft9zswBEPD1pldPVKmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyS169JzKHNNV;
	Fri, 14 Aug 2026 17:39:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id DDF1840561;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S21;
	Fri, 14 Aug 2026 17:39:48 +0800 (CST)
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
	yukuai@fnnas.com
Subject: [PATCH -next v5 17/32] ext4: implement mmap path using iomap
Date: Fri, 14 Aug 2026 17:33:16 +0800
Message-ID: <20260814093331.1703882-18-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S21
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWfJr17JryxtF43Kw1DGFg_yoWrJw4xpr
	95K34rGrsIqwnF9rs7WFsxZr1rKayxKrW7WrW3WrnxZa42y340qa18KF1YvF1rJ3yfCr42
	qF4Ykr18Wa47CrDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Ar0_tr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRiyxR3UUUUU==
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
index 0b3e54e12b78..a05445625895 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4027,7 +4027,7 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
 		return -ERANGE;
 	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EINVAL;
-	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
+	if (WARN_ON_ONCE(!(flags & (IOMAP_WRITE | IOMAP_FAULT))))
 		return -EINVAL;
 
 	map_flags = delalloc ? EXT4_GET_BLOCKS_DELALLOC_RESERVE :
@@ -4085,6 +4085,14 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
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
@@ -7296,6 +7304,23 @@ static int ext4_block_page_mkwrite(struct inode *inode, struct folio *folio,
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
@@ -7318,6 +7343,11 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
 
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

