From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Tue, 13 Aug 2013 09:04:59 -0400
Message-ID: <20130813130459.GD8902@thunk.org>
References: <20130719033309.GQ11674@dastard>
 <20130719161930.GF17938@thunk.org>
 <20130722013831.GE11674@dastard>
 <20130722021742.GA24195@gmail.com>
 <20130722100255.GF11674@dastard>
 <20130722125745.GA2827@gmail.com>
 <20130730030807.GI21982@dastard>
 <20130804012740.GC19781@thunk.org>
 <20130813031057.GV12779@dastard>
 <5209A649.90406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43171 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab3HMNFE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Aug 2013 09:05:04 -0400
Content-Disposition: inline
In-Reply-To: <5209A649.90406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 12, 2013 at 10:21:45PM -0500, Eric Sandeen wrote:
> 
> Reading extents via fiemap almost certainly moves that metadata into
> kernel cache, simply by the act of reading the block device to get them.

Well, if the file system has an extent cache.  It certainly will end
up reading the pages involved with the extents into the buffer and/or
page cache (depending on how the file system does things).

> I see Dave's point that we _do_ have an interface today to read
> all file extents into cache.  We don't mark them as particularly sticky,
> however.
> 
> This seems pretty clearly driven by a Google workload need; something you
> can probably test.  Does FIEMAP do the job for you or not?  If not, why not?

If you are using memory containers the way we do, in practice every
single process is going to be under memory pressure.  See previous
comments I've made about why in a cloud environment, memory is your
most precious resource, since motherboards have limited numbers of
DIMM slots, and high-density DIMMS are expensive --- this is why
services like Amazon EC2 and Linode charge $$$ if you need much more
than 512mb of memory.  This is because in order to make cloud systems
cost effective from a financial ROI point of view (especially once you
include power and cooling costs), you need to pack a large number of
workloads on each machine, and this is true regardless of whether you
are using containers or VM's as your method of isolation.

So basically, if you are trying to use your memory efficiently, _and_
you are trying to meet 99.9 percentile latency SLA numbers for your
performance-critical workloads, you need to have a way of telling the
system that certain pieces of memory (in this case, certain parts of
the extent cache) are more important than others (for example, a
no-longer-used inode/dentry in the inode/dentry cache or other slab
objects).

						- Ted

P.S.  In previous versions of this patch (which never went upstream,
using a different implementation which also never went upstream), this
ioctl nailed the relevant portions of the extent cache into memory
permanently, and they wouldn't be evicted no matter how much memory
pressure you would be under.  In the Google environment, this wasn't a
major issue, since all jobs run under a restrictive memory container
and so a buggy or malicious program which attempted to precache too
many files would end up OOM-kiling itself (after which point the
situation would correct itself).

In this version of the patch, I've made the cache entries sticky, but
they aren't permanently nailed in place.  This is because not all
systems will be running with containers, and I wanted to make sure we
had a safety valve against abuse.  Could someone still degrade the
system performance if they tried to abuse this ioctl?  Sure, but
someone can do the same thing with a "while (1) fork();" bomb.
