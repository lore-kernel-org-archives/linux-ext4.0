From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext2fs_block_iterate() on fast symlink
Date: Thu, 21 Jun 2007 03:33:43 -0600
Message-ID: <20070621093343.GO5181@schatzie.adilger.int>
References: <20070620125653.GG27218@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50256 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbXFUJdq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 05:33:46 -0400
Content-Disposition: inline
In-Reply-To: <20070620125653.GG27218@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 20, 2007  14:56 +0200, Jan Kara wrote:
>   when  ext2fs_block_iterate() is called on a fast symlink (and I assume
> device inodes would be no different), then random things happen - the
> problem is ext2fs_block_iterate() just blindly takes portions of the inode
> and treats them as block numbers. Now I agree that garbage went in (it
> makes no sence to call this function on such inode) so garbage results but
> maybe it would be nicer to handle it more gracefully. Attached patch should
> do it.

> --- a/lib/ext2fs/inode.c	2007-06-20 13:55:52.000000000 +0200
> +++ b/lib/ext2fs/inode.c	2007-06-20 14:11:15.000000000 +0200
> @@ -771,6 +771,10 @@ errcode_t ext2fs_get_blocks(ext2_filsys 
>  	retval = ext2fs_read_inode(fs, ino, &inode);
>  	if (retval)
>  		return retval;
> +	if (LINUX_S_ISCHR(inode.i_mode) || LINUX_S_ISBLK(inode.i_mode) ||
> +	    (LINUX_S_ISLNK(inode.i_mode) &&
> +	     ext2fs_inode_data_blocks(fs, &inode) == 0))
> +		return EXT2_ET_INVAL_INODE_TYPE;

I would prefer that we NOT continue to make fast symlinks conditional upon
the i_blocks count.  That causes problems if e.g. an EA block is present
(that would cause this blocks == 0 test to incorrectly fail), and may making
the check (blocks - !!i_file_acl) can still fail for other reasons where a
block is added to an inode (e.g. if we have larger EAs, etc).

I'd prefer to make this check "i_size < sizeof(i_block)" or similar, which
has always been true for fast symlinks, for every kernel that I have ever
seen.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
