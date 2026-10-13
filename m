Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0F347CA69;
	Tue, 13 Oct 2026 06:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872821; cv=none; b=SfNtursIOpyQgQHh+WPIQ+Wq4Ep8rZZxp2+pOIHcGp+AA07nj3eA0aYZc9EcdGLjne1mBuHOms/6hNmhRtQw9E4hV7f5Q55XubAXW49QUypeBT+ReM3R/ByMBJRDiVQ4tlheoSFz6WJFKV0qhxp8U1qftNPc2Nyki3dSCkmtucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872821; c=relaxed/simple;
	bh=gu02VXEztapDsCl0pvT9LyF4xePyLcTzlOcKkRl2Ldw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BVjnQN5Ym8JtvHaQSD3XhyzzEhj/UocxXhh1DBK5gOC6xd8rQZPmtEHRjX2ntdWQQyHr0lXryezxGPlNCIYhWXwwm2ocRIRWCfCE3LAGLSNjSjZHwW5lbv73ED2Q5AyglyVpOQ/ajwxsMXuuRw6mcX/uvZkosiK28R2nTzxYbzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=bBOjrxpa; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="bBOjrxpa"
Received: from localhost (gy-adaptive-ssl-proxy-4-entmail-virt151.gy.ntes [39.144.128.132])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50d4ab5f2;
	Tue, 13 Oct 2026 14:26:51 +0800 (GMT+08:00)
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
Subject: [PATCH 2/3] ext4: check return value of blkdev_issue_flush() when starting a fast commit
Date: Tue, 13 Oct 2026 06:26:17 +0000
Message-Id: <20261013062618.1741670-2-guolingxing@tju.edu.cn>
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
X-HM-Tid: 0aa133f1400603a2kunm9a103e304a958c
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGR0fVksdTR1CSR0eTE5DHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpISVlXWRYaDxIVHRRZQVlPS0hVSktJQk
	NNQlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=bBOjrxpaD25zzwFixD1+z4mo04hCrbUAAqxRKkbnRy8G4VIeLLlEAHXwlFRFNdIuNhCEciQ1JfVpUjckpq5r5ZHJvW6sgutZa/SJAg5im9qyvtdo8mrKj8+asSDGgHz9xUSHh2c8hjsGO4OCXkaKS3hPVapbPZskZjjzVVf790k=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=pmnp5r4dxKCR1gs6pAEYSB7XZoUGEt98RR7AFiIbyD4=;
	h=date:mime-version:subject:message-id:from;

When the file system device differs from the journal device, a cache
flush is issued on the file system device before fast commit blocks
are written, but the return value is ignored.  If the cache flush
fails, the fast commit blocks are written and the fast commit
completes anyway, even though the updates covered by the preceding
transactions may not be on stable storage yet, so the fast commit may
provide guarantees it cannot keep.

Check the return value of blkdev_issue_flush() and abort the fast
commit if the cache flush fails.  ext4_fc_commit() will then fall back
to a full journal commit, so the caller still gets the expected
durability guarantees.

Fixes: da0c5d2695265 ("ext4: issue fsdev cache flush before starting fast commit")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/fast_commit.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..ead8b16f9be0 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1425,8 +1425,11 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 	 * Step 5: If file system device is different from journal device,
 	 * issue a cache flush before we start writing fast commit blocks.
 	 */
-	if (journal->j_fs_dev != journal->j_dev)
-		blkdev_issue_flush(journal->j_fs_dev);
+	if (journal->j_fs_dev != journal->j_dev) {
+		ret = blkdev_issue_flush(journal->j_fs_dev);
+		if (ret)
+			return ret;
+	}
 
 	blk_start_plug(&plug);
 	alloc_ctx = ext4_fc_lock(sb);
-- 
2.34.1

