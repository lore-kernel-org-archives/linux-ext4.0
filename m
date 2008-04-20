From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Sun, 20 Apr 2008 14:31:48 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754992AbYDTVd2@vger.kernel.org>
In-Reply-To: <200804202104.24037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Sun, 20 Apr 2008, Rafael J. Wysocki wrote:
> 
> I've just got the following traces from 2.6.25-git2 on HP nx6325 (64-bit).
> I think they are related to the hang I described yesterday:
> 
> [12844.066757] BUG: unable to handle kernel paging request at ffffffffffffffff

Something has added a dentry pointer that has the value -1 to the dentry 
hash list. The access that oopses seems to be the

	prefetch(pos->next)

which is part of hlist_for_each_entry_rcu(), where "pos" is -1.

I suspect it's an RCU error, ie somebody has released a dentry entry, and 
free'd it without waiting for the RCU grace period.

Talking about RCU I also think that whoever did those "rcu_dereference()" 
macros in <linux/list.h> was insane. It's totally pointless to do 
"rcu_dereference()" on a local variable. It simply *cannot* make sense. 
Herbert, Paul, you guys should look at it.

As far as I can tell, rcu_dereference() should _always_ be done when we 
access the "next" pointer (except for when prefetching, where we simply 
don't care).

Paul? Herbert? Totally untested patch appended.

NOTE! I do not expect this patch to matter for this oops. There's 
something else going on there.

		Linus

---
 include/linux/list.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 75ce2cb..4a851ba 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -631,14 +631,14 @@ static inline void list_splice_init_rcu(struct list_head *list,
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
+	for (pos = rcu_dereference((head)->next); \
+		pos != (head); \
+        	pos = rcu_dereference(pos->next))
 
 /**
  * list_for_each_safe_rcu
@@ -653,8 +653,8 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_safe_rcu(pos, n, head) \
-	for (pos = (head)->next; \
-		n = rcu_dereference(pos)->next, pos != (head); \
+	for (pos = rcu_dereference((head)->next); \
+		n = rcu_dereference((pos)->next), pos != (head); \
 		pos = n)
 
 /**
@@ -668,10 +668,10 @@ static inline void list_splice_init_rcu(struct list_head *list,
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
@@ -686,9 +686,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
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
@@ -986,10 +986,10 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
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
