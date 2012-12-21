From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] lib/ext2fs: Add ext2fs_symlink
Date: Fri, 21 Dec 2012 13:11:18 -0800
Message-ID: <20121221211118.GC4878@blackbox.djwong.org>
References: <ff54dc35c816ae53f149f2f032c12147deac8508.1355971726.git.dvhart@infradead.org>
 <40709903834127afbb1f6eda82cf50c292b3f97c.1355971726.git.dvhart@infradead.org>
 <20121220215154.GB10770@blackbox.djwong.org>
 <50D4984F.2000909@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	sgw@linux.intel.com
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48582 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2LUVL3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Dec 2012 16:11:29 -0500
Content-Disposition: inline
In-Reply-To: <50D4984F.2000909@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2012 at 09:11:43AM -0800, Darren Hart wrote:
> Hi Darrick!

:D

> On 12/20/2012 01:51 PM, Darrick J. Wong wrote:
> > On Wed, Dec 19, 2012 at 06:49:22PM -0800, Darren Hart wrote:
> >> Creating symlinks is a complex affair when accounting for slowlinks.
> >>
> >> Create a new function, ext2fs_symlink(), modeled after ext2fs_mkdir()
> >> with input from debugfs's do_write() and copy_file(). Like
> >> ext2fs_mkdir(), ext2fs_symlink() takes on the task of allocating a new
> >> inode, setting up sane default values in the inode, accounting for the
> >> inode stats, and copying the target path to either the inode (for
> >> fastlinks) or to the blocks/extents (for slowlinks) using
> >> ext2fs_file_write().
> >>
> >> It does not attempt to expand the parent directory, instead returning
> >> EXT2_ET_DIR_NO_SPACE and leaving it to the caller to expand just as
> >> ext2fs_mkdir() does. Ideally, I think both of these functions should
> >> make a single attempt to expand the directory.
> >>
> >> Adds 1556 bytes to libext2fs.a (stripped).
> >>
> >> Signed-off-by: Darren Hart <dvhart@infradead.org>
> >> Cc: "Theodore Ts'o" <tytso@mit.edu>
> >> Cc: Andreas Dilger <adilger@dilger.ca>
> >> ---
> >>  lib/ext2fs/Makefile.in    |   8 +++
> >>  lib/ext2fs/ext2_err.et.in |   3 +
> >>  lib/ext2fs/symlink.c      | 137 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 148 insertions(+)
> >>  create mode 100644 lib/ext2fs/symlink.c
> >>
> >> diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> >> index e05b438..5411826 100644
> >> --- a/lib/ext2fs/Makefile.in
> >> +++ b/lib/ext2fs/Makefile.in
> >> @@ -80,6 +80,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
> >>  	res_gdt.o \
> >>  	rw_bitmaps.o \
> >>  	swapfs.o \
> >> +	symlink.o \
> >>  	tdb.o \
> >>  	undo_io.o \
> >>  	unix_io.o \
> >> @@ -155,6 +156,7 @@ SRCS= ext2_err.c \
> >>  	$(srcdir)/res_gdt.c \
> >>  	$(srcdir)/rw_bitmaps.c \
> >>  	$(srcdir)/swapfs.c \
> >> +	$(srcdir)/symlink.c \
> >>  	$(srcdir)/tdb.c \
> >>  	$(srcdir)/test_io.c \
> >>  	$(srcdir)/tst_badblocks.c \
> >> @@ -881,6 +883,12 @@ swapfs.o: $(srcdir)/swapfs.c $(top_builddir)/lib/config.h \
> >>   $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> >>   $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> >>   $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
> >> +symlink.o: $(srcdir)/symlink.c $(top_builddir)/lib/config.h \
> >> + $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
> >> + $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
> >> + $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> >> + $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> >> + $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
> >>  tdb.o: $(srcdir)/tdb.c $(top_builddir)/lib/config.h \
> >>   $(top_builddir)/lib/dirpaths.h $(srcdir)/tdb.h
> >>  test_io.o: $(srcdir)/test_io.c $(top_builddir)/lib/config.h \
> >> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> >> index c99a167..e1313a8 100644
> >> --- a/lib/ext2fs/ext2_err.et.in
> >> +++ b/lib/ext2fs/ext2_err.et.in
> >> @@ -248,6 +248,9 @@ ec	EXT2_ET_DB_NOT_FOUND,
> >>  ec	EXT2_ET_DIR_EXISTS,
> >>  	"Ext2 directory already exists"
> >>  
> >> +ec	EXT2_ET_FILE_EXISTS,
> >> +	"Ext2 file already exists"
> >> +
> >>  ec	EXT2_ET_UNIMPLEMENTED,
> >>  	"Unimplemented ext2 library function"
> >>  
> >> diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
> >> new file mode 100644
> >> index 0000000..5bfb9fc
> >> --- /dev/null
> >> +++ b/lib/ext2fs/symlink.c
> >> @@ -0,0 +1,137 @@
> >> +/*
> >> + * symlink.c --- make a symlink in the filesystem, based on mkdir.c
> >> + *
> >> + * Copyright (c) 2012, Intel Corporation.
> >> + * All Rights Reserved.
> >> + *
> >> + * %Begin-Header%
> >> + * This file may be redistributed under the terms of the GNU Library
> >> + * General Public License, version 2.
> >> + * %End-Header%
> >> + */
> >> +
> >> +#include "config.h"
> >> +#include <stdio.h>
> >> +#include <string.h>
> >> +#if HAVE_UNISTD_H
> >> +#include <unistd.h>
> >> +#endif
> >> +#include <fcntl.h>
> >> +#include <time.h>
> >> +#if HAVE_SYS_STAT_H
> >> +#include <sys/stat.h>
> >> +#endif
> >> +#if HAVE_SYS_TYPES_H
> >> +#include <sys/types.h>
> >> +#endif
> >> +
> >> +#include "ext2_fs.h"
> >> +#include "ext2fs.h"
> >> +
> >> +#ifndef EXT2_FT_SYMLINK
> >> +#define EXT2_FT_SYMLINK		7
> >> +#endif
> > 
> > Is this ever /not/ defined?  ext2_fs.h should always define this, right?
> 
> 
> I thought the same thing, but I'm following convention here from mkdir.c.

