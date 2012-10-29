From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/2] mm: Gate stable page writes on the bdi flag
Date: Mon, 29 Oct 2012 19:28:57 +0100
Message-ID: <20121029182857.GI18767@quack.suse.cz>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121027013608.GB19591@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab2J2S27 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 14:28:59 -0400
Content-Disposition: inline
In-Reply-To: <20121027013608.GB19591@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 26-10-12 18:36:08, Darrick J. Wong wrote:
> Create a helper function to decide if a particular address space is backed by a
> device that requires stable page writes.  For each wait_on_page_writeback call
> that was inserted in the original stable page write patchset, change it to wait
> only if the helper says it's necessary.  This should eliminate unnecessary
> waiting for devices that don't require page contents to be immutable during
> writeout.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> 
>  fs/buffer.c         |    3 ++-
>  fs/ext4/inode.c     |    4 ++--
>  include/linux/fs.h  |    2 ++
>  mm/filemap.c        |    3 ++-
>  mm/page-writeback.c |    7 +++++++
>  5 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b5f0442..f508ece 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2334,7 +2334,8 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	if (unlikely(ret < 0))
>  		goto out_unlock;
>  	set_page_dirty(page);
> -	wait_on_page_writeback(page);
> +	if (page->mapping && mapping_needs_stable_writes(page->mapping))
> +		wait_on_page_writeback(page);
  The page is locked and we checked whether it belongs to the right mapping
just after we locked it down. So you can safely skip the page->mapping
test.

>  	return 0;
>  out_unlock:
>  	unlock_page(page);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b3c243b..82908b8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4813,8 +4813,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (page_has_buffers(page)) {
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
> -			/* Wait so that we don't change page under IO */
> -			wait_on_page_writeback(page);
> +			if (mapping_needs_stable_writes(mapping))
> +				wait_on_page_writeback(page);
>  			ret = VM_FAULT_LOCKED;
>  			goto out;
>  		}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b33cfc9..d99db0e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -466,6 +466,8 @@ struct block_device {
>  	struct percpu_rw_semaphore	bd_block_size_semaphore;
>  };
>  
> +int mapping_needs_stable_writes(struct address_space *mapping);
> +
>  /*
>   * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
>   * radix trees
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 83efee7..aedc6bd 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2274,7 +2274,8 @@ repeat:
>  		return NULL;
>  	}
>  found:
> -	wait_on_page_writeback(page);
> +	if (mapping_needs_stable_writes(mapping))
> +		wait_on_page_writeback(page);
>  	return page;
>  }
>  EXPORT_SYMBOL(grab_cache_page_write_begin);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 830893b..d0f042c 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2275,3 +2275,10 @@ int mapping_tagged(struct address_space *mapping, int tag)
>  	return radix_tree_tagged(&mapping->page_tree, tag);
>  }
>  EXPORT_SYMBOL(mapping_tagged);
> +
> +int mapping_needs_stable_writes(struct address_space *mapping)
> +{
> +	return mapping->backing_dev_info &&
> +	       bdi_cap_stable_writes(mapping->backing_dev_info);
> +}
> +EXPORT_SYMBOL_GPL(mapping_needs_stable_writes);
  Traditional name for these shortcuts is "mapping_cap_..." and put them in
linux/backing-dev.h.  And you don't have to check
mapping->backing_dev_info.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
