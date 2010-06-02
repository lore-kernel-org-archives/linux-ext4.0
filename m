From: Eric Whitney <eric.whitney@hp.com>
Subject: j_state_lock patch data  (was: Re: ext4 dbench performance with CONFIG_PREEMPT_RT)
Date: Wed, 02 Jun 2010 18:35:21 -0400
Message-ID: <4C06DCA9.8090601@hp.com>
References: <1270682478.3755.58.camel@localhost.localdomain> <20100408034631.GB23188@thunk.org> <20100412194628.GI12238@atrey.karlin.mff.cuni.cz> <20100413145247.GO1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:34966 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab0FBWeP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 18:34:15 -0400
In-Reply-To: <20100413145247.GO1849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Weeks ago, Ted asked if someone would be willing to run Steven Pratt's 
and Keith Mannthey's ffsb filesystem workloads (as found at 
http://btrfs.boxacle.net) on a large system running a non-RT kernel with 
and without Ted's j_state_lock patch.  In a previous thread, John Stultz 
had identified the j_state_lock as an important scalability limiter for 
RT kernels running ext4 on 8 core systems.

Ted wanted lock_stats as well as performance data, and I've collected 
those on a 48 core x86-64 system running a 2.6.34 kernel.  (The 
j_state_lock patch is now in 2.6.35, and I'll try to collect fresh data 
in the near future.)

Since my test system was bigger than the system Keith has been using 
recently, I adjusted the thread counts, running 1, 48 (1 thread per 
core), and 192 (4 threads per core) ffsb threads in my version of his 
workloads.

The adjusted "boxacle" large_file_creates and random_writes workloads 
benefited significantly from the patch on my test configuration.  Three 
sets of uninstrumented runs for each workload yielded throughput results 
that were generally consistent and close to those obtained for the 
lock_stat runs.  (There were a few outliers - fewer than 10% of the 
total - that showed throughput declines of more than 50% from the rest 
of the runs.)

Using statistics taken in the lock_stat runs:

The ffsb transaction rate for large_file_create at 48 threads improved 
85% with the patch over the unmodified baseline, while the number of 
contentions dropped 29%.  At 192 threads, the transaction rate improved 
46%, and the number of contentions dropped 44%.

The ffsb transaction rate for random_writes at 48 threads improved 35% 
with the patch over the unmodified baseline, while the number of 
contentions dropped 8%.  At 192 threads, the transaction rate improved 
29%, and the number of contentions dropped 3%.

The single thread workloads and all versions of the mail_server workload 
were not materially affected by the patch.  (The remaining workloads are 
read-only, and also were not affected.)

On my test configuration, the lock_stats in the patched cases show the 
j_state_lock is still the most heavily contended, and the system is 
usually CPU-bound in system mode.

Detailed data for the large_file_create and random_write lock_stat runs, 
including lock_stats, vmstats, ffsb reports, logs, the patch, etc., can 
be found at:
http://free.linux.hp.com/~enw/jbd2scaling/2.6.34

At that location, there are four directories containing the detailed 
information for the four relevant lock_stat runs:
large-file-creates
large-file-creates.patched
random_writes
random_writes.patched

There are also a set of links at the top level to make it easier to 
compare lock_stat data without navigating through those directories - 
the names simply begin with "lock_stat".

The patch used is also there: j_state_lock.patch.txt

Test system configuration:

* 48 core x86-64 server (HP Proliant DL785) with 256 GB of memory
* One Fibre Channel-attached 4 Gb/second MSA2000 RAID controller
* Single 586 GB hardware RAID0 volume consisting of four disks
* e2fsprogs v1.41.11
* nobarrier mount option
* deadline I/O scheduler

Thanks to Steven and Keith for their workloads and benchmarking data.

Eric






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
> 
> Also, the spinlock code has a "ticket" system which tries to protect
> against the thundering hurd effect --- do the PI mutexes which replace
> spinlocks in the -rt kernel have any technqiue to try to prevent
> scheduler thrashing in the face of thundering hurd scenarios?
> 
> 	  	       	   	   - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
