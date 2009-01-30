From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 3/3] ext4: Ext4 online defrag command
Date: Fri, 30 Jan 2009 15:14:15 +0900
Message-ID: <49829AB7.9020609@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40965 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZA3GQR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jan 2009 01:16:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: online defrag -- Ext4 online defrag command

From: Akira Fujita <a-fujita@rs.jp.nec.com>

- Usage is as follows:
  - Defrag for a single file.
    # e4defrag file, directory, device
  - Check the file fragments on ext4.
    # e4defrag -c file, directory, device


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
/*
 * e4defrag.c - ext4 filesystem defragmenter
 *
 * Copyright (C) 2009 NEC Software Tohoku, Ltd.
 *
 * Author: Akira Fujita	<a-fujita@rs.jp.nec.com>
 *         Takashi Sato	<t-sato@yk.jp.nec.com>
 */

#ifndef _LARGEFILE_SOURCE
#define _LARGEFILE_SOURCE
#endif

#ifndef _LARGEFILE64_SOURCE
#define _LARGEFILE64_SOURCE
#endif

#define _XOPEN_SOURCE	500
#define _GNU_SOURCE
#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <dirent.h>
#include <limits.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/statfs.h>
#include <sys/vfs.h>
#include <sys/ioctl.h>
#include <mntent.h>
#include <linux/fs.h>
#include <ctype.h>
#include <sys/syscall.h>
#include <sys/mman.h>
#include <ext2fs/ext2_types.h>
#include <math.h>

/* Ioctl command */
#define FS_IOC_FIEMAP		_IOWR('f', 11, struct fiemap)
#define EXT4_IOC_DEFRAG		_IOW('f', 15, struct move_extent)

/* Macro functions */
#define PRINT_ERR_MSG(msg)	fprintf(stderr, "%s\n", (msg))
#define IN_FTW_PRINT_ERR_MSG(msg)	\
	fprintf(stderr, "\t%s\t\t[ NG ]\n", (msg))
#define PRINT_FILE_NAME(file)	fprintf(stderr, " \"%s\"\n", (file))
#define PRINT_ERR_MSG_WITH_ERRNO(msg)	\
	fprintf(stderr, "\t%s:%s\t[ NG ]\n", (msg), strerror(errno))
#define STATISTIC_ERR_MSG(msg)	\
	fprintf(stderr, "\t%s\n", (msg))
#define STATISTIC_ERR_MSG_WITH_ERRNO(msg)	\
	fprintf(stderr, "\t%s:%s\n", (msg), strerror(errno))
#define min(x, y) (((x) > (y)) ? (y) : (x))
#define SECTOR_TO_BLOCK(sectors, blocksize) \
	((sectors) / ((blocksize) >> 9))
#define CALC_SCORE(ratio) \
	(powf((ratio), 0.09) * 66.1)
#define CALC_BLKS_PER_GROUP(blocksize) \
	((blocksize) * 8)
/* Wrap up the free function */
#define FREE(tmp)				\
	do {					\
		if (tmp)			\
			free(tmp);		\
	} while (0)				\
/* Insert list2 after list1 */
#define insert(list1, list2)			\
	do {					\
		list2->next = list1->next;	\
		list1->next->prev = list2;	\
		list2->prev = list1;		\
		list1->next = list2;		\
	} while (0)

#ifndef __NR_fadvise64
#define __NR_fadvise64		250
#endif

#ifndef __NR_sync_file_range
#define __NR_sync_file_range	314
#endif

#ifndef __NR_fallocate
#define __NR_fallocate		324
#endif

#ifndef POSIX_FADV_DONTNEED
#if defined(__s390x__)
#define POSIX_FADV_DONTNEED	6 /* Don't need these pages */
#else
#define POSIX_FADV_DONTNEED	4 /* Don't need these pages */
#endif
#endif

#ifndef SYNC_FILE_RANGE_WAIT_BEFORE
#define SYNC_FILE_RANGE_WAIT_BEFORE	1
#endif
#ifndef SYNC_FILE_RANGE_WRITE
#define SYNC_FILE_RANGE_WRITE		2
#endif
#ifndef SYNC_FILE_RANGE_WAIT_AFTER
#define SYNC_FILE_RANGE_WAIT_AFTER	4
#endif

#define DEVNAME			0
#define DIRNAME			1
#define FILENAME		2

#define RETURN_OK		0
#define RETURN_NG		-1
#define RETURN_GFS_ERR		-2
/*
 * Restriction for uninitialized extent file.
 * This will be gone away, soon.
 */
#define RETURN_UNINIT_EXT_ERR	-3

#define FTW_CONT		0
#define FTW_OPEN_FD		2000

#define FS_EXT4			"ext4"
#define ROOT_UID		0

#define DEFAULT_SCORE		55

/* Magic number for ext4 */
#define EXT4_SUPER_MAGIC	0xEF53

/* Defrag size(64MB) per ioctl */
#define DEFRAG_SIZE		((unsigned long)1 << 26)

/* The following four macros are used for ioctl FS_IOC_FIEMAP
 * FIEMAP_FLAG_SYNC:	sync file data before map.
 * FIEMAP_EXTENT_LAST:	last extent in file.
 * FIEMAP_MAX_OFFSET:	max file offset.
 * EXTENT_MAX_COUNT:	the maximum number of extents for exchanging between
 *			kernel-space and user-space per ioctl
 */
#define FIEMAP_FLAG_SYNC	0x00000001
#define FIEMAP_EXTENT_LAST	0x00000001
#define FIEMAP_EXTENT_UNWRITTEN	0x00000800
#define FIEMAP_MAX_OFFSET	(~0ULL)
#define EXTENT_MAX_COUNT	512

/* The following macros are error message */
#define MSG_USAGE		\
"Usage	: e4defrag [-v] file...| directory...| device...\n\
	: e4defrag  -c  file...| directory...| device...\n"

#define NGMSG_MTAB		"Can not access /etc/mtab"
#define NGMSG_UNMOUNT		"FS is not mounted"
#define NGMSG_EXT4		"FS is not ext4 File System"
#define NGMSG_FS_INFO		"Get FSInfo fail"
#define NGMSG_FILE_INFO		"Get FileInfo fail"
#define NGMSG_FILE_OPEN		"Open fail"
#define NGMSG_FILE_SYNC		"Sync(fsync) fail"
#define NGMSG_FILE_DEFRAG	"Defrag fail"
#define NGMSG_FILE_BLOCKSIZE	"Can't get blocksize"
#define NGMSG_FILE_UNREG	"File is not regular file"
#define NGMSG_FILE_LARGE	\
	"Defrag size is larger than FileSystem's free space"
#define NGMSG_FILE_AUTHORITY	\
	"File is not current user's file or current user is not root"
