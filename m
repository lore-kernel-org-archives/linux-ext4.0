Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ECC426EB7;
	Tue,  1 Sep 2026 02:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230551; cv=none; b=YcXLtDvX1ngRWhSJXoh3FQrzgWYPjXaK0q8ecZ+pMQvlSvPE+hmyiO1uf0vd0q0/2AM20Wjg0ypBrQBh+d1QkWQkkhMFwKfJed0x8jH+yKnynrVexU6PCE7F9AWGHpeO+kADa52ifFWOVukDGBgDxu8k/+J6RgAAyzJbWlu0i+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230551; c=relaxed/simple;
	bh=Q4IHSqNTta6ZY/efVhCtaRjHjKcMWUomiKRMpYUCKlw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JByEnaDUReboLHNdNXca9QxVoIb0ribKpHjZcjtfhE+xQ7Q2YgmkmbyVN9SIBNCHHngkof0gdwbWdGs7nMdWjjtZoc1JpwhqIO/uzy3C8cxOtURvbhavT7jDb1Fi6QHgGAGkKi4kjfxl2K2F7rzpOuDAjGMfB1RfsHhIoaeasgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=3MN1y82A; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="3MN1y82A"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HpnC7rLdz/iDoVhcUnqYIGvEK4UiEp8j2qFTrzFFI14=;
	b=3MN1y82AyUB+uSVGkpsEtn46gwJl3yuhLHq+APy7OksLo3azZvR0HlLyg/DfR5RZ8YBYprGfD
	IfPDFzpbKdgaKYr4CjKFT7GcHHN6kXtOvwv+26okjTS7wgzucRQEAXul44jF7TxYxkACO6gDi6m
	2HM8XEE4+uMal1dtnRg0FhE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hYqbd3nwvz12LHt;
	Tue,  1 Sep 2026 10:30:53 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 8DF7B40561;
	Tue,  1 Sep 2026 10:42:10 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:42:09 +0800
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
Subject: [PATCH v2 10/12] net: sched: act_gact: use acquire/release for tcfg_ptype
Date: Tue, 1 Sep 2026 10:42:32 +0800
Message-ID: <20260901024234.135119-11-ruanjinjie@huawei.com>
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

Replace the smp_wmb()/smp_rmb() barrier pair with
smp_store_release()/smp_load_acquire() on gact->tcfg_ptype.
tcf_gact_init() publishes tcfg_ptype via release after writing
tcfg_pval/tcfg_paction; tcf_gact_act() acquires it before
dispatching to gact_net_rand()/gact_determ(), ensuring the probability
parameters are visible.

No functional change intended.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
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

