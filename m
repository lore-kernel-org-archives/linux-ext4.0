From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Thu, 28 Nov 2013 00:01:13 +0100
Message-ID: <20131127230113.GC27330@quack.suse.cz>
References: <20131119095302.GA4534@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab3K0XBP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Nov 2013 18:01:15 -0500
Content-Disposition: inline
In-Reply-To: <20131119095302.GA4534@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 19-11-13 17:53:03, Zheng Liu wrote:
> Currently we check i_size in buffered read path after we know the page
> is updated.  But it could return some zero-filled pages to the userspace
> when we do some append dio writes meanwhile we do some dio reads.  We
> could use the following code snippet to reproduce this problem in a
> ext2/3/4 filesystem.  In the mean time, I run this code snippet against
> xfs and btrfs, and they can survive.  Furthermore, if we do some buffered
> read, xfs also has the same problem.  So I guess that this might be a
> generic problem.
<snip code>
> As we expected, we should read nothing or data with 'a'.  But now we
> read data with '0'.  I take a closer look at the code and it seems that
> there is a bug in vfs.  Let me describe my found here.
> 
>   reader					writer
>                                                 generic_file_aio_write()
>                                                 ->__generic_file_aio_write()
>                                                   ->generic_file_direct_write()
>   generic_file_aio_read()
>   ->do_generic_file_read()
>     [fallback to buffered read]
> 
>     ->find_get_page()
>     ->page_cache_sync_readahead()
>     ->find_get_page()
>     [in find_page label, we couldn't find a
>      page before and after calling
>      page_cache_sync_readahead().  So go to
>      no_cached_page label]
> 
>     ->page_cache_alloc_cold()
>     ->add_to_page_cache_lru()
>     [in no_cached_page label, we alloc a page
>      and goto readpage label.]
> 
>     ->aops->readpage()
>     [in readpage label, readpage() callback
>      is called and mpage_readpage() return a
>      zero-filled page (e.g. ext3/4), and go
>      to page_ok label]
> 
>                                                   ->a_ops->direct_IO()
>                                                   ->i_size_write()
>                                                   [we enlarge the i_size]
> 
>     Here we check i_size
>     [in page_ok label, we check i_size but
>      it has been enlarged.  Thus, we pass
>      the check and return a zero-filled page]
  Yeah, this looks like it can cause the problem you see.

> I attach a patch below to fix this problem in vfs.  However, to be honest, the
> fix is very dirty.  But frankly I haven't had a good solution until now.  So I
> send this mail to talk about this problem.  Please let me know if I miss
> something.
> 
> Any comment and idea are always welcome.
  Well, your patch will fix only the easy scenario but there are other
scenarios which could result in a similar problem - e.g. if the writer
does:
  pwrite(fd, buf, blksize, 0);
  ftruncate(fd, 0);
  pwrite(fd, buf, blksize, 0);
the reader even with the additional check can get unlucky and read zeros
(the first i_size check happens before truncate, the second check happens
after the second pwrite).

To solve this reliably you'd need some lock serializing dio and buffered io
on the file range. The mapping range locks I'm working on will provide
this synchronization but that's not a solution I have now. So until then
some imperfect but simple solution might be OK - but instead of what you
do, I'd prefer to trim desc->count at the beginning of
do_generic_file_read() so that *ppos+desc->count <= i_size. Because your
check also has the disadvantage that it doesn't work when the read doesn't
read just the last page in the file.

								Honza

> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Subject: [PATCH] vfs: check i_size at the beginning of do_generic_file_read()
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  mm/filemap.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1e6aec4..9de2ad8 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1107,6 +1107,8 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
>  	pgoff_t index;
>  	pgoff_t last_index;
>  	pgoff_t prev_index;
> +	pgoff_t end_index;
> +	loff_t isize;
>  	unsigned long offset;      /* offset into pagecache page */
>  	unsigned int prev_offset;
>  	int error;
> @@ -1117,10 +1119,17 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
>  	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
>  	offset = *ppos & ~PAGE_CACHE_MASK;
>  
> +	/*
> +	 * We must check i_size at the beginning of this function to avoid to return
> +	 * zero-filled page to userspace when the application does append dio writes.
> +	 */
> +	isize = i_size_read(inode);
> +	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
> +	if (unlikely(!isize || index > end_index))
> +		goto out;
> +
>  	for (;;) {
>  		struct page *page;
> -		pgoff_t end_index;
> -		loff_t isize;
>  		unsigned long nr, ret;
>  
>  		cond_resched();
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
