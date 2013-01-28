From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/12] ext4: Use redirty_page_for_writepage() in
 ext4_bio_write_page()
Date: Mon, 28 Jan 2013 09:34:35 -0500
Message-ID: <20130128143435.GC22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45855 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab3A1Oem (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:34:42 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:36PM +0100, Jan Kara wrote:
> When we cannot write a page we should use redirty_page_for_writepage()
> instead of plain set_page_dirty(). That tells writeback code we have
> problems, redirties only the page (redirtying buffers is not needed),
> and updates mm accounting of failed page writes.
> 
> Also move clearing of buffer dirty flag after io_submit_add_bh(). At that
> moment we are sure buffer will be going to disk.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
