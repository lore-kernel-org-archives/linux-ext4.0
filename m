From: Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.21-ext4-1
Date: Mon, 30 Apr 2007 13:45:30 -0400
Message-ID: <20070430174530.GC19149@thunk.org>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org> <46362463.5010309@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Dave Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48029 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031576AbXD3Rpo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2007 13:45:44 -0400
Content-Disposition: inline
In-Reply-To: <46362463.5010309@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 30, 2007 at 01:16:19PM -0400, Jeff Garzik wrote:
> Why isn't this stuff going upstream rapidly?

Some of the patches are ready to be pushed upstream, and that will be
happening shortly.

In the case of the fallocate patches, the system call interface hadn't
been completely closed, so we don't want to push it until we have
closure and consensus.  The previous versions of the patches used an
ioctl interface that would have gotten potshots from the
all-ioctls-are-evil camp, and it was clear that a unified system call
interface was the right thing.  So we wanted to make sure the XFS
folks were happy with the interface as well before we pushed it.

In general, yes, ext4 development has been a little slow; part of the
problem is that we have a lot of people, but a number of folks are new
and their patches need review before they are ready for upstream
acceptance, and a number of other folks who should be doing the review
have been overloaded with multiple other projects and have been
time-sharing.

> The whole point of having ext4 in the kernel is to do development 
> upstream, in the public view, getting new stuff in ASAP (even if that 
> means changing or pulling some stuff later).

That's true, but we also get flamed when the patches don't meet
various criteria, up to and including breaking on ia64.  We are in the
process of setting up automated testing to help address that problem,
but it's a taken a little while to get that going.  I'm also trying to
schedule more time so I can do the needed review of the patches so
they meet basic upstream standards so we *can* push them.  If other
folks would like to help with the review process, that would be more
than welcome.

But yes, we will try to get more of the patches pushed sooner rather
than later.  Point taken.

						- Ted
