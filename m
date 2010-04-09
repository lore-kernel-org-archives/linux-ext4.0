From: john stultz <johnstul@us.ibm.com>
Subject: RE: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Fri, 09 Apr 2010 16:57:35 -0700
Message-ID: <1270857455.4704.21.camel@localhost.localdomain>
References: <1270682478.3755.58.camel@localhost.localdomain>
	 <87d3y8wrq5.fsf@basil.nowhere.org> <20100409233325.GF1849@thunk.org>
	 <EA929A9653AAE14F841771FB1DE5A1365FE4FCD4BC@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: "Chen, Tim C" <tim.c.chen@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:34177 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0DIX5n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2010 19:57:43 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o39Npe1u022700
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 17:51:40 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o39NvfFj132468
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 17:57:41 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o39NveSK004915
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 17:57:41 -0600
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1365FE4FCD4BC@rrsmsx501.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2010-04-09 at 17:48 -0600, Chen, Tim C wrote:
> 
> >tytso@mit.edu wrote 
> >
> >Yeah, I'm very much aware of that.  What worries me is that locking
> >problems in the jbd2 layer could be very hard to debug, so we need to
> >make sure we have some really good testing as we make any changes.
> >
> >Not taking the j_state_lock spinlock in jbd2_stop_lock() was relatively
> >easy to prove to be safe, but I'm really worried about
> >start_this_handle() the locking around that is going to be subtle, and
> >it's not just the specific fields in the transaction and journal
> >handle.
> >
> >And even with the jbd2_stop_lock() change, I'd really prefer some
> >pretty exhaustive testing, including power fail testing, just to make
> >sure we're in practice when/if we make more subtle or more invasive
> >changes to the jbd2 layer...
> >
> >So I'm mot waving the red flag, but the yellow flag (as they would say
> >in auto racing circles).
> >
> 
> Your patch did remove the contention on the j_state_lock for dbench
> in my testing with 64 threads.  The contention point now
> moves dcache_lock, which is also another tricky bottleneck.

Nick Piggin's vfs scalability patches takes care of the dcache_lock
contention. I'm actually using them with the -rt patch in my testing
here.


> In our other testing with FFSB that creates/rename/remove a lot of directories,
> we found that journal->j_revoke_lock was also heavily contended.

Yep. This also shows up in my -rt patch testing with Ted's patch.

thanks
-john


