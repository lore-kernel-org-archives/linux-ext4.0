Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D063E3C48
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462941; cv=none; b=RiwRpBPFDcjt0S1b6m5CxiRyg+i2pxIct1s0ULx9/AWiwjIzIug0O0dj6R7pNDVoOCtcVxHGGrX5JTpdea4JBwhlb8fQ6CXGoYlz02sfpJd0UWTQhEo7bi8XEPULjxyWkhiDNTosw5KYRnYnl7yYb14/QzZPh91C/b7VCJGR3v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462941; c=relaxed/simple;
	bh=wJVbAesw2Dplot1s9FzSGEASFqtTeFHe3mSgjwdzL1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcDU8eNSg39SVO6S1pO8KXLW0F2D9BLxKEbtNWlWoMl//lkAqcjYz04BVNvUydDUwgHx3fyjAQdR2ePpjUGZ8HT8iyUhi6iU1mUNeDyklI/akGpaseMhNirnnZMm85TFK7bAG1CO12pVb0ozC5RB3lQNdXoJfVG+DoAAtRVEWxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xrw+U7HL; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xrw+U7HL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462932; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XUp2crXMoL+J4RMQUo8W7K8WmzP2cqN0vwaFsoLbv2Y=;
	b=xrw+U7HLquu6xRnlPWMER9Mfz/GtDGumi56KD66B1V5XL8YdtT6J4g29zf/8eSqWwRHgYN39ueS7mBZghpl8Afffts2NihC824O0qqBKqUDQn+NPiHd46avzlEHdL0B6mmKLbIw25ArfB//OqXFMjRhoW1mDXnfeFqdgLCZMOZs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5e4ziE_1782462931;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4ziE_1782462931 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:31 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v3 3/9] ext4: skip overwrite check for aligned non-extending DIO writes
Date: Fri, 26 Jun 2026 16:35:12 +0800
Message-ID: <20260626083518.1064517-4-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
References: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, ext4_dio_write_checks() calls ext4_overwrite_io() to
determine if a write is a pure overwrite, and upgrades to exclusive
i_rwsem if not. However, ext4_overwrite_io() uses a single
ext4_map_blocks() call which only returns the first contiguous extent of
the same type. A write spanning multiple pre-allocated extents (e.g.
written + unwritten, or two physically discontiguous written extents)
produces a false negative, forcing an unnecessary exclusive lock upgrade.

