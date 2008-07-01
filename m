From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4dev snapshot weirdness
Date: Tue, 1 Jul 2008 12:02:36 -0400
Message-ID: <20080701160236.GG22717@mit.edu>
References: <3.0.6.32.20080626221227.0242af78@pop.west.cox.net> <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net> <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net> <3.0.6.32.20080626221227.0242af78@pop.west.cox.net> <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43249 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754299AbYGAQCj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2008 12:02:39 -0400
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 01, 2008 at 12:00:46AM +0000, Gary Hawco wrote:
> Gentoo was fine through 062508/00119hrs. No problems. From 062608/0042hrs -
> 062708/2353 snapshots boot sequence was fine, but segfaulting running my
> portage/metadata backup script (lots of small files).
> 
> Today's updates rebased against 2.6.26-rc8 are NOT segfaulting running the
> backup script, but seem to be corrupting the /lib/rc/init.d/database files
> after the first start.
> 
> I am willing to bet that Gentoo on the old baselayout/Non open-rc startup
> up scripts would have no problems ala Slackware, but it's curious
> everything was fine through the 062508/0019GMT snapshot. It seems that once
> delalloc was brought back in with ordered data mode problems started to
> arise. I tried to roll back the baselayout v2 to the older version 1.12,
> but I broke the os and had to quickly reinstall using a recent tarball.
> It's the only explanation why Gentoo is having problems, but Slackware is
> not. And now that today with the latest rc-8 snapshots the initialization
> of devices during startup is getting fubared, I am certain the
> Baselayout2/open-rc-2.5 does not like the latest iterations of the
> ext4-patch-queue kernel.

Gary,

It's definitely the case that kernel oops indicates kernel bugs.  It
might be the case that one distribution is better than another at
exposing the bug and making it visible, but that doesn't mean the bug
is in the distribution; in fact, if you can provoke a segfault, this
is *good* because it can help us track down the bug more
effectively/efficiently.  Data corruption like you are seeing now is
worse, since it's actually much harder to track down.

Of course, in order to track down the segfault we really need the oops
messages.  In the bad old days I would laborously copy down all of the
numbers and function names in the stack trace using pen and paper, and
then transcribe it into e-mail.  (Yes, I also walked uphill through
the snow in the winter, in both directions.  :-) Using a digital
camera is more convenient, but if it's too hard for you to grab one,
you can always fall back to the pen and paper model.

So if you have data corruption in your init.d files, does it go away
if you disable delalloc?  What if you disable mballoc?  Of course, do
this on Gentoo if it's better at provoking the filesystem bug.
Remember, from the point of view of filesystem developers, it's good
if you can provoke the bug; since it's only then that you can squash
it.  :-)

       	       		       	      	      - Ted
