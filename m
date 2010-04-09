From: tytso@mit.edu
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Fri, 9 Apr 2010 19:33:26 -0400
Message-ID: <20100409233325.GF1849@thunk.org>
References: <1270682478.3755.58.camel@localhost.localdomain>
 <87d3y8wrq5.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: john stultz <johnstul@us.ibm.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>,
	tim.c.chen@intel.com
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34476 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab0DIXdi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Apr 2010 19:33:38 -0400
Content-Disposition: inline
In-Reply-To: <87d3y8wrq5.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 09, 2010 at 05:49:54PM +0200, Andi Kleen wrote:
> john stultz <johnstul@us.ibm.com> writes:
> >
> > Further using lockstat I was able to isolate it the contention down to
> > the journal j_state_lock, and then adding some lock owner tracking, I
> > was able to see that the lock owners were almost always in
> > start_this_handle, and jbd2_journal_stop when we saw contention (with
> > the freq breakdown being about 55% in jbd2_journal_stop and 45% in
> > start_this_handle).
> 
> FWIW we've been also seeing this on larger systems without RT.
> The journal locks are the number one contention in some workloads.
> So it's not just a RT problem.

Yeah, I'm very much aware of that.  What worries me is that locking
problems in the jbd2 layer could be very hard to debug, so we need to
make sure we have some really good testing as we make any changes.

Not taking the j_state_lock spinlock in jbd2_stop_lock() was relatively
easy to prove to be safe, but I'm really worried about
start_this_handle() the locking around that is going to be subtle, and
it's not just the specific fields in the transaction and journal
handle.

And even with the jbd2_stop_lock() change, I'd really prefer some
pretty exhaustive testing, including power fail testing, just to make
sure we're in practice when/if we make more subtle or more invasive
changes to the jbd2 layer...

So I'm mot waving the red flag, but the yellow flag (as they would say
in auto racing circles).

Regards,

						- Ted
