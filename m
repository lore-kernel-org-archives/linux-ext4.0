Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0831540D59A
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787479; cv=none; b=EKrgNHKs/6Ifvi1wKcVl05/K9bmtepm7P/UA9kpubBctBPTs/RfjqnXSmzfMUdr7cZBClsFb8OXb/xKkfPX82ex9+24FTjukDjjHG3+ZljaoyfkjjncCyPc82UBf0ruqI7h+PySbIBQ7F/Z7YH5m1t0cN14uE0zs99jhXWxrvAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787479; c=relaxed/simple;
	bh=+XlTe81V68Yn4jeT6gbEVMaegynMI4lptSbbiazmqqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ops87yggfPqMI2hrKUEFo0XRDQvkQVjmebgQDYCkU9JE2uRuFUe+k7oA+aud01DORXfiyy5GtlWPa1YyYhIrghiqS7OPyZXkkkS28DfUjQqJ4OTbpziy+53qa4b9GVwewFOUhAcS8oRx1mTiodzgRAtZILULZz5NCPk3WLH2u8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rMTMvCaW; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rMTMvCaW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781787473; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=iXNkZfWCeF5SrPb8ocwZ8qTD9rAyR0Un2ztI8nsgg2Q=;
	b=rMTMvCaWatCyO0qbcMm4lYk7avVhynnNs9HpMi4/5Vg8V3FHowm/w3BMOvCuiL791i4CrX33UgD0IElonittnmN0+UMFtLU2szMC4u+Xq60HBRUQ16boaj0MXfiucWYI0marQi3Wm4fIJGbLd+B5DXGmZb8Q7Hin/1h2xIg0dao=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X575f1Y_1781787472;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X575f1Y_1781787472 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 20:57:53 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v2 3/8] ext4: skip overwrite check for aligned non-extending DIO writes
Date: Thu, 18 Jun 2026 20:57:30 +0800
Message-ID: <20260618125735.4156639-4-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
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
index 9f9bc0b13772..886b73247aab 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -434,16 +434,27 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
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
@@ -454,7 +465,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 	loff_t offset;
 	size_t count;
 	ssize_t ret;
-	bool overwrite, unaligned_io, unwritten;
+	bool overwrite = true, unaligned_io, unwritten = false;
 
 restart:
 	ret = ext4_generic_write_checks(iocb, from);
@@ -466,22 +477,19 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 
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
@@ -496,8 +504,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
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

