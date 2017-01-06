From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm: introduce kv[mz]alloc helpers
Date: Fri, 6 Jan 2017 14:29:33 +0100
Message-ID: <747f7b9a-e95d-a872-7e30-ea235b91593a@suse.cz>
References: <20170102133700.1734-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -514,18 +514,9 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(vhost_dev_set_owner);
>  
> -static void *vhost_kvzalloc(unsigned long size)
> -{
> -	void *n = kzalloc(size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);

Hi, I just noticed that this had __GFP_REPEAT, so you'll probably want
to move these hunks to patch 3 with the rest of vhost.

> -
> -	if (!n)
> -		n = vzalloc(size);
> -	return n;
> -}
> -
>  struct vhost_umem *vhost_dev_reset_owner_prepare(void)
>  {
> -	return vhost_kvzalloc(sizeof(struct vhost_umem));
> +	return kvzalloc(sizeof(struct vhost_umem), GFP_KERNEL);
>  }
>  EXPORT_SYMBOL_GPL(vhost_dev_reset_owner_prepare);
>  
> @@ -1189,7 +1180,7 @@ EXPORT_SYMBOL_GPL(vhost_vq_access_ok);
>  
>  static struct vhost_umem *vhost_umem_alloc(void)
>  {
> -	struct vhost_umem *umem = vhost_kvzalloc(sizeof(*umem));
> +	struct vhost_umem *umem = kvzalloc(sizeof(*umem), GFP_KERNEL);
>  
>  	if (!umem)
>  		return NULL;
> @@ -1215,7 +1206,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>  		return -EOPNOTSUPP;
>  	if (mem.nregions > max_mem_regions)
>  		return -E2BIG;
> -	newmem = vhost_kvzalloc(size + mem.nregions * sizeof(*m->regions));
> +	newmem = kvzalloc(size + mem.nregions * sizeof(*m->regions), GFP_KERNEL);
>  	if (!newmem)
>  		return -ENOMEM;
>  
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 7ae43c59bc79..bb49409172d9 100644

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
