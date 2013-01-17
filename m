From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] ext4: Always use ext4_bio_write_page() for writeout
Date: Thu, 17 Jan 2013 22:30:12 +0100
Message-ID: <20130117213012.GE23984@quack.suse.cz>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-2-git-send-email-jack@suse.cz>
 <20130117183137.GC29972@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab3AQVaO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2013 16:30:14 -0500
Content-Disposition: inline
In-Reply-To: <20130117183137.GC29972@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 17-01-13 13:31:37, Ted Tso wrote:
> On Wed, Jan 02, 2013 at 06:45:40PM +0100, Jan Kara wrote:
> > Currently we sometimes used block_write_full_page() and sometimes
> > ext4_bio_write_page() for writeback (depending on mount options and call
> > path). Let's always use ext4_bio_write_page() to simplify things a bit.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I left in block_write_full_page() deliberately because it was
> page_io.c was very tricky to get right.  When you make changes, if you
> aren't careful, you can end up dereferencing a data structure after
> it's been freed, which sometimes doesn't become visible until you do
> some very serious stress testing.  (We had one case where it only
> showed up if you were using xfstests in a VM with the memory cranked
> down to a ridiculously low amount of memory.)  So having a way to
> disable the page_io.c code path was useful in trying to debug things.
  Yes, I understand this. Just I thought the time has come we may get rid
of the old code.

> Fortunately, we haven't had a bug in that part of the ext4 code base
> in quite a while, so maybe it's time for us to get rid of this
> alternate code path.
> 
> > @@ -2885,11 +2849,6 @@ static void ext4_invalidatepage(struct page *page, unsigned long offset)
> >  	trace_ext4_invalidatepage(page, offset);
> >  
> >  	/*
> > -	 * free any io_end structure allocated for buffers to be discarded
> > -	 */
> > -	if (ext4_should_dioread_nolock(page->mapping->host))
> > -		ext4_invalidatepage_free_endio(page, offset);
> 
> What does this have to with always using ext4_bio_write_page()?  It
> looks like this was a change that leaked from one of your follow-on
> commits?
> 
> There was other removals of other functions, such as
> ext4_set_bh_endio(), which I think should be broken out into another
> commit.
  Once we stop using block_write_full_page(), all the removed functions
(including the change to ext4_invalidatepage() - that is there only for
nomblk_io_submit,dioread_nolock case) become unused so I removed them.

If you think removing of unused functions should be in a separate patch I
can do that but frankly I don't see a point. So do you mean it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
