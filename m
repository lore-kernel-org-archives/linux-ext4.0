From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: Fix device too big bug in mainline?
Date: Mon, 3 Aug 2009 14:04:05 -0400
Message-ID: <20090803180405.GC10853@shell>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZHCSEG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 14:04:06 -0400
Content-Disposition: inline
In-Reply-To: <20090802002833.GB8680@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 01, 2009 at 08:28:33PM -0400, Theodore Tso wrote:
> On Thu, Jul 30, 2009 at 05:53:02PM -0400, Valerie Aurora wrote:
> > Hi all,
> > 
> > Currently, e2fsprogs will fail to create a file system if the
> > underlying device is "too big" - even if we specify a number of blocks
> > to use that is in range:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=485236
> > 
> > This is fixed in the current pu branch, but more as a side effect of
> > an enormous 64-bit rewrite.
> > 
> > Ted, any plans to pull this into mainline?
> 
> We have a special case as of v1.41.4 so that if someone creates a 16TB
> partition, we'll treat it as having 16TB - 1 minus blocks.
> 
> Yes, I'm working on merging the 64-bit patches into mainline; and so
> far we have about 25% or so of the patches merged into the master
> branch.  It's been somewhat slow going, since I've many other things
> on my plate, and because I've wanted to do a lot of QA while doing the
> merge.  I've found more than a few bugs simply by doing code
> inspection while merging the patches one at a time.
> 
> How much do we care about this specific bug as something that needs to
> be fixed ASAP?  We already have something for a 16TB logical volume,
> since that is what is most likely to be created with lvcreate.  But do
> we consider it a common case where someone creates a 32TB logical
> volume, but intends to create a 16TB (minus 1 block) filesystem, that
> needs to be urgently fixed?

I've only talked to one customer who ran into this problem, and they
were testing, not doing anything in production.  The bug is pretty
easy to workaround - just partition your device or shrink your logical
volume.  Obviously, there's no point in having a partition larger than
16TB without the 64-bit feature since you can't grow the file system
to larger than that.  On the other hand, it offends my sensibilities
to have a known bug in a release.

To me, it seems reasonable to wait to fix this bug until the 64-bit
stuff goes in, especially since you'd have to write a fix from
scratch, since you can't backport the 64-bit version.  However, you
are the maintainer; if you think it should be fixed sooner then I'll
go ahead and write it.

-VAL
