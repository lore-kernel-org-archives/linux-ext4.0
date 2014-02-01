From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] libext2fs: allow clients to read-ahead metadata
Date: Sat, 1 Feb 2014 02:41:03 -0800
Message-ID: <20140201104103.GA9176@birch.djwong.org>
References: <20140201103721.9011.5971.stgit@birch.djwong.org>
 <20140201103735.9011.14433.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37810 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaBAKlH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Feb 2014 05:41:07 -0500
Content-Disposition: inline
In-Reply-To: <20140201103735.9011.14433.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 01, 2014 at 02:37:35AM -0800, Darrick J. Wong wrote:
> This patch adds to libext2fs the ability to pre-fetch metadata
> into the page cache in the hopes of speeding up libext2fs' clients.
> There are two new library functions -- the first allows a client to
> readahead a list of blocks, and the second is a helper function that
> uses that first mechanism to load group data (bitmaps, inode tables).
> 
> e2fsck will employ both of these methods to speed itself up.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/Makefile.in  |    4 +
>  lib/ext2fs/ext2fs.h     |   10 +++
>  lib/ext2fs/io_manager.c |    2 -
>  lib/ext2fs/readahead.c  |  153 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 168 insertions(+), 1 deletion(-)
>  create mode 100644 lib/ext2fs/readahead.c
> 
> 
> diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> index 92b6ab0..8f98f4b 100644
> --- a/lib/ext2fs/Makefile.in
> +++ b/lib/ext2fs/Makefile.in
> @@ -77,6 +77,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
>  	qcow2.o \
>  	read_bb.o \
>  	read_bb_file.o \
> +	readahead.o \
>  	res_gdt.o \
>  	rw_bitmaps.o \
>  	swapfs.o \
> @@ -153,6 +154,7 @@ SRCS= ext2_err.c \
>  	$(srcdir)/qcow2.c \
>  	$(srcdir)/read_bb.c \
>  	$(srcdir)/read_bb_file.c \
> +	$(srcdir)/readahead.c \
>  	$(srcdir)/res_gdt.c \
>  	$(srcdir)/rw_bitmaps.c \
>  	$(srcdir)/swapfs.c \
> @@ -887,6 +889,8 @@ read_bb_file.o: $(srcdir)/read_bb_file.c $(top_builddir)/lib/config.h \
>   $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
>   $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
>   $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
> +readahead.o: $(srcdir)/readahead.c $(top_builddir)/lib/config.h \
> + $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_err.h
>  res_gdt.o: $(srcdir)/res_gdt.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
>   $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 069c1b6..1e06791 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1543,6 +1543,16 @@ extern errcode_t ext2fs_read_bb_FILE(ext2_filsys fs, FILE *f,
>  				     void (*invalid)(ext2_filsys fs,
>  						     blk_t blk));
>  
> +/* readahead.c */
> +#define EXT2FS_READ_SUPER	0x01
> +#define EXT2FS_READ_GDT		0x02
> +#define EXT2FS_READ_BBITMAP	0x04
> +#define EXT2FS_READ_IBITMAP	0x08
> +#define EXT2FS_READ_ITABLE	0x10
> +errcode_t ext2fs_readahead(ext2_filsys fs, int flags, dgrp_t start,
> +			   dgrp_t ngroups);
> +errcode_t ext2fs_readahead_dblist(ext2_filsys fs, ext2_dblist dblist);
> +
>  /* res_gdt.c */
>  extern errcode_t ext2fs_create_resize_inode(ext2_filsys fs);
>  
> diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
> index 1acbb1d..aae0a4b 100644
> --- a/lib/ext2fs/io_manager.c
> +++ b/lib/ext2fs/io_manager.c
> @@ -135,5 +135,5 @@ errcode_t io_channel_readahead(io_channel io, unsigned long long block,
>  	if (!io->manager->readahead)
>  		return EXT2_ET_OP_NOT_SUPPORTED;
>  
> -	return io->manager->readahead(io, block, nblocks);
> +	return io->manager->readahead(io, block, count);
>  }

Oops, this hunk of course goes in the previous patch.

--D

