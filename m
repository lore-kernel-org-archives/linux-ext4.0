From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Some jbd2 philosophy about credits estimation and other things
Date: Thu, 6 Jul 2017 19:26:41 -0400
Message-ID: <20170706232641.oz65eaf6aiqx3x6j@thunk.org>
References: <20170704175441.ljipnhmgli6npdt6@thunk.org>
 <20170706171906.GA4096@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com, ebiggers3@gmail.com,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        tahsin@google.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55164 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752881AbdGFX0v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Jul 2017 19:26:51 -0400
Content-Disposition: inline
In-Reply-To: <20170706171906.GA4096@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 06, 2017 at 10:19:06AM -0700, Darrick J. Wong wrote:
> > While I was looking into this, I realized that there are some
> > implementation details about how the jbd2 layer works that haven't
> > written down, and it might be useful to document it for everyone.
> > (This probably needs to go into the ext4 wiki, with some editing.)
> 
> Additionally ext4-jbd2.h ?

Yeah.  We should have a succint summary of this in ext4_jbd2.h; I
don't think we should have a huge long essay in there.  That should
either go in Documentation/filesystems or in the ext4 wiki.

> > In general, under-estimating of the number of credits needed is far
> > worse than over-estimating.  Under-estimating can cause the above,
> > which will end up marking the file system corrupt.  We can actually do
> > better; in fact, we probably ought to do is to try to see if we can
> > extend the transaction, print an ext4 warning plus a WARN_ON(1) to get
> 
> I don't know if that's a good idea -- I'd rather train the developers
> that they cannot underestimate ever than let them paper over things like
> this that will eventually blow out on someone else's machine.
> 
> But I guess a noisy WARN would get peoples' attention.

A WARN will cause xfstests to consider the test as failed, so as long
as we can trigger it in xfstests, we can get it fixed.  If it happens
in the field, the poor user isn't going to do anything actionable, so
doing a hard stop on the file system when we could have continued
doesn't quite seem fair to the user, even if it makes it much more
likely that the user will file an angry bug report with the distro
help desk.  :-)

The better approach might be to have distro's write scripts that
search for warnings in the logs, run them out of cron, and then
somehow ask the user for permission to report the WARN's to the
distro's bug tracking system (or some other tracking system).

> > So over-estimating by a few 10's of credits is probably not noticeable
> > at all.  Over-estimating by hundreds of credits can start causing
> > performance impacts.  How?  By forcing transaction to close earlier
> > than the normal 5 second timeout due of a perceived lack of space,
> > when the journal is almost full due to a credit over-estimation.  Even
> > so, the performance impact is not necessarily that great, and
> > typically only shows up under heavy load --- and we or the system
> > administrator can mitigate this problem fairly easily by increasing
> > the journal size.
> 
> /me wonders if it'd be useful to track how closely the estimates fit
> reality in debugfs to make it easier to spot-check how good of a job
> we're all doing?

It's important to track this for those handle types where the
estimates are huge, or could become huge --- especially if that
happens via handle extensions.  If we are estimating 20 and we're only
using 4, it's hard for me to get excited about that.

That being said, having added tracepoints to track handle usage, I
already mostly know the answer to this question, and I suspect it
hasn't changed that much.  The really big problem user is truncate,
and that's because it takes a long time and can potentially touch a
large number of blocks.

If we are worried about improving ext4 benchmarks where you have all N
CPU cores all trying to write to the file system at once, the clear
optimization is to change truncate so that we lock out changes to the
inode, then scan the extent tree (and/or indirect blocks) to
accomulate an extent map of blocks that need to be released, and do
that *without* starting a handle.  Once we know which blocks need to
be released, especially if we are truncating to zero (the delete file
case) we don't need to touch the extent tree blocks as we currently
do.  We can calculate how many bitmap blocks and block group descripts
we would need to update, then try to start a handle for that number of
blocks, free the blocks, and clear the inode's i_blocks[] array.
Boom, done.

This optimization would reduce the number of metadata blocks we need
to modify, and hence the number of blocks we need journal, and it
would also significantly reduce the handle hold time, which in turn
improve our performance, since one of the ways in which highly
parallel benchmarks can get dragged down by ext4 is when we have 31
CPU's waiting for the last handle to stop, which throttles the
performance of the workload that would have been running on those 31
other CPU's, and in turn this drags down our Spec SFS numbers or
whatever.

I haven't done this optimization because I haven't had time, and for
most workloads (other than the NFS / Samba workload case), we
generally don't have all of the CPU's blocked on file system
operations.  So other than making the benchmark weenies at Phoronix
happy (and those people who actually want to run an NFS server, of
course!), it hasn't been a high priority thing for me to do.

The other handle operation which can take a large number of handle
credits is the inode allocation case.  And there it's just a really
complex case especially if quotas, acl's, and encryption are all
enabled at once.  So that's the other one that we could try
optimizing, but I doubt there's as much opportunities for optimization
as trying to optimize truncate.

Cheers,

					- Ted
