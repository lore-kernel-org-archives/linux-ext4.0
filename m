Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14879445AD1;
	Fri,  9 Oct 2026 06:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791527359; cv=none; b=LzY9a0scVXz80rJhB6KN+DH3iFXRZ4hccPEkr9c1SACjPNFSm9bqLOfsnO4TY1jyBiZMH0D04MBv3hyZ0Ne7oE2ak3Bn6q/6uC2mPbOOXnG7iKG/4bLAZ/giK4MfcbnR50Z+RRNR7JVRpnXyuHNMSC0mr7S5I/TNNHeNdiQzQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791527359; c=relaxed/simple;
	bh=jbDaMbj+uM8E622ix4YGf5P9RxGY8cHVi/1EzfYMazw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F/+rkp1h09VcuvCeCecd1Pvpbbc/aYfFOdJqMwkWMWkhNbOJZx5TROZGhkWsQ8rJuD718IX7tFD7NzY2Cvn/VJlDHpxr2h3Znu/B9LA9DATqdD+iT5z/vfe7z/TfBSg03gSlxf/3vXwvr/XccfSwcmDoShZ14XF7fGwDc/C78dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=GZWYx1gL; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="GZWYx1gL"
Received: from openclaw.rd.supcon.com (gy-adaptive-ssl-proxy-4-entmail-virt151.gy.ntes [IPV6:240e:473:fb90:5666:f43a:5390:1dc9:ec21])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50684f5e2;
	Fri, 9 Oct 2026 14:29:08 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH] ext4: fix buffer_head leak in ext4_ind_map_blocks() error path
Date: Fri,  9 Oct 2026 06:28:46 +0000
Message-Id: <20261009062846.327298-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa11f59ea0203a2kunmccc2e4b73c8199
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGh1PVh8fSE4YGENDQk1MQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0seQU9MSEEdGUJLQU5NTU1BHU9IGkFOSEJLQUofGEJBHh
	hJSllXWRYaDxIVHRRZQVlLVUtVS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=GZWYx1gLQbIpK6iZENRqNd3xbLSAcHLW0+BCPtXgJiSnTRPgVaJ6OsFauvN4sDTYQkRjiIC5Ygjt7XuHOd3YNzq9Hgmxq1VjxKjDe7H8MTGgOXwEXkdDV5WpJXsByzrfLlxCxnJWab5k4WjXbcI6LPz4P34J31jKXpKb7Fu6fTw=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=KrOrjVfG6ht8nuaubDNQ/L4RwWwsBJoMYsm3L5JAqtI=;
	h=date:mime-version:subject:message-id:from;

When ext4_ind_map_blocks() is called with EXT4_GET_BLOCKS_CREATE on
a non-extent mapped inode of a filesystem with the bigalloc feature
enabled, it fails with -EFSCORRUPTED via 'goto out'.  However, at
this point ext4_get_branch() has already acquired buffer_head
references for the chain of indirect blocks, which are stored in
the stack variable 'chain'.  Since 'goto out' skips the cleanup
loop that releases these references, they are leaked permanently
(each failed allocation can leak up to 3 buffer_heads, and repeated
allocation attempts keep pinning the corresponding pages in memory).

Jump to 'cleanup' instead, so that the chain of buffer_heads is
properly released before the error is returned.

Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/indirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 5aec759eed70..9f1f4e6c37a4 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -603,7 +603,7 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 		EXT4_ERROR_INODE(inode, "Can't allocate blocks for "
 				 "non-extent mapped inodes with bigalloc");
 		err = -EFSCORRUPTED;
-		goto out;
+		goto cleanup;
 	}
 
 	/* Set up for the direct block allocation */
-- 
2.34.1

