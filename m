From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 6/6][64-bit] __u32 -> __u64 in ba_resize_bmap() and  blk_t -> blk64_t  in ext2fs_check_desc()
Date: Mon, 4 May 2009 02:21:38 -0400
Message-ID: <20090504062138.GH9151@shell>
References: <15592.1241167646@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZEDGVj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 02:21:39 -0400
Content-Disposition: inline
In-Reply-To: <15592.1241167646@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 04:47:26AM -0400, Nick Dokos wrote:
> Both of these were found by code inspection while chasing the
> ext2fs_get_free_blocks2() problem. I have not seen a problem arising
> from them, but they look like bugs to me.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> ---
>  lib/ext2fs/blkmap64_ba.c |    2 +-
>  lib/ext2fs/check_desc.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
> index f7f7097..b9e0e90 100644
> --- a/lib/ext2fs/blkmap64_ba.c
> +++ b/lib/ext2fs/blkmap64_ba.c
> @@ -124,7 +124,7 @@ static errcode_t ba_resize_bmap(ext2fs_generic_bitmap64 bmap,
>  	ext2fs_ba_private bp = (ext2fs_ba_private) bmap->private;
>  	errcode_t	retval;
>  	size_t		size, new_size;
> -	__u32		bitno;
> +	__u64		bitno;
>  
>  	/*
>  	 * If we're expanding the bitmap, make sure all of the new
> diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
> index 6a969e0..e812c9f 100644
> --- a/lib/ext2fs/check_desc.c
> +++ b/lib/ext2fs/check_desc.c
> @@ -36,7 +36,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
>  	dgrp_t i;
>  	blk64_t first_block = fs->super->s_first_data_block;
>  	blk64_t last_block = ext2fs_blocks_count(fs->super)-1;
> -	blk_t blk, b;
> +	blk64_t blk, b;
>  	int j;
>  
>  	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> -- 
> 1.6.0.6
> 

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

-VAL
