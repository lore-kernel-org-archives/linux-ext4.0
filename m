From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm: introduce kv[mz]alloc helpers
Date: Fri, 6 Jan 2017 15:36:04 +0100
Message-ID: <6ab0f90a-4ead-d7a2-74e3-200c49b7d2b3@suse.cz>
References: <20170102133700.1734-1-mhocko@kernel.org>
 <20170104142022.GL25453@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
 Johannes Weiner <hannes@cmpxchg.org>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
 kvm@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org,
 Joe Perches <joe@perches.com>, Anatoly Stepanov <astepanov@cloudlinux.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger@dilger.ca>
To: Michal Hocko <mhocko@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170104142022.GL25453@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 01/04/2017 03:20 PM, Michal Hocko wrote:
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 2ff499680cc6..0a5cc1237afe 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -712,17 +712,8 @@ EXPORT_SYMBOL(xt_check_entry_offsets);
>   */
>  unsigned int *xt_alloc_entry_offsets(unsigned int size)
>  {
> -	unsigned int *off;
> +	return kvmalloc(size * sizeof(unsigned int), GFP_KERNEL);;
>  
> -	off = kcalloc(size, sizeof(unsigned int), GFP_KERNEL | __GFP_NOWARN);
> -
> -	if (off)
> -		return off;
> -
> -	if (size < (SIZE_MAX / sizeof(unsigned int)))
> -		off = vmalloc(size * sizeof(unsigned int));
> -
> -	return off;

This one seems to have tried hard to avoid the multiplication overflow
by using kcalloc() and doing the size check before vmalloc(), so I
wonder if it's safe to just remove the checks completely?

>  }
>  EXPORT_SYMBOL(xt_alloc_entry_offsets);
>  
> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> index 86309a3156a5..5678eff40f61 100644
> --- a/net/sched/sch_fq.c
> +++ b/net/sched/sch_fq.c
> @@ -624,16 +624,6 @@ static void fq_rehash(struct fq_sched_data *q,
>  	q->stat_gc_flows += fcnt;
>  }
>  
> -static void *fq_alloc_node(size_t sz, int node)
> -{
> -	void *ptr;
> -
> -	ptr = kmalloc_node(sz, GFP_KERNEL | __GFP_REPEAT | __GFP_NOWARN, node);

Another patch 3 material?

> -	if (!ptr)
> -		ptr = vmalloc_node(sz, node);
> -	return ptr;
> -}
> -
>  static void fq_free(void *addr)
>  {
>  	kvfree(addr);
> @@ -650,7 +640,7 @@ static int fq_resize(struct Qdisc *sch, u32 log)
>  		return 0;
>  
>  	/* If XPS was setup, we can allocate memory on right NUMA node */
> -	array = fq_alloc_node(sizeof(struct rb_root) << log,
> +	array = kvmalloc_node(sizeof(struct rb_root) << log, GFP_KERNEL,
>  			      netdev_queue_numa_node_read(sch->dev_queue));
>  	if (!array)
>  		return -ENOMEM;

With that fixed,

Acked-by: Vlastimil Babka <vbabka@suse.cz>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
