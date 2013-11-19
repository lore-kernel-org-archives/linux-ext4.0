From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 19:45:47 +0800
Message-ID: <20131119114547.GB4782@gmail.com>
References: <20131119095302.GA4534@gmail.com>
 <87li0koe4m.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60380 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KSLnH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2013 06:43:07 -0500
Content-Disposition: inline
In-Reply-To: <87li0koe4m.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 19, 2013 at 02:54:49PM +0400, Dmitry Monakhov wrote:
> On Tue, 19 Nov 2013 17:53:03 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
[...]
> > As we expected, we should read nothing or data with 'a'.  But now we
> > read data with '0'.  I take a closer look at the code and it seems that
> > there is a bug in vfs.  Let me describe my found here.
> > 
> >   reader					writer
> >                                                 generic_file_aio_write()
> >                                                 ->__generic_file_aio_write()
> >                                                   ->generic_file_direct_write()
> >   generic_file_aio_read()
> >   ->do_generic_file_read()
> >     [fallback to buffered read]
> > 
> >     ->find_get_page()
> >     ->page_cache_sync_readahead()
> >     ->find_get_page()
> >     [in find_page label, we couldn't find a
> >      page before and after calling
> >      page_cache_sync_readahead().  So go to
> >      no_cached_page label]
> > 
> >     ->page_cache_alloc_cold()
> >     ->add_to_page_cache_lru()
> >     [in no_cached_page label, we alloc a page
> >      and goto readpage label.]
> > 
> >     ->aops->readpage()
> >     [in readpage label, readpage() callback
> >      is called and mpage_readpage() return a
> >      zero-filled page (e.g. ext3/4), and go
> >      to page_ok label]
> > 
> >                                                   ->a_ops->direct_IO()
> >                                                   ->i_size_write()
> >                                                   [we enlarge the i_size]
> > 
> >     Here we check i_size
> >     [in page_ok label, we check i_size but
> >      it has been enlarged.  Thus, we pass
> >      the check and return a zero-filled page]
> > 
> > I attach a patch below to fix this problem in vfs.  However, to be honest, the
> > fix is very dirty.  But frankly I haven't had a good solution until now.  So I
> > send this mail to talk about this problem.  Please let me know if I miss
> > something.
> Looks sane because in orrder to get correct result we have to read
> variables in opposite order in comparison to update order.
> > 
> > Any comment and idea are always welcome.
> > 
> > Thanks,
> > 						- Zheng
> > 
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Subject: [PATCH] vfs: check i_size at the beginning of do_generic_file_read()
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  mm/filemap.c |   13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 1e6aec4..9de2ad8 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1107,6 +1107,8 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
> >  	pgoff_t index;
> >  	pgoff_t last_index;
> >  	pgoff_t prev_index;
> > +	pgoff_t end_index;
> > +	loff_t isize;
> >  	unsigned long offset;      /* offset into pagecache page */
> >  	unsigned int prev_offset;
> >  	int error;
> > @@ -1117,10 +1119,17 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
> >  	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
> >  	offset = *ppos & ~PAGE_CACHE_MASK;
> >  
> > +	/*
> > +	 * We must check i_size at the beginning of this function to avoid to return
> > +	 * zero-filled page to userspace when the application does append dio writes.
> > +	 */
> > +	isize = i_size_read(inode);
> > +	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
> > +	if (unlikely(!isize || index > end_index))
> > +		goto out;
> > +
> This not sufficient because protect from append case only.
> following scenario still can result in zefo-filed pages

If I understand correctly, it couldn't happen.

> Let inode has i_size=8192
> task1                               task2
> pread(, off=4096,sz=4096)           truncate(4096)
>  ->do_generic_file_read()
>      check i_size OK
>                                      ->i_size_write()
>                                      ->truncate_pagecache()
>      ->page_cache_alloc_cold                        
>        ->aops->readpage() ->ZERO
>                                     pwrite(off=4096,sz=4096)
>                                     ->generic_file_direct_write()

                                        ->invalidate_inode_pages2_range()
                                        ->direct_IO()
                                        ->invalidate_inode_pages2_range()
                                        So the page should be invalidated

                                                - Zheng

>                                     ->i_size_write()
>          check i_size OK     
> >  	for (;;) {
> >  		struct page *page;
> > -		pgoff_t end_index;
> > -		loff_t isize;
> >  		unsigned long nr, ret;
> >  
> >  		cond_resched();
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
