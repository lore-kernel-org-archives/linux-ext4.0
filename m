From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] allow tune2fs to set/clear resize_inode
Date: Tue, 6 Nov 2007 09:12:55 +0800
Message-ID: <20071106011255.GB3900@webber.adilger.int>
References: <472F80F5.3030608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:38671 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbXKFBNL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 20:13:11 -0500
Content-Disposition: inline
In-Reply-To: <472F80F5.3030608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 05, 2007  14:45 -0600, Eric Sandeen wrote:
> (this patch has been carried in Red Hat / Fedora rpms for a while, not 
> sure why it never got sent upstream... clearing this allows for mounting 
> filesystems with a resize_inode on older systems)
>
> Allow tune2fs to set & clear resize_inode; requires fsck afterwards.

Two things that are a bit confusing:
- since RESIZE_INODE is a COMPAT feature, I don't see how this affects
  mounting the filesystem on older systems?  Is there a bug somewhere?
- why not use something like remove_journal_inode() (or create a new
  helper function like ext2fs_unlink(), and move the kill_file_by_inode()
  and release_blocks_proc() into lib/ext2fs as ext2fs_delete_inode())
  to avoid the need for an e2fsck?

>  	if ((sparse != old_sparse) ||
> -	    (filetype != old_filetype)) {
> +	    (filetype != old_filetype) ||
> +	    (resize_inode != old_resize_inode)) {
>  		sb->s_state &= ~EXT2_VALID_FS;
>  		printf("\n%s\n", _(please_fsck));
>  	}

I don't know that it is so easy to enable RESIZE_INODE on an existing
filesystem as just setting the feature flag and running e2fsck?  The
reserved group descriptor blocks will potentially conflict with the
bitmaps and inode tables.

What is needed is an ext2prepare-like step that involves resize2fs code
to move the file/dir blocks and then the move inode table, as if the
filesystem were going to be resized to the new maximum resize limit,
and then create the resize inode but do not actually add new blocks/groups
at the end of the filesystem.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
