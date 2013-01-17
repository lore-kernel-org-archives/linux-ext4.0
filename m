From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: Always use ext4_bio_write_page() for writeout
Date: Thu, 17 Jan 2013 13:31:37 -0500
Message-ID: <20130117183137.GC29972@thunk.org>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44033 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3AQSbk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2013 13:31:40 -0500
Content-Disposition: inline
In-Reply-To: <1357148744-4895-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2013 at 06:45:40PM +0100, Jan Kara wrote:
> Currently we sometimes used block_write_full_page() and sometimes
> ext4_bio_write_page() for writeback (depending on mount options and call
> path). Let's always use ext4_bio_write_page() to simplify things a bit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I left in block_write_full_page() deliberately because it was
page_io.c was very tricky to get right.  When you make changes, if you
aren't careful, you can end up dereferencing a data structure after
it's been freed, which sometimes doesn't become visible until you do
some very serious stress testing.  (We had one case where it only
showed up if you were using xfstests in a VM with the memory cranked
down to a ridiculously low amount of memory.)  So having a way to
disable the page_io.c code path was useful in trying to debug things.

Fortunately, we haven't had a bug in that part of the ext4 code base
in quite a while, so maybe it's time for us to get rid of this
alternate code path.

> @@ -2885,11 +2849,6 @@ static void ext4_invalidatepage(struct page *page, unsigned long offset)
>  	trace_ext4_invalidatepage(page, offset);
>  
>  	/*
> -	 * free any io_end structure allocated for buffers to be discarded
> -	 */
> -	if (ext4_should_dioread_nolock(page->mapping->host))
> -		ext4_invalidatepage_free_endio(page, offset);

What does this have to with always using ext4_bio_write_page()?  It
looks like this was a change that leaked from one of your follow-on
commits?

There was other removals of other functions, such as
ext4_set_bh_endio(), which I think should be broken out into another
commit.

					- Ted
