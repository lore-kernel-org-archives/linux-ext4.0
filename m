From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: Fix lost truncate due to race with writeback
Date: Sat, 17 Aug 2013 10:12:27 -0400
Message-ID: <20130817141227.GG30769@thunk.org>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
 <1375710744-29329-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45007 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab3HQOMb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Aug 2013 10:12:31 -0400
Content-Disposition: inline
In-Reply-To: <1375710744-29329-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 05, 2013 at 03:52:24PM +0200, Jan Kara wrote:
> The following race can lead to a loss of i_disksize update from truncate
> thus resulting in a wrong inode size if the inode size isn't updated
> again before inode is reclaimed:
> 
> ext4_setattr()				mpage_map_and_submit_extent()
>   EXT4_I(inode)->i_disksize = attr->ia_size;
>   ...					  ...
> 					  disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT
> 					  /* False because i_size isn't
> 					   * updated yet */
> 					  if (disksize > i_size_read(inode))
> 					  /* True, because i_disksize is
> 					   * already truncated */
> 					  if (disksize > EXT4_I(inode)->i_disksize)
> 					    /* Overwrite i_disksize
> 					     * update from truncate */
> 					    ext4_update_i_disksize()
>   i_size_write(inode, attr->ia_size);
> 
> For other places updating i_disksize such race cannot happen because
> i_mutex prevents these races. Writeback is the only place where we do
> not hold i_mutex and we cannot grab it there because of lock ordering.
> 
> We fix the race by doing both i_disksize and i_size update in truncate
> atomically under i_data_sem and in mpage_map_and_submit_extent() we move
> the check against i_size under i_data_sem as well.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
