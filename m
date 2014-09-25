From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] vfs: Fix data corruption when blocksize < pagesize
 for mmaped data
Date: Thu, 25 Sep 2014 11:32:16 +1000
Message-ID: <20140925013216.GD4945@dastard>
References: <1411484603-17756-1-git-send-email-jack@suse.cz>
 <1411484603-17756-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1411484603-17756-2-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 23, 2014 at 05:03:22PM +0200, Jan Kara wrote:
> ->page_mkwrite() is used by filesystems to allocate blocks under a page
> which is becoming writeably mmapped in some process' address space. This
> allows a filesystem to return a page fault if there is not enough space
> available, user exceeds quota or similar problem happens, rather than
> silently discarding data later when writepage is called.
> 
> However VFS fails to call ->page_mkwrite() in all the cases where
> filesystems need it when blocksize < pagesize. For example when
> blocksize = 1024, pagesize = 4096 the following is problematic:
>   ftruncate(fd, 0);
>   pwrite(fd, buf, 1024, 0);
>   map = mmap(NULL, 1024, PROT_WRITE, MAP_SHARED, fd, 0);
>   map[0] = 'a';       ----> page_mkwrite() for index 0 is called
>   ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
>   mremap(map, 1024, 10000, 0);
>   map[4095] = 'a';    ----> no page_mkwrite() called
> 
> At the moment ->page_mkwrite() is called, filesystem can allocate only
> one block for the page because i_size == 1024. Otherwise it would create
> blocks beyond i_size which is generally undesirable. But later at
> ->writepage() time, we also need to store data at offset 4095 but we
> don't have block allocated for it.
...
>  
> +#ifdef CONFIG_MMU
> +/**
> + * block_create_hole - handle creation of a hole in a file
> + * @inode:	inode where the hole is created
> + * @from:	offset in bytes where the hole starts
> + * @to:		offset in bytes where the hole ends.

This function doesn't create holes.  It also manipulates page state,
not block state.  Probably could do with a better name, but I'm not
sure what a better name is - something like
pagecache_extend_isize(old_eof, new_eof)?


> +void block_create_hole(struct inode *inode, loff_t from, loff_t to)
> +{
> +	int bsize = 1 << inode->i_blkbits;
> +	loff_t rounded_from;
> +	struct page *page;
> +	pgoff_t index;
> +
> +	WARN_ON(!mutex_is_locked(&inode->i_mutex));
> +	WARN_ON(to > inode->i_size);

We've already changed i_size, so shouldn't that be:

	WARN_ON(to != inode->i_size);

> +
> +	if (from >= to || bsize == PAGE_CACHE_SIZE)
> +		return;
> +	/* Currently last page will not have any hole block created? */
> +	rounded_from = ALIGN(from, bsize);

That rounds down? or up? round_down/round_up are much better than
ALIGN() because they tell you exactly what rounding was intended...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
