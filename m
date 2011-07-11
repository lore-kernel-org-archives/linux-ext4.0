From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] jbd2,rcu: correctly use RCU
Date: Sun, 10 Jul 2011 20:25:02 -0400
Message-ID: <20110711002502.GC28763@thunk.org>
References: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@elte.hu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55323 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1GKAZQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 20:25:16 -0400
Content-Disposition: inline
In-Reply-To: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 16, 2011 at 09:47:04AM +0800, Lai Jiangshan wrote:
> In read site, we need to use local_ptr = rcu_dereference(),
> and then use this local_ptr to read the content.
> 
> In update site, we should assign/publish the new object/pointer after
> the content of the new object/pointer is fully initialized,
> and we can't not touch the object after the pointer assignment.
> rcu_assign_pointer() is need for the assignement.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks, applied.

> @@ -2447,24 +2447,25 @@ const char *jbd2_dev_to_name(dev_t device)
>  	int	i = hash_32(device, CACHE_SIZE_BITS);
>  	char	*ret;
>  	struct block_device *bd;
> -	static struct devname_cache *new_dev;
> +	static struct devname_cache *cache;

I also removed the static modifier to the struct devname_cache
pointer.  It's pointless, and in fact introduces a bug if two CPU's
try to run jbd2_dev_to_name() at the same time.

						- Ted
