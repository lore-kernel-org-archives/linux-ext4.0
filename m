From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Allow ext4 to run without a journal.
Date: Sat, 3 Jan 2009 20:17:47 -0500
Message-ID: <20090104011747.GI4758@mit.edu>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com> <20081217031210.GA17588@mit.edu> <20090103155221.GH4758@mit.edu> <1231013940.22046.4.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57693 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZADBRx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Jan 2009 20:17:53 -0500
Content-Disposition: inline
In-Reply-To: <1231013940.22046.4.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 03, 2009 at 12:19:00PM -0800, Frank Mayhar wrote:
> On Sat, 2009-01-03 at 10:52 -0500, Theodore Tso wrote:
> > I've modified your patch to reflect the comments I made two weeks ago.
> > Were there any other changes you have planned?  I'd like to get this
> > pushed to Linus soon....
> 
> My apologies, I have a new patch that has been tested quite a bit more
> (although I still wouldn't say quite thoroughly yet, but close), all I
> need to do is set it up correctly for you guys and send it to the list.
> Unfortunately other stuff (including the holidays) has gotten in the
> way.  Expect it on Monday or Tuesday.  Note that this version will have
> a handful of small but important bugs fixed, as well.
> 
> One question:  Shold I make the patch relative to the stable tree or to
> the latest bits?

At this point can you make your patch relative to whatever you used
last time (and remind me what it is)?  Or, can you give me a delta
between what you did last time and what you have now that has the
fixes?  The problem is that the patch touches so much of ext4 that
it's quite painful to maintain it in the ext4 patch queue --- it
either invalidates a large number of patches after the fact, or the
patch needs a huge amount of work to fix up patch conflicts if it is
applied afterwards --- and if it is placed in the middle of the patch
queue, both conditions apply.

So I will have to do a lot of fix ups either way.  So unless you're
willing to pull down the ext4 patch queue, at:

	git://repo.or.cz/ext4-patch-queue.git

... and worry about making it apply in place, it's probably easier for
you to give me delta's versus the last patch, and I'll integrate in
the changes by hand.

						- Ted
