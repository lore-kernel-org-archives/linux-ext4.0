From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 01/15] mm: add invalidatepage_range address space
 operation
Date: Sun, 19 Aug 2012 22:24:24 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208192153020.2390@eggly.anvils>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com> <1343376074-28034-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-mmc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1343376074-28034-2-git-send-email-lczerner@redhat.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 27 Jul 2012, Lukas Czerner wrote:

> Currently there is no way to truncate partial page where the end
> truncate point is not at the end of the page. This is because it was not
> needed and the functionality was enough for file system truncate
> operation to work properly. However more file systems now support punch
> hole feature and it can benefit from mm supporting truncating page just
> up to the certain point.
> 
> Specifically, with this functionality truncate_inode_pages_range() can
> be changed so it supports truncating partial page at the end of the
> range (currently it will BUG_ON() if 'end' is not at the end of the
> page).
> 
> This commit add new address space operation invalidatepage_range which
> allows specifying length of bytes to invalidate, rather than assuming
> truncate to the end of the page. It also introduce
> block_invalidatepage_range() and do_invalidatepage)range() functions for
> exactly the same reason.
> 
> The caller does not have to implement both aops (invalidatepage and
> invalidatepage_range) and the latter is preferred. The old method will be
> used only if invalidatepage_range is not implemented by the caller.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>

Needs some rework.

> ---

Documentation/filesystems/Locking
Documentation/filesystems/netfs-api.txt
Documentation/filesystems/vfs.txt
   all have something to say about invalidatepage().  I should think
   you can leave the netfs-api.txt one alone, but the other two ought
   now to comment on invalidatepage_range() too.  Can perfectly well be
   left to a separate patch, following on a little later if you prefer.

>  fs/buffer.c                 |   23 ++++++++++++++++++++++-
>  include/linux/buffer_head.h |    2 ++
>  include/linux/fs.h          |    2 ++
>  include/linux/mm.h          |    2 ++
>  mm/truncate.c               |   30 ++++++++++++++++++++++++++----
>  5 files changed, 54 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index c7062c8..5937f30 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1457,13 +1457,27 @@ static void discard_buffer(struct buffer_head * bh)
>   */
>  void block_invalidatepage(struct page *page, unsigned long offset)
>  {
> +	block_invalidatepage_range(page, offset, PAGE_CACHE_SIZE);

Okay, fine, that fits with patch 06 where the third arg is endoffset.

> +}
> +EXPORT_SYMBOL(block_invalidatepage);
> +
> +void block_invalidatepage_range(struct page *page, unsigned long offset,
> +				unsigned long length)

Length?  No, patch 06 is passing endoffset.

