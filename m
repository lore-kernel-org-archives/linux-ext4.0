From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/ext2/super.c: Drop memory allocation cast
Date: Wed, 11 Jun 2014 14:14:54 +0200
Message-ID: <20140611121454.GE3661@quack.suse.cz>
References: <20140610144118.GA3255@himangi-Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
To: Himangi Saraogi <himangi774@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140610144118.GA3255@himangi-Dell>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 10-06-14 20:11:18, Himangi Saraogi wrote:
> Drop cast on the result of kmem_cache_alloc.
> 
> The semantic patch that makes this change is as follows:
> 
> // <smpl>
> @@
> type T;
> @@
> 
> - (T *)
>   (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
>    kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
  Merged to my tree. Thanks!

								Honza
> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 3750031..b88edc0 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -161,7 +161,7 @@ static struct kmem_cache * ext2_inode_cachep;
>  static struct inode *ext2_alloc_inode(struct super_block *sb)
>  {
>  	struct ext2_inode_info *ei;
> -	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
> +	ei = kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
>  	if (!ei)
>  		return NULL;
>  	ei->i_block_alloc_info = NULL;
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
