Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEB4257435;
	Tue, 14 Jul 2026 08:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016555; cv=none; b=N4MQ/exbrTL7YcTtr756LAF4c2ZHldzdGcOSzNYCRC5qronGNqVreoL/8azhegtdsuqdQVZrohjz2O3uXY5wh1156gNNDKZYZUNOox8WJeng+gaNC1MUbo7AYERK/dxNUc2iXDZan+pIQo+g6VrCPvepWEM06UrTsPB2FZGsiyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016555; c=relaxed/simple;
	bh=wq6srPQ0Q+eYWwwXCdktrtce+86VyBk+wEdy4pzBy+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJ5v11ReXT6Z2wY8u+mvQOeu7WMmw3av2fl+PFf1/XDG7kx0ffQ7vUYXiQSPbpSWX0HgfKMhOixWNh0jJmk0lKyiatXV0psuTzr8gQzPh2MlkzcvO/E7bBHV8E7KPR8xn/eiaE1EzEAnGCLufld4Rch7molXT5AuQ6hsv6+EQKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gzsQ94cp1zYQtlS;
	Tue, 14 Jul 2026 16:08:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 9BA5B4056D;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgD3B3ST7lVqDS26BA--.56424S10;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
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
Subject: [PATCH v4 6/9] ext4: track partial-zero outcome per edge in ext4_zero_partial_blocks()
Date: Tue, 14 Jul 2026 16:00:41 +0800
Message-ID: <20260714080044.4038124-7-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3B3ST7lVqDS26BA--.56424S10
X-Coremail-Antispam: 1UD129KBjvJXoWxZw4kJF13Aw1fCr4kZw1UJrb_yoWrtFy5p3
	47Ja43Gr43W348urWfGF4avw1Yy3Z3WF4kWry3Gr15ZayfXw1xKF1DKr1FvF1jgrW3Ca40
	vF1Yy347Kr13CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl
	6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x
	IIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4U
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJV
	WUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUv
	cSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Replace the single bool did_zero output of ext4_zero_partial_blocks()
with a bitmask that records which edge (start, end, or both in the
single-block case) was actually partial-zeroed. This allows callers to
distinguish which edges have been zeroed, preparing for unaligned
FALLOC_FL_WRITE_ZEROES handling in later patches.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  5 ++++-
 fs/ext4/extents.c |  2 +-
 fs/ext4/inode.c   | 36 ++++++++++++++++++++++++++++++------
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..b2e55876d0e3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3099,8 +3099,11 @@ extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 				  int pextents);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
+
+#define EXT4_PARTIAL_ZERO_START	0x1
+#define EXT4_PARTIAL_ZERO_END	0x2
 extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
-				    loff_t length, bool *did_zero);
+				    loff_t length, unsigned int *partial_zeroed);
 extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 27ca641e701b..7a8f9f188a29 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4715,7 +4715,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	loff_t align_start, align_end, new_size = 0;
 	loff_t end = offset + len;
 	unsigned int blocksize = i_blocksize(inode);
-	bool partial_zeroed = false;
+	unsigned int partial_zeroed = 0;
 	int ret, flags;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 479ed73b5cda..a1615084a3b9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4271,13 +4271,26 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	return 0;
 }
 
+/*
+ * Zero out the unaligned head and tail of the [lstart, lstart+length)
+ * range.
+ *
+ * On return, @partial_zeroed records which edges actually got
+ * partial-zeroed.  Set EXT4_PARTIAL_ZERO_START/EXT4_PARTIAL_ZERO_END if
+ * the head/tail block got actually partially zeroed (in written, dirty
+ * unwritten or delalloc state).  Cleared if the head/tail block is a
+ * hole or a clean unwritten block, in which case there is nothing that
+ * needs zeroing.  When the head and tail land in the same block, both
+ * bits are set together on a successful zeroing.
+ */
 int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
-			     bool *did_zero)
+			     unsigned int *partial_zeroed)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned partial_start, partial_end;
 	ext4_fsblk_t start, end;
 	loff_t byte_end = (lstart + length - 1);
+	bool did_zero = false;
 	int err = 0;
 
 	partial_start = lstart & (sb->s_blocksize - 1);
@@ -4289,21 +4302,32 @@ int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
 	/* Handle partial zero within the single block */
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
-		err = ext4_block_zero_range(inode, lstart, length, did_zero,
+		err = ext4_block_zero_range(inode, lstart, length, &did_zero,
 					    NULL);
+		if (did_zero)
+			*partial_zeroed |= (EXT4_PARTIAL_ZERO_START |
+					    EXT4_PARTIAL_ZERO_END);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
 		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
-					    did_zero, NULL);
+					    &did_zero, NULL);
 		if (err)
 			return err;
+		if (did_zero)
+			*partial_zeroed |= EXT4_PARTIAL_ZERO_START;
 	}
 	/* Handle partial zero out on the end of the range */
-	if (partial_end != sb->s_blocksize - 1)
+	if (partial_end != sb->s_blocksize - 1) {
+		did_zero = false;
 		err = ext4_block_zero_range(inode, byte_end - partial_end,
-					    partial_end + 1, did_zero, NULL);
+					    partial_end + 1, &did_zero, NULL);
+		if (err)
+			return err;
+		if (did_zero)
+			*partial_zeroed |= EXT4_PARTIAL_ZERO_END;
+	}
 	return err;
 }
 
@@ -4452,7 +4476,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t end = offset + length;
 	handle_t *handle;
 	unsigned int credits;
-	bool partial_zeroed = false;
+	unsigned int partial_zeroed = 0;
 	int ret;
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
-- 
2.52.0

