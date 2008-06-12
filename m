From: Neil Brown <neilb@suse.de>
Subject: Re: Two questions on VFS/mm
Date: Thu, 12 Jun 2008 17:06:26 +1000
Message-ID: <18512.51954.831279.617586@notabene.brown>
References: <20080604163412.GL16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:43083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbYFLHHB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 03:07:01 -0400
In-Reply-To: message from Jan Kara on Wednesday June 4
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday June 4, jack@suse.cz wrote:
>   Hi,
> 
>   could some kind soul knowledgable in VFS/mm help me with the following
> two questions? I've spotted them when testing some ext4 for patches...
>   1) In write_cache_pages() we do:
> ...
> 	lock_page(page);
> 	...
> 	if (!wbc->range_cyclic && page->index > end) {
>                    done = 1;
>                    unlock_page(page);
>                    continue;
>         }
> 	...
> 	ret = (*writepage)(page, wbc, data);
> 
>   Now the problem is that if range_cyclic is set, it can happen that the
> page we give to the filesystem is beyond the current end of file (and can
> be already processed by invalidatepage()). Is the filesystem supposed to
> handle this (what would it be good for to give such a page to the fs?) or
> is it just a bug in write_cache_pages()?

Maybe there is an invariant that an address_space never has a dirty
page beyond the end-of-file??
Certainly 'truncate' invalidates and un-dirties such pages.

With typical writes, ->write_begin will extend EOF to include the
page, and ->write_end will mark it dirty (I think).

mmap writes are probably a bit different, but I suspect the same
principle applies.

If the page is not dirty, then 
			if (PageWriteback(page) ||
			    !clear_page_dirty_for_io(page)) {
				unlock_page(page);
				continue;
			}

will fire, and you never get to
			ret = (*writepage)(page, wbc, data);


> 
>   2) I have the following problem with page_mkwrite() when blocksize <
> pagesize. What we want to do is to fill in a potential hole under a page
> somebody wants to write to. But consider following scenario with a
> filesystem with 1k blocksize:
>   truncate("file", 1024);
>   ptr = mmap("file");
>   *ptr = 'a'
>      -> page_mkwrite() is called.
>         but "file" is only 1k large and we cannot really allocate blocks
>         beyond end of file. So we allocate just one 1k block.
>   truncate("file", 4096);
>   *(ptr + 2048) = 'a'
>      - nothing is called and later during writepage() time we are surprised
>        we have a dirty page which is not backed by a filesystem block.
> 
>   How to solve this? One idea I have here is that when we handle truncate(),
> we mark the original last page (if it is partial) as read-only again so
> that page_mkwrite() is called on the next write to it. Is something like
> this possible? Pointers to code doing something similar are welcome, I don't
> really know these things ;).

My understanding is that memory mapping is always done in multiples of
the page size.
When you dirty any part of a page, you effectively dirty the whole
page, so you need to extend the file to cover the whole page.
i.e. the page_mkwrite() call must extend the file to a size of 4096.

NeilBrown
