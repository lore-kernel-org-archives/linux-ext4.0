From: tytso@mit.edu
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Thu, 8 Apr 2010 17:10:54 -0400
Message-ID: <20100408211054.GB1849@thunk.org>
References: <1270682478.3755.58.camel@localhost.localdomain>
 <20100408034631.GB23188@thunk.org>
 <1270759317.3373.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51424 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933038Ab0DHVLV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 17:11:21 -0400
Content-Disposition: inline
In-Reply-To: <1270759317.3373.7.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 08, 2010 at 01:41:57PM -0700, john stultz wrote:
> 
> I'll continue to play with your patch and see if I can con some some
> folks with more interesting storage setups to do some testing as well.

You might want to ask djwong to play with it with his nice big
machine.  (We don't need a big file system, but we want as many CPU's
as possible, and to use his "mailserver" workload to really stress the
journal.  I'd recommend using barrier=0 for additional journal
lock-level stress testing, and then try some forced sysrq-b reboots
and then make sure that the filesystem is consistent after the journal
replay.)

I've since done basic two-CPU testing using xfstests under KVM, but
that's really not going to test any locking issues.

> Any thoughts for ways to rework the state_lock in start_this_handle?
> (Now that its at the top of the contention logs? :)

That's going to be much harder.  We're going to have to take
j_state_lock at some point inside start_this_handle.  We might be able
to decrease the amount of code which is run while the spinlock is
taken, but I very much doubt it's possible to eliminate that spinlock
entirely.

Do you have detailed lockstat information showing the hold-time and
wait-time of j_lock_stat (especially in start_this_handle)?

						- Ted
