From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] ext4: Simplify io_end handling for AIO DIO
Date: Tue, 8 Mar 2016 23:38:34 -0500
Message-ID: <20160309043834.GE3150@thunk.org>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
 <1455897582-13292-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49298 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbcCIEih (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2016 23:38:37 -0500
Content-Disposition: inline
In-Reply-To: <1455897582-13292-6-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 04:59:41PM +0100, Jan Kara wrote:
> When mapping blocks for direct IO, we allocate io_end structure before
> mapping blocks and store pointer to it in the inode. This creates a
> requirement that any AIO DIO using io_end must be protected by i_mutex.
> This created problems in the past with dioread_nolock mode which was
> corrupting io_end pointers. Also io_end is allocated unnecessarily in
> case where we don't need to convert any extents (which is a common case
> for example when overwriting file).
> 
> We fix the problem by allocating io_end only once we return unwritten
> extent from block mapping function for AIO DIO (so we can save some
> pointless io_end allocations) and we pass pointer to it in bh->b_private
> which generic DIO code later passes to our end IO callback. That way we
> remove any need for global pointer to io_end structure and thus fix the
> races.
> 
> The downside of this change is that the checking for unwritten IO in
> flight in ext4_extents_can_be_merged() is more racy since we now
> increment i_unwritten / set EXT4_STATE_DIO_UNWRITTEN only after dropping
> i_data_sem. However the check has been racy already before because
> ext4_writepages() already increment i_unwritten after dropping
> i_data_sem and reserved blocks save us from hitting ENOSPC in the worst
> case.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
