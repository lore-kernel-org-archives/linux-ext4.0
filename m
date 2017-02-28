From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] libext2fs: readahead for meta_bg
Date: Tue, 28 Feb 2017 08:16:02 -0800
Message-ID: <20170228161602.GD5266@birch.djwong.org>
References: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44144 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbdB1QQt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Feb 2017 11:16:49 -0500
Content-Disposition: inline
In-Reply-To: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2017 at 01:03:45PM +0300, Artem Blagodarenko wrote:
> From: Alexey Lyashkov <alexey.lyashkov@seagate.com>
> 
> There are ~37k of random IOs with meta_bg option on 300T target.

Yikes, 300TB ext4! :)

(Is that really 2.2 million blockgroups?)

> Debugfs requires 20 minutes to be started. Enabling readahead for
> group blocks metadata save time dramatically. Only 12s to start.
> 
> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  lib/ext2fs/openfs.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index ba501e6..f158b0a 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -399,6 +399,12 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
>  #endif
>  		dest += fs->blocksize*first_meta_bg;
>  	}
> +
> +	for (i = first_meta_bg ; i < fs->desc_blocks; i++) {
> +		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
> +		io_channel_cache_readahead(fs->io, blk, 1);
> +	}
> +
>  	for (i=first_meta_bg ; i < fs->desc_blocks; i++) {
>  		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
>  		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
> -- 
> 1.7.1
> 
