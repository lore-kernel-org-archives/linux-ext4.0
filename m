Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FA536EA93;
	Wed,  2 Sep 2026 06:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788331590; cv=none; b=ju2FCOW5qHBWpdJ5qN/mpBIpqyDVRJasIhwPo19FkdJVKfaulDJInGFNhEGo/v8yXt0AuhATGElgK+dvmCroRqHQify+z/9zOB0kkfSnNWZH3dC9e2FAe71YVi+TO6g2sBZpSXrgMrptsD7MBCy/9pxqJWYqj8LZkEU9bDJhlJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788331590; c=relaxed/simple;
	bh=BQ/OLKVbP+6G6AzF18XitS8dZZFklfctJS9TxMOmcnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DjEjtzqk2swdUKbgDP1sYIPvAXhYOg6tjVIqAL0BnWEXgW8d0BebBHIXAEJZmrMkJRSVNu9C/trJkDp8+Jbk+T+cTblfEopN1zJFscCDP4nBOQNlGEVghCrcc5OVvIuEXViVVGXP0Iu58h+94VFB7mKMI9gJT2HO7gnYAhB1FB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pWpxjur1; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pWpxjur1"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XkVkydpEbd/i/xyW0bVNgYtI18TmGIgVUYVlilWRXC8=;
	b=pWpxjur1ia9Wds1HdRjs5cyzpqLF4seDOc/RLHklmeLfdlvuVEhkBvZQaoX5+giXgrsDuswUR
	4LD0NE+qCLsGV9eAQD+ucr4usT1VCy/3nC2GpkHn7UMIvcODtNYdWw9Tjr7vK5XluGWpOnLhZJW
	NPaWcXMW97CToFAiypVdSpk=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hZXz71xySzKm5t;
	Wed,  2 Sep 2026 14:35:15 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id D82FD4057C;
	Wed,  2 Sep 2026 14:46:08 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 2 Sep 2026 14:46:06 +0800
Message-ID: <cb145b63-7f72-4912-87d5-4af3f6d89c09@huawei.com>
Date: Wed, 2 Sep 2026 14:46:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/12] 8021q: Fix data race when publishing vlan
 net_device pointers
To: Jakub Kicinski <kuba@kernel.org>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
	<horms@kernel.org>, <kuniyu@google.com>, <willemb@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kees@kernel.org>,
	<cyphar@cyphar.com>, <tglx@kernel.org>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-12-ruanjinjie@huawei.com>
 <20260901075833.1aa73cb3@kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260901075833.1aa73cb3@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500011.china.huawei.com (7.185.36.131)



在 2026/9/1 22:58, Jakub Kicinski 写道:
> On Tue, 1 Sep 2026 10:42:33 +0800 Jinjie Ruan wrote:
>> A plain C read and assignment of the net_device pointer
>> in the vlan_devices_arrays leaf entries lack proper atomicity
>> and ordering barriers. A concurrent lockless reader on the packet
>> receive fast-path could observe a torn or partially initialized
>> net_device pointer, leading to a potential out-of-bounds read or kernel
>> panic.
>>
>> The data race occurs between the netlink/ioctl configuration paths
>> (holding the per-netns rtnl_nets_lock or RTNL lock) and the softirq
>> receive fast-path (holding rcu_read_lock()):
>>
>>   CPU 0 (Writer, rtnl_nets_lock/RTNL)      CPU 1 (Reader, rcu_read_lock())
>>   -----------------------------------      -------------------------------
>>    rtnetlink_rcv_msg()
>>      // RTM_NEWLINK handler with RTNL_FLAG_DOIT_PERNET
>>      rtnl_newlink()
>>        ops->newlink() == vlan_newlink()
>>    OR
>>    vlan_ioctl_handler()
>>      [ADD_VLAN_CMD] -> register_vlan_device()
>>
>>      register_vlan_dev()
>>        vlan_group_set_device()
>>                                       netif_receive_skb_core()
>>                                           vlan_do_receive()
>>                                               vlan_find_dev()
>>                                                  __vlan_group_get_device()
>>                                                   // Speculative / torn read
>>                                                   [Loads bad net_device *]
>>            [Plain C store]
>>            array[vlan_id] = dev;
>>                                                   // Dereferences bad pointer
>>                                                   // during device status check
>>                                                   vlan_dev->flags (PANIC!)
>>
>> Fix this by using rcu_assign_pointer() in vlan_group_set_device()
>> and rcu_dereference_raw() in __vlan_group_get_device() to enforce
>> proper ordering and memory atomicity for the leaf entry traversal.
>>
>> Cc: stable@vger.kernel.org
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: Simon Horman <horms@kernel.org>
>> Cc: Stanislav Fomichev <sdf@fomichev.me>
>> Cc: Kuniyuki Iwashima <kuniyu@google.com>
>> Cc: Nicolai Buchwitz <nb@tipi-net.de>
>> Cc: Dan Aloni <da-x@monatomic.org>
>> Cc: Jeff Garzik <jeff@garzik.org>
>> Fixes: 5c15bdec5c38 ("[VLAN]: Avoid a 4-order allocation.")
>> Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> make C=1 says:
> 
> net/8021q/vlan.c: note: in included file:
> net/8021q/vlan.h:91:9: error: incompatible types in comparison expression (different address spaces):
> net/8021q/vlan.h:91:9:    struct net_device [noderef] __rcu *

Good catch, let me fix it in next version.

> net/8021q/vlan.h:91:9:    struct net_device *
> net/8021q/vlan.h:91:9: error: incompatible types in comparison expression (different address spaces):
> net/8021q/vlan.h:91:9:    struct net_device [noderef] __rcu *
> net/8021q/vlan.h:91:9:    struct net_device *

