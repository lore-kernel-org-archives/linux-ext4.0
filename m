Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A090F3A0EA2;
	Fri, 14 Aug 2026 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700406; cv=none; b=o/2PGXj1mBW+6SxjiiFjynfs7x15v0cpGrp0iThSP+xGvkVUtaD3emTX1iV8SSBnY+vzFFuRaLgBTyud6/fCkQpkYmmmWidw4bXxbpGj1a6PzApQA3k4bnQ7ycpcvcCxtQG3Zw4TGc0rfpW1++/CXwBRm/vn2LMXC4eE/YM0IYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700406; c=relaxed/simple;
	bh=paAgJoIYZCFpB17m47tThq8gFbcfpHuo4I11SE4QkPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obfe05kD6+rQVxja71hjX55qDuocErRNE9iBlIkkfAP0Cmy3ypnH/b/LBbzEM8Uk8QRk9g2yfEliJjbSrU2kZ4TJ18p6yWf+1VkyMLExdIIjrL+Ge9l3J4kPQljKnAWm681RLZdiXn9u1a10Kt22jDoFHyvgSJheRnmDokVBdXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyk1bPwzYQvYY;
	Fri, 14 Aug 2026 17:39:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 707FD4056B;
	Fri, 14 Aug 2026 17:39:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S34;
	Fri, 14 Aug 2026 17:39:50 +0800 (CST)
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
Subject: [PATCH -next v5 30/32] ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
Date: Fri, 14 Aug 2026 17:33:29 +0800
Message-ID: <20260814093331.1703882-31-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S34
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw4rZF4xXFWxWFWxZr1xuFg_yoW3ZF17pw
	1DGr98Gw1kJr1Y9r4IqryIqr4F9ayruF48Jr9xuFWjv348ZFZ2qF4xKF98uFy0yrsFywsI
	gF1vkrZ5G3W8XrJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW7JVWDJwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVWxJr0_GcJvcSsG
	vfC2KfnxnUUI43ZEXa7sRiyxR3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add tracepoints to track the disksize-grow-pending lifecycle in the
writeback path and the block-zero-EOF entry point:

- ext4_iomap_wb_disksize_pending_submit: ioend is marked as
  DISKSIZE_GROW_IO in ext4_iomap_writeback_submit.
- ext4_iomap_wb_disksize_pending_complete: ioend of type
  DISKSIZE_GROW_IO completes in ext4_iomap_end_bio.
- ext4_iomap_wb_disksize_pending_wait: ioend worker waits for the
  pending zeroed EOF block to complete.
- ext4_iomap_wb_update_disksize: i_disksize is advanced in
  ext4_iomap_wb_update_disksize, including the new value and
  whether the update is a disksize-grow completion.
- ext4_block_zero_eof: ext4_block_zero_eof is called with the range
  and zeroing outcome, capturing the producer-side entry point.

Together with the previous mark/clear/wait tracepoints, these cover the
full lifetime of the disksize-grow-pending state.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c             |   3 +
 fs/ext4/page-io.c           |  13 ++++-
 include/trace/events/ext4.h | 107 ++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bca7d5c33919..ee15366422a1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4406,6 +4406,8 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 	    round_down(ioend->io_offset, blocksize) <= pstart &&
 	    round_up(ioend->io_offset + ioend->io_size, blocksize) >=
 			pstart + plen) {
+		trace_ext4_iomap_wb_disksize_pending_submit(inode,
+				ioend->io_offset, ioend->io_size);
 		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
 		ioend->io_private = (void *)EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO;
 	}
@@ -5001,6 +5003,7 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 			return err;
 	}
 
+	trace_ext4_block_zero_eof(inode, from, length, did_zero, zero_written);
 	return 0;
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4f1176b9332f..4464eb03c972 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -31,6 +31,8 @@
 #include "xattr.h"
 #include "acl.h"
 
+#include <trace/events/ext4.h>
+
 static struct kmem_cache *io_end_cachep;
 static struct kmem_cache *io_end_vec_cachep;
 
@@ -574,6 +576,7 @@ static void ext4_iomap_wb_disksize_pending_wait(struct inode *inode,
 	if (!plen || pos < pstart + plen)
 		return;
 
+	trace_ext4_iomap_wb_disksize_pending_wait(inode, pos, size);
 	ext4_iomap_wait_disksize_pending(inode);
 }
 
@@ -617,8 +620,11 @@ static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 	 * after the data has been persisted.
 	 */
 	new_disksize = is_disksize_grow ? i_size : min(end, i_size);
