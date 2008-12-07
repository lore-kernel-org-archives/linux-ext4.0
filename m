From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sat, 6 Dec 2008 20:22:33 -0800
Message-ID: <20081206202233.3b74febc.akpm@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578AbYLGEXM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Dec 2008 23:23:12 -0500
In-Reply-To: <4936EB04.8000609@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Eric Dumazet a __crit :
> > Hi Andrew
> > 
> > While working on percpu_counter on net-next-2.6, I found
> > a CPU unplug race in percpu_counter_destroy()
> > 
> > (Very unlikely of course)
> > 
> > Thank you
> > 
> > [PATCH] percpu_counter: fix CPU unplug race in percpu_counter_destroy()
> > 
> > We should first delete the counter from percpu_counters list
> > before freeing memory, or a percpu_counter_hotcpu_callback()
> > could dereference a NULL pointer.
> > 
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > ---
> > lib/percpu_counter.c |    4 ++--
> > 1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> 
> Well, this percpu_counter stuff is simply not working at all.
> 
> We added some percpu_counters to network tree for 2.6.29 and we get
> drift bugs if calling __percpu_counter_sum() while some heavy duty
> benches are running, on a 8 cpus machine
> 
> 1) __percpu_counter_sum() is buggy, it should not write
> on per_cpu_ptr(fbc->counters, cpu), or another cpu
> could get its changes lost.
> 
> __percpu_counter_sum should be read only (const struct percpu_counter *fbc),
> and no locking needed.

No, we can't do this - it will break ext4.

Take a closer look at 1f7c14c62ce63805f9574664a6c6de3633d4a354 and at
e8ced39d5e8911c662d4d69a342b9d053eaaac4e.

I suggest that what we do is to revert both those changes.  We can
worry about the possibly-unneeded spin_lock later, in a separate patch.

It should have been a separate patch anyway.  It's conceptually
unrelated and is not a bugfix, but it was mixed in with a bugfix.

Mingming, this needs urgent consideration, please.  Note that I had to
make additional changes to ext4 due to the subsequent introduction of
the dirty_blocks counter.


Please read the below changelogs carefully and check that I have got my
head around this correctly - I may not have done.

What a mess.




From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit 1f7c14c62ce63805f9574664a6c6de3633d4a354
    Author: Mingming Cao <cmm@us.ibm.com>
    Date:   Thu Oct 9 12:50:59 2008 -0400

        percpu counter: clean up percpu_counter_sum_and_set()

Before this patch we had the following:

percpu_counter_sum(): return the percpu_counter's value

percpu_counter_sum_and_set(): return the percpu_counter's value, copying
that value into the central value and zeroing the per-cpu counters before
returning.

After this patch, percpu_counter_sum_and_set() has gone, and
percpu_counter_sum() gets the old percpu_counter_sum_and_set()
functionality.

Problem is, as Eric points out, the old percpu_counter_sum_and_set()
functionality was racy and wrong.  It zeroes out counters on "other" cpus,
without holding any locks which will prevent races agaist updates from
those other CPUS.

This patch reverts 1f7c14c62ce63805f9574664a6c6de3633d4a354.  This means
that percpu_counter_sum_and_set() still has the race, but
percpu_counter_sum() does not.

Note that this is not a simple revert - ext4 has since started using
percpu_counter_sum() for its dirty_blocks counter as well.


Note that this revert patch changes percpu_counter_sum() semantics. 

Before the patch, a call to percpu_counter_sum() will bring the counter's
central counter mostly up-to-date, so a following percpu_counter_read()
will return a close value.

After this patch, a call to percpu_counter_sum() will leave the counter's
central accumulator unaltered, so a subsequent call to
percpu_counter_read() can now return a significantly inaccurate result.

If there is any code in the tree which was introduced after
e8ced39d5e8911c662d4d69a342b9d053eaaac4e was merged, and which depends
upon the new percpu_counter_sum() semantics, that code will break.


Reported-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c               |    4 ++--
 include/linux/percpu_counter.h |   12 +++++++++---
 lib/percpu_counter.c           |    8 +++++---
 3 files changed, 16 insertions(+), 8 deletions(-)

