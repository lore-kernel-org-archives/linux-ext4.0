From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 1/2][64-BIT] blk_t -> blk64_t in read_bitmaps().
Date: Mon, 20 Apr 2009 20:49:36 -0400
Message-ID: <20090421004935.GA24177@shell>
References: <30393.1240034704@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZDUAtk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 20:49:40 -0400
Content-Disposition: inline
In-Reply-To: <30393.1240034704@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 18, 2009 at 02:05:04AM -0400, Nick Dokos wrote:
> e2fsck -n -f on a brand-new, never-mounted 32TiB filesystem was
> detecting a lot of "Block bitmap differences". This change makes them
> go away (there are are still more problems however: the run finds used
> blocks in one BLOCK_UNINIT group and a free block mismatch.)
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

Pulled and pushed.

-VAL

> ---
>  lib/ext2fs/rw_bitmaps.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
> index cee6142..5b504bf 100644
> --- a/lib/ext2fs/rw_bitmaps.c
> +++ b/lib/ext2fs/rw_bitmaps.c
> @@ -144,9 +144,9 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
>  	int csum_flag = 0;
>  	int do_image = fs->flags & EXT2_FLAG_IMAGE_FILE;
>  	unsigned int	cnt;
> -	blk_t	blk;
> -	blk_t	blk_itr = fs->super->s_first_data_block;
> -	blk_t   blk_cnt;
> +	blk64_t	blk;
> +	blk64_t	blk_itr = fs->super->s_first_data_block;
> +	blk64_t   blk_cnt;
>  	ext2_ino_t ino_itr = 1;
>  	ext2_ino_t ino_cnt;
>  
> -- 
> 1.6.0.6
> 