-	if (new_disksize > ei->i_disksize)
+	if (new_disksize > ei->i_disksize) {
+		trace_ext4_iomap_wb_update_disksize(inode, end, i_size,
+				ei->i_disksize, new_disksize, is_disksize_grow);
 		WRITE_ONCE(ei->i_disksize, new_disksize);
+	}
 	up_write(&ei->i_data_sem);
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (ret)
@@ -729,8 +735,11 @@ void ext4_iomap_end_bio(struct bio *bio)
 	 * state set in ext4_block_zero_eof() and wake up all waiters
 	 * that will update the inode i_disksize.
 	 */
-	if (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
+	if (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO) {
+		trace_ext4_iomap_wb_disksize_pending_complete(ioend->io_inode,
+				ioend->io_offset, ioend->io_size);
 		ext4_iomap_clear_disksize_pending(ioend->io_inode);
+	}
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	if (list_empty(&ei->i_rsv_conversion_list))
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 4539ef8e5f86..c9259c2a3e36 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3237,6 +3237,113 @@ DEFINE_EVENT(ext4_iomap_disksize_pending, ext4_iomap_wait_disksize_pending,
 	TP_ARGS(inode)
 );
 
+/* disksize pending I/O tracepoints for iomap Buffered I/O path */
+DECLARE_EVENT_CLASS(ext4_iomap_wb_disksize_pending,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size),
+	TP_ARGS(inode, io_offset, io_size),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, io_offset)
+		__field(size_t, io_size)
+		__field(loff_t, i_size)
+		__field(loff_t, i_disksize)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->io_offset = io_offset;
+		__entry->io_size = io_size;
+		__entry->i_size = i_size_read(inode);
+		__entry->i_disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
+	),
+	TP_printk("dev %d:%d ino %llu io_offset %lld io_size %zu i_size %lld i_disksize %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->io_offset, __entry->io_size,
+		  __entry->i_size, __entry->i_disksize)
+);
+
+DEFINE_EVENT(ext4_iomap_wb_disksize_pending,
+	ext4_iomap_wb_disksize_pending_submit,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size),
+	TP_ARGS(inode, io_offset, io_size)
+);
+
+DEFINE_EVENT(ext4_iomap_wb_disksize_pending,
+	ext4_iomap_wb_disksize_pending_complete,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size),
+	TP_ARGS(inode, io_offset, io_size)
+);
+
+DEFINE_EVENT(ext4_iomap_wb_disksize_pending,
+	ext4_iomap_wb_disksize_pending_wait,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size),
+	TP_ARGS(inode, io_offset, io_size)
+);
+
+/* i_disksize update tracepoint */
+TRACE_EVENT(ext4_iomap_wb_update_disksize,
+	TP_PROTO(struct inode *inode, loff_t end, loff_t i_size,
+		 loff_t i_disksize, loff_t new_disksize,
+		 bool is_disksize_grow),
+	TP_ARGS(inode, end, i_size, i_disksize, new_disksize,
+		is_disksize_grow),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, end)
+		__field(loff_t, i_size)
+		__field(loff_t, i_disksize)
+		__field(loff_t, new_disksize)
+		__field(bool, is_disksize_grow)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->end = end;
+		__entry->i_size = i_size;
+		__entry->i_disksize = i_disksize;
+		__entry->new_disksize = new_disksize;
+		__entry->is_disksize_grow = is_disksize_grow;
+	),
+	TP_printk("dev %d:%d ino %llu end %lld i_size %lld i_disksize %lld new_disksize %lld is_disksize_grow %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->end, __entry->i_size,
+		  __entry->i_disksize, __entry->new_disksize,
+		  __entry->is_disksize_grow)
+);
+
+/* Block zero EOF tracepoint */
+TRACE_EVENT(ext4_block_zero_eof,
+	TP_PROTO(struct inode *inode, loff_t from, loff_t length,
+		 bool did_zero, bool zero_written),
+	TP_ARGS(inode, from, length, did_zero, zero_written),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, from)
+		__field(loff_t, length)
+		__field(loff_t, i_size)
+		__field(loff_t, i_disksize)
+		__field(bool, did_zero)
+		__field(bool, zero_written)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->from = from;
+		__entry->length = length;
+		__entry->i_size = inode->i_size;
+		__entry->i_disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
+		__entry->did_zero = did_zero;
+		__entry->zero_written = zero_written;
+	),
+	TP_printk("dev %d:%d ino %llu zero EOF from %lld length %lld i_size %lld i_disksize %lld did_zero %d zero_written %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->ino,
+		  __entry->from, __entry->length, __entry->i_size,
+		  __entry->i_disksize, __entry->did_zero, __entry->zero_written)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
2.52.0

