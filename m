From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 2/6] [64-bit] write_bitmaps(): blk_t -> blk64_t
Date: Mon, 4 May 2009 02:20:33 -0400
Message-ID: <20090504062033.GD9151@shell>
References: <15560.1241167591@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZEDGUe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 02:20:34 -0400
Content-Disposition: inline
In-Reply-To: <15560.1241167591@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 04:46:31AM -0400, Nick Dokos wrote:
> write_bitmaps() was truncating blocks numbers to 32 bits and therefore
> writing at the wrong place on the disk.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> ---
>  lib/ext2fs/rw_bitmaps.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
> index 5b504bf..da472a8 100644
> --- a/lib/ext2fs/rw_bitmaps.c
> +++ b/lib/ext2fs/rw_bitmaps.c
> @@ -36,8 +36,8 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
>  	errcode_t	retval;
>  	char 		*block_buf, *inode_buf;
>  	int		csum_flag = 0;
> -	blk_t		blk;
> -	blk_t		blk_itr = fs->super->s_first_data_block;
> +	blk64_t		blk;
> +	blk64_t		blk_itr = fs->super->s_first_data_block;
>  	ext2_ino_t	ino_itr = 1;
>  
>  	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> -- 
> 1.6.0.6
> 

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

-VAL
