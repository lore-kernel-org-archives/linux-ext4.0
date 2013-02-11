From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/12] ext4: fix the number of credits needed for
 ext4_unlink() and ext4_rmdir()
Date: Mon, 11 Feb 2013 20:30:20 +0100
Message-ID: <20130211193020.GA14172@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-11-git-send-email-tytso@mit.edu>
 <20130211162830.GM5318@quack.suse.cz>
 <20130211183036.GA9617@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718Ab3BKTaW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 14:30:22 -0500
Content-Disposition: inline
In-Reply-To: <20130211183036.GA9617@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-02-13 13:30:36, Ted Tso wrote:
> On Mon, Feb 11, 2013 at 05:28:30PM +0100, Jan Kara wrote:
> > On Sat 09-02-13 16:53:50, Ted Tso wrote:
> > > The ext4_unlink() and ext4_rmdir() don't actually release the blocks
> > > associated with the file/directory.  This gets done in a separate jbd2
> > > handle called via ext4_evict_inode().  Thus, we don't need to reserve
> > > lots of journal credits for the truncate.
> > > 
> > > Note that using too many journal credits is non-optimal because it can
> > > leading to the journal transmit getting closed too early, before it is
> > > strictly necessary.
> >   Nice spotting. The patch looks good. You can add:
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> The change in how ext4_unlink() works goes back years and years, so
> this patch is applicable to ext3 as well.  I imagine a some of these
> patches, such as the one where we now can start the handle in
> ext4_new_inode(), or changing the order in which we call
> grab_cache_page() and journal_start(), will probably be too
> complicated for you to feel comfortable backporting them to ext3.
> This one is really simple though, so maybe it's worth it.
> 
> The other ones you might want to consider is the patches do the
> directory lookup before before start the journal, since they are
> pretty easy to validate by inspection.
  Yeah, I will likely take the easy ones into ext3 but I definitely don't
plan to port the change in ext4_new_inode() into ext3.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
