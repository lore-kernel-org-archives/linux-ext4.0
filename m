From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH -v2] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
Date: Mon, 25 Aug 2008 16:21:34 +0200
Message-ID: <1219674094.8515.62.camel@twins>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219663639.8515.47.camel@twins>  <20080825140518.GA7391@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:53130 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753292AbYHYOVo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 10:21:44 -0400
Received: from edge05.upc.biz ([192.168.13.212]) by viefep20-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080825142136.KNUA18311.viefep20-int.chello.at@edge05.upc.biz>
          for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:21:36 +0200
In-Reply-To: <20080825140518.GA7391@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-08-25 at 19:35 +0530, Aneesh Kumar K.V wrote:
> On Mon, Aug 25, 2008 at 01:27:19PM +0200, Peter Zijlstra wrote:
> > On Mon, 2008-08-25 at 16:50 +0530, Aneesh Kumar K.V wrote:

> > > @@ -53,10 +53,31 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
> > >  	return __percpu_counter_sum(fbc);
> > >  }
> > >  
> > > -static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> > > +#if BITS_PER_LONG == 64
> > > +static inline s64 fbc_count(struct percpu_counter *fbc)
> > >  {
> > >  	return fbc->count;
> > >  }
> > > +#else
> > > +/* doesn't have atomic 64 bit operation */
> > > +static inline s64 fbc_count(struct percpu_counter *fbc)
> > > +{
> > > +	s64 ret;
> > > +	unsigned seq;
> > > +	unsigned long flags;
> > > +	do {
> > > +		seq = read_seqbegin_irqsave(&fbc->lock, flags);
> > > +		ret = fbc->count;
> > > +	} while(read_seqretry_irqrestore(&fbc->lock, seq, flags));
> > 
> > Do we really need to disabled IRQs here? It seems to me the worst that
> > can happen is that the IRQ will change ->count and increase the sequence
> > number a bit - a case that is perfectly handled by the current retry
> > logic.
> > 
> > And not doing the IRQ flags bit saves a lot of time on some archs.
> > 
> 
> Will update in the next version. BTW does it make sense to do
> the above unconditionally now ? ie to remove the #if ?. How much
> impact would it be to do read_seqbegin and read_seqretry on a 64bit
> machine too ?

there's a few smp_rmb()s in there - so that will at the very least be a
compiler barrier and thus generate slightly worse code along with the
few extra reads.

But I'm not sure that's measurable..