#define NGMSG_FILE_LOCK		"File is locked"
#define NGMSG_FILE_BLANK	"File size is 0"
#define NGMSG_GET_LCKINFO	"Get LockInfo fail"
#define NGMSG_LOST_FOUND	"Can not process \"lost+found\""
#define NGMSG_REALPATH		"Can not get full path"
#define NGMSG_FILE_MAP		"Get file map fail"
#define NGMSG_FILE_DROP_BUFFER	"Free page fail"
#define NGMSG_FADVISE_SYSCALL	"\tFadvise fail"
#define NGMSG_FILE_EXTENT	"Get file extents fail"
#define NGMSG_FILE_UNLINK	"Unlink fail"
#define NGMSG_FILE_FALLOC	"Fallocate fail"
#define NGMSG_FILE_IN_DEFRAG	"File is being defraged by other program"
/*
 * Restriction for uninitialized extent file.
 * This will be gone away, soon.
 */
#define NGMSG_UNINIT_EXTENT	"Can not handle uninit extents"

/* Data type for filesystem-wide blocks number */
typedef unsigned long long ext4_fsblk_t;

/* Data type for file logical block number */
typedef unsigned int ext4_lblk_t;

struct fiemap_extent_data {
	ext4_lblk_t len;			/* blocks count */
	ext4_lblk_t logical;		/* start logical block number */
	ext4_fsblk_t physical;		/* start physical block number */
};

struct fiemap_extent_list {
	struct fiemap_extent_list *prev;
	struct fiemap_extent_list *next;
	struct fiemap_extent_data data;	/* extent belong to file */
};

struct fiemap_extent_group {
	struct fiemap_extent_group *prev;
	struct fiemap_extent_group *next;
	ext4_lblk_t len;	/* length of this continuous region */
	struct fiemap_extent_list *start;	/* start ext */
	struct fiemap_extent_list *end;		/* end ext */
};

struct move_extent {
	int org_fd;		/* original file descriptor */
	int dest_fd;		/* destination file descriptor */
	ext4_lblk_t start;	/* logical offset of org_fd and dest_fd*/
	ext4_lblk_t len;	/* exchange block length */
};

struct fiemap_extent {
	__u64 fe_logical;	/* logical offset in bytes for the start of
				* the extent from the beginning of the file */
	__u64 fe_physical;	/* physical offset in bytes for the start
				* of the extent from the beginning
				* of the disk */
	__u64 fe_length;	/* length in bytes for this extent */
	__u64 fe_reserved64[2];
	__u32 fe_flags;    	/* FIEMAP_EXTENT_* flags for this extent */
	__u32 fe_reserved[3];
};

struct fiemap {
	__u64 fm_start;		/* logical offset (inclusive) at
				* which to start mapping (in) */
	__u64 fm_length;	/* logical length of mapping which
				* userspace wants (in) */
	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
	__u32 fm_mapped_extents;/* number of extents that were mapped (out) */
	__u32 fm_extent_count;	/* size of fm_extents array (in) */
	__u32 fm_reserved;
	struct fiemap_extent fm_extents[0];/* array of mapped extents (out) */
};

struct statistic_ino {
	int now_count;	/* the file's extents count of before defrag */
	int best_count; /* the best file's extents count */
	float ratio;	/* the ratio of fragmentation */
	char msg_buffer[PATH_MAX + 1];	/* pathname of the file */
};

int	detail_flag;
int	statistic_flag;
int	extents_before_defrag;
int	extents_after_defrag;
unsigned int	current_uid;
unsigned int	succeed_cnt;
unsigned int	regular_count;
unsigned int	total_count;
unsigned int	frag_files_before_defrag;
unsigned int	frag_files_after_defrag;
unsigned int	defraged_file_count;
char	lost_found_dir[PATH_MAX + 1];
ext4_fsblk_t	files_block_count;
struct statistic_ino	sta_array[5];

/*
 * fadvise() -		Give advice about file access.
 *
 * @fd:			the file's descriptor.
 * @offset:		file offset.
 * @len:		area length.
 * @advise:		process flag.
 */
int fadvise(int fd, loff_t offset, size_t len, int advise)
{
	return syscall(__NR_fadvise64, fd, offset, len, advise);
}

/*
 * sync_file_range() -	Sync file region.
 *
 * @fd:			the file's descriptor.
 * @offset:		file offset.
 * @length:		area length.
 * @flag:		process flag.
 */
int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
{
	return syscall(__NR_sync_file_range, fd, offset, length, flag);
}

/*
 * fallocate() -	Manipulate file space.
 *
 * @fd:			the file's descriptor.
 * @mode:		process flag.
 * @offset:		file offset.
 * @len:		file size.
 */
int fallocate(int fd, int mode, loff_t offset, loff_t len)
{
	return syscall(__NR_fallocate, fd, mode, offset, len);
}

/*
 * get_mount_point() -	Get device's mount point.
 *
 * @devname:		the device's name.
 * @mount_point:	the mount point.
 * @dir_path_len:	the length of directory.
 */
int get_mount_point(const char *devname, char *mount_point, int dir_path_len)
{
	/* Refer to /etc/mtab */
	char	*mtab = MOUNTED;
	FILE	*fp = NULL;
	struct mntent	*mnt = NULL;

	fp = setmntent(mtab, "r");
	if (fp == NULL) {
		perror(NGMSG_MTAB);
		return RETURN_NG;
	}

	while ((mnt = getmntent(fp)) != NULL) {
		if (strcmp(devname, mnt->mnt_fsname) != 0)
			continue;

		endmntent(fp);
		if (strcmp(mnt->mnt_type, FS_EXT4) == 0) {
			strncpy(mount_point, mnt->mnt_dir,
				dir_path_len);
			return RETURN_OK;
		}
		PRINT_ERR_MSG(NGMSG_EXT4);
		return RETURN_NG;
	}
	endmntent(fp);
	PRINT_ERR_MSG(NGMSG_UNMOUNT);
	return RETURN_NG;
}

/*
 * is_ext4() -		Whether on an ext4 filesystem.
 *
 * @filename:		the file's name.
 */
int is_ext4(const char *filename)
{
	int 	maxlen, len, ret;
	FILE	*fp = NULL;
	char	*mnt_type = NULL;
	/* Refer to /etc/mtab */
	char	*mtab = MOUNTED;
	char	file_path[PATH_MAX + 1];
	struct mntent	*mnt = NULL;
	struct statfs	buffs;

	/* Get full path */
	if (realpath(filename, file_path) == NULL) {
		perror(NGMSG_REALPATH);
		PRINT_FILE_NAME(filename);
		return RETURN_NG;
	}

	if (statfs(file_path, &buffs) < 0) {
		perror(NGMSG_FS_INFO);
		PRINT_FILE_NAME(filename);
		return RETURN_NG;
	}

	if (buffs.f_type != EXT4_SUPER_MAGIC) {
		PRINT_ERR_MSG(NGMSG_EXT4);
		return RETURN_NG;
	}

	fp = setmntent(mtab, "r");
	if (fp == NULL) {
		perror(NGMSG_MTAB);
		return RETURN_NG;
	}

	maxlen = 0;
	while ((mnt = getmntent(fp)) != NULL) {
		len = strlen(mnt->mnt_dir);
		ret = memcmp(file_path, mnt->mnt_dir, len);
		if (ret != 0)
			continue;

		if (maxlen >= len)
			continue;

		maxlen = len;

		mnt_type = realloc(mnt_type, strlen(mnt->mnt_type) + 1);
		if (!mnt_type) {
			endmntent(fp);
			return RETURN_NG;
		}
		strcpy(mnt_type, mnt->mnt_type);
		strncpy(lost_found_dir, mnt->mnt_dir, PATH_MAX);
	}

	endmntent(fp);
	if (strcmp(mnt_type, FS_EXT4) == 0) {
		FREE(mnt_type);
		return RETURN_OK;
	} else {
		FREE(mnt_type);
		PRINT_ERR_MSG(NGMSG_EXT4);
		return RETURN_NG;
	}
}

