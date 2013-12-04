From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 09/28] libext2fs: handle inline data in dir iterator
 function
Date: Tue, 3 Dec 2013 21:10:25 -0800
Message-ID: <20131204051025.GF9541@birch.djwong.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-10-git-send-email-wenqing.lz@taobao.com>
 <20131203221349.GF9535@birch.djwong.org>
 <20131204045736.GF20409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49133 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3LDFKe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Dec 2013 00:10:34 -0500
Content-Disposition: inline
In-Reply-To: <20131204045736.GF20409@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 04, 2013 at 12:57:36PM +0800, Zheng Liu wrote:
> On Tue, Dec 03, 2013 at 02:13:49PM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 03, 2013 at 08:11:36PM +0800, Zheng Liu wrote:
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > Inline_data is handled in dir iterator because a lot of commands use
> > > this function to traverse directory entries in debugfs.  We need to
> > > handle inline_data individually because inline_data is saved in two
> > > places.  One is in i_block, and another is in ibody extended attribute.
> > > 
> > > After applied this commit, the following commands in debugfs can
> > > support the inline_data feature:
> > > 	- cd
> > > 	- chroot
> > > 	- link*
> > > 	- ls
> > > 	- ncheck
> > > 	- pwd
> > > 	- unlink
> > > 
> > > * TODO: Inline_data doesn't expand to ibody extended attribute because
> > >   link command doesn't handle DIR_NO_SPACE error until now.  But if we
> > >   have already expanded inline data to ibody ea area, link command can
> > >   occupy this space.
> > 
> > A patch for this TODO is coming, right?
> 
> TBH, I don't have a patch for this because I don't know why ext2fs_link
> doesn't handle DIR_NO_SPACE error.  So I will try to fix it later.

Yeah, it's sort of annoying that it doesn't do that.  You might notice that
fuse2fs will detect that error code, call ext2fs_expand_dir(), and try again.
On the other hand, none of the other programs do that...

...it's not difficult to change ext2fs_link() to do that, though.

again:

/* link_proc magic... */

if (!ls.done && !not_again) {
	ext2fs_expand_dir(fs, dir...);
	not_again = 1;
	goto again;
}

Hmm.  That /is/ easy to fix.  I might as well fix that.

--D

