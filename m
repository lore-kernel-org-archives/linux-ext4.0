Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CB13E5A0F
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462940; cv=none; b=EyQE17gJdHOYj3iE1le1PQAN2JlK0aKmYWgdSG675a6AKHcrq9+41+Y6E9IKGKQiSUBKyWNs3Vegm6hWovwEyvBUTFNBuXPwJvG0oRztLxWgqLf4m3O6xpNKf9aA5r9TGin565moMsiGwhqmLBfIi5u0cXDGgMzq5fQ6mYBiT8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462940; c=relaxed/simple;
	bh=JgVwqTaJeuN++lETybaNQiWgLOwyF3JxKcGV5VJAU1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSwNDlYuPHlYLNTrNkIbxfPLJjMPipDoRUAM23AWLOOLG2S9P3V56SVTl9q7q04E4CC5SYkXw5ToasM70zhmGrpML/HnSYqy2p8ZcILiWua+/ss0pUEwiUrpYL6FTdUbCqwNogd5UMswhtP8HKQW8gLvO6z0wEHbiDPPSMU4C60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BzefUBL8; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BzefUBL8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462930; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=1n/LFlgTw/OD9dtJmCW9qyXr5tmBKXb29pWHGv2KQrA=;
	b=BzefUBL8dJpPHgYb+Gma5HMslbv1lC4ujRIfdaVUEe2CasabOaeVm+QK+5+qhyTbZJyla3d46gcE3OQO7ylT1zilqob5fLRo+DeiAetEZEpwI/SS/DzFUEZfqSYxflPNxanOcx2jqjmUvqeA2RzyqqCUTKdPOTsDys9kYjUlgCA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X5e4zhj_1782462929;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4zhj_1782462929 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:30 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 1/9] ext4: prevent sleeping allocation in NOWAIT write path
Date: Fri, 26 Jun 2026 16:35:10 +0800
Message-ID: <20260626083518.1064517-2-libaokun@linux.alibaba.com>
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

Block allocation requires journal access which may sleep, violating
NOWAIT semantics. Return -EAGAIN early when IOMAP_NOWAIT is set,
allowing the caller to retry without the NOWAIT constraint.

This ensures that write paths using IOMAP_NOWAIT (e.g., DIO with
RWF_NOWAIT) will not block on journal operations when blocks need
to be allocated.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611163441.2431805-1-libaokun@linux.alibaba.com?part=1
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..832794294ccf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3672,6 +3672,9 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 	int ret, dio_credits, m_flags = 0, retries = 0;
 	bool force_commit = false;
 
+	if (flags & IOMAP_NOWAIT)
+		return -EAGAIN;
+
 	/*
 	 * Trim the mapping request to the maximum value that we can map at
 	 * once for direct I/O.
-- 
2.43.7

