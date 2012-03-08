From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Wed, 7 Mar 2012 19:00:14 -0800
Message-ID: <4F5820BE.2090501@panasas.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com> <4F57F523.3020703@redhat.com> <20120308000510.GJ15164@tux1.beaverton.ibm.com> <20120308021853.GK15164@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120308021853.GK15164@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/07/2012 06:18 PM, Darrick J. Wong wrote:
> On Wed, Mar 07, 2012 at 04:05:10PM -0800, Darrick J. Wong wrote:
>> On Wed, Mar 07, 2012 at 05:54:11PM -0600, Eric Sandeen wrote:
>>> On 3/7/12 5:40 PM, Theodore Ts'o wrote:
>>>> We've recently discovered a workload at Google where the page
>>>> stablization patches (specifically commit 0e499890c1f: ext4: wait for
>>>> writeback to complete while making pages writable) resulted in a
>>>> **major** performance regression.  As in, kernel threads that were
>>>> writing to log files were getting hit by up to 2 seconds stalls, which
>>>> very badly hurt a particular application.  Reverting this commit fixed
>>>> the performance regression.
>>>>
>>>> The main reason for the page stablizatoin patches was for DIF/DIX
>>>> support, right?   So I'm wondering if we should just disable the calls
>>>> to wait_on_page_writeback if CONFIG_BLKDEV_INTEGRITY is not defined.
>>>> i.e., something like this.
>>>
>>> Can you devise a non-secret testcase that demonstrates this?
>>
>> It sure would be nice if the block device could know if it requires stable
>> writeback, and the fs could figure that out.... though iirc there was more to
>> my patchset than just these two wait_on_page_writeback() calls.
> 
> Ted,
> 
> Would something along the lines of the following patch address your concern in
> a somewhat more flexible manner?
> 
> Provide a BDI flag to indicate that a device requires stable pages during
> writeback.  Use the flag to skip wait_on_page_writeback() if we don't have such
> a device that needs it.
> 
> (Obviously this needs to be refactored a bit...)
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  block/blk-integrity.c       |    7 +++++++
>  fs/buffer.c                 |    2 +-
>  fs/ext4/inode.c             |    2 +-
>  include/linux/backing-dev.h |    3 +++
>  include/linux/fs.h          |    1 +
>  include/linux/mm.h          |   13 +------------
>  include/linux/pagemap.h     |   14 ++++++++++++++
>  mm/filemap.c                |    2 +-
>  mm/memory.c                 |   14 ++++++++++++++
>  mm/page-writeback.c         |   10 ++++++++++
>  10 files changed, 53 insertions(+), 15 deletions(-)
> 
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index da2a818..f2d51f9 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -420,6 +420,10 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
>  	} else
>  		bi->name = bi_unsupported_name;
>  
> +#ifdef CONFIG_BLK_DEV_INTEGRITY

Ooof I feel like a mute.

No also iscsi data digest needs stable pages. Please remove any reference to
CONFIG_BLK_DEV_INTEGRITY. It needs to be supported for other
transport needs. 
Just make the default off. (Which it is)

I'll check to see how to add this for iscsi, when data digest is on

Thanks
Boaz

