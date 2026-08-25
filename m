Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C23F58F7;
	Tue, 25 Aug 2026 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651644; cv=none; b=n7vuBlx1wcUMSpye+gvNyACKa536C2QaNPviuzV8X43Gq6WcmjGjC99uWfRpIqFAIaXjJYVhv6/3oKcD0Hye4pgtXVX+gY7HTIbtyhywqQb05I4BXr9n3q471twXQhJYcP8y7UAcP9ontDQ90jBLO8PJHlobbZVZwdN4OfEWmGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651644; c=relaxed/simple;
	bh=9VX9tNxmeiNKMUZmwh7YDzBNqN4eQ+31Q0u7K6Vy2wA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZixBKVMOsz9icVS3QlO8TVx21MdUC/LGliUKFqsTrfCB+0vivjT5VfsKORRtRQw9+GvdaxeffSqO64yulKIJ7O030vDP5ZzWUMWzqnIlZHUBEkMB3AywAQ9GeOfg8cbzASRHm4ms51SIxN5OGSMMq1tSYkBqYZyd4ju3EvaEWuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gIdVxCQH; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gIdVxCQH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8sPKKDcZB2un5eRi6hOumnki0mdxkjaC8IL+SruPwMw=;
	b=gIdVxCQHr5Il4Bx2DPju27DKp6wMWMKNbSmPAhbOEVnUhFaoiGOBw4y5me6l9kZ2Jam81LP4t
	AJewY0GkDv33/SgEEGSoLQ/5Q0LL5JX4tMDbGqdxalHUXQE//+MZ/LGNubcYMnwFoMQpywZdgIW
	7LlDiiS1v1tXSErIckpJImQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWb2MY6z1K9BV;
	Tue, 25 Aug 2026 17:43:07 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 7DE8B40578;
	Tue, 25 Aug 2026 17:53:52 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:50 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>,
	<akpm@linux-foundation.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <horms@kernel.org>,
	<socketcan@hartkopp.net>, <mkl@pengutronix.de>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<liuhangbin@gmail.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH 06/11] super: Use acquire for SB_BORN check in super_cache_count()
Date: Tue, 25 Aug 2026 17:54:17 +0800
Message-ID: <20260825095422.3166067-7-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825095422.3166067-1-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500011.china.huawei.com (7.185.36.131)

The active SB_BORN check in super_cache_count() pairs with the
smp_store_release() in super_wake() when publishing a newly initialized
superblock.

Replace the historical independent smp_rmb() barrier with an acquire load
on sb->s_flags. This expresses the publish-subscribe pattern more clearly
and allows weakly-ordered architectures like arm64 to utilize efficient
native instructions (e.g., LDAR) instead of a full one-way barrier.

Also update the outdated comment to correctly point to super_wake().

Assisted-by: Gemini:Gemini-3.1
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/super.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 05e443173038..5860daea6d40 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -267,12 +267,11 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	 * However, if we are currently mounting the superblock, the underlying
 	 * filesystem might be in a state of partial construction and hence it
 	 * is dangerous to access it.  super_trylock_shared() uses a SB_BORN check
-	 * to avoid this situation, so do the same here. The memory barrier is
-	 * matched with the one in mount_fs() as we don't hold locks here.
+	 * to avoid this situation, so do the same here. The acquire is matched
+	 * with the smp_store_release() in super_wake() as we don't hold locks here.
 	 */
-	if (!(sb->s_flags & SB_BORN))
+	if (!(smp_load_acquire(&sb->s_flags) & SB_BORN))
 		return 0;
-	smp_rmb();
 
 	if (sb->s_op && sb->s_op->nr_cached_objects &&
 	    super_fs_objects_eligible(sc))
-- 
2.34.1

