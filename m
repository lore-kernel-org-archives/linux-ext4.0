From: Theodore Tso <tytso@mit.edu>
Subject: Re: Making it easier for end users to use ext4
Date: Mon, 14 Jul 2008 15:55:26 -0400
Message-ID: <20080714195526.GA3382@mit.edu>
References: <E1KITeX-0001PV-Pv@closure.thunk.org> <487BAA6B.7030001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46306 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754829AbYGNTz2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 15:55:28 -0400
Content-Disposition: inline
In-Reply-To: <487BAA6B.7030001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 02:35:07PM -0500, Eric Sandeen wrote:
> > Eric, when you have a chance, could you take a quick peek at the Fedora
> > Core section of that page and update it appropriately.  
> 
> Sure, first I'll remove "core" since that terminology doesn't exist
> anymore ;)

Is "FC" acronym as in "FC9" going away as well?  :-)

> I think very soon just saying "run the latest kernel + e2fsprogs from F9
> updates-testing" will be a good start.  It won't have delalloc yet,
> though.  Do we want to try to make that more widely available to people
> who can't/don't build their own kernels?  I'm slightly hesitant I guess
> both for the extra work of maintaining the repo & complete kernel
> builds, as well as providing too much rope to people who may not know
> just how much rope they've got ...

Well, there are two reasons why I was thinking it might be nice to
synch up the ext4 code base.  One was the "more testers good"
argument.  The other was is that while *most* of the various races and
bug fixes that have gone in since 2.6.26 were delalloc related, some
are real bugs that might bite 2.6.25 users if they start using the
ext4 code in a more demanding workload.  That would result in perhaps
preventable data loss, plus which we could end up spending time
debugging a problem which had already been solved.

If Fedora is going to be putting out another test kernel shortly, any
chance we can get the 2.6.26-ext4-1 or 2.6.26-ext4-2 (with mingming's
latest patch, to be released shortly) included in that test kernel?
Again, the goal is to make it as easy as possible for people to test
the latest version of ext4, so we can get those bugs fixed.

Regards,

						- Ted
