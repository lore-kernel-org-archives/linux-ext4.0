From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext2fs_block_iterate (e2, EXT2_RESIZE_INO, ...) =>
 EXT2_ET_FILE_TOO_BIG?
Date: Wed, 31 Aug 2011 11:22:07 -0400
Message-ID: <20110831152207.GB32582@thunk.org>
References: <867h5tdf9o.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52401 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1HaPWJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 11:22:09 -0400
Content-Disposition: inline
In-Reply-To: <867h5tdf9o.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 05:52:35PM +0700, Ivan Shmakov wrote:
> 	Curiosly enough, ext2fs_block_iterate () returns
> 	EXT2FS_BLOCK_ITERATE for EXT2_RESIZE_INO (the binary in question
> 	is statically linked against libext2fs, 1.41.12 debian 2):
> 
> (gdb) print ext2fs_block_iterate (e2, ino, 0, 0, db_add_block, (void *)sp)
> $13 = 2133571410
> (gdb) 
> 
> 	Is it because the blocks belonging to this inode aren't supposed
> 	to belong to the filesystem itself, I wonder?

It returned the error EXT2_ET_FILE_TOO_BIG.  From ext2_err.h, which
you can get from the build tree of e2fsprogs, in lib/ext2fs/ext2_err.h
(generated from lib/ext2fs/ext2_err.et):

#define EXT2_ET_FILE_TOO_BIG                     (2133571410L)

Yeah, the resize inode is a special case.  It is specially constructed
to reserve space for new block group descriptor blocks when doing an
online resize.  I would suggest for your purposes that you _not_
support the online-resizable file system feature, as it's unneeded
complexity (from what I understand of what you're going to be doing
with the file system).

Regards,

							- Ted

P.S. The code to create the reserved inode can be found in
lib/ext2fs/res_gdt.c, in ext2fs_create_resize_inode().
