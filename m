From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] debugfs: Fix sprintf stack overflow
Date: Tue, 11 Oct 2011 21:38:56 -0500
Message-ID: <4E94FDC0.1070409@redhat.com>
References: <20111012010221.GN12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1JLCjB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Oct 2011 22:39:01 -0400
In-Reply-To: <20111012010221.GN12447@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/11/11 8:02 PM, Darrick J. Wong wrote:
> The htree dump code overflows a char buffer if the directory has a long
> filename because the buffer is not large enough to hold the characters that are
> not part of the filename.  Make the buffer larger and use snprintf instead.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

lessee ...

"%u 0x%08x-%08x (%d) %s   "

%u   10
" "   1
0x    2
%08x  8
-     1
%08x  8
" ("  2
%d    5
"( "  2
%s    EXT2_NAME_LEN
"   " 3
-------
EXT2_NAME_LEN+42

64 should be plenty :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
>  debugfs/htree.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/debugfs/htree.c b/debugfs/htree.c
> index 06e7737..05745eb 100644
> --- a/debugfs/htree.c
> +++ b/debugfs/htree.c
> @@ -39,7 +39,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
>  	int		thislen, col = 0;
>  	unsigned int	offset = 0;
>  	char		name[EXT2_NAME_LEN + 1];
> -	char		tmp[EXT2_NAME_LEN + 16];
> +	char		tmp[EXT2_NAME_LEN + 64];
>  	blk64_t		pblk;
>  	ext2_dirhash_t 	hash, minor_hash;
>  	unsigned int	rec_len;
> @@ -91,8 +91,8 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
>  		if (errcode)
>  			com_err("htree_dump_leaf_node", errcode,
>  				"while calculating hash");
> -		sprintf(tmp, "%u 0x%08x-%08x (%d) %s   ", dirent->inode,
> -			hash, minor_hash, rec_len, name);
> +		snprintf(tmp, EXT2_NAME_LEN + 64, "%u 0x%08x-%08x (%d) %s   ",
> +			dirent->inode, hash, minor_hash, rec_len, name);
>  		thislen = strlen(tmp);
>  		if (col + thislen > 80) {
>  			fprintf(pager, "\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

