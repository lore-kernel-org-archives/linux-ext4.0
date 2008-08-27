From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
 on 32 bit architecture
Date: Wed, 27 Aug 2008 14:22:50 -0700
Message-ID: <20080827142250.7397a1a7.akpm@linux-foundation.org>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20080827120553.9c9d6690.akpm@linux-foundation.org>
	<1219870912.6395.45.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYH0VY1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2008 17:24:27 -0400
In-Reply-To: <1219870912.6395.45.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 27 Aug 2008 23:01:52 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > 
> > > +static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> > > +{
> > > +	return fbc_count(fbc);
> > > +}
> > 
> > This change means that a percpu_counter_read() from interrupt context
> > on a 32-bit machine is now deadlockable, whereas it previously was not
> > deadlockable on either 32-bit or 64-bit.
> > 
> > This flows on to the lib/proportions.c, which uses
> > percpu_counter_read() and also does spin_lock_irqsave() internally,
> > indicating that it is (or was) designed to be used in IRQ contexts.
> 
> percpu_counter() never was irq safe, which is why the proportion stuff
> does all the irq disabling bits by hand.

percpu_counter_read() was irq-safe.  That changes here.  Needs careful
review, changelogging and, preferably, runtime checks.  But perhaps
they should be inside some CONFIG_thing which won't normally be done in
production.

otoh, percpu_counter_read() is in fact a rare operation, so a bit of
overhead probably won't matter.

(write-often, read-rarely is the whole point.  This patch's changelog's
assertion that "Since fbc->count is read more frequently and updated
rarely" is probably wrong.  Most percpu_counters will have their
fbc->count modified far more frequently than having it read from).

> > It means that bdi_stat() can no longer be used from interrupt context.
> 
> Actually, as long as the write side of the seqlock usage is done with
> IRQs disabled, the read side should be good.

yup.

> If the read loop gets preempted by a write action, the seq count will
> not match up and we'll just try again.
>
> The only lethal combination is trying to do the read loop while inside
> the write side.

yup
 
> If you look at backing-dev.h, you'll see that all modifying operations
> disable IRQs.

OK.

> > So a whole lot of thought and review and checking is needed here.  It
> > should all be spelled out in the changelog.  This will be a horridly
> > rare deadlock, so suitable WARN_ON()s should be added to detect when
> > callers are vulnerable to it.
> > 
> > Or we make the whole thing irq-safe.
> 
> That'd rather substantially penalize those cases where we don't need it.
> >From what I understood this whole pushf/popf stuff is insanely expensive
> on a few archs.

Sure.  I _expect_ that this interface change won't actually break
anything.  But it adds a restriction which we should think about, and
document.



btw, what the heck is percpu_counter_init_irq()?  Some mysterious
lockdep-specific thing?

<does git-fiddle.  Oh.  crappy changelog.>

I let that one leak through uncommented.  Must be getting old. 
Probably it will need an EXPORT_SYMBOL() sometime.


I expect that if we're going to go ahead and make percpu_counter_read()
no longer usable from interrupt context then we'll eventually end up
needing the full suite of _irq() and _irqsave() interface functions. 
percpu_counter_add_irqsave(), etc.
