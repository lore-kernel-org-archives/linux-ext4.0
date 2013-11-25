From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 12/25] libext2fs: don't update the summary counts when
 doing implied cluster allocation
Date: Mon, 25 Nov 2013 17:03:33 +0800
Message-ID: <20131125090333.GA13183@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045014.7339.26675.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53735 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3KYJAq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 04:00:46 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so5072916pdj.2
        for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 01:00:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131018045014.7339.26675.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:50:14PM -0700, Darrick J. Wong wrote:
> When we're appending a block to a directory file or the journal file,
> and the new block is part of a cluster that has already been allocated
> to the file (implied cluster allocation), don't update the bitmap or
> the summary counts because that was performed when the cluster was
> allocated.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

In e2fsck/pass3.c we also have a expand_dir_proc() function to expand
dir.  Maybe it also needs to be fixed.  Otherwise the patch looks good
to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  lib/ext2fs/expanddir.c |    2 +-
>  lib/ext2fs/mkjournal.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
> index 22558d6..09a15fa 100644
> --- a/lib/ext2fs/expanddir.c
> +++ b/lib/ext2fs/expanddir.c
> @@ -55,6 +55,7 @@ static int expand_dir_proc(ext2_filsys	fs,
>  			return BLOCK_ABORT;
>  		}
>  		es->newblocks++;
> +		ext2fs_block_alloc_stats2(fs, new_blk, +1);
>  	}
>  	if (blockcnt > 0) {
>  		retval = ext2fs_new_dir_block(fs, 0, 0, &block);
> @@ -82,7 +83,6 @@ static int expand_dir_proc(ext2_filsys	fs,
>  	}
>  	ext2fs_free_mem(&block);
>  	*blocknr = new_blk;
> -	ext2fs_block_alloc_stats2(fs, new_blk, +1);
>  
>  	if (es->done)
>  		return (BLOCK_CHANGED | BLOCK_ABORT);
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 2afd3b7..8bf4670 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -250,6 +250,7 @@ static int mkjournal_proc(ext2_filsys	fs,
>  			es->err = retval;
>  			return BLOCK_ABORT;
>  		}
> +		ext2fs_block_alloc_stats2(fs, new_blk, +1);
>  		es->newblocks++;
>  	}
>  	if (blockcnt >= 0)
> @@ -285,7 +286,6 @@ static int mkjournal_proc(ext2_filsys	fs,
>  		return BLOCK_ABORT;
>  	}
>  	*blocknr = es->goal = new_blk;
> -	ext2fs_block_alloc_stats2(fs, new_blk, +1);
>  
>  	if (es->num_blocks == 0)
>  		return (BLOCK_CHANGED | BLOCK_ABORT);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
