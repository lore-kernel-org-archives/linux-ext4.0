From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on
	32 bit architecture
Date: Tue, 07 Oct 2008 11:55:47 +0200
Message-ID: <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
References: <E1KmetO-00053M-5u@closure.thunk.org>
	 <20081006232322.c383fac5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753956AbYJGJ5A@vger.kernel.org>
In-Reply-To: <20081006232322.c383fac5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2008-10-06 at 23:23 -0700, Andrew Morton wrote:
> On Sun, 05 Oct 2008 21:28:10 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > The following patch has been sitting in the ext4 patch queue for about
> > six weeks.  It was there it was a suspected cause for block allocation
> > bug.  As I recall, it we found the true root cause since then, but this
> > has stuck around since it's a potential problem.  Andrew has expressed
> > concerns that this patch might have performance impacts.
> 
> Performace impacts I guess we'll just have to put up with.  iirc I was
> thinking that this implementation should be pushed down to a kernel-wide
> atomic64_t and then the percpu_counters would just use that type.

something like so?

or should I use a global seqlock hash table?

i386 could then do a version using cmpxchg8, although I'm not sure
that's a win, as I've heard thats an awefuly expensive op to use.

---
Subject: 
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Oct 07 11:52:37 CEST 2008

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-generic/atomic_64.h |  132 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

Index: linux-2.6/include/asm-generic/atomic_64.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/atomic_64.h
@@ -0,0 +1,132 @@
+#ifndef _ASM_GENERIC_ATOMIC64_H
+#define _ASM_GENERIC_ATOMIC64_H
+
+#include <linux/types.h>
+
+#if BITS_PER_LONG == 32
+
+#include <linux/seqlock.h>
+
+typedef struct {
+	s64 counter;
+	seqlock_t slock;
+} atomic64_t;
+
+ATOMIC64_INIT(i)	{ .counter = (i), .slock = __SEQLOCK_UNLOCKED(i.slock) }
+
+static inline s64 atomic64_read(atomic64_t *v)
+{
+	unsigned seq = read_seqbegin(&v->slock);
+	s64 val;
+
+	do {
+		val = v->counter;
+	} while (read_seqretry(&v->slock, seq));
+
+	return val;
+}
+
+static inline void atomic64_set(s64 i, atomic64_t *v)
+{
+	write_seqlock(&v->slock);
+	v->counter = i;
+	write_sequnlock(&v->slock);
+}
+
+static inline void atomic64_add(s64 i, atomic64_t *v)
+{
+	write_seqlock(&v->slock);
+	v->counter += i;
+	write_sequnlock(&v->slock);
+}
+
+static inline void atomic64_sub(s64 i, atomic64_t *v)
+{
+	write_seqlock(&v->slock);
+	v->counter -= i;
+	write_sequnlock(&v->slock);
+}
+
+static inline int atomic64_sub_and_test(s64 i, atomic64_t *v)
+{
+	int ret;
+
+	write_seqlock(&v->slock);
+	v->counter -= i;
+	ret = !v->counter;
+	write_sequnlock(&v->slock);
+
+	return ret;
+}
+
+static inline void atomic64_inc(atomic64_t *v)
+{
+	write_seqlock(&v->slock);
+	v->counter++;
+	write_sequnlock(&v->slock);
+}
+
+static inline void atomic64_dec(atomic64_t *v)
+{
+	write_seqlock(&v->slock);
+	v->counter--;
+	write_sequnlock(&v->slock);
+}
+
+static inline int atomic64_dec_and_test(atomic64_t *v)
+{
+	int ret;
+
+	write_seqlock(&v->slock);
+	v->counter--;
+	ret = !v->counter;
+	write_sequnlock(&v->slock);
+
+	return ret;
+}
+
+static inline int atomic64_add_and_test(atomic64_t *v)
+{
+	int ret;
+
+	write_seqlock(&v->slock);
+	v->counter++;
+	ret = !v->counter;
+	write_sequnlock(&v->slock);
+
+	return ret;
+}
+
+static inline int atomic64_add_negative(s64 i, atomic64_t *v)
+{
+	int ret;
+
+	write_seqlock(&v->slock);
+	v->counter += i;
+	ret = v->counter < 0;
+	write_sequnlock(&v->slock);
+
+	return ret;
+}
+
+static inline s64 atomic64_add_return(s64 i, atomic64_t *v)
+{
+	s64 val;
+
+	write_seqlock(&v->slock);
+	v->counter += i;
+	val = v->counter;
+	write_sequnlock(&v->slock);
+
+	return val;
+}
+
+static inline s64 atomic64_sub_return(s64 i, atomic64_t *v)
+{
+	return atomic64_add_return(-i, v);
+}
+
+#define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
+#define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
+
+#endif
