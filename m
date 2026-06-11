Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B36331237
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781195700; cv=none; b=EFbYAu0K7jB2hjhPoUC+xAnDSItcNrpe6LsQZS7H5JVbywv5AKw/ugQrwKx4s5odtrAoX2TcQoYVxoMdaE5YohSdjZVlzbhzZRnS2ZWJR+HvchEb7ZKOLcZSqzDwOgT/8wmG6QB89+JG5OcFduUOfSW7Mz5hp9Y4nCy27KYPcKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781195700; c=relaxed/simple;
	bh=e88UVcuG2nk2jZ9y4Dsp7TPLjqm06liIzk79InCTCdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsLo+6jnw5R/zUP8XRJcIRWz01pCOFRl2I7Vb4w0z0rjDvo27CqIE7sAfSAsbxW70wvloxAGXexHGE5e/MxtpNOM+vv7X/CXe/XBA3kR9oI7A0vIZhHXDwQjoAg6fVcHPVwpfYsAVyZR0Nf+hXcp2USaSnHVJIhAr04LJY10pPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fa6RrUvt; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fa6RrUvt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781195695; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qEIQmivluOajVZnamKUHGBVBrgIoltNkBo12RGthEEo=;
	b=fa6RrUvtpjeWArx5GzMt+abzbR9jkP9FmfMLB7HzkegQCN7KIYiJmmmZLnPiqMqFdgOPpIMG91eHL1Ds/SmJCmNOMBFImxS9T9Hjp8WqDwDyKlW74Ed1Yvi8/ASK2+w1guMnfNeZEpEvzsntjfKwFXNCsBUHk5fkPP4S4GaxADo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X4ebDJi_1781195694;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4ebDJi_1781195694 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 00:34:54 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial block zeroing
Date: Fri, 12 Jun 2026 00:34:41 +0800
Message-ID: <20260611163441.2431805-3-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For unaligned DIO writes, the previous ext4_overwrite_io() required the
entire range to fall within a single written extent.  This was overly
conservative: the DIO layer only performs partial block zeroing for the
head and tail blocks when they are partially covered by the write.
Middle blocks that are fully covered are written as whole blocks
without any zeroing, so they are safe regardless of extent state.

Therefore exclusive lock is only required when partial block zeroing
will actually happen:
 - The head partial block (if any) lands on a hole or unwritten extent.
 - The tail partial block (if any) lands on a hole or unwritten extent.

Middle full-cover blocks can be in any state (hole, unwritten, or
written) - block allocation under shared lock is safe per the previous
patch's analysis (inode_dio_begin + i_data_sem protection).

Replace ext4_overwrite_io() with ext4_dio_needs_zeroing(), which
directly answers the question driving the lock decision.  It uses at
most two ext4_map_blocks() calls: one for the head partial block (also
catching the case where it spans through the tail), and one for the
tail partial block if not already covered.

This enables shared lock for previously-rejected scenarios such as:
 - Unaligned write spanning written extent + mid-range hole + written
   extent at the tail.
 - Unaligned write where the partial blocks land on written extents but
   the middle has unwritten extents.

Performance:

Hardware: /dev/sda (rotational disk, ~1 GB/s sustained write)
Filesystem: ext4 default mkfs

Unaligned DIO writes (14336 bytes at +512 within each 16K stripe).
Each stripe is laid out as [written][unwritten][unwritten][written],
so the head and tail partial blocks land on written extents but the
middle is unwritten.  Metric: IOPS.

  JOBS      Before        After    speedup
  ----    --------    ---------    -------
     1      15,547       17,381      1.12x
     2      15,910       34,172      2.15x
     4      15,014       57,567      3.83x
     8      15,022       81,947      5.46x
    16      14,586       99,126      6.80x
    32      14,047       92,519      6.59x

Wall time at JOBS=32: 149.3s (Before) -> 22.7s (After), 6.58x faster.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 108 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6f3886465ce3..aa926e641739 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -213,31 +213,60 @@ ext4_extending_io(struct inode *inode, loff_t offset, size_t len)
 	return false;
 }
 
