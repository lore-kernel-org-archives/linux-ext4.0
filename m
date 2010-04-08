From: john stultz <johnstul@us.ibm.com>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Thu, 08 Apr 2010 13:41:57 -0700
Message-ID: <1270759317.3373.7.camel@localhost.localdomain>
References: <1270682478.3755.58.camel@localhost.localdomain>
	 <20100408034631.GB23188@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:32953 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869Ab0DHUmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 16:42:04 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e8.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o38KWvmS021897
	for <linux-ext4@vger.kernel.org>; Thu, 8 Apr 2010 16:32:57 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o38Kg2oZ1699874
	for <linux-ext4@vger.kernel.org>; Thu, 8 Apr 2010 16:42:02 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o38Kg1QP016088
	for <linux-ext4@vger.kernel.org>; Thu, 8 Apr 2010 16:42:02 -0400
In-Reply-To: <20100408034631.GB23188@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-04-07 at 23:46 -0400, tytso@mit.edu wrote:
> On Wed, Apr 07, 2010 at 04:21:18PM -0700, john stultz wrote:
> > Further using lockstat I was able to isolate it the contention down to
> > the journal j_state_lock, and then adding some lock owner tracking, I
> > was able to see that the lock owners were almost always in
> > start_this_handle, and jbd2_journal_stop when we saw contention (with
> > the freq breakdown being about 55% in jbd2_journal_stop and 45% in
> > start_this_handle).
> 
> Hmm....  I've taken a very close look at jbd2_journal_stop(), and I
> don't think we need to take j_state_lock() at all except if we need to
> call jbd2_log_start_commit().  t_outstanding_credits,
> h_buffer_credits, and t_updates are all documented (and verified by
> me) to be protected by the t_handle_lock spinlock.
> 
> So I ***think*** the following might be safe.  WARNING!  WARNING!!  No
> real testing done on this patch, other than "it compiles!  ship it!!".
> 
> I'll let other people review it, and maybe you could give this a run
> and see what happens with this patch?


So this patch seems to match the performance and has similar perf log
output to what I was getting with my hack. 

Very very cool!

I'll continue to play with your patch and see if I can con some some
folks with more interesting storage setups to do some testing as well.

Any thoughts for ways to rework the state_lock in start_this_handle?
(Now that its at the top of the contention logs? :)

thanks so much!
-john





