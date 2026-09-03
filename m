Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74D4A0EEA;
	Thu,  3 Sep 2026 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439651; cv=none; b=gmXEAaUJwCGT9ND9R8/n306s0wMCgt7epzcYpqeALYXkh81+dOrnnMGUXoWERzHzg/o0xmM6TtnCvGwjGTKZmhq33HYHs/7epidqhrQQX6HhFWk1sNARu5rMxoDBMpF/oLIVyl74gTEyGZYyqJKErygS/kMnscAii1BFF+25INg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439651; c=relaxed/simple;
	bh=qSYmEETCtcEdf3WhTA4Rl1Ig8kz6qf3dtOe6LlowPqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDi0jkKcEGCYepqFNr01mfFNALdQQT7Argvqp3kQFYm+GNgSU8l5/6E2wu9a8iLEj5JT+eK08UeEVSn/hfJP57P8Ij2ZOes+VR6gv4Zlrlb1wmoGarbnhmfAaXgaPfKJSwKJ+JfMEuJVLZk6qLchbtUZtYU3R7vKpPBV91qwFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK9G0TrrzYQthg;
	Thu,  3 Sep 2026 20:46:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E36EC40D20;
	Thu,  3 Sep 2026 20:47:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBnUAtUbJlqlPhrAg--.37288S4;
	Thu, 03 Sep 2026 20:47:24 +0800 (CST)
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
Subject: [PATCH v6 29/31] ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
Date: Thu,  3 Sep 2026 20:40:15 +0800
Message-ID: <20260903124017.2325538-1-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgBnUAtUbJlqlPhrAg--.37288S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw4rZF4xXFyDGr4rCFW7Arb_yoWfGFW7pw
	1DCr98Gw1kJr1Y9r4IqryIqr4Fva95uF4UJF9xuFWjv3y0vF97tF47tF98uFyvyrsFywsF
	gF4vkrZ5G3W8Xr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar
	1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVWxJr0_GcJvcS
	sGvfC2KfnxnUUI43ZEXa7sRiKsUtUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add tracepoints to track the disksize-grow-pending lifecycle in the
writeback path and the block-zero-EOF entry point:

- ext4_iomap_wb_disksize_pending_submit: ioend is marked as
  DISKSIZE_GROW_IO in ext4_iomap_writeback_submit().
- ext4_iomap_wb_disksize_pending_complete: ioend of type
  DISKSIZE_GROW_IO completes in ext4_iomap_finish_ioend().
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
 fs/ext4/page-io.c           |  11 ++-
 include/trace/events/ext4.h | 129 ++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d53de72624bb..7454867ac8bd 100644
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
@@ -5011,6 +5013,7 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 			return err;
 	}
 
+	trace_ext4_block_zero_eof(inode, from, length, did_zero, zero_written);
 	return 0;
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4f1176b9332f..734d856a6d47 100644
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
@@ -641,6 +647,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	int ret, err;
 
 	ret = blk_status_to_errno(ioend->io_bio.bi_status);
+	if (is_disksize_grow)
+		trace_ext4_iomap_wb_disksize_pending_complete(ioend->io_inode,
+				ioend->io_offset, ioend->io_size, ret);
 	if (unlikely(ret)) {
 		if (test_opt(sb, DATA_ERR_ABORT) && !ext4_emergency_state(sb))
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 6bd0849c2f09..74d09a2a58cc 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3235,6 +3235,135 @@ DEFINE_EVENT(ext4_iomap_disksize_pending, ext4_iomap_wait_disksize_pending,
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
+	ext4_iomap_wb_disksize_pending_wait,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size),
+	TP_ARGS(inode, io_offset, io_size)
+);
+
+TRACE_EVENT(ext4_iomap_wb_disksize_pending_complete,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size,
+		 int ret),
+	TP_ARGS(inode, io_offset, io_size, ret),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, io_offset)
+		__field(size_t, io_size)
+		__field(loff_t, i_size)
+		__field(loff_t, i_disksize)
+		__field(int, ret)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->io_offset = io_offset;
+		__entry->io_size = io_size;
+		__entry->i_size = i_size_read(inode);
+		__entry->i_disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
+		__entry->ret = ret;
+	),
+	TP_printk("dev %d:%d ino %llu io_offset %lld io_size %zu ret %d i_size %lld i_disksize %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->io_offset, __entry->io_size,
+		  __entry->ret, __entry->i_size, __entry->i_disksize)
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

