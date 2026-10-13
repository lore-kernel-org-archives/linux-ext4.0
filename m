Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30FA4B04A5;
	Tue, 13 Oct 2026 06:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872825; cv=none; b=rrVL2hEif763np2cRX8gZtaeu5M3UgzIZZ0uNMX4mNlmbNKzd6txLjkOAsakWLF7KDMBaJtEUnAT/kD0v/nt7qhcuk6/rtAA5IyNJ/dAU/liSchHfvy1HHrmGb5V+iMMsGdML39ElHFMZ4i/XyHQdNk67cNIN6KYM+ihl6oqRaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872825; c=relaxed/simple;
	bh=PLMTjdpTRR7dXWKVFB6R1lmLronijpQC1Ak3MNcThX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BlcFZi8zEKZjtRiuLgWPoQOXIKoHVvjdgr3LlVTzbsDkGIY7fIHiDxBSyVC4wZiRqiZJ5xb6/Ty6vACKWRXBfGy0zWZqc3cn/1HV/5mGvh9PrrtTezB73g4g9YSECVS44XRz/k3jM+PpMGzi2dIOg2IpNvDMNv5KrfsqKqSVtpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=d05zacp4; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="d05zacp4"
Received: from localhost (gy-adaptive-ssl-proxy-4-entmail-virt151.gy.ntes [IPV6:2409:8d28:39:f54:a8d0:6ae:755d:34f6])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50d4ab5fd;
	Tue, 13 Oct 2026 14:26:56 +0800 (GMT+08:00)
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
Subject: [PATCH 3/3] ext4: check return value of blkdev_issue_flush() when replaying fast commits
Date: Tue, 13 Oct 2026 06:26:18 +0000
Message-Id: <20261013062618.1741670-3-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa133f154da03a2kunm6f2d423a4a95a3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGBhDVh5JTEkfS08YHUhCGlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSEJBHU5PQRpDH0tBTRoeQUxOTh9BSE8dTV
	lXWRYaDxIVHRRZQVlPS0hVSktJQkNNQlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=d05zacp4LkcIpqRxjJtOir/bHEIPmq2AvtGOLKGtI2UFWjOKL/s1qZS/zUZ+c7pZrGJdmvPdAjIIOkFGNRZmwY+IWZgBfqG1o9RfN10PaqMo9XRMQbNcgLmCEEbgmG5WOmahbbPJMtpT5eKD6ANoD9EQ3LLVTN975SEZb5QL1eY=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=ZVnlfFMJpSzHTrUQJyetICb8UH4vltaTrahoAkGoHas=;
	h=date:mime-version:subject:message-id:from;

ext4_fc_replay_inode() writes the replayed inode to disk and then
issues a cache flush, but the return value is ignored.  If the cache
flush fails, the fast commit replay continues and the mount may
succeed, even though the replayed inode contents are not guaranteed to
be on stable storage yet.

Check the return value of blkdev_issue_flush() and abort the fast
commit replay if the cache flush fails, like any other error detected
while replaying the inode.  This causes the mount to fail instead of
silently succeeding with potentially unreplayed data.

Fixes: 8016e29f4362e ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/fast_commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index ead8b16f9be0..f554405ebabf 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2019,7 +2019,7 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 out:
 	iput(inode);
 	if (!ret)
-		blkdev_issue_flush(sb->s_bdev);
+		ret = blkdev_issue_flush(sb->s_bdev);
 
 	return ret;
 }
-- 
2.34.1

