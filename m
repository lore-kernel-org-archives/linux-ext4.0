From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 15/28] debugfs: handle inline_data feature in bmap
 command
Date: Tue, 3 Dec 2013 19:11:25 -0800
Message-ID: <20131204031125.GK9535@birch.djwong.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-16-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18649 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3LDDLe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 22:11:34 -0500
Content-Disposition: inline
In-Reply-To: <1386072715-9869-16-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 08:11:42PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> No physical block mapping if an inode has inline data.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  lib/ext2fs/bmap.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
> index 5074587..0d043bd 100644
> --- a/lib/ext2fs/bmap.c
> +++ b/lib/ext2fs/bmap.c
> @@ -273,6 +273,13 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
>  		block_buf = buf;
>  	}
>  
> +	/*
> +	 * If an inode has inline data, that means that it doesn't have
> +	 * any blocks and we shouldn't map any blocks for it.
> +	 */
> +	if (inode->i_flags & EXT4_INLINE_DATA_FL)
> +		goto done;

If you move this to before the ext2fs_get_array() chunk above it, you could
return straight out of the function.

This should return an error code of some kind, because otherwise the client
will think that something happened when the function returns 0, especially if
BMAP_{ALLOC,SET,UNINIT} are passed in.

--D

> +
>  	if (inode->i_flags & EXT4_EXTENTS_FL) {
>  		retval = ext2fs_extent_open2(fs, ino, inode, &handle);
>  		if (retval)
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
