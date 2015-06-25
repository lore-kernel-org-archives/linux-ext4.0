From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 15:57:06 +0200
Message-ID: <20150625135706.GG17237@dhcp22.suse.cz>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <20150625133138.GH14324@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Borisov <kernel@kyup.com>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbFYN5I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2015 09:57:08 -0400
Content-Disposition: inline
In-Reply-To: <20150625133138.GH14324@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-06-15 09:31:38, Theodore Ts'o wrote:
> On Thu, Jun 25, 2015 at 01:50:25PM +0200, Michal Hocko wrote:
> > On Thu 25-06-15 14:43:42, Nikolay Borisov wrote:
> > > I do have several OOM reports unfortunately I don't think I can
> > > correlate them in any sensible way to be able to answer the question
> > > "Which was the process that was writing prior to the D state occuring".
> > > Maybe you can be more specific as to what am I likely looking for?
> > 
> > Is the system still in this state? If yes I would check the last few OOM
> > reports which will tell you the pid of the oom victim and then I would
> > check sysrq+t whether they are still alive. And if yes check their stack
> > traces to see whether they are still in the allocation path or they got
> > stuck somewhere else or maybe they are not related at all...
> > 
> > sysrq+t might be useful even when this is not oom related because it can
> > pinpoint the task which is blocking your waiters.
> 
> In addition to sysrq+t, the other thing to do is to sample sysrq-p a
> few half-dozen times so we can see if there are any processes in some
> memory allocation retry loop.  Also useful is to enable soft lockup
> detection.
> 
> Something that perhaps we should have (and maybe GFP_NOFAIL should
> imply this) is for places where your choices are either (a) let the
> memory allocation succeed eventually, or (b) remount the file system
> read-only and/or panic the system, is in the case where we're under
> severe memory pressure due to cgroup settings, to simply allow the
> kmalloc to bypass the cgroup allocation limits, since otherwise the
> stall could end up impacting processes in other cgroups.

GFP_NOFAIL will fallback to the root memcg if the charge fails after
several attempts to reclaim the memcg.

Besides that kmalloc would require kmem limit set which is not the case
here. And even if it were it would fallback as well.

As explained in other email, memcg charges are not blocked until memcg
oom gets resolved. We simply return ENOMEM. The memcg oom killer is
called only from the page fault path and even there from
pagefault_out_of_memory where no locks are held.
-- 
Michal Hocko
SUSE Labs
