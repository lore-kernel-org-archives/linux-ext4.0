From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/4] libext2fs: Support for orphan file feature
Date: Fri, 22 May 2015 15:59:19 -0600
Message-ID: <4CA1ABFA-BDCE-44D7-AC06-FF1D606803A4@dilger.ca>
References: <1432294137-26078-1-git-send-email-jack@suse.cz> <1432294137-26078-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35804 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946194AbbEVV7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2015 17:59:23 -0400
Received: by pdea3 with SMTP id a3so28920983pde.2
        for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 14:59:23 -0700 (PDT)
In-Reply-To: <1432294137-26078-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 22, 2015, at 5:28 AM, Jan Kara <jack@suse.cz> wrote:
> 
> Add support for creating and deleting orphan file and a couple of
> utility functions that will be used in other tools.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> lib/e2p/feature.c      |   4 +
> lib/ext2fs/Makefile.in |   2 +
> lib/ext2fs/ext2_fs.h   |  11 +++
> lib/ext2fs/ext2fs.h    |  35 +++++++-
> lib/ext2fs/orphan.c    | 217 +++++++++++++++++++++++++++++++++++++++++++++++++
> 5 files changed, 267 insertions(+), 2 deletions(-)
> create mode 100644 lib/ext2fs/orphan.c
> 
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index 73884f2cf5bf..a8e0d4a4644a 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -45,6 +45,8 @@ static struct feature feature_list[] = {
> 			"snapshot_bitmap" },
> 	{	E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_SPARSE_SUPER2,
> 			"sparse_super2" },
> +	{	E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_ORPHAN_FILE,
> +			"orphan_file" },
> 
> 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
> 			"sparse_super" },
> @@ -70,6 +72,8 @@ static struct feature feature_list[] = {
> 			"replica" },
> 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_READONLY,
> 			"read-only" },
> +	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT,
> +			"orphan_file_used" },
> 
> 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
> 			"compression" },
> diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> index 8a7f8ca52902..67120b10438c 100644
> --- a/lib/ext2fs/Makefile.in
> +++ b/lib/ext2fs/Makefile.in
> @@ -109,6 +109,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
> 	native.o \
> 	newdir.o \
> 	openfs.o \
> +	orphan.o \
> 	progress.o \
> 	punch.o \
> 	qcow2.o \
> @@ -189,6 +190,7 @@ SRCS= ext2_err.c \
> 	$(srcdir)/native.c \
> 	$(srcdir)/newdir.c \
> 	$(srcdir)/openfs.c \
> +	$(srcdir)/orphan.c \
> 	$(srcdir)/progress.c \
> 	$(srcdir)/punch.c \
> 	$(srcdir)/qcow2.c \
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index a755cfac8eae..a77c8fa09938 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -52,6 +52,7 @@
> #define EXT2_JOURNAL_INO	 8	/* Journal inode */
> #define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for snapshots */
> #define EXT4_REPLICA_INO	10	/* Used by non-upstream feature */
> +#define EXT4_ORPHAN_INO		 9	/* Inode with orphan entries */

This still has a problem here, and can't be safely landed until it is resolved.
At a minimum, it shouldn't be possible to create a filesystem with COMPAT_ORPHAN_FILE
at the same time as COMPAT_EXCLUDE_BITMAP.  Since EXCLUDE_BITMAP never made it
upstream, that might be a reasonable compromise for now.

That said, we still need to do something about the lack of reserved inodes.

Cheers, Andreas