diff -puN fs/ext4/balloc.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set
+++ a/fs/ext4/balloc.c
@@ -609,8 +609,8 @@ int ext4_has_free_blocks(struct ext4_sb_
 
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
-		free_blocks  = percpu_counter_sum(fbc);
-		dirty_blocks = percpu_counter_sum(dbc);
+		free_blocks  = percpu_counter_sum_and_set(fbc);
+		dirty_blocks = percpu_counter_sum_and_set(dbc);
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
diff -puN include/linux/percpu_counter.h~revert-percpu-counter-clean-up-percpu_counter_sum_and_set include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~revert-percpu-counter-clean-up-percpu_counter_sum_and_set
+++ a/include/linux/percpu_counter.h
@@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percp
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc);
+s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,13 +44,19 @@ static inline void percpu_counter_add(st
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
-	s64 ret = __percpu_counter_sum(fbc);
+	s64 ret = __percpu_counter_sum(fbc, 0);
 	return ret < 0 ? 0 : ret;
 }
 
+static inline s64 percpu_counter_sum_and_set(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum(fbc, 1);
+}
+
+
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
-	return __percpu_counter_sum(fbc);
+	return __percpu_counter_sum(fbc, 0);
 }
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
diff -puN lib/percpu_counter.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set lib/percpu_counter.c
--- a/lib/percpu_counter.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set
+++ a/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc)
+s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
 {
 	s64 ret;
 	int cpu;
@@ -62,9 +62,11 @@ s64 __percpu_counter_sum(struct percpu_c
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		*pcount = 0;
+		if (set)
+			*pcount = 0;
 	}
-	fbc->count = ret;
+	if (set)
+		fbc->count = ret;
 
 	spin_unlock(&fbc->lock);
 	return ret;
_




From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e
    Author: Mingming Cao <cmm@us.ibm.com>
    Date:   Fri Jul 11 19:27:31 2008 -0400

        percpu_counter: new function percpu_counter_sum_and_set


As described in

	revert "percpu counter: clean up percpu_counter_sum_and_set()"

the new percpu_counter_sum_and_set() is racy against updates to the
cpu-local accumulators on other CPUs.  Revert that change.

This means that ext4 will be slow again.  But correct.

Reported-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c               |    4 ++--
 include/linux/percpu_counter.h |   12 +++---------
 lib/percpu_counter.c           |    7 +------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff -puN fs/ext4/balloc.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set
+++ a/fs/ext4/balloc.c
@@ -609,8 +609,8 @@ int ext4_has_free_blocks(struct ext4_sb_
 
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
-		free_blocks  = percpu_counter_sum_and_set(fbc);
-		dirty_blocks = percpu_counter_sum_and_set(dbc);
+		free_blocks  = percpu_counter_sum_positive(fbc);
+		dirty_blocks = percpu_counter_sum_positive(dbc);
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
diff -puN include/linux/percpu_counter.h~revert-percpu_counter-new-function-percpu_counter_sum_and_set include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~revert-percpu_counter-new-function-percpu_counter_sum_and_set
+++ a/include/linux/percpu_counter.h
@@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percp
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
+s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,19 +44,13 @@ static inline void percpu_counter_add(st
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
-	s64 ret = __percpu_counter_sum(fbc, 0);
+	s64 ret = __percpu_counter_sum(fbc);
 	return ret < 0 ? 0 : ret;
 }
 
-static inline s64 percpu_counter_sum_and_set(struct percpu_counter *fbc)
-{
-	return __percpu_counter_sum(fbc, 1);
-}
-
-
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
-	return __percpu_counter_sum(fbc, 0);
+	return __percpu_counter_sum(fbc);
 }
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
diff -puN lib/percpu_counter.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set lib/percpu_counter.c
--- a/lib/percpu_counter.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set
+++ a/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -62,12 +62,7 @@ s64 __percpu_counter_sum(struct percpu_c
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		if (set)
-			*pcount = 0;
 	}
-	if (set)
-		fbc->count = ret;
