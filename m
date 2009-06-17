From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: write only core inode in update_path()
Date: Wed, 17 Jun 2009 11:35:37 -0400
Message-ID: <20090617153537.GB25451@mit.edu>
References: <4A381EC8.4010202@redhat.com> <4A383F97.1080002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZFQPfh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 11:35:37 -0400
Content-Disposition: inline
In-Reply-To: <4A383F97.1080002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 16, 2009 at 07:57:59PM -0500, Eric Sandeen wrote:
> libext2fs: write only core inode in update_path()
> 
> The ext2_extent_handle only has a struct ext2_inode allocated on
> it, and the same amount copied into it in that same function, 
> but in update_path() we're possibly writing out more than that - 
> for example 256 bytes, from that address.  This causes uninitialized 
> memory to get  written to disk, overwriting the parts of the 
> inode past the osd2 member (the end of the smaller structure).

Oh, I see.  The bug was introduced by commit 84b239ae 


    libext2fs: add ext2fs_extent_open2
    
    The patch below adds a function, ext2fs_extent_open2(), that behaves
    as ext2fs_extent_open(), but will use the user-supplied inode
    structure when opening an extent instead of reading the inode from
    disk.  It also changes several of the calls to extent_open() to use
    this enhancement.
    
    Signed-off-by: Nic Case <number9652@yahoo.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Which replaced ext2fs_read_inode_full with ext2fs_read_inode(); which
is fine, extents.c doesn't need to use the full inode; but it didn't
change ext2fs_write_inode_full() with ext2fs_write_inode().

> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index b7eb617..0dfee62 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -547,7 +547,7 @@ static errcode_t update_path(ext2_extent_handle_t handle)
>  
>  	if (handle->level == 0) {
>  		retval = ext2fs_write_inode_full(handle->fs, handle->ino,
> -			   handle->inode, EXT2_INODE_SIZE(handle->fs->super));
> +			   handle->inode, sizeof(struct ext2_inode));

Probably it would be better/simpler to replace this with:

		retval = ext2fs_write_inode(handle->fs, handle->ino,
					    handle->inode);

							- Ted
