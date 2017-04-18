From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4-lazy (SMR-optimizations) landing to kernel?
Date: Mon, 17 Apr 2017 23:28:43 -0400
Message-ID: <20170418032843.pg4gwqdaclbqubkg@thunk.org>
References: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
 <c2d584af-c91b-bcbb-ac13-d1e9e6162a4b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        linux-ext4 <linux-ext4@vger.kernel.org>, tahsin@google.com
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45458 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753860AbdDRD2s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Apr 2017 23:28:48 -0400
Content-Disposition: inline
In-Reply-To: <c2d584af-c91b-bcbb-ac13-d1e9e6162a4b@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 17, 2017 at 09:18:11AM -0500, Eric Sandeen wrote:
> On 4/10/17 10:06 PM, Andreas Dilger wrote:
> > Hi Ted,
> > now that FAST'17 is behind us, is there any plan to land the ext4-lazy code
> > (SMR optimizations) to the upstream kernel?  This looks like it improves
> > some workloads even without SMR disks, and doesn't have any noticeable
> > overhead for other workloads.

There is a plan to do this, but I've been crazy busy lately.  A
colleague of mine, Tashin Erdogan, has been taking a look at it.  It
looks like the fault may be mine, in that Abutalib's original patch
complately disabled the normal journalling paths, and for upstream
adoption we need to keep the original paths working until we're really
sure the new mode is an always a win.  It looks like I might not have
done a complete job suppressing the original checkpointing code,
resulting in some journal transaction getting trimmed when they
shouldn't have been.   But we'll see.

> > to optionally checkpoint the metadata to the filesystem in the background,
> > when the filesystem is otherwise idle, so that in case of journal loss for
> > some reason the whole filesystem is not lost?

So long as this isn't a SMR disk, some kind of background trickle to
the final location is indeed something we can do.  It's probably
better to focus on stablizing the existing feature first, and then get
the cleaner to be smarter about its hueristics first, though.
Checkpointing metadata to the file system when the file system is idle
and if the system is not running on battery power on a laptop are both
examples of an advanced cleaner policy, and there are probably simpler
hueristics that we might want to do first.

> IIRC even the new larger default journal size was a big win by itself, yes?

It's a big win for workloads that have a sufficiently heavy metadata
workload that the journal size was forcing blocking, synchronous
checkpoint operations.  For many customer workloads it won't make any
difference at all, of course.

	      			- Ted
