From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Sun, 20 Apr 2008 22:47:29 -0700
Message-ID: <20080421054729.GA19864@linux.vnet.ibm.com>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com> <20080421045911.GA1812@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35414 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYDUFrc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 01:47:32 -0400
Content-Disposition: inline
In-Reply-To: <20080421045911.GA1812@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 20, 2008 at 09:59:11PM -0700, Paul E. McKenney wrote:
> And here is an update with one bug fixed -- testing continues.
> This is an update of http://lkml.org/lkml/2008/4/20/217, deleting
> list_for_each_safe_rcu() and fixing hlist_for_each_entry_rcu().
> Testing continues...

And it passes.

							Thanx, Paul

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  list.h |   48 +++++++++++++++---------------------------------
>  1 file changed, 15 insertions(+), 33 deletions(-)
>  
> diff -urpNa -X dontdiff linux-2.6.25/include/linux/list.h linux-2.6.25-rcu-list/include/linux/list.h
> --- linux-2.6.25/include/linux/list.h	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-rcu-list/include/linux/list.h	2008-04-20 21:48:29.000000000 -0700
> @@ -631,31 +631,14 @@ static inline void list_splice_init_rcu(
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
>  #define list_for_each_rcu(pos, head) \
> -	for (pos = (head)->next; \
> -		prefetch(rcu_dereference(pos)->next), pos != (head); \
> -        	pos = pos->next)
> +	for (pos = rcu_dereference((head)->next); \
> +		prefetch(pos->next), pos != (head); \
> +        	pos = rcu_dereference(pos->next))
>  
>  #define __list_for_each_rcu(pos, head) \
> -	for (pos = (head)->next; \
> -		rcu_dereference(pos) != (head); \
> -        	pos = pos->next)
> -
> -/**
> - * list_for_each_safe_rcu
> - * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> - *
> - * Iterate over an rcu-protected list, safe against removal of list entry.
> - *
> - * This list-traversal primitive may safely run concurrently with
> - * the _rcu list-mutation primitives such as list_add_rcu()
> - * as long as the traversal is guarded by rcu_read_lock().
> - */
> -#define list_for_each_safe_rcu(pos, n, head) \
> -	for (pos = (head)->next; \
> -		n = rcu_dereference(pos)->next, pos != (head); \
> -		pos = n)
> +	for (pos = rcu_dereference((head)->next); \
> +		pos != (head); \
> +        	pos = rcu_dereference(pos->next))
>  
>  /**
>   * list_for_each_entry_rcu	-	iterate over rcu list of given type
> @@ -668,10 +651,9 @@ static inline void list_splice_init_rcu(
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
>  #define list_for_each_entry_rcu(pos, head, member) \
> -	for (pos = list_entry((head)->next, typeof(*pos), member); \
> -		prefetch(rcu_dereference(pos)->member.next), \
> -			&pos->member != (head); \
> -		pos = list_entry(pos->member.next, typeof(*pos), member))
> +	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
> +		prefetch(pos->member.next), &pos->member != (head); \
> +		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
>  
>  
>  /**
> @@ -686,9 +668,9 @@ static inline void list_splice_init_rcu(
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
>  #define list_for_each_continue_rcu(pos, head) \
> -	for ((pos) = (pos)->next; \
> -		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
> -        	(pos) = (pos)->next)
> +	for ((pos) = rcu_dereference((pos)->next); \
> +		prefetch((pos)->next), (pos) != (head); \
> +        	(pos) = rcu_dereference((pos)->next))
>  
>  /*
>   * Double linked lists with a single pointer list head.
> @@ -986,10 +968,10 @@ static inline void hlist_add_after_rcu(s
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
>  #define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
> -	for (pos = (head)->first;					 \
> -	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	 \
> +	for (pos = rcu_dereference((head)->first);			 \
> +	        pos && ({ prefetch(pos->next); 1;}) &&			 \
>  		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
> -	     pos = pos->next)
> +	     pos = rcu_dereference(pos->next))
>  
>  #else
>  #warning "don't include kernel headers in userspace"