After commit 5d87c7fca2c1 ("ext4: avoid starting handle when dio
writing an unwritten extent") and commit 012924f0eeef ("ext4: remove
useless ext4_iomap_overwrite_ops"), ext4_iomap_begin()'s fast path
accepts both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN without starting a
journal transaction. The iomap iteration naturally handles multi-extent
ranges: each call returns the mapping for the current segment, and
unwritten-to-written conversion is deferred to ext4_dio_write_end_io().
This means the common case of mixed written/unwritten extents never
reaches ext4_iomap_alloc() at all.

Even for the less common case where the range contains a hole and
ext4_iomap_alloc() is needed, exclusive i_rwsem is still unnecessary for
aligned non-extending writes:

 - truncate/punch_hole are kept out: they require exclusive i_rwsem
   (blocked by our shared lock during allocation), and inode_dio_begin()
   keeps their inode_dio_wait() blocked until in-flight bios complete.
 - i_data_sem write-lock inside ext4_map_blocks() serializes concurrent
   extent tree modifications (parallel writers to the same hole).
 - The journal handle is per-thread and does not require i_rwsem
   exclusion.
 - i_disksize and orphan list are not involved in non-extending writes.

Skip the ext4_overwrite_io() check entirely for aligned writes by
initializing overwrite to true and only calling ext4_overwrite_io() for
unaligned writes. Unaligned writes still need the extent state check
because concurrent partial block zeroing in the DIO layer requires
exclusive serialization unless the range is a pure written-extent
overwrite.

Performance:

Hardware: /dev/sda (rotational disk, ~1 GB/s sustained write)
Filesystem: ext4 default mkfs

Aligned 8K DIO writes spanning written+unwritten extent boundaries.
Each thread writes its own 1G region sequentially; the file is rebuilt
between runs so every block is written exactly once. Metric: IOPS.

  JOBS      Before        After    speedup
  ----    --------    ---------    -------
     1      42,322       43,329      1.02x
     2      68,516       70,677      1.03x
     4      62,489       97,072      1.55x
     8      58,701      110,819      1.89x
    16      58,569      116,392      1.99x
    32      60,860      117,244      1.93x

Wall time at JOBS=32: 69.2s (Before) -> 35.4s (After), 1.96x faster.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 52 +++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 130edf1ac242..7d453d7c003b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -435,16 +435,27 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
  * condition requires an exclusive inode lock. If yes, then we restart the
  * whole operation by releasing the shared lock and acquiring exclusive lock.
  *
- * - For unaligned_io we never take shared lock as it may cause data corruption
- *   when two unaligned IO tries to modify the same block e.g. while zeroing.
+ * The decision is layered, evaluated in this order:
  *
- * - For extending writes case we don't take the shared lock, since it requires
- *   updating inode i_disksize and/or orphan handling with exclusive lock.
+ * 1. If file_modified() needs to update security info (!IS_NOSEC), upgrade
+ *    to the exclusive lock -- the security update itself requires it,
+ *    regardless of whether the write extends the file or is aligned.
  *
- * - shared locking will only be true mostly with overwrites, including
- *   initialized blocks and unwritten blocks.
+ * 2. If the write extends i_size or i_disksize, upgrade to the exclusive
+ *    lock to safely update i_disksize and the orphan list, regardless of
+ *    alignment.
  *
- * - Otherwise we will switch to exclusive i_rwsem lock.
+ * 3. Otherwise, for aligned non-extending writes, shared lock is always
+ *    sufficient regardless of extent state (written, unwritten, or hole).
+ *    truncate/punch_hole cannot run while we hold the shared i_rwsem
+ *    (they need it exclusively); after we release it, inode_dio_begin()
+ *    keeps their inode_dio_wait() blocked until in-flight bios complete.
+ *    i_data_sem serializes concurrent extent tree modifications.
+ *
+ * 4. Otherwise, the write is unaligned and non-extending. Shared lock is
+ *    only safe for pure written-extent overwrites. Unwritten extents or
+ *    holes require exclusive lock because concurrent partial block zeroing
+ *    in the DIO layer could corrupt data.
  */
 static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 				     bool *ilock_shared, bool *extend,
@@ -455,7 +466,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 	loff_t offset;
 	size_t count;
 	ssize_t ret;
-	bool overwrite, unaligned_io, unwritten;
+	bool overwrite = true, unaligned_io, unwritten = false;
 
 restart:
 	ret = ext4_generic_write_checks(iocb, from);
@@ -467,22 +478,19 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 
 	unaligned_io = ext4_unaligned_io(inode, from, offset);
 	*extend = ext4_extending_io(inode, offset, count);
-	overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
 
 	/*
-	 * Determine whether we need to upgrade to an exclusive lock. This is
-	 * required to change security info in file_modified(), for extending
-	 * I/O, any form of non-overwrite I/O, and unaligned I/O to unwritten
-	 * extents (as partial block zeroing may be required).
-	 *
-	 * Note that unaligned writes are allowed under shared lock so long as
-	 * they are pure overwrites. Otherwise, concurrent unaligned writes risk
-	 * data corruption due to partial block zeroing in the dio layer, and so
-	 * the I/O must occur exclusively.
+	 * For unaligned writes we need to know the extent state to determine
+	 * whether shared lock is safe. For aligned writes we skip this check
+	 * entirely since allocation under shared lock is safe.
 	 */
+	if (unaligned_io)
+		overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
+
+	/* Determine whether we need to upgrade to an exclusive lock. */
 	if (*ilock_shared &&
-	    ((!IS_NOSEC(inode) || *extend || !overwrite ||
-	     (unaligned_io && unwritten)))) {
+	    ((!IS_NOSEC(inode) || *extend ||
+	     (unaligned_io && (!overwrite || unwritten))))) {
 		if (iocb->ki_flags & IOCB_NOWAIT) {
 			ret = -EAGAIN;
 			goto out;
@@ -497,8 +505,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 	 * Now that locking is settled, determine dio flags and exclusivity
 	 * requirements. We don't use DIO_OVERWRITE_ONLY because we enforce
 	 * behavior already. The inode lock is already held exclusive if the
-	 * write is non-overwrite or extending, so drain all outstanding dio and
-	 * set the force wait dio flag.
+	 * write is unaligned non-overwrite or extending, so drain all
+	 * outstanding dio and set the force wait dio flag.
 	 */
 	if (!*ilock_shared && (unaligned_io || *extend)) {
 		if (iocb->ki_flags & IOCB_NOWAIT) {
-- 
2.43.7

