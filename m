From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 v4] ext4: fix xfstests 75, 112, 127 punch hole
 failure
Date: Wed, 10 Aug 2011 23:17:12 -0400
Message-ID: <20110811031712.GF3625@thunk.org>
References: <1312698112-7836-1-git-send-email-achender@linux.vnet.ibm.com>
 <20110808024213.GC11497@thunk.org>
 <4E404D06.6010002@linux.vnet.ibm.com>
 <20110809164524.GA3422@thunk.org>
 <4E41A254.3030300@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46378 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1HKDRW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 23:17:22 -0400
Content-Disposition: inline
In-Reply-To: <4E41A254.3030300@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 09, 2011 at 02:10:44PM -0700, Allison Henderson wrote:
> >	/*
> >	 * Now we need to zero out the non-block-aligned data.
> >	 * If the file space being truncated is smaller than
> >	 * than a block, just zero out the middle
> >	 */
> >
> Hmm, for this piece here, Im not sure I quite follow you.  I was
> pretty sure that ext4_block_zero_page() only deals with ranges that
> appear with in one block.  

Yes, that's true.  What I was objecting to in the comment is the
phrase "smaller than a block".  That's not right, or it's only right
if blocksize == page size.  That comment should really read, "if the
file space is smaller than a ***page***" zero out the middle.

That's what happens in ext4_block_zero_page(), and so it works
correctly; but the comment is confusing, and it makes the reader think
that all we only need to zero is based on block boundaries, when in
fact when we look at zeroing memory, we have to base it on page
boundaries.

Basically for either punch or truncate what we must do is:

   *) Zero partial pages
   *) Unmap full pages
   *) We take buffer_heads which have been freed and either
      (a) detach them, or 
      (b) clear the mapped flag, to indicate that the block number
           in the bh is invalid 

Using "unmap" for both pages and blocks can be confusing, since for
pages, unmapping means that we remove the page completely from the
page cache, so any future attempt to read from that virtual memory
address will result in a zero page getting mapped in.

However, for buffers, "unmapping" merely means that we are removing
the mapping to the disk block which has been deallocated by the punch
operation.  It does not result in anything getting zero'ed out in the
_page_ cache, which is why we need to zero out partial pages.

Does that make sense?

						- Ted
