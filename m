From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/5] mke2fs: the -g option will now specify the clusters
 per block group
Date: Tue, 15 Jan 2013 23:22:50 +0800
Message-ID: <20130115152250.GB19209@gmail.com>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
 <1358210232-30578-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55437 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab3AOPJL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 10:09:11 -0500
Received: by mail-pa0-f41.google.com with SMTP id bj3so154071pad.14
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 07:09:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1358210232-30578-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 07:37:09PM -0500, Theodore Ts'o wrote:
> If bigalloc is enabled, then -g will specify the clusters per block
> group.  (If bigalloc is not enabled, then a cluster == a block, so the
> meaning of -g is not changed.)
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng
> ---
>  misc/mke2fs.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 75d0e48..5cb49b3 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1962,6 +1962,15 @@ profile_error:
>  		}
>  	}
>  
> +	/*
> +	 * If the bigalloc feature is enabled, then the -g option will
> +	 * specify the number of clusters per group.
> +	 */
> +	if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC) {
> +		fs_param.s_clusters_per_group = fs_param.s_blocks_per_group;
> +		fs_param.s_blocks_per_group = 0;
> +	}
> +
>  	if (inode_size == 0)
>  		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
>  	if (!flex_bg_size && (fs_param.s_feature_incompat &
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
