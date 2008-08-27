From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
Date: Wed, 27 Aug 2008 23:01:52 +0200
Message-ID: <1219870912.6395.45.camel@twins>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080827120553.9c9d6690.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:12905 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754657AbYH0VCH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 17:02:07 -0400
In-Reply-To: <20080827120553.9c9d6690.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-08-27 at 12:05 -0700, Andrew Morton wrote:
> On Wed, 27 Aug 2008 20:58:26 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > fbc->count is of type s64. The change was introduced by
> > 0216bfcffe424a5473daa4da47440881b36c1f4 which changed the type
> > from long to s64. Moving to s64 also means on 32 bit architectures
> > we can get wrong values on fbc->count. Since fbc->count is read
> > more frequently and updated rarely use seqlocks. This should
> > reduce the impact of locking in the read path for 32bit arch.
> > 
> 
> So...  yesterday's suggestionm to investigate implementing this at a
> lower level wasn't popular?

I think its a good idea to investigate a generic atomic64_t type.

i386 could possibly use cmpxchg8 if and when available, although using
that to read might be rather too expensive.

Doing something like:

struct atomic64_t {
	seqlock_t lock;
	s64 val;
};

might be somewhat unexpected from the sizeof() angle of things. Then
there is of course the possiblity of hashing the locks...



> >  include/linux/percpu_counter.h |   28 ++++++++++++++++++++++++----
> >  lib/percpu_counter.c           |   20 ++++++++++----------
> >  2 files changed, 34 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> > index 9007ccd..1b711a1 100644
> > --- a/include/linux/percpu_counter.h
> > +++ b/include/linux/percpu_counter.h
> > @@ -6,7 +6,7 @@
> >   * WARNING: these things are HUGE.  4 kbytes per counter on 32-way P4.
> >   */
> >  
> > -#include <linux/spinlock.h>
> > +#include <linux/seqlock.h>
> >  #include <linux/smp.h>
> >  #include <linux/list.h>
> >  #include <linux/threads.h>
> > @@ -16,7 +16,7 @@
> >  #ifdef CONFIG_SMP
> >  
> >  struct percpu_counter {
> > -	spinlock_t lock;
> > +	seqlock_t lock;
> >  	s64 count;
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  	struct list_head list;	/* All percpu_counters are on a list */
> > @@ -53,10 +53,30 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
> >  	return __percpu_counter_sum(fbc);
> >  }
> >  
> > -static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> > +#if BITS_PER_LONG == 64
> > +static inline s64 fbc_count(struct percpu_counter *fbc)
> >  {
> >  	return fbc->count;
> >  }
> > +#else
> > +/* doesn't have atomic 64 bit operation */
> > +static inline s64 fbc_count(struct percpu_counter *fbc)
> > +{
> > +	s64 ret;
> > +	unsigned seq;
> > +	do {
> > +		seq = read_seqbegin(&fbc->lock);
> > +		ret = fbc->count;
> > +	} while (read_seqretry(&fbc->lock, seq));
> > +	return ret;
> > +
> 
> Please don't put unneeded blank lines into random places.
> 
> > +}
> > +#endif
> 
> This is now too large to be inlined.
> 
> > +static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> > +{
> > +	return fbc_count(fbc);
> > +}
> 
> This change means that a percpu_counter_read() from interrupt context
> on a 32-bit machine is now deadlockable, whereas it previously was not
> deadlockable on either 32-bit or 64-bit.
> 
> This flows on to the lib/proportions.c, which uses
> percpu_counter_read() and also does spin_lock_irqsave() internally,
> indicating that it is (or was) designed to be used in IRQ contexts.

percpu_counter() never was irq safe, which is why the proportion stuff
does all the irq disabling bits by hand.

> It means that bdi_stat() can no longer be used from interrupt context.

Actually, as long as the write side of the seqlock usage is done with
IRQs disabled, the read side should be good.

If the read loop gets preempted by a write action, the seq count will
not match up and we'll just try again.

The only lethal combination is trying to do the read loop while inside
the write side.

If you look at backing-dev.h, you'll see that all modifying operations
disable IRQs.

> So a whole lot of thought and review and checking is needed here.  It
> should all be spelled out in the changelog.  This will be a horridly
> rare deadlock, so suitable WARN_ON()s should be added to detect when
> callers are vulnerable to it.
> 
> Or we make the whole thing irq-safe.

That'd rather substantially penalize those cases where we don't need it.
>From what I understood this whole pushf/popf stuff is insanely expensive
on a few archs.

