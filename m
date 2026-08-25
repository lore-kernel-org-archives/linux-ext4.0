Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3193F3284;
	Tue, 25 Aug 2026 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651632; cv=none; b=Y3VncoQoLhRiJsjH+rp/hjOXrg/tUioo39ouL4RRp+YeFsrmi7sYREobU50eax4W+cTlzAhiZhD6ActO7UJKm9J8YXJNOhCP8aYbzmMiZy9YD3UBKqk2Sxwj3JO2m+IlhGJNqZC+aRfzZTgd5AZHp2OQ49XHJIbRtATMbbelQc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651632; c=relaxed/simple;
	bh=z0BxniLfOKINc495SO6dIMOCxgc3oRBRylFOj3iSnqw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBnJs6GgP4ec7KyCS9Zjxi3X3IwVL5GTR5BmNsllpAzXOZV3dlnxDxZR9QH+9WFFQ3XhBSLq99nR/OHV9odlYDM6eqFKuWRhAQl6LDC7sK0Rq5s7My8KztRKy85OKcsqv8ikNBXN46dKGnOLpC2cpVWbTxsYg+/AoBuZhyDldwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=DhkTcSxB; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="DhkTcSxB"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HgTAudJq8eHX15OWks05AWG/aS/PTGI/7ZST00bOn60=;
	b=DhkTcSxBxG6+QuFui1fAbXzMpP7OAunc0olvkVUBNqDQ6v01S+pCZQp8+ee2Q3wY1ABG4SW1x
	FGSDXE4D0XfgyxUvepAYHy5UmZZHnKo62+r7rU1wzucBTt6Y1Nw9GWce/qqKj4qMZTTCpbFWZ2i
	E1GaE6D5I7SSj8wsc7h/iqQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWj5vKxzcb0T;
	Tue, 25 Aug 2026 17:43:13 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id D8FB84058C;
	Tue, 25 Aug 2026 17:53:44 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:42 +0800
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
Subject: [PATCH 02/11] lib/vsprintf: Use acquire/release for ptr_key publication
Date: Tue, 25 Aug 2026 17:54:13 +0800
Message-ID: <20260825095422.3166067-3-ruanjinjie@huawei.com>
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

Replace the smp_wmb() + WRITE_ONCE() and READ_ONCE() + smp_rmb() barrier
pair with smp_store_release()/smp_load_acquire() on filled_random_ptr_key.

This expresses the publish/subscribe pattern more clearly and allows
architectures with native acquire/release instructions (e.g. arm64's
STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).

No functional change intended.

Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 lib/vsprintf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e285e8bc4712..d6f235e143b7 100644
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

