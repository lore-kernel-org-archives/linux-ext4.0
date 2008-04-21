From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Sun, 20 Apr 2008 19:08:07 -0700
Message-ID: <20080421020806.GL20138@linux.vnet.ibm.com>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:50525 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYDUCIN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2008 22:08:13 -0400
Content-Disposition: inline
In-Reply-To: <20080421011855.GA6243@gondor.apana.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 09:18:55AM +0800, Herbert Xu wrote:
> Hi Linus:
> 
> On Sun, Apr 20, 2008 at 02:31:48PM -0700, Linus Torvalds wrote:
> >
> > Talking about RCU I also think that whoever did those "rcu_dereference()" 
> > macros in <linux/list.h> was insane. It's totally pointless to do 
> > "rcu_dereference()" on a local variable. It simply *cannot* make sense. 
> > Herbert, Paul, you guys should look at it.
> 
> Since I made the macros look this way I'm obliged to defend it :)
> 
> >  #define list_for_each_rcu(pos, head) \
> > -	for (pos = (head)->next; \
> > -		prefetch(rcu_dereference(pos)->next), pos != (head); \
> > -        	pos = pos->next)
> > +	for (pos = rcu_dereference((head)->next); \
> > +		prefetch(pos->next), pos != (head); \
> > +        	pos = rcu_dereference(pos->next))
> 
> Semantically there should be no difference between the two versions.
> The purpose of rcu_dereference is really similar to smp_rmb, i.e.,
> it adds a (conditional) read barrier between what has been read so
> far (including its argument), and what will be read subsequently.
> 
> So if we expand out the current code it would look like
> 
> 	fetch (head)->next
> 	store into pos
> again:
> 	smp_read_barrier_depends()
> 	prefetch(pos->next)
> 	pos != (head)
> 
> 	...loop body...
> 
> 	fetch pos->next
> 	store into pos
> 	goto again
> 
> Yours looks like
> 
> 	fetch (head)->next
> 	smp_read_barrier_depends()
> 	store into pos
> again:
> 	prefetch(pos->next)
> 	pos != (head)
> 
> 	...loop body...
> 
> 	fetch pos->next
> 	smp_read_barrier_depends()
> 	store into pos
> 	goto again
> 
> As the objective here is to insert a barrier before dereferencing
> pos (e.g., reading pos->next or using it in the loop body), these
> two should be identical.
> 
> But I do concede that your version looks clearer, and has the
> benefit that should prefetch ever be optimised out with no side-
> effects, yours would still be correct while the current one will
> lose the barrier completely.

Agreed as well -- compilers would also be within their right to bypass
the rcu_dereference() around the test/prefetch, which would allow
them to refetch.  For example, with __list_for_each_rcu(), the original
implementation allows the compiler to treat a use of "pos" within the body
of the loop as if it was a use of (head)->next, refetching if convenient.
Not so good.

So good catch, Linus!!!

Could we also eliminate the (both unused in 2.6.25 and useless as
well) list_for_each_safe_rcu()?  After all, if you use list_del_rcu()
and call_rcu(), all the RCU list-traversal primitives are "safe" in
this sense.  Patch attached (testing in progress), based on Linus's
earlier patch.

Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 list.h |   47 +++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff -urpNa linux-2.6.25/include/linux/list.h linux-2.6.25-rcu-list/include/linux/list.h
--- linux-2.6.25/include/linux/list.h	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-rcu-list/include/linux/list.h	2008-04-20 18:44:55.000000000 -0700
@@ -631,31 +631,14 @@ static inline void list_splice_init_rcu(
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_rcu(pos, head) \
-	for (pos = (head)->next; \
-		prefetch(rcu_dereference(pos)->next), pos != (head); \
-        	pos = pos->next)
+	for (pos = rcu_dereference((head)->next); \
+		prefetch(pos->next), pos != (head); \
+        	pos = rcu_dereference(pos->next))
 
 #define __list_for_each_rcu(pos, head) \
-	for (pos = (head)->next; \
-		rcu_dereference(pos) != (head); \
-        	pos = pos->next)
-
-/**
- * list_for_each_safe_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, safe against removal of list entry.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_safe_rcu(pos, n, head) \
-	for (pos = (head)->next; \
-		n = rcu_dereference(pos)->next, pos != (head); \
-		pos = n)
+	for (pos = rcu_dereference((head)->next); \
+		pos != (head); \
+        	pos = rcu_dereference(pos->next))
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
@@ -668,10 +651,10 @@ static inline void list_splice_init_rcu(
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry((head)->next, typeof(*pos), member); \
-		prefetch(rcu_dereference(pos)->member.next), \
+	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
+		prefetch(pos->member.next), \
 			&pos->member != (head); \
-		pos = list_entry(pos->member.next, typeof(*pos), member))
+		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
 
 
 /**
@@ -686,9 +669,9 @@ static inline void list_splice_init_rcu(
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = (pos)->next; \
-		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
-        	(pos) = (pos)->next)
+	for ((pos) = rcu_dereference((pos)->next); \
+		prefetch((pos)->next), (pos) != (head); \
+        	(pos) = rcu_dereference((pos)->next))
 
 /*
  * Double linked lists with a single pointer list head.
@@ -986,10 +969,10 @@ static inline void hlist_add_after_rcu(s
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = (head)->first;					 \
-	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	 \
+	for (pos = rcu_dereference((head)->first);			 \
+	        ({ prefetch(pos->next); 1;}) &&				 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+	     pos = rcu_dereference(pos->next))
 
 #else
 #warning "don't include kernel headers in userspace"
