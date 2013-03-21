From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4/jbd2: don't wait (forever) for stale tid caused
 by wraparound
Date: Thu, 21 Mar 2013 23:41:43 +0100
Message-ID: <20130321224143.GA5066@quack.suse.cz>
References: <B2EC601CDDA242189A46599B31EA6AD3@atlassian.com>
 <1363412062.3937.196.camel@deadeye.wl.decadent.org.uk>
 <20130318025401.GA12611@thunk.org>
 <20130321204638.GA6116@quack.suse.cz>
 <20130321210940.GD21877@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
	George Barnett <gbarnett@atlassian.com>,
	linux-ext4@vger.kernel.org,
	Debian kernel maintainers <debian-kernel@lists.debian.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3CUWlq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Mar 2013 18:41:46 -0400
Content-Disposition: inline
In-Reply-To: <20130321210940.GD21877@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 21-03-13 17:09:40, Ted Tso wrote:
> On Thu, Mar 21, 2013 at 09:46:38PM +0100, Jan Kara wrote:
> >   Good catch! But shouldn't we rather fix jbd2_log_wait_commit() instead of
> > inventing new function?
> 
> In most of the places where we call jbd2_log_start_commit(), we're
> actually starting the current running transaction.  So the fact that
> we pass in a tid, and we're having to validate that the tid is
> actually a valid one, is a bit of a waste.  So in the long run I think
> it's worth rethinking whether or not jbd2_log_{start,wait}_commit()
> should exist in their current form, or whether we should reorganize
> their functionality (i.e., by having a jbd2_start_running_commit(),
> for example.).  Piling on fixes to jbd2_log_wait_commit() would make
> it get even more complicated, and I think if we separate out the
> various ways in which we use these functions, we can make the code
> simpler and easier to read.
  I don't find jbd2_log_wait_commit() that complex that it couldn't bear
another if :) But given there are really two waiting operations that make
sense:
a) request commit of running transaction and wait for it
b) wait for committing transaction

then I agree there may be a better interface. OTOH I'm somewhat
curious about the new interface because the only race-free way of
identifying a transaction you want to wait for is using its tid.

> In fact, I had started making this rather large set of changes when I
> decided it would be better to save that kind of wholesale refactoring
> for the next merge window.  So the reason why I ended up fixing the
> patch the way I did was to keep things simple.
> 
> Also as I mentioned in the commit description, by using a single
> function I was also able to optimize the locking the locking somewhat.
  Yeah. I'm not as much opposed to the new function doing start commit
& wait but what I dislike is the fact that we have still exposed the
function jbd2_log_wait_commit() which can possibly lockup if tid overflows.
I agree there aren't currently any other callers where this could happen
but in a few years who knows...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
