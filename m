From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] ext4: convert swap_inode_data() over to use swap()
 on most of the fields
Date: Wed, 4 Jan 2017 16:43:32 +0100
Message-ID: <20170104154332.GA3607@quack2.suse.cz>
References: <1482249341-21113-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482249341-21113-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 20-12-16 10:55:41, Jeff Layton wrote:
> For some odd reason, it forces a byte-by-byte copy of each field. A
> plain old swap() on most of these fields would be more efficient. We
> do need to retain one memswap however as that field is an array.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ioctl.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 49fd1371bfa2..fb844da4836f 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -60,18 +60,16 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
>  	ei1 = EXT4_I(inode1);
>  	ei2 = EXT4_I(inode2);
>  
> -	memswap(&inode1->i_flags, &inode2->i_flags, sizeof(inode1->i_flags));
> -	memswap(&inode1->i_version, &inode2->i_version,
> -		  sizeof(inode1->i_version));
> -	memswap(&inode1->i_blocks, &inode2->i_blocks,
> -		  sizeof(inode1->i_blocks));
> -	memswap(&inode1->i_bytes, &inode2->i_bytes, sizeof(inode1->i_bytes));
> -	memswap(&inode1->i_atime, &inode2->i_atime, sizeof(inode1->i_atime));
> -	memswap(&inode1->i_mtime, &inode2->i_mtime, sizeof(inode1->i_mtime));
> +	swap(inode1->i_flags, inode2->i_flags);
> +	swap(inode1->i_version, inode2->i_version);
> +	swap(inode1->i_blocks, inode2->i_blocks);
> +	swap(inode1->i_bytes, inode2->i_bytes);
> +	swap(inode1->i_atime, inode2->i_atime);
> +	swap(inode1->i_mtime, inode2->i_mtime);
>  
>  	memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));
> -	memswap(&ei1->i_flags, &ei2->i_flags, sizeof(ei1->i_flags));
> -	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
> +	swap(ei1->i_flags, ei2->i_flags);
> +	swap(ei1->i_disksize, ei2->i_disksize);
>  	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
>  	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
