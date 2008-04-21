From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 09:18:55 +0800
Message-ID: <20080421011855.GA6243@gondor.apana.org.au>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48179 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753702AbYDUBUK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2008 21:20:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus:

On Sun, Apr 20, 2008 at 02:31:48PM -0700, Linus Torvalds wrote:
>
> Talking about RCU I also think that whoever did those "rcu_dereference()" 
> macros in <linux/list.h> was insane. It's totally pointless to do 
> "rcu_dereference()" on a local variable. It simply *cannot* make sense. 
> Herbert, Paul, you guys should look at it.

Since I made the macros look this way I'm obliged to defend it :)

>  #define list_for_each_rcu(pos, head) \
> -	for (pos = (head)->next; \
> -		prefetch(rcu_dereference(pos)->next), pos != (head); \
> -        	pos = pos->next)
> +	for (pos = rcu_dereference((head)->next); \
> +		prefetch(pos->next), pos != (head); \
> +        	pos = rcu_dereference(pos->next))

Semantically there should be no difference between the two versions.
The purpose of rcu_dereference is really similar to smp_rmb, i.e.,
it adds a (conditional) read barrier between what has been read so
far (including its argument), and what will be read subsequently.

So if we expand out the current code it would look like

	fetch (head)->next
	store into pos
again:
	smp_read_barrier_depends()
	prefetch(pos->next)
	pos != (head)

	...loop body...

	fetch pos->next
	store into pos
	goto again

Yours looks like

	fetch (head)->next
	smp_read_barrier_depends()
	store into pos
again:
	prefetch(pos->next)
	pos != (head)

	...loop body...

	fetch pos->next
	smp_read_barrier_depends()
	store into pos
	goto again

As the objective here is to insert a barrier before dereferencing
pos (e.g., reading pos->next or using it in the loop body), these
two should be identical.

But I do concede that your version looks clearer, and has the
benefit that should prefetch ever be optimised out with no side-
effects, yours would still be correct while the current one will
lose the barrier completely.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
