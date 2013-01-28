From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/12] ext4: Simplify mpage_add_bh_to_extent()
Date: Mon, 28 Jan 2013 13:06:32 -0500
Message-ID: <20130128180632.GJ22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45894 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682Ab3A1SGg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 13:06:36 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-11-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:44PM +0100, Jan Kara wrote:
> The argument b_size of mpage_add_bh_to_extent() was bogus since it was
> always == blocksize (which we can easily derive from inode->i_blkbits).
> Also second branch of condition:
> 	if (nrblocks >= EXT4_MAX_TRANS_DATA) {
> 	} else if ((nrblocks + (b_size >> mpd->inode->i_blkbits)) >
> 						EXT4_MAX_TRANS_DATA) {
> 	}
> was never taken because (b_size >> mpd->inode->i_blkbits) == 1.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
