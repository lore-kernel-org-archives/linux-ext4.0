Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A41318B96
	for <linux-ext4@vger.kernel.org>; Sun,  7 Jun 2026 12:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780836601; cv=none; b=EaHJiNybaDkDyQx82ShIQG3+EHMfpRGeoxHL0BFR5nUbxOf+yDh/Ve2HJnDmmJB7buUxZBau4pISaBGt2von0cpK+ity1QDFl0qT6OM8+TBiDAxfQLRFPNWkVCvMm4jdQnNrGB4IF142kFvGccV/N3cdiJI8JOAc6wDrihVGUk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780836601; c=relaxed/simple;
	bh=yaRDr04kovw9TT6iEUOEMPFvJBnRLSUYwG4qqhFVspk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NrzwVQG3bkvimbea+EUGjGEKQAbZNNEmlRrfNqKcZDzK/CYAHdf/E6/EMCozBWN/oZldqk8kdnzuBbLWoBfVPXP22A8TLuEJkAGVHpLoCFYh88G3yKNbl7QbiRRmpwXokI/cDSwHqLSNVTjaxD/f1DP96gltFk0MR7dXtzMKafE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MKeSdCq6; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MKeSdCq6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780836590; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jd9RSIi0Mu4RK2jKPaJG7C+MIBpvt8J/hm9ZJi5xFZs=;
	b=MKeSdCq6iv2ezVF+Q9tDgeWhG4C6DxwIebmK7CQkD1fsIJBmJB2hiThGea8j2F6Pbv1F+rVjBMK4oCUf82Zk6h8wF7DBVrfhMv+l6uXL8kMlYsiNVSUHpMbUKWbj0+cHim9XEfa+SXxxuxIImrHg2rXe5jsc4TUCOfcuMyUnQ5I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X4Hu-bq_1780836588;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0X4Hu-bq_1780836588 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 07 Jun 2026 20:49:49 +0800
From: Peng Wang <peng_wang@linux.alibaba.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	inux-kernel@vger.kernel.org,
	Peng Wang <peng_wang@linux.alibaba.com>
Subject: [RFC PATCH] ext4: fix false-negative overwrite check for DIO spanning extent boundaries
Date: Sun,  7 Jun 2026 20:49:35 +0800
Message-ID: <20260607124935.6168-1-peng_wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_overwrite_io() decides whether a direct I/O write is an overwrite
(all target blocks already allocated) so the write can proceed under a
shared inode lock.  It calls ext4_map_blocks() once and returns false
if the mapped length is shorter than the requested length.

ext4_map_blocks() maps at most one extent per call.  When a write
straddles two extents (e.g. a written extent and an adjacent unwritten
extent created by fallocate), the single call returns only the first
extent's length.  ext4_overwrite_io() then mis-classifies the write as
non-overwrite and forces the caller to cycle i_rwsem from shared to
exclusive.

On workloads where a DIO writer appends through a fallocated region
while a DIO reader tails the same file, every write that crosses a
written/unwritten extent boundary triggers an exclusive lock
acquisition.  The writer must wait for the reader's shared lock to be
released, and while waiting the RWSEM_FLAG_WAITERS bit blocks all
other shared acquirers.  This serialises all writers to queue-depth 1
and throughput collapses.

Fix by looping ext4_map_blocks() over the remaining range.  As long as
every queried extent reports allocated blocks (written or unwritten),
the function returns true and the write keeps the shared lock.

The *unwritten output now uses OR semantics across extents: set if any
block in the range is unwritten.  This is correct for the two callers:

 - (unaligned_io && unwritten) takes the exclusive lock, which is
   needed if any block requires partial-block zeroing.
 - (ilock_shared && !unwritten) selects ext4_iomap_overwrite_ops,
   which skips journal transactions and is only safe when every block
   is written/mapped.

The loop adds at most one extra ext4_map_blocks() call per extent
boundary, which is negligible compared to the lock contention it
eliminates.

Reproducer: two threads doing O_DIRECT I/O on a fallocated ext4 file.
Thread 1 appends sequentially in 4-16 KB writes.  Thread 2 reads from
the tail of the file in up to 1 MB reads.  Both use the same fd with
the file preallocated via posix_fallocate().

Tested on ext4 over NVMe, 6.6 based kernel:

                              before          after
  writer-only throughput:     399 MB/s        412 MB/s
  mixed (writer + reader):     11 MB/s        381 MB/s
  write latency (mixed):     880 us            21 us
  rwsem_down_write_slowpath
   (5 s sample, mixed):       1792              2

Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
---
 fs/ext4/file.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index eb1a323962b1..d060de8eddac 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -228,15 +228,22 @@ static bool ext4_overwrite_io(struct inode *inode,
 	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
 	blklen = map.m_len;
 
-	err = ext4_map_blocks(NULL, inode, &map, 0);
-	if (err != blklen)
-		return false;
-	/*
-	 * 'err==len' means that all of the blocks have been preallocated,
-	 * regardless of whether they have been initialized or not. We need to
-	 * check m_flags to distinguish the unwritten extents.
-	 */
-	*unwritten = !(map.m_flags & EXT4_MAP_MAPPED);
+	*unwritten = false;
+
+	while (blklen > 0) {
+		map.m_len = blklen;
+		err = ext4_map_blocks(NULL, inode, &map, 0);
+		/*
+		 * err <= 0 means a hole or error; the write needs block
+		 * allocation so it cannot be treated as an overwrite.
+		 */
+		if (err <= 0)
+			return false;
+		if (!(map.m_flags & EXT4_MAP_MAPPED))
+			*unwritten = true;
+		blklen -= err;
+		map.m_lblk += err;
+	}
 	return true;
 }
 
-- 
2.43.0

