From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext2fs: Handle internal journal over 2^32 bytes
Date: Sat, 11 Jun 2011 12:21:28 -0400
Message-ID: <20110611162128.GK11207@thunk.org>
References: <1307700019-4551-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55645 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1FKQVc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 12:21:32 -0400
Content-Disposition: inline
In-Reply-To: <1307700019-4551-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 04:00:17AM -0600, Andreas Dilger wrote:
> The write_journal_inode() code is only setting the low 32-bit i_size
> for the journal size, even though it is possible to specify a journal
> up to 10M blocks in size.  Trying to create a journal larger than 2GB
> will succeed, but an immediate e2fsck would fail.  Store i_size_high
> for the journal inode when creating it, and load it upon access.
> 
> Use s_jnl_blocks[15] to store the journal i_size_high backup.  This
> field is currently unused, as EXT2_N_BLOCKS is 15, so it is using
> s_jnl_blocks[0..14], and i_size is in s_jnl_blocks[16].
> 
> Rename the "size" argument "num_blocks" for the journal creation functions
> to clarify this parameter is in units of filesystem blocks and not bytes.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Added to the next branch, thanks.

						- Ted
