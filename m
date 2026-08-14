Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1882463B93;
	Fri, 14 Aug 2026 09:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700417; cv=none; b=J2QSANT004OaUGKcSyOLqk0ciKAN4Aj1Z93qtgs9Xj770idzVwUdCjRq2gUa8RGTCVnHBXuD+awFR1ZAESV5jyBxeRuVhqU61BGAzYoP+CzEQz8XvmnEjHWAgioAa7i8QWKnBmLxaLhxcahFvQrxBlkEU3RFb2NKDW6Q5SE2Sdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700417; c=relaxed/simple;
	bh=1N/B8/PkyJjboJ1cO/VS6WU52V+hOGWHQ3Gb2mv8qwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUoZ2m9eOH35bijMWiq3xRKctzLFlZY6Qg2bUmV7kSiCKFcyNckWn/oRjrOn67163T3ViuHrQnxISv3NcDUVtwy5S1CR54v+WDi5ekmvQkTy3NihEp2vvhHhenc8f+QNDgRtnOVplMGX65BuOALIOwGerdxCJBYFyvQFzJH8+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyT3KdpzKHNMD;
	Fri, 14 Aug 2026 17:39:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 285964058F;
	Fri, 14 Aug 2026 17:39:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S33;
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
Subject: [PATCH -next v5 29/32] ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
Date: Fri, 14 Aug 2026 17:33:28 +0800
Message-ID: <20260814093331.1703882-30-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S33
X-Coremail-Antispam: 1UD129KBjvJXoWxXw1UKF1kGr1ftF4fJw15twb_yoW5uw1Dpr
	1DKrn8Gwn7Jr9I9w4Sqry7Zr1YvF4rGr4UGryfCr12qFWrCryxKF4IqF9IkFy8Aw4kA3y2
	gFn0k3ykC3WUCrJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Add trace events ext4_iomap_mark_disksize_pending(),
ext4_iomap_clear_disksize_pending(), and
ext4_iomap_wait_disksize_pending() to track disksize-grow-pending
state changes and waiting.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c             |  6 +++++-
 include/trace/events/ext4.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ec69e8abe54..bca7d5c33919 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -133,6 +133,7 @@ void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw,
  */
 void ext4_iomap_clear_disksize_pending(struct inode *inode)
 {
+	trace_ext4_iomap_clear_disksize_pending(inode);
 	ext4_clear_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
 	/*
 	 * Make sure clearing of EXT4_STATE_DISKSIZE_GROW_PENDING is
@@ -151,6 +152,7 @@ void ext4_iomap_clear_disksize_pending(struct inode *inode)
  */
 void ext4_iomap_wait_disksize_pending(struct inode *inode)
 {
+	trace_ext4_iomap_wait_disksize_pending(inode);
 	wait_on_bit(ext4_inode_state_wait_word(inode),
 		    ext4_inode_state_wait_bit(EXT4_STATE_DISKSIZE_GROW_PENDING),
 		    TASK_UNINTERRUPTIBLE);
@@ -4895,8 +4897,10 @@ static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
 	 */
 	if (likely(folio_test_dirty(folio) &&
 		   !ext4_test_inode_state(inode,
-					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
+					  EXT4_STATE_DISKSIZE_GROW_PENDING))) {
+		trace_ext4_iomap_mark_disksize_pending(inode);
 		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
+	}
 
 	folio_unlock(folio);
 	folio_put(folio);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 69596a216dcb..4539ef8e5f86 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3202,6 +3202,41 @@ DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_write_begin);
 DEFINE_SET_IOMAP_EVENT(ext4_iomap_map_writeback_range);
 DEFINE_SET_IOMAP_EVENT(ext4_iomap_zero_begin);
 
+DECLARE_EVENT_CLASS(ext4_iomap_disksize_pending,
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, i_size)
+		__field(loff_t, i_disksize)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->i_size = i_size_read(inode);
+		__entry->i_disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
+	),
+	TP_printk("dev %d:%d ino %llu i_size %lld i_disksize %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->i_size, __entry->i_disksize)
+);
+
+DEFINE_EVENT(ext4_iomap_disksize_pending, ext4_iomap_mark_disksize_pending,
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(ext4_iomap_disksize_pending, ext4_iomap_clear_disksize_pending,
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(ext4_iomap_disksize_pending, ext4_iomap_wait_disksize_pending,
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
2.52.0

