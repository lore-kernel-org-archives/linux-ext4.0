From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [patch v2 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Thu, 02 Sep 2010 09:59:13 +0200
Message-ID: <4C7F5951.6040809@gmail.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 09/02/2010 03:02 AM, David Rientjes wrote:
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -334,6 +334,57 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
>  	return kmalloc_node(size, flags | __GFP_ZERO, node);
>  }
>  
> +/**
> + * kmalloc_nofail - infinitely loop until kmalloc() succeeds.
> + * @size: how many bytes of memory are required.
> + * @flags: the type of memory to allocate (see kmalloc).
> + *
> + * NOTE: no new callers of this function should be implemented!
> + * All memory allocations should be failable whenever possible.
> + */
> +static inline void *kmalloc_nofail(size_t size, gfp_t flags)
> +{
> +	void *ret;
> +
> +	for (;;) {
> +		ret = kmalloc(size, flags);
> +		if (ret)
> +			return ret;
> +		WARN_ON_ONCE(get_order(size) > PAGE_ALLOC_COSTLY_ORDER);

This doesn't work as you expect. kmalloc will warn every time it fails.
__GFP_NOFAIL used to disable the warning. Actually what's wrong with
__GFP_NOFAIL? I cannot find a reason in the changelogs why the patches
are needed.

> +	}



-- 
js
