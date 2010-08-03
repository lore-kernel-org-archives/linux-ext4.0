From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Tue, 3 Aug 2010 12:06:11 -0400
Message-ID: <20100803160611.GB3387@thunk.org>
References: <1280753306-23871-1-git-send-email-tytso@mit.edu>
 <1280790152.3966.14.camel@localhost.localdomain>
 <20100803000609.GI25653@thunk.org>
 <1280796823.3966.74.camel@localhost.localdomain>
 <1280803949.3966.86.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: john stultz <johnstul@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47570 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab0HCSgW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 14:36:22 -0400
Content-Disposition: inline
In-Reply-To: <1280803949.3966.86.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 02, 2010 at 07:52:29PM -0700, john stultz wrote:
> With the non-vfs scalability patched kernels, we see that the j_state
> lock and atomic changes pull start_this_handle out of the top contender
> handle, but there is still quite a large amount of contention on the
> dput paths.
> 
> So yea, the change does help, but its just not the top cause of
> contention when aren't using the vfs patches, so we don't see as much
> benefit at this point.

Great, thanks for uploading the lockstats.  Since dbench is so
metadata heavy, it makes a lot of sense that further jbd2
optimizations probably won't make much difference until the VFS
bottlenecks can be solved.

Other benchmarks, such as the FFSB benchmarks used by Steven Pratt and
Eric Whitney, would probably show more of a difference.

In any case, I've just sent two more patches which completely remove
any exclusive spinlocks from start_this_handle() by converting
j_state_lock to a rwlock_t, and dropping the need to take
t_handle_lock.  This will add more cache line bouncing, so on NUMA
workloads this may make things worse, but I guess we'll have to see.
Anyone have access to an SGI Altix?  I'm assuming the old Sequent NUMA
boxes are long gone by now...

					- Ted
