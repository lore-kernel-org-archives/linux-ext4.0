From: john stultz <johnstul@us.ibm.com>
Subject: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Wed, 07 Apr 2010 16:21:18 -0700
Message-ID: <1270682478.3755.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Darren Hart <dvhltc@us.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:34190 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0DGXVY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 19:21:24 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o37NEPje016134
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:14:25 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o37NLNwM018338
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:21:23 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o37NLMpN019581
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:21:23 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've recently been working on scalability issues with the PREEMPT_RT
kernel patch, and one area I've hit has been ext4 journal j_state_lock
contention.

With the PREEMPT_RT kernel, most spinlocks become pi-aware mutexes, so
they sleep when the lock cannot be acquired. This means lock contention
has a *much* greater impact on the PREEMPT_RT kernel then mainline. Thus
scalability issues hit the PREEMPT_RT kernel at lower cpu counts then
mainline.

Now, you might not care about PREEMPT_RT, but consider that any lock
contention will get worse in mainline as the cpu count increases. So in
this way, the PREEMPT_RT kernel allows us to see what scalability issues
are on the horizon for mainline kernels running on larger systems.

When running dbench on ext4 with the -rt kernel, I saw a fairly severe
performance drop off (~-60%) going from 4 to 8 clients (on an 8 cpu
machine).

Looking at the perf log, I could see there was quite a bit of lock
contention in the jdb2 start_This_handle/jbd2_journal_stop code paths:

27.39%       dbench  [kernel]                    [k] _raw_spin_lock_irqsave
                |          
                |--90.91%-- rt_spin_lock_slowlock
                |          rt_spin_lock
                |          |          
                |          |--66.92%-- start_this_handle
                |          |          jbd2_journal_start
                |          |          ext4_journal_start_sb
                |          |          |          
... 
                |          |          
                |          |--32.31%-- jbd2_journal_stop
                |          |          __ext4_journal_stop
                |          |          |          
                |          |          |--92.86%-- ext4_da_write_end
                |          |          |          generic_file_buffered_write

Full perf log here:
http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.33/linux-2.6.33-rt11-vfs-ext4-8cpu.log

The perf logs for mainline showed similar contention, but at 8 cpus it
was not severe enough to drastically hurt performance in the same way.

Further using lockstat I was able to isolate it the contention down to
the journal j_state_lock, and then adding some lock owner tracking, I
was able to see that the lock owners were almost always in
start_this_handle, and jbd2_journal_stop when we saw contention (with
the freq breakdown being about 55% in jbd2_journal_stop and 45% in
start_this_handle).


Now, I'm very new to this code, and I don't fully understand the locking
rules. There is some documentation in the journal_s structure about
what's protected by the j_state_lock, but I'm not sure if its 100%
correct or not. 

For the most part, in jbd2_jorunal_stop we're only reading values in the
journal_t struct, so throwing caution to the wind, I simply removed the
locking there (trying to be careful in the one case of a structure write
to use cmpxchg so its sort of an atomic write).

Doing this more then doubled performance (2.5x increase).

Now, I know its terribly terribly wrong, in probably more ways then I
imagine, and I'm in no way suggesting this "locks are for data integrity
nerds, look at this performance!" mentality is valid. But it does show
exactly where contention is hurting us, and maybe what is possibly
achievable if we can rework some of the locking here.


The terrible terrible disk-eating* patch can be found here:
http://sr71.net/~jstultz/dbench-scalability/patches/2.6.33-ext4-hack/state_lock_hack.patch

Here's a chart comparing 2.6.33 vs 2.6.33-rt11-vfs  both with and
without the terrible terrible disk-eating* locking hack:
http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33-ext4-hack/2.6.33-ext4-hack.png


All the perf logs for the 4 cases above:
http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.33-ext4-hack/


As you can see in the charts, the hack doesn't seem to give any benefit
to mainline at only 8 cpus, but looking at the perf logs it does seem to
lower the overhead of the journal code.

The charts also show that start_this_handle still sees some contention
so there is still more gains to be had by reworking the j_state_lock.


So questions from there are:
1) Some of the values protected by the j_state_lock are protected only
for quick modification or reading. Could these be converted to a
atomic_t? If not, why?

2) Alternatively can some of the values protected by the j_state_lock
which seem to be mostly read type values be converted to something like
a seq_lock? Again, I'm looking more for the locking dependency reasons
then just yes or no.

3) Is RCU too crazy for filesystems?


If there's any better documentation on the locking rules here, I'd also
appreciate a pointer.

Any other thoughts or feedback would be greatly appreciated.

thanks
-john

* No disks were actually eaten in the creation of this data. The patch
actually ran fine the whole time, but that said, DON'T TRY IT AT HOME!

