From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Patch] e2fsprogs: add e2view tool to display file system blocks usage
Date: Mon, 24 Jan 2011 00:46:55 -0700
Message-ID: <6871A0E1-954C-48C2-A432-A1F831DCD92F@dilger.ca>
References: <1295840763-17123-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:51172 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1AXHq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jan 2011 02:46:57 -0500
In-Reply-To: <1295840763-17123-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-23, at 20:46, Robin Dong wrote:
> Having a view of blocks usage of block group descriptors, block/inode bitmaps, inode table, block pointer blocks, extents .etc, can help users in many cases,
> 1) Make estimation on how many memory might be occupied as buffer cache or page cache.
> 2) For some specific workload, is a file system is well formatted for block usage, e.g. whether there are never-be-used blocks allocated for inode table.
> 3) If there is a chance to allocated meta data from non-seek-cost device like SSD as a meta-data device, first of all user should know how many meta data blocks are allocated/used on the file system.
> 
> Therefore a tool to collect block usage information and display in a clear view is necessary. This patch is a first effort to provide such a tool which is called e2view so far.

Much of this information is available via "dumpe2fs -h" already, though perhaps a more clear summary of the total block usage could be added to dumpe2fs. 

Instead, perhaps a better summary for the e2freefrag tool would be good, which also prints out a histogram of free blocks in the filesystem.

I'd personally rather avoid adding another tool to print information like this, and just make one of the existing tools print it.

