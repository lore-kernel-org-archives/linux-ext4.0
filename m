Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346AD485518;
	Tue, 13 Oct 2026 06:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872819; cv=none; b=uMvzIAL0ZJaDTF3I4Mp3tGLCPEOlkGABdcIkz6Cu7gdfDx7hvn+AibEX1FIHec2Ird9/Z/Sm/EsiGHkjFvU9jtyZrBS6rVmxaajfKv2HKo8NdSI5bf1DFbyzHy/mpr+FF6t0VglO5ixMX/E3jsAStpHErLD9+GVTVC9ETZKxL2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872819; c=relaxed/simple;
	bh=yAh+yFHkbslPzEUHMd8BQYBi9iHfw777faQzRjy0lJI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MS8I/FYWPYWLXRQBw2zvfaOd/3CzClPqDUMLEOuafT6+gp+0bJKuxkSkRbMSfJJwWCIzz5mK0dlJ4m+YmuhyhD+yza3OzSKQ2iLU6jFlQw2sG7Rp0yUytENqBPvJYYYH84EhSqcLKuRrTn3NxwBKrqxhLu5lQOpR4qqkqqhHpoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=BnoKK+M4; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="BnoKK+M4"
Received: from localhost (gy-adaptive-ssl-proxy-3-entmail-virt135.gy.ntes [IPV6:2409:8d28:39:f54:a8d0:6ae:755d:34f6])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50d4ab5eb;
	Tue, 13 Oct 2026 14:26:45 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH 1/3] ext4: check return value of blkdev_issue_flush() when initializing inode tables
Date: Tue, 13 Oct 2026 06:26:16 +0000
Message-Id: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa133f12b6403a2kunmb9a5108c4a9579
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTENJVktJGUpMHxgZGUJJTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSEJBHU5PQRpDH0tBTRoeQUxOTh9BSE8dTV
	lXWRYaDxIVHRRZQVlPS0hVSktJQkNNQlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=BnoKK+M4kEfw19vEq03G1SqpqG/5mL5usHE5VxqzyIg3yiBXoGSZ7CckGAmg5ELbh+UrvS8LS4PSalX5SkKAYA7FAyZiYHXfpiTH5LJHHEd3xJT/SDmdIyTvVVyxBH2ldkOK5HY0AbHwEsTBHlhSxVFbES+diSiSEsURZp+wmQU=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=gR+g88cPM94OUc9N4017YEYSOcGvDnK7C7C0+ASptjE=;
	h=date:mime-version:subject:message-id:from;

When lazily zeroing an inode table, ext4_init_inode_table() issues a
cache flush to make sure the zeroed blocks have reached the disk
before setting the EXT4_BG_INODE_ZEROED flag, but the return value is
ignored.  If the cache flush fails, the inode table is still marked as
initialized, and a subsequent crash can leave the table containing
stale data from the previous use of the disk, which may then be
exposed to user space through newly allocated inodes.

Check the return value of blkdev_issue_flush() and leave
EXT4_BG_INODE_ZEROED unset if the cache flush fails, so that the inode
table zeroing is retried on the next mount.

Fixes: a107e5a3a473a ("Merge branch 'next' into upstream-merge")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/ialloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a5831fc536db..9abd7fb75b02 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1610,8 +1610,11 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 	ret = sb_issue_zeroout(sb, blk, num, GFP_NOFS);
 	if (ret < 0)
 		goto err_out;
-	if (barrier)
-		blkdev_issue_flush(sb->s_bdev);
+	if (barrier) {
+		ret = blkdev_issue_flush(sb->s_bdev);
+		if (ret)
+			goto err_out;
+	}
 
 skip_zeroout:
 	ext4_lock_group(sb, group);
-- 
2.34.1

