From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 08/31] libext2fs: Fix off-by-one error in file
 truncation
Date: Mon, 7 Oct 2013 16:02:05 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310071601290.1975@localhost.localdomain>
References: <20131001012642.28415.89353.stgit@birch.djwong.org> <20131001012734.28415.45404.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab3JGOCM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 10:02:12 -0400
In-Reply-To: <20131001012734.28415.45404.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Sep 2013, Darrick J. Wong wrote:

> Date: Mon, 30 Sep 2013 18:27:34 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 08/31] libext2fs: Fix off-by-one error in file truncation
> 
> When told to truncate a file, ext2fs_file_set_size2 should start with the first
> block past the end of the file.  The current calculation jumps one more block
> ahead, with the result that it fails to hack off the last block.  Adding
> blocksize-1 and dividing is sufficient to find the last block.

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/fileio.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
> index ae5cbf1..d875630 100644
> --- a/lib/ext2fs/fileio.c
> +++ b/lib/ext2fs/fileio.c
> @@ -384,10 +384,10 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
>  	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
>  
>  	truncate_block = ((size + file->fs->blocksize - 1) >>
> -			  EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
> +			  EXT2_BLOCK_SIZE_BITS(file->fs->super));
>  	old_size = EXT2_I_SIZE(&file->inode);
>  	old_truncate = ((old_size + file->fs->blocksize - 1) >>
> -		      EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
> +		      EXT2_BLOCK_SIZE_BITS(file->fs->super));
>  
>  	/* If we're writing a large file, set the large_file flag */
>  	if (LINUX_S_ISREG(file->inode.i_mode) &&
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