<shrug> Was hoping Ted or anyone else could comment on this and the next bit...
> 
> 
> >> +
> >> +errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
> >> +                         const char *name, char *target)
> >> +{
> >> +	ext2_extent_handle_t	handle;
> >> +	errcode_t		retval;
> >> +	struct ext2_inode	inode;
> >> +	ext2_ino_t		scratch_ino;
> >> +	int			fastlink;
> >> +	int			target_len;
> >> +
> >> +	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> >> +
> >> +	/*
> >> +	 * Allocate an inode, if necessary
> >> +	 */
> >> +	if (!ino) {
> >> +		retval = ext2fs_new_inode(fs, parent, LINUX_S_IFLNK | 0755,
> >> +		                          0, &ino);
> >> +		if (retval)
> >> +			goto cleanup;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Link the symlink into the filesystem hierarchy
> >> +	 */
> >> +	retval = ext2fs_lookup(fs, parent, name, strlen(name), 0,
> >> +	                       &scratch_ino);
> >> +	if (!retval) {
> >> +		retval = EXT2_ET_FILE_EXISTS;
> >> +		goto cleanup;
> >> +	}
> >> +	if (retval != EXT2_ET_FILE_NOT_FOUND)
> >> +		goto cleanup;
> >> +	retval = ext2fs_link(fs, parent, name, ino, EXT2_FT_SYMLINK);
> >> +	if (retval)
> >> +		goto cleanup;
> >> +
> >> +	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
> > 
> > You know, I've always wondered about why there are unary plus scattered
> > throughout calls to this function in e2fsprogs.
> 
> 
> Me too :-) Again, just following convention.
> 
> 
> >> +	/*
> >> +	 * Create the inode structure....
> >> +	 */
> >> +	memset(&inode, 0, sizeof(struct ext2_inode));
> >> +	inode.i_mode = LINUX_S_IFLNK | 0777;
> >> +	inode.i_uid = inode.i_gid = 0;
> >> +	/* FIXME: set the time fields */
> > 
> > Are you going to fix this? :)
> 
> 
> It is an open question as to what they should be initialized to. Should
> the current time be used? Should a fixed time be used for all of a
> debugfs (or similar) session? This strikes me as a policy decision which
> I was hoping to leave to the maintainers to dictate (at which point I
> would implement it).

