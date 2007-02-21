From: Peter Staubach <staubach@redhat.com>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Wed, 21 Feb 2007 09:49:35 -0500
Message-ID: <45DC5BFF.4000302@redhat.com>
References: <1172049359.4727.15.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Lustre-discuss <Lustre-discuss@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXBUOuI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Feb 2007 09:50:08 -0500
In-Reply-To: <1172049359.4727.15.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kalpak Shah wrote:
> Hi,
>
> If the mode of a directory gets corrupted, check_filetype() makes wrong decisions for all its sub-directories. For example, using debugfs we can corrupt the mode of a directory to 0140755 (i.e. a socket). e2fsck will set the filetype of all its subdirectories as 6 (filetype for socket). All the subdirectories would be moved to lost+found, and in second run of e2fsck their filetype would be set back to 2.
>
> By the time we come to check_filetype(), we have already verified the "." and ".." entries, so we special case these dirents in check_filetype().
>
> Please consider for review.
>
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
>
>
> Index: e2fsprogs-1.39/e2fsck/pass2.c
> ===================================================================
> --- e2fsprogs-1.39.orig/e2fsck/pass2.c
> +++ e2fsprogs-1.39/e2fsck/pass2.c
> @@ -495,7 +495,9 @@ static _INLINE_ int check_filetype(e2fsc
>                 return 1;
>         }
>
> -       if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode)) {
> +       if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode) ||
> +           ((dirent->name_len && 0xFF) <= 2 && dirent->name[0] == '.' &&
>   

What is the "&& 0xFF" part for?  At the very least, it should probably
be "& 0xFF".  It doesn't seem like this mask should be needed at all
though, I think.

    Thanx...

       ps

> +            (dirent->name[1] == '.' || dirent->name[1] == '\0'))) {
>                 should_be = EXT2_FT_DIR;
>         } else if (ext2fs_test_inode_bitmap(ctx->inode_reg_map,
>                                             dirent->inode)) {
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
