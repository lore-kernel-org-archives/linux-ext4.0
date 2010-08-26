From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Thu, 26 Aug 2010 10:09:40 +1000
Message-ID: <20100826000940.GR31488@dastard>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
 <1282656558.2605.2742.camel@laptop>
 <4C73CA24.3060707@fusionio.com>
 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
 <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop>
 <20100825115709.GD4453@thunk.org>
 <1282740516.2605.3644.camel@laptop>
 <20100825132417.GQ31488@dastard>
 <1282743342.2605.3707.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:55294 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752406Ab0HZAJq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 20:09:46 -0400
Content-Disposition: inline
In-Reply-To: <1282743342.2605.3707.camel@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 25, 2010 at 03:35:42PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-08-25 at 23:24 +1000, Dave Chinner wrote:
> > 
> > That is, the guarantee that we will always make progress simply does
> > not exist in filesystems, so a mempool-like concept seems to me to
> > be doomed from the start.... 
> 
> While I appreciate that it might be somewhat (a lot) harder for a
> filesystem to provide that guarantee, I'd be deeply worried about your
> claim that its impossible.

I didn't say impossible, just that there's no way we can always
guarantee of forward progress with a specific, bound pool of memory.

Sure, we know what the worst case amount of log space is needed for
each transaction (i.e. how many pages that will be dirtied), but
that does not take into account all the blocks that need to be read
to make those modifications, the memory needed for stuff like btree
cursors, log tickets, transaction commit vectors, btree blocks
needed to do the searches, etc.  A typical transaction reservation
on a 4k block filesystem is between 200-400k (it's worst case), and
if you add in all the other allocations that might be required,
we're at the order of requiring megabytes of RAM to guarantee a
single transaction will succeed in low memory conditions. The exact
requirement is very difficult to quantify algorithmically, but for a
single transaction it should be possible.

However, consider the case of running a thousand concurrent
transactions and in the middle of that the system runs out of
memory. All the transactions need memory allocation to succeed, some
are blocked waiting for resources held in other transactions, etc.
Firstly, how to you stop all the transactions from making further
progress to serialise access to the low memory pool?  Secondly, how
do you select which transaction you want to use the low memory pool?
What do you do if the selected transaction then blocks on a resource
held by another transaction (which you can't know ahead of time)? Do
you switch to another thread and hope the pool doesn't run dry? What
do you do when (not if) the memory pool runs dry?

I'm sure this could be done, but it's lot of difficult, unrewarding
work that greatly increases code complexity, touches a massive
amount of the filesystem code base, exponentially increases the test
matrix, is likely to have significant operational overhead, and even
then there's no guarantee that we've got it right. That doesn't
sound like a good solution to me.

> It would render a system without swap very prone to deadlocks. Even with
> the very tight dirty page accounting we currently have you can fill all
> your memory with anonymous pages, at which point there's nothing free
> and you require writeout of dirty pages to succeed.

Then don't allow anonymous pages to fill all of memory when there is
no swap available - i.e. keep a larger pool of free memory when
there is no swap available. That's a much simpler solution than
turning all the filesystems upside down to try to make them not need
allocation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
