From: Jan Kara <jack@suse.cz>
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Date: Thu, 3 Dec 2009 11:32:46 +0100
Message-ID: <20091203103245.GA5023@quack.suse.cz>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
 <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net>
 <1259667765.9614.19.camel@marge.simson.net>
 <20091201143558.GB12730@quack.suse.cz>
 <20091202190425.GA30315@quack.suse.cz>
 <20091203052825.GL31517@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Mike Galbraith <gleep@gmx.de>,
	James Y Knight <foom@fuhm.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZLCKcw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Dec 2009 05:32:52 -0500
Content-Disposition: inline
In-Reply-To: <20091203052825.GL31517@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-12-09 06:28:25, Nick Piggin wrote:
> On Wed, Dec 02, 2009 at 08:04:26PM +0100, Jan Kara wrote:
> > >   When using writev, the page we copy from is not paged in (while when we
> > > use ordinary write, it is paged in). This difference might be worth
> > > investigation on its own (as it is likely to heavily impact performance of
> > > writev) but is irrelevant for us now - we should handle this without data
> > > corruption anyway.
> >   I've looked into why writev fails reliably the writes. The reason is that
> > iov_iter_fault_in_readable() faults in only the first IO buffer. Because
> > this is just 600 bytes big, following iov_iter_copy_from_user_atomic copies
> > only 600 bytes and block_write_end sets number of copied bytes to 0. Thus
> > we restart the write and do it one iov per iteration which succeeds. So
> > everything works as designed only it gets inefficient in this particular
> > case.
> Yep, this would be right. We could actually do more prefaulting; I
> think I was being a little over conservative and worried about earlier
> pages being unmapped before we were able to consume them... but I
> think being too worried about that case is optimizing an unusual case
> that is probably performing badly anyway at the expense of more common
> patterns.
  Yeah, IMHO optimal would be to fault in enough buffers so that we can
fill one page (although we may pose some upper bound on the number of pages
we are willing to fault in - like 1 MB of data or so).

> Anyway, what I was doing to test this code when I wrote it was to
> inject random failures into user copy functions. I guess this could
> be useful to merge in the error injection framework?
  Yes, that would be definitely useful. This was exceptionally easy to
track down because it was easily reproducible. But otherwise this path is
almost never taken and bugs in there are hard to debug so it would get more
testing coverage. I've spent like a month debugging a bug in reiserfs
causing data corruption in this path - mainly because it took a few days to
reproduce it and I didn't know what could be possibly triggering it...

								Honza
