From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 4/5] dax: remove DAX code from page_cache_tree_insert()
Date: Mon, 24 Jul 2017 13:47:38 +0200
Message-ID: <20170724114738.GL652@quack2.suse.cz>
References: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
 <20170721223956.29485-5-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christoph Hellwig <hch@lst.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>, David Airlie <airlied@linux.ie>,
	Ingo Molnar <mingo@redhat.com>, Inki Dae <inki.dae@samsung.com>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Kukjin Kim <kgene@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Matthew Wilcox <mawilcox@microsoft.com>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Rob Clark <robdclark@gmail.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tomi Valkeinen <tomi.
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170721223956.29485-5-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 21-07-17 16:39:54, Ross Zwisler wrote:
> Now that we no longer insert struct page pointers in DAX radix trees we can
> remove the special casing for DAX in page_cache_tree_insert().  This also
> allows us to make dax_wake_mapping_entry_waiter() local to fs/dax.c,
> removing it from dax.h.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Jan Kara <jack@suse.cz>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/dax.c            |  2 +-
>  include/linux/dax.h |  2 --
>  mm/filemap.c        | 13 ++-----------
>  3 files changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index fb0e4c1..0e27d90 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -127,7 +127,7 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait, unsigned int mo
>   * correct waitqueue where tasks might be waiting for that old 'entry' and
>   * wake them.
>   */
> -void dax_wake_mapping_entry_waiter(struct address_space *mapping,
> +static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
>  		pgoff_t index, void *entry, bool wake_all)
>  {
>  	struct exceptional_entry_key key;
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 29cced8..afa99bb 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -122,8 +122,6 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
>  int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
>  int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  				      pgoff_t index);
> -void dax_wake_mapping_entry_waiter(struct address_space *mapping,
> -		pgoff_t index, void *entry, bool wake_all);
>  
>  #ifdef CONFIG_FS_DAX
>  int __dax_zero_page_range(struct block_device *bdev,
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a497024..1bf1265 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -130,17 +130,8 @@ static int page_cache_tree_insert(struct address_space *mapping,
>  			return -EEXIST;
>  
>  		mapping->nrexceptional--;
> -		if (!dax_mapping(mapping)) {
> -			if (shadowp)
> -				*shadowp = p;
> -		} else {
> -			/* DAX can replace empty locked entry with a hole */
> -			WARN_ON_ONCE(p !=
> -				dax_radix_locked_entry(0, RADIX_DAX_EMPTY));
> -			/* Wakeup waiters for exceptional entry lock */
> -			dax_wake_mapping_entry_waiter(mapping, page->index, p,
> -						      true);
> -		}
> +		if (shadowp)
> +			*shadowp = p;
>  	}
>  	__radix_tree_replace(&mapping->page_tree, node, slot, page,
>  			     workingset_update_node, mapping);
> -- 
> 2.9.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
