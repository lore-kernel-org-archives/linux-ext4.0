From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on
	32 bit architecture
Date: Tue, 07 Oct 2008 19:22:20 +0200
Message-ID: <1223400140.26330.76.camel@lappy.programming.kicks-ass.net>
References: <E1KmetO-00053M-5u@closure.thunk.org>
	 <20081006232322.c383fac5.akpm@linux-foundation.org>
	 <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
	 <48EB97B2.3010406@rsk.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: richard kennedy <richard@rsk.demon.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYJGRWq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 13:22:46 -0400
In-Reply-To: <48EB97B2.3010406@rsk.demon.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-10-07 at 18:09 +0100, richard kennedy wrote:
> Peter Zijlstra wrote:
> .....
> > +static inline int atomic64_dec_and_test(atomic64_t *v)
> > +{
> > +	int ret;
> > +
> > +	write_seqlock(&v->slock);
> > +	v->counter--;
> > +	ret = !v->counter;
> > +	write_sequnlock(&v->slock);
> > +
> > +	return ret;
> > +}
> > +
> > +static inline int atomic64_add_and_test(atomic64_t *v)
> > +{
> > +	int ret;
> > +
> > +	write_seqlock(&v->slock);
> > +	v->counter++;
> > +	ret = !v->counter;
> > +	write_sequnlock(&v->slock);
> > +
> > +	return ret;
> > +}
> would it be more logical to call this atomic64_inc_and_test to match the
> above dec_and_test ?

Yeah, I know of at least 2 other bugs in here, but I wanted some real
early feedback :-)

