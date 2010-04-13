From: john stultz <johnstul@us.ibm.com>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Mon, 12 Apr 2010 20:52:57 -0700
Message-ID: <1271130777.3469.18.camel@localhost.localdomain>
References: <1270682478.3755.58.camel@localhost.localdomain>
	 <20100408034631.GB23188@thunk.org>
	 <1270759317.3373.7.camel@localhost.localdomain>
	 <20100408211054.GB1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37364 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0DMDxC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 23:53:02 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e2.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3D3flIq001907
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 23:41:47 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3D3r2GR160536
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 23:53:02 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3D3r13D030926
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 23:53:02 -0400
In-Reply-To: <20100408211054.GB1849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-04-08 at 17:10 -0400, tytso@mit.edu wrote:
> > Any thoughts for ways to rework the state_lock in start_this_handle?
> > (Now that its at the top of the contention logs? :)
> 
> That's going to be much harder.  We're going to have to take
> j_state_lock at some point inside start_this_handle.  We might be able
> to decrease the amount of code which is run while the spinlock is
> taken, but I very much doubt it's possible to eliminate that spinlock
> entirely.
> 
> Do you have detailed lockstat information showing the hold-time and
> wait-time of j_lock_stat (especially in start_this_handle)?

Hey Ted,
	Sorry this took so long. I've been using a fairly large pile of patches
in my testing on top of -rt, and since with -rt lockstat is less useful
(you don't get any of the contention data for mutexes, and the contended
spinlocks are always the internal rtmutex locks), I tried to regenerate
the data on something closer to plain vanilla.

So I ran dbench with 2.6.33, 2.6.33 + Nick Piggin's VFS scalability
patches, and 2.6.33 + Nick's patches + your state-lock patch on an 8 cpu
system. 

Here's the chart of the performance difference:
http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33-ext4-state-lock/2.6.33_ext4-state-lock.png

Here's the perf log output:
http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.33-ext4-state-lock/

And finally, as requested, here's the lockstat data:
http://sr71.net/~jstultz/dbench-scalability/lockstat/2.6.33-ext4-state-lock/


Now, again, because the -rt kernel amplifies the contention cost, the
data above doesn't show as much pain at only 8 cpus as we see with -rt.
However, the contention does show up, and your patch helps. 

In fact, with your patch, I'm not seeing any major contention in the
perf logs at 8 cpus. Although the lockstat logs still show:

t_handle_lock contention in start_This_handle/jbd2_journal_stop
	- Likely the j_stat_lock was previously serializing this

j_state_lock contention in start_this_handle
	- Expected

j_revoke_lock contention in find_revoke_record
	- Also observed by Tim Chen



Let me know if there's any other data you'd like to see.

thanks
-john





