Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30302EA75E
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787487; cv=none; b=sjtljKYpMD2SJ/l4NMfsBNCuFlFxG4iiuWGy06mZ+tksnHGu3WY1GwjcT8dRNX1RZ3Bcrw9eRZKDx56WC4UnJdRtQjoHrL3xmFb8mFUqoIw57HTKI2WSAh/kCarj94bPEQ6DZLp25QgCSjwkFroTpLPkU1K88odvcmxBd0x+if8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787487; c=relaxed/simple;
	bh=w8JLSZHS89WPpcR1qYPc7cy2CSYrAg+fci3jkJdUmyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egPLFWqjRDGlaVAnQxpHeo5eW1bPMSmB8ZEvd2d/Mn1SDL4x3pUOZbKU3cuih/7JAWYYbEz6wn89vSIPtmuP5ASm2KJX7O0jMUEI5RxqOParju+Dh5fnhNVT9M3zj8VvGkEsO4NZ7hAh45sNPq+5VpWKULBUZjblqROrgwFxGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cnLdTAs+; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cnLdTAs+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781787476; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=NaV14lUj5MTUp1BM/THdCgFkLMtNRwOtmVnGGle5vT0=;
	b=cnLdTAs+pX1cc+ruZokzwd8V91JLTjTUkE0qoRrDK5tqYGfgMX31gE/b8Zhl/1qlAAtOt7XZdu2Ee1o2VVxPnepQFN+K/hMu7IuN5Xrmb2ah/HRBO+gJZXkhSEE6bhW3OvZKW2OskMRIZ+qIDRXy57VPpQMsw3PwlywMWyr0WwQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X575f2N_1781787475;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X575f2N_1781787475 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 20:57:55 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v2 6/8] ext4: return -EAGAIN from ext4_map_blocks() in NOWAIT cache miss
Date: Thu, 18 Jun 2026 20:57:33 +0800
Message-ID: <20260618125735.4156639-7-libaokun@linux.alibaba.com>
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

Make ext4_map_blocks() return -EAGAIN instead of 0 when
EXT4_GET_BLOCKS_CACHED_NOWAIT is set and the extent status cache
misses. This allows callers to easily distinguish between a successful
cache lookup (positive return value) and a cache miss requiring disk
access (-EAGAIN), simplifying error handling in NOWAIT paths.

The change affects two locations:
1. After cache hit: return retval ? retval : -EAGAIN
   (return -EAGAIN if cache hit is hole/delayed)
2. After cache miss: return -EAGAIN
   (instead of 0, indicating need for disk lookup)

The only existing caller using EXT4_GET_BLOCKS_CACHED_NOWAIT is the
ext4_get_link() -> ext4_getblk() path. Although ext4_getblk() now
takes a different return branch (err < 0 instead of err == 0) and
propagates -EAGAIN instead of NULL, ext4_get_link() converts both
cases to -ECHILD via IS_ERR_OR_NULL(), so the final error seen by
the VFS remains unchanged.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 832794294ccf..03adbca3ec78 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -760,7 +760,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		}
 
 		if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
-			return retval;
+			return retval ? retval : -EAGAIN;
+
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
-- 
2.43.7

