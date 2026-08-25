Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E7C3F54A0;
	Tue, 25 Aug 2026 09:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651653; cv=none; b=X1ZxjgtLs47o6qbS1iPDhjCBS/LNDazWYbhp54Ffhstr8/xmdXxK1tKIeE9VJpksivbYIJo7LehJrV8/m8ZiSrQK6ImHBG42qYXYRQQOqrYj1CXqCOvsAj397fxUP4YiR26G8jszI6NZQh/e+ZQHK3ly8krzro9sO8fn/YPHtCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651653; c=relaxed/simple;
	bh=vmhjgqu4evWlBUI6tNjlRBCU4UfRqEc/jY1DimltO7E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qdV+9QZDUbEGYFEMYhhG2AYuPCUUb96KlUFVdZUJAPzGUO2Qls3vwk7K9yA4iwCYBt1AlGI5pg46aiNdJ67U0KeS34Rq1j7G+FMwftviJaX9QAhg7SO+Lalv272JFddxg8uVgSmmy7Gh91A39KR1cBpbHWuJMY9Bg5JZyHQmafE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QuTizBvZ; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QuTizBvZ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kLuSQCasskPYYSTYdCUYQ9AeYdxAoMlIQ8GTnnTcWE4=;
	b=QuTizBvZQBJR6MMk8yU0Kw5pB6Ut9Nb0ABl+lfisxX2p6nCcM7rkUuLgCfuZLE424ahAyNv/G
	DvKFSk44c6hg8C55c5dFw3LWiyFNwSIoJN/GqbyBDd/b2dhmUYSCOLl1yt30opD9Xo+QJ8yyfFQ
	FZ+nNQ6zFfrCX7eSukYK5AU=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWm6GsNzmV91;
	Tue, 25 Aug 2026 17:43:16 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 12F5E4055B;
	Tue, 25 Aug 2026 17:54:02 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:54:00 +0800
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
Subject: [PATCH 11/11] can: isotp: publish tx.state with smp_store_release()
Date: Tue, 25 Aug 2026 17:54:22 +0800
Message-ID: <20260825095422.3166067-12-ruanjinjie@huawei.com>
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

The writer already pairs with the smp_load_acquire() readers
in isotp_tx_timeout()/isotp_tx_gen_done(); convert
the smp_wmb() + WRITE_ONCE() into a release store.

Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/can/isotp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 155530aedce2..11b653ba7c10 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1156,8 +1156,8 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	my_gen = isotp_inc_tx_gen(READ_ONCE(so->tx_gen));
 	isotp_set_tx_result(so, my_gen, ECOMM); /* prevent stale slot matching */
 	WRITE_ONCE(so->tx_gen, my_gen);
-	smp_wmb(); /* see smp_load_acquire() in isotp_tx_[timeout|gen_done] */
-	WRITE_ONCE(so->tx.state, ISOTP_SENDING);
+	/* Pairs with smp_load_acquire() in isotp_tx_[timeout|gen_done] */
+	smp_store_release(&so->tx.state, ISOTP_SENDING);
 	WRITE_ONCE(so->cfecho, 0);
 	spin_unlock_bh(&so->rx_lock);
 
-- 
2.34.1

