From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] e2fsck: Don't skip time based checks if
 broken_system_clock=1 unnecessarily
Date: Tue, 22 Apr 2014 17:47:02 +0200
Message-ID: <20140422154702.GH366@quack.suse.cz>
References: <1395976531-7447-1-git-send-email-jack@suse.cz>
 <20140421003956.GB5754@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaDVPrG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Apr 2014 11:47:06 -0400
Content-Disposition: inline
In-Reply-To: <20140421003956.GB5754@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 20-04-14 20:39:56, Ted Tso wrote:
> On Fri, Mar 28, 2014 at 04:15:31AM +0100, Jan Kara wrote:
> > When option broken_system_clock is set, we unconditionally skip checks
> > whether e2fsck should check the fs because the fs was last checked too
> > long ago. Distributions however set broken_system_clock by default as
> > some of the systems simply have the clocks broken and e2fsck stops the
> > boot because of that which is harsh given how minor issue that is (at
> > least for the fs). Thus checking every X days doesn't work with these
> > distributions.
> 
> There are a couple of different ways in which the time can be
> considered "broken":
> >
> 1) The system has no battery-backed block and so the time is always
> January 1, 1970 on boot.  These systems are taken care of by the
> TIME_INSANE checks.
> 
> 2) The distribution the timezone is incorrect when e2fsck is run, so
> depending on whether you are east or west of GMT, the clock could
> appear to be up to 24 hours in the future, which would falsely trigger
> the e2fsck check.  That is now taken care of by the accept_time_fudge
> hack, which is enabled by default.
> 
> 3) The clock is totally insane, which means that it could be any
> value; it could have a time in 2037; it could have a time in the
> 1970's.  This is what broken_system_clock means now.
> 
> If the system clock is completely untrustworthy, you really do want to
> skip all time based checks, because there is no way to tell whether
> the times look "sensible" or not.  If the clock warps forward by N
> years, it's still going to look sensible, and it can force a time
> based check when one shouldn't be needed.
>
> I think the issue is that there may be some distributions that set
> broken_system_lock way back in the past, before we added the
> accept_time_fudge (which was added in 2009).  So if the concern is
> dealing with people who have systems in Western Europe whose RTC ticks
> localtime (as opposed to UTC), that problem was fixed by
> accept_time_fudge.  And if the concern is systems in state #1, that
> was dealt with by the TIME_INSANE checks in 2010.
> 
> So if those are the main concerns, you can simply get rid of setting
> broken_system_clock, since those problems are now solved by default.
  So looking into our bugzilla we added broken_system_clock=1 to
e2fsck.conf because of a report of a machine where the time went few days
backward after a reboot (the most likely explanation to me seems that the
system time wasn't getting properly written to the hw clock for some
reason).

Anyway, thinking about this again maybe my point should have been: Isn't it
too harsh to declare mount time in future as requiring manual intervention?
Why don't we just reset it (or just leave it alone) in preen mode without
requiring user interaction? I understand it may indicate some corruption
problem but we don't really care about corruption in this particular field
much...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
