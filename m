From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] misc: fix 'zero_hugefiles = false' regression
Date: Mon, 8 May 2017 18:56:36 -0700
Message-ID: <20170509015636.GC5963@birch.djwong.org>
References: <20170508224757.94528-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49784 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753987AbdEIB4n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 May 2017 21:56:43 -0400
Content-Disposition: inline
In-Reply-To: <20170508224757.94528-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 08, 2017 at 03:47:57PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When mk_hugefiles() was switched to use ext2fs_fallocate(), it was
> accidentally changed to ignore the 'zero_hugefiles = false' setting,
> which should cause hugefiles to be allocated without initializing their
> contents.  Fix this by only passing EXT2_FALLOCATE_ZERO_BLOCKS to
> ext2fs_fallocate() when zero_hugefiles is true.

Soooo... I don't know that I like the potential for stale data exposure,
which predisposes me not to like this patch.

On the other hand, mkfs isn't a frequently used program and it clearly
supports this as a feature, so let's not have regressions.

Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Fixes: 4f868703f6f2 ("libext2fs: use fallocate for creating journals and hugefiles")
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  misc/mk_hugefiles.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
> index 71a15c5d..049c6f41 100644
> --- a/misc/mk_hugefiles.c
> +++ b/misc/mk_hugefiles.c
> @@ -260,6 +260,7 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
>  {
>  	errcode_t		retval;
>  	struct ext2_inode	inode;
> +	int			falloc_flags;
>  
>  	retval = ext2fs_new_inode(fs, 0, LINUX_S_IFREG, NULL, ino);
>  	if (retval)
> @@ -281,10 +282,11 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
>  
>  	if (ext2fs_has_feature_extents(fs->super))
>  		inode.i_flags |= EXT4_EXTENTS_FL;
> -	retval = ext2fs_fallocate(fs,
> -				  EXT2_FALLOCATE_FORCE_INIT |
> -				  EXT2_FALLOCATE_ZERO_BLOCKS,
> -				  *ino, &inode, goal, 0, num);
> +
> +	falloc_flags = EXT2_FALLOCATE_FORCE_INIT;
> +	if (zero_hugefile)
> +		falloc_flags |= EXT2_FALLOCATE_ZERO_BLOCKS;
> +	retval = ext2fs_fallocate(fs, falloc_flags, *ino, &inode, goal, 0, num);
>  	if (retval)
>  		return retval;
>  	retval = ext2fs_inode_size_set(fs, &inode, num * fs->blocksize);
> -- 
> 2.13.0.rc2.291.g57267f2277-goog
> 
