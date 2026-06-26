Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94263E5A0E
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462940; cv=none; b=ToOPCAmcezE7yhoWzlpGJ4e9CVhqIBorUNNJ5/r2OS2jSyivhuN44+ez5GpIT15PiPPv64OUGv4YZcbeEkSt6YWok0OunvqgX6hfreN4a7nv/S48I4C8F2CTLsSLxko9udxFYGuq6maMztYsc+PRno0AZOsBb6H+yG6t1++MPPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462940; c=relaxed/simple;
	bh=P0qOZP6qlhaHDgDVOI3Lve6Adqc82JA3FxSyKwQRV6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr1whiwUhCxQCrf8LhKcDgz6ZEQ+L3XXXq+A+nhOHpGb1jvBK9mSCnaKvoSBDfaLn7aGlQhmd5Rw5jcshvM73Mjfs3b+ayIFz1tRqJs6wKlPQOMP9lgaIJWzsAI7OMiJW1JDhbBIgN/5kf1V8AopnvSoWK4Gr3PXmQ90eBxs9oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aejR0Vnu; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aejR0Vnu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462934; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=R3iEPNkGzrutdD+McFKciSRaA6GFKouIvrBMNLHmYQ4=;
	b=aejR0VnulhlMUaeA3D2Y+wSwS3IjjL9NOBdtfAwmiQuaJkHeBEUqV8FUISO2Wv4xBXScUfUxaqkqZhpS3MF0ZefQwvGPTRNkcTokk9Lo/Zlk/8cjpoVgJqtxit8GVyFGRv2JN4d367JfGr6UcYpL/d5HY/JFgyZlSlgj9p5AlX8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5e4zjF_1782462933;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4zjF_1782462933 cluster:ay36)
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
Subject: [PATCH v3 6/9] ext4: improve EXT4_GET_BLOCKS_CACHED_NOWAIT handling in ext4_map_blocks
Date: Fri, 26 Jun 2026 16:35:15 +0800
Message-ID: <20260626083518.1064517-7-libaokun@linux.alibaba.com>
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

When EXT4_GET_BLOCKS_CACHED_NOWAIT is set and the extent status cache
hits, ext4_map_blocks() returns immediately without running
check_block_validity(). This allows malicious extents from crafted
filesystem images to bypass validation if they have been cached by a
previous blocking read.

Make three improvements to the EXT4_GET_BLOCKS_CACHED_NOWAIT handling:

1. Change the cache-hit path from "return retval" to "goto found" so
   that check_block_validity() always runs, closing the security bypass.

2. Return -EAGAIN instead of 0 on cache miss to distinguish it from a
   cache hit on a hole or delayed extent (which returns 0). The only
   existing caller (ext4_get_link() -> ext4_getblk() -> ERR_PTR())
   converts both -EAGAIN and 0 to ERR_PTR(-ECHILD), so the end result
   is unchanged.

3. Add WARN_ON_ONCE after the EXT4_GET_BLOCKS_CREATE==0 early return
   to assert that EXT4_GET_BLOCKS_CREATE and EXT4_GET_BLOCKS_CACHED_NOWAIT
   are never combined, since EXT4_GET_BLOCKS_CREATE requires blocking on
   i_data_sem.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 832794294ccf..7f9ae584ad98 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -759,8 +759,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			BUG();
 		}
 
+		/* Skip blocking operations and jump to extent validation. */
 		if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
-			return retval;
+			goto found;
 #ifdef ES_AGGRESSIVE_TEST
 		ext4_map_blocks_es_recheck(handle, inode, map,
 					   &orig_map, flags);
@@ -776,7 +777,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * cannot find extent in the cache.
 	 */
 	if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
-		return 0;
+		return -EAGAIN;
 
 	/*
 	 * Try to see if we can get the block without requesting a new
@@ -797,6 +798,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0)
 		return retval;
 
+	/* EXT4_GET_BLOCKS_CREATE cannot operate in NOWAIT mode */
+	WARN_ON_ONCE(flags & EXT4_GET_BLOCKS_CACHED_NOWAIT);
+
 	/*
 	 * Returns if the blocks have already allocated
 	 *
-- 
2.43.7

