Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E33F4DE6
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787487; cv=none; b=adFW6wsm4sf2sIqGBJUNRea7t24wUYvBDvle5FLG/SUwxawwdtoypbpQKWraYJr5cFr3REEEP3gxr95Fj6815LM8j9ivXS+Fj9ZhxfV6COGnUq9nFsXHO7QRezu1el/q0BvW+eERZJeGBEXYxQ17f7SbdyxpSDZkTWJalD3Y8rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787487; c=relaxed/simple;
	bh=xnM+RTYGakAvLXqjTq1skOkyoJQcU8toxw0tXxPL3f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYNAqWCx9c1seAa9ZeUYx2J6/jTAUvFaO9LEugnAhHxUB9n7Y2pcrdyJqT4NGW2x20rEdUGPiKPad7/i8lLZXEKVDuMEWTDYeITMzWD71G9eLEf/YztnxVhSXarRIDu0gUpoNkJ30kknaWdRNWSPYKrJVgH+wyhrQmZHnUAHqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jyNe2JJ+; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jyNe2JJ+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781787477; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qCTgE6b32ab8Yspn9FTQpVk7t9wsUd2ROh+hJbRBOYc=;
	b=jyNe2JJ+lOqch2efyaYXSNUqe7P2PUyOo66fuVsg5rZqMNMJlEEgId3uB70EHaHdDceOmU0VU7b5bQivGrI8dv2NaPi4mq4ZeldYcfQu9mgIpIl7lTk6w4UvZNr47ZeofRG1pyzkuUKcmPq7+w7VkVqpz/CCnxBWEYa7ykuyDzQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X575f2Y_1781787475;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X575f2Y_1781787475 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 20:57:56 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v2 7/8] ext4: handle IOMAP_NOWAIT in ext4_iomap_begin() with cache-only lookup
Date: Thu, 18 Jun 2026 20:57:34 +0800
Message-ID: <20260618125735.4156639-8-libaokun@linux.alibaba.com>
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

Pass EXT4_GET_BLOCKS_CACHED_NOWAIT flag to ext4_map_blocks() when
IOMAP_NOWAIT is set, ensuring that extent lookups only use the cached
extent status tree. If the cache misses, ext4_map_blocks() returns
-EAGAIN instead of sleeping on down_read(i_data_sem) to read extent
tree from disk.

This applies to both write and read paths in ext4_iomap_begin(),
allowing DIO/DAX operations with RWF_NOWAIT to avoid blocking on
extent tree lookups.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 03adbca3ec78..09f85cd6c118 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3781,6 +3781,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	struct ext4_map_blocks map;
 	u8 blkbits = inode->i_blkbits;
 	unsigned int orig_mlen;
+	int map_flags = 0;
 
 	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
@@ -3795,6 +3796,12 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	map.m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
 			  EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
 	orig_mlen = map.m_len;
+	/*
+	 * In NOWAIT context, only use cached extent info. If es cache misses,
+	 * return -EAGAIN to avoid sleeping on down_read(i_data_sem).
+	 */
+	if (flags & IOMAP_NOWAIT)
+		map_flags = EXT4_GET_BLOCKS_CACHED_NOWAIT;
 
 	if (flags & IOMAP_WRITE) {
 		/*
@@ -3804,7 +3811,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		 * especially in multi-threaded overwrite requests.
 		 */
 		if (offset + length <= i_size_read(inode)) {
-			ret = ext4_map_blocks(NULL, inode, &map, 0);
+			ret = ext4_map_blocks(NULL, inode, &map, map_flags);
 			/*
 			 * For DAX we convert extents to initialized ones before
 			 * copying the data, otherwise we do it after I/O so
@@ -3825,7 +3832,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		}
 		ret = ext4_iomap_alloc(inode, &map, flags);
 	} else {
-		ret = ext4_map_blocks(NULL, inode, &map, 0);
+		ret = ext4_map_blocks(NULL, inode, &map, map_flags);
 	}
 
 	if (ret < 0)
-- 
2.43.7

