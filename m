Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55ED30ACEE;
	Tue,  1 Sep 2026 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274719; cv=none; b=PK1oa8t1jKDeVouILtB37m8eKRvFxdmaRQSL7Q6HkYtsBBjIb7YKeoGUy2Wx07CDdq3GmFrXTz2pTORQeDF+QqzGOS1ZPcuB7PojI6mJ3SqlIuGr/w8JMBVcxqLJJDzz9G1ic69MDAy+R20SlYTZhB87STR+y0jIEWKX0zRuNzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274719; c=relaxed/simple;
	bh=ga7y9OugbgnIiRVYV8riRt+w/Uj12Gi5CSk2yc3met4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iklBh1+MnPATD/H3g/a3mpVEsVwAQaSEMf7UB+/1MkQpqEdpLEV1zSo97061uDYMznj4k1nRXATNKFQ1+ZzhCRMx1SnPwBoyTZOUcH5QYf9MddVk/xxUYqq9XGe3rrvktJt0L5q8Akkff8Byz46R54Xdysu6QmzW5LPpINwWD8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuM/YRy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuM/YRy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B141F000E9;
	Tue,  1 Sep 2026 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274714;
	bh=z2JM2kqKqHtIUp1FbN4QpSpD8kywj/s6QcNJcxpz9BQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VuM/YRy+aDv1fi7qnyesOmaXKWZnEMshLov1UfHp2xGqwVKxq80thRvq2Cx/a+KUd
	 bEwree+mKqy1TNDVCjyKtXjVg1hoGTbd0Zm+tu4LqyLnRrrrsj0qPs6wfK7Y4Jd+Li
	 69H/hepoPhtOZaxJoSDiWHoR3gRWpTqXxdyIat+CT9x0vd3fBFcypzzk55KeSRNj86
	 0cos3+ifYrrWeCfiFsir4rAGJl+aLWwK9gc0WS3h0IrEhJqk3K7Rv1L973c0GpbKEG
	 BaM6yGY0TCd19StS3sGBmx6aMClQ6hJZsp5KhtFoOzTWZhl9rs37lDUZkEW6IdC4d3
	 k4HaNvG5cUZsA==
Date: Tue, 1 Sep 2026 07:58:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
 <bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
 <libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
 <ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
 <pmladek@suse.com>, <rostedt@goodmis.org>,
 <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
 <senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
 <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
 <horms@kernel.org>, <kuniyu@google.com>, <willemb@google.com>,
 <jhs@mojatatu.com>, <jiri@resnulli.us>, <kees@kernel.org>,
 <cyphar@cyphar.com>, <tglx@kernel.org>, <sdf@fomichev.me>,
 <nb@tipi-net.de>, <liuhangbin@gmail.com>, <da-x@monatomic.org>,
 <jeff@garzik.org>, <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
 <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 11/12] 8021q: Fix data race when publishing vlan
 net_device pointers
Message-ID: <20260901075833.1aa73cb3@kernel.org>
In-Reply-To: <20260901024234.135119-12-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
	<20260901024234.135119-12-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 1 Sep 2026 10:42:33 +0800 Jinjie Ruan wrote:
> A plain C read and assignment of the net_device pointer
> in the vlan_devices_arrays leaf entries lack proper atomicity
> and ordering barriers. A concurrent lockless reader on the packet
> receive fast-path could observe a torn or partially initialized
> net_device pointer, leading to a potential out-of-bounds read or kernel
> panic.
> 
> The data race occurs between the netlink/ioctl configuration paths
> (holding the per-netns rtnl_nets_lock or RTNL lock) and the softirq
> receive fast-path (holding rcu_read_lock()):
> 
>   CPU 0 (Writer, rtnl_nets_lock/RTNL)      CPU 1 (Reader, rcu_read_lock())
>   -----------------------------------      -------------------------------
>    rtnetlink_rcv_msg()
>      // RTM_NEWLINK handler with RTNL_FLAG_DOIT_PERNET
>      rtnl_newlink()
>        ops->newlink() == vlan_newlink()
>    OR
>    vlan_ioctl_handler()
>      [ADD_VLAN_CMD] -> register_vlan_device()
> 
>      register_vlan_dev()
>        vlan_group_set_device()
>                                       netif_receive_skb_core()
>                                           vlan_do_receive()
>                                               vlan_find_dev()
>                                                  __vlan_group_get_device()
>                                                   // Speculative / torn read
>                                                   [Loads bad net_device *]
>            [Plain C store]
>            array[vlan_id] = dev;
>                                                   // Dereferences bad pointer
>                                                   // during device status check
>                                                   vlan_dev->flags (PANIC!)
> 
> Fix this by using rcu_assign_pointer() in vlan_group_set_device()
> and rcu_dereference_raw() in __vlan_group_get_device() to enforce
> proper ordering and memory atomicity for the leaf entry traversal.
> 
> Cc: stable@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Cc: Nicolai Buchwitz <nb@tipi-net.de>
> Cc: Dan Aloni <da-x@monatomic.org>
> Cc: Jeff Garzik <jeff@garzik.org>
> Fixes: 5c15bdec5c38 ("[VLAN]: Avoid a 4-order allocation.")
> Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

make C=1 says:

net/8021q/vlan.c: note: in included file:
net/8021q/vlan.h:91:9: error: incompatible types in comparison expression (different address spaces):
net/8021q/vlan.h:91:9:    struct net_device [noderef] __rcu *
net/8021q/vlan.h:91:9:    struct net_device *
net/8021q/vlan.h:91:9: error: incompatible types in comparison expression (different address spaces):
net/8021q/vlan.h:91:9:    struct net_device [noderef] __rcu *
net/8021q/vlan.h:91:9:    struct net_device *
