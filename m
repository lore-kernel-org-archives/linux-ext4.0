Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59086352FA5;
	Wed, 22 Apr 2026 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824230; cv=none; b=d83TBbtS8lswYqO/cWCeYsIme/0/6O+NQ/Fyu4v7KCi8+RavSAslaaRxCSEsVJcT+PSLRHxJCc4jX97gLi7325PKLimUj4bbIfxZnxD49J8RT1BcETSXLIOkQiaCKwmNPGZJaLu+OUxrL+J4KDsN3hC+vl2rZsOD2SLHg5YF4jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824230; c=relaxed/simple;
	bh=2KLnNij5KNNVM2Cx1sKcD2NX2y5ocyh3EgNgT7sfJ0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmNNhkGrXrzF68lggifiIbnpBzmhLPmv0SEITHb5ozAQE7yH/ix4ygDvYoyj/adpxWNsXqqiWP/RGIrWle/78AxxAuRe+YsItUDN4yTI350hdk12rnWlrZ7nqDLKu+VRKc5hcqE9HSxFZb+2hbIq5vczqQDsqrLSLo+G+CqXB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0jWM6KkPzYQtrf;
	Wed, 22 Apr 2026 10:15:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 1770C405D6;
	Wed, 22 Apr 2026 10:16:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S19;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
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
Subject: [PATCH v3 15/22] ext4: add block mapping tracepoints for iomap buffered I/O path
Date: Wed, 22 Apr 2026 10:10:35 +0800
Message-ID: <20260422021042.4157510-16-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S19
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7ZrWDAFWkXF17WF18uFg_yoWrGr4fpa
	4vyFy5GF4fXrsF9w4fWrW3XF1Fva1xKr4UGry3Wry5AFWxtr42gF4UGFyjyFy5Jw4jkryf
	XF4Ykry8G3WUurDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add tracepoints for iomap buffered read, write, partial block zeroing,
and writeback operations to help debug the iomap buffered I/O path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c             |  6 +++++
 include/trace/events/ext4.h | 45 +++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 701b912db6fb..53fdcb50f3dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3961,6 +3961,8 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
 	if (ret < 0)
 		return ret;
 
+	trace_ext4_iomap_buffered_read_begin(inode, &map, offset, length,
+					     flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	return 0;
 }
@@ -4036,6 +4038,8 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
 	if (ret < 0)
 		return ret;
 
+	trace_ext4_iomap_buffered_write_begin(inode, &map, offset, length,
+					      flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	return 0;
 }
@@ -4138,6 +4142,7 @@ static int ext4_iomap_zero_begin(struct inode *inode,
 			map.m_len = (offset >> blkbits) - map.m_lblk;
 	}
 
+	trace_ext4_iomap_zero_begin(inode, &map, offset, length, flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	iomap->flags |= iomap_flags;
 
@@ -4306,6 +4311,7 @@ static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
 		return ret;
 	}
 out:
+	trace_ext4_iomap_map_writeback_range(inode, &map, offset, dirty_len, 0);
 	ext4_set_iomap(inode, &wpc->iomap, &map, offset, dirty_len, 0);
 	return 0;
 }
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index f493642cf121..ebafa06cd191 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3096,6 +3096,51 @@ TRACE_EVENT(ext4_move_extent_exit,
 		  __entry->ret)
 );
 
+DECLARE_EVENT_CLASS(ext4_set_iomap_class,
+	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
+		 loff_t offset, loff_t length, unsigned int flags),
+	TP_ARGS(inode, map, offset, length, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(ext4_lblk_t, m_lblk)
+		__field(unsigned int, m_len)
+		__field(unsigned int, m_flags)
+		__field(u64, m_seq)
+		__field(loff_t, offset)
+		__field(loff_t, length)
+		__field(unsigned int, iomap_flags)
+	),
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->m_lblk		= map->m_lblk;
+		__entry->m_len		= map->m_len;
+		__entry->m_flags	= map->m_flags;
+		__entry->m_seq		= map->m_seq;
+		__entry->offset		= offset;
+		__entry->length		= length;
+		__entry->iomap_flags	= flags;
+
+	),
+	TP_printk("dev %d:%d ino %llu m_lblk %u m_len %u m_flags %s m_seq %llu orig_off 0x%llx orig_len 0x%llx iomap_flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->m_lblk, __entry->m_len,
+		  show_mflags(__entry->m_flags), __entry->m_seq,
+		  __entry->offset, __entry->length, __entry->iomap_flags)
+)
+
+#define DEFINE_SET_IOMAP_EVENT(name) \
+DEFINE_EVENT(ext4_set_iomap_class, name, \
+	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map, \
+		 loff_t offset, loff_t length, unsigned int flags), \
+	TP_ARGS(inode, map, offset, length, flags))
+
+DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_read_begin);
+DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_write_begin);
+DEFINE_SET_IOMAP_EVENT(ext4_iomap_map_writeback_range);
+DEFINE_SET_IOMAP_EVENT(ext4_iomap_zero_begin);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
2.52.0

