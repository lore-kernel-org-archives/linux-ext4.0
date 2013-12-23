From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Mon, 23 Dec 2013 09:51:35 -0500
Message-ID: <20131223145135.GA12353@thunk.org>
References: <20131219152049.GB19166@parisc-linux.org>
 <20131219161728.GA9130@thunk.org>
 <20131219171201.GD19166@parisc-linux.org>
 <20131219171848.GC9130@thunk.org>
 <20131220181731.GG19166@parisc-linux.org>
 <20131220193455.GA6912@thunk.org>
 <20131220201059.GH19166@parisc-linux.org>
 <20131223033641.GF3220@dastard>
 <20131223034554.GA11091@parisc-linux.org>
 <20131223065641.GI3220@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew@wil.cx>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42787 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3LWOvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 09:51:42 -0500
Content-Disposition: inline
In-Reply-To: <20131223065641.GI3220@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 05:56:41PM +1100, Dave Chinner wrote:
> IOWs, I don't see XIP as something that should be tacked on to the
> side of the filesystems and bypass the normal IO paths. it's
> somethign that should be integrated directly and used automatically
> if it can be used. And that requires persistent memory to be treated
> as pages just like volatile memory.

I agree with Dave's suggestions here completely.  However, for the
long term...

> If the persistent memory device can hand us struct pages rather than
> mapped memory handles, we don't need to change our data indexing
> methods, nor do we need to change the way data in the page cache is
> accessed. mmap() gets direct access, just like the current XIP, but
> we can use all of the smarts filesystems have for optimal
> block allocation.

I suspect in the long term, or a least for persistent memory, the mm
subsystem is going to have to move away from having a struct page for
every 4k region of memory.  This just doesn't scale very well, and
especially in the case of persistent memory, where we might in the
long run have terrabytes of the stuff (assuming the price comes down,
but hopefully they will), it probably makes sense to have some kind of
struct page_extent structure which covers a region of pages.

After all, there are portions of the struct page which aren't needed
for persistent memory.  We don't need to scan persistent memory and we
don't need to deactivate pages of persistent memory (since it's not
like we can reuse the persistent memory page for anything else so long
as it belongs to an allocated file).

But all of this is in the long-term.  In the short term, I suspect the
reality is that whatever interfaces we try to set up for persistent
memory, they will probably have to be rewritten and rototilled at
least once or twice more.

After all, this stuff isn't available in real life, and we don't know
which variants of the technology will win out, in terms of
price/performance and market acceptance.  Some of them may require
double-buffering where you map in the page read-only, but if you need
to modify the page, you really want to make a copy-on-write to
traditional RAM (because writes, though faster than flash and byte
addressable, might still be slow enough --- say, 2x or 3x --- that you
wouldn't want to be doing a lot of calculations and modifications to
the persistent memory.)

So we do need to worry about overdesign.  Maybe it will be better to
do something simple/crappy/stupid initially, with the understanding
that it might not be the kindest as far as write cycles or
performance, but with the expectation that it will have to be
rewritten later.  After all, this isn't like a file system format
where once we have committed to the format, it is really painful to
change.

How many times have we written the network stack?  Three, four, five
times depending on how you count?  It's true we haven't been as lucky
at being able to rev block layer when it has desparately needed
rototilling and rewriting in the past, but maybe we should accept the
fact that we _will_ get it wrong this second time that we rewrite XIP,
and just try to make it be less painful when we need to rewrite it the
for the third time...

          	     	     	     - Ted
