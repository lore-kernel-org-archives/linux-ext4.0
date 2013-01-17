From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: Use redirty_page_for_writepage() in
 ext4_bio_write_page()
Date: Thu, 17 Jan 2013 13:35:01 -0500
Message-ID: <20130117183501.GD29972@thunk.org>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44036 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3AQSfD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2013 13:35:03 -0500
Content-Disposition: inline
In-Reply-To: <1357148744-4895-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2013 at 06:45:41PM +0100, Jan Kara wrote:
> When we cannot write a page we should use redirty_page_for_writepage()
> instead of plain set_page_dirty(). That tells writeback code we have
> problems, redirties only the page (redirtying buffers is not needed),
> and updates mm accounting of failed page writes.
> 
> Also move clearing of buffer dirty flag after io_submit_add_bh(). At that
> moment we are sure buffer will be going to disk.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This sounds like a bug fix, not just a clean up.  Do you think the
impact of not using redirty_page_for_writeback() is bad enough that we
should add a cc: stable@vger.kernel.org tag?  As I recall, not doing
this would end up leaving the page flags and radix tree to be
inconsistent, right?

	    	       	   	      - Ted
