Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA003E5A03
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462940; cv=none; b=Kj+acwpFWuQApN+Vz0x4f/Y1kHtDz4cNqcieQzgH/rfJ4TyQmDH91EGEBspkjpN2Qb/Tx1Yc/VmFXMqxGIBNgzcI4sYpHQfnH/QaQd/oiHRtxO3kE30fQNjDSel+FMCafqLQy7/+WThJgF6nBMZLFl7bOKB5nwb6LX7ZXu2iYLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462940; c=relaxed/simple;
	bh=dT4G6h9UlVfmz1f1zCIzZ8GmQmzSSqwdzUcAoOUfzOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rde6GHcpD2o4HNvvoSM5llrpK71ksAXmZUgv/5UTPsNwE4pAvnkQ4Br3tg9D8C6SdKtE6EKyIKwlRxvvbF7+KUDGffbWxUpHumxPTExBQlLiaTODSIAEjd2NJ0HNtLUyFh427PVYmCg/EMKYipZ32ANFE3EcMdFWptVxBx0xwGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dXrS6Q1K; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dXrS6Q1K"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462936; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WC7kQqp+MzBwm1AHUR4tI60tjNa+UN2pRvGQCVNE5a8=;
	b=dXrS6Q1Ktw4pOrkRBLv0+HFJ9KrOXdD5M8nXujLlckSLVWssymebHgrX4Z/0KDeBOhTXYWW4GIQtvawjA0N/ac8Mt1Xfpgz/88WhOn4Wyh7pyxxJtItmYnyXagGNNYN17Fg2zk2jknfa1gyMx/phvTItOYBO1L90YhqEJOKCROA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5e4zk1_1782462935;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4zk1_1782462935 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:35 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v3 8/9] ext4: handle IOCB_NOWAIT in ext4_dio_needs_zeroing() with cache-only lookup
Date: Fri, 26 Jun 2026 16:35:17 +0800
Message-ID: <20260626083518.1064517-9-libaokun@linux.alibaba.com>
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

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0e9448a110dc..49074cc13751 100644
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
@@ -517,7 +522,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
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

