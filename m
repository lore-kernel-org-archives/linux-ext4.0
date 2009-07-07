From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: reset handle after inserting new extent
Date: Tue, 7 Jul 2009 09:35:07 -0400
Message-ID: <20090707133507.GL31532@mit.edu>
References: <4A52776B.8000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36128 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbZGGNfQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jul 2009 09:35:16 -0400
Content-Disposition: inline
In-Reply-To: <4A52776B.8000203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 06, 2009 at 05:15:07PM -0500, Eric Sandeen wrote:
> Commit 53422e8a5644e22ea3f6e0efba82a765b72e4308 moved
> the new extent insertion in ext2fs_extent_set_bmap prior
> to the modification of the original extent, but the
> insert function left the handle pointing a the new
> extent; this left us modifying the -new- extent not
> the original one, and winding up with a corrupt extent
> tree something like:
> 
> BLOCKS:
> (0-1):588791-588792, (0):588791
> 
> We need to move back to the previous extent prior
> to modification, if we inserted a new one.

Hmm, I just thought of something awful; what if the insert resulted in
a node split?  Instead of using ext2fs_extent_get(EXT2_EXTENT_PREV),
we may need to use ext2fs_extent_goto() to seek to the correct logical
block instead.

						- Ted
