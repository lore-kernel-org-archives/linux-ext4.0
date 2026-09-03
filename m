Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE474A8A10;
	Thu,  3 Sep 2026 12:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439386; cv=none; b=mzrAJ4zkuozdD2SHcCSK2NjAnZdydw7Scr4hw54VhTdUODuvbsl+Znq+bSzV1uMax6VGTo63f0vkV3gqcyzgoKRcljOfSKy2EZYOTYIom4G7CGiuT3UYeMXyZda0BOQcFFGVV11bivW5kC/s5/aHWHGnbWABMxEZIF4tN8YzBPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439386; c=relaxed/simple;
	bh=9RCr9wL/u6HtYu2X4+eZBRcTl8v083rxrrLGmrjVjMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFk0pwaA7SBsmuEIWp83NR7RXtA1KCY5OzN40NftZsjleqaXCd7S1Q41gBUtUVEv79hwkA0kaNGhp9eyhCXxpFj6qZ549wnOdx1TKoXJ/veBkzal3MZdqxT7OTNsNTccWoQk5hG7tf4XYMjwMS8JJF+sHAKxXekD7clK58VZllA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3q4mmHzKHMmM;
	Thu,  3 Sep 2026 20:41:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 54A8F40561;
	Thu,  3 Sep 2026 20:42:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S32;
	Thu, 03 Sep 2026 20:42:53 +0800 (CST)
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
Subject: [PATCH v6 28/31] ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
Date: Thu,  3 Sep 2026 20:35:40 +0800
Message-ID: <20260903123543.2302999-29-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S32
X-Coremail-Antispam: 1UD129KBjvJXoWxXw18tr4fury5JF1rJryxKrg_yoW5ur18pr
	1DKFn8GwnrJr9F9w4Sqry7Zr1YvF4rGr4UGryfCr1IqFWrCryIgF4IqFnxCFy8Aw4kA3y2
	gFn09w4kC3WUCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnI
	WIevJa73UjIFyTuYvjTR_nYFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add trace events ext4_iomap_mark_disksize_pending(),
ext4_iomap_clear_disksize_pending(), and
ext4_iomap_wait_disksize_pending() to track disksize-grow-pending
state changes and waiting.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c             |  6 +++++-
 include/trace/events/ext4.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4cb0ea82f58c..d53de72624bb 100644
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
@@ -4892,8 +4894,10 @@ static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
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
index 69596a216dcb..6bd0849c2f09 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3202,6 +3202,39 @@ DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_write_begin);
 DEFINE_SET_IOMAP_EVENT(ext4_iomap_map_writeback_range);
 DEFINE_SET_IOMAP_EVENT(ext4_iomap_zero_begin);
 
+DECLARE_EVENT_CLASS(ext4_iomap_disksize_pending,
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, ino)
+		__field(loff_t, i_disksize)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->i_disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
+	),
+	TP_printk("dev %d:%d ino %llu i_disksize %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->i_disksize)
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