> +	disk->queue->backing_dev_info.state |= (1 << BDI_stable_writes);
> +#endif
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(blk_integrity_register);
> @@ -438,6 +442,9 @@ void blk_integrity_unregister(struct gendisk *disk)
>  	if (!disk || !disk->integrity)
>  		return;
>  
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +	disk->queue->backing_dev_info.state &= ~(1 << BDI_stable_writes);
> +#endif
>  	bi = disk->integrity;
>  
>  	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 1a30db7..d994d3d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2333,7 +2333,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		ret = -EAGAIN;
>  		goto out_unlock;
>  	}
> -	wait_on_page_writeback(page);
> +	wait_on_stable_page_writeback(page);
>  	return 0;
>  out_unlock:
>  	unlock_page(page);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e94ac91..79e6c90 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4724,7 +4724,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
>  			/* Wait so that we don't change page under IO */
> -			wait_on_page_writeback(page);
> +			wait_on_stable_page_writeback(page);
>  			ret = VM_FAULT_LOCKED;
>  			goto out;
>  		}
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index b1038bd..a28fecb 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -32,6 +32,9 @@ enum bdi_state {
>  	BDI_sync_congested,	/* The sync queue is getting full */
>  	BDI_registered,		/* bdi_register() was done */
>  	BDI_writeback_running,	/* Writeback is in progress */
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +	BDI_stable_writes,	/* Pages must not change during write */
> +#endif
>  	BDI_unused,		/* Available bits start here */
>  };
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 69cd5bb..d1eb3ce 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -709,6 +709,7 @@ struct block_device {
>  #define PAGECACHE_TAG_TOWRITE	2
>  
>  int mapping_tagged(struct address_space *mapping, int tag);
> +int mapping_needs_stable_writes(struct address_space *as);
>  
>  /*
>   * Might pages of this file be mapped into userspace?
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 17b27cd..a069bcf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -783,18 +783,7 @@ void page_address_init(void);
>  #define PAGE_MAPPING_KSM	2
>  #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
>  
> -extern struct address_space swapper_space;
> -static inline struct address_space *page_mapping(struct page *page)
> -{
> -	struct address_space *mapping = page->mapping;
> -
> -	VM_BUG_ON(PageSlab(page));
> -	if (unlikely(PageSwapCache(page)))
> -		mapping = &swapper_space;
> -	else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
> -		mapping = NULL;
> -	return mapping;
> -}
> +struct address_space *page_mapping(struct page *page);
>  
>  /* Neutral page->mapping pointer to address_space or anon_vma or other */
>  static inline void *page_rmapping(struct page *page)
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index cfaaa69..0f82b91 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -392,6 +392,20 @@ static inline void wait_on_page_writeback(struct page *page)
>  		wait_on_page_bit(page, PG_writeback);
>  }
>  
> +static inline void wait_on_stable_page_writeback(struct page *page)
> +{
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +	struct address_space *as;
> +
> +	as = page_mapping(page);
> +	if (!as)
> +		return;
> +
> +	if (mapping_needs_stable_writes(as))
> +		wait_on_page_writeback(page);
> +#endif
> +}
> +
>  extern void end_page_writeback(struct page *page);
>  
>  /*
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b662757..08ffa94 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2361,7 +2361,7 @@ repeat:
>  		return NULL;
>  	}
>  found:
> -	wait_on_page_writeback(page);
> +	wait_on_stable_page_writeback(page);
>  	return page;
>  }
>  EXPORT_SYMBOL(grab_cache_page_write_begin);
> diff --git a/mm/memory.c b/mm/memory.c
> index fa2f04e..40288e5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -67,6 +67,20 @@
>  
>  #include "internal.h"
>  
> +extern struct address_space swapper_space;
> +struct address_space *page_mapping(struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +
> +	VM_BUG_ON(PageSlab(page));
> +	if (unlikely(PageSwapCache(page)))
> +		mapping = &swapper_space;
> +	else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
> +		mapping = NULL;
> +	return mapping;
> +}
> +EXPORT_SYMBOL(page_mapping);
> +
>  #ifndef CONFIG_NEED_MULTIPLE_NODES
>  /* use the per-pgdat data instead for discontigmem - mbligh */
>  unsigned long max_mapnr;
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 363ba70..dc86f8f 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2239,3 +2239,13 @@ int mapping_tagged(struct address_space *mapping, int tag)
>  	return radix_tree_tagged(&mapping->page_tree, tag);
>  }
>  EXPORT_SYMBOL(mapping_tagged);
> +
> +int mapping_needs_stable_writes(struct address_space *as)
> +{
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +	if (as->backing_dev_info->state & (1 << BDI_stable_writes))
> +		return 1;
> +#endif
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(mapping_needs_stable_writes);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

