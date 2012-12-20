From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] lib/ext2fs: Add ext2fs_symlink
Date: Thu, 20 Dec 2012 13:51:54 -0800
Message-ID: <20121220215154.GB10770@blackbox.djwong.org>
References: <ff54dc35c816ae53f149f2f032c12147deac8508.1355971726.git.dvhart@infradead.org>
 <40709903834127afbb1f6eda82cf50c292b3f97c.1355971726.git.dvhart@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	sgw@linux.intel.com
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2LTVwG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Dec 2012 16:52:06 -0500
Content-Disposition: inline
In-Reply-To: <40709903834127afbb1f6eda82cf50c292b3f97c.1355971726.git.dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 19, 2012 at 06:49:22PM -0800, Darren Hart wrote:
> Creating symlinks is a complex affair when accounting for slowlinks.
> 
> Create a new function, ext2fs_symlink(), modeled after ext2fs_mkdir()
> with input from debugfs's do_write() and copy_file(). Like
> ext2fs_mkdir(), ext2fs_symlink() takes on the task of allocating a new
> inode, setting up sane default values in the inode, accounting for the
> inode stats, and copying the target path to either the inode (for
> fastlinks) or to the blocks/extents (for slowlinks) using
> ext2fs_file_write().
> 
> It does not attempt to expand the parent directory, instead returning
> EXT2_ET_DIR_NO_SPACE and leaving it to the caller to expand just as
> ext2fs_mkdir() does. Ideally, I think both of these functions should
> make a single attempt to expand the directory.
> 
> Adds 1556 bytes to libext2fs.a (stripped).
> 
> Signed-off-by: Darren Hart <dvhart@infradead.org>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@dilger.ca>
> ---
>  lib/ext2fs/Makefile.in    |   8 +++
>  lib/ext2fs/ext2_err.et.in |   3 +
>  lib/ext2fs/symlink.c      | 137 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 148 insertions(+)
>  create mode 100644 lib/ext2fs/symlink.c
> 
> diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> index e05b438..5411826 100644
> --- a/lib/ext2fs/Makefile.in
> +++ b/lib/ext2fs/Makefile.in
> @@ -80,6 +80,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
>  	res_gdt.o \
>  	rw_bitmaps.o \
>  	swapfs.o \
> +	symlink.o \
>  	tdb.o \
>  	undo_io.o \
>  	unix_io.o \
> @@ -155,6 +156,7 @@ SRCS= ext2_err.c \
>  	$(srcdir)/res_gdt.c \
>  	$(srcdir)/rw_bitmaps.c \
>  	$(srcdir)/swapfs.c \
> +	$(srcdir)/symlink.c \
>  	$(srcdir)/tdb.c \
>  	$(srcdir)/test_io.c \
>  	$(srcdir)/tst_badblocks.c \
> @@ -881,6 +883,12 @@ swapfs.o: $(srcdir)/swapfs.c $(top_builddir)/lib/config.h \
>   $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
>   $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
>   $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
> +symlink.o: $(srcdir)/symlink.c $(top_builddir)/lib/config.h \
> + $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
> + $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
> + $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> + $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> + $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
>  tdb.o: $(srcdir)/tdb.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(srcdir)/tdb.h
>  test_io.o: $(srcdir)/test_io.c $(top_builddir)/lib/config.h \
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index c99a167..e1313a8 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -248,6 +248,9 @@ ec	EXT2_ET_DB_NOT_FOUND,
>  ec	EXT2_ET_DIR_EXISTS,
>  	"Ext2 directory already exists"
>  
> +ec	EXT2_ET_FILE_EXISTS,
> +	"Ext2 file already exists"
> +
>  ec	EXT2_ET_UNIMPLEMENTED,
>  	"Unimplemented ext2 library function"
>  
> diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
> new file mode 100644
> index 0000000..5bfb9fc
> --- /dev/null
> +++ b/lib/ext2fs/symlink.c
> @@ -0,0 +1,137 @@
> +/*
> + * symlink.c --- make a symlink in the filesystem, based on mkdir.c
> + *
> + * Copyright (c) 2012, Intel Corporation.
> + * All Rights Reserved.
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Library
> + * General Public License, version 2.
> + * %End-Header%
> + */
> +
> +#include "config.h"
> +#include <stdio.h>
> +#include <string.h>
> +#if HAVE_UNISTD_H
> +#include <unistd.h>
> +#endif
> +#include <fcntl.h>
> +#include <time.h>
> +#if HAVE_SYS_STAT_H
> +#include <sys/stat.h>
> +#endif
> +#if HAVE_SYS_TYPES_H
> +#include <sys/types.h>
> +#endif
> +
> +#include "ext2_fs.h"
> +#include "ext2fs.h"
> +
> +#ifndef EXT2_FT_SYMLINK
> +#define EXT2_FT_SYMLINK		7
> +#endif

