From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
	ffffffffffffffff
Date: Mon, 21 Apr 2008 15:00:22 +0200
Message-ID: <20080421130022.GH9554@elte.hu>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com> <20080421045911.GA1812@linux.vnet.ibm.com> <20080421054729.GA19864@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758637AbYDUNBM@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080421054729.GA19864@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sun, Apr 20, 2008 at 09:59:11PM -0700, Paul E. McKenney wrote:
> > And here is an update with one bug fixed -- testing continues.
> > This is an update of http://lkml.org/lkml/2008/4/20/217, deleting
> > list_for_each_safe_rcu() and fixing hlist_for_each_entry_rcu().
> > Testing continues...
> 
> And it passes.

i have queued up your patch in its form below. (but Linus might beat me 
at applying it)

	Ingo

-------------------->
Subject: RCU, list.h: fix list iterators
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 20 Apr 2008 21:59:13 -0700

RCU list iterators: should prefetch ever be optimised out with no
side-effects, the current version will lose the barrier completely.

Pointed-out-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/list.h |   48 +++++++++++++++---------------------------------
 1 file changed, 15 insertions(+), 33 deletions(-)
 
Index: linux/include/linux/list.h
===================================================================
--- linux.orig/include/linux/list.h
+++ linux/include/linux/list.h
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
@@ -668,10 +651,9 @@ static inline void list_splice_init_rcu(
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry((head)->next, typeof(*pos), member); \
-		prefetch(rcu_dereference(pos)->member.next), \
-			&pos->member != (head); \
-		pos = list_entry(pos->member.next, typeof(*pos), member))
+	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
+		prefetch(pos->member.next), &pos->member != (head); \
+		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
 
 
 /**
@@ -686,9 +668,9 @@ static inline void list_splice_init_rcu(
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
@@ -986,10 +968,10 @@ static inline void hlist_add_after_rcu(s
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = (head)->first;					 \
-	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	 \
+	for (pos = rcu_dereference((head)->first);			 \
+	        pos && ({ prefetch(pos->next); 1;}) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+	     pos = rcu_dereference(pos->next))
 
 #else
 #warning "don't include kernel headers in userspace"
