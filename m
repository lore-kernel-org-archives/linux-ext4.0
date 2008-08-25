From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -v2] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
Date: Mon, 25 Aug 2008 19:35:18 +0530
Message-ID: <20080825140518.GA7391@skywalker>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219663639.8515.47.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57872 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754851AbYHYOFp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 10:05:45 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7PE5PdT014791
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 19:35:25 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PE5PXL1663038
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 19:35:25 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7PE5OnU019539
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 19:35:25 +0530
Content-Disposition: inline
In-Reply-To: <1219663639.8515.47.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 25, 2008 at 01:27:19PM +0200, Peter Zijlstra wrote:
> On Mon, 2008-08-25 at 16:50 +0530, Aneesh Kumar K.V wrote:
> > fbc->count is of type s64. The change was introduced by
> > 0216bfcffe424a5473daa4da47440881b36c1f4 which changed the type
> > from long to s64. Moving to s64 also means on 32 bit architectures
> > we can get wrong values on fbc->count. Since fbc->count is read
> > more frequently and updated rarely use seqlocks. This should
> > reduce the impact of locking in the read path for 32bit arch.
> > 
> > percpu_counter_read is used within interrupt context also. So
> > use the irq safe version of seqlock while reading
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  include/linux/percpu_counter.h |   29 +++++++++++++++++++++++++----
> >  lib/percpu_counter.c           |   20 ++++++++++----------
> >  2 files changed, 35 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> > index 9007ccd..36f3d2d 100644
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
> > @@ -53,10 +53,31 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
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
> > +	unsigned long flags;
> > +	do {
> > +		seq = read_seqbegin_irqsave(&fbc->lock, flags);
> > +		ret = fbc->count;
> > +	} while(read_seqretry_irqrestore(&fbc->lock, seq, flags));
> 
> Do we really need to disabled IRQs here? It seems to me the worst that
> can happen is that the IRQ will change ->count and increase the sequence
> number a bit - a case that is perfectly handled by the current retry
> logic.
> 
> And not doing the IRQ flags bit saves a lot of time on some archs.
> 

Will update in the next version. BTW does it make sense to do
the above unconditionally now ? ie to remove the #if ?. How much
impact would it be to do read_seqbegin and read_seqretry on a 64bit
machine too ?

-aneesh
