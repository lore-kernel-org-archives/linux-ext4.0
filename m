Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E79539D6E8;
	Fri, 14 Aug 2026 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700404; cv=none; b=aZMK4I8E/0Dan2M/mySiu4/MYhtO7GtEZp0F3/rLbxaYK9aYj497A2N3VO1p9i1U2eLVx68ZULx1mo52bO0T9uyGtum1YGsBkjmAH28m408al7DmfYK6XifC2xiUZxehdy+8AfO4AdFf0JCJ5MLQD6jNbct5QbcuSbQG810FveQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700404; c=relaxed/simple;
	bh=TKn05nvXB9c1TgJn/Y1KlLuJ3nq7M2VOuAIJ18kvNtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/e/T57GTXQ/D4qcRmVoC0wUTjAHzNT8aYSYmtnI3Hnj6BTbRV0WqDofuJE6+Fj/fzOSn//2u26ILRFlJm8ArwFpsaV80CsgedR4ctOztXCx5D2YyWz4hQcJRaHFFBV3az2YMyksm/1VRpsCKakWT34uFX2j2vr+lbMXYODLoOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyj2L1yzYQvYY;
	Fri, 14 Aug 2026 17:39:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 7C93540594;
	Fri, 14 Aug 2026 17:39:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S27;
	Fri, 14 Aug 2026 17:39:49 +0800 (CST)
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
Subject: [PATCH -next v5 23/32] ext4: submit and wait for pending disksize-grow I/O on writeback
Date: Fri, 14 Aug 2026 17:33:22 +0800
Message-ID: <20260814093331.1703882-24-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S27
X-Coremail-Antispam: 1UD129KBjvJXoWxKryUZFy8KF17JrykKr1xKrg_yoWxKrWxp3
	s8Kry5Gr4DXr9F9rsaqFW7Zr1Yka1rtr4UJry3Wa98Zry5ury7KFW0gF1a9F1vk393J39F
	qF4vkrW8Cw17ArJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

When the current writeback pass begins beyond the disksize-grow-pending
zeroed EOF block, the ioend worker would otherwise have to wait for the
pending EOF block to complete before it can advance i_disksize.
Otherwise the old EOF block could be exposed as stale data once
i_disksize advances past it.

Therefore, introduce the ioend mechanism for the pending range, tag
ioends that cover the pending zeroed EOF block which straddles
i_disksize with EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO in
ext4_iomap_writeback_submit(), and clear the bit and wake up all waiters
in ext4_iomap_end_bio() when such an ioend completes.

In order to avoid the ioend that passes the pending range waiting for a
long time, proactively submit the pending range first in
ext4_iomap_writepages() so it completes in parallel with the rest of the
writeback.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  6 ++++++
 fs/ext4/inode.c   | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/page-io.c | 40 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1c3d736fb700..089dbd39c5c2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3986,6 +3986,12 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			     __u64 len, __u64 *moved_len);
 
 /* page-io.c */