/*
 * calc_entry_counts() -	Calculate file counts.
 *
 * @file:		file name.
 * @buf:		file info.
 * @flag:		file type.
 * @ftwbuf:		the pointer of a struct FTW.
 */
int calc_entry_counts(const char *file, const struct stat64 *buf, int flag,
			struct FTW *ftwbuf)
{
	if (S_ISREG(buf->st_mode))
		regular_count++;

	total_count++;

	return FTW_CONT;
}

/*
 * page_in_core() -	Get information on whether pages are in core.
 *
 * @fd:			the file's descriptor.
 * @defrag_data:	data used for defrag.
 * @vec:		page state array.
 * @page_num:		page number.
 */
int page_in_core(int fd, struct move_extent defrag_data,
			unsigned char **vec, unsigned int *page_num)
{
	int	blocksize;
	int	pagesize = getpagesize();
	void	*page = NULL;
	loff_t	offset, end_offset, length;

	if (vec == NULL || *vec != NULL)
		return RETURN_NG;

	if (ioctl(fd, FIGETBSZ, &blocksize) < 0)
		return RETURN_NG;

	/* In mmap, offset should be a multiple of the page size */
	offset = (loff_t)defrag_data.start * blocksize;
	length = (loff_t)defrag_data.len * blocksize;
	end_offset = offset + length;
	/* Round the offset down to the nearest multiple of pagesize */
	offset = (offset / pagesize) * pagesize;
	length = end_offset - offset;

	page = mmap(NULL, length, PROT_READ, MAP_SHARED, fd, offset);
	if (page == MAP_FAILED)
		return RETURN_NG;

	*page_num = 0;
	*page_num = (length + pagesize - 1) / pagesize;
	*vec = (unsigned char *)calloc(*page_num, 1);
	if (*vec == NULL)
		return RETURN_NG;

	/* Get information on whether pages are in core */
	if (mincore(page, (size_t)length, *vec) == -1 ||
		munmap(page, length) == -1) {
		FREE(*vec);
		return RETURN_NG;
	}

	return RETURN_OK;
}

/*
 * defrag_fadvise() -	Predeclare an access pattern for file data.
 *
 * @fd:			the file's descriptor.
 * @defrag_data:	data used for defrag.
 * @vec:		page state array.
 * @page_num:		page number.
 */
int defrag_fadvise(int fd, struct move_extent defrag_data,
		   unsigned char *vec, unsigned int page_num)
{
	int	flag = 1;
	int	blocksize;
	int	pagesize = getpagesize();
	int	fadvise_flag = POSIX_FADV_DONTNEED;
	int	sync_flag = SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE|
			SYNC_FILE_RANGE_WAIT_AFTER;
	unsigned int	i;
	loff_t	offset;

	if (ioctl(fd, FIGETBSZ, &blocksize) < 0)
		return RETURN_NG;

	offset = (loff_t)defrag_data.start * blocksize;
	offset = (offset / pagesize) * pagesize;

	/* Sync file for fadvise process */
	if (sync_file_range(fd, offset,
		(loff_t)pagesize * page_num, sync_flag) != 0)
		return RETURN_NG;

	/* Try to release buffer cache which this process used,
	 * then other process can use the released buffer
	 */
	for (i = 0; i < page_num; i++) {
		if ((vec[i] & 0x1) == 0) {
			offset += pagesize;
			continue;
		}
		if (fadvise(fd, offset, pagesize, fadvise_flag) != 0) {
			if (detail_flag && flag) {
				perror(NGMSG_FADVISE_SYSCALL);
				flag = 0;
			}
		}
		offset += pagesize;
	}

	return RETURN_OK;
}

/*
 * check_free_size() -	Check if there's enough disk space.
 *
 * @fd:			the file's descriptor.
 * @file_name		file name.
 * @buf:		the pointer of the struct stat64.
 */
int check_free_size(int fd, const char *file_name, const struct stat64 *buf)
{
	ext4_fsblk_t	physical_block_count = 0;
	ext4_fsblk_t	free_physical_block_count = 0;
	struct statfs64	fsbuf;

	if (fstatfs64(fd, &fsbuf) < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file_name);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FS_INFO);
		}
		return RETURN_GFS_ERR;
	}

	/* Target file size measured by filesystem IO blocksize */
	physical_block_count = SECTOR_TO_BLOCK(buf->st_blocks, fsbuf.f_bsize);

	/* Compute free space for root and normal user separately */
	if (current_uid == ROOT_UID)
		free_physical_block_count = fsbuf.f_bfree;
	else
		free_physical_block_count = fsbuf.f_bavail;

	if (free_physical_block_count >= physical_block_count)
		return RETURN_OK;

	return RETURN_NG;
}

/*
 * file_frag_count() -	Get file fragment count.
 *
 * @fd:			the file's descriptor.
 */
int file_frag_count(int fd)
{
	int	ret = RETURN_NG;
	struct fiemap	file_extent_map;

	/* When fm_extent_count is 0,
	 * ioctl just get file fragment count.
	 */
	memset(&file_extent_map, 0, sizeof(struct fiemap));
	file_extent_map.fm_start = 0;
	file_extent_map.fm_length = FIEMAP_MAX_OFFSET;
	file_extent_map.fm_flags |= FIEMAP_FLAG_SYNC;

	ret = ioctl(fd, FS_IOC_FIEMAP, &file_extent_map);
	if (ret < 0)
		return RETURN_NG;

	return file_extent_map.fm_mapped_extents;
}

/*
 * file_check() -	Check file's attributes.
 *
 * @fd:			the file's descriptor.
 * @buf:		a pointer of the struct stat64.
 * @file_name:		the file's name.
 * @extents:		the file's extents.
 */
