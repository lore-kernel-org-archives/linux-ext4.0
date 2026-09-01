Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02F3955F9;
	Tue,  1 Sep 2026 02:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230551; cv=none; b=Owc0Xegzcod6rRTIrfepPLBEXLAUStrDwM4kt1a7TPOW8gBdVifCgQWp6n7rXqdb/7fsUIHlHGJ2ztsCWNi7LrsVj6ybb6XyA1vvL+SxCbG+IIpMPBkTLKUvKJXIcENiUYPx4gvEd1fW1bB3H8ofeM5MjpgwpSZH/9wOpP4w/Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230551; c=relaxed/simple;
	bh=psredXZcBYyF6yHuuo0kUdTbAiaE3bXWhgJqN8LR8dc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCkpGMkmTC6Z6V4m6u7cWG6GlIbuE8ltx7+j/PjHsD3wPuL8wscDCQjHcR5rfTUKFpBTAiR2zi+K0dyCykIVEb4XAgYdI9RqM7FmRG8qXlbVAWvBCLYhZUoysQQHh1ONpsx1bccimkH+JSg0W+LU3JOBRAdytzSUeE+bOa0GmoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Tm0QWdRu; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Tm0QWdRu"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FeUz9/Jb9zKBq4O6jTmfAdLRs6iUhQP0Ga4scxDxqrg=;
	b=Tm0QWdRumd9vaVubufGNdVaCfqEmd4AXKW9cihyB2xeJLR9Ulp6l09CFiRb1vZTF5i3+QcWxU
	tombpLLUdc5HpuTbdarLIaK38/vXyRuouGcJ51a7JKCw1xTjl8mOPp6McLFmAjvPXXwWjrJIxA3
	mnM0gTlkzt1y5vv56lRb4w0=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hYqcD1DK2z1K9XH;
	Tue,  1 Sep 2026 10:31:24 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 84DC24057C;
	Tue,  1 Sep 2026 10:42:13 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:42:11 +0800
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
Subject: [PATCH v2 12/12] 8021q: publish vlan_devices_arrays entries with acquire/release
Date: Tue, 1 Sep 2026 10:42:34 +0800
Message-ID: <20260901024234.135119-13-ruanjinjie@huawei.com>
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
smp_store_release()/smp_load_acquire() on
vg->vlan_devices_arrays[pidx][vidx].

vlan_group_prealloc_vid() publishes the array pointer via release;
__vlan_group_get_device() acquires it before accessing the array,
ensuring the allocated entries are visible.

No functional change intended.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Nicolai Buchwitz <nb@tipi-net.de>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/8021q/vlan.c | 6 ++----
 net/8021q/vlan.h | 8 +++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 2d2efb877975..e34ada0cceac 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -70,10 +70,8 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 	if (array == NULL)
 		return -ENOBUFS;
 
-	/* paired with smp_rmb() in __vlan_group_get_device() */
-	smp_wmb();
-
-	vg->vlan_devices_arrays[pidx][vidx] = array;
+	/* paired with smp_load_acquire() in __vlan_group_get_device() */
+	smp_store_release(&vg->vlan_devices_arrays[pidx][vidx], array);
 	return 0;
 }
 
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 8030d616cb16..ee22637aa7ba 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -56,11 +56,9 @@ static inline struct net_device *__vlan_group_get_device(struct vlan_group *vg,
 {
 	struct net_device **array;
 
-	array = vg->vlan_devices_arrays[pidx]
-				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
-
-	/* paired with smp_wmb() in vlan_group_prealloc_vid() */
-	smp_rmb();
+	/* Pairs with smp_store_release() in vlan_group_prealloc_vid() */
+	array = smp_load_acquire(&vg->vlan_devices_arrays[pidx]
+				 [vlan_id / VLAN_GROUP_ARRAY_PART_LEN]);
 
 	return array ? rcu_dereference_raw(array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN]) : NULL;
 }
-- 
2.34.1

