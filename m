From: Jan Kara <jack@suse.cz>
Subject: Re: ext4/jbd2 hangs in __jbd2_log_wait_for_space on 3.4-RT/3.6-RT
Date: Tue, 25 Jun 2013 15:18:08 +0200
Message-ID: <20130625131808.GA14581@quack.suse.cz>
References: <20130531183411.GA30169@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-rt-users@vger.kernel.org, linux-ext4@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3FYNSM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jun 2013 09:18:12 -0400
Content-Disposition: inline
In-Reply-To: <20130531183411.GA30169@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 31-05-13 14:34:12, Paul Gortmaker wrote:
> This problem is seen on vanilla 3.4-RT and 3.6-RT kernels. It is
> not clear to me whether this is an RT issue, or whether (as usual)
> RT has managed to shake out an issue in mainline code.  So I've
> looped in the ext4 list as well as the RT list, since at the
> moment it appears this can impact anyone using RT and ext4...
> 
> What happens is that under reasonable load, the jbd2/sda1-8 thread
> goes D state, and then lots of regular processes follow suit, after
> calling __jbd2_log_wait_for_space.  As can be seen at the bottom
> of the sysrq-t output, j_checkpoint_mutex is implicated.  All
> future processes trying to do I/O to/from that filesystem go D.
> 
> More testing details:
> Even though debug_rt_mutex_print_deadlock shows up in each stalled
> process backtrace, no output is seen from debug_rt_mutex_print_deadlock.
> There are no messages in dmesg at all, until I trigger a SysRQ-t.
> 
> I've reproduced this on v3.4.42-rt57, v3.4.47-rt62, and v3.6.11.3-rt35.
> 
> The two separate versions of v3.4.x are because I noticed the 3.4.47
> pulled in some jbd2 commits via stable, like 794446c6 "jbd2: fix race
> between jbd2_journal_remove_checkpoint and ->j_commit_callback". It
> looked promising, but having that present didn't change things.
> 
> I'm using a yocto build, configured for six parallel package builds,
> each pkg in turn with "make -j6" to create I/O.  I've found that also
> running an "rm -rf" of an old build (several gigs of data) at the
> same time increases the probability of it.  Typically it will fail
> within about 15m or so.  The test box is a dell optiplex 990 with
> a single disk as ext4.  The box stays alive for basic sysrq operations
> and anything else that doesn't touch the locked filesystem.  The build
> halts with a static load average equal to the number of blocked D procs.
> 
> I've deleted the sysrq-t output from the irrelevant sleeping processes
> in order to reduce the noise.  I'll keep looking at this but I'm hoping
> more experienced eyes on the problem will help, since it seems common
> to all RT users and hence of interest to everyone (I've not yet tried
> 3.8.x-RT, mind you.)
  Hum, this sounds familiar... I was already debugging this with RT kernel
and I also remember it was RT specific issue. Let me try to remember the
whole story... yes, while wandering over the traces I think I remember what
was the problem: In standard kernel, whenever we scheduler process out from
CPU, we unplug its IO queue in sched_submit_work(). However in RT kernel
that was not the case. So it could happen that a process has IOs queued
and was sent to sleep waiting for jbd2 thread to free some journal space
and jbd2 thread was waiting for some IO to complete - however that never
happened because the IO was sitting in the sleeping process' queue.

>From a quick look into the traces you've provided this seems to be your
case as well. I think newer RT kernels should have the bug fixed but I
wasn't really watching closely after I handed over the problem to RT folks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
