From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-01.diff>
Date: Sun, 18 Mar 2007 09:55:23 -0400
Message-ID: <20070318135523.GA14519@thunk.org>
References: <200702100208.l1A28GC2005813@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33388 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXCRNzf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2007 09:55:35 -0400
Content-Disposition: inline
In-Reply-To: <200702100208.l1A28GC2005813@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 09, 2007 at 06:08:16PM -0800, Brian D. Behlendorf wrote:
> Found 2 of the three places where a return code for ext2fs_write_inode() was
> not being checked.
> 
> 
> Index: e2fsprogs+chaos/resize/resize2fs.c
> ===================================================================
> --- e2fsprogs+chaos.orig/resize/resize2fs.c
> +++ e2fsprogs+chaos/resize/resize2fs.c
> @@ -1303,7 +1303,9 @@ static int check_and_change_inodes(ext2_
>  	retval = ext2fs_read_inode(is->rfs->old_fs, dir, &inode);
>  	if (retval == 0) {
>  		inode.i_mtime = inode.i_ctime = time(0);
> -		ext2fs_write_inode(is->rfs->old_fs, dir, &inode);
> +		retval = ext2fs_write_inode(is->rfs->old_fs, dir, &inode);
> +		if (retval)
> +			return DIRENT_ERROR;
>  	}

The new lines should read:

	is->err = ext2fs_write_inode(...)
	if (is->err)
		return DIRENT_ABORT

I'll fix up the patch before committing.

> Index: e2fsprogs+chaos/e2fsck/emptydir.c
> ===================================================================
> --- e2fsprogs+chaos.orig/e2fsck/emptydir.c


n.b. emptydir.c is the ultimate in dead code.  It was some code that I
never finished, and it's not linked into e2fsck at all (emptydir.c/o
is not mentioned in the Makefile at all :-).

						- Ted
