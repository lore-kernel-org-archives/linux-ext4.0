From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio
	writereturningEIOwhentry_to_release_page fails
Date: Tue, 12 Aug 2008 09:28:26 -0400
Message-ID: <1218547706.15342.305.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
	 <1217953055.7899.11.camel@think.oraclecorp.com>
	 <1217971027.7516.20.camel@mingming-laptop>
	 <1218029114.15342.58.camel@think.oraclecorp.com>
	 <20080806135337.GA3615@duck.suse.cz>
	 <1218063477.6383.41.camel@mingming-laptop>
	 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
	 <1218104494.15342.171.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
	 <1218200055.15342.230.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zach Brown <zach.brown@oracle.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:19697 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYHLNfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Aug 2008 09:35:24 -0400
In-Reply-To: <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-08-11 at 15:25 +0900, Hisashi Hifumi wrote:
> >> >> >I am wondering why we need stronger invalidate hurantees for DIO->
> >> >> >invalidate_inode_pages_range(),which force the page being removed from
> >> >> >page cache? In case of bh is busy due to ext3 writeout,
> >> >> >journal_try_to_free_buffers() could return different error number(EBUSY)
> >> >> >to try_to_releasepage() (instead of EIO).  In that case,  could we just
> >> >> >leave the page in the cache, clean pageuptodate() (to force later buffer
> >> >> >read to read from disk) and then invalidate_complete_page2() return
> >> >> >successfully? Any issue with this way?
> >> >> 
> >> >> My idea is that journal_try_to_free_buffers returns EBUSY if it fails due to
> >> >> bh busy, and dio write falls back to buffered write. This is easy to fix.
> >> >> 
> >> >> 
> >> >
> >> >What about the invalidates done after the DIO has already run
> >> >non-buffered?
> >> 
> >> Dio write falls back to buffered IO when writing to a hole on ext3, I 
> >think. I want to 
> >> apply this mechanism to fix this issue. When try_to_release_page fails on 
> >a page 
> >> due to bh busy, dio write does buffered write, sync_page_range, and 
> >> wait_on_page_writeback, imvalidates page cache to preserve dio semantics. 
> >> Even if page invalidation that is carried out after 
> >wait_on_page_writeback fails, 
> >> there is no inconsistency between HDD and page cache.
> >> 
> >
> >Sorry, I'm sure I wasn't very clear, I was referencing this code from
> >mm/filemap.c:
> >
> >        written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
> >
> >        /*
> >         * Finally, try again to invalidate clean pages which might have been
> >         * cached by non-direct readahead, or faulted in by get_user_pages()
> >         * if the source of the write was an mmap'ed region of the file
> >         * we're writing.  Either one is a pretty crazy thing to do,
> >         * so we don't support it 100%.  If this invalidation
> >         * fails, tough, the write still worked...
> >         */
> >        if (mapping->nrpages) {
> >                invalidate_inode_pages2_range(mapping,
> >                                              pos >> PAGE_CACHE_SHIFT, end);
> >        }
> >
> >If this second invalidate fails during a DIO write, we'll have up to
> >date pages in cache that don't match the data on disk.  It is unlikely
> >to fail because the conditions that make jbd unable to free a buffer are
> >rare, but it can still happen with the write combination of mmap usage.
> >
> >The good news is the second invalidate doesn't make O_DIRECT return
> >-EIO.  But, it sounds like fixing do_launder_page to always call into
> >the FS can fix all of these problems.  Am I missing something?
> >
> 
> My approach is not implementing do_launder_page for ext3.
> It is needed to modify VFS.
> 
> My patch is as follows:

Sorry, I'm still not sure why the do_launder_page implementation is a
bad idea.  Clearly Mingming spent quite some time on it in the past, but
given that it could provide a hook for the FS to do expensive operations
to make the page really go away, why not do it?

As far as I can tell, the only current users afs, nfs and fuse.  Pushing
down the PageDirty check to those filesystems should be trivial.

With that said, I don't have strong feelings against falling back to
buffered IO when the invalidate fails.  Maybe Zach remembers something I
don't?

-chris

> 
> 
> diff -Nrup linux-2.6.27-rc2.org/mm/filemap.c linux-2.6.27-rc2/mm/filemap.c
> --- linux-2.6.27-rc2.org/mm/filemap.c	2008-08-11 14:33:23.000000000 +0900
> +++ linux-2.6.27-rc2/mm/filemap.c	2008-08-11 14:57:29.000000000 +0900
> @@ -2129,13 +2129,16 @@ generic_file_direct_write(struct kiocb *
>  	 * After a write we want buffered reads to be sure to go to disk to get
>  	 * the new data.  We invalidate clean cached page from the region we're
>  	 * about to write.  We do this *before* the write so that we can return
> -	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
> +	 * -EBUSY without clobbering -EIOCBQUEUED from ->direct_IO().
>  	 */
>  	if (mapping->nrpages) {
>  		written = invalidate_inode_pages2_range(mapping,
>  					pos >> PAGE_CACHE_SHIFT, end);
> -		if (written)
> +		if (written) {
> +			if (written == -EBUSY)
> +				written = 0;
>  			goto out;
> +		}
>  	}
>  
>  	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
> diff -Nrup linux-2.6.27-rc2.org/mm/truncate.c linux-2.6.27-rc2/mm/truncate.c
> --- linux-2.6.27-rc2.org/mm/truncate.c	2008-08-11 14:33:24.000000000 +0900
> +++ linux-2.6.27-rc2/mm/truncate.c	2008-08-11 14:52:03.000000000 +0900
> @@ -380,7 +380,7 @@ static int do_launder_page(struct addres
>   * Any pages which are found to be mapped into pagetables are unmapped prior to
>   * invalidation.
>   *
> - * Returns -EIO if any pages could not be invalidated.
> + * Returns -EBUSY if any pages could not be invalidated.
>   */
>  int invalidate_inode_pages2_range(struct address_space *mapping,
>  				  pgoff_t start, pgoff_t end)
> @@ -440,7 +440,7 @@ int invalidate_inode_pages2_range(struct
>  			ret2 = do_launder_page(mapping, page);
>  			if (ret2 == 0) {
>  				if (!invalidate_complete_page2(mapping, page))
> -					ret2 = -EIO;
> +					ret2 = -EBUSY;
>  			}
>  			if (ret2 < 0)
>  				ret = ret2;
> 
> 
> 
> 