int file_check(int fd, const struct stat64 *buf, const char *file_name,
		int extents)
{
	int	ret;
	struct flock	lock;

	/* Write-lock check is more reliable */
	lock.l_type = F_WRLCK;
	lock.l_start = 0;
	lock.l_whence = SEEK_SET;
	lock.l_len = 0;

	/* Free space */
	ret = check_free_size(fd, file_name, buf);
	if (ret == RETURN_NG) {
		if (detail_flag) {
			printf("\033[79;0H\033[K[%u/%u] \"%s\"\t\t"
				"  extents: %d -> %d\n", defraged_file_count,
				total_count, file_name, extents, extents);
			IN_FTW_PRINT_ERR_MSG(NGMSG_FILE_LARGE);
		}
		return RETURN_NG;
	} else if (ret == RETURN_GFS_ERR)
		return RETURN_NG;

	/* Access authority */
	if (current_uid != ROOT_UID &&
		buf->st_uid != current_uid) {
		if (detail_flag) {
			printf("\033[79;0H\033[K[%u/%u] \"%s\"\t\t"
				"  extents: %d -> %d\n", defraged_file_count,
				total_count, file_name, extents, extents);
			IN_FTW_PRINT_ERR_MSG(NGMSG_FILE_AUTHORITY);
		}
		return RETURN_NG;
	}

	/* Lock status */
	if (fcntl(fd, F_GETLK, &lock) < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file_name);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_GET_LCKINFO);
		}
		return RETURN_NG;
	} else if (lock.l_type != F_UNLCK) {
		if (detail_flag) {
			PRINT_FILE_NAME(file_name);
			IN_FTW_PRINT_ERR_MSG(NGMSG_FILE_LOCK);
		}
		return RETURN_NG;
	}

	/* Empty file */
	if (buf->st_size == 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file_name);
			IN_FTW_PRINT_ERR_MSG(NGMSG_FILE_BLANK);
		}
		return RETURN_NG;
	}

	return RETURN_OK;
}

/*
 * insert_extent() -	Sequentially insert extent.
 *
 * @extlist_head:	the head of an extent list.
 * @ext:		the extent element which will be inserted.
 */
int insert_extent(struct fiemap_extent_list **extlist_head,
			struct fiemap_extent_list *ext)
{
	struct fiemap_extent_list	*ext_tmp = *extlist_head;

	if (ext == NULL)
		goto out;

	/* First element */
	if (*extlist_head == NULL) {
		(*extlist_head) = ext;
		(*extlist_head)->prev = *extlist_head;
		(*extlist_head)->next = *extlist_head;
		return RETURN_OK;
	}

	if (ext->data.logical <= ext_tmp->data.logical) {
		/* Insert before head */
		if (ext_tmp->data.logical < ext->data.logical + ext->data.len)
			/* Overlap */
			goto out;
		/* Adjust head */
		*extlist_head = ext;
	} else {
		/* Insert into the middle or last of the list */
		do {
			if (ext->data.logical < ext_tmp->data.logical)
				break;
			ext_tmp = ext_tmp->next;
		} while (ext_tmp != (*extlist_head));
		if (ext->data.logical <
		    ext_tmp->prev->data.logical + ext_tmp->prev->data.len)
			/* Overlap */
			goto out;

		if (ext_tmp != *extlist_head &&
		    ext_tmp->data.logical < ext->data.logical + ext->data.len)
			/* Overlap */
			goto out;
	}
	ext_tmp = ext_tmp->prev;
	/* Insert "ext" after "ext_tmp" */
	insert(ext_tmp, ext);
	return RETURN_OK;
out:
	errno = EINVAL;
	return RETURN_NG;
}

/*
 * insert_exts_group() -	Insert a exts_group.
 *
 * @exts_group_list_head:	the head of a exts_group list.
 * @exts_group:			the exts_group element which will be inserted.
 */
int insert_exts_group(struct fiemap_extent_group **exts_group_list_head,
				struct fiemap_extent_group *exts_group)
{
	struct fiemap_extent_group	*exts_group_tmp = NULL;

	if (exts_group == NULL) {
		errno = EINVAL;
		return RETURN_NG;
	}

	/* Initialize list */
	if (*exts_group_list_head == NULL) {
		(*exts_group_list_head) = exts_group;
		(*exts_group_list_head)->prev = *exts_group_list_head;
		(*exts_group_list_head)->next = *exts_group_list_head;
		return RETURN_OK;
	}

	exts_group_tmp = (*exts_group_list_head)->prev;
	insert(exts_group_tmp, exts_group);

	return RETURN_OK;
}

/*
 * join_extents() -		Find continuous region(exts_group).
 *
 * @ext_list_head:		the head of the extent list.
 * @exts_group_list_head:	the head of the target exts_group list.
 */
int join_extents(struct fiemap_extent_list *ext_list_head,
		struct fiemap_extent_group **exts_group_list_head)
{
	ext4_lblk_t	len;
	struct fiemap_extent_list	*ext_start, *extent_tmp;

	ext_start = ext_list_head;
	extent_tmp = ext_list_head;
	len = ext_list_head->data.len;
	extent_tmp = extent_tmp->next;

	do {
		struct fiemap_extent_group	*exts_group_tmp = NULL;

		/* This extent and previous extent are not continuous,
		 * so, all previous extents are treated as an extent group.
		 */
		if ((extent_tmp->prev->data.logical +
			extent_tmp->prev->data.len)
				!= extent_tmp->data.logical) {
			exts_group_tmp =
				malloc(sizeof(struct fiemap_extent_group));
			if (exts_group_tmp == NULL)
				return RETURN_NG;

			memset(exts_group_tmp, 0,
				sizeof(struct fiemap_extent_group));
			exts_group_tmp->len = len;
			exts_group_tmp->start = ext_start;
			exts_group_tmp->end = extent_tmp->prev;

			if (insert_exts_group(exts_group_list_head,
				exts_group_tmp) < 0) {
				FREE(exts_group_tmp);
				return RETURN_NG;
			}
			ext_start = extent_tmp;
			len = extent_tmp->data.len;
			extent_tmp = extent_tmp->next;
			continue;
		}

		/* This extent and previous extent are continuous,
		 * so, they belong to the same extent group, and we check
		 * if the next extent belongs to the same extent group.
		 */
		len += extent_tmp->data.len;
		extent_tmp = extent_tmp->next;
	} while (extent_tmp != ext_list_head->next);

	return RETURN_OK;
}

/*
 * get_file_extents() -	Get file extent in the block group.
 *
 * @fd:			the file's descriptor.
 * @ext_list_head:	the head of the extent list.
 */
