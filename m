From: Neil Brown <neilb@suse.de>
Subject: Re: Two questions on VFS/mm
Date: Fri, 13 Jun 2008 16:44:47 +1000
Message-ID: <18514.5983.603918.591472@notabene.brown>
References: <20080604163412.GL16572@duck.suse.cz>
	<18512.51954.831279.617586@notabene.brown>
	<20080612081847.GA12367@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37990 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbYFMGp1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2008 02:45:27 -0400
In-Reply-To: message from Jan Kara on Thursday June 12
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday June 12, jack@suse.cz wrote:
> On Thu 12-06-08 17:06:26, Neil Brown wrote:
> > On Wednesday June 4, jack@suse.cz wrote:
> > >   Hi,
> > > 
> > >   could some kind soul knowledgable in VFS/mm help me with the following
> > > two questions? I've spotted them when testing some ext4 for patches...
> > >   1) In write_cache_pages() we do:
> > > ...
> > > 	lock_page(page);
> > > 	...
> > > 	if (!wbc->range_cyclic && page->index > end) {
> > >                    done = 1;
> > >                    unlock_page(page);
> > >                    continue;
> > >         }
> > > 	...
> > > 	ret = (*writepage)(page, wbc, data);
> > > 
> > >   Now the problem is that if range_cyclic is set, it can happen that the
> > > page we give to the filesystem is beyond the current end of file (and can
> > > be already processed by invalidatepage()). Is the filesystem supposed to
> > > handle this (what would it be good for to give such a page to the fs?) or
> > > is it just a bug in write_cache_pages()?
> > 
> > Maybe there is an invariant that an address_space never has a dirty
> > page beyond the end-of-file??
> > Certainly 'truncate' invalidates and un-dirties such pages.
> > 
> > With typical writes, ->write_begin will extend EOF to include the
> > page, and ->write_end will mark it dirty (I think).
> > 
> > mmap writes are probably a bit different, but I suspect the same
> > principle applies.
> > 
> > If the page is not dirty, then 
> > 			if (PageWriteback(page) ||
> > 			    !clear_page_dirty_for_io(page)) {
> > 				unlock_page(page);
> > 				continue;
> > 			}
> > 
> > will fire, and you never get to
> > 			ret = (*writepage)(page, wbc, data);
>   As Miklos pointed out, there's at least call do_invalidatepage() from
> block_write_full_page() which does invalidate the page but does not clear
> dirty bits or remove page from page cache. Otherwise I'd agree with
> you...

block_write_full_page will have been called after a
clear_page_dirty_for_io() call, so it should not be dirty.

I guess it could have been dirtied again as you don't need the page
lock to dirty a page... though if it is beyond EOF, maybe you do...

Hmm, I have a very strong feeling that "this cannot happen", and that
it should certainly be "this shouldn't happen", but I guess I'm not
100% convincing at the moment :-)


> 
> > >   2) I have the following problem with page_mkwrite() when blocksize <
> > > pagesize. What we want to do is to fill in a potential hole under a page
> > > somebody wants to write to. But consider following scenario with a
> > > filesystem with 1k blocksize:
> > >   truncate("file", 1024);
> > >   ptr = mmap("file");
> > >   *ptr = 'a'
> > >      -> page_mkwrite() is called.
> > >         but "file" is only 1k large and we cannot really allocate blocks
> > >         beyond end of file. So we allocate just one 1k block.
> > >   truncate("file", 4096);
> > >   *(ptr + 2048) = 'a'
> > >      - nothing is called and later during writepage() time we are surprised
> > >        we have a dirty page which is not backed by a filesystem block.
> > > 
> > >   How to solve this? One idea I have here is that when we handle truncate(),
> > > we mark the original last page (if it is partial) as read-only again so
> > > that page_mkwrite() is called on the next write to it. Is something like
> > > this possible? Pointers to code doing something similar are welcome, I don't
> > > really know these things ;).
> > 
> > My understanding is that memory mapping is always done in multiples of
> > the page size.  When you dirty any part of a page, you effectively dirty
> > the whole page, so you need to extend the file to cover the whole page.
> > i.e. the page_mkwrite() call must extend the file to a size of 4096.
>   Well, you definitely cannot increase file size because someone wrote to
> the last page of file whose size is not multiple of page size. So when your
> block size is smaller than page size, you have to handle it somehow... You
> could instantiate blocks beyond end of file but that gets a bit tricky
> (e.g. in ext3, we don't allow such blocks to exist so far).

I get the problem now.. I read the 'mmap' man page:

       A file is mapped in multiples of the page size.  For a file that is not
       a multiple of the page  size,  the  remaining  memory  is  zeroed  when
       mapped, and writes to that region are not written out to the file.  The
       effect of changing the size of the underlying file of a mapping on  the
       pages  that  correspond  to  added  or  removed  regions of the file is
       unspecified.

As the situation you are describing is documented as having
"unspecified" behaviour, I guess you can do whatever you want.
So just not writing out to any block that isn't backed by a filesystem
block would be defensible.  But maybe not desirable.

I like your idea of playing with the mapping.
I don't think you want to bother mapping it as "read-only" - just
unmap it altogether.  When it is next mapped writable to service a
write you will get a page_mkwrite call and you can fix things up.

To unmap the page, just call
  unmap_mapping_range(mapping, page_index << PAGE_CACHE_SHIFT,
		      PAGE_CACHE_SIZE, 0);
(I got that from truncate_inode_pages_range in mm/truncate.c).
You can do this while you have the page locked, and it won't be
mapped again until you unlock it.

NeilBrown
