From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Fri, 16 Aug 2013 10:39:18 -0400
Message-ID: <20130816143917.GA10304@thunk.org>
References: <20130722013831.GE11674@dastard>
 <20130722021742.GA24195@gmail.com>
 <20130722100255.GF11674@dastard>
 <20130722125745.GA2827@gmail.com>
 <20130730030807.GI21982@dastard>
 <20130804012740.GC19781@thunk.org>
 <20130813031057.GV12779@dastard>
 <5209A649.90406@redhat.com>
 <20130813130459.GD8902@thunk.org>
 <20130816032124.GJ12779@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44575 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3HPOjX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Aug 2013 10:39:23 -0400
Content-Disposition: inline
In-Reply-To: <20130816032124.GJ12779@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 16, 2013 at 01:21:24PM +1000, Dave Chinner wrote:
> 
> Sure, we know all that. But you haven't answered the question being
> asked which was whether FIEMAP can acheive what you need. You've
> already admitted it can populate the extent cache for ext4, so
> there's little else that is needed to pin the extents is reads in a
> range in the cache. Just one flag...

I thought you were asking a different question, which is whether we
could just use FIEMAP and not try to soft-pin the extents in the
cache.  And the answer to that is no.

If the argument is that you think it's better to allocate an extra bit
to FIEMAP rather than allocate a new ioctl code --- shrug.  I'm not
sure why you're making such a big deal about that; it's not like we're
short on ioctl code points.  I'm willing to do this, although if we
keep on getting API bikeshedding, my fallback position is to just
implement this as an ext4-specific ioctl and call it a day.

I am curious whether any other file system is actually going to
implement this or not, though.  If everyone else is convinced that
their file system is so wonderful that they don't need this, or this
is just a wierdo Google use case, I'm not sure why we're spending so
much time bikeshedding the APi.

						- Ted
