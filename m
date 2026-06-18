Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F0840D59A
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787481; cv=none; b=TXyYfWhnDNvbBDia6E7weM5XCmQeRLcsEFIV6Ngk0ztiEnpufQT9iRzYIf6aB9+VXAx0aNOzjNknYrNw93YtyMD+OvMkT706SvsXAJMu9qwqWkjfSKaoflt3sBXpDQ47pVzkj9mESliEbXtqa8RQaAJpzHWx6BJd51joU3QP89E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787481; c=relaxed/simple;
	bh=jY7eYAXGHkO2tITskwLXAriEu+jHxl8H1glLY/cUkuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yfhfn436CB1MBo3+RvthzBNxC7fIaZSRlP3R1BIV3DtgfUdQTpH399eLwLukScmX8SA2SbT/p9e0OnkWO5dEdMxIp3LFpMeqPfHNJSMaVao7d/lmtjv4SJpcj13m7guHzxoZpCSHRfK9mqbQ3YFaXYHNjokLZKm7uUsBevlU2Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QM9hWhcB; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QM9hWhcB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781787471; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=8PzIsobVNIaF1m16DVEvVnQ+fHEZopkPGTQG+EWhJR8=;
	b=QM9hWhcBDD+zzBCTxGQ4FX0LKiinajw7YhUkU38GNelEE1cmycwXQ7etiiHRAuOPEJwB6r0e2U/YH+/w60AlxcsUwUhbIgOztemQES2HSPuiKjtmXAsICY4WlxNJ4sovc/zPZQfa8Rr2/ke2WLKOWqg8SCgvVCdy/ejOTPQyYCM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X575f14_1781787470;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X575f14_1781787470 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 20:57:51 +0800
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
Subject: [PATCH v2 1/8] ext4: prevent sleeping allocation in NOWAIT write path
Date: Thu, 18 Jun 2026 20:57:28 +0800
Message-ID: <20260618125735.4156639-2-libaokun@linux.alibaba.com>
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

Block allocation requires journal access which may sleep, violating
NOWAIT semantics. Return -EAGAIN early when IOMAP_NOWAIT is set,
allowing the caller to retry without the NOWAIT constraint.

This ensures that write paths using IOMAP_NOWAIT (e.g., DIO with
RWF_NOWAIT) will not block on journal operations when blocks need
to be allocated.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611163441.2431805-1-libaokun@linux.alibaba.com?part=1
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

