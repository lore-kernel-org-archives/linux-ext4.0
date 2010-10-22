From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/6] ext4: call mpage_da_submit_io() from mpage_da_map_blocks()
Date: Fri, 22 Oct 2010 12:29:12 -0600
Message-ID: <59D861FB-F630-4F5A-87A3-2E2DFE6FA237@dilger.ca>
References: <1287761366-20249-1-git-send-email-tytso@mit.edu> <1287761366-20249-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:56200 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0JVS3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 14:29:13 -0400
In-Reply-To: <1287761366-20249-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-22, at 09:29, Theodore Ts'o wrote:
> @@ -2323,10 +2323,13 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
> 		disksize = i_size_read(mpd->inode);
> 	if (disksize > EXT4_I(mpd->inode)->i_disksize) {
> 		ext4_update_i_disksize(mpd->inode, disksize);
> -		return ext4_mark_inode_dirty(handle, mpd->inode);
> +		err = ext4_mark_inode_dirty(handle, mpd->inode);
> +		/* XXX not sure what our error handling straegy is here */

(typo) s/straegy/strategy/

I don't think this is necessarily fatal.  It looks like the only time we can fail from ext4_mark_inode_dirty() is cases of IO errors or bad inode numbers and such (which should have been caught already).   At worst, if the blocks are newly mapped (and referenced directly from the inode) then the new blocks would be leaked and the data would be unreachable.  These should already have marked the filesystem in error, so it may be any error here is irrelevant.

Cheers, Andreas