+/*
+ * The I/O range covers the zeroed EOF block that straddles i_disksize
+ * and will advance it upon completion.
+ */
+#define EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO	1UL
+
 extern int __init ext4_init_pageio(void);
 extern void ext4_exit_pageio(void);
 extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e4a4396eaf87..a0707310b464 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4366,7 +4366,10 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 				       int error)
 {
 	struct iomap_ioend *ioend = wpc->wb_ctx;
-	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
+	struct inode *inode = ioend->io_inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int blocksize = i_blocksize(inode);
+	loff_t pstart, plen;
 
 	/*
 	 * After I/O completion, a worker needs to be scheduled when:
@@ -4379,6 +4382,21 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
 		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
 
+	/*
+	 * Mark the I/O as DISKSIZE_GROW_IO by setting io_private to
+	 * EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO if it covers the pending range.
+	 * Such I/O will allow or trigger i_disksize advancement in the
+	 * ioend worker.
+	 */
+	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
+	if (plen &&
+	    round_down(ioend->io_offset, blocksize) <= pstart &&
+	    round_up(ioend->io_offset + ioend->io_size, blocksize) >=
+			pstart + plen) {
+		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
+		ioend->io_private = (void *)EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO;
+	}
+
 	/*
 	 * ext4_iomap_end_bio() always defers endio processing, disable
 	 * generic BIO in task to avoid double deferral since we will use
@@ -4398,6 +4416,29 @@ static const struct iomap_writeback_ops ext4_writeback_ops = {
 	.writeback_submit = ext4_iomap_writeback_submit,
 };
 
+/*
+ * If the current writeback range begins after the pending zeroed EOF
+ * block range which straddles i_disksize, issue a separate writeback to
+ * flush it first, so as to avoid prolonged waiting.
+ */
+static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
+					    struct writeback_control *wbc)
+{
+	struct address_space *mapping = inode->i_mapping;
+	loff_t pstart, plen, range_start;
+
+	if (wbc->range_cyclic)
+		range_start = (loff_t)mapping->writeback_index << PAGE_SHIFT;
+	else
+		range_start = wbc->range_start;
+
+	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
+	if (!plen || range_start < pstart + plen)
+		return;
+
+	filemap_fdatawrite_range(mapping, pstart, pstart + plen - 1);
+}
+
 static int ext4_iomap_writepages(struct address_space *mapping,
 				 struct writeback_control *wbc)
 {
@@ -4415,6 +4456,12 @@ static int ext4_iomap_writepages(struct address_space *mapping,
 	if (unlikely(ret))
 		return ret;
 
+	/*
+	 * Submit the pending zeroed EOF block range if the entire
+	 * writeback range lies beyond it.
+	 */
+	ext4_iomap_wb_submit_zeroed_eof(inode, wbc);
+
 	alloc_ctx = ext4_writepages_down_read(sb);
 	trace_ext4_writepages(inode, wbc);
 	ret = iomap_writepages(&wpc);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 2888e0057561..955ff88045db 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -549,6 +549,34 @@ void ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 	} while ((bh = bh->b_this_page) != head);
 }
 
+/*
+ * If the current writeback range starts beyond the zeroed EOF pending
+ * range that straddles i_disksize, wait for the zeroed data from
+ * ext4_block_zero_eof() to be written out first. Otherwise, extending
+ * i_disksize may expose stale data in the old EOF block.
+ */
+static void ext4_iomap_wb_disksize_pending_wait(struct inode *inode,
+						loff_t pos, size_t size)
+{
+	loff_t disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
+	loff_t pstart, plen;
+
+	/*
+	 * Overwrite I/Os and I/Os covering the EOF block do not need to
+	 * wait: the former do not advance i_disksize past the pending
+	 * boundary, and the latter are the pending I/O itself (cleared in
+	 * the bio completion path).
+	 */
+	if (pos < round_up(disksize, i_blocksize(inode)))
+		return;
+
+	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
+	if (!plen || pos < pstart + plen)
+		return;
+
+	ext4_iomap_wait_disksize_pending(inode);
+}
+
 static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 					 loff_t end)
 {
@@ -594,6 +622,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	    end <= READ_ONCE(EXT4_I(inode)->i_disksize))
 		goto out;
 
+	/* Wait for disksize-pending zeroed data to be written out. */
+	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);
+
 	/*
 	 * We may need to convert one extent, update the i_disksize and
 	 * dirty the inode.
@@ -660,8 +691,17 @@ void ext4_iomap_end_bio(struct bio *bio)
 {
 	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
 	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
+	unsigned long io_mode = (unsigned long)ioend->io_private;
 	unsigned long flags;
 
+	/*
+	 * This is a disksize-pending I/O: clear the disksize-pending
+	 * state set in ext4_block_zero_eof() and wake up all waiters
+	 * that will update the inode i_disksize.
+	 */
+	if (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
+		ext4_iomap_clear_disksize_pending(ioend->io_inode);
+
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	if (list_empty(&ei->i_rsv_conversion_list))
 		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
-- 
2.52.0

