Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F37390992;
	Mon, 11 May 2026 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484521; cv=none; b=B1dTwkCvGzbuMEEtSRWTWr2aazgn3YsPBJgKiWibOtuQBQqK6NkWf4xiewCY40zavtnZEG1fByLuo3Rh+JXAJ/5RX2dg3KiOE7NCr6KOc82eV5OGp1q4wnCo5TSlZG8QyWjSi6yYVsqRZB5q41Qv4klxYLC6HGL/SVENWtaqNjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484521; c=relaxed/simple;
	bh=pTAy+2+kW0hd6ArJe/XxmdF9CJ4jwbhGmawCxMEgPoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF5o5RbIMsG9N1xVAX0JOXor7kYrhmEiRfC3ofDEi/jY1BxfUVTNn31i/xw+N2+jA62mvzwdfRGZKH8R9KcwcBWqr3520j/VpRosP9OkixLbEJ1y/+JIO+KemnEIuP4N5NLhZbJs6ZgopjcJWLEi/g0NnWri0ivNEduB2Qq8Arw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXW1B0tzYQv3b;
	Mon, 11 May 2026 15:27:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CD6494056F;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S19;
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
Subject: [PATCH v4 15/23] ext4: add block mapping tracepoints for iomap buffered I/O path
Date: Mon, 11 May 2026 15:23:35 +0800
Message-ID: <20260511072344.191271-16-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S19
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7ZrWDAFWkXF17WF18uFg_yoWrGr43pF
	yqyFy5KF4fXrsF9w4fWrW3XF1Fva1xKr4UGry3Wry5JFWxtr42gF4UGFyjyFy5Jw4jkryf
	WF4Ykry8G3WUuFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Add tracepoints for iomap buffered read, write, partial block zeroing,
and writeback operations to help debug the iomap buffered I/O path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c             |  6 +++++
 include/trace/events/ext4.h | 45 +++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e0dae2501292..239d387ffaf2 100644
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
@@ -4034,6 +4036,8 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
 	if (ret < 0)
 		return ret;
 
+	trace_ext4_iomap_buffered_write_begin(inode, &map, offset, length,
+					      flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	return 0;
 }
@@ -4136,6 +4140,7 @@ static int ext4_iomap_zero_begin(struct inode *inode,
 			map.m_len = (start >> blkbits) - map.m_lblk;
 	}
 
+	trace_ext4_iomap_zero_begin(inode, &map, offset, length, flags);
 	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	iomap->flags |= iomap_flags;
 
@@ -4308,6 +4313,7 @@ static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
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