> 
> > 
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > > ---
> > >  lib/ext2fs/Makefile.in    |    8 +++
> > >  lib/ext2fs/Makefile.pq    |    1 +
> > >  lib/ext2fs/dir_iterate.c  |   62 +++++++++++-----
> > >  lib/ext2fs/ext2_err.et.in |    3 +
> > >  lib/ext2fs/ext2_fs.h      |   10 +++
> > >  lib/ext2fs/ext2fs.h       |    1 +
> > >  lib/ext2fs/ext2fsP.h      |   11 +++
> > >  lib/ext2fs/inline_data.c  |  175 +++++++++++++++++++++++++++++++++++++++++++++
> > >  lib/ext2fs/swapfs.c       |   12 +++-
> > >  9 files changed, 265 insertions(+), 18 deletions(-)
> > >  create mode 100644 lib/ext2fs/inline_data.c
> > > 
> > > diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> > > index e1e6216..4d011c9 100644
> > > --- a/lib/ext2fs/Makefile.in
> > > +++ b/lib/ext2fs/Makefile.in
> > > @@ -59,6 +59,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
> > >  	ind_block.o \
> > >  	initialize.o \
> > >  	inline.o \
> > > +	inline_data.o \
> > >  	inode.o \
> > >  	io_manager.o \
> > >  	ismounted.o \
> > > @@ -133,6 +134,7 @@ SRCS= ext2_err.c \
> > >  	$(srcdir)/ind_block.c \
> > >  	$(srcdir)/initialize.c \
> > >  	$(srcdir)/inline.c \
> > > +	$(srcdir)/inline_data.c	\
> > >  	$(srcdir)/inode.c \
> > >  	$(srcdir)/inode_io.c \
> > >  	$(srcdir)/imager.c \
> > > @@ -758,6 +760,12 @@ inline.o: $(srcdir)/inline.c $(top_builddir)/lib/config.h \
> > >   $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> > >   $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> > >   $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
> > > +inline_data.o: $(srcdir)/inline_data.c $(top_builddir)/lib/config.h \
> > > + $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
> > > + $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
> > > + $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> > > + $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> > > + $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
> > >  inode.o: $(srcdir)/inode.c $(top_builddir)/lib/config.h \
> > >   $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
> > >   $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
> > > diff --git a/lib/ext2fs/Makefile.pq b/lib/ext2fs/Makefile.pq
> > > index 2f7b654..89082a7 100644
> > > --- a/lib/ext2fs/Makefile.pq
> > > +++ b/lib/ext2fs/Makefile.pq
> > > @@ -27,6 +27,7 @@ OBJS= 	alloc.obj \
> > >  	icount.obj \
> > >  	initialize.obj \
> > >  	inline.obj \
> > > +	inline_data.obj \
> > >  	inode.obj \
> > >  	ismounted.obj \
> > >  	link.obj \
> > > diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
> > > index 8be0ac2..1624371 100644
> > > --- a/lib/ext2fs/dir_iterate.c
> > > +++ b/lib/ext2fs/dir_iterate.c
> > > @@ -127,6 +127,12 @@ errcode_t ext2fs_dir_iterate2(ext2_filsys fs,
> > >  				       ext2fs_process_dir_block, &ctx);
> > >  	if (!block_buf)
> > >  		ext2fs_free_mem(&ctx.buf);
> > > +	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE) {
> > > +		ctx.flags |= DIRENT_FLAG_INCLUDE_INLINE_DATA;
> > > +		retval = ext2fs_inline_data_dir_iterate(fs, dir,
> > > +						ext2fs_process_dir_block,
> > > +						&ctx);
> > > +	}
> > >  	if (retval)
> > >  		return retval;
> > >  	return ctx.errcode;
> > > @@ -189,30 +195,40 @@ int ext2fs_process_dir_block(ext2_filsys fs,
> > >  	int		ret = 0;
> > >  	int		changed = 0;
> > >  	int		do_abort = 0;
> > > -	unsigned int	rec_len, size;
> > > +	unsigned int	rec_len, size, buflen;
> > >  	int		entry;
> > >  	struct ext2_dir_entry *dirent;
> > >  	int		csum_size = 0;
> > > +	int		inline_data;
> > > +	errcode_t	retval = 0;
> > >  
> > >  	if (blockcnt < 0)
> > >  		return 0;
> > >  
> > >  	entry = blockcnt ? DIRENT_OTHER_FILE : DIRENT_DOT_FILE;
> > >  
> > > -	ctx->errcode = ext2fs_read_dir_block4(fs, *blocknr, ctx->buf, 0,
> > > -					      ctx->dir);
> > > -	if (ctx->errcode)
> > > -		return BLOCK_ABORT;
> > > +	/* If a dir has inline data, we don't need to read block */
> > > +	inline_data = !!(ctx->flags & DIRENT_FLAG_INCLUDE_INLINE_DATA);
> > > +	if (!inline_data) {
> > > +		ctx->errcode = ext2fs_read_dir_block4(fs, *blocknr, ctx->buf, 0,
> > > +						      ctx->dir);
> > > +		if (ctx->errcode)
> > > +			return BLOCK_ABORT;
> > > +		/* If we handle a normal dir, we traverse the entire block */
> > > +		buflen = fs->blocksize;
> > > +	} else {
> > > +		buflen = ctx->buflen;
> > 
> > Since we don't swap i_block[] when we're reading in the inode, who calls
> > ext2fs_dirent_swab_in()?
> 
> Good catch!  I will call this on ext2fs_inline_data_dir_iterate().
> 
> > 
> > > +	}
> > >  
> > >  	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> > >  					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > >  		csum_size = sizeof(struct ext2_dir_entry_tail);
> > >  
> > > -	while (offset < fs->blocksize) {
> > > +	while (offset < buflen) {
> > >  		dirent = (struct ext2_dir_entry *) (ctx->buf + offset);
> > >  		if (ext2fs_get_rec_len(fs, dirent, &rec_len))
> > >  			return BLOCK_ABORT;
> > > -		if (((offset + rec_len) > fs->blocksize) ||
> > > +		if (((offset + rec_len) > buflen) ||
> > >  		    (rec_len < 8) ||
> > >  		    ((rec_len % 4) != 0) ||
> > >  		    ((ext2fs_dirent_name_len(dirent)+8) > rec_len)) {
> > > @@ -220,7 +236,13 @@ int ext2fs_process_dir_block(ext2_filsys fs,
> > >  			return BLOCK_ABORT;
> > >  		}
> > >  		if (!dirent->inode) {
> > > -			if ((offset == fs->blocksize - csum_size) &&
> > > +			/*
> > > +			 * We just need to check metadata_csum when this
> > > +			 * dir hasn't inline data.  That means that 'buflen'
> > > +			 * should be blocksize.
> > > +			 */
> > > +			if (!inline_data &&
> > > +			    (offset == buflen - csum_size) &&
> > >  			    (dirent->rec_len == csum_size) &&
> > >  			    (dirent->name_len == EXT2_DIR_NAME_LEN_CSUM)) {
> > >  				if (!(ctx->flags & DIRENT_FLAG_INCLUDE_CSUM))
> > > @@ -234,7 +256,7 @@ int ext2fs_process_dir_block(ext2_filsys fs,
> > >  				  (next_real_entry > offset) ?
> > >  				  DIRENT_DELETED_FILE : entry,
> > >  				  dirent, offset,
> > > -				  fs->blocksize, ctx->buf,
> > > +				  buflen, ctx->buf,
> > >  				  ctx->priv_data);
> > >  		if (entry < DIRENT_OTHER_FILE)
> > >  			entry++;
> > > @@ -272,13 +294,21 @@ next:
> > >  	}
> > >  
> > >  	if (changed) {
> > > -		ctx->errcode = ext2fs_write_dir_block4(fs, *blocknr, ctx->buf,
> > > -						       0, ctx->dir);
> > > -		if (ctx->errcode)
> > > -			return BLOCK_ABORT;
> > > +		if (!inline_data) {
> > > +			ctx->errcode = ext2fs_write_dir_block4(fs, *blocknr,
> > > +							       ctx->buf,
> > > +							       0, ctx->dir);
> > > +			if (ctx->errcode)
> > > +				return BLOCK_ABORT;
> > > +		} else {
> > > +			/*
> > > +			 * return BLOCK_CHANGED to notify caller that inline
> > > +			 * data has been changed
> > > +			 */
> > 
> > I don't think I like overloading the meaning of BLOCK_CHANGED here.  For a
> > non-inlinedata file, the iterator function returning BLOCK_CHANGED means that
> > the lblk->pblk mapping changed, whereas for an inline data file, it means that
> > the block *contents* have changed.
> > 
> > At best, the two meanings ought to be documented wherever BLOCK_CHANGED is
> > defined, though I think I'd prefer a new flag BLOCK_INLINE_DATA_CHANGED to
> > handle this situation, because otherwise the meaning of the flag is
> > context-dependent and therefore more difficult to reason about.
> > 
> > Separate flags also gives us the ability to check for programming errors, such
> > as someone returning BLOCK_CHANGED on inlinedata files or returning
> > BLOCK_INLINE_DATA_CHANGED on !inlinedata files.
> 
> Fair enough.
> 
> > 
> > > +			retval = BLOCK_CHANGED;
> > 
> > Who calls ext2fs_dirent_swab_out()?
> 
> Ditto.
> 
> > 
> > > +		}
> > >  	}
> > >  	if (do_abort)
> > > -		return BLOCK_ABORT;
> > > -	return 0;
> > > +		return retval | BLOCK_ABORT;
> > > +	return retval;
> > >  }
> > > -
> > > diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> > > index b819a90..0781145 100644
> > > --- a/lib/ext2fs/ext2_err.et.in
> > > +++ b/lib/ext2fs/ext2_err.et.in
> > > @@ -500,4 +500,7 @@ ec	EXT2_ET_EA_KEY_NOT_FOUND,
> > >  ec	EXT2_ET_EA_NO_SPACE,
> > >  	"Insufficient space to store extended attribute data"
> > >  
> > > +ec	EXT2_ET_NO_INLINE_DATA,
> > > +	"Inode doesn't have inline data"
> > > +
> > >  	end
> > > diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> > > index 6a28d55..5ab16ae 100644
> > > --- a/lib/ext2fs/ext2_fs.h
> > > +++ b/lib/ext2fs/ext2_fs.h
> > > @@ -914,4 +914,14 @@ struct mmp_struct {
> > >   */
> > >  #define EXT4_MMP_MIN_CHECK_INTERVAL     5
> > >  
> > > +/*
> > > + * Minimum size of inline data.
> > > + */
> > > +#define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__u32) * EXT2_N_BLOCKS))
> > > +
> > > +/*
> > > + * Size of a parent inode in inline data directory.
> > > + */
> > > +#define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
> > > +
> > >  #endif	/* _LINUX_EXT2_FS_H */
> > > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > > index e251435..c5b73fd 100644
> > > --- a/lib/ext2fs/ext2fs.h
> > > +++ b/lib/ext2fs/ext2fs.h
> > > @@ -438,6 +438,7 @@ struct ext2_extent_info {
> > >  #define DIRENT_FLAG_INCLUDE_EMPTY	1
> > >  #define DIRENT_FLAG_INCLUDE_REMOVED	2
> > >  #define DIRENT_FLAG_INCLUDE_CSUM	4
> > > +#define DIRENT_FLAG_INCLUDE_INLINE_DATA 8
> > >  
> > >  #define DIRENT_DOT_FILE		1
> > >  #define DIRENT_DOT_DOT_FILE	2
> > > diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> > > index 80d2d0a..5ab6084 100644
> > > --- a/lib/ext2fs/ext2fsP.h
> > > +++ b/lib/ext2fs/ext2fsP.h
> > > @@ -50,6 +50,7 @@ struct dir_context {
> > >  	ext2_ino_t		dir;
> > >  	int		flags;
> > >  	char		*buf;
> > > +	unsigned int	buflen;
> > >  	int (*func)(ext2_ino_t	dir,
> > >  		    int	entry,
> > >  		    struct ext2_dir_entry *dirent,
> > > @@ -87,6 +88,16 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
> > >  				    int			ref_offset,
> > >  				    void		*priv_data);
> > >  
> > > +extern errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
> > > +				      ext2_ino_t ino,
> > > +				      int (*func)(ext2_filsys fs,
> > > +						  blk64_t     *blocknr,
> > > +						  e2_blkcnt_t blockcnt,
> > > +						  blk64_t     ref_blk,
> > > +						  int	      ref_offset,
> > > +						  void	      *priv_data),
> > > +				      void *priv_data);
> > > +
> > >  /* Generic numeric progress meter */
> > >  
> > >  struct ext2fs_numeric_progress_struct {
> > > diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> > > new file mode 100644
> > > index 0000000..cc2954d
> > > --- /dev/null
> > > +++ b/lib/ext2fs/inline_data.c
> > > @@ -0,0 +1,175 @@
> > > +/*
> > > + * inline_data.c --- data in inode
> > > + *
> > > + * Copyright (C) 2012 Zheng Liu <wenqing.lz@taobao.com>
> > > + *
> > > + * %Begin-Header%
> > > + * This file may be redistributed under the terms of the GNU library
> > > + * General Public License, version 2.
> > > + * %End-Header%
> > > + */
> > > +
> > > +#include "config.h"
> > > +#include <stdio.h>
> > > +#include <time.h>
> > > +
> > > +#include "ext2_fs.h"
> > > +#include "ext2_ext_attr.h"
> > > +
> > > +#include "ext2fs.h"
> > > +#include "ext2fsP.h"
> > > +
> > > +struct ext2_inline_data {
> > > +	ext2_filsys fs;
> > > +	ext2_ino_t ino;
> > > +	size_t ea_size;	/* the size of inline data in ea area */
> > > +	char *ea_data;
> > 
> > Should this be a void* since the file data type is opaque to the library?
> 
> I will fix it.
> 
> > 
> > > +};
> > > +
> > > +static errcode_t ext2fs_inline_data_ea_set(struct ext2_inline_data *data)
> > > +{
> > > +	struct ext2_xattr_handle *handle;
> > > +	errcode_t retval;
> > > +
> > > +	retval = ext2fs_xattrs_open(data->fs, data->ino, &handle);
> > > +	if (retval)
> > > +		return retval;
> > > +
> > > +	retval = ext2fs_xattrs_read(handle);
> > > +	if (retval)
> > > +		goto err;
> > > +
> > > +	retval = ext2fs_xattr_set(handle, "system.data",
> > > +				  data->ea_data, data->ea_size);
> > > +	if (retval)
> > > +		goto err;
> > > +
> > > +	retval = ext2fs_xattrs_write(handle);
> > > +
> > > +err:
> > > +	(void) ext2fs_xattrs_close(&handle);
> > > +	return retval;
> > > +}
> > > +
> > > +errcode_t ext2fs_inline_data_ea_get(struct ext2_inline_data *data)
> > > +{
> > > +	struct ext2_xattr_handle *handle;
> > > +	errcode_t retval;
> > > +
> > > +	data->ea_size = 0;
> > > +	data->ea_data = 0;
> > > +
> > > +	retval = ext2fs_xattrs_open(data->fs, data->ino, &handle);
> > > +	if (retval)
> > > +		return retval;
> > > +
> > > +	retval = ext2fs_xattrs_read(handle);
> > > +	if (retval)
> > > +		goto err;
> > > +
> > > +	retval = ext2fs_xattr_get(handle, "system.data",
> > > +				  (void **)&data->ea_data, &data->ea_size);
> > > +	if (retval)
> > > +		goto err;
> > > +
> > > +err:
> > > +	(void) ext2fs_xattrs_close(&handle);
> > > +	return retval;
> > > +}
> > > +
> > > +
> > > +errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
> > > +			       ext2_ino_t ino,
> > > +			       int (*func)(ext2_filsys fs,
> > > +					   blk64_t     *blocknr,
> > > +					   e2_blkcnt_t blockcnt,
> > > +					   blk64_t     ref_blk,
> > > +					   int         ref_offset,
> > > +					   void        *priv_data),
> > > +			       void *priv_data)
> > > +{
> > > +	struct dir_context *ctx;
> > > +	struct ext2_inode inode;
> > > +	struct ext2_dir_entry dirent;
> > > +	struct ext2_inline_data data;
> > > +	errcode_t retval = 0;
> > > +	e2_blkcnt_t blockcnt = 0;
> > > +
> > > +	ctx = (struct dir_context *)priv_data;
> > > +
> > > +	retval = ext2fs_read_inode(fs, ino, &inode);
> > > +	if (retval)
> > > +		goto out;
> > > +
> > > +	if (!(inode.i_flags & EXT4_INLINE_DATA_FL))
> > > +		return EXT2_ET_NO_INLINE_DATA;
> > > +
> > > +	if (!LINUX_S_ISDIR(inode.i_mode)) {
> > > +		retval = EXT2_ET_NO_DIRECTORY;
> > > +		goto out;
> > > +	}
> > > +
> > > +	/* we first check '.' and '..' dir */
> > > +	dirent.inode = ino;
> > > +	dirent.name_len = 1;
> > > +	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
> > > +	dirent.name[0] = '.';
> > > +	dirent.name[1] = '\0';
> > > +	ctx->buf = (char *)&dirent;
> > > +	ext2fs_get_rec_len(fs, &dirent, &ctx->buflen);
> > > +	retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> > > +	if (retval & BLOCK_ABORT)
> > > +		goto out;
> > > +
> > > +	dirent.inode = ext2fs_le32_to_cpu(inode.i_block[0]);
> > > +	dirent.name_len = 2;
> > > +	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
> > > +	dirent.name[0] = '.';
> > > +	dirent.name[1] = '.';
> > > +	dirent.name[2] = '\0';
> > > +	ctx->buf = (char *)&dirent;
> > > +	ext2fs_get_rec_len(fs, &dirent, &ctx->buflen);
> > > +	retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> > > +	if (retval & BLOCK_CHANGED) {
> > > +		errcode_t err;
> > > +
> > > +		inode.i_block[0] = ext2fs_cpu_to_le32(dirent.inode);
> > > +		err = ext2fs_write_inode(fs, ino, &inode);
> > > +		if (err)
> > > +			goto out;
> > > +	}
> > > +	if (retval & BLOCK_ABORT)
> > > +		goto out;
> > > +
> > > +	ctx->buf = (char *)inode.i_block + EXT4_INLINE_DATA_DOTDOT_SIZE;
> > > +	ctx->buflen = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
> > > +	retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> > > +	if (retval & BLOCK_CHANGED) {
> > > +		errcode_t err;
> > > +
> > > +		err = ext2fs_write_inode(fs, ino, &inode);
> > > +		if (err)
> > > +			goto out;
> > > +	}
> > > +	if (retval & BLOCK_ABORT)
> > > +		goto out;
> > > +
> > > +	data.fs = fs;
> > > +	data.ino = ino;
> > > +	retval = ext2fs_inline_data_ea_get(&data);
> > > +	if (retval)
> > > +		goto out;
> > > +	if (data.ea_size > 0) {
> > > +		ctx->buf = data.ea_data;
> > > +		ctx->buflen = data.ea_size;
> > > +		retval |= (*func)(fs, 0, blockcnt++, 0, 0, priv_data);
> > > +		if (retval & BLOCK_CHANGED)
> > > +			ext2fs_inline_data_ea_set(&data);
> > > +		ext2fs_free_mem(&data.ea_data);
> > > +		ctx->buf = 0;
> > > +	}
> > > +
> > > +out:
> > > +	retval |= BLOCK_ERROR;
> > > +	return retval & BLOCK_ERROR ? ctx->errcode : 0;
> > > +}
> > > diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> > > index 1295e81..cfbe5dd 100644
> > > --- a/lib/ext2fs/swapfs.c
> > > +++ b/lib/ext2fs/swapfs.c
> > > @@ -207,6 +207,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
> > >  {
> > >  	unsigned i, has_data_blocks, extra_isize, attr_magic;
> > >  	int has_extents = 0;
> > > +	int has_inline_data = 0;
> > >  	int islnk = 0;
> > >  	__u32 *eaf, *eat;
> > >  
> > > @@ -233,12 +234,19 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
> > >  					   (struct ext2_inode *) t);
> > >  	if (hostorder && (f->i_flags & EXT4_EXTENTS_FL))
> > >  		has_extents = 1;
> > > +	if (hostorder && (f->i_flags & EXT4_INLINE_DATA_FL))
> > > +		has_inline_data = 1;
> > >  	t->i_flags = ext2fs_swab32(f->i_flags);
> > >  	if (!hostorder && (t->i_flags & EXT4_EXTENTS_FL))
> > >  		has_extents = 1;
> > > +	if (!hostorder && (f->i_flags & EXT4_INLINE_DATA_FL))
> > > +		has_inline_data = 1;
> > >  	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
> > > -	/* extent data are swapped on access, not here */
> > > -	if (!has_extents && (!islnk || has_data_blocks)) {
> > > +	/*
> > > +	 * Extent data are swapped on access, not here
> > > +	 * Inline data are not swapped beside parent ino is accessed
> > 
> > From the other patches it looks like the parent ino is swapped on access too.
> > 
> > I'm confused about what this comment is trying to say, though the code here
> > says that inline data is swapped on access (if at all).
> 
> OK.  I will clarify this.
> 
> Thanks,
>                                                 - Zheng
