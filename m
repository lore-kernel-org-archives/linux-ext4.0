From: tytso@mit.edu
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Tue, 13 Apr 2010 10:52:47 -0400
Message-ID: <20100413145247.GO1849@thunk.org>
References: <1270682478.3755.58.camel@localhost.localdomain>
 <20100408034631.GB23188@thunk.org>
 <20100412194628.GI12238@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: john stultz <johnstul@us.ibm.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49767 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab0DND4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Apr 2010 23:56:46 -0400
Content-Disposition: inline
In-Reply-To: <20100412194628.GI12238@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 12, 2010 at 09:46:28PM +0200, Jan Kara wrote:
>   I also had a look at jbd2_journal_start. What probably makes
> things bad there is that lots of threads accumulate waiting for
> transaction to get out of T_LOCKED state. When that happens, all the
> threads are woken up and start pondering at j_state_lock which
> creates contention. This is just a theory and I might be completely
> wrong... Some lockstat data would be useful to confirm / refute
> this.

Yeah, that sounds right.  We do have a classic thundering hurd problem
when we while are draining handles from the transaction in the
T_LOCKED state --- that is (for those who aren't jbd2 experts) when it
comes time to close out the current transaction, one of the first
things that fs/jbd2/commit.c will do is to set the transaction into
T_LOCKED state.  In that state we are waiting for currently active
handles to complete, and we don't allow any new handles to start until
the currently running transaction is completely drained of active
handles, at which point we can swap in a new transaction, and continue
the commit process on the previously running transaction.

On a non-real time kernel, the spinlock will tie up the currently
running CPU's until the transaction drains, which is usually pretty
fast, since we don't allow transactions to be held for that long (the
worst case being truncate/unlink operations).  Dbench is a worst case,
though since we have some large number of threads all doing file
system I/O (John, how was dbench configured?) and the spinlocks will
no longer tie up a CPU, but actually let some other dbench thread run,
so it magnifies the thundering hurd problem from 8 threads, to nearly
all of the CPU threads.

Also, the spinlock code has a "ticket" system which tries to protect
against the thundering hurd effect --- do the PI mutexes which replace
spinlocks in the -rt kernel have any technqiue to try to prevent
scheduler thrashing in the face of thundering hurd scenarios?

	  	       	   	   - Ted