int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
{
	int	i;
	int	ret = 0;
	int	blocksize;
	int	extents_buffer_size, fiemap_buffer_size;
	__u64	pos = 0;
	struct fiemap	*fiemap_buf = NULL;
	struct fiemap_extent	*extents_buf = NULL;
	struct fiemap_extent_list	*extent = NULL;

	ret = ioctl(fd, FIGETBSZ, &blocksize);
	if (ret < 0)
		return RETURN_NG;

	/* Convert units, in bytes.
	 * Be careful : now, physical block number in extent is 48bit,
	 * and the maximum blocksize for ext4 is 4K(12bit),
	 * so there is no overflow, but in future it may be changed.
	 */

	/* Alloc space for fiemap */
	extents_buffer_size = EXTENT_MAX_COUNT * sizeof(struct fiemap_extent);
	fiemap_buffer_size = sizeof(struct fiemap) + extents_buffer_size;

	fiemap_buf = malloc(fiemap_buffer_size);
	if (!fiemap_buf)
		return RETURN_NG;

	extents_buf = fiemap_buf->fm_extents;
	memset(fiemap_buf, 0, fiemap_buffer_size);
	fiemap_buf->fm_length = FIEMAP_MAX_OFFSET;
	fiemap_buf->fm_flags |= FIEMAP_FLAG_SYNC;
	fiemap_buf->fm_extent_count = EXTENT_MAX_COUNT;

	pos = 0;
	do {
		fiemap_buf->fm_start = pos;
		memset(extents_buf, 0, extents_buffer_size);
		ret = ioctl(fd, FS_IOC_FIEMAP, fiemap_buf);
		if (ret < 0)
			goto out;
		for (i = 0; i < fiemap_buf->fm_mapped_extents; i++) {
			extent = NULL;
			extent = malloc(sizeof(struct fiemap_extent_list));
			if (extent == NULL)
				goto out;
			/*
			 * Restriction for uninitialized extent file.
			 * This will be gone away, soon.
			 */
			if (extents_buf[i].fe_flags & FIEMAP_EXTENT_UNWRITTEN) {
				FREE(extent);
				FREE(fiemap_buf);
				return RETURN_UNINIT_EXT_ERR;
			}
			extent->data.physical = extents_buf[i].fe_physical
						/ blocksize;
			extent->data.logical = extents_buf[i].fe_logical
						/ blocksize;
			extent->data.len = extents_buf[i].fe_length
						/ blocksize;
			ret = insert_extent(ext_list_head, extent);
			if (ret < 0) {
				FREE(extent);
				goto out;
			}
		}
			/* Record file's logical offset this time */
		pos = extents_buf[EXTENT_MAX_COUNT-1].fe_logical +
			extents_buf[EXTENT_MAX_COUNT-1].fe_length;
		/* If fm_extents array has been filled and
		 * there are extents left, continue to cycle.
		 */
	} while (fiemap_buf->fm_mapped_extents
					== EXTENT_MAX_COUNT &&
		!(extents_buf[EXTENT_MAX_COUNT-1].fe_flags
					& FIEMAP_EXTENT_LAST));

	FREE(fiemap_buf);
	return RETURN_OK;
out:
	FREE(fiemap_buf);
	return RETURN_NG;
}

/*
 * free_ext() -		Free the extent list.
 *
 * @extent_list_head:	the extent list head of which will be free.
 */
void free_ext(struct fiemap_extent_list *extent_list_head)
{
	struct fiemap_extent_list	*extent_tmp = NULL;

	if (extent_list_head == NULL)
		return;

	while (extent_list_head->next != extent_list_head) {
		extent_tmp = extent_list_head;
		extent_list_head->prev->next = extent_list_head->next;
		extent_list_head->next->prev = extent_list_head->prev;
		extent_list_head = extent_list_head->next;
		free(extent_tmp);
	}
	free(extent_list_head);
}

/*
 * free_exts_group() -		Free the exts_group.
 *
 * @*exts_group_list_head:	the exts_group list head which will be free.
 */
 void free_exts_group(struct fiemap_extent_group *exts_group_list_head)
{
	struct fiemap_extent_group	*exts_group_tmp = NULL;

	if (exts_group_list_head == NULL)
		return;

	while (exts_group_list_head->next != exts_group_list_head) {
		exts_group_tmp = exts_group_list_head;
		exts_group_list_head->prev->next = exts_group_list_head->next;
		exts_group_list_head->next->prev = exts_group_list_head->prev;
		exts_group_list_head = exts_group_list_head->next;
		free(exts_group_tmp);
	}
	free(exts_group_list_head);
}

/*
 * statistic_fn() -	Get statistic info of the file's fragments.
 *
 * @file:		the file's name.
 * @buf:		the pointer of the struct stat64.
 * @flag:		file type.
 * @ftwbuf:		the pointer of a struct FTW.
 */
int statistic_fn(const char *file, const struct stat64 *buf, int flag,
			struct FTW *ftwbuf)
{
	int	fd;
	int	blocksize;
	int	ret = 0;
	int	now_extents_count, best_extents_count;
	int	i, j;
	float	ratio = 0.0;
	ext4_fsblk_t	physical_block_count = 0;
	char	msg_buffer[PATH_MAX + 24];

	defraged_file_count++;

	if (detail_flag) {
		if (total_count == 1 && regular_count == 1)
			printf("<File>\n");
		else {
			printf("[%u/%u]", defraged_file_count, total_count);
			fflush(stdout);
		}
	}
	if (lost_found_dir[0] != '\0' &&
	    !memcmp(file, lost_found_dir, strnlen(lost_found_dir, PATH_MAX))) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			STATISTIC_ERR_MSG(NGMSG_LOST_FOUND);
		}
			return FTW_CONT;
	}

	if (!S_ISREG(buf->st_mode)) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			STATISTIC_ERR_MSG(NGMSG_FILE_UNREG);
		}
		return FTW_CONT;
	}

	/* Access authority */
	if (current_uid != ROOT_UID &&
		buf->st_uid != current_uid) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			STATISTIC_ERR_MSG(NGMSG_FILE_AUTHORITY);
		}
		return FTW_CONT;
	}

	/* Empty file */
	if (buf->st_size == 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			STATISTIC_ERR_MSG(NGMSG_FILE_BLANK);
		}
		return FTW_CONT;
	}

	fd = open64(file, O_RDONLY);
	if (fd < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
		}
		return FTW_CONT;
	}

	/* Get blocksize */
	ret = ioctl(fd, FIGETBSZ, &blocksize);
	if (ret < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_BLOCKSIZE);
		}
		goto out;
	}

	/* Count file fragments before defrag */
	now_extents_count = file_frag_count(fd);
	if (now_extents_count == RETURN_NG) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_INFO);
		}
		goto out;
	}

	physical_block_count = SECTOR_TO_BLOCK(buf->st_blocks, blocksize);
	best_extents_count = ((physical_block_count - 1) /
					CALC_BLKS_PER_GROUP(blocksize)) + 1;
	ratio = (float)(now_extents_count - best_extents_count) * 100 /
						physical_block_count;

	extents_before_defrag += now_extents_count;
	extents_after_defrag += best_extents_count;
	files_block_count += physical_block_count;

	if (total_count == 1 && regular_count == 1) {
		/* File only */
		if (detail_flag) {
			int count = 0;
			struct fiemap_extent_list *file_extlist_head = NULL;
			struct fiemap_extent_list *extent_tmp = NULL;

			ret = get_file_extents(fd, &file_extlist_head);
			if (ret < 0) {
				PRINT_FILE_NAME(file);
				STATISTIC_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
				free_ext(file_extlist_head);
				goto out;
			}

			extent_tmp = file_extlist_head;
			/* Print extents info */
			do {
				count++;
				printf("[ext %d]:\tstart %llu:\tlogical "
						"%u:\tlen %u\n", count,
						extent_tmp->data.physical,
						extent_tmp->data.logical,
						extent_tmp->data.len);
				extent_tmp = extent_tmp->next;
			} while (extent_tmp != file_extlist_head);

			free_ext(file_extlist_head);
		} else {
			printf("%-40s%10s/%-10s%9s\n",
					"<File>", "now", "best", "ratio");
			if (strlen(file) > 40)
				printf("%s\n%50d/%-10d%8.2f%%\n",
						file, now_extents_count,
						best_extents_count, ratio);
			else
				printf("%-40s%10d/%-10d%8.2f%%\n",
						file, now_extents_count,
						best_extents_count, ratio);
		}
		succeed_cnt++;
		goto out;
	}

	if (detail_flag) {
		/* Print statistic info */
		sprintf(msg_buffer, "[%u/%u]%s",
				defraged_file_count, total_count, file);
		if (strlen(msg_buffer) > 40)
			printf("\033[79;0H\033[K%s\n%50d/%-10d%8.2f%%\n",
					msg_buffer, now_extents_count,
						best_extents_count, ratio);
		else
			printf("\033[79;0H\033[K%-40s%10d/%-10d%8.2f%%\n",
					msg_buffer, now_extents_count,
						best_extents_count, ratio);
	}

	for (i = 0; i <= 4; i++) {
		if (ratio >= sta_array[i].ratio) {
			for (j = 4; j > i; j--) {
				memcpy(&sta_array[j], &sta_array[j - 1],
						sizeof(struct statistic_ino));
			}
			memset(&sta_array[i], 0, sizeof(struct statistic_ino));
			strncpy(sta_array[i].msg_buffer, file,
						strnlen(file, PATH_MAX));
			sta_array[i].now_count = now_extents_count;
			sta_array[i].best_count = best_extents_count;
			sta_array[i].ratio = ratio;
			break;
		}
	}

	succeed_cnt++;

