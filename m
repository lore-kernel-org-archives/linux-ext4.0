From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 51/51] ext2: enable cgroup writeback support
Date: Wed, 1 Jul 2015 21:29:12 +0200
Message-ID: <20150701192912.GN7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-52-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz,
	hch@infradead.org, hannes@cmpxchg.org,
	linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
	lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
	mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
	david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru,
	linux-ext4@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-52-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 22-05-15 17:14:05, Tejun Heo wrote:
> Writeback now supports cgroup writeback and the generic writeback,
> buffer, libfs, and mpage helpers that ext2 uses are all updated to
> work with cgroup writeback.
> 
> This patch enables cgroup writeback for ext2 by adding
> FS_CGROUP_WRITEBACK to its ->fs_flags.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@vger.kernel.org

Hallelujah!

Reviewed-by: Jan Kara <jack@suse.com>

> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index d0e746e..549219d 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1543,7 +1543,7 @@ static struct file_system_type ext2_fs_type = {
>  	.name		= "ext2",
>  	.mount		= ext2_mount,
>  	.kill_sb	= kill_block_super,
> -	.fs_flags	= FS_REQUIRES_DEV,
> +	.fs_flags	= FS_REQUIRES_DEV | FS_CGROUP_WRITEBACK,
>  };
>  MODULE_ALIAS_FS("ext2");
>  
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
