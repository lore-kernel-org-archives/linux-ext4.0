Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684383F5BCF
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787490; cv=none; b=HnXPFoK1Aj+9l+YaCFOlGiR9bcT8Fu5DhaRtG1Xs/ZI746Ii87hNKkU0SAYlJRQnsA2evbcS7CC24lWy6SmAlap8wyAOs4ArJ0ga+zdw8LnPdMB3+QkRkK82j9gcbA2bYzZ0xxMg99PqnpPC3lV/QSo9uYfcvWX6mtDHTxi9hg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787490; c=relaxed/simple;
	bh=X9Kuuf5ahC5rM5Ht/Bt3Z319F1h5cvIlwVUAJTUCOqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8Rb895cg0MJKwItiS0pzk8hpQ6VEHxXUGeznEOwAUd7LDxtW35j/wqeRkILget4deO+K2UpSRuHm1kwpSI05uO/GsIFQ4EbqpqB58FF37jdq7YMjhbB8Xw0ieBo2zQpIekOMRb38kYtXOgAqryIQiN1lmi8OlOVsWmk/vtsPNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gakecyWl; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gakecyWl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781787478; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=F7SN1P1d0TG71H4fVBc3VBClA+AxCvSjPFzX5xG7xag=;
	b=gakecyWl10u4xUqUDvmuOpj8ISEw8lVD6scvH0BazePWmLFsvZYpFCaQnEERHXI18gV4mKNQoNBpiUFN049MgypyHc3027OszTPkg7DhvmdfbFxIlFRvGpzMWYD0CIp25FWnUI1H07I1PiVAe9qYCrmiSw/nvY3hUT/UH2YwCBI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X575f2r_1781787476;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X575f2r_1781787476 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 20:57:57 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v2 8/8] ext4: handle IOCB_NOWAIT in ext4_dio_needs_zeroing() with cache-only lookup
Date: Thu, 18 Jun 2026 20:57:35 +0800
Message-ID: <20260618125735.4156639-9-libaokun@linux.alibaba.com>
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

Add a nowait parameter to ext4_dio_needs_zeroing() and pass
EXT4_GET_BLOCKS_CACHED_NOWAIT flag to ext4_map_blocks() when
IOCB_NOWAIT is set. This ensures the needs_zeroing check only uses
cached extent info. If cache misses, ext4_map_blocks() returns
-EAGAIN, causing ext4_dio_needs_zeroing() to conservatively return
true (needs zeroing). The caller then tries to upgrade to exclusive
lock, which returns -EAGAIN for NOWAIT, avoiding potential sleep on
down_read(i_data_sem).

The caller in ext4_dio_write_checks() is updated to pass the
IOCB_NOWAIT flag from the kiocb.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5ffc1afd8050..44d1658d2b5a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -228,7 +228,8 @@ ext4_extending_io(struct inode *inode, loff_t offset, size_t len)
  * unwritten conversion for middle blocks are protected by i_data_sem
  * and inode_dio_begin().
  */
-static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
+static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len,
+				   bool nowait)
 {
 	struct ext4_map_blocks map;
 	unsigned int blkbits = inode->i_blkbits;
@@ -236,10 +237,14 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
 	bool head_partial, tail_partial;
 	ext4_lblk_t head_lblk, tail_lblk;
 	int err;
+	int map_flags = 0;
 
 	if (pos + len > i_size_read(inode))
 		return true;
 
+	if (nowait)
+		map_flags = EXT4_GET_BLOCKS_CACHED_NOWAIT;
+
 	head_partial = (pos & blockmask) != 0;
 	tail_partial = ((pos + len) & blockmask) != 0;
 	head_lblk = pos >> blkbits;
@@ -249,7 +254,7 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
 	if (head_partial) {
 		map.m_lblk = head_lblk;
 		map.m_len = tail_lblk - head_lblk + 1;
-		err = ext4_map_blocks(NULL, inode, &map, 0);
+		err = ext4_map_blocks(NULL, inode, &map, map_flags);
 		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
 			return true;
 		/* If this mapping already covers the tail block, we're done. */
@@ -261,7 +266,7 @@ static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
 	if (tail_partial) {
 		map.m_lblk = tail_lblk;
 		map.m_len = 1;
-		err = ext4_map_blocks(NULL, inode, &map, 0);
+		err = ext4_map_blocks(NULL, inode, &map, map_flags);
 		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
 			return true;
 	}
@@ -516,7 +521,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 	 * under shared lock is safe.
 	 */
 	if (ext4_unaligned_io(inode, from, offset))
-		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count);
+		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count,
+						iocb->ki_flags & IOCB_NOWAIT);
 
 	/* Determine whether we need to upgrade to an exclusive lock. */
 	if (*ilock_shared &&
-- 
2.43.7

