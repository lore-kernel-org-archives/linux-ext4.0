From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 14/22] mke2fs: add inline_data support in mke2fs
Date: Fri, 11 Oct 2013 17:27:18 -0700
Message-ID: <20131012002718.GT6860@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-15-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20822 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3JLA10 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2013 20:27:26 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-15-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:41PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Inline_data feature doesn't be specified without ext_attr.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  misc/mke2fs.8.in |    3 +++
>  misc/mke2fs.c    |   14 +++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 023ba49..5731542 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -578,6 +578,9 @@ option).
>  @JDEV@must be created with the same
>  @JDEV@block size as the filesystems that will be using it.
>  .TP
> +.B inline_data
> +Allow data to be stored in inode

"..to be stored in the inode and extended attribute areas" ?

> +.TP
>  .B large_file
>  Filesystem can contain files that are greater than 2GB.  (Modern kernels
>  set this feature automatically when a file > 2GB is created.)
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index a59d24c..cb084ea 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -902,7 +902,8 @@ static __u32 ok_features[3] = {
>  		EXT2_FEATURE_INCOMPAT_META_BG|
>  		EXT4_FEATURE_INCOMPAT_FLEX_BG|
>  		EXT4_FEATURE_INCOMPAT_MMP |
> -		EXT4_FEATURE_INCOMPAT_64BIT,
> +		EXT4_FEATURE_INCOMPAT_64BIT|
> +		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
>  	/* R/O compat */
>  	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
>  		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
> @@ -2042,6 +2043,17 @@ profile_error:
>  		exit(1);
>  	}
>  
> +	/* Since inline_data depends on ext_attr, we would ask it to be
> +	 * enabled.

/*
 * Comment
 */

There needs to be an extra newline after the '/*' at the top of that multiline
comment.

> +	 */
> +	if ((fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> +	    !(fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
> +		com_err(program_name, 0,
> +			_("Ext_attr feature not enabled, so inline_data "
> +			  "feature doesn't be specified"));

"The inline_data feature requires the ext_attr feature." ?

--D

> +		exit(1);
> +	}
> +
>  	if (fs_param.s_blocks_per_group) {
>  		if (fs_param.s_blocks_per_group < 256 ||
>  		    fs_param.s_blocks_per_group > 8 * (unsigned) blocksize) {
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
