From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
Date: Thu, 28 Aug 2008 09:22:00 +0530
Message-ID: <20080828035200.GB6440@skywalker>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080827120553.9c9d6690.akpm@linux-foundation.org> <1219870912.6395.45.camel@twins> <20080827142250.7397a1a7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, cmm@us.ibm.com,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41586 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYH1DwL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 23:52:11 -0400
Content-Disposition: inline
In-Reply-To: <20080827142250.7397a1a7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2008 at 02:22:50PM -0700, Andrew Morton wrote:
> On Wed, 27 Aug 2008 23:01:52 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > 
> > > > +static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> > > > +{
> > > > +	return fbc_count(fbc);
> > > > +}
> > > 
> > > This change means that a percpu_counter_read() from interrupt context
> > > on a 32-bit machine is now deadlockable, whereas it previously was not
> > > deadlockable on either 32-bit or 64-bit.
> > > 
> > > This flows on to the lib/proportions.c, which uses
> > > percpu_counter_read() and also does spin_lock_irqsave() internally,
> > > indicating that it is (or was) designed to be used in IRQ contexts.
> > 
> > percpu_counter() never was irq safe, which is why the proportion stuff
> > does all the irq disabling bits by hand.
> 
> percpu_counter_read() was irq-safe.  That changes here.  Needs careful
> review, changelogging and, preferably, runtime checks.  But perhaps
> they should be inside some CONFIG_thing which won't normally be done in
> production.
> 
> otoh, percpu_counter_read() is in fact a rare operation, so a bit of
> overhead probably won't matter.
> 
> (write-often, read-rarely is the whole point.  This patch's changelog's
> assertion that "Since fbc->count is read more frequently and updated
> rarely" is probably wrong.  Most percpu_counters will have their
> fbc->count modified far more frequently than having it read from).

we may actually be doing percpu_counter_add. But that doesn't update
fbc->count. Only if the local percpu values cross FBC_BATCH we update
fbc->count. If we are modifying fbc->count more frequently than
reading fbc->count then i guess we would be contenting of fbc->lock more.


-aneesh
