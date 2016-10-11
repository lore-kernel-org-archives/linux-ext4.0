From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v5 14/17] dax: move RADIX_DAX_* defines to dax.h
Date: Tue, 11 Oct 2016 09:23:27 +0200
Message-ID: <20161011072327.GF6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-15-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475874544-24842-15-git-send-email-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Fri 07-10-16 15:09:01, Ross Zwisler wrote:
> The RADIX_DAX_* defines currently mostly live in fs/dax.c, with just
> RADIX_DAX_ENTRY_LOCK being in include/linux/dax.h so it can be used in
> mm/filemap.c.  When we add PMD support, though, mm/filemap.c will also need
> access to the RADIX_DAX_PTE type so it can properly construct a 4k sized
> empty entry.
> 
> Instead of shifting the defines between dax.c and dax.h as they are
> individually used in other code, just move them wholesale to dax.h so
> they'll be available when we need them.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/dax.c            | 14 --------------
>  include/linux/dax.h | 15 ++++++++++++++-
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5e8febe..ac3cd05 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -34,20 +34,6 @@
>  #include <linux/iomap.h>
>  #include "internal.h"
>  
> -/*
> - * We use lowest available bit in exceptional entry for locking, other two
> - * bits to determine entry type. In total 3 special bits.
> - */
> -#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 3)
> -#define RADIX_DAX_PTE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
> -#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
> -#define RADIX_DAX_TYPE_MASK (RADIX_DAX_PTE | RADIX_DAX_PMD)
> -#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_TYPE_MASK)
> -#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
> -#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
> -		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE) | \
> -		RADIX_TREE_EXCEPTIONAL_ENTRY))
> -
>  /* We choose 4096 entries - same as per-zone page wait tables */
>  #define DAX_WAIT_TABLE_BITS 12
>  #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index a3dfee4..e9ea78c 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -8,8 +8,21 @@
>  
>  struct iomap_ops;
>  
> -/* We use lowest available exceptional entry bit for locking */
> +/*
> + * We use lowest available bit in exceptional entry for locking, other two
> + * bits to determine entry type. In total 3 special bits.
> + */
> +#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 3)
>  #define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
> +#define RADIX_DAX_PTE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
> +#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
> +#define RADIX_DAX_TYPE_MASK (RADIX_DAX_PTE | RADIX_DAX_PMD)
> +#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_TYPE_MASK)
> +#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
> +#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
> +		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE) | \
> +		RADIX_TREE_EXCEPTIONAL_ENTRY))
> +
>  
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		struct iomap_ops *ops);
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
