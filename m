Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBAA4A0122;
	Thu,  3 Sep 2026 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439385; cv=none; b=eIw1VdqvUILlKjMiSU/dNB1LaUBRkwHx/W+cx/ZQ1LQDh47bpuprDAnS8WVUX1+oFBusVkmdnsBe7Qk1I4gsc374BVLs+eD23YdEl6gqFwlLJ7FImFqZxH3A3ssAkl633KBZvAZZg/N9If01Ej6zi4NU87kLkzrPBKbiEPqg1TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439385; c=relaxed/simple;
	bh=QixlQjB651qgJmet/FtSOy26MpyWdPgboxMvBX93jlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+Bipf0at+HqR+CvNWIfL8YrmKOM154SBh1bBUcMZBBrmkd9+byG6tsqwNEhxzPcFzMsSybtsgeGg2tG8NiMHP001nuWdF9CQ2f0EpWhTf3LzyVbg3vSk04DeB+nV/kzBjG9MCG48BvUOd6ti88+1xU7VKbXeNHl43Xpb83jPJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3q3K9SzKHMmx;
	Thu,  3 Sep 2026 20:41:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2387A40592;
	Thu,  3 Sep 2026 20:42:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S30;
	Thu, 03 Sep 2026 20:42:52 +0800 (CST)
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
Subject: [PATCH v6 26/31] ext4: clear DISKSIZE_GROW_PENDING on truncate or error
Date: Thu,  3 Sep 2026 20:35:38 +0800
Message-ID: <20260903123543.2302999-27-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S30
X-Coremail-Antispam: 1UD129KBjvJXoWxZFyDur17Kr48JF1kGryrtFb_yoWrAr18pr
	Z8KFn5Cr18Wr9F9r4SgF18Xr1rKa18ta1UAFWxuF4kXF15X34xKF18ta47ZFW8KrZ5Xw42
	qF40kr4DWw48CrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVWxJr0_GcJvcSsG
	vfC2KfnxnUUI43ZEXa7sRRjg43UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The disksize-grow-pending state is set when a zeroed EOF block is queued
for writeback and cleared by the ioend completion path once writeback
finishes. However, the zeroed block may be discarded before writeback
completes — through folio discard, truncate, or unlink and inode
eviction.

In any of these cases, leaving the bit set would block subsequent
writeback indefinitely. Therefore, we must clear it on all paths that
invalidate the pending block before writeback completes:
 - ext4_iomap_discard_folio() on folio discard.
 - ext4_evict_inode() when an unlinked inode is destroyed.

In ext4_truncate_down(), truncating past the pending zeroed EOF block
also invalidates the pending disksize update, so the bit must be cleared
there as well.

Finally, add a WARN_ON in ext4_destroy_inode() to catch any inode
destroyed with the bit still set. The check is skipped when the
filesystem is in an error or emergency state, as the pending block may
not have been written back in those cases.

Note that EXT4_STATE_DISKSIZE_GROW_PENDING is not set for now, and it
will be set after everthing is done.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 24 +++++++++++++++++++++++-
 fs/ext4/super.c |  8 ++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c81a28b67913..8e8859c8f5b0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -273,6 +273,8 @@ void ext4_evict_inode(struct inode *inode)
 
 	if (ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
+	if (ext4_inode_buffered_iomap(inode))
+		ext4_iomap_clear_disksize_pending(inode);
 	truncate_inode_pages_final(&inode->i_data);
 
 	/*
@@ -4344,8 +4346,17 @@ static void ext4_iomap_discard_folio(struct folio *folio, loff_t pos)
 {
 	struct inode *inode = folio->mapping->host;
 	loff_t length = folio_pos(folio) + folio_size(folio) - pos;
+	loff_t pstart, plen;
 
 	ext4_iomap_punch_delalloc(inode, pos, length, NULL);
+
+	/*
+	 * Clear the disksize-grow-pending state if the zeroed EOF block
+	 * fails to write back and is discarded.
+	 */
+	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
+	if (plen && pos <= pstart && folio_next_pos(folio) >= pstart + plen)
+		ext4_iomap_clear_disksize_pending(inode);
 }
 
 static ssize_t ext4_iomap_writeback_range(struct iomap_writepage_ctx *wpc,
@@ -6765,7 +6776,18 @@ static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
 	start_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
 	ext4_fc_track_range(handle, inode, start_lblk, EXT_MAX_BLOCKS - 1);
 
-	ext4_set_inode_size(inode, newsize);
+	down_write(&EXT4_I(inode)->i_data_sem);
+	/*
+	 * Truncate the zeroed EOF block invalidates the pending disksize
+	 * update, so clear the disksize-grow-pending state.
+	 */
+	if (ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING) &&
+	    (newsize <= EXT4_I(inode)->i_disksize))
+		ext4_iomap_clear_disksize_pending(inode);
+
+	i_size_write(inode, newsize);
+	__ext4_set_i_disksize(inode, newsize);
+	up_write(&EXT4_I(inode)->i_data_sem);
 
 	ret = ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1c2395aa1d53..73735fd336b9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1497,6 +1497,14 @@ static void ext4_destroy_inode(struct inode *inode)
 			 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
 			 inode->i_ino, EXT4_I(inode),
 			 EXT4_I(inode)->i_reserved_data_blocks);
+
+	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
+	    !ext4_emergency_state(inode->i_sb) &&
+	    WARN_ON_ONCE(ext4_test_inode_state(inode,
+				EXT4_STATE_DISKSIZE_GROW_PENDING)))
+		ext4_msg(inode->i_sb, KERN_ERR,
+			 "Inode %llu (%p): EXT4_STATE_DISKSIZE_GROW_PENDING not cleared!",
+			 inode->i_ino, EXT4_I(inode));
 }
 
 static void ext4_shutdown(struct super_block *sb)
-- 
2.52.0