> diff --git a/lib/ext2fs/readahead.c b/lib/ext2fs/readahead.c
> new file mode 100644
> index 0000000..05f6135
> --- /dev/null
> +++ b/lib/ext2fs/readahead.c
> @@ -0,0 +1,153 @@
> +/*
> + * readahead.c -- Try to convince the OS to prefetch metadata.
> + *
> + * Copyright (C) 2014 Oracle.
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Library
> + * General Public License, version 2.
> + * %End-Header%
> + */
> +
> +#include "config.h"
> +#include <string.h>
> +
> +#include "ext2_fs.h"
> +#include "ext2fs.h"
> +
> +struct read_dblist {
> +	errcode_t err;
> +	blk64_t run_start;
> +	blk64_t run_len;
> +};
> +
> +static EXT2_QSORT_TYPE readahead_dir_block_cmp(const void *a, const void *b)
> +{
> +	const struct ext2_db_entry2 *db_a =
> +		(const struct ext2_db_entry2 *) a;
> +	const struct ext2_db_entry2 *db_b =
> +		(const struct ext2_db_entry2 *) b;
> +
> +	return (int) (db_a->blk - db_b->blk);
> +}
> +
> +static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 *db,
> +			       void *priv_data)
> +{
> +	errcode_t err = 0;
> +	struct read_dblist *pr = priv_data;
> +
> +	if (!pr->run_len || db->blk != pr->run_start + pr->run_len) {
> +		if (pr->run_len)
> +			pr->err = io_channel_readahead(fs->io, pr->run_start,
> +						       pr->run_len);
> +		pr->run_start = db->blk;
> +		pr->run_len = 0;
> +	}
> +	pr->run_len += db->blockcnt;
> +
> +	return pr->err ? DBLIST_ABORT : 0;
> +}
> +
> +errcode_t ext2fs_readahead_dblist(ext2_filsys fs, ext2_dblist dblist)
> +{
> +	errcode_t err;
> +	struct read_dblist pr;
> +
> +	ext2fs_dblist_sort2(dblist, readahead_dir_block_cmp);
> +
> +	memset(&pr, 0, sizeof(pr));
> +	err = ext2fs_dblist_iterate2(dblist, readahead_dir_block, &pr);
> +	if (pr.err)
> +		return pr.err;
> +	if (err)
> +		return err;
> +
> +	if (pr.run_len)
> +		err = io_channel_readahead(fs->io, pr.run_start, pr.run_len);
> +
> +	return err;
> +}
> +
> +errcode_t ext2fs_readahead(ext2_filsys fs, int flags, dgrp_t start,
> +			   dgrp_t ngroups)
> +{
> +	blk64_t		super, old_gdt, new_gdt;
> +	blk_t		blocks;
> +	dgrp_t		i;
> +	ext2_dblist	dblist;
> +	dgrp_t		end = start + ngroups;
> +	errcode_t	err = 0;
> +
> +	if (end > fs->group_desc_count)
> +		end = fs->group_desc_count;
> +
> +	if (flags == 0)
> +		return 0;
> +
> +	err = ext2fs_init_dblist(fs, &dblist);
> +	if (err)
> +		return err;
> +
> +	for (i = start; i < end; i++) {
> +		err = ext2fs_super_and_bgd_loc2(fs, i, &super, &old_gdt,
> +						&new_gdt, &blocks);
> +		if (err)
> +			break;
> +
> +		if (flags & EXT2FS_READ_SUPER) {
> +			err = ext2fs_add_dir_block2(dblist, 0, super, 0);
> +			if (err)
> +				break;
> +		}
> +
> +		if (flags & EXT2FS_READ_GDT) {
> +			if (old_gdt)
> +				err = ext2fs_add_dir_block2(dblist, 0, old_gdt,
> +							    blocks);
> +			else if (new_gdt)
> +				err = ext2fs_add_dir_block2(dblist, 0, new_gdt,
> +							    blocks);
> +			else
> +				err = 0;
> +			if (err)
> +				break;
> +		}
> +
> +		if ((flags & EXT2FS_READ_BBITMAP) &&
> +		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
> +		    ext2fs_bg_free_blocks_count(fs, i) <
> +				fs->super->s_blocks_per_group) {
> +			super = ext2fs_block_bitmap_loc(fs, i);
> +			err = ext2fs_add_dir_block2(dblist, 0, super, 1);
> +			if (err)
> +				break;
> +		}
> +
> +		if ((flags & EXT2FS_READ_IBITMAP) &&
> +		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) &&
> +		    ext2fs_bg_free_inodes_count(fs, i) <
> +				fs->super->s_inodes_per_group) {
> +			super = ext2fs_inode_bitmap_loc(fs, i);
> +			err = ext2fs_add_dir_block2(dblist, 0, super, 1);
> +			if (err)
> +				break;
> +		}
> +
> +		if ((flags & EXT2FS_READ_ITABLE) &&
> +		    ext2fs_bg_free_inodes_count(fs, i) <
> +				fs->super->s_inodes_per_group) {
> +			super = ext2fs_inode_table_loc(fs, i);
> +			err = ext2fs_add_dir_block2(dblist, 0, super,
> +					fs->inode_blocks_per_group);
> +			if (err)
> +				break;
> +		}
> +	}
> +
> +	if (!err)
> +		err = ext2fs_readahead_dblist(fs, dblist);
> +
> +	ext2fs_free_dblist(dblist);
> +	return err;
> +}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
