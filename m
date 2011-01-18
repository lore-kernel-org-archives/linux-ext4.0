From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: reduce redundant check of '*options'
Date: Tue, 18 Jan 2011 23:24:19 +0100
Message-ID: <20110118222419.GC5070@quack.suse.cz>
References: <1294922362-2237-1-git-send-email-xu.simon@oracle.com>
 <20110117170203.GF5294@quack.suse.cz>
 <20110118134345.GC3138@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Simon Xu <xu.simon@oracle.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1ARWYV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jan 2011 17:24:21 -0500
Content-Disposition: inline
In-Reply-To: <20110118134345.GC3138@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 18-01-11 08:43:45, Ted Ts'o wrote:
> On Mon, Jan 17, 2011 at 06:02:03PM +0100, Jan Kara wrote:
> > Seriously, if you want to do some useful fixing then have a look for
> > example at making ext3/4 (in fact JBD/JBD2) handle transaction allocation
> > failures gratefully.  Currently we just loop in start_this_handle()
> > infinitely until we can make the allocation which is a bit dumb. So it
> > would be good, to make as many places as possible able to handle ENOMEM
> > from start_this_handle() and propagate the error to user space. In some
> > cases, it might not be easily possible (e.g. during writeout of dirty
> > memory, where proper handling needs more thought) but lots of cases
> > should be rather simple and need just auditing the code paths. Thanks.
> 
> Uh, this is actually a rather subtle set of fixes that you are
> proposing, because it won't be obvious to someone who hasn't paid very
> careful attention to who calls certain functions (i.e., such as the
> writepages function), which get propagated to user space, and which
> will just cause mysterious data corruption of files --- especially
> since the writeback daemon doesn't check error returns (!!!).  So if
> someone changed writepages to return ENOMEM, and then said, "How
> delightful!  My work is done...", it would result in nothing getting
> back to userspace in most cases, and the writeback code would mark the
> pages as clean, and on the next reboot, the data would be lost.
  I agree that the patches will need a careful review because of catches
like you mention.

> So this is *not* a change that I would recommend to people who are
> just beginning to learn how to program the kernel, and have been
> taught by some kernel programmers that the best thing to do is to take
> trivial-style changes and submit them upstream.
 I agree, maybe I've shooted too high (feel free to suggest better topic),
but we'll see what the guy comes up with. Personally, I find it more useful
to correct bad patches trying to achieve good things than spending time
shooting down trivial code rearrangements...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
