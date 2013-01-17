From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] ext4: Use redirty_page_for_writepage() in
 ext4_bio_write_page()
Date: Thu, 17 Jan 2013 22:24:15 +0100
Message-ID: <20130117212415.GD23984@quack.suse.cz>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-3-git-send-email-jack@suse.cz>
 <20130117183501.GD29972@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab3AQVYS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2013 16:24:18 -0500
Content-Disposition: inline
In-Reply-To: <20130117183501.GD29972@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 17-01-13 13:35:01, Ted Tso wrote:
> On Wed, Jan 02, 2013 at 06:45:41PM +0100, Jan Kara wrote:
> > When we cannot write a page we should use redirty_page_for_writepage()
> > instead of plain set_page_dirty(). That tells writeback code we have
> > problems, redirties only the page (redirtying buffers is not needed),
> > and updates mm accounting of failed page writes.
> > 
> > Also move clearing of buffer dirty flag after io_submit_add_bh(). At that
> > moment we are sure buffer will be going to disk.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> This sounds like a bug fix, not just a clean up.  Do you think the
  Yes, it's a bug fix.

> impact of not using redirty_page_for_writeback() is bad enough that we
> should add a cc: stable@vger.kernel.org tag?  As I recall, not doing
> this would end up leaving the page flags and radix tree to be
> inconsistent, right?
  No, it shouldn't cause any such serious harm. Just writeback may retry
writing the inode immediately (it backs off if it sees skipped pages) which
could result in needless spinning. Also some mm/bdi statistics will get
slightly off. But all in all I don't think it's a stable material.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