> +{
>  	struct buffer_head *head, *bh, *next;
>  	unsigned int curr_off = 0;
> +	unsigned long stop = length + offset;

So here you are adding together two offsets.

>  
>  	BUG_ON(!PageLocked(page));
>  	if (!page_has_buffers(page))
>  		goto out;
>  
> +	/*
> +	 * Check for overflow
> +	 */
> +	if (stop < length)
> +		stop = PAGE_CACHE_SIZE;

And this is weird, even if length were a length: though such wraparound
is conceivable, a far more likely overflow would be stop > PAGE_CACHE_SIZE.

> +
>  	head = page_buffers(page);
>  	bh = head;
>  	do {
> @@ -1471,6 +1485,12 @@ void block_invalidatepage(struct page *page, unsigned long offset)
>  		next = bh->b_this_page;
>  
>  		/*
> +		 * Are we still fully in range ?
> +		 */
> +		if (next_off > stop)
> +			goto out;

Disillusioned, I didn't stop to think about this one.

> +
> +		/*
>  		 * is this block fully invalidated?
>  		 */
>  		if (offset <= curr_off)
> @@ -1489,7 +1509,8 @@ void block_invalidatepage(struct page *page, unsigned long offset)
>  out:
>  	return;
>  }
> -EXPORT_SYMBOL(block_invalidatepage);
> +EXPORT_SYMBOL(block_invalidatepage_range);
> +
>  
>  /*
>   * We attach and possibly dirty the buffers atomically wrt
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 458f497..9d55645 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -194,6 +194,8 @@ extern int buffer_heads_over_limit;
>   * address_spaces.
>   */
>  void block_invalidatepage(struct page *page, unsigned long offset);
> +void block_invalidatepage_range(struct page *page, unsigned long offset,
> +				unsigned long length);

See comments on fs.h.

>  int block_write_full_page(struct page *page, get_block_t *get_block,
>  				struct writeback_control *wbc);
>  int block_write_full_page_endio(struct page *page, get_block_t *get_block,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8fabb03..b9eaf0c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -620,6 +620,8 @@ struct address_space_operations {
>  	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
>  	sector_t (*bmap)(struct address_space *, sector_t);
>  	void (*invalidatepage) (struct page *, unsigned long);
> +	void (*invalidatepage_range) (struct page *, unsigned long,
> +				      unsigned long);

It may turn out to be bad advice, given how invalidatepage() already
takes an unsigned long, but I'd be tempted to make both of these args
unsigned int, since that helps to make it clearer that they're intended
to be offsets within a page, in the range 0..PAGE_CACHE_SIZE.

(partial_start, partial_end and top in truncate_inode_pages_range()
are all unsigned int.)

Andrew is very keen on naming arguments in prototypes,
and I think there is an especially strong case for it here.

>  	int (*releasepage) (struct page *, gfp_t);
>  	void (*freepage)(struct page *);
>  	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f9f279c..2db6a29 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -998,6 +998,8 @@ struct page *get_dump_page(unsigned long addr);
>  
>  extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
>  extern void do_invalidatepage(struct page *page, unsigned long offset);
> +extern void do_invalidatepage_range(struct page *page, unsigned long offset,
> +				    unsigned long length);

Likewise; ah, good, you named them... but then passed the wrong thing.

>  
>  int __set_page_dirty_nobuffers(struct page *page);
>  int __set_page_dirty_no_writeback(struct page *page);
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 75801ac..e29e5ea 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -39,14 +39,36 @@
>   */
>  void do_invalidatepage(struct page *page, unsigned long offset)
>  {
> +	do_invalidatepage_range(page, offset, PAGE_CACHE_SIZE);

Good.

> +}
> +
> +void do_invalidatepage_range(struct page *page, unsigned long offset,
> +			     unsigned long length)

Not so good.

> +{
> +	void (*invalidatepage_range)(struct page *, unsigned long,
> +				     unsigned long);
>  	void (*invalidatepage)(struct page *, unsigned long);
> +
> +	/*
> +	 * Try invalidatepage_range first
> +	 */
> +	invalidatepage_range = page->mapping->a_ops->invalidatepage_range;
> +	if (invalidatepage_range)
> +		(*invalidatepage_range)(page, offset, length);
> +
> +	/*
> +	 * When only invalidatepage is registered length must be
> +	 * PAGE_CACHE_SIZE
> +	 */
>  	invalidatepage = page->mapping->a_ops->invalidatepage;
> +	if (invalidatepage) {
> +		BUG_ON(length != PAGE_CACHE_SIZE);
> +		(*invalidatepage)(page, offset);

So if a filesystem were to declare both invalidatepage_range() and
invalidatepage(), it would call them both?  That seems odd, and differs
from what you said in the commit message, though probably would not matter.

> +	}
>  #ifdef CONFIG_BLOCK
> -	if (!invalidatepage)
> -		invalidatepage = block_invalidatepage;
> +	if (!invalidatepage_range && !invalidatepage)
> +		block_invalidatepage_range(page, offset, length);
>  #endif
> -	if (invalidatepage)
> -		(*invalidatepage)(page, offset);
>  }
>  
>  static inline void truncate_partial_page(struct page *page, unsigned partial)
> -- 
> 1.7.7.6

Patches 02-05 look as if they suffer from the same defect;
I didn't look at the later ones, they may well be unaffected.

I can see that your series would change less if we were declare that
01 is right and 06 is wrong; but I find consistency with zero_user_segment
too appealing, and the strange "stop" stuff here too unappealing.

Hugh
