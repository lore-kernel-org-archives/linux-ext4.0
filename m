From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Date: Sat, 6 Jun 2009 01:23:06 +0200
Message-ID: <20090605232306.GD11650@duck.suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <20090527142332.GB10842@mit.edu> <20090527145911.GH16006@duck.suse.cz> <20090604171142.GB13639@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZFEXXG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 19:23:06 -0400
Content-Disposition: inline
In-Reply-To: <20090604171142.GB13639@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 04-06-09 13:11:42, Theodore Tso wrote:
> On Wed, May 27, 2009 at 04:59:11PM +0200, Jan Kara wrote:
> >   Yes, that would be fine. Thanks. Luckily, the dependence is just one way
> > (ext4 change has to go after the VFS patch) so it's just enough to merge
> > that ext4 change some time after VFS changes go in.
> 
> ext4: Add WARN_ON on unmapped dirty buffer_heads in writepage
> fs: Don't clear dirty bits in block_write_full_page()
> vfs: Unmap underlying metadata of new data buffers only when buffer is m
> ext4: Make sure blocks are properly allocated under mmaped page even whe
> vfs: Add better VFS support for page_mkwrite when blocksize < pagesize
> 
> FYI, I've added the following to the unstable portion of the patch
> queue, and have started running tests (fsx, fsstress, and dbench)
> using 1k blocksizes, using a variety of ext4 mount options.  So far,
> things look good.
  Thanks for the merge and testing!

> How goes the reviews/comments?  Are we planning on pushing this to
> Linus at the beginning of the next merge window?
  I'd like to get some VFS / MM people review the generic part of the
change... I guess I'll post a request to linux-mm to catch more attention.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
