From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs-interim scm tree?
Date: Tue, 20 Nov 2007 09:04:20 -0500
Message-ID: <20071120140420.GC13125@thunk.org>
References: <alpine.DEB.0.99999.0711200128130.7426@sheep.housecafe.de> <20071120031127.GB13125@thunk.org> <14319.62.180.231.196.1195554243.squirrel@housecafe.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34661 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbXKTOEj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2007 09:04:39 -0500
Content-Disposition: inline
In-Reply-To: <14319.62.180.231.196.1195554243.squirrel@housecafe.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 20, 2007 at 11:24:03AM +0100, Christian Kujau wrote:
> > Note that the userspace code still needs a lot of work.
> > It's for this reason that I haven't been recommending people use it for
> > production systems just yet.
> 
> Understood. But the more ppl testing your stuff the better, right?

Oh, absolutely.  I just don't think it's fair to encourage people to
use something that might cause them to risk their data unless they are
going into it with their eyes wide open.  The 'pu' branch gets very
minimal testing.  I do run the regression test suite(*), so it's a bit
more than "it builds, ship it!", but essentially almost any patch that
will apply gets thrown into 'pu', and as I review patches and fix up
issues, I move them to the 'next' branch, and then a little bit later
to the 'master' branch.

(*) With only 3-4 test failures, but at least some of them are tests
that need to be fixed up, not necessarily outright bugs in the 'pu'
branch.

At the moment in the git tree only the 'pu' branch has extents
support, and to be honest the support in e2fsprogs-interim in terms of
being able to better detect and fix corrupted filesystems without
crashing.  (Some of the newer features like uninit groups and flexbg
isn't in e2fsprogs-interim, though.)  Fixing up the extents support is
very high on my priority list over the next couple of weeks, but at
the moment e2fsck on the 'pu' branch will correctly check an ext4
filesystem with extents that isn't too badly corrupted; a badly
corrupted one will cause e2fsck to crash.  It will get better, I
promise you!  :-)

Regards,

					- Ted
