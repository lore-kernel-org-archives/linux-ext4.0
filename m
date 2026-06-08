Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B13B346E51
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 11:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917128; cv=none; b=PEO8qh/hzX2kpwyY+Kvowu6IKmfHRjxTEzEBsFCo9AWgdhJtxMZqUMorB3q20iBQM2XeEk07AiBPOt8zrmyDNE/wc8+MIY8gcBnlpD6ct9o7n38TuyhKIlkRqLWZIbxrjQLookJiINTX1rBu6IcfmFn3D5apyYjcdo1A6F58kcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917128; c=relaxed/simple;
	bh=QUB+kU6+P/OF1F9JpycIWPIImWii9aPKhLA1Xw15uII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7TVDGm0X1lA6yDctFAiCH4R/MCP2tfScRBKMMGHT0YEm0+VOzVAEbMndmOoz0tiCDMuBcpIRWLB2GBTQ6Kk1UysidbA5N4481B0SquQ4EKGr7npMUti0lXFsAfgf3oUZ5rQq98O1O6R8uhDIOixtizKm3ofJUNlZS/5mSPxonI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vjEfRits; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vjEfRits"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780917123; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=uFbYZD/Q4Y+a1qC46y0RkpiidM1C/uVsZmB4jUt4Fgs=;
	b=vjEfRitsLzYSps9y1b7xhju/jMGQWhN8O/oXyLm0ww/h8DmUuesdKV5tMn0N0lP4KTB8SaadP2PFlyFbg/feYOmCnJzlovyjmiF+Lzfo4fEkT//S7gu/rY4FMf8pF1jUzOmKbuEVgdpneE1e/risgjY0sETJAblfFJGbvXYKnF4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X4Nw8S9_1780917122;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4Nw8S9_1780917122 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 19:12:02 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 2/3] ext4: reduce max cluster size to match documented 256MB limit
Date: Mon,  8 Jun 2026 19:11:49 +0800
Message-ID: <20260608111150.827117-3-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260608111150.827117-1-libaokun@linux.alibaba.com>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mke2fs man page documents:

  Valid cluster-size values are from 2048 to 256M bytes per cluster.

but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
filesystem images to specify cluster sizes up to 1GB.

On 32-bit systems with bigalloc enabled, the consistency check in
ext4_handle_clustersize():

  s_blocks_per_group == s_clusters_per_group * (clustersize / blocksize)

can overflow when the cluster ratio is large enough. Since
s_blocks_per_group is not range-checked in the bigalloc path, the
wrapped product can pass the consistency check, leading to inconsistent
group geometry and potential out-of-bounds block allocation.

Reduce EXT4_MAX_CLUSTER_LOG_SIZE to 28 to match the documented 256MB
limit. With this cap, the maximum product is:

  (blocksize * 8) * (256M / blocksize) = 2^31

which fits safely in a 32-bit unsigned long for all block sizes.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..11e41a864db8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -334,7 +334,7 @@ struct ext4_io_submit {
 #define	EXT4_MAX_BLOCK_SIZE		65536
 #define EXT4_MIN_BLOCK_LOG_SIZE		10
 #define EXT4_MAX_BLOCK_LOG_SIZE		16
-#define EXT4_MAX_CLUSTER_LOG_SIZE	30
+#define EXT4_MAX_CLUSTER_LOG_SIZE	28
 #ifdef __KERNEL__
 # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
-- 
2.43.7

