From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv3 1/3] fs/buffer.c: allocate buffer cache with user
 specific flag
Date: Thu, 28 Aug 2014 12:59:09 +0200
Message-ID: <20140828105909.GE5961@quack.suse.cz>
References: <53FE9357.6000505@lge.com>
 <53FE9492.1030909@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53FE9492.1030909@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 28-08-14 11:31:46, Gioh Kim wrote:
> 
> A buffer cache is allocated from movable area
> because it is referred for a while and released soon.
> But some filesystems are taking buffer cache for a long time
> and it can disturb page migration.
> 
> New APIs are introduced to allocate buffer cache
> with user specific flag.
> *_gfp APIs are for user want to set page allocation flag for page cache
> allocation.
> And *_unmovable APIs are for the user wants to allocate page cache from
> non-movable area.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
  Still a few nits below.
> ---
>  fs/buffer.c                 |   54 +++++++++++++++++++++++++++++++++----------
>  include/linux/buffer_head.h |   14 ++++++++++-
>  2 files changed, 55 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 8f05111..ee29bc4 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>   */
>  static int
>  grow_dev_page(struct block_device *bdev, sector_t block,
> -               pgoff_t index, int size, int sizebits)
> +             pgoff_t index, int size, int sizebits, gfp_t gfp)
  I've noticed that whitespace got damaged in your patches (tabs replaced
with spaces). Please use email client that doesn't do this or use
attachments. Otherwise patch doesn't apply.

>  {
>         struct inode *inode = bdev->bd_inode;
>         struct page *page;
> @@ -1002,10 +1002,10 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>         int ret = 0;            /* Will call free_more_memory() */
>         gfp_t gfp_mask;
> 
> -       gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
> -       gfp_mask |= __GFP_MOVABLE;
> +       gfp_mask = (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS) | gfp;
> +
>         /*
> -        * XXX: __getblk_slow() can not really deal with failure and
> +        * XXX: __getblk_gfp() can not really deal with failure and
>          * will endlessly loop on improvised global reclaim.  Prefer
>          * looping in the allocator rather than here, at least that
>          * code knows what it's doing.
> @@ -1058,7 +1058,7 @@ failed:
>   * that page was dirty, the buffers are set dirty also.
>   */
>  static int
> -grow_buffers(struct block_device *bdev, sector_t block, int size)
> +grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_t gfp)
>  {
>         pgoff_t index;
>         int sizebits;
> @@ -1085,11 +1085,12 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>         }
> 
>         /* Create a page with the proper size buffers.. */
> -       return grow_dev_page(bdev, block, index, size, sizebits);
> +       return grow_dev_page(bdev, block, index, size, sizebits, gfp);
>  }
> 
> -static struct buffer_head *
> -__getblk_slow(struct block_device *bdev, sector_t block, int size)
> +struct buffer_head *
> +__getblk_gfp(struct block_device *bdev, sector_t block,
> +            unsigned size, gfp_t gfp)
>  {
>         /* Size must be multiple of hard sectorsize */
>         if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
> @@ -1111,13 +1112,21 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
>                 if (bh)
>                         return bh;
> 
> -               ret = grow_buffers(bdev, block, size);
> +               ret = grow_buffers(bdev, block, size, gfp);
>                 if (ret < 0)
>                         return NULL;
>                 if (ret == 0)
>                         free_more_memory();
>         }
>  }
> +EXPORT_SYMBOL(__getblk_gfp);
> +
> +struct buffer_head *getblk_unmovable(struct block_device *bdev, sector_t block,
> +                                    unsigned size)
> +{
> +       return __getblk_gfp(bdev, block, size, 0);
> +}
> +EXPORT_SYMBOL(getblk_unmovable);
  This can be just an inline function in include/linux/buffer_head.h.

>  /*
>   * The relationship between dirty buffers and dirty pages:
> @@ -1385,7 +1394,7 @@ __getblk(struct block_device *bdev, sector_t block, unsigned size)
> 
>         might_sleep();
>         if (bh == NULL)
> -               bh = __getblk_slow(bdev, block, size);
> +               bh = __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>         return bh;
>  }
>  EXPORT_SYMBOL(__getblk);
  I'd keep __getblk_slow() internal and just add 'gfp' parameter to it.
Then change __getblk() to __getblk_gfp() and pass on the 'gfp' parameter.
And finally define inline __getblk() in include/linux/buffer_head.h which
just calls __getblk_gfp() with appropriate gfp mask.

That way you keep all the interfaces completely symmetric. For example now
you miss might_sleep() checks from __getblk_gfp().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
