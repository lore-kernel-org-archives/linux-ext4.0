From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 2/3] e2fsprogs/tune2fs: rewrite metadata checksums
 when resizing inode size
Date: Fri, 14 Nov 2014 15:10:10 -0800
Message-ID: <20141114231010.GK10043@birch.djwong.org>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27632 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaKNXKS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 18:10:18 -0500
Content-Disposition: inline
In-Reply-To: <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 05:15:36PM +0800, Xiaoguang Wang wrote:
> When we use tune2fs -I new_ino_size to change inode size, if everything is OK,
> the corresponding ext4_group_desc.bg_free_blocks_count will be decreased, so
> obviously, we need to re-compute the group descriptor checksums, and the inode
> 's size has also changed, we also need to recompute the checksums of inodes for
> metadata_csum filesystem, so here we choose to call a rewrite_metadata_checksums(),
> this will fix checksum issues.
> 
> Meanwhile, the patch will trigger an existing memory write overflow, which will
> casue segfault, please see the next patch.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/tune2fs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 065b483..91dc7c1 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -2908,8 +2908,7 @@ retry_open:
>  				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>  			rewrite_checksums = 1;
>  	}
> -	if (rewrite_checksums)
> -		rewrite_metadata_checksums(fs);
> +
>  	if (I_flag) {
>  		if (mount_flags & EXT2_MF_MOUNTED) {
>  			fputs(_("The inode size may only be "
> @@ -2935,6 +2934,7 @@ retry_open:
>  		if (resize_inode(fs, new_inode_size) == 0) {

Come to think of it, if we're enabling metadata_csum /and/ resizing the inode,
we have to set EXT2_FLAG_IGNORE_CSUM_ERRORS before calling resize_inode.  If we
don't, the library calls that resize_inode() makes will try to verify the
checksums (which haven't been set yet) and the operation will fail.

Will send patch, but at this point I'm wondering if it doesn't make more sense
for me to incorporate them into my patchbomb rather than let this series get
lost in the blizzard...

--D

>  			printf(_("Setting inode size %lu\n"),
>  							new_inode_size);
> +			rewrite_checksums = 1;
>  		} else {
>  			printf("%s", _("Failed to change inode size\n"));
>  			rc = 1;
> @@ -2942,6 +2942,9 @@ retry_open:
>  		}
>  	}
>  
> +	if (rewrite_checksums)
> +		rewrite_metadata_checksums(fs);
> +
>  	if (l_flag)
>  		list_super(sb);
>  	if (stride_set) {
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
