From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v4 1/6] Always read full inode structure
Date: Sun, 6 Mar 2016 14:31:34 -0500
Message-ID: <20160306193134.GN10297@thunk.org>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com>
 <1457237696-13770-2-git-send-email-lixi@ddn.com>
 <20160306054622.GK10297@thunk.org>
 <3DEDB39A-8511-470C-A438-726E2672B821@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37924 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbcCFTbi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 14:31:38 -0500
Content-Disposition: inline
In-Reply-To: <3DEDB39A-8511-470C-A438-726E2672B821@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 11:27:25PM -0700, Andreas Dilger wrote:
> Do you think it really makes e2fsprogs less efficient?  The disk IO has
> already happened, and definitely included the whole inode even if only
> the small inode data was requested.  The ext2fs block cache will still
> cache the whole inode block, so fetching the whole inode is no overhead.

I'm concerned about all of the extra memory allocation and
deallocation that we would need to do.  If you have a million inodes,
that's a million malloc()'s and free()'s.


> In contrast, several places in the code are doing extra work to fetch
> the large inode data after having fetched the small inode data.  It is
> also fairly confusing in different parts of the code which "know" that
> the inode pointer is pointing to a full inode buffer, so it is a lot
> cleaner if we just always read the full inode data everywhere.

Can you point at some of these places?  See below, but I think it's a
lot more complicated to do what you are suggested.

> Even better would be if the API explicitly just passed ext4_inode_large
> everywhere, which wouldn't break the ABI, but it might cause problems
> for anything that encodes the argument types (e.g. C++).  At least if
> the e2fsprogs internal functions are reading the full inode the code is
> easier to understand.

For the inode structure, for better or for worse, we have a "caller
allocates" convention.  So we can't just fill in the full inode unless
the caller explicitly requests it, and tells us how much space it has
available.

Also, if the caller passes in a pointer to struct ext2_inode, the
library can't assume it's a full inode.  Fortunately, in the vast
majority of the places where the library needs to look at the inode,
it doesn't need to look at the full inode.

Cheers,

					- Ted
