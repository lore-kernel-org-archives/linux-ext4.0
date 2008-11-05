From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch collision: 64-bit quota changes and ext4 delalloc quota
	changs
Date: Wed, 5 Nov 2008 12:40:26 -0500
Message-ID: <20081105174026.GB29880@mit.edu>
References: <E1Kxkwt-0007Np-O4@closure.thunk.org> <20081105084303.ed0c53d5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38845 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753085AbYKERkd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 12:40:33 -0500
Content-Disposition: inline
In-Reply-To: <20081105084303.ed0c53d5.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2008 at 08:43:03AM -0800, Andrew Morton wrote:
> 
> It works for me.  I really need to get off my butt and get -mm into
> linux-next.
> 
> I can merge ext4-quota-handling-for-delayed-allocation.patch if you
> like, or you can merge it once te quota changes have gone in.
> 

If you are willing to carry the
ext4-quota-handling-for-delayed-allocation.patch, that would be great.

Mingming, what I'll do is create a branch of the ext4 patch queue
(since it's being maintained in git anyway), that basically reflects
the patch queue as it currently exists today.  You can do your
development in that branch so it won't impact you terribly, but I'll
then set master branch of the ext4 patch queue to be a version that
drops all of the quota related changes.  You should be able to
periodically pull from the master branch to the quota branch, so you
can keep up with other changes, but then what we'll need to do is to
make sure that the version of the patches that you are developing
against in your branch corresponds with what Andrew has in mmotm, and
if it doesn't, we'll have to manually send updates to Andrew to keep
his tree in sync with yours, since it is his tree that will ultimately
be pushing the patches to Linus.

If it weren't for the fact that Jan is on vacation until November
18th, what I would have suggested instead was for Jan to create his
own quota git tree, drop the ext4 delalloc quota patches into a
separate git tree, called the quota-ext4-postmerge tree, and then tell
Steve to pull into next first the ext4 tree, then the quota tree, and
then the quota-ext4-postmerge tree.  (And then we could easily do
testing/development by creating a throw-away integration tree that
merged the ext4, quota, and post-merge trees.)

But keeping this stuff all in -mm should work, although depending on
how many more cleanup patches flow into ext4, this might cause some
minor patch conflicts on that last quota dellaloc patch that actually
touches ext4 core code.

						- Ted
