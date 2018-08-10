From: Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Date: Fri, 10 Aug 2018 14:52:53 -0500
Message-ID: <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
Reply-To: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180710191031.17919-2-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
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

On 7/10/18 2:10 PM, Ross Zwisler wrote:
> Inodes using DAX should only ever have exceptional entries in their page
> caches.  Make this clear by warning if the iteration in
> dax_layout_busy_page() ever sees a non-exceptional entry, and by adding a
> comment for the pagevec_release() call which only deals with struct page
> pointers.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Hi Ted, hadn't seem feedback from you on this by the time it gathered reviews,
is this something you plan to merge for realz?  (I see it's on your dev
branch now, just not sure of its permanence at this point.)

Thanks,
-Eric

> ---
>  fs/dax.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 641192808bb6..897b51e41d8f 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -566,7 +566,8 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
>  			if (index >= end)
>  				break;
>  
> -			if (!radix_tree_exceptional_entry(pvec_ent))
> +			if (WARN_ON_ONCE(
> +			     !radix_tree_exceptional_entry(pvec_ent)))
>  				continue;
>  
>  			xa_lock_irq(&mapping->i_pages);
> @@ -578,6 +579,13 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
>  			if (page)
>  				break;
>  		}
> +
> +		/*
> +		 * We don't expect normal struct page entries to exist in our
> +		 * tree, but we keep these pagevec calls so that this code is
> +		 * consistent with the common pattern for handling pagevecs
> +		 * throughout the kernel.
> +		 */
>  		pagevec_remove_exceptionals(&pvec);
>  		pagevec_release(&pvec);
>  		index++;
> 
