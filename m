From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/19] afs: convert to new i_version API
Date: Sat, 16 Dec 2017 08:49:46 -0500
Message-ID: <1513432186.3428.6.camel@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
         <20171216134656.15561-6-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org,
        jack-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171216134656.15561-6-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2017-12-16 at 08:46 -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> For AFS, it's generally treated as an opaque value, so we use the
> *_raw variants of the API here.
> 
> Note that AFS has quite a different definition for this counter. AFS
> only increments it on changes to the data, not for the metadata. We'll
> need to reconcile that somehow if we ever want to present this to
> userspace via statx.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/afs/fsclient.c | 2 +-
>  fs/afs/inode.c    | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
> index b90ef39ae914..67ed9bb5fe31 100644
> --- a/fs/afs/fsclient.c
> +++ b/fs/afs/fsclient.c
> @@ -124,7 +124,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
>  		vnode->vfs_inode.i_ctime.tv_sec	= status->mtime_client;
>  		vnode->vfs_inode.i_mtime	= vnode->vfs_inode.i_ctime;
>  		vnode->vfs_inode.i_atime	= vnode->vfs_inode.i_ctime;
> -		vnode->vfs_inode.i_version	= data_version;
> +		inode_set_iversion_raw(&vnode->vfs_inode, data_version);
>  	}
>  
>  	expected_version = status->data_version;
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index 3415eb7484f6..af9577210a46 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -89,7 +89,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
>  	inode->i_atime		= inode->i_mtime = inode->i_ctime;
>  	inode->i_blocks		= 0;
>  	inode->i_generation	= vnode->fid.unique;
> -	inode->i_version	= vnode->status.data_version;
> +	inode_set_iversion_raw(inode, vnode->status.data_version);
>  	inode->i_mapping->a_ops	= &afs_fs_aops;
>  
>  	read_sequnlock_excl(&vnode->cb_lock);
> @@ -218,7 +218,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
>  	inode->i_ctime.tv_nsec	= 0;
>  	inode->i_atime		= inode->i_mtime = inode->i_ctime;
>  	inode->i_blocks		= 0;
> -	inode->i_version	= 0;
> +	inode_set_iversion_raw(inode, 0);
>  	inode->i_generation	= 0;
>  
>  	set_bit(AFS_VNODE_PSEUDODIR, &vnode->flags);

TBH, we could just remove the i_version handling here. Nothing ever
looks at the i_version field in AFS inodes.
-- 
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
