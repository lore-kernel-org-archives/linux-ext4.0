From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: prompt for user verification for "-S"
Date: Fri, 19 Jun 2015 21:38:18 -0400
Message-ID: <20150620013818.GC29480@thunk.org>
References: <1432334588-18387-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46034 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbbFTBiT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2015 21:38:19 -0400
Content-Disposition: inline
In-Reply-To: <1432334588-18387-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2015 at 04:43:08PM -0600, Andreas Dilger wrote:
> Prompt for user verification before rewriting the filesystem
> superblocks using the "-S" (super-only) option.  This should
> not normally be used at all, so adding the extra verification
> will probably save a few user filesystems in the future.  Since
> this is something that should only be done in rare cases under
> user supervision, wait for user input rather than proceeding
> automatically after a timeout.
> 
> Update the mke2fs man page to more fully explain the many
> dangers of this option.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
