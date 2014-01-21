From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/6] libext2fs: don't hang on to unmapped block if extent
 tree update fails
Date: Tue, 21 Jan 2014 15:45:33 +0800
Message-ID: <20140121074533.GF1819@gmail.com>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062211.20507.54603.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33192 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaAUHlK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 02:41:10 -0500
Received: by mail-pb0-f54.google.com with SMTP id uo5so4428777pbc.27
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jan 2014 23:41:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140121062211.20507.54603.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 10:22:11PM -0800, Darrick J. Wong wrote:
> If we're doing a BMAP_ALLOC allocation and the extent tree update
> fails, there's no point in hanging on to the newly allocated block.
> So, free it to make fsck happy.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
                                                - Zheng

> ---
>  lib/ext2fs/bmap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
> index b944c27..db2fd72 100644
> --- a/lib/ext2fs/bmap.c
> +++ b/lib/ext2fs/bmap.c
> @@ -255,8 +255,10 @@ got_block:
>  	set_extent:
>  		retval = ext2fs_extent_set_bmap(handle, block,
>  						blk64, 0);
> -		if (retval)
> +		if (retval) {
> +			ext2fs_block_alloc_stats2(fs, blk64, -1);
>  			return retval;
> +		}
>  		/* Update inode after setting extent */
>  		retval = ext2fs_read_inode(fs, ino, inode);
>  		if (retval)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
