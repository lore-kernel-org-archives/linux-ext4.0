From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/3] e2fsprogs/tune2fs: rewrite metadata checksums
 when resizing inode size
Date: Wed, 12 Nov 2014 14:39:59 -0800
Message-ID: <20141112223959.GH10043@birch.djwong.org>
References: <1415785780-3832-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415785780-3832-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaKLWkI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 17:40:08 -0500
Content-Disposition: inline
In-Reply-To: <1415785780-3832-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 12, 2014 at 05:49:39PM +0800, Xiaoguang Wang wrote:
> When we use tune2fs -I new_ino_size to change inode size, if everything is OK,
> the corresponding ext4_group_desc.bg_free_blocks_count will be decreased, so
> obviously, we need to re-compute the group descriptor checksums, fix this. If
> not doing this, mount operation will fail.
> 
> Meanwhile, the patch will trigger an existing memory write overflow, which will
> casue segfault, please see the next patch.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
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

Aha!  expand_inode_table() fails to recompute the checksums of the inode blocks
it's moving around, and happily your change takes care of recomputing the inode
checksums for a metadata_csum FS.  The changelog for this patch doesn't mention
this, but it should.

There ought to be a regression test for this.  Can you send one along, please?

I crafted my own test case for the metadata_csum failure while trying to figure
out what this patchset does, so I'll simply send it out.  Unfortunately, the
test requires a fix for a bug in the hugefile code that I'll cram onto the
patchbomb.

Other than that, you can add for all three patches:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