ext2fs_write_new_inode sets atime = ctime = mtime = now() if you don't
otherwise set them.  If that's ok with you (I'm having trouble grokking why
you'd want to set all the symlink times to a fixed value...) then you could
just remove the comment.

> >> +	inode.i_links_count = 1;
> >> +
> >> +	target_len = strlen(target);
> >> +	fastlink = (target_len < sizeof(inode.i_block));
> >> +	if (fastlink) {
> >> +		/* Fast symlinks, target stored in inode */
> >> +		inode.i_size = target_len;
> >> +		strcpy((char *)&inode.i_block, target);
> >> +	} else {
> >> +		if (retval)
> >> +			goto cleanup;
> >> +
> >> +		if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
> >> +			inode.i_flags |= EXT4_EXTENTS_FL;
> >> +
> >> +		inode.i_size = (target_len % fs->blocksize) ?
> >> +		               target_len + (fs->blocksize - target_len) : target_len;
> > 
> > Shouldn't this just be i_size = target_len?
> 
> 
> Hrm... I thought it had to be block, but I can't remember where I got
> that notion from. I confirmed with your example and a few others, that
> target_len is indeed correct. Nice, I hated that parameterized integer
> ceiling function anyway :-)

Directory files have lengths that must be strict multiples of $blocksize,
because the driver writes (empty) directory entries all the way to the end of
each block.  As far as I know nothing else has that requirement.

> > 
> > $ ln -s "$(perl -e 'print "x" x 4000;')" cow
> > 
> > ...nets me a symlink with a reported length of 4000.
> > 
> > Come to think of it, ext4 (kernel) doesn't seem to allow slow symlinks to have
> > a target longer than $blocksize.  I suspect that might be a side effect of
> > blocksize <= pagesize, and therefore we allocate at most a page's worth to read
> > the target into.
> > 
> > Either way, we probably ought to check.
> 
> 
> Agreed. I'll give it a closer look.

Yep ... the first code stanza of ext4_symlink in fs/ext4/namei.c does indeed
enforce that.

> 
> > Also, I think the VFS errors out if you try to pass '' as the target, so
> > perhaps we ought to look for that.
> 
> 
> Will do.
> 
> 
> > I think the rest looks more or less ok, barring the 80 char overflows that I
> > think is happening on the ext2fs_file_write line.
> 
> 
> I'm happy to enforce 80 chars if that is the preferred coding style.
> There were many instances where the existing code went beyond 80, so I
> wasn't sure what was preferred and was trying my best to follow convention.

There's still quite a bit of old code in e2fsprogs that don't seem to follow
any conventions.  I'm not sure which conventions Ted wants for e2fsprogs, but
so far I haven't gotten any resistance from using kernel coding style.

> 
> I'm away with family until the new year, so my V2 will come in early
> January, but I'll be able to respond to discussions here.
> 
> Thanks for taking the time to review Darrick!

np!

--D
> 
> --
> Darren
> 
> > 
> > --D
> > 
> >> +	}
> >> +
> >> +	/*
> >> +	 * Write out the inode and inode data block.  The inode generation
> >> +	 * number is assigned by write_new_inode, which means that the file
> >> +	 * operations below should come after it.
> >> +	 */
> >> +	retval = ext2fs_write_new_inode(fs, ino, &inode);
> >> +	if (retval)
> >> +		goto cleanup;
> >> +
> >> +	/*
> >> +	 * For slow links, the target path is written to the blocks/extents
> >> +	 */
> >> +	if (!fastlink) {
> >> +		ext2_extent_handle_t handle;
> >> +		ext2_file_t file;
> >> +		int written = 0;
> >> +		char *rem;
> >> +
> >> +		/* Write the target to file */
> >> +		retval = ext2fs_file_open2(fs, ino, &inode,
> >> +		                           EXT2_FILE_CREATE | EXT2_FILE_WRITE,
> >> +		                           &file);
> >> +		if (retval)
> >> +			goto cleanup;
> >> +
> >> +		rem = target;
> >> +		while (strlen(rem)) {
> >> +			retval = ext2fs_file_write(file, (void *)rem, strlen(rem), &written);
> >> +			rem += written;
> >> +			if (retval)
> >> +				break;
> >> +		}
> >> +		ext2fs_file_close(file);
> >> +	}
> >> +
> >> +cleanup:
> >> +	return retval;
> >> +}
> >> -- 
> >> 1.7.11.7
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
