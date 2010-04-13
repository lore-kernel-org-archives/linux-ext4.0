From: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Tue, 13 Apr 2010 09:25:24 -0700
Message-ID: <4BC49AF4.2080805@us.ibm.com>
References: <1270682478.3755.58.camel@localhost.localdomain> <20100408034631.GB23188@thunk.org> <20100412194628.GI12238@atrey.karlin.mff.cuni.cz> <20100413145247.GO1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, john stultz <johnstul@us.ibm.com>,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:49696 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0DMQZd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 12:25:33 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3DGITr1002003
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 10:18:29 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3DGPVwJ146146
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 10:25:31 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3DGPRKM001189
	for <linux-ext4@vger.kernel.org>; Tue, 13 Apr 2010 10:25:28 -0600
In-Reply-To: <20100413145247.GO1849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Mon, Apr 12, 2010 at 09:46:28PM +0200, Jan Kara wrote:
>>   I also had a look at jbd2_journal_start. What probably makes
>> things bad there is that lots of threads accumulate waiting for
>> transaction to get out of T_LOCKED state. When that happens, all the
>> threads are woken up and start pondering at j_state_lock which
>> creates contention. This is just a theory and I might be completely
>> wrong... Some lockstat data would be useful to confirm / refute
>> this.
> 
> Yeah, that sounds right.  We do have a classic thundering hurd problem
> when we while are draining handles from the transaction in the
> T_LOCKED state --- that is (for those who aren't jbd2 experts) when it
> comes time to close out the current transaction, one of the first
> things that fs/jbd2/commit.c will do is to set the transaction into
> T_LOCKED state.  In that state we are waiting for currently active
> handles to complete, and we don't allow any new handles to start until
> the currently running transaction is completely drained of active
> handles, at which point we can swap in a new transaction, and continue
> the commit process on the previously running transaction.
> 
> On a non-real time kernel, the spinlock will tie up the currently
> running CPU's until the transaction drains, which is usually pretty
> fast, since we don't allow transactions to be held for that long (the
> worst case being truncate/unlink operations).  Dbench is a worst case,
> though since we have some large number of threads all doing file
> system I/O (John, how was dbench configured?) and the spinlocks will
> no longer tie up a CPU, but actually let some other dbench thread run,
> so it magnifies the thundering hurd problem from 8 threads, to nearly
> all of the CPU threads.


I didn't follow that part - how will dbench prevent threads from 
spinning on a spinlock and instead allow other dbench threads to run?

> 
> Also, the spinlock code has a "ticket" system which tries to protect
> against the thundering hurd effect --- do the PI mutexes which replace
> spinlocks in the -rt kernel have any technqiue to try to prevent
> scheduler thrashing in the face of thundering hurd scenarios?

Nothing specific per-se, however, being a blocking lock, it will put all 
those locks to sleep and then wake them in priority fifo order as the 
lock becomes available. Unless dbench is being run with various priority 
levels (I don't think John is doing that) then the PI part won't really 
come into play. If we were, then we would see some more scheduling 
overhead as high prio tasks became available, blocked on the lock, 
boosted the owner, which then would get scheduled to release the lock, 
then the high prio task would schedule back in - but that isn't the case 
here.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
