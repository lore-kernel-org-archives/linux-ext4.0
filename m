From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 16/19] fs: only set S_VERSION when updating times if
 necessary
Date: Mon, 18 Dec 2017 17:07:36 +0100
Message-ID: <20171218160736.GE30350@quack2.suse.cz>
References: <20171218151156.14565-1-jlayton@kernel.org>
 <20171218151156.14565-17-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, jack-l3A5Bk7waGM@public.gmane.org,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171218151156.14565-17-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon 18-12-17 10:11:53, Jeff Layton wrote:
> From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> We only really need to update i_version if someone has queried for it
> since we last incremented it. By doing that, we can avoid having to
> update the inode if the times haven't changed.
> 
> If the times have changed, then we go ahead and forcibly increment the
> counter, under the assumption that we'll be going to the storage
> anyway, and the increment itself is relatively cheap.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/inode.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 03102d6ef044..83f6cfc3cde7 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -19,6 +19,7 @@
>  #include <linux/ratelimit.h>
>  #include <linux/list_lru.h>
>  #include <trace/events/writeback.h>
> +#include <linux/iversion.h>
>  #include "internal.h"
>  
>  /*
> @@ -1634,17 +1635,24 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
>  int generic_update_time(struct inode *inode, struct timespec *time, int flags)
>  {
>  	int iflags = I_DIRTY_TIME;
> +	bool dirty = false;
>  
> -	if (flags & S_ATIME)
> +	if (flags & S_ATIME) {
>  		inode->i_atime = *time;
> +		dirty |= !(inode->i_sb->s_flags & SB_LAZYTIME);
> +	}
>  	if (flags & S_VERSION)
> -		inode_inc_iversion(inode);
> -	if (flags & S_CTIME)
> +		dirty |= inode_maybe_inc_iversion(inode, dirty);
> +	if (flags & S_CTIME) {
>  		inode->i_ctime = *time;
> -	if (flags & S_MTIME)
> +		dirty = true;
> +	}
> +	if (flags & S_MTIME) {
>  		inode->i_mtime = *time;
> +		dirty = true;
> +	}

The SB_LAZYTIME handling is wrong here. That option is not only about atime
handling but rather about all inode time stamps. So you rather need
something like:

	if (flags & (S_ATIME | S_CTIME | S_MTIME) &&
	    !(inode->i_sb->s_flags & SB_LAZYTIME))
		dirty = true;

								Honza

>  
> -	if (!(inode->i_sb->s_flags & SB_LAZYTIME) || (flags & S_VERSION))
> +	if (dirty)
>  		iflags |= I_DIRTY_SYNC;
>  	__mark_inode_dirty(inode, iflags);
>  	return 0;
> @@ -1863,7 +1871,7 @@ int file_update_time(struct file *file)
>  	if (!timespec_equal(&inode->i_ctime, &now))
>  		sync_it |= S_CTIME;
>  
> -	if (IS_I_VERSION(inode))
> +	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
>  		sync_it |= S_VERSION;
>  
>  	if (!sync_it)
> -- 
> 2.14.3
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
