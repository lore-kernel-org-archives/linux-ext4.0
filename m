From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] libext2fs: only use override function when reading an
 128 byte inode
Date: Mon, 22 Apr 2013 12:11:46 -0300
Message-ID: <20130422151145.GC519@andromeda.usersys.redhat.com>
References: <1366602969-26187-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab3DVPLw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Apr 2013 11:11:52 -0400
Content-Disposition: inline
In-Reply-To: <1366602969-26187-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks Good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Sun, Apr 21, 2013 at 11:56:09PM -0400, Theodore Ts'o wrote:
> The ext2fs_read_inode_full() function should not use fs->read_inode()
> if the caller has requested more than the base 128 byte inode
> structure and the inode size is greater than 128 bytes.  Otherwise the
> caller won't get all of the bytes that they were asking for, since
> there's no way for the fs->read_inode override function can know what
> the size of the buffer passed to ext2fs_read_inode_full().
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
> index 77fc447..fd72d4c 100644
> --- a/lib/ext2fs/inode.c
> +++ b/lib/ext2fs/inode.c
> @@ -533,7 +533,9 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
>  	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
>  
>  	/* Check to see if user has an override function */
> -	if (fs->read_inode) {
> +	if (fs->read_inode &&
> +	    ((bufsize == sizeof(struct ext2_inode)) ||
> +	     (EXT2_INODE_SIZE(fs->super) == sizeof(struct ext2_inode)))) {
>  		retval = (fs->read_inode)(fs, ino, inode);
>  		if (retval != EXT2_ET_CALLBACK_NOTHANDLED)
>  			return retval;
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
