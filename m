Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4AD35838A;
	Wed, 22 Apr 2026 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824227; cv=none; b=Ts3OCMYw0i8y7IODhCUdn1UXlgSIA/Lvvad4pC2aCuMqpPB+l7pTDFhXEWE9RZhSgsgrZI6522C2lJwdyfR6ohrJ4puBTi5gwcCeKhrzVDfnR8B7FzhAAdwWSyW/JOBdpUK40H212DEo8llKOgZ7sIAkQyiBChpFlREpdtPxF3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824227; c=relaxed/simple;
	bh=cD0bCy3g9mJTd0A1fuNVh0uWNy9F36geLGfTMHjUsw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf6iYW7O9A8GSDRNQKeE+VI0KQ8KBxcdTKDsFGlWPVjNSwB2sxH6kcNam6sta5uryHt2ZOSI708CV98t6nU7oFL0mxHCC2Ej7AMhxnoEBycl1Y2Fwoh3MMkjgm5Q3RhqV2YmhZPMf+mQ2dFYuQS+MZboPyJ2PsGjoawuJKyQhwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0jWN3CQQzYQtrW;
	Wed, 22 Apr 2026 10:16:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A0CE940603;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S26;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
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
Subject: [PATCH v3 22/22] ext4: add tracepoints for ordered I/O in the iomap buffered I/O path
Date: Wed, 22 Apr 2026 10:10:42 +0800
Message-ID: <20260422021042.4157510-23-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S26
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww1xury5uFyDuFW7Cw18uFg_yoWxCFyrpF
	1DCFyrGw48Zrn09w4xXw4Iqr4YvF4rCa18try3WFyDZ3yxAr92kF47tF90vFy8tr4qkryI
	gF4DArWkKw1DXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

To facilitate the tracing of ordered I/Os in the iomap buffered I/O
path, add tracepoints to track the ordered I/O flow:

 - ext4_iomap_ordered_submit: trace when ordered I/O is being submitted;
 - ext4_iomap_ordered_complete: trace when ordered I/O completes;
 - ext4_iomap_disksize_update: trace when i_disksize is updated, either
   when appending I/O or when an ordered I/O completes;
 - ext4_block_zero_eof - trace zero EOF partial block.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c             |  4 ++
 fs/ext4/page-io.c           |  8 +++
 include/trace/events/ext4.h | 97 +++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d983336390c7..ca4284da2a2b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4377,6 +4377,9 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
 				     ioend->io_offset + ioend->io_size);
 
 		if (start <= order_lblk && end >= order_lblk + order_len) {
+			trace_ext4_iomap_ordered_submit(ioend->io_inode,
+					ioend->io_offset, ioend->io_size,
+					order_lblk, order_len);
 			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
 			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
 			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
@@ -4879,6 +4882,7 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 		}
 	}
 
+	trace_ext4_block_zero_eof(inode, from, length, did_zero, zero_written);
 	return 0;
 }
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 589c74b9f8a3..979a88c38fff 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -31,6 +31,8 @@
 #include "xattr.h"
 #include "acl.h"
 
+#include <trace/events/ext4.h>
+
 static struct kmem_cache *io_end_cachep;
 static struct kmem_cache *io_end_vec_cachep;
 
@@ -673,6 +675,9 @@ static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
 	 * never be exposed.
 	 */
 	new_disksize = is_ordered ? i_size : min(end, i_size);
+	trace_ext4_iomap_disksize_update(inode, end, i_size, ei->i_disksize,
+					 new_disksize, is_ordered);
+
 	if (new_disksize > ei->i_disksize)
 		ei->i_disksize = new_disksize;
 	up_write(&ei->i_data_sem);
@@ -782,6 +787,9 @@ void ext4_iomap_end_bio(struct bio *bio)
 		 * waiters.
 		 */
 		smp_store_release(&ei->i_ordered_len, 0);
+		trace_ext4_iomap_ordered_complete(inode, ioend->io_offset,
+				ioend->io_size, READ_ONCE(ei->i_ordered_lblk),
+				READ_ONCE(ei->i_ordered_len));
 		wake_up_all(&ei->i_ordered_wq);
 		goto defer;
 	}
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index ebafa06cd191..423aec6d09d1 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3141,6 +3141,103 @@ DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_write_begin);
 DEFINE_SET_IOMAP_EVENT(ext4_iomap_map_writeback_range);
 DEFINE_SET_IOMAP_EVENT(ext4_iomap_zero_begin);
 
+/* Ordered I/O tracepoints for iomap buffered I/O path */
+DECLARE_EVENT_CLASS(ext4_iomap_ordered_io,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size,
+		 ext4_lblk_t i_ordered_lblk, unsigned int i_ordered_len),
+	TP_ARGS(inode, io_offset, io_size, i_ordered_lblk, i_ordered_len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, io_offset)
+		__field(size_t, io_size)
+		__field(ext4_lblk_t, i_ordered_lblk)
+		__field(unsigned int, i_ordered_len)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->io_offset = io_offset;
+		__entry->io_size = io_size;
+		__entry->i_ordered_lblk = i_ordered_lblk;
+		__entry->i_ordered_len = i_ordered_len;
+	),
+	TP_printk("dev %d:%d ino %llu io_offset %lld io_size %zu i_ordered_lblk %u i_ordered_len %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->io_offset, __entry->io_size,
+		  __entry->i_ordered_lblk, __entry->i_ordered_len)
+);
+
+DEFINE_EVENT(ext4_iomap_ordered_io, ext4_iomap_ordered_submit,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size,
+		 ext4_lblk_t i_ordered_lblk, unsigned int i_ordered_len),
+	TP_ARGS(inode, io_offset, io_size, i_ordered_lblk, i_ordered_len)
+);
+
+DEFINE_EVENT(ext4_iomap_ordered_io, ext4_iomap_ordered_complete,
+	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size,
+		 ext4_lblk_t i_ordered_lblk, unsigned int i_ordered_len),
+	TP_ARGS(inode, io_offset, io_size, i_ordered_lblk, i_ordered_len)
+);
+
+
+/* i_disksize update tracepoint */
+TRACE_EVENT(ext4_iomap_disksize_update,
+	TP_PROTO(struct inode *inode, loff_t end, loff_t i_size,
+		 loff_t i_disksize, loff_t new_disksize, bool is_ordered),
+	TP_ARGS(inode, end, i_size, i_disksize, new_disksize, is_ordered),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, end)
+		__field(loff_t, i_size)
+		__field(loff_t, i_disksize)
+		__field(loff_t, new_disksize)
+		__field(bool, is_ordered)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->end = end;
+		__entry->i_size = i_size;
+		__entry->i_disksize = i_disksize;
+		__entry->new_disksize = new_disksize;
+		__entry->is_ordered = is_ordered;
+	),
+	TP_printk("dev %d:%d ino %llu end %lld i_size %lld i_disksize %lld new_disksize %lld is_ordered %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->end, __entry->i_size,
+		  __entry->i_disksize, __entry->new_disksize,
+		  __entry->is_ordered)
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
+		__field(bool, did_zero)
+		__field(bool, zero_written)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->from = from;
+		__entry->length = length;
+		__entry->did_zero = did_zero;
+		__entry->zero_written = zero_written;
+	),
+	TP_printk("dev %d:%d ino %llu zero EOF from %lld length %lld did_zero %d zero_written %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->from, __entry->length,
+		  __entry->did_zero, __entry->zero_written)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
2.52.0

