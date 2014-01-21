From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 4/6] libext2fs: during punch, fix parent extents after
 modifying extent
Date: Tue, 21 Jan 2014 15:43:43 +0800
Message-ID: <20140121074343.GE1819@gmail.com>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062204.20507.93142.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64149 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaAUHjU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 02:39:20 -0500
Received: by mail-pb0-f45.google.com with SMTP id un15so4343406pbc.4
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jan 2014 23:39:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140121062204.20507.93142.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 10:22:04PM -0800, Darrick J. Wong wrote:
> When modifying/removing an extent during punch, don't forget to update
> the extent's parents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
                                                - Zheng

> ---
>  lib/ext2fs/punch.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
> index 657cb53..a3d020e 100644
> --- a/lib/ext2fs/punch.c
> +++ b/lib/ext2fs/punch.c
> @@ -353,6 +353,9 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  		if (extent.e_len) {
>  			dbg_print_extent("replacing", &extent);
>  			retval = ext2fs_extent_replace(handle, 0, &extent);
> +			if (retval)
> +				goto errout;
> +			retval = ext2fs_extent_fix_parents(handle);
>  		} else {
>  			struct ext2fs_extent	newex;
>  			blk64_t			old_lblk, next_lblk;
> @@ -387,6 +390,11 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  			if (retval)
>  				goto errout;
>  
> +			retval = ext2fs_extent_fix_parents(handle);
> +			if (retval && retval != EXT2_ET_NO_CURRENT_NODE)
> +				goto errout;
> +			retval = 0;
> +
>  			/* Jump forward to the next extent. */
>  			ext2fs_extent_goto(handle, next_lblk);
>  			op = EXT2_EXTENT_CURRENT;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
