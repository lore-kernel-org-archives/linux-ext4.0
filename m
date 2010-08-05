From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Fix dirtying of journalled buffers in
 data=journal mode
Date: Thu, 5 Aug 2010 21:31:35 +0200
Message-ID: <20100805193135.GI3535@quack.suse.cz>
References: <1281026536-10413-1-git-send-email-jack@suse.cz>
 <1281026536-10413-3-git-send-email-jack@suse.cz>
 <20100805120941.d915ea09.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab0HETcI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 15:32:08 -0400
Content-Disposition: inline
In-Reply-To: <20100805120941.d915ea09.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-08-10 12:09:41, Andrew Morton wrote:
> On Thu,  5 Aug 2010 18:42:16 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > In data=journal mode, we still use block_write_begin() to prepare page for
> > writing. This function can occasionally mark buffer dirty which violates
> > journalling assumptions - when a buffer is part of a transaction, it should be
> > dirty and a buffer can be already part of a forget list of some transaction
> > when block_write_begin() gets called. This violation of journalling assumptions
> > then results in "JBD: Spotted dirty metadata buffer..." warnings.
> > 
> > In fact, temporary dirtying the buffer while the page is still locked does not
> > really cause problems to the journalling because we won't write the buffer
> > until the page gets unlocked. So we just have to make sure to clear dirty bits
> > before unlocking the page.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext3/inode.c |   18 +++++++++++++++++-
> >  1 files changed, 17 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index 735f019..1a84abb 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -1149,9 +1149,25 @@ static int walk_page_buffers(	handle_t *handle,
> >  static int do_journal_get_write_access(handle_t *handle,
> >  					struct buffer_head *bh)
> >  {
> > +	int dirty = buffer_dirty(bh);
> > +	int ret;
> > +
> >  	if (!buffer_mapped(bh) || buffer_freed(bh))
> >  		return 0;
> > -	return ext3_journal_get_write_access(handle, bh);
> > +	/*
> > +	 * __block_prepare_write() could have dirtied some buffers. Clean
> > +	 * the dirty bit as jbd2_journal_get_write_access() could complain
> > +	 * otherwise about fs integrity issues. Setting of the dirty bit
> > +	 * by __block_prepare_write() isn't a real problem here as we clear
> > +	 * the bit before releasing a page lock and thus writeback cannot
> > +	 * ever write the buffer.
> > +	 */
> > +	if (dirty)
> > +		clear_buffer_dirty(bh);
> 
> mark_buffer_dirty() can run set_page_dirty() which will set the page
> dirty and increment dirty-page accounting.  If we then run
> clear_buffer_dirty() we can end up with a dirty page which has clean
> buffers and an off-by-one in dirty-page accounting.
> 
> Later, writeback will come along and will attempt to write the "dirty"
> page.  It will discover the cleanness of the buffers, will mark the
> page clean without doing any IO and will decrement the dirty-page
> accounting.  So everything gets fixed up again.
> 
> So I don't see any problem here and this isn't the only place where
> this sort of thing occurs.  It's just somethnig to be aware of and to
> have a think about.
  Yes, JBD tends to do this a lot (with all the journaled buffers).
Thanks for review!

								Honza
 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
