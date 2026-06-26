Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6653E5588
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462940; cv=none; b=IQhsMWovf0fFoD5YZFPciXWMxMRm5PaFfH9IsVgBgGG+MMqmJezgEKoQ9iYVR885as9x1rtyQRNsivX1D7TY/lhvr5ocHE63wTM/sXHM9WVKQAXK2KasYsV/4JOwaOyK5/9CxkWzWBa9htN6abJTV0WopOkYtv5MYbwD7KVOGCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462940; c=relaxed/simple;
	bh=wO0HjMPc/Cu4vXmIsMuU3EgVUaP83vhjgCLv9JNQWY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQvL1qx8u6QVC4xW4f4cYZNP7YHRlYXsyJQLzzKzWsDgz5c3YtP7WQOEyMca25zpPdvjCNVDvbDcdF3JGzbUV8GwqVvS87+USK7lJkbpxQSZRt4t04MEPyqBIDsP65YGiLzF8XU3JvZY8MC8E642G5BBiR7CdS1zSwjZTg+SxVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KJK+jcIC; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KJK+jcIC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462935; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=OFYcp8E7awCjZQYw/J6KuCeZm38i2mdRiU4amqwms9A=;
	b=KJK+jcICifQcEkrziSQQP5yKfpMoknyzuQW4DmcawWryNaq4Kniy9s8HTHEH0qvf7N9j4j18v7VaO+iht9/fH2MmfXSlrOOp8Qq7CIVhYuXG7mNVxBaOynJGqdFLHBosgOM/jT7rfD02YphetGLKpxmnNYnjVUA5p1HIWhS1eHA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5e4zjb_1782462934;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4zjb_1782462934 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:34 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v3 7/9] ext4: handle IOMAP_NOWAIT in ext4_iomap_begin() with cache-only lookup
Date: Fri, 26 Jun 2026 16:35:16 +0800
Message-ID: <20260626083518.1064517-8-libaokun@linux.alibaba.com>
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

Pass EXT4_GET_BLOCKS_CACHED_NOWAIT flag to ext4_map_blocks() when
IOMAP_NOWAIT is set, ensuring that extent lookups only use the cached
extent status tree. If the cache misses, ext4_map_blocks() returns
-EAGAIN instead of sleeping on down_read(i_data_sem) to read extent
tree from disk.

This applies to both write and read paths in ext4_iomap_begin(),
allowing DIO/DAX operations with RWF_NOWAIT to avoid blocking on
extent tree lookups.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7f9ae584ad98..3c05094475db 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3784,6 +3784,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	struct ext4_map_blocks map;
 	u8 blkbits = inode->i_blkbits;
 	unsigned int orig_mlen;
+	int map_flags = 0;
 
 	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
@@ -3798,6 +3799,12 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
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
@@ -3807,7 +3814,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		 * especially in multi-threaded overwrite requests.
 		 */
 		if (offset + length <= i_size_read(inode)) {
-			ret = ext4_map_blocks(NULL, inode, &map, 0);
+			ret = ext4_map_blocks(NULL, inode, &map, map_flags);
 			/*
 			 * For DAX we convert extents to initialized ones before
 			 * copying the data, otherwise we do it after I/O so
@@ -3828,7 +3835,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		}
 		ret = ext4_iomap_alloc(inode, &map, flags);
 	} else {
-		ret = ext4_map_blocks(NULL, inode, &map, 0);
+		ret = ext4_map_blocks(NULL, inode, &map, map_flags);
 	}
 
 	if (ret < 0)
-- 
2.43.7

