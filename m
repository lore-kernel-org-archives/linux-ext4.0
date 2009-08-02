From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fix device too big bug in mainline?
Date: Sat, 1 Aug 2009 20:28:33 -0400
Message-ID: <20090802002833.GB8680@mit.edu>
References: <20090730215302.GA31141@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51226 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZHBA2m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Aug 2009 20:28:42 -0400
Content-Disposition: inline
In-Reply-To: <20090730215302.GA31141@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 30, 2009 at 05:53:02PM -0400, Valerie Aurora wrote:
> Hi all,
> 
> Currently, e2fsprogs will fail to create a file system if the
> underlying device is "too big" - even if we specify a number of blocks
> to use that is in range:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=485236
> 
> This is fixed in the current pu branch, but more as a side effect of
> an enormous 64-bit rewrite.
> 
> Ted, any plans to pull this into mainline?

We have a special case as of v1.41.4 so that if someone creates a 16TB
partition, we'll treat it as having 16TB - 1 minus blocks.

Yes, I'm working on merging the 64-bit patches into mainline; and so
far we have about 25% or so of the patches merged into the master
branch.  It's been somewhat slow going, since I've many other things
on my plate, and because I've wanted to do a lot of QA while doing the
merge.  I've found more than a few bugs simply by doing code
inspection while merging the patches one at a time.

How much do we care about this specific bug as something that needs to
be fixed ASAP?  We already have something for a 16TB logical volume,
since that is what is most likely to be created with lvcreate.  But do
we consider it a common case where someone creates a 32TB logical
volume, but intends to create a 16TB (minus 1 block) filesystem, that
needs to be urgently fixed?

            					- Ted
