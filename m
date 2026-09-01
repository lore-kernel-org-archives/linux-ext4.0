Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12E542F70E;
	Tue,  1 Sep 2026 02:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230534; cv=none; b=mE7Mh7B6vwEhpaPazowYcW1gxY7z1pZFtq3OioXj5qJF9AuGLdnVD5TuntGN8onuND+yBI1AXNb/Koe8nMTYZruov4fCkHRInlXtyx6jPgGgu/6ZXCCu3ToSOm0a4fTRLfeQKoZbRk2WBEFRuDIM4z0trtQ5nREYS1CfZ7RysUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230534; c=relaxed/simple;
	bh=K7Gq5AUxlQXe5No7zoeHSsKZ3ssti34uiTOjY1Ps/no=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWPwj2D8x1vcWHtrstVgaKzVunX/DtIgTDaUVPAxleXmdJem5pi8wZguFT3pwvo+9qN0EVRG3kwFOA8v909FlNSE00o2DJLVyDt/f4cY52Lo2+BRMn4wL45JMlW7VrRZkDRi6MYwT6IayP0dmaX0FfpGGzmGLMJwlFa/JvIXGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=SFCgOczG; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="SFCgOczG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4SvDeO5hIzQzXgGr/cxbQ0Jb8d2NsgcdDWNHmf6UJlg=;
	b=SFCgOczGkgW7ko/Y6AyBOmgW04Do1Yczgae9MVa2hBLlI//yx0q8SiRjeMI/zITTc1wQzJfyz
	Vr5GUCNXmb9RGJMAhn5/pBaxOBcUTwNFSsW7mBjeakFp9WQLLKIevVOcv4C56V+IqI5wZ3JjmZN
	6QoPmCaiCKQ0LvFErUobgGM=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hYqbv6KdNz1prmR;
	Tue,  1 Sep 2026 10:31:07 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id D4544203C8;
	Tue,  1 Sep 2026 10:41:58 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:41:57 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<ruanjinjie@huawei.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH v2 02/12] lib/vsprintf: Use acquire/release for ptr_key publication
Date: Tue, 1 Sep 2026 10:42:24 +0800
Message-ID: <20260901024234.135119-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260901024234.135119-1-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
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

Replace the smp_wmb() + WRITE_ONCE() and READ_ONCE() + smp_rmb() barrier
pair with smp_store_release()/smp_load_acquire() on filled_random_ptr_key.

This expresses the publish/subscribe pattern more clearly and allows
architectures with native acquire/release instructions (e.g. arm64's
STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).

No functional change intended.

Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 lib/vsprintf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1d95ab9314bf..90d0a724eadd 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -762,9 +762,8 @@ static int fill_ptr_key(struct notifier_block *nb, unsigned long action, void *d
 {
 	get_random_bytes(&ptr_key, sizeof(ptr_key));
 
-	/* Pairs with smp_rmb() before reading ptr_key. */
-	smp_wmb();
-	WRITE_ONCE(filled_random_ptr_key, true);
+	/* Pairs with smp_load_acquire() before reading ptr_key. */
+	smp_store_release(&filled_random_ptr_key, true);
 	return NOTIFY_DONE;
 }
 
@@ -781,12 +780,10 @@ static inline int __ptr_to_hashval(const void *ptr, unsigned long *hashval_out)
 {
 	unsigned long hashval;
 
-	if (!READ_ONCE(filled_random_ptr_key))
+	/* Pairs with smp_store_release() after writing ptr_key. */
+	if (!smp_load_acquire(&filled_random_ptr_key))
 		return -EBUSY;
 
-	/* Pairs with smp_wmb() after writing ptr_key. */
-	smp_rmb();
-
 #ifdef CONFIG_64BIT
 	hashval = (unsigned long)siphash_1u64((u64)ptr, &ptr_key);
 	/*
-- 
2.34.1

