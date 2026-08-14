Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDBB43CED7;
	Fri, 14 Aug 2026 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700411; cv=none; b=WETajSWPqzR3WyESaECUhqDcSf1I6DQ3roXUWtJqFZ5uI9DJ+sbm644qE3k3pzUSaoVmC2Mh0rVn+FRySoChUNPJubEabq6nE5fechRIuXGpbOYRChRqr8p7jlIE6MsoaasmylCrYMjte1vbWvGTYhRYaGttnALsFgyNJ2uAqdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700411; c=relaxed/simple;
	bh=zDov8zxYYt9fFGhkHUrlOlPvimkURQvwpLQYfpMmxlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeYQkRezpS9OWMUEAGzvfSyBeei/347irv53ejEpXReOsUh+lwIulzlzqewKUVWVtehiUyLZU7muA/jLIxqOjF0+JO7jzzkerP5ErHXaOpQDbZ5ZjoKwYlC5R1xx/dx0XrJXBS3uc2zS4RCfJtLZKBWJHp7czDRC7kKF93Wid7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyS3vljzKHNNk;
	Fri, 14 Aug 2026 17:39:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3F99B40C40;
	Fri, 14 Aug 2026 17:39:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S24;
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
Subject: [PATCH -next v5 20/32] ext4: add block mapping tracepoints for iomap buffered I/O path
Date: Fri, 14 Aug 2026 17:33:19 +0800
Message-ID: <20260814093331.1703882-21-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S24
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7ZF1rKr18Xr47GFy8Krg_yoWrGFy7pa
	4vyFy5KFs3XrsF9w4fWrW3Xr1Fva1xKr4UGry3Wry5ZFWxtr12gF4UGFyjyFy5Jw4jkryf
	WF4Ykry8G3WUurDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Add tracepoints for iomap buffered read, write, partial block zeroing,
and writeback operations to help debug the iomap buffered I/O path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c             |  6 +++++
 include/trace/events/ext4.h | 45 +++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d4b4153077bb..a2f060ae6cbc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4006,6 +4006,8 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
 	if (ret < 0)
 		return ret;
 
+	trace_ext4_iomap_buffered_read_begin(inode, &map, offset, length,
+					     flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	return 0;
 }
@@ -4039,6 +4041,8 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
 	if (ret < 0)
 		return ret;
 
+	trace_ext4_iomap_buffered_write_begin(inode, &map, offset, length,
+					      flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	return 0;
 }
@@ -4155,6 +4159,7 @@ static int ext4_iomap_zero_begin(struct inode *inode,
 			goto again;
 	}
 
+	trace_ext4_iomap_zero_begin(inode, &map, offset, length, flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	iomap->flags |= iomap_flags;
 
@@ -4266,6 +4271,7 @@ static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
 		return ret;
 	}
 
+	trace_ext4_iomap_map_writeback_range(inode, &map, offset, dirty_len, 0);
 	ext4_set_iomap(inode, &wpc->iomap, &map, offset, dirty_len, 0);
 	return 0;
 }
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 7028a28316fa..69596a216dcb 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3157,6 +3157,51 @@ TRACE_EVENT(ext4_move_extent_exit,
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

