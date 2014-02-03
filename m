From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] ext3: Add __init macro to init_inodecache
Date: Tue, 4 Feb 2014 00:55:47 +0100
Message-ID: <20140203235547.GF2542@quack.suse.cz>
References: <20140201191300.bf1332562e81082e8d7cfa53@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140201191300.bf1332562e81082e8d7cfa53@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 01-02-14 19:13:00, Fabian Frederick wrote:
> init_inodecache is only called by __init init_ext3_fs.
  Thanks. Added to my tree.

							Honza

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/ext3/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 37fd31e..94608d4 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -527,7 +527,7 @@ static void init_once(void *foo)
>  	inode_init_once(&ei->vfs_inode);
>  }
>  
> -static int init_inodecache(void)
> +static int __init init_inodecache(void)
>  {
>  	ext3_inode_cachep = kmem_cache_create("ext3_inode_cache",
>  					     sizeof(struct ext3_inode_info),
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
