Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2C74BFE9B;
	Fri,  9 Oct 2026 10:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542259; cv=none; b=GOSLhWDVHRq9Hs4K24P7k9alUK76NWhlKaP2cFxcKt/rUBF4FE1AS/oLkFhf1hb55kZqk2ZAqXZHOCAHASwiI8yaKS8Jizhdhi/WJYAciNAe+lJfOY5v/1j26NbctTUKeFQUPj/11UrP0Y2U0/Zx0iJNblZt58pE/ijQEiqFshY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542259; c=relaxed/simple;
	bh=kCByc/1ae6Ot5gpgDoGWuQ8Sj/QfAA3rz8gFJlQQRk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI//Xj1lweQujXs2L4Qa/rROI/+ZWLwfhGrADUMLTJztlaNi9Y/pjq2BXTNU7B/Ct/39/xdPv6uOsEyNonEgoTaMDt6tFiqyvHTNeZkrhaPItl+5Fn53YDoJaSd6APYxoyXtcURAjhbm58fBpp2wByKHuK8i6G/GP2mO5Hq9Sxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZY4t2KzYQv9Y;
	Fri,  9 Oct 2026 18:36:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id DDCDB40561;
	Fri,  9 Oct 2026 18:37:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S32;
	Fri, 09 Oct 2026 18:37:21 +0800 (CST)
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
Subject: [PATCH v7 28/31] ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
Date: Fri,  9 Oct 2026 18:30:29 +0800
Message-ID: <20261009103033.2920530-29-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S32
X-Coremail-Antispam: 1UD129KBjvJXoWxXw15tF4DJryDtw1DWFWDtwb_yoW5Kr47pw
	1DKFn8GwnrXr9F9r4Sqry7Zr1Y9F4rGr4UGFW3Crn2qryrCryIgF4xKF9FkFyrA3ykA3y2
	gF1qkw4DC3WUCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnI
	WIevJa73UjIFyTuYvjTRRyxRDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add trace events ext4_iomap_mark_disksize_pending(),
ext4_iomap_clear_disksize_pending(), and
ext4_iomap_wait_disksize_pending() to track disksize-grow-pending
state changes and waiting.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c             | 15 ++++++++++++---
 include/trace/events/ext4.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3bdb5f3b119ab..920760ab6ea7b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -133,9 +133,12 @@ void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw,
  */
 void ext4_iomap_clear_disksize_pending(struct inode *inode)
 {
-	clear_and_wake_up_bit(
+	if (!test_and_clear_wake_up_bit(
 		ext4_inode_state_wait_bit(EXT4_STATE_DISKSIZE_GROW_PENDING),
-		ext4_inode_state_wait_word(inode));
+		ext4_inode_state_wait_word(inode)))
+		return;
+
+	trace_ext4_iomap_clear_disksize_pending(inode);
 }
 
 /*
@@ -144,6 +147,10 @@ void ext4_iomap_clear_disksize_pending(struct inode *inode)
  */
 void ext4_iomap_wait_disksize_pending(struct inode *inode)
 {
+	/* Only emit the trace when the bit is actually set */
+	if (ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
+		trace_ext4_iomap_wait_disksize_pending(inode);
+
 	wait_on_bit(ext4_inode_state_wait_word(inode),
 		    ext4_inode_state_wait_bit(EXT4_STATE_DISKSIZE_GROW_PENDING),
 		    TASK_UNINTERRUPTIBLE);
@@ -4922,8 +4929,10 @@ static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
 	 */
 	if (likely(folio_test_dirty(folio) &&
 		   !ext4_test_inode_state(inode,
-					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
+					  EXT4_STATE_DISKSIZE_GROW_PENDING))) {
+		trace_ext4_iomap_mark_disksize_pending(inode);
 		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
+	}
 out:
 	folio_unlock(folio);
 	folio_put(folio);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index bcf80f518e61d..d33456d06b001 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -3204,6 +3204,39 @@ DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_write_begin);
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