-/* Is IO overwriting allocated or initialized blocks? */
-static bool ext4_overwrite_io(struct inode *inode,
-			      loff_t pos, loff_t len, bool *unwritten)
+/*
+ * Does an unaligned DIO write require partial block zeroing?
+ *
+ * Partial block zeroing is performed only for the head and tail blocks
+ * when they are partially covered by the write and the underlying extent
+ * is a hole or unwritten. Middle blocks (fully covered by the write)
+ * are written as whole blocks without zeroing.
+ *
+ * When zeroing is required, two concurrent unaligned DIO writes to the
+ * same partial block can race and corrupt each other's data, so the
+ * caller must take the exclusive i_rwsem and drain in-flight DIO. When
+ * zeroing is not required, shared lock is safe -- block allocation and
+ * unwritten conversion for middle blocks are protected by i_data_sem
+ * and inode_dio_begin().
+ */
+static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
 {
 	struct ext4_map_blocks map;
 	unsigned int blkbits = inode->i_blkbits;
-	int err, blklen;
+	unsigned long blockmask = inode->i_sb->s_blocksize - 1;
+	bool head_partial, tail_partial;
+	ext4_lblk_t head_lblk, tail_lblk;
+	int err;
 
 	if (pos + len > i_size_read(inode))
-		return false;
+		return true;
 
-	map.m_lblk = pos >> blkbits;
-	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
-	blklen = map.m_len;
+	head_partial = (pos & blockmask) != 0;
+	tail_partial = ((pos + len) & blockmask) != 0;
+	head_lblk = pos >> blkbits;
+	tail_lblk = (pos + len - 1) >> blkbits;
+
+	/* Check the head partial block. */
+	if (head_partial) {
+		map.m_lblk = head_lblk;
+		map.m_len = tail_lblk - head_lblk + 1;
+		err = ext4_map_blocks(NULL, inode, &map, 0);
+		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
+			return true;
+		/* If this mapping already covers the tail block, we're done. */
+		if (!tail_partial || map.m_lblk + err > tail_lblk)
+			return false;
+	}
 
-	err = ext4_map_blocks(NULL, inode, &map, 0);
-	if (err != blklen)
-		return false;
-	/*
-	 * 'err==len' means that all of the blocks have been preallocated,
-	 * regardless of whether they have been initialized or not. We need to
-	 * check m_flags to distinguish the unwritten extents.
-	 */
-	*unwritten = !(map.m_flags & EXT4_MAP_MAPPED);
-	return true;
+	/* Check the tail partial block. */
+	if (tail_partial) {
+		map.m_lblk = tail_lblk;
+		map.m_len = 1;
+		err = ext4_map_blocks(NULL, inode, &map, 0);
+		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
+			return true;
+	}
+
+	return false;
 }
 
 static ssize_t ext4_generic_write_checks(struct kiocb *iocb,
@@ -446,9 +475,10 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
  *    i_data_sem serializes concurrent extent tree modifications.
  *
  * 4. Otherwise, the write is unaligned and non-extending. Shared lock is
- *    only safe for pure written-extent overwrites. Unwritten extents or
- *    holes require exclusive lock because concurrent partial block zeroing
- *    in the DIO layer could corrupt data.
+ *    safe unless the DIO layer needs to perform partial block zeroing --
+ *    i.e. the head or tail partial block sits on a hole or unwritten
+ *    extent. In that case upgrade to the exclusive lock and drain
+ *    in-flight DIO to avoid races with concurrent partial block zeroing.
  */
 static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 				     bool *ilock_shared, bool *extend,
@@ -459,7 +489,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 	loff_t offset;
 	size_t count;
 	ssize_t ret;
-	bool overwrite = true, unaligned_io, unwritten = false;
+	bool needs_zeroing = false;
 
 restart:
 	ret = ext4_generic_write_checks(iocb, from);
@@ -469,21 +499,22 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 	offset = iocb->ki_pos;
 	count = ret;
 
-	unaligned_io = ext4_unaligned_io(inode, from, offset);
 	*extend = ext4_extending_io(inode, offset, count);
 
 	/*
-	 * For unaligned writes we need to know the extent state to determine
-	 * whether shared lock is safe. For aligned writes we skip this check
-	 * entirely since allocation under shared lock is safe.
+	 * For unaligned writes, check whether partial block zeroing will be
+	 * needed. If so, exclusive lock is required to serialize against
+	 * concurrent DIO that could race with the zeroing.
+	 *
+	 * For aligned writes we skip this check entirely since allocation
+	 * under shared lock is safe.
 	 */
-	if (unaligned_io)
-		overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
+	if (ext4_unaligned_io(inode, from, offset))
+		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count);
 
 	/* Determine whether we need to upgrade to an exclusive lock. */
 	if (*ilock_shared &&
-	    ((!IS_NOSEC(inode) || *extend ||
-	     (unaligned_io && (!overwrite || unwritten))))) {
+	    (!IS_NOSEC(inode) || *extend || needs_zeroing)) {
 		if (iocb->ki_flags & IOCB_NOWAIT) {
 			ret = -EAGAIN;
 			goto out;
@@ -497,16 +528,23 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 	/*
 	 * Now that locking is settled, determine dio flags and exclusivity
 	 * requirements. We don't use DIO_OVERWRITE_ONLY because we enforce
-	 * behavior already. The inode lock is already held exclusive if the
-	 * write is unaligned non-overwrite or extending, so drain all
-	 * outstanding dio and set the force wait dio flag.
+	 * behavior already. When holding the exclusive lock for a write that
+	 * needs partial block zeroing or is extending the file, we must wait
+	 * for the I/O to complete synchronously:
+	 *
+	 *  - needs_zeroing: drain in-flight DIO whose end_io could race with
+	 *    our partial block zeroing, and force synchronous completion so we
+	 *    don't leave in-flight zeroing bios for the next writer to drain.
+	 *
+	 *  - extend: the caller must update i_disksize after I/O completion,
+	 *    which requires the data to be on disk first.
 	 */
-	if (!*ilock_shared && (unaligned_io || *extend)) {
+	if (!*ilock_shared && (needs_zeroing || *extend)) {
 		if (iocb->ki_flags & IOCB_NOWAIT) {
 			ret = -EAGAIN;
 			goto out;
 		}
-		if (unaligned_io && (!overwrite || unwritten))
+		if (needs_zeroing)
 			inode_dio_wait(inode);
 		*dio_flags = IOMAP_DIO_FORCE_WAIT;
 	}
-- 
2.43.7

