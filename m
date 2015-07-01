From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Wed, 1 Jul 2015 07:13:55 -0400
Message-ID: <20150701111355.GA22423@thunk.org>
References: <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <20150625133138.GH14324@thunk.org>
 <5591097D.6010602@kyup.com>
 <20150629093640.GD28471@dhcp22.suse.cz>
 <20150630015206.GL22807@dastard>
 <20150630123033.GB4578@dhcp22.suse.cz>
 <20150630143158.GD4578@dhcp22.suse.cz>
 <20150630225851.GK7943@dastard>
 <20150701061014.GA6286@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Nikolay Borisov <kernel@kyup.com>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Michal Hocko <mhocko@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34948 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbbGALN4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jul 2015 07:13:56 -0400
Content-Disposition: inline
In-Reply-To: <20150701061014.GA6286@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 01, 2015 at 08:10:14AM +0200, Michal Hocko wrote:
> On Wed 01-07-15 08:58:51, Dave Chinner wrote:
> [...]
> > *blink*
> > 
> > /me re-reads again
> > 
> > That assumption is fundamentally broken. Filesystems use GFP_NOFS
> > because the filesystem holds resources that can prevent memory
> > reclaim making forwards progress if it re-enters the filesystem or
> > blocks on anything filesystem related. memcg does not change that,
> > and I'm kinda scared to learn that memcg plays fast and loose like
> > this.
> > 
> > For example: IO completion might require unwritten extent conversion
> > which executes filesystem transactions and GFP_NOFS allocations. The
> > writeback flag on the pages can not be cleared until unwritten
> > extent conversion completes. Hence memory reclaim cannot wait on
> > page writeback to complete in GFP_NOFS context because it is not
> > safe to do so, memcg reclaim or otherwise.
> 
> Thanks for the clarification.

Perhaps we need to make the documentation a bit more explicit?
All which is stated in include/slab.h:

 * %GFP_NOIO - Do not do any I/O at all while trying to get memory.
 *
 * %GFP_NOFS - Do not make any fs calls while trying to get memory.

I thought this was obvious, but these flags are used by code which in
the I/O or FS paths, and so it's always possible that they are trying
to write back the page which you decide to blocking on when trying to
do the memory allocation, at which point, *boom*, deadlock.

So it's just not "do not make any FS or I/O calls", but also "the mm
layer must not not wait for any FS or I/O operations from completing,
since the operation you block on might be the one they were in the
middle of trying to complete --- or they may be holding a lock at the
time when they were trying to do a memory allocation which blocks the
I/O or FS operation from completing".

						- Ted
