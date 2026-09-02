Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C563E1D05;
	Wed,  2 Sep 2026 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335247; cv=none; b=agLFPmHOhHlj2V6WwdNQ4BuoTfQ6INpL7HvtCZ+tNip9h6l/6UgU4CTOTcQs6Nn+YIXdsIsw+atW8w1JJRPISIeZtWFhdFh44djASxxMFypd45kffyIYRImO+DyTKzZUlAuCobhDUIwfNuWY5gY0DS+Rdff4YFt8boU3B9wIZ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335247; c=relaxed/simple;
	bh=rM/tXGbf1aCcjq5KxywPtk0vBUXFIx2mFpz196P6YbQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lbCjl4KKCH6adeiFDpmSW2eVDakBxQqd3I+O/BJIFgf2lY/XfTnzNyh6ZhCOVl+MdLKJ3LjBDsb4FaavMO0fpJl+VTC/BLebag7OTLXfkxOIewvBGYjBC7nF53x1kkzhQp/OmUPKT1s4VGt+TRq51hoZqnm5B9AgPgrGIDgAYPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=NOgSQT1d; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="NOgSQT1d"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Xr9BLFJfOVdKkYTXuHA//41f3O6Yyk2q7ziikLqqqXw=;
	b=NOgSQT1dlqJaQi9vrvjYnOEf8vsKWa97ntxZrTZMRxiKx0d/nYt5xLqPcABA9lWZ31g/7l5Y1
	+AfGvHDdfxbE8Fgiw6r/ppCN3i8sshYU034KTWamrxz3cwwcpKeTXatkjTKwHhVVwkOK/Im0sjX
	vRXMeKBUnArlIhi7y1g3vL8=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hZZKF42mzzpSvd;
	Wed,  2 Sep 2026 15:36:01 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 38E5940561;
	Wed,  2 Sep 2026 15:47:22 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 2 Sep
 2026 15:47:20 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <bcrl@kvack.org>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<akpm@linux-foundation.org>, <pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <kees@kernel.org>, <tglx@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 6/8] super: Use acquire for SB_BORN check in super_cache_count()
Date: Wed, 2 Sep 2026 15:48:03 +0800
Message-ID: <20260902074805.398540-7-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260902074805.398540-1-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500011.china.huawei.com (7.185.36.131)

The active SB_BORN check in super_cache_count() pairs with the
smp_store_release() in super_wake() when publishing a newly initialized
superblock.

Replace the historical independent smp_rmb() barrier with an acquire load
on sb->s_flags via super_flags(). This expresses the publish-subscribe
pattern more clearly and allows weakly-ordered architectures like arm64
to utilize efficient native instructions (e.g., LDAR) instead of a full
one-way barrier.

Also remove the outdated memory barrier comment in super_cache_count(),
as the underlying super_flags() implementation already self-documents
the matched smp_store_release() in super_wake().

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Assisted-by: Gemini:Gemini-3.1
Assisted-by: DeepSeek:DeepSeek-V3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 05e443173038..caa6189e4057 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -267,12 +267,10 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	 * However, if we are currently mounting the superblock, the underlying
 	 * filesystem might be in a state of partial construction and hence it
 	 * is dangerous to access it.  super_trylock_shared() uses a SB_BORN check
-	 * to avoid this situation, so do the same here. The memory barrier is
-	 * matched with the one in mount_fs() as we don't hold locks here.
+	 * to avoid this situation, so do the same here.
 	 */
-	if (!(sb->s_flags & SB_BORN))
+	if (!super_flags(sb, SB_BORN))
 		return 0;
-	smp_rmb();
 
 	if (sb->s_op && sb->s_op->nr_cached_objects &&
 	    super_fs_objects_eligible(sc))
-- 
2.34.1

