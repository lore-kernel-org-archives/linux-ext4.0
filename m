From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Don't report uninit extents past EOF invalid
Date: Tue, 13 Aug 2013 22:49:03 -0400
Message-ID: <20130814024903.GB11064@thunk.org>
References: <20130721202849.GB2331@wallace>
 <52096DF5.9090700@redhat.com>
 <52096F9E.3060801@redhat.com>
 <52097153.4000600@redhat.com>
 <20130813163112.GA4990@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43376 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759240Ab3HNCtI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Aug 2013 22:49:08 -0400
Content-Disposition: inline
In-Reply-To: <20130813163112.GA4990@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 13, 2013 at 12:31:12PM -0400, Eric Whitney wrote:
> Clearly, I wasn't thinking about the ABI at all - thanks for pointing out
> that misstep.
> 
> So, I'd like to withdraw that patch, please, and will post a V2 in a bit.
> Computing the eof_blk in that manner is better than an initial patch I had
> that worked but which was pretty ugly.

It didn't really make sense to put the eof_blk in the extent_info
structure, anyway, since it's not information about the that specific
extent.  It's an inode-specific value which is set via:

	handle->path[0].end_blk =
		(EXT2_I_SIZE(handle->inode) + fs->blocksize - 1) >>
		 EXT2_BLOCK_SIZE_BITS(fs->super);

Right?  So this is something you can calculate without making any
changes in lib/ext2fs/extent.c, unless I'm missing something.

							- Ted