out:
	close(fd);
	return FTW_CONT;
}

/*
 * file_defrag() -	Execute the defrag program.
 *
 * @fd:			the target file's descriptor.
 * @tmp_fd:		the temp file's descriptor.
 * @file_name:		file name.
 * @buf:		the pointer of the struct stat64.
 * @ext_group_head:	the head of the extent group list.
 */
int file_defrag(int fd, int tmp_fd, const char *file_name,
	const struct stat64 *buf, struct fiemap_extent_group *ext_group_head)
{
	loff_t	start = 0;
	unsigned int	page_num;
	unsigned char	*vec = NULL;
	ext4_lblk_t	move_len, default_len;
	int	defraged_size = 0;
	int	percent = 0;
	int	ret;
	struct move_extent	move_data;
	struct fiemap_extent_group	*ext_group_tmp = NULL;

	memset(&move_data, 0, sizeof(struct move_extent));
	move_data.org_fd = fd;
	move_data.dest_fd = tmp_fd;

	/* Print process progress */
	percent = (start * 100) / buf->st_size;
	printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
		defraged_file_count, total_count, file_name, min(percent, 100));
	fflush(stdout);

	default_len = (DEFRAG_SIZE + buf->st_blksize - 1) / buf->st_blksize;
	ext_group_tmp = ext_group_head;
	do {
		move_len = ext_group_tmp->len;
		move_data.start = ext_group_tmp->start->data.logical;

		while (move_len > 0) {
			if (move_len <= default_len) {
				move_data.len = move_len;
				move_len = 0;
			} else {
				move_data.len = default_len;
				move_len -= default_len;
			}

			ret = page_in_core(fd, move_data, &vec, &page_num);
			if (ret < 0) {
				if (detail_flag) {
					printf("\n");
					PRINT_ERR_MSG_WITH_ERRNO(
							NGMSG_FILE_MAP);
				} else {
					printf("\t[ NG ]\n");
				}
				return RETURN_NG;
			}

			/* EXT4_IOC_DEFRAG */
			defraged_size = ioctl(fd, EXT4_IOC_DEFRAG, &move_data);

			/* Free pages */
			ret = defrag_fadvise(fd, move_data, vec, page_num);
			if (vec) {
				free(vec);
				vec = NULL;
			}
			if (ret < 0) {
				if (detail_flag) {
					printf("\n");
					PRINT_ERR_MSG_WITH_ERRNO(
						NGMSG_FILE_DROP_BUFFER);
				} else {
					printf("\t[ NG ]\n");
				}
				return RETURN_NG;
			}

			if (defraged_size < 0) {
				if (detail_flag) {
					printf("\n");
					PRINT_ERR_MSG_WITH_ERRNO(
							NGMSG_FILE_DEFRAG);
				} else {
					printf("\t[ NG ]\n");
				}
				return RETURN_NG;
			}
			move_data.start += defraged_size;
			start = (loff_t)move_data.start * buf->st_blksize;

			/* Print process progress */
			percent = (start * 100) / buf->st_size;
			printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
				defraged_file_count, total_count, file_name,
					min(percent, 100));
			fflush(stdout);
		}

		/* End of file */
		if (start >= buf->st_size)
			break;

		ext_group_tmp = ext_group_tmp->next;
	} while (ext_group_tmp != ext_group_head);

	return RETURN_OK;
}

/*
 * ftw_fn() -		Check file attributes and call ioctl to defrag.
 *
 * @file:		the file's name.
 * @buf:		the pointer of the struct stat64.
 * @flag:		file type.
 * @ftwbuf:		the pointer of a struct FTW.
 */
int ftw_fn(const char *file, const struct stat64 *buf, int flag,
	   struct FTW *ftwbuf)
{
	int	fd;
	int	tmp_fd = -1;
	int	blocksize;
	int	defrag_fail = 0;
	int	ret = RETURN_NG;
	int	best;
	int	file_frags_start, file_frags_end, tmp_ext_count;
	char	tmp_inode_name[PATH_MAX + 8];
	struct fiemap_extent_list	*ext_list_head = NULL;
	struct fiemap_extent_group	*ext_group_head = NULL;
	struct fiemap_extent_group	*ext_group_tmp = NULL;

	defraged_file_count++;

	if (detail_flag) {
		printf("[%u/%u]", defraged_file_count, total_count);
		fflush(stdout);
	}

