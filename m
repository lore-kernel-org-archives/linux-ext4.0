From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm: introduce kv[mz]alloc helpers
Date: Tue, 3 Jan 2017 11:23:04 +0100
Message-ID: <74a00631-ab1f-b818-6608-1554bcd7cbc1@suse.cz>
References: <20170102133700.1734-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
 Johannes Weiner <hannes@cmpxchg.org>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
 kvm@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org,
 Joe Perches <joe@perches.com>, Michal Hocko <mhocko@suse.com>,
 Anatoly Stepanov <astepanov@cloudlinux.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger@dilger.ca>
To: Michal Hocko <mhocko@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170102133700.1734-1-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 01/02/2017 02:37 PM, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
>
> Using kmalloc with the vmalloc fallback for larger allocations is a
> common pattern in the kernel code. Yet we do not have any common helper
> for that and so users have invented their own helpers. Some of them are
> really creative when doing so. Let's just add kv[mz]alloc and make sure
> it is implemented properly. This implementation makes sure to not make
> a large memory pressure for > PAGE_SZE requests (__GFP_NORETRY) and also
> to not warn about allocation failures. This also rules out the OOM
> killer as the vmalloc is a more approapriate fallback than a disruptive
> user visible action.
>
> This patch also changes some existing users and removes helpers which
> are specific for them. In some cases this is not possible (e.g.
> ext4_kvmalloc, libcfs_kvzalloc, __aa_kvmalloc) because those seems to be
> broken and require GFP_NO{FS,IO} context which is not vmalloc compatible
> in general (note that the page table allocation is GFP_KERNEL). Those
> need to be fixed separately.
>
> apparmor has already claimed kv[mz]alloc so remove those and use
> __aa_kvmalloc instead to prevent from the naming clashes.
>
> Changes since v1
> - define __vmalloc_node_flags for CONFIG_MMU=n
>
> Cc: Anatoly Stepanov <astepanov@cloudlinux.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca> # ext4 part
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>
(but with a small fix and suggestion below)

> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -346,6 +346,46 @@ unsigned long vm_mmap(struct file *file, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vm_mmap);
>
> +/**
> + * kvmalloc_node - allocate contiguous memory from SLAB with vmalloc fallback
> + * @size: size of the request.
> + * @flags: gfp mask for the allocation - must be compatible with GFP_KERNEL.
> + * @node: numa node to allocate from
> + *
> + * Uses kmalloc to get the memory but if the allocation fails then falls back
> + * to the vmalloc allocator. Use kvfree for freeing the memory.
> + */
> +void *kvmalloc_node(size_t size, gfp_t flags, int node)
> +{
> +	gfp_t kmalloc_flags = flags;
> +	void *ret;
> +
> +	/*
> +	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
> +	 * so the given set of flags has to be compatible.
> +	 */
> +	WARN_ON((flags & GFP_KERNEL) != GFP_KERNEL);

Wouldn't a _ONCE be sufficient? It's unlikely that multiple wrong call sites 
appear out of the blue, but we don't want to flood the log from a single 
frequently called site. No strong feelings though.

> +
> +	/*
> +	 * Make sure that larger requests are not too disruptive - no OOM
> +	 * killer and no allocation failure warnings as we have a fallback
> +	 */
> +	if (size > PAGE_SIZE)
> +		kmalloc_flags |= __GFP_NORETRY | __GFP_NOWARN;
> +
> +	ret = kmalloc_node(size, kmalloc_flags, node);
> +
> +	/*
> +	 * It doesn't really make sense to fallback to vmalloc for sub page
> +	 * requests
> +	 */
> +	if (ret || size < PAGE_SIZE)

This should be size <= PAGE_SIZE.

> +		return ret;
> +
> +	return __vmalloc_node_flags(size, node, flags);
> +}
> +EXPORT_SYMBOL(kvmalloc_node);
> +
>  void kvfree(const void *addr)
>  {
>  	if (is_vmalloc_addr(addr))

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
