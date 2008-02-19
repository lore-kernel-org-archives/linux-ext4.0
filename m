From: Theodore Tso <tytso@mit.edu>
Subject: Re: How were some of the lustre e2fsprogs test cases generated?
Date: Tue, 19 Feb 2008 07:29:25 -0500
Message-ID: <20080219122925.GW25098@mit.edu>
References: <E1JRG0g-0001lz-Ur@closure.thunk.org> <20080219114032.GL3029@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56581 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751041AbYBSM31 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 07:29:27 -0500
Content-Disposition: inline
In-Reply-To: <20080219114032.GL3029@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2008 at 04:40:32AM -0700, Andreas Dilger wrote:
> 
> No, it hasn't always been true that we cleared the _hi fields in the
> kernel code.  But, it has been a year or more since we found this bug,
> and all CFS e2fsprogs releases since then have cleared the _hi fields,
> and there has not been any other e2fsprogs that supports extents, so
> we expect that there are no filesystems left in the field with this
> issue, and even then the current code will prefer to clear the _hi
> bits instead of considering the whole extent corrupt.
> 

I checked again, and it looks like the interim code is indeed clearing
the _hi bits.  I managed to confuse myself into thinking it didn't for
index nodes, but I checked again and it seems to be doing the right
thing.

The reason why I asked is that the extents code in the 'next' branch
of e2fsprogs *does* consider the whole extent to be corrupt, since in
the long run once we start 64-bit block number extent blocks, if the
physical block number (including the high 16 bits) is greater than
s_blocks_count, simply masking off the high 16 bits of the 48 bit
extent block is probably not the right way of dealing with the
problem.

I think that's probably a safe thing to do since all of your customers
who might have had a filesystem with non-zero _hi fields have almost
certainly run e2fsck to clear the _hi bits at least once; do you
concur that is a safe assumption?  Or would you prefer that I add some
code that tries to clear just the _hi bits, perhaps controlled by a
configuration flag in e2fsck.conf?

Regards,

						- Ted
