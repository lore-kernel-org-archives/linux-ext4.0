From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Sat, 29 Aug 2009 22:52:50 -0400
Message-ID: <20090830025250.GA25768@mit.edu>
References: <1248366422.27509.1.camel@bobble.smo.corp.google.com> <4A689723.7000805@redhat.com> <1248372301.31323.2.camel@bobble.smo.corp.google.com> <20090723215614.GF4231@webber.adilger.int> <1248389165.17459.3.camel@bobble.smo.corp.google.com> <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com> <20090828194051.GM4197@webber.adilger.int> <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com> <20090828221432.GS4197@webber.adilger.int> <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47321 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZH3Cwy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Aug 2009 22:52:54 -0400
Content-Disposition: inline
In-Reply-To: <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 28, 2009 at 05:40:54PM -0700, Jiaying Zhang wrote:
> --- .pc/fallocate_keepsizse.patch/fs/attr.c	2009-08-28 15:38:46.000000000 -0700
> +++ fs/attr.c	2009-08-28 17:01:04.000000000 -0700
> @@ -68,7 +68,8 @@ int inode_setattr(struct inode * inode,
>  	unsigned int ia_valid = attr->ia_valid;
> 
>  	if (ia_valid & ATTR_SIZE &&
> -	    (attr->ia_size != i_size_read(inode)) {
> +	    (attr->ia_size != i_size_read(inode) ||
> +	     (inode->i_flags & FS_KEEPSIZE_FL))) {
>  		int error = vmtruncate(inode, attr->ia_size);
>  		if (error)
>  			return error;

Instead of doing this in the generic code, it really should be done in
ext4_setattr.  Technically speaking, we don't actually need the
FS_KEEPSIZE_FL to solve this problem; instead we can simply have the
ext4 code look in the extent tree to see if there are any blocks
mapped beyond the logical block:

       i_size_read(inode) >> inode->i_sb->s_blocksize_bits

Having a flag as Andreas suggested does help with the issue of e2fsck
noticing whether or not i_size is incorrect (and should be fixed) or
the file has been extended.  So keeping having the flag is an OK thing
to do, but we need to be careful about a particularly subtle
overloading problem.  The flags FS_*_FL as defined in
include/linux/fs.h are technically only for in-memory use.  The ext4
on-disk format flags is EXT4_*_FL, and defined in ext4.h.

The flags were originially defined for use in ext2/3/4, but later on
other filesystems adopted those flags so that e2fsprogs's chattr and
lsattr programs could be used for their filesystems as well.  It just
so happens that for ext2/3/4 the on-disk encoding of those flags in
the in-memory encoding of those flags in i_flags are the same, but
that means that the flags need to be defined in both places to avoid
assignment overlaps.  We also need to be clear whether the flags are
internal flags for ext4's use only, or flags meant for use by all
filesystems.  This is why the testing for FS_KEEPSIZE_FL in fs/attr is
particularly bad, if the flag are going to be set in fs/ext4/extents.c.

It's better to define the flag as EXT4_KEEPSIZE_FL, and to use it as
EXT4_KEEPSIZE_FL, but make a note of that bitfield position as being
reserved in include/linux/fs.h.

							- Ted