	if (lost_found_dir[0] != '\0' &&
	    !memcmp(file, lost_found_dir, strnlen(lost_found_dir, PATH_MAX))) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			IN_FTW_PRINT_ERR_MSG(NGMSG_LOST_FOUND);
		}
		return FTW_CONT;
	}

	if (!S_ISREG(buf->st_mode)) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			IN_FTW_PRINT_ERR_MSG(NGMSG_FILE_UNREG);
		}
		return FTW_CONT;
	}

	fd = open64(file, O_RDONLY);
	if (fd < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
		}
		return FTW_CONT;
	}

	/* Count file fragments before defrag */
	file_frags_start = file_frag_count(fd);
	if (file_frags_start == RETURN_NG) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_INFO);
		}
		goto out;
	}

	if (file_check(fd, buf, file, file_frags_start) == RETURN_NG)
		goto out;

	if (fsync(fd) < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_SYNC);
		}
		goto out;
	}

	/* Get blocksize */
	if (ioctl(fd, FIGETBSZ, &blocksize) < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_BLOCKSIZE);
		}
		goto out;
	}

	best = (SECTOR_TO_BLOCK(buf->st_blocks, blocksize) - 1)
			/ CALC_BLKS_PER_GROUP(blocksize) + 1;

	if (file_frags_start == best)
		goto check_improvement;

	/* Get file's extents */
	ret = get_file_extents(fd, &ext_list_head);
	if (ret < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			if (ret == RETURN_UNINIT_EXT_ERR)
				IN_FTW_PRINT_ERR_MSG(NGMSG_UNINIT_EXTENT);
			else
				PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
		}
		goto out;
	}

	/* Combine extents to group */
	ret = join_extents(ext_list_head, &ext_group_head);
	if (ret < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
		}
		goto out;
	}

	/* Create donor inode */
	memset(tmp_inode_name, 0, PATH_MAX + 8);
	sprintf(tmp_inode_name, "%.*s.defrag",  strnlen(file, PATH_MAX), file);
	tmp_fd = open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR);
	if (tmp_fd < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			if (errno == EEXIST)
				PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_IN_DEFRAG);
			else
				PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
		}
		goto out;
	}

	/* Unlink donor inode */
	ret = unlink(tmp_inode_name);
	if (ret < 0) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_UNLINK);
		}
		goto out;
	}

	/* Allocate space for donor inode */
	ext_group_tmp = ext_group_head;
	do {
		ret = fallocate(tmp_fd, 0,
			(loff_t)ext_group_tmp->start->data.logical * blocksize,
			(loff_t)ext_group_tmp->len * blocksize);
		if (ret < 0) {
			if (detail_flag) {
				PRINT_FILE_NAME(file);
				PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_FALLOC);
			}
		goto out;
		}

		ext_group_tmp = ext_group_tmp->next;
	} while (ext_group_tmp != ext_group_head);

	/* Get donor inode's extents count */
	tmp_ext_count = file_frag_count(tmp_fd);
	if (tmp_ext_count == RETURN_NG) {
		if (detail_flag) {
			PRINT_FILE_NAME(file);
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_INFO);
		}
		goto out;
	}

check_improvement:
	if (detail_flag) {
		if (file_frags_start != 1)
			frag_files_before_defrag++;

		extents_before_defrag += file_frags_start;
	}

	if (file_frags_start == best ||	file_frags_start <= tmp_ext_count) {
		printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
			defraged_file_count, total_count, file, 100);
		if (detail_flag)
			printf("  extents: %d -> %d",
				file_frags_start, file_frags_start);

		printf("\t[ OK ]\n");
		succeed_cnt++;

		if (file_frags_start != 1)
			frag_files_after_defrag++;

		extents_after_defrag += file_frags_start;
		goto out;
	}

	/* Defrag the file */
	ret = file_defrag(fd, tmp_fd, file, buf, ext_group_head);
	if (ret < 0)
		defrag_fail = 1;

	/* Count file fragments after defrag and print extents info */
	if (detail_flag) {
		file_frags_end = file_frag_count(fd);
		if (file_frags_end == RETURN_NG) {
			printf("\n");
			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_INFO);
			goto out;
		}

		if (file_frags_end != 1)
			frag_files_after_defrag++;

		extents_after_defrag += file_frags_end;

		if (defrag_fail)
			goto out;

		printf("  extents: %d -> %d",
			file_frags_start, file_frags_end);
		fflush(stdout);
	}

	if (defrag_fail)
		goto out;

	printf("\t[ OK ]\n");
	fflush(stdout);
	succeed_cnt++;

out:
	close(fd);
	if (tmp_fd != -1)
		close(tmp_fd);
	free_ext(ext_list_head);
	free_exts_group(ext_group_head);
	return FTW_CONT;
}

/*
 * main() -		Ext4 online defrag.
 *
 * @argc:		the number of parameter.
 * @argv[]:		the pointer array of parameter.
 */