> [Example]
> An example of e2view execution looks like this:
> 
> #e2view /dev/mapper/sys-var
> 
> result:
> e2view 1.41.14 (22-Dec-2010)
> Super block:            9 Block
> Group descriptor:       9 Block
> Reserved GDT:        4600 Block
> Inode table:        65536 Block
> Inode bitmap:           9 Block
> Block bitmap:           9 Block
> Link block:             0 Block
> Journal:            32802 Block
> Directory:            644 Block
> Extent:                 0 Block
> Ind-Block:            574 Block
> Dind-Block:           172 Block
> Tind-Block:             0 Block
> File Data:         309069 Block
> ACL block:            194 Block
> 
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> misc/Makefile.in |   19 ++-
> misc/e2view.c    |  482 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 498 insertions(+), 3 deletions(-)
> create mode 100644 misc/e2view.c
> 
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 86ee53f..32b7c93 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -17,6 +17,8 @@ INSTALL = @INSTALL@
> @IMAGER_CMT@E2IMAGE_PROG= e2image
> @IMAGER_CMT@E2IMAGE_MAN= e2image.8
> 
> +@IMAGER_CMT@E2IMAGE_PROG= e2view
> +
> @UUIDD_CMT@UUIDD_PROG= uuidd
> @UUIDD_CMT@UUIDD_MAN= uuidd.8
> 
> @@ -50,6 +52,7 @@ UUIDD_OBJS=	uuidd.o
> DUMPE2FS_OBJS=	dumpe2fs.o
> BADBLOCKS_OBJS=	badblocks.o
> E2IMAGE_OBJS=	e2image.o
> +E2VIEW_OBJS=	e2view.o
> FSCK_OBJS=	fsck.o base_device.o ismounted.o
> BLKID_OBJS=	blkid.o
> FILEFRAG_OBJS=	filefrag.o
> @@ -68,6 +71,7 @@ PROFILED_UUIDD_OBJS=	profiled/uuidd.o
> PROFILED_DUMPE2FS_OBJS=	profiled/dumpe2fs.o
> PROFILED_BADBLOCKS_OBJS=	profiled/badblocks.o
> PROFILED_E2IMAGE_OBJS=	profiled/e2image.o
> +PROFILED_E2VIEW_OBJS=	profiled/e2view.o
> PROFILED_FSCK_OBJS=	profiled/fsck.o profiled/base_device.o \
> 			profiled/ismounted.o
> PROFILED_BLKID_OBJS=	profiled/blkid.o
> @@ -106,7 +110,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
> all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
> 	$(FMANPAGES) $(LPROGS) $(E4DEFRAG_PROG)
> 
> -@PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled \
> +@PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled e2view.profiled \
> 	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \
> 	logsave.profiled filefrag.profiled uuidgen.profiled uuidd.profiled \
> 	e2image.profiled e4defrag.profiled
> @@ -187,6 +191,15 @@ e2image.profiled: $(PROFILED_E2IMAGE_OBJS) $(PROFILED_DEPLIBS)
> 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2image.profiled \
> 		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL)
> 
> +e2view: $(E2VIEW_OBJS) $(DEPLIBS)
> +	$(E) "	LD $@"
> +	$(Q) $(CC) $(ALL_LDFLAGS) -o e2view $(E2VIEW_OBJS) $(LIBS) $(LIBINTL)
> +
> +e2view.profiled: $(PROFILED_E2VIEW_OBJS) $(PROFILED_DEPLIBS)
> +	$(E) "	LD $@"
> +	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2view.profiled \
> +		$(PROFILED_E2VIEW_OBJS) $(PROFILED_LIBS) $(LIBINTL)
> +
> e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
> 	$(E) "	LD $@"
> 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2undo $(E2UNDO_OBJS) $(LIBS) $(LIBINTL)
> @@ -550,8 +563,8 @@ clean:
> 		$(FMANPAGES) \
> 		base_device base_device.out mke2fs.static filefrag e2freefrag \
> 		e2initrd_helper partinfo prof_err.[ch] default_profile.c \
> -		uuidd e2image tune2fs.static tst_ismounted fsck.profiled \
> -		blkid.profiled tune2fs.profiled e2image.profiled \
> +		uuidd e2image e2view tune2fs.static tst_ismounted fsck.profiled \
> +		blkid.profiled tune2fs.profiled e2image.profiled e2view.profiled\
> 		e2undo.profiled mke2fs.profiled dumpe2fs.profiled \
> 		logsave.profiled filefrag.profiled uuidgen.profiled \
> 		uuidd.profiled e2image.profiled \
> diff --git a/misc/e2view.c b/misc/e2view.c
> new file mode 100644
> index 0000000..679bbb8
> --- /dev/null
> +++ b/misc/e2view.c
> @@ -0,0 +1,482 @@
> +/*
> + * e2view.c --- provide a view of block usage of a specific file system
> + *
> + * Some code borrowed from misc/e2image.c and is:
> + *
> + * Copyright 2000, 2001 by Theodore Ts'o.
> + *
> + * The rest is Copyright (C) 2011 Taobao, all rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License, version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + *
> + * Authors: Robin Dong <sanbai@taobao.com>
> + */
> +
> +#define _LARGEFILE_SOURCE
> +#define _LARGEFILE64_SOURCE
> +
> +#include <fcntl.h>
> +#include <grp.h>
> +#ifdef HAVE_GETOPT_H
> +#include <getopt.h>
> +#else
> +extern char *optarg;
> +extern int optind;
> +#endif
> +#include <pwd.h>
> +#include <stdio.h>
> +#ifdef HAVE_STDLIB_H
> +#include <stdlib.h>
> +#endif
> +#include <string.h>
> +#include <time.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +
> +#include "ext2fs/ext2_fs.h"
> +#include "ext2fs/ext2fs.h"
> +#include "et/com_err.h"
> +#include "uuid/uuid.h"
> +#include "e2p/e2p.h"
> +
> +#include "../version.h"
> +#include "nls-enable.h"
> +
> +#define SECTOR_SIZE 512
> +#define UNIT_SIZE   64
> +
> +const char * program_name = "e2view";
> +char * device_name = NULL;
> +
> +static void usage(void)
> +{
> +	fprintf(stderr, _("Usage: [-dkm] %s <filesystem>\n"),
> +		program_name);
> +	exit (1);
> +}
> +
> +struct fs_meta_count {
> +	unsigned long	super_block_counts;
> +	unsigned long	group_desc_counts;
> +	unsigned long	reserved_gdt_counts;
> +	unsigned long	inode_table_counts;
> +	unsigned long	inode_bitmap_counts;
> +	unsigned long	block_bitmap_counts;
> +	unsigned long	dir_block;
> +	unsigned long	acl_block;
> +	unsigned long	file_data_block;
> +	unsigned long	file_data_extent_block;
> +	unsigned long	file_data_ind_block;
> +	unsigned long	file_data_dind_block;
> +	unsigned long	file_data_tind_block;
> +	unsigned long	link_block;
> +	unsigned long	journal_block;
> +};
> +
> +struct fs_meta_count meta_counter;
> +
> +struct process_block_struct {
> +	ext2_ino_t	ino;
> +	int		is_dir;
> +	__u32	i_flags;
> +};
> +
> +/*
> + * These subroutines short circuits ext2fs_get_blocks and
> + * ext2fs_check_directory; we use them since we already have the inode
> + * structure, so there's no point in letting the ext2fs library read
> + * the inode again.
> + */
> +static ino_t stashed_ino = 0;
> +static struct ext2_inode *stashed_inode;
> +
> +static errcode_t meta_get_blocks(ext2_filsys fs EXT2FS_ATTR((unused)),
> +				 ext2_ino_t ino,
> +				 blk_t *blocks)
> +{
> +	int	i;
> +
> +	if ((ino != stashed_ino) || !stashed_inode)
> +		return EXT2_ET_CALLBACK_NOTHANDLED;
> +
> +	for (i=0; i < EXT2_N_BLOCKS; i++)
> +		blocks[i] = stashed_inode->i_block[i];
> +	return 0;
> +}
> +
> +static errcode_t meta_check_directory(ext2_filsys fs EXT2FS_ATTR((unused)),
> +				      ext2_ino_t ino)
> +{
> +	if ((ino != stashed_ino) || !stashed_inode)
> +		return EXT2_ET_CALLBACK_NOTHANDLED;
> +
> +	if (!LINUX_S_ISDIR(stashed_inode->i_mode))
> +		return EXT2_ET_NO_DIRECTORY;
> +	return 0;
> +}
> +
> +static errcode_t meta_read_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
> +				 ext2_ino_t ino,
> +				 struct ext2_inode *inode)
> +{
> +	if ((ino != stashed_ino) || !stashed_inode)
> +		return EXT2_ET_CALLBACK_NOTHANDLED;
> +	*inode = *stashed_inode;
> +	return 0;
> +}
> +
> +static void use_inode_shortcuts(ext2_filsys fs, int bool)
> +{
> +	if (bool) {
> +		fs->get_blocks = meta_get_blocks;
> +		fs->check_directory = meta_check_directory;
> +		fs->read_inode = meta_read_inode;
> +		stashed_ino = 0;
> +	} else {
> +		fs->get_blocks = 0;
> +		fs->check_directory = 0;
> +		fs->read_inode = 0;
> +	}
> +}
> +
> +static int process_journal_block(ext2_filsys fs EXT2FS_ATTR((unused)),
> +			     blk64_t *block_nr,
> +			     e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
> +			     blk64_t ref_block EXT2FS_ATTR((unused)),
> +			     int ref_offset EXT2FS_ATTR((unused)),
> +			     void *priv_data EXT2FS_ATTR((unused)))
> +{
> +	meta_counter.journal_block ++;
> +	return 0;
> +}
> +
> +static int process_dir_block(ext2_filsys fs EXT2FS_ATTR((unused)),
> +			     blk64_t *block_nr,
> +			     e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
> +			     blk64_t ref_block EXT2FS_ATTR((unused)),
> +			     int ref_offset EXT2FS_ATTR((unused)),
> +			     void *priv_data EXT2FS_ATTR((unused)))
> +{
> +	meta_counter.dir_block ++;
> +	return 0;
> +}
> +
> +static int process_file_block(ext2_filsys fs EXT2FS_ATTR((unused)),
> +			      blk64_t *block_nr,
> +			      e2_blkcnt_t blockcnt,
> +			      blk64_t ref_block EXT2FS_ATTR((unused)),
> +			      int ref_offset EXT2FS_ATTR((unused)),
> +			      void *priv_data EXT2FS_ATTR((unused)))
> +{
> +	struct process_block_struct *p;
> +
> +	p = (struct process_block_struct *) priv_data;
> +
> +	if (p->i_flags & EXT4_EXTENTS_FL) {
> +		/*
> +		 * leaf node block
> +		 */
> +		if (blockcnt == -1) {
> +			meta_counter.file_data_extent_block ++;
> +		}
> +	} else {
> +		if (blockcnt == BLOCK_COUNT_IND) {
> +			meta_counter.file_data_ind_block ++;
> +		} else if (blockcnt == BLOCK_COUNT_DIND) {
> +			meta_counter.file_data_dind_block ++;
> +		} else if (blockcnt == BLOCK_COUNT_TIND) {
> +			meta_counter.file_data_tind_block ++;
> +		}
> +	}
> +
> +	meta_counter.file_data_block ++;
> +
> +	return 0;
> +}
> +
> +static void calculate_table_blocks(ext2_filsys fs, int debug_flag)
> +{
> +	blk64_t	first_block, b;
> +	unsigned int	i,j;
> +
> +	first_block = fs->super->s_first_data_block;
> +
> +	/*
> +	 * calculate the block_bitmap/inode_bitmap/inode_table
> +	 */
> +	meta_counter.block_bitmap_counts = fs->group_desc_count;
> +	meta_counter.inode_bitmap_counts = fs->group_desc_count;
> +	meta_counter.inode_table_counts =
> +		fs->inode_blocks_per_group * fs->group_desc_count;
> +
> +	for (i = 0; i < fs->group_desc_count; i++) {
> +		if (i == 0) {
> +			meta_counter.reserved_gdt_counts += 1;
> +		}
> +
> +		if (ext2fs_bg_has_super(fs, i)) {
> +			meta_counter.super_block_counts += 1;
> +			meta_counter.group_desc_counts += fs->desc_blocks;
> +			meta_counter.reserved_gdt_counts +=
> +				fs->super->s_reserved_gdt_blocks;
> +			if (debug_flag) {
> +				printf("group%ld has suer block. gdt:%ld\n", i, 
> +					fs->super->s_reserved_gdt_blocks);
> +			}
> +		}
> +	}
> +}
> +
> +int name_id[256];
> +
> +#define EXT4_MAX_REC_LEN		((1<<16)-1)
> +
> +static void calculate_metadata(ext2_filsys fs, int fd, int debug_flag)
> +{
> +	struct process_block_struct	pb;
> +	struct ext2_inode		inode;
> +	ext2_inode_scan			scan;
> +	ext2_ino_t			ino;
> +	errcode_t			retval;
> +	char *				block_buf;
> +
> +	calculate_table_blocks(fs, debug_flag);
> +
> +	retval = ext2fs_open_inode_scan(fs, 0, &scan);
> +	if (retval) {
> +		com_err(program_name, retval, _("while opening inode scan"));
> +		exit(1);
> +	}
> +
> +	block_buf = malloc(fs->blocksize * 3);
> +	if (!block_buf) {
> +		com_err(program_name, 0, "Can't allocate block buffer");
> +		exit(1);
> +	}
> +
> +	use_inode_shortcuts(fs, 1);
> +	stashed_inode = &inode;
> +	while (1) {
> +		retval = ext2fs_get_next_inode(scan, &ino, &inode);
> +		if (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
> +			continue;
> +		if (retval) {
> +			com_err(program_name, retval,
> +				_("while getting next inode"));
> +			exit(1);
> +		}
> +		if (ino == 0)
> +			break;
> +		if (!inode.i_links_count)
> +			continue;
> +		if (ext2fs_file_acl_block(&inode)) {
> +			meta_counter.acl_block++;
> +		}
> +		if (!ext2fs_inode_has_valid_blocks(&inode))
> +			continue;
> +
> +		stashed_ino = ino;
> +		pb.ino = ino;
> +		pb.is_dir = LINUX_S_ISDIR(inode.i_mode);
> +		pb.i_flags = inode.i_flags;
> +		/* calc journal block */
> +		if (ino == fs->super->s_journal_inum) {
> +			retval = ext2fs_block_iterate3(fs, ino,
> +					BLOCK_FLAG_READ_ONLY, block_buf,
> +					process_journal_block, &pb);
> +			if (retval) {
> +				com_err(program_name, retval,
> +					"while iterating over journal inode %u",
> +					ino);
> +				exit(1);
> +			}
> +		} else if (LINUX_S_ISDIR(inode.i_mode)) {
> +			retval = ext2fs_block_iterate3(fs, ino,
> +					BLOCK_FLAG_READ_ONLY, block_buf,
> +					process_dir_block, &pb);
> +			if (retval) {
> +				com_err(program_name, retval,
> +					"while iterating over inode %u",
> +					ino);
> +				exit(1);
> +			}
> +		} else if (LINUX_S_ISLNK(inode.i_mode) &&
> +		     ext2fs_inode_has_valid_blocks(&inode)) {
> +			if (debug_flag) {
> +				printf("ino:%lu link i_blocks:%lu\n", ino,
> +						inode.i_blocks);
> +			}
> +			meta_counter.link_block += inode.i_blocks * 
> +				SECTOR_SIZE / fs->blocksize;
> +		} else {
> +			if ((inode.i_flags & EXT4_EXTENTS_FL) ||
> +			    inode.i_block[EXT2_IND_BLOCK] ||
> +			    inode.i_block[EXT2_DIND_BLOCK] ||
> +			    inode.i_block[EXT2_TIND_BLOCK]) 
> +			{
> +				if (debug_flag) {
> +					printf("ino:%lu inode i_blocks:%lu\n", ino,
> +						inode.i_blocks);
> +				}
> +				retval = ext2fs_block_iterate3(fs,
> +				       ino, BLOCK_FLAG_READ_ONLY, block_buf,
> +				       process_file_block, &pb);
> +				if (retval) {
> +					com_err(program_name, retval,
> +					"while iterating over inode %u", ino);
> +					exit(1);
> +				}
> +			} else {
> +				if (debug_flag) {
> +					printf("ino:%lu normal inode i_blocks:%lu\n", ino,
> +						inode.i_blocks);
> +				}
> +				meta_counter.file_data_block += inode.i_blocks * 
> +					SECTOR_SIZE / fs->blocksize;
> +			}
> +		}
> +	}
> +	use_inode_shortcuts(fs, 0);
> +	free(block_buf);
> +}
> +
> +void change_unit(ext2_filsys fs,
> +			struct fs_meta_count *counter,
> +			unsigned long unit)
> +{
> +	int i;
> +	int nr = sizeof(struct fs_meta_count) / sizeof(unsigned long);
> +	unsigned long *p = (unsigned long*)counter;
> +	
> +	for (i=0; i < nr; i++)
> +		*(p + i) = *(p + i) * fs->blocksize / unit;
> +}
> +
> +int main (int argc, char ** argv)
> +{
> +	int c;
> +	errcode_t retval;
> +	ext2_filsys fs;
> +	char *image_fn;
> +	char unit[UNIT_SIZE];
> +	int open_flag = EXT2_FLAG_64BITS;
> +	int debug_flag = 0;
> +	int kilobytes_flag = 0;
> +	int megabytes_flag = 0;
> +	int fd = 0;
> +
> +#ifdef ENABLE_NLS
> +	setlocale(LC_MESSAGES, "");
> +	setlocale(LC_CTYPE, "");
> +	bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
> +	textdomain(NLS_CAT_NAME);
> +#endif
> +	fprintf (stderr, "e2view %s (%s)\n", E2FSPROGS_VERSION,
> +		 E2FSPROGS_DATE);
> +	if (argc && *argv)
> +		program_name = *argv;
> +	add_error_table(&et_ext2_error_table);
> +	while ((c = getopt (argc, argv, "dkm")) != EOF)
> +		switch (c) {
> +			case 'd':
> +				debug_flag++;
> +				break;
> +			case 'k':
> +				kilobytes_flag++;
> +				break;
> +			case 'm':
> +				megabytes_flag++;
> +				break;
> +			default:
> +				usage();
> +		}
> +	if (optind != argc - 1 ||
> +			(kilobytes_flag && megabytes_flag))
> +		usage();
> +
> +	device_name = argv[optind];
> +
> +	retval = ext2fs_open (device_name, open_flag, 0, 0,
> +			      unix_io_manager, &fs);
> +	if (retval) {
> +		com_err (program_name, retval, _("while trying to open %s"),
> +			 device_name);
> +		fputs(_("Couldn't find valid filesystem superblock.\n"), stdout);
> +		exit(1);
> +	}
> +
> +	memset(&meta_counter, 0, sizeof(struct fs_meta_count));
> +
> +	calculate_metadata(fs, fd, debug_flag);
> +
> +	/*
> +	 * take off the blocks of  Reserved_GDT
> +	 */
> +	meta_counter.file_data_ind_block -=
> +			fs->super->s_reserved_gdt_blocks;
> +	meta_counter.file_data_dind_block -= 1;
> +	meta_counter.file_data_block -= meta_counter.reserved_gdt_counts;
> +
> +	/*
> +	 * take off the xattr block (ACL block)
> +	 */
> +	meta_counter.file_data_block -= meta_counter.acl_block;
> +
> +	/*
> +	 * display the different units
> +	 */
> +	if (kilobytes_flag) {
> +		change_unit(fs, &meta_counter, 1024);
> +		sprintf(unit, " %s", "KB");
> +	} else if (megabytes_flag) {
> +		change_unit(fs, &meta_counter, 1024*1024);
> +		sprintf(unit, " %s", "MB");
> +	} else {
> +		sprintf(unit, " %s", "Block");
> +	}
> +
> +	printf("Super block:     %8lu%s\n",
> +			meta_counter.super_block_counts, unit);
> +	printf("Group descriptor:%8lu%s\n",
> +			meta_counter.group_desc_counts, unit);
> +	printf("Reserved GDT:    %8lu%s\n",
> +			meta_counter.reserved_gdt_counts, unit);
> +	printf("Inode table:     %8lu%s\n",
> +			meta_counter.inode_table_counts, unit);
> +	printf("Inode bitmap:    %8lu%s\n",
> +			meta_counter.inode_bitmap_counts, unit);
> +	printf("Block bitmap:    %8lu%s\n",
> +			meta_counter.block_bitmap_counts, unit);
> +	printf("Link block:      %8lu%s\n",
> +			meta_counter.link_block, unit);
> +	printf("Journal:         %8lu%s\n",
> +			meta_counter.journal_block, unit);
> +	printf("Directory:       %8lu%s\n",
> +			meta_counter.dir_block, unit);
> +	printf("Extent:          %8lu%s\n",
> +			meta_counter.file_data_extent_block, unit);
> +	printf("Ind-Block:       %8lu%s\n",
> +			meta_counter.file_data_ind_block, unit);
> +	printf("Dind-Block:      %8lu%s\n",
> +			meta_counter.file_data_dind_block, unit);
> +	printf("Tind-Block:      %8lu%s\n",
> +			meta_counter.file_data_tind_block, unit);
> +	printf("File Data:       %8lu%s\n",
> +			meta_counter.file_data_block, unit);
> +	printf("ACL block:       %8lu%s\n",
> +			meta_counter.acl_block, unit);
> +
> +	ext2fs_close (fs);
> +	remove_error_table(&et_ext2_error_table);
> +	exit (0);
> +}
> -- 
> 1.7.3.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





