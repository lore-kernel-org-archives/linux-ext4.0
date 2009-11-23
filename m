From: tytso@mit.edu
Subject: Re: Bug in extent zeroout: blocks not marked as new
Date: Mon, 23 Nov 2009 18:20:04 -0500
Message-ID: <20091123232004.GG2183@thunk.org>
References: <6601abe90911231017q5cf424a4s4e6c788922c336c8@mail.gmail.com>
 <20091123195049.GD2183@thunk.org>
 <1259011043.25937.29.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60521 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbZKWXUB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 18:20:01 -0500
Content-Disposition: inline
In-Reply-To: <1259011043.25937.29.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 01:17:23PM -0800, Frank Mayhar wrote:
> I think the missing bit of information here is that this is happening on
> converted ext2 partitions.  Older non-extent-based files are being
> gradually removed while new extent-based files are being created.  Last
> week, Curt found that in certain cases newly-reallocated metadata blocks
> are being hit; these metadata blocks just happen to be newly-emptied
> indirect blocks (freed by a recent delete), which just happen to have
> been filled with zeroes as they were emptied.  As I recall, Curt found
> that these were pretty clearly the source of the blocks being written in
> this case.

Ah, right, the zero'ed blocks are coming from indirect blocks of files
that were being unlinked/truncated.  Got it.

> Finally, we have a question about the zero-out path:  Is there any
> known, concrete improvement given by doing the zero-out as opposed to
> just continuing to split the extents?  At the moment, by the way, there
> is one definite problem: Since it doesn't try to do a merge left (which
> it should) it invariably leaves a 14-block extent fragment, thus
> increasing fragmentation of the file.  It's not a huge problem (since
> the extents are in fact contiguous) but it's there.

Reducing extents "fragmentation" (the number of extents in the extent
tree, even though the block allocation remains contiguous) was one
reason.  Another was reducing the number of blocks that need to be
journaled, and in the case where adding an extent might cause a split;
this can be problematic if we don't have any more free blocks
available, and at the moment, not only do we not have any tree merging
code, we don't have code to decrease the tree depth once an extent
split forces us to increase the height of the tree.

Also, a contiguous write should be faster than needing to seek to the
extent tree leaf block as well as to the journal, although we haven't
measured whether the breakpoints for when we split the extent and when
we do the zero-out are ideal.  That's something we should do.

      	  	       	       	      		- Ted