int main(int argc, char *argv[])
{
	int	opt;
	int	i, j, flags;
	int	arg_type;
	int	detail_tmp;
	int	success_flag;
	char	dir_name[PATH_MAX + 1];
	struct stat64	buf;

	i = 1;
	flags = 0;
	arg_type = -1;
	detail_tmp = -1;
	success_flag = 0;
	/* Do not follow symlink */
	flags |= FTW_PHYS;
	/* Stay within the same filesystem */
	flags |= FTW_MOUNT;

	/* Parse arguments */
	if (argc == 1 || (argc == 2 && argv[1][0] == '-'))
		goto out;

	current_uid = getuid();

	while ((opt = getopt(argc, argv, "vc")) != EOF) {
		switch (opt) {
		case 'v':
			detail_flag = 1;
			i = 2;
			break;
		case 'c':
			statistic_flag = 1;
			i = 2;
			break;
		default:
			goto out;
		}
	}

	/* Main process */
	for (; i < argc; i++) {
		succeed_cnt = 0;
		regular_count = 0;
		total_count = 0;
		frag_files_before_defrag = 0;
		frag_files_after_defrag = 0;
		extents_before_defrag = 0;
		extents_after_defrag = 0;
		defraged_file_count = 0;
		files_block_count = 0;

		memset(dir_name, 0, PATH_MAX + 1);
		memset(lost_found_dir, 0, PATH_MAX + 1);
		memset(sta_array, 0, sizeof(struct statistic_ino) * 5);

		if (statistic_flag && i > 2)
			printf("\n");

		if (lstat64(argv[i], &buf) < 0) {
			perror(NGMSG_FILE_INFO);
			PRINT_FILE_NAME(argv[i]);
			continue;
		}

		if (S_ISBLK(buf.st_mode)) {
			/* Block device */
			if (get_mount_point(argv[i], dir_name, PATH_MAX)
							== RETURN_NG)
				continue;
			arg_type = DEVNAME;
			if (!statistic_flag)
				printf("ext4 defragmentation for device(%s)\n",
					argv[i]);
		} else if (S_ISDIR(buf.st_mode)) {
			/* Directory */
			if (access(argv[i], R_OK) < 0) {
				perror(argv[i]);
				continue;
			}
			arg_type = DIRNAME;
			strcpy(dir_name, argv[i]);
		} else if (S_ISREG(buf.st_mode)) {
			/* Regular file */
			arg_type = FILENAME;
		} else {
			/* Irregular file */
			PRINT_ERR_MSG(NGMSG_FILE_UNREG);
			PRINT_FILE_NAME(argv[i]);
			continue;
		}

		/* For device case,
		 * filesystem type checked in get_mount_point()
		 */
		if (arg_type == FILENAME || arg_type == DIRNAME) {
			if (is_ext4(argv[i]) == RETURN_NG)
				continue;
			if (realpath(argv[i], dir_name) == NULL) {
				perror(NGMSG_REALPATH);
				PRINT_FILE_NAME(argv[i]);
				continue;
			}
		}

		switch (arg_type) {
		case DIRNAME:
			if (!statistic_flag)
				printf("ext4 defragmentation "
					"for directory(%s)\n", argv[i]);

			int mount_dir_len = 0;
			mount_dir_len = strnlen(lost_found_dir, PATH_MAX);

			strncat(lost_found_dir, "/lost+found",
				PATH_MAX - strnlen(lost_found_dir, PATH_MAX));

			/* Not the case("e4defrag  mount_piont_dir") */
			if (dir_name[mount_dir_len] != '\0') {
				/* "e4defrag mount_piont_dir/lost+found"
				 * or "e4defrag mount_piont_dir/lost+found/"
				 */
				if (strncmp(lost_found_dir, dir_name,
					    strnlen(lost_found_dir,
						    PATH_MAX)) == 0 &&
				    (dir_name[strnlen(lost_found_dir,
						      PATH_MAX)] == '\0' ||
				     dir_name[strnlen(lost_found_dir,
						      PATH_MAX)] == '/')) {
					PRINT_ERR_MSG(NGMSG_LOST_FOUND);
					PRINT_FILE_NAME(argv[i]);
					continue;
				}

				/* "e4defrag mount_piont_dir/else_dir" */
				memset(lost_found_dir, 0, PATH_MAX + 1);
			}
		case DEVNAME:
			if (arg_type == DEVNAME) {
				strncpy(lost_found_dir, dir_name,
					strnlen(dir_name, PATH_MAX));
				strncat(lost_found_dir, "/lost+found/",
					PATH_MAX - strnlen(lost_found_dir,
							   PATH_MAX));
			}

			nftw64(dir_name, calc_entry_counts, FTW_OPEN_FD, flags);

			if (statistic_flag) {
				if (detail_flag)
					printf("%-40s%10s/%-10s%9s\n",
					"<File>", "now", "best", "ratio");
				nftw64(dir_name, statistic_fn,
							FTW_OPEN_FD, flags);

				if (succeed_cnt != 0) {
					if (detail_flag)
						printf("\n");
					printf("%-40s%10s/%-10s%9s\n",
						"<Fragmented files>", "now",
						"best", "ratio");
					for (j = 0; j <= 4; j++) {
						if (strlen(sta_array[j].
							msg_buffer) > 37) {
							printf("%d. %s\n%50d/"
							"%-10d%8.2f%%\n", j + 1,
							sta_array[j].msg_buffer,
							sta_array[j].now_count,
							sta_array[j].best_count,
							sta_array[j].ratio);
						} else if (strlen(sta_array[j].
							msg_buffer) > 0) {
							printf("%d. %-37s%10d/"
							"%-10d%8.2f%%\n", j + 1,
							sta_array[j].msg_buffer,
							sta_array[j].now_count,
							sta_array[j].best_count,
							sta_array[j].ratio);
						} else
							break;
					}
				}
				break;
			}
			/* File tree walk */
			nftw64(dir_name, ftw_fn, FTW_OPEN_FD, flags);
			printf("\n\tSuccess:\t\t\t[ %u/%u ]\n", succeed_cnt,
				total_count);
			printf("\tFailure:\t\t\t[ %u/%u ]\n",
				total_count - succeed_cnt, total_count);
			if (detail_flag) {
				printf("\tTotal extents:\t\t\t%4d->%d\n",
					extents_before_defrag,
					extents_after_defrag);
				printf("\tFragmented percentage:\t\t"
					"%3llu%%->%llu%%\n",
					!regular_count ? 0 :
					((unsigned long long)
					frag_files_before_defrag * 100) /
					regular_count,
					!regular_count ? 0 :
					((unsigned long long)
					frag_files_after_defrag * 100) /
					regular_count);
			}
			break;
		case FILENAME:
			total_count = 1;
			regular_count = 1;
			strncat(lost_found_dir, "/lost+found/",
				PATH_MAX - strnlen(lost_found_dir,
						   PATH_MAX));
			if (strncmp(lost_found_dir, dir_name,
				    strnlen(lost_found_dir,
					    PATH_MAX)) == 0) {
				PRINT_ERR_MSG(NGMSG_LOST_FOUND);
				PRINT_FILE_NAME(argv[i]);
				continue;
			}

			if (statistic_flag) {
				statistic_fn(argv[i], &buf, FTW_F, NULL);
				break;
			} else
				printf("ext4 defragmentation for %s\n",
								 argv[i]);
			/* Defrag single file process */
			ftw_fn(argv[i], &buf, FTW_F, NULL);
			if (succeed_cnt != 0)
				printf(" Success:\t\t\t[1/1]\n");
			else
				printf(" Success:\t\t\t[0/1]\n");

			break;
		}

		if (succeed_cnt != 0)
			success_flag = 1;
		if (statistic_flag) {
			if (!succeed_cnt) {
				if (detail_flag)
					printf("\n");

				if (arg_type == DEVNAME)
					printf(" In this device(%s), "
					"none can be defragmented.\n", argv[i]);
				else if (arg_type == DIRNAME)
					printf(" In this directory(%s), "
					"none can be defragmented.\n", argv[i]);
				else
					printf(" This file(%s) "
					"can't be defragmented.\n", argv[i]);
			} else {
				float files_ratio = 0.0;
				float score = 0.0;
				files_ratio = (float)(extents_before_defrag -
						extents_after_defrag) *
						100 / files_block_count;
				score = CALC_SCORE(files_ratio);
				printf("\n Total/best extents\t\t\t\t%d/%d\n"
					" Fragmentation ratio\t\t\t\t%.2f%%\n"
					" Fragmentation score\t\t\t\t%.2f\n",
						extents_before_defrag,
						extents_after_defrag,
						files_ratio, score);
				printf(" [0-30 no problem:"
					" 31-55 a little bit fragmented:"
					" 55- needs defrag]\n");

				if (arg_type == DEVNAME)
					printf(" This device(%s) ", argv[i]);
				else if (arg_type == DIRNAME)
					printf(" This directory(%s) ", argv[i]);
				else
					printf(" This file(%s) ", argv[i]);

				if (score > DEFAULT_SCORE)
					printf("needs defragmentation.\n");
				else
					printf("does not need "
							"defragmentation.\n");
			}
		}

	}

	if (success_flag)
		return RETURN_OK;

	exit(1);

out:
	printf(MSG_USAGE);
	exit(1);
}
