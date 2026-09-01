Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7305436BF4;
	Tue,  1 Sep 2026 02:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230575; cv=none; b=nyyKU1Ewd36sgAjbedCHpJRFear0TnBcaKSzCvdJKiCebQNI5jSjOc/nhAl3lFqsxOFUuKaUzmHTVUcn2GGaacTRuvmQYlnr6aO+xY4PElogYpXMGyyZdoysY2AU8bn3+k7T5Lsli/yjob0TMU58wshK5BtGujuAJFzkDLbmoUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230575; c=relaxed/simple;
	bh=qTOa/SXotA6a3UX1CtQJnoWqsy2a0tld+krDqavWCrU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QqDpkIknx560xRaYgkXVojLMmHYVUDJGoccBzK1YI9UwQok17ufL1DFOtwiNqRjgkrS6S4ftToIuLMu4qxwOMzUJhxbqcrKSRnqAnV0f6bBRwf6en52E8Mdrqm623Jpjl0Df6WSOCzFzyyo09066yk2dlj21Z1KHcEHo4ZouVrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FxCl1y1c; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FxCl1y1c"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=B4nkOSyrKXpYTqmMmhRGx9fcZpl8Ig3qwoqs/6YnVlI=;
	b=FxCl1y1c/qQJ+0Tb1ZFYoM/2vqeeozEIe48eoyUhQz2YNxplZ4JVrma92Up0t0/bcJJKqNmXz
	adFsXQLrfS5iQtE8NTYRkFGNfWj59kSXfwW1xaM5J/2OsbROIRtSYZNtGWCpDn4cUCkRGnNNH/D
	LQxJ3jNZlXNQHb49u+GbXlU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hYqcC3frsz1cyVL;
	Tue,  1 Sep 2026 10:31:23 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 1011C4057C;
	Tue,  1 Sep 2026 10:42:12 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:42:10 +0800
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
Subject: [PATCH v2 11/12] 8021q: Fix data race when publishing vlan net_device pointers
Date: Tue, 1 Sep 2026 10:42:33 +0800
Message-ID: <20260901024234.135119-12-ruanjinjie@huawei.com>
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

A plain C read and assignment of the net_device pointer
in the vlan_devices_arrays leaf entries lack proper atomicity
and ordering barriers. A concurrent lockless reader on the packet
receive fast-path could observe a torn or partially initialized
net_device pointer, leading to a potential out-of-bounds read or kernel
panic.

The data race occurs between the netlink/ioctl configuration paths
(holding the per-netns rtnl_nets_lock or RTNL lock) and the softirq
receive fast-path (holding rcu_read_lock()):

  CPU 0 (Writer, rtnl_nets_lock/RTNL)      CPU 1 (Reader, rcu_read_lock())
  -----------------------------------      -------------------------------
   rtnetlink_rcv_msg()
     // RTM_NEWLINK handler with RTNL_FLAG_DOIT_PERNET
     rtnl_newlink()
       ops->newlink() == vlan_newlink()
   OR
   vlan_ioctl_handler()
     [ADD_VLAN_CMD] -> register_vlan_device()

     register_vlan_dev()
       vlan_group_set_device()
                                      netif_receive_skb_core()
                                          vlan_do_receive()
                                              vlan_find_dev()
                                                 __vlan_group_get_device()
                                                  // Speculative / torn read
                                                  [Loads bad net_device *]
           [Plain C store]
           array[vlan_id] = dev;
                                                  // Dereferences bad pointer
                                                  // during device status check
                                                  vlan_dev->flags (PANIC!)

Fix this by using rcu_assign_pointer() in vlan_group_set_device()
and rcu_dereference_raw() in __vlan_group_get_device() to enforce
proper ordering and memory atomicity for the leaf entry traversal.

Cc: stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Nicolai Buchwitz <nb@tipi-net.de>
Cc: Dan Aloni <da-x@monatomic.org>
Cc: Jeff Garzik <jeff@garzik.org>
Fixes: 5c15bdec5c38 ("[VLAN]: Avoid a 4-order allocation.")
Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/8021q/vlan.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index c41caaf94095..8030d616cb16 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -62,7 +62,7 @@ static inline struct net_device *__vlan_group_get_device(struct vlan_group *vg,
 	/* paired with smp_wmb() in vlan_group_prealloc_vid() */
 	smp_rmb();
 
-	return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] : NULL;
+	return array ? rcu_dereference_raw(array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN]) : NULL;
 }
 
 static inline struct net_device *vlan_group_get_device(struct vlan_group *vg,
@@ -88,7 +88,7 @@ static inline void vlan_group_set_device(struct vlan_group *vg,
 		return;
 	array = vg->vlan_devices_arrays[pidx]
 				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
-	array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] = dev;
+	rcu_assign_pointer(array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN], dev);
 }
 
 /* Must be invoked with rcu_read_lock or with RTNL. */
-- 
2.34.1

