Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90463DA5C5;
	Tue, 25 Aug 2026 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651642; cv=none; b=Q+gSuwkaS/D3+wFacatS1Es/ahR12lFRksLLiglVVHqjB5T2f/1cxz8lH4p9ZuOGXdtuCGzXBh8Ni4SOhZiRKsK2SN2KfLygzs5/cNoaGO9MJXf6SM8qHGohafENdgJ6wfabGSK+t2E3d+XfrCkd1YmkYnPf2jlFhbhyg/PjBcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651642; c=relaxed/simple;
	bh=Z35ePei/QyXNJ5AewGWCEjdFNWAAxaH7ykgYKESbCwA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bgYCnH04E5IYUeNPy3/7XLcKTLvAm17XVnGcUEjeaFQh9yXUViK68WHCpLSBGtZ58EKUwtciEzZ7yxjLy3pdPVTE7tvRqRa5cxWhdFfqim5ntsIhlL/1ktTtSlT3XgHsYiqU2+AzlevyTVxTc5jVflDd653hXwCYv9rXDS8FPXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=fVfh6m5T; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="fVfh6m5T"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J6Z3R61B1Bih/Ax1lTgFVPe2AKAV13hl3xrbb4fy5uU=;
	b=fVfh6m5T3nT8C5mQN0/TWRlBwYFBOEmuyYdU3jNF4lTiGYWflLdfMqFu4BA+VNpiPQjW6XJ7G
	auW2bISPGxUbY+4/pcDke2TV1K3Zbqmf9kjvmiht1QV4ZPqNd8mfipvyuYhP9W4RNtkwo163xve
	5f60+A/uYlzYhqPOjd+AdRA=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWF4nWtzpT0h;
	Tue, 25 Aug 2026 17:42:49 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 526CC4058C;
	Tue, 25 Aug 2026 17:53:56 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:54 +0800
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
Subject: [PATCH 08/11] soreuseport: publish num_socks with acquire/release
Date: Tue, 25 Aug 2026 17:54:19 +0800
Message-ID: <20260825095422.3166067-9-ruanjinjie@huawei.com>
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

Replace the smp_wmb()/smp_rmb() barrier pair with
smp_store_release()/smp_load_acquire() on reuse->num_socks.
Writers publish socks[] updates via release before incrementing
or decrementing the count; readers acquire the count before
accessing socks[], ensuring they observe a consistent view.

The detach path gains proper ordering between the socks[] write and
the decrement, which was previously unordered.

No functional change intended.

Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/core/sock_reuseport.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 29948cb44b7d..6d3c511d1def 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -125,9 +125,8 @@ static void __reuseport_add_sock(struct sock *sk,
 				 struct sock_reuseport *reuse)
 {
 	reuse->socks[reuse->num_socks] = sk;
-	/* paired with smp_rmb() in reuseport_(select|migrate)_sock() */
-	smp_wmb();
-	reuse->num_socks++;
+	/* paired with smp_load_acquire() in reuseport_(select|migrate)_sock() */
+	smp_store_release(&reuse->num_socks, reuse->num_socks + 1);
 	reuseport_get_incoming_cpu(sk, reuse);
 }
 
@@ -140,7 +139,8 @@ static bool __reuseport_detach_sock(struct sock *sk,
 		return false;
 
 	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
-	reuse->num_socks--;
+	/* paired with smp_load_acquire() in reuseport_(select|migrate)_sock() */
+	smp_store_release(&reuse->num_socks, reuse->num_socks - 1);
 	reuseport_put_incoming_cpu(sk, reuse);
 
 	return true;
@@ -583,11 +583,9 @@ struct sock *reuseport_select_sock(struct sock *sk,
 		goto out;
 
 	prog = rcu_dereference(reuse->prog);
-	socks = READ_ONCE(reuse->num_socks);
+	/* paired with smp_store_release() in __reuseport_add_sock() */
+	socks = smp_load_acquire(&reuse->num_socks);
 	if (likely(socks)) {
-		/* paired with smp_wmb() in __reuseport_add_sock() */
-		smp_rmb();
-
 		if (!prog || !skb)
 			goto select_by_hash;
 
@@ -634,13 +632,11 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	if (!reuse)
 		goto out;
 
-	socks = READ_ONCE(reuse->num_socks);
+	/* paired with smp_store_release() in __reuseport_add_sock() */
+	socks = smp_load_acquire(&reuse->num_socks);
 	if (unlikely(!socks))
 		goto failure;
 
-	/* paired with smp_wmb() in __reuseport_add_sock() */
-	smp_rmb();
-
 	hash = migrating_sk->sk_hash;
 	prog = rcu_dereference(reuse->prog);
 	if (!prog || prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE) {
-- 
2.34.1

