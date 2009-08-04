From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fix device too big bug in mainline?
Date: Tue, 4 Aug 2009 18:12:00 -0400
Message-ID: <20090804221200.GP28678@mit.edu>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090804182811.GG9324@shell> <20090804204122.GL28678@mit.edu> <20090804212937.GM9324@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35957 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbZHDWMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 18:12:10 -0400
Content-Disposition: inline
In-Reply-To: <20090804212937.GM9324@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 04, 2009 at 05:29:37PM -0400, Valerie Aurora wrote:
> 
> Yeah, it's pretty hard to keep track of which branch does what after
> several months go by.  Maybe next time we can sync up first if it's
> been a while since the last review/pull request.
> 

Well, if you are planning on doing more e2fsprogs work, why not work
against a shared patch queue which is under git control?  That way we
don't need to do explicit sync ups.

Once we have more than one person with write access into the patch
queue, if someone plans to make changes that involve reorganizing or
refactoring patches, they should send e-mail to take a "lock" on the
patch queue.  I normally work on the patch queue in concentrated
bursts, usually in the evenings or on the weekends, so if you're going
to "take the lock" to work on the patch queue during the day, we're
not likely to collide with each other.

I believe this will be a far more efficient way of working together,
which won't require massive "sync up" efforts.

					- Ted