> /* First non-reserved inode for old ext2 filesystems */
> #define EXT2_GOOD_OLD_FIRST_INO	11
> @@ -769,6 +770,7 @@ struct ext2_super_block {
> /* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080 not used, legacy */
> #define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100
> #define EXT4_FEATURE_COMPAT_SPARSE_SUPER2	0x0200
> +#define EXT4_FEATURE_COMPAT_ORPHAN_FILE		0x0400
> 
> 
> #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
> @@ -789,6 +791,7 @@ struct ext2_super_block {
> #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
> #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
> #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
> +#define EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT	0x2000
> 
> 
> #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
> @@ -838,6 +841,14 @@ struct ext2_super_block {
> #define EXT4_DEFM_DISCARD	0x0400
> #define EXT4_DEFM_NODELALLOC	0x0800
> 
> +#define EXT4_ORPHAN_BLOCK_MAGIC 0x0b10ca04
> +
> +/* Structure at the tail of orphan block */
> +struct ext4_orphan_block_tail {
> +	__u32 ob_magic;
> +	__u32 ob_checksum;
> +};
> +
> /*
>  * Structure of a directory entry
>  */
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 28c46701da29..1e303d5d59ca 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -555,7 +555,8 @@ typedef struct ext2_icount *ext2_icount_t;
> 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
> 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
> 					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
> -					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2)
> +					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2|\
> +					 EXT4_FEATURE_COMPAT_ORPHAN_FILE)
> 
> #ifdef CONFIG_MMP
> #define EXT4_LIB_INCOMPAT_MMP		EXT4_FEATURE_INCOMPAT_MMP
> @@ -589,7 +590,8 @@ typedef struct ext2_icount *ext2_icount_t;
> 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
> 					 EXT4_LIB_RO_COMPAT_QUOTA|\
> 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
> -					 EXT4_FEATURE_RO_COMPAT_READONLY)
> +					 EXT4_FEATURE_RO_COMPAT_READONLY|\
> +					 EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT)
> 
> /*
>  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
> @@ -1512,6 +1514,19 @@ errcode_t ext2fs_get_data_io(ext2_filsys fs, io_channel *old_io);
> errcode_t ext2fs_set_data_io(ext2_filsys fs, io_channel new_io);
> errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io);
> 
> +/* orphan.c */
> +/*
> + * Minimum orphan file size (it must be at least 1 block and smaller one isn't
> + * very useful).
> + */
> +#define EXT4_MIN_ORPHAN_FILE_SIZE 16384
> +
> +extern errcode_t ext2fs_create_orphan_file(ext2_filsys fs, blk_t num_blocks);
> +extern errcode_t ext2fs_truncate_orphan_file(ext2_filsys fs);
> +extern e2_blkcnt_t ext2fs_default_orphan_file_blocks(__u64 num_blocks);
> +extern errcode_t ext2fs_orphan_file_block_csum_set(ext2_filsys fs, char *buf);
> +extern int ext2fs_orphan_file_block_csum_verify(ext2_filsys fs, char *buf);
> +
> /* get_pathname.c */
> extern errcode_t ext2fs_get_pathname(ext2_filsys fs, ext2_ino_t dir, ext2_ino_t ino,
> 			       char **name);
> @@ -1645,6 +1660,9 @@ extern int ext2fs_dirent_name_len(const struct ext2_dir_entry *entry);
> extern void ext2fs_dirent_set_name_len(struct ext2_dir_entry *entry, int len);
> extern int ext2fs_dirent_file_type(const struct ext2_dir_entry *entry);
> extern void ext2fs_dirent_set_file_type(struct ext2_dir_entry *entry, int type);
> +extern int ext2fs_inodes_per_orphan_block(ext2_filsys fs);
> +extern struct ext4_orphan_block_tail *ext2fs_orphan_block_tail(ext2_filsys fs,
> +							       char *buf)
> 
> #endif
> 
> @@ -1915,6 +1933,19 @@ _INLINE_ void ext2fs_dirent_set_file_type(struct ext2_dir_entry *entry, int type
> 	entry->name_len = (entry->name_len & 0xff) | (type << 8);
> }
> 
> +_INLINE_ int ext2fs_inodes_per_orphan_block(ext2_filsys fs)
> +{
> +	return (fs->blocksize - sizeof(struct ext4_orphan_block_tail)) /
> +		sizeof(__u32);
> +}
> +
> +_INLINE_ struct ext4_orphan_block_tail *
> +ext2fs_orphan_block_tail(ext2_filsys fs, char *buf)
> +{
> +	return (struct ext4_orphan_block_tail *)(buf + fs->blocksize -
> +		sizeof(struct ext4_orphan_block_tail));
> +}
> +
> #undef _INLINE_
> #endif
> 
> diff --git a/lib/ext2fs/orphan.c b/lib/ext2fs/orphan.c
> new file mode 100644
> index 000000000000..1fd5c0688218
> --- /dev/null
> +++ b/lib/ext2fs/orphan.c
> @@ -0,0 +1,217 @@
> +/*
> + * orphan.c --- utility function to handle orphan file
> + *
> + * Copyright (C) 2015 Jan Kara.
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
> +#include "ext2fsP.h"
> +
> +errcode_t ext2fs_truncate_orphan_file(ext2_filsys fs)
> +{
> +	struct ext2_inode inode;
> +	errcode_t err;
> +
> +	err = ext2fs_read_inode(fs, EXT4_ORPHAN_INO, &inode);
> +	if (err)
> +		return err;
> +
> +	err = ext2fs_punch(fs, EXT4_ORPHAN_INO, &inode, NULL, 0, ~0ULL);
> +	if (err)
> +		return err;
> +
> +	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
> +	memset(&inode, 0, sizeof(struct ext2_inode));
> +	err = ext2fs_write_inode(fs, EXT4_ORPHAN_INO, &inode);
> +
> +	fs->super->s_feature_compat &= ~EXT4_FEATURE_COMPAT_ORPHAN_FILE;
> +	ext2fs_mark_super_dirty(fs);
> +
> +	return err;
> +}
> +
> +struct mkorphan_info {
> +	char *buf;
> +	char *zerobuf;
> +	blk_t num_blocks;
> +	blk_t alloc_blocks;
> +	errcode_t err;
> +};
> +
> +static int mkorphan_proc(ext2_filsys	fs,
> +			 blk64_t	*blocknr,
> +			 e2_blkcnt_t	blockcnt,
> +			 blk64_t	ref_block EXT2FS_ATTR((unused)),
> +			 int		ref_offset EXT2FS_ATTR((unused)),
> +			 void		*priv_data)
> +{
> +	struct mkorphan_info *oi = (struct mkorphan_info *)priv_data;
> +	blk64_t new_blk;
> +	errcode_t err;
> +
> +	err = ext2fs_new_block2(fs, 0, 0, &new_blk);
> +	if (err) {
> +		oi->err = err;
> +		return BLOCK_ABORT;
> +	}
> +	ext2fs_block_alloc_stats2(fs, new_blk, +1);
> +	if (blockcnt >= 0)
> +		err = io_channel_write_blk64(fs->io, new_blk, 1, oi->buf);
> +	else
> +		err = io_channel_write_blk64(fs->io, new_blk, 1, oi->zerobuf);
> +	if (err) {
> +		oi->err = err;
> +		return BLOCK_ABORT;
> +	}
> +	oi->alloc_blocks++;
> +	*blocknr = new_blk;
> +	if (blockcnt >= 0 && --oi->num_blocks == 0)
> +		return BLOCK_CHANGED | BLOCK_ABORT;
> +	return BLOCK_CHANGED;
> +}
> +
> +errcode_t ext2fs_create_orphan_file(ext2_filsys fs, blk_t num_blocks)
> +{
> +	struct ext2_inode inode;
> +	errcode_t err;
> +	char *buf = NULL, *zerobuf = NULL;
> +	struct mkorphan_info oi;
> +	struct ext4_orphan_block_tail *ob_tail;
> +
> +	err = ext2fs_read_inode(fs, EXT4_ORPHAN_INO, &inode);
> +	if (err)
> +		return err;
> +	if (EXT2_I_SIZE(&inode)) {
> +		err = ext2fs_truncate_orphan_file(fs);
> +		if (err)
> +			return err;
> +	}
> +
> +	memset(&inode, 0, sizeof(struct ext2_inode));
> +	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
> +		inode.i_flags |= EXT4_EXTENTS_FL;
> +		err = ext2fs_write_inode(fs, EXT4_ORPHAN_INO, &inode);
> +		if (err)
> +			return err;
> +	}
> +
> +	err = ext2fs_get_mem(fs->blocksize, &buf);
> +	if (err)
> +		return err;
> +	err = ext2fs_get_mem(fs->blocksize, &zerobuf);
> +	if (err)
> +		goto out;
> +	memset(buf, 0, fs->blocksize);
> +	memset(zerobuf, 0, fs->blocksize);
> +	ob_tail = ext2fs_orphan_block_tail(fs, buf);
> +	ob_tail->ob_magic = ext2fs_cpu_to_le32(EXT4_ORPHAN_BLOCK_MAGIC);
> +	ext2fs_orphan_file_block_csum_set(fs, buf);
> +	oi.num_blocks = num_blocks;
> +	oi.alloc_blocks = 0;
> +	oi.buf = buf;
> +	oi.zerobuf = zerobuf;
> +	oi.err = 0;
> +	err = ext2fs_block_iterate3(fs, EXT4_ORPHAN_INO, BLOCK_FLAG_APPEND,
> +				    0, mkorphan_proc, &oi);
> +	if (err)
> +		goto out;
> +
> +	/* Reread inode after blocks were allocated */
> +	err = ext2fs_read_inode(fs, EXT4_ORPHAN_INO, &inode);
> +	if (err)
> +		goto out;
> +	ext2fs_iblk_set(fs, &inode, 0);
> +	inode.i_atime = inode.i_mtime =
> +		inode.i_ctime = fs->now ? fs->now : time(0);
> +	inode.i_links_count = 1;
> +	inode.i_mode = LINUX_S_IFREG | 0600;
> +	ext2fs_iblk_add_blocks(fs, &inode, oi.alloc_blocks);
> +	err = ext2fs_inode_size_set(fs, &inode,
> +			(unsigned long long)fs->blocksize * num_blocks);
> +	if (err)
> +		goto out;
> +	err = ext2fs_write_new_inode(fs, EXT4_ORPHAN_INO, &inode);
> +	if (err)
> +		goto out;
> +
> +	fs->super->s_feature_compat |= EXT4_FEATURE_COMPAT_ORPHAN_FILE;
> +	ext2fs_mark_super_dirty(fs);
> +out:
> +	if (buf)
> +		ext2fs_free_mem(&buf);
> +	if (zerobuf)
> +		ext2fs_free_mem(&zerobuf);
> +	return err;
> +}
> +
> +/*
> + * Find reasonable size for orphan file. We choose orphan file size to be
> + * between 32 and 512 filesystem blocks and not more than 1/4096 of the
> + * filesystem unless it is really small.
> + */
> +e2_blkcnt_t ext2fs_default_orphan_file_blocks(__u64 num_blocks)
> +{
> +	if (num_blocks < 128 * 1024)
> +		return 32;
> +	if (num_blocks < 2 * 1024 * 1024)
> +		return num_blocks / 4096;
> +	return 512;
> +}
> +
> +static errcode_t ext2fs_orphan_file_block_csum(ext2_filsys fs, char *buf,
> +					       __u32 *crc)
> +{
> +	int inodes_per_ob = ext2fs_inodes_per_orphan_block(fs);
> +	__u32 gen;
> +	ext2_ino_t inum;
> +	struct ext2_inode inode;
> +	errcode_t retval;
> +
> +	retval = ext2fs_read_inode(fs, EXT4_ORPHAN_INO, &inode);
> +	if (retval)
> +		return retval;
> +	inum = ext2fs_cpu_to_le32(EXT4_ORPHAN_INO);
> +	gen = ext2fs_cpu_to_le32(inode.i_generation);
> +	*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&inum,
> +			       sizeof(inum));
> +	*crc = ext2fs_crc32c_le(*crc, (unsigned char *)&gen, sizeof(gen));
> +	*crc = ext2fs_crc32c_le(*crc, buf, inodes_per_ob * sizeof(__u32));
> +
> +	return 0;
> +}
> +
> +errcode_t ext2fs_orphan_file_block_csum_set(ext2_filsys fs, char *buf)
> +{
> +	struct ext4_orphan_block_tail *tail;
> +
> +	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +		return 0;
> +
> +	tail = ext2fs_orphan_block_tail(fs, buf);
> +	return ext2fs_orphan_file_block_csum(fs, buf, &tail->ob_checksum);
> +}
> +
> +int ext2fs_orphan_file_block_csum_verify(ext2_filsys fs, char *buf)
> +{
> +	struct ext4_orphan_block_tail *tail;
> +	__u32 crc;
> +	errcode_t retval;
> +
> +	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +		return 1;
> +	retval = ext2fs_orphan_file_block_csum(fs, buf, &crc);
> +	if (retval)
> +		return 0;
> +	tail = ext2fs_orphan_block_tail(fs, buf);
> +	return ext2fs_le32_to_cpu(tail->ob_checksum) == crc;
> +}
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





