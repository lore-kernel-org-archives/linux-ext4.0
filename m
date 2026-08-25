Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB15E3FB055;
	Tue, 25 Aug 2026 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651646; cv=none; b=dnsILqVOWxbT3nkDXrKLbkQswmg/OuDtMQkcZdTJceEI31mEZ2pNh39iqjZukr16QBSyv/YU+punEcV87zkTgvn80UTwDj4QCSIHty7AWTVWyNICc9y6OpdAWp/z3sn83b23Ez/kJNNageuK5Lzu/mutvxNA35s0Uw4aDGRnkFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651646; c=relaxed/simple;
	bh=XNBSpVHvQ/skL0QPySFaWZ90V7U+qoF6u8zFYzU2KAI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PoFITP70ePjcgn0pSepAAyDRSlFGEN0yaANG76xNeECNcFxwORfl5wRVPbo4KIteoVuk+z7LS0O/fQHeo6vt9i3zvGf6XKihiRnb/tXHc74pE6hBf9jBp+TFqPV2EqspOiI4IzAjCMD4wuVw9vG+dGutWCk/ZTN6fob7Df68pww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rIgop2Bp; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="rIgop2Bp"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LFpSehcyWw3Y5kI9RuGM4x6gwDDus7uImypv1l9XmUc=;
	b=rIgop2BpX302wWzEzJXEEj0c/j/JwUX9pZgVh33DZYD4iHm5PlMWgX6FvkTb4EURkqw5YM6t+
	1gMKEIciAGJTn2knTbDafplxmKREtnS5ejmRZVpB2s/5Z5so33Vu2v97nO29+T7PI0bIe3KD1NP
	/jkIs64DvAWhLsiQ9L8Zqkw=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWl5j2yz1cyT9;
	Tue, 25 Aug 2026 17:43:15 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 29B93402AB;
	Tue, 25 Aug 2026 17:54:00 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:58 +0800
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
Subject: [PATCH 10/11] 8021q: publish vlan_devices_arrays entries with acquire/release
Date: Tue, 25 Aug 2026 17:54:21 +0800
Message-ID: <20260825095422.3166067-11-ruanjinjie@huawei.com>
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
smp_store_release()/smp_load_acquire() on
vg->vlan_devices_arrays[pidx][vidx].

vlan_group_prealloc_vid() publishes the array pointer via release;
__vlan_group_get_device() acquires it before accessing the array,
ensuring the allocated entries are visible.

No functional change intended.

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
index c41caaf94095..6db7172bdaac 100644
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
 
 	return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] : NULL;
 }
-- 
2.34.1

