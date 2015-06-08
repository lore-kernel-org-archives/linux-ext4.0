From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix reservation release on invalidatepage for
 delalloc fs
Date: Mon, 8 Jun 2015 11:16:51 -0400
Message-ID: <20150608151651.GD19168@thunk.org>
References: <1433406301-29136-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53049 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbbFHPQy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 11:16:54 -0400
Content-Disposition: inline
In-Reply-To: <1433406301-29136-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2015 at 10:25:01AM +0200, Lukas Czerner wrote:
> On delalloc enabled file system on invalidatepage operation
> in ext4_da_page_release_reservation() we want to clear the delayed
> buffer and remove the extent covering the delayed buffer from the extent
> status tree.
> 
> However currently there is a bug where on the systems with page size >
> block size we will always remove extents from the start of the page
> regardless where the actual delayed buffers are positioned in the page.

Right, because we end up screwing up the accounting.

> @@ -1363,14 +1363,23 @@ static void ext4_da_page_release_reservation(struct page *page,
>  
>  		if ((offset <= curr_off) && (buffer_delay(bh))) {
>  			to_release++;
> +			contiguous_blks++;
>  			clear_buffer_delay(bh);
> +		} else if (contiguous_blks) {
> +			lblk = page->index <<
> +			       (PAGE_CACHE_SHIFT - inode->i_blkbits);
> +			lblk += (curr_off >> inode->i_blkbits) -
> +				contiguous_blks;
> +			ext4_es_remove_extent(inode, lblk, contiguous_blks);
> +			contiguous_blks = 0;
>  		}
>  		curr_off = next_off;
>  	} while ((bh = bh->b_this_page) != head);

Shouldn't we call ext4_es_remove_extent() on the portion of the page
containing the delayed allocation region, before we clear
contiguous_blks and resetting lblk?

For example, suppose we had the 4k page with a 1k block size, where
the first, second, and fourth blocks are delayed allocated.  With this
patch we will end up only clearing the extent status tree for the
fourth block, but not the first and second.

       	      	      	  	    - Ted
