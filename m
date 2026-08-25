Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAEA3F99E3;
	Tue, 25 Aug 2026 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651645; cv=none; b=UdmOXnbXm8V8KkI1E/7UeteyH/iTtwcnOPk2qNTwk6q52AQ/O1C09jDD3YWN8U2pImyInOxZhuATjMq5EnAZ6ZPbGU20uuh3/yNwAs2uNdlSG3ZYovpW12PkVUupWeQq9K2AMQXJII2mLVSbui6l00oTcMrHN+XEXjei5whTgLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651645; c=relaxed/simple;
	bh=YHPKagm1+brOllx+9HjiRfO+T8k3k5DTtjYMuEzl4cY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rw7tWIaQmQH2LmbxQY2oryFGeYoVr2cNMIlq/NimE6VgAbTAGtJQi2wEKWJZmJTa3xIV83X260p2gbIW3pYWWf6BcJfSOPW2Se/eiQX057tzIgTzfHijvjRw0V28AFuwEdvKSGuRXkEzXQiY7Wct8acXyYN8byDdVE6Jf33I4kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pv78ql9T; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pv78ql9T"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=n2rOlDHSg923uKF19dgYoacryfpqA16TA+EsTrrgL/o=;
	b=pv78ql9TY9058OtNO5LvmA4H7jBpYx3OKhlPYYCwzCjyirI4JN5udw2lPbCxRrFqjxLQJT3xS
	iMD1iUdx+ChRubUdoqqVXThmZiu+idvUiKgCVNFOH/uAOj1vq+1CM2s3203d9/gDyjnhgnYRkEB
	9RBwTxjYv8/jgRQy/hVuS4w=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hTjXP2Sbgz1T4MQ;
	Tue, 25 Aug 2026 17:43:49 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E3F04057A;
	Tue, 25 Aug 2026 17:53:58 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:56 +0800
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
Subject: [PATCH 09/11] net: sched: act_gact: use acquire/release for tcfg_ptype
Date: Tue, 25 Aug 2026 17:54:20 +0800
Message-ID: <20260825095422.3166067-10-ruanjinjie@huawei.com>
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
smp_store_release()/smp_load_acquire() on gact->tcfg_ptype.
tcf_gact_init() publishes tcfg_ptype via release after writing
tcfg_pval/tcfg_paction; tcf_gact_act() acquires it before
dispatching to gact_net_rand()/gact_determ(), ensuring the probability
parameters are visible.

No functional change intended.

Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/sched/act_gact.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 565860cccba6..d4f39f98e2cf 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -25,7 +25,6 @@ static struct tc_action_ops act_gact_ops;
 #ifdef CONFIG_GACT_PROB
 static int gact_net_rand(struct tcf_gact *gact)
 {
-	smp_rmb(); /* coupled with smp_wmb() in tcf_gact_init() */
 	if (get_random_u32_below(gact->tcfg_pval))
 		return gact->tcf_action;
 	return gact->tcfg_paction;
@@ -35,7 +34,6 @@ static int gact_determ(struct tcf_gact *gact)
 {
 	u32 pack = atomic_inc_return(&gact->packets);
 
-	smp_rmb(); /* coupled with smp_wmb() in tcf_gact_init() */
 	if (pack % gact->tcfg_pval)
 		return gact->tcf_action;
 	return gact->tcfg_paction;
@@ -133,11 +131,8 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	if (p_parm) {
 		gact->tcfg_paction = p_parm->paction;
 		gact->tcfg_pval    = max_t(u16, 1, p_parm->pval);
-		/* Make sure tcfg_pval is written before tcfg_ptype
-		 * coupled with smp_rmb() in gact_net_rand() & gact_determ()
-		 */
-		smp_wmb();
-		gact->tcfg_ptype   = p_parm->ptype;
+		/* Pairs with smp_load_acquire() in tcf_gact_act(). */
+		smp_store_release(&gact->tcfg_ptype, p_parm->ptype);
 	}
 #endif
 	spin_unlock_bh(&gact->tcf_lock);
@@ -160,7 +155,8 @@ TC_INDIRECT_SCOPE int tcf_gact_act(struct sk_buff *skb,
 
 #ifdef CONFIG_GACT_PROB
 	{
-	u32 ptype = READ_ONCE(gact->tcfg_ptype);
+	/* Pairs with smp_store_release() in tcf_gact_init() */
+	u32 ptype = smp_load_acquire(&gact->tcfg_ptype);
 
 	if (ptype)
 		action = gact_rand[ptype](gact);
-- 
2.34.1

