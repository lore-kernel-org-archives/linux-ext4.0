From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix reservation release on invalidatepage for
 delalloc fs
Date: Mon, 8 Jun 2015 17:45:08 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1506081729390.1273@localhost.localdomain>
References: <1433406301-29136-1-git-send-email-lczerner@redhat.com> <20150608151651.GD19168@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbbFHPpN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 11:45:13 -0400
In-Reply-To: <20150608151651.GD19168@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 8 Jun 2015, Theodore Ts'o wrote:

> Date: Mon, 8 Jun 2015 11:16:51 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: fix reservation release on invalidatepage for
>     delalloc fs
> 
> On Thu, Jun 04, 2015 at 10:25:01AM +0200, Lukas Czerner wrote:
> > On delalloc enabled file system on invalidatepage operation
> > in ext4_da_page_release_reservation() we want to clear the delayed
> > buffer and remove the extent covering the delayed buffer from the extent
> > status tree.
> > 
> > However currently there is a bug where on the systems with page size >
> > block size we will always remove extents from the start of the page
> > regardless where the actual delayed buffers are positioned in the page.
> 
> Right, because we end up screwing up the accounting.
> 
> > @@ -1363,14 +1363,23 @@ static void ext4_da_page_release_reservation(struct page *page,
> >  
> >  		if ((offset <= curr_off) && (buffer_delay(bh))) {
> >  			to_release++;
> > +			contiguous_blks++;
> >  			clear_buffer_delay(bh);
> > +		} else if (contiguous_blks) {
> > +			lblk = page->index <<
> > +			       (PAGE_CACHE_SHIFT - inode->i_blkbits);
> > +			lblk += (curr_off >> inode->i_blkbits) -
> > +				contiguous_blks;
> > +			ext4_es_remove_extent(inode, lblk, contiguous_blks);
> > +			contiguous_blks = 0;
> >  		}
> >  		curr_off = next_off;
> >  	} while ((bh = bh->b_this_page) != head);
> 
> Shouldn't we call ext4_es_remove_extent() on the portion of the page
> containing the delayed allocation region, before we clear
> contiguous_blks and resetting lblk?

Hi Ted,

right this is the point of the patch.

> 
> For example, suppose we had the 4k page with a 1k block size, where
> the first, second, and fourth blocks are delayed allocated.  With this
> patch we will end up only clearing the extent status tree for the
> fourth block, but not the first and second.

So when the first and second block are delayed, then the

if ((offset <= curr_off) && (buffer_delay(bh)))

will hit twice which means that we'll have contiguous_blks = 2

Now on the third block this condition will no longer be true
(because buffer_delay(bh) will be false) and so we will hit

else if (contiguous_blks) {

then lblk will be: start of the page + (curr_off - contiguous_blks).
curr_off at this point will point at third block (index 2) and
contiguous_blks is 2. Which means that lblk will point at the start
of the page - which is exactly right because the first delayed block
is at the start of the page.

So ext4_es_remove_extent() will remove extent of two blocks starting
from the end of the page - which means it removes first and second
delayed block.

Now when we check fourth block the

if ((offset <= curr_off) && (buffer_delay(bh)))

will hit again, leaving contiguous_blks with 1, then we leave the
while cycle and hit this:

if (contiguous_blks)

removing the extent starting at fourth block in the page removing
one block (the fourth block in the page).

That's how I wrote the code, but maybe I am missing something ? I am
a bit tired today already so my explanation is not very good, sorry.

Can you put your question in a form of a patch ?

Thanks!
-Lukas

> 
>        	      	      	  	    - Ted
> 