Is this ever /not/ defined?  ext2_fs.h should always define this, right?

> +
> +errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
> +                         const char *name, char *target)
> +{
> +	ext2_extent_handle_t	handle;
> +	errcode_t		retval;
> +	struct ext2_inode	inode;
> +	ext2_ino_t		scratch_ino;
> +	int			fastlink;
> +	int			target_len;
> +
> +	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> +
> +	/*
> +	 * Allocate an inode, if necessary
> +	 */
> +	if (!ino) {
> +		retval = ext2fs_new_inode(fs, parent, LINUX_S_IFLNK | 0755,
> +		                          0, &ino);
> +		if (retval)
> +			goto cleanup;
> +	}
> +
> +	/*
> +	 * Link the symlink into the filesystem hierarchy
> +	 */
> +	retval = ext2fs_lookup(fs, parent, name, strlen(name), 0,
> +	                       &scratch_ino);
> +	if (!retval) {
> +		retval = EXT2_ET_FILE_EXISTS;
> +		goto cleanup;
> +	}
> +	if (retval != EXT2_ET_FILE_NOT_FOUND)
> +		goto cleanup;
> +	retval = ext2fs_link(fs, parent, name, ino, EXT2_FT_SYMLINK);
> +	if (retval)
> +		goto cleanup;
> +
> +	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);

You know, I've always wondered about why there are unary plus scattered
throughout calls to this function in e2fsprogs.

> +	/*
> +	 * Create the inode structure....
> +	 */
> +	memset(&inode, 0, sizeof(struct ext2_inode));
> +	inode.i_mode = LINUX_S_IFLNK | 0777;
> +	inode.i_uid = inode.i_gid = 0;
> +	/* FIXME: set the time fields */

Are you going to fix this? :)

> +	inode.i_links_count = 1;
> +
> +	target_len = strlen(target);
> +	fastlink = (target_len < sizeof(inode.i_block));
> +	if (fastlink) {
> +		/* Fast symlinks, target stored in inode */
> +		inode.i_size = target_len;
> +		strcpy((char *)&inode.i_block, target);
> +	} else {
> +		if (retval)
> +			goto cleanup;
> +
> +		if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
> +			inode.i_flags |= EXT4_EXTENTS_FL;
> +
> +		inode.i_size = (target_len % fs->blocksize) ?
> +		               target_len + (fs->blocksize - target_len) : target_len;

Shouldn't this just be i_size = target_len?

$ ln -s "$(perl -e 'print "x" x 4000;')" cow

...nets me a symlink with a reported length of 4000.

Come to think of it, ext4 (kernel) doesn't seem to allow slow symlinks to have
a target longer than $blocksize.  I suspect that might be a side effect of
blocksize <= pagesize, and therefore we allocate at most a page's worth to read
the target into.

Either way, we probably ought to check.

Also, I think the VFS errors out if you try to pass '' as the target, so
perhaps we ought to look for that.

I think the rest looks more or less ok, barring the 80 char overflows that I
think is happening on the ext2fs_file_write line.

--D

> +	}
> +
> +	/*
> +	 * Write out the inode and inode data block.  The inode generation
> +	 * number is assigned by write_new_inode, which means that the file
> +	 * operations below should come after it.
> +	 */
> +	retval = ext2fs_write_new_inode(fs, ino, &inode);
> +	if (retval)
> +		goto cleanup;
> +
> +	/*
> +	 * For slow links, the target path is written to the blocks/extents
> +	 */
> +	if (!fastlink) {
> +		ext2_extent_handle_t handle;
> +		ext2_file_t file;
> +		int written = 0;
> +		char *rem;
> +
> +		/* Write the target to file */
> +		retval = ext2fs_file_open2(fs, ino, &inode,
> +		                           EXT2_FILE_CREATE | EXT2_FILE_WRITE,
> +		                           &file);
> +		if (retval)
> +			goto cleanup;
> +
> +		rem = target;
> +		while (strlen(rem)) {
> +			retval = ext2fs_file_write(file, (void *)rem, strlen(rem), &written);
> +			rem += written;
> +			if (retval)
> +				break;
> +		}
> +		ext2fs_file_close(file);
> +	}
> +
> +cleanup:
> +	return retval;
> +}
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
