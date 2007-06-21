From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 10/10] Online defrag command
Date: Thu, 21 Jun 2007 10:56:43 +0900
Message-ID: <20070621105643t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39911 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbXFUB4o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 21:56:44 -0400
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.197])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l5L1uhaB024688
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:56:43 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l5L1ugw00260 for linux-ext4@vger.kernel.org; Thu, 21 Jun 2007 10:56:42 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l5L1ugo03698 for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:56:42 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070621.105641.45302168 for <linux-ext4@vger.kernel.org>
	; Thu, 21 Jun 2007 10:56:41 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- The defrag command.  Usage is as follows:
  o Put the multiple files closer together.
    # e4defrag -r directory-name
  o Defrag for free space fragmentation.
    # e4defrag -f file-name
  o Defrag for a single file.
    # e4defrag file-name
  o Defrag for all files on ext4.
    # e4defrag device-name

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
/*
 * e4defrag.c - ext4 filesystem defragmenter
 */

#ifndef _LARGEFILE_SOURCE
#define _LARGEFILE_SOURCE
#endif

#ifndef _LARGEFILE64_SOURCE
#define _LARGEFILE64_SOURCE
#endif

#define _XOPEN_SOURCE	500
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

#define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)
#define EXT4_IOC_GROUP_INFO	_IOW('f', 11, struct ext4_group_data_info)
#define EXT4_IOC_FREE_BLOCKS_INFO _IOW('f', 12, struct ext4_extents_info)
#define EXT4_IOC_EXTENTS_INFO	_IOW('f', 13, struct ext4_extents_info)
#define EXT4_IOC_RESERVE_BLOCK	_IOW('f', 14, struct ext4_extents_info)
#define EXT4_IOC_MOVE_VICTIM	_IOW('f', 15, struct ext4_extents_info)
#define EXT4_IOC_BLOCK_RELEASE	_IO('f', 16)


#define _FILE_OFFSET_BITS 64
#define ext4_fsblk_t	unsigned long long
#define DEFRAG_MAX_ENT	32

/* Extent status which are used in ext_in_group */
#define EXT4_EXT_USE		0
#define EXT4_EXT_FREE		1
#define EXT4_EXT_RESERVE	2

/* Insert list2 after list1 */
#define insert(list1,list2) { list2 ->next = list1->next;\
						list1->next->prev = list2;\
						list2->prev = list1;\
						list1->next = list2;\
}

#define DEFRAG_RESERVE_BLOCK_SECOND	2

/* Magic number for ext4 */
#define EXT4_SUPER_MAGIC	0xEF53

/* The number of pages to defrag at one time */
#define DEFRAG_PAGES    	128

/* Maximum length of contiguous blocks */
#define MAX_BLOCKS_LEN  	16384

/* Force defrag mode: Max file size in bytes (128MB) */
#define	MAX_FILE_SIZE		(unsigned long)1 << 27

/* Force defrag mode: Max filesystem relative offset (48bit) */
#define MAX_FS_OFFSET_BIT	48

/* Data type for filesystem-wide blocks number */
#define  ext4_fsblk_t unsigned long long

/* Ioctl command */
#define EXT4_IOC_FIBMAP		_IOW('f', 9, ext4_fsblk_t)
#define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)

#define DEVNAME			0
#define DIRNAME			1
#define FILENAME		2

#define RETURN_OK		0
#define RETURN_NG		-1
#define FTW_CONT		0
#define FTW_STOP		-1
#define FTW_OPEN_FD		2000
#define FILE_CHK_OK		0
#define FILE_CHK_NG		-1
#define FS_EXT4			"ext4dev"
#define ROOT_UID		0

/* Defrag block size, in bytes */
#define DEFRAG_SIZE		67108864

#define min(x,y) (((x) > (y)) ? (y) : (x))

#define PRINT_ERR_MSG(msg)	fprintf(stderr, "%s\n", (msg));
#define PRINT_FILE_NAME(file)	fprintf(stderr, "\t\t    \"%s\"\n", (file));

#define MSG_USAGE		\
"Usage : e4defrag [-v] file...| directory...| device...\n\
      : e4defrag -f file [blocknr] \n\
      : e4defrag -r directory... | device... \n"

#define MSG_R_OPTION		" with regional block allocation mode.\n"
#define NGMSG_MTAB		"\te4defrag  : Can not access /etc/mtab."
#define NGMSG_UNMOUNT		"\te4defrag  : FS is not mounted."
#define NGMSG_EXT4		"\te4defrag  : FS is not ext4 File System."
#define NGMSG_FS_INFO		"\te4defrag  : get FSInfo fail."
#define NGMSG_FILE_INFO		"\te4defrag  : get FileInfo fail."
#define NGMSG_FILE_OPEN		"\te4defrag  : open fail."
#define NGMSG_FILE_SYNC		"\te4defrag  : sync(fsync) fail."
#define NGMSG_FILE_DEFRAG	"\te4defrag  : defrag fail."
#define NGMSG_FILE_BLOCKSIZE	"\te4defrag  : can't get blocksize."
#define NGMSG_FILE_FIBMAP	"\te4defrag  : can't get block number."
#define NGMSG_FILE_UNREG	"\te4defrag  : File is not regular file."

#define NGMSG_FILE_LARGE	\
	"\te4defrag  : Defrag size is larger than FileSystem's free space."

#define NGMSG_FILE_PRIORITY	\
"\te4defrag  : File is not current user's file or current user is not root."

#define NGMSG_FILE_LOCK		"\te4defrag  : File is locked."
#define NGMSG_FILE_BLANK	"\te4defrag  : File size is 0."
#define NGMSG_GET_LCKINFO	"\te4defrag  : get LockInfo fail."
#define NGMSG_TYPE		\
	"e4defrag  : Can not process %s in regional mode\n."
#define NGMSG_REALPATH		"\te4defrag  : Can not get full path."

struct ext4_extent_data {
	unsigned long long block;	/* start logical block number */
	ext4_fsblk_t start;		/* start physical block number */
	int len;			/* blocks count */
};

/* Used for defrag */
struct ext4_ext_defrag_data {
	ext4_fsblk_t start_offset;	/* start offset to defrag in blocks */
	ext4_fsblk_t defrag_size;	/* size of defrag in blocks */
	ext4_fsblk_t goal;		/* block offset for allocation */
	int flag;			/* free space mode flag */
	struct ext4_extent_data ext;
};

struct ext4_group_data_info {
	int s_blocks_per_group;		/* blocks per group */
	int s_inodes_per_group;		/* inodes per group */
};

struct ext4_extents_info {
	unsigned long long ino;		/* inode number */
	int max_entries;		/* maximum extents count */
	int entries; 	 		/* extent number/count */
	unsigned long offset;
	ext4_fsblk_t goal;
	struct ext4_extent_data ext[DEFRAG_MAX_ENT];
};

typedef struct ext_in_group {
	struct ext_in_group *prev;
	unsigned long tag;		/* Extent status */
	unsigned long ino;		/* File`s inode number */
	struct ext4_extent_data data;	/* Extent belong to file */
	struct ext_in_group *next;
}extlist;

typedef struct big_extent {
	struct big_extent *prev;
	extlist *start;			/* Start ext */
	extlist *end;			/* End ext */
	int big_len;			/* Length of this continuous region */
	struct big_extent *next;
}bigext;

typedef struct ext_group_wrap {
	struct ext_group_wrap *prev, *next;
	struct ext_in_group *group_ext;
}ext_wrap;

int	force_flag = 0;
int	detail_flag = 0;
int	regional_flag = 0;
int	amount_cnt = 0;
int	succeed_cnt = 0;
ext4_fsblk_t	goal = 0;
ext4_fsblk_t	fgoal = -1;

/*
 * Check if there's enough disk space
 */
int check_free_size(int fd, const struct stat64 *sb)
{
	struct statfs	fsbuf;
	off64_t	file_asize = 0;
	off64_t	fsize = 0;

	/* target file size */
	fsize = sb->st_size;

	if (fstatfs(fd, &fsbuf) < 0) {
		if (detail_flag) {
			perror(NGMSG_FS_INFO);
		}
		return RETURN_NG;
	}

	/* Compute free space for root and normal user separately */
	if (getuid() == ROOT_UID) {
		file_asize = (off64_t)fsbuf.f_bsize * fsbuf.f_bfree;
	} else {
		file_asize = (off64_t)fsbuf.f_bsize * fsbuf.f_bavail;
	}

	if (file_asize >= fsize) {
		return RETURN_OK;
	}

	return RETURN_NG;
}

int file_check(int fd, const struct stat64 * buf, const char * file_name);
int force_defrag(int fd, const struct stat64 *sb, int blocksize);
/*
 * Check file attributes and ioctl call to avoid illegal operations
 */
int
ftw_fn(const char *file, const struct stat64 *sb, int flag, struct FTW *ftwbuf)
{
	struct ext4_ext_defrag_data	df_data;
	loff_t	start = 0;
	int	defraged_size = 0;
	int	blocksize;
	int	fd;

	if (flag == FTW_F) {
		amount_cnt++;
		if ((fd = open64(file, O_RDONLY)) < 0) {
			if (detail_flag) {
				perror(NGMSG_FILE_OPEN);
				PRINT_FILE_NAME(file);
			}
			return FTW_CONT;
		}

		if (file_check(fd, sb, file) == FILE_CHK_NG) {
			close(fd);
			return FTW_CONT;
		}

		if (fsync(fd) < 0) {
			if (detail_flag) {
				perror(NGMSG_FILE_SYNC);
				PRINT_FILE_NAME(file);
			}
			close(fd);
			return FTW_CONT;
		}
		/* Get blocksize */
		if (ioctl(fd, FIGETBSZ, &blocksize) < 0) {
			if (detail_flag) {
				perror(NGMSG_FILE_BLOCKSIZE);
				PRINT_FILE_NAME(file);
			}
			return FTW_CONT;
		}
		/* Ioctl call does the actual defragment job. */
		df_data.start_offset = 0;
		df_data.goal = goal;
		df_data.ext.len = 0;

		if (force_flag)
			df_data.flag = 1;
		while (1) {
			df_data.defrag_size =
					(min((sb->st_size - start),
					     DEFRAG_SIZE) + blocksize - 1) /
					blocksize;
			/* EXT4_IOC_DEFRAG */
			defraged_size = ioctl(fd, EXT4_IOC_DEFRAG, &df_data);
			if ((defraged_size < 0) && (force_flag == 1) &&
			 (errno == ENOSPC) && sb->st_size <= MAX_FILE_SIZE) {
				defraged_size = force_defrag(fd, sb, blocksize);
				if (defraged_size *blocksize >= sb->st_size) {
					/* Whole file is enforcedly defraged */
					break;
				} else {
					defraged_size = RETURN_NG;
				}
			}
			if (defraged_size < 0) {
				if (detail_flag) {
					perror(NGMSG_FILE_DEFRAG);
					PRINT_FILE_NAME(file);
				}
				close(fd);
				return FTW_CONT;
			}
			df_data.start_offset += defraged_size;
			start = df_data.start_offset * blocksize;
			/* End of file */
			if (start >= sb->st_size) {
				break;
			}
		}
		close(fd);
		succeed_cnt++;
	} else {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_UNREG);
			PRINT_FILE_NAME(file);
		}
	}

	return FTW_CONT;
}

/*
 * Check file's attributes
 */
int file_check(int fd, const struct stat64 *buf, const char *file_name)
{
	struct flock	lock;

	lock.l_type = F_WRLCK; /* Write-lock check is more reliable. */
	lock.l_start = 0;
	lock.l_whence = SEEK_SET;
	lock.l_len = 0;

	/* Regular file */
	if (S_ISREG(buf->st_mode) == 0) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_UNREG);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* Available space */
	if (check_free_size(fd, buf) == RETURN_NG) {

		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_LARGE);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* Priority */
	if (getuid() != ROOT_UID &&
		buf->st_uid != getuid()) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_PRIORITY);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* Lock status */
	if (fcntl(fd, F_GETLK, &lock) < 0) {
		if (detail_flag) {
			perror(NGMSG_GET_LCKINFO);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	} else if (lock.l_type != F_UNLCK) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_LOCK);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* Empty file */
	if (buf->st_size == 0) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_BLANK);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	return FILE_CHK_OK;
}

/*
 * Whether on an ext4 filesystem
 */
int is_ext4(const char *filename)
{
	struct statfs	buffs;
	char	*mtab = MOUNTED;	/* Refer to /etc/mtab */
	struct mntent	*mnt = NULL;
	FILE	*fp = NULL;
	int maxlen, len;
	char maxtype[10];
	char	fullpath[PATH_MAX];

	/* Get full path */
	if (realpath(filename, fullpath) == NULL) {
		perror(NGMSG_REALPATH);
		PRINT_FILE_NAME(filename);
		return RETURN_NG;
	}

	if (statfs(fullpath, &buffs) < 0) {
		perror(NGMSG_FS_INFO);
		PRINT_FILE_NAME(filename);
		return RETURN_NG;
	}

	if (buffs.f_type != EXT4_SUPER_MAGIC) {
		PRINT_ERR_MSG(NGMSG_EXT4);
		return RETURN_NG;
	}

	if ((fp = setmntent(mtab, "r")) == NULL) {
		perror(NGMSG_MTAB);
		return RETURN_NG;
	}

	maxlen = 0;
	while ((mnt = getmntent(fp)) != NULL) {
		len = strlen(mnt->mnt_dir);
		if (memcmp(fullpath, mnt->mnt_dir, len) == 0) {
			if (maxlen < len) {
				maxlen = len;
				strcpy(maxtype, mnt->mnt_type);
			}
		}
	}

	if (strcmp(maxtype, FS_EXT4) == 0) {
		endmntent(fp);
		return RETURN_OK;
	} else {
		endmntent(fp);
		PRINT_ERR_MSG(NGMSG_EXT4);
		return RETURN_NG;
	}
}

/*
 * Get device's mount point
 */
int get_mount_point(const char *devname, char *mount_point, int buf_len)
{
	char	*mtab = MOUNTED;	/* Refer to /etc/mtab */
	struct mntent	*mnt = NULL;
	FILE	*fp = NULL;

	if ((fp = setmntent(mtab, "r")) == NULL) {
		perror(NGMSG_MTAB);
		return RETURN_NG;
	}

	while ((mnt = getmntent(fp)) != NULL) {
		if (strcmp(devname, mnt->mnt_fsname) == 0) {
			endmntent(fp);
			if (strcmp(mnt->mnt_type, FS_EXT4) == 0) {
				strncpy(mount_point, mnt->mnt_dir, buf_len);
				return RETURN_OK;
			}
			PRINT_ERR_MSG(NGMSG_EXT4);
			return RETURN_NG;
		}
	}
	endmntent(fp);
	PRINT_ERR_MSG(NGMSG_UNMOUNT);
	return RETURN_NG;
}

int main(int argc, char *argv[])
{
	int	i, flags;
	int	arg_type;
	int	success_flag;
	int	orig_detail;
	char	dir_name[PATH_MAX];
	int	fd;
	int	ret;
	int	c;
	struct stat64	buf;

	i = 1;
	arg_type = -1;
	success_flag = 0;
	orig_detail = -1;
	flags = 0;
	flags |= FTW_PHYS;	/* Do not follow symlink */
	flags |= FTW_MOUNT;	/* Stay within the same filesystem */
	/* Parse arguments */
	if (argc == 1 || (argc == 2 && argv[1][0] == '-')) {
		printf(MSG_USAGE);
		return 1;
	}

	while ((c = getopt(argc, argv, "rvf")) != EOF) {
		switch (c) {
		case 'r':
			regional_flag = 1;
			i = 2;
			break;
		case 'v':
			detail_flag = 1;
			i = 2;
			break;
		case 'f':
			force_flag = 1;
			i = 2;

			if (argc == 4) {
				int res_strlen;
				res_strlen = strlen(argv[3]);
				for (res_strlen -= 1; res_strlen >= 0;
								res_strlen--) {
					if (!isdigit(argv[3][res_strlen])) {
						printf ("Illegal argument\n\n");
						printf(MSG_USAGE);
						exit(1);
					}
				}

				fgoal = strtoul(argv[3], NULL, 0);
				if (errno) {
					printf ("block num shold be < 32bit\n");
					exit(1);
				}
			}
			if (!fgoal)
				fgoal = -1;
			break;
		default:
			printf(MSG_USAGE);
			return 1;
		}
	}

	/* Main process */
	for (; i < argc; i++) {
		amount_cnt = 0;
		succeed_cnt = 0;
		memset(dir_name, 0, PATH_MAX);

		if (force_flag && i == 3)
			break;

		if (stat64(argv[i], &buf) < 0) {
			perror(NGMSG_FILE_INFO);
			PRINT_FILE_NAME(argv[i]);
			continue;
		}

		/* Regular file is acceptalbe with force mode */
		if (force_flag && !S_ISREG(buf.st_mode)) {
			printf ("Inappropriate file type \n\n");
			printf(MSG_USAGE);
			exit(1);
		}

		/* Block device */
		if (S_ISBLK(buf.st_mode)) {
			arg_type = DEVNAME;
			if (get_mount_point(argv[i], dir_name, PATH_MAX) ==
				RETURN_NG) {
				continue;
			}
			printf("Start defragment for device(%s)\n", argv[i]);
		} else if (S_ISDIR(buf.st_mode)) {
			/* Directory */
			arg_type = DIRNAME;
			if (access(argv[i], R_OK) < 0) {
				perror(argv[i]);
				continue;
			}
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

		/* Device's ext4 check is in get_mount_point() */
		if (arg_type == FILENAME || arg_type == DIRNAME) {
			if (is_ext4(argv[i]) == RETURN_NG) {
				continue;
			}
		}

		switch (arg_type) {
			case DIRNAME:
				printf("Start defragment for directory(%s)\n",
					argv[i]);
			case DEVNAME:
				/* Regional block allocation */
				if (regional_flag) {
					printf(MSG_R_OPTION);

					if ((fd = open64(dir_name, O_RDONLY)) <
					    0) {
						if (detail_flag) {
							perror(NGMSG_FILE_OPEN);
							PRINT_FILE_NAME(
								      dir_name);
						}
						continue;
					}

					goal = 0;
					if ((ret = ioctl(fd, EXT4_IOC_FIBMAP,
							 &goal)) > 0) {
						perror(NGMSG_FILE_FIBMAP);
						PRINT_FILE_NAME(dir_name);
						close(fd);
						continue;
					}
					close(fd);
				}

				/* File tree walk */
				nftw64(dir_name, ftw_fn, FTW_OPEN_FD, flags);
				printf("\tTotal:\t\t%12d\n", amount_cnt);
				printf("\tSuccess:\t%12d\n", succeed_cnt);
				printf("\tFailure:\t%12d\n",
					amount_cnt - succeed_cnt);
				break;
			case FILENAME:
				if (regional_flag) {
					fprintf(stderr, NGMSG_TYPE, argv[i]);
					continue;
				}
				orig_detail = detail_flag;
				detail_flag = 1;
				printf("Start defragment for %s\n", argv[i]);
				/* Single file process */
				ftw_fn(argv[i], &buf, FTW_F, NULL);
				if (succeed_cnt != 0) {
					printf(
					"\tSUCCESS\t:file defrag success.\n"
					);
				}
				detail_flag = orig_detail;
				break;
		}

		if (succeed_cnt != 0)
			success_flag = 1;
	}

	if (success_flag)
		return 0;

	return 1;
}

/* Sequentially insert extent by physical block number */
int insertextent(extlist **head, extlist *ext)
{
	extlist	*p = *head;
	if (ext == NULL) {
		return RETURN_NG;
	}
	/* First element */
	if (*head == NULL) {
		(*head) = ext;
		(*head)->prev = *head;
		(*head)->next = *head;
		return 0;
	}

	if (ext->data.start <= p->data.start) {
		/* Insert before head */
		if (p->data.start < ext->data.start + ext->data.len) {
			/* Overlap */
			return RETURN_NG;
		}
		/* Adjust head */
		*head = ext;
	} else {
		/* Insert into the middle or last of the list */
		p = *head;
		do {
			if (ext->data.start < p->data.start) {
				break;
			}
			p = p->next;
		} while (p != (*head));
		if (ext->data.start < p->prev->data.start + p->prev->data.len) {
			/* Overlap */
			return RETURN_NG;
		}
		if (p != *head &&
		    p->data.start < ext->data.start + ext->data.len) {
			/* Overlap */
			return RETURN_NG;
		}
	}
	p = p->prev;
	/* Insert "ext" after "p" */
	insert(p,ext);
	return 0;
}

/* Insert big extent in decreasing order of length */
int insertbig(bigext **bighead, bigext *ext)
{
	bigext	*p = NULL;
	if (ext == NULL) {
		return RETURN_NG;
	}

	/* Initialize list */
	if (*bighead == NULL) {
		(*bighead) = ext;
		(*bighead)->prev = *bighead;
		(*bighead)->next = *bighead;
		return 0;
	}

	if (ext->big_len >= (*bighead)->big_len) {
		/* Insert before bighead */
		p = (*bighead)->prev;
		insert(p, ext);
		*bighead = ext;
		return 0;
	}

	/* Find insertion positon */
	for (p = (*bighead)->next; p != *bighead; p = p->next) {
		if (p->big_len < ext->big_len) {
			break;
		}
	}
	p = p->prev;
	insert(p, ext);

	return 0;
}

/* Delete and get element from the big list */
bigext * del_get_big(bigext **bighead, bigext *ext)
{
	if (ext == NULL || *bighead == NULL) {
		return NULL;
	}
	/* Keep "bighead" point to the largest enxtent */
	if (ext == *bighead) {
		*bighead = ext->next;
	}
	if (*bighead == (*bighead)->next && ext == *bighead) {
		/* Delete the last element in the list */
		*bighead = NULL;
	}
	ext->prev->next = ext->next;
	ext->next->prev = ext->prev;
	return ext;
}

 void freebig(bigext *big)
{
	bigext *tmpbig = NULL;
	if (big == NULL) {
		return;
	}
	while (big->next != big) {
		tmpbig = big;
		big->prev->next = big->next;
		big->next->prev = big->prev;
		big = big->next;
		free(tmpbig);
	}
	free(big);
}

void free_ext(extlist *head)
{
	extlist *tmp = NULL;
	if (head == NULL) {
		return;
	}
	while (head->next != head) {
		tmp = head;
		head->prev->next = head->next;
		head->next->prev = head->prev;
		head = head->next;
		free(tmp);
	}
	free(head);
}

int move_wrap_tail(ext_wrap **from, ext_wrap **to, ext_wrap *entry)
{
	if (!to || !entry) {
		return RETURN_NG;
	}
	if (from && *from == entry) {
		if ((*from)->next == *from) {
			*from = NULL;
		} else {
			*from = (*from)->next;
		}
	}
	entry->next->prev = entry->prev;
	entry->prev->next = entry->next;
	if (!(*to)) {
		*to = entry;
		(*to)->prev = (*to)->next = *to;
	} else {
		entry->next = *to;
		entry->prev = (*to)->prev;
		(*to)->prev->next = entry;
		(*to)->prev = entry;
	}
	return 0;
}

void mark_wrap(ext_wrap *list)
{
	ext_wrap *wrap = list;

	if (!list) {
		return;
	}
	do {
		wrap->group_ext->tag |= EXT4_EXT_RESERVE;
		wrap = wrap->next;
	} while (wrap != list);
}

void free_wrap_list(ext_wrap **head)
{
	ext_wrap *wrap, *tmp;

	if (!head || !(*head)) {
		return;
	}
	wrap = *head;
	do {
		tmp = wrap;
		wrap = wrap->next;
		free(tmp);
	} while (wrap != *head);
	*head = NULL;
}

int list_size(ext_wrap *list)
{
	ext_wrap	*entry = list;
	int	ret = 0;

	if (!list) {
		return 0;
	}
	do {
		ret++;
		entry = entry->next;
	} while (entry != list);

	return ret;
}

static inline
int do_defrag(int fd, bigext *bigptr, extlist *ptr0, struct ext4_ext_defrag_data defrag_data)
{
	int defraged_size = 0;
	int ret = 0;

	/* Defrag */
	defrag_data.ext.start = bigptr->start->data.start;
	defrag_data.ext.len = bigptr->big_len;
	defrag_data.ext.block = 0;
	defrag_data.defrag_size = bigptr->big_len;
	defrag_data.flag = DEFRAG_RESERVE_BLOCK_SECOND;
	defrag_data.goal = bigptr->start->data.start;

	defraged_size = ioctl(fd, EXT4_IOC_DEFRAG, &defrag_data);
	if (defraged_size < 0) {
		ret = RETURN_NG;
	}
	/* Release reserved sign */
	ptr0 = bigptr->start;
	do {
		ptr0->tag &= ~EXT4_EXT_RESERVE;
		ptr0 = ptr0->next;
	} while (ptr0 != bigptr->end->next);

	ret += defraged_size;

	if(defraged_size > 0)
		defrag_data.start_offset += defraged_size;

	return ret;
}

int force_defrag(int fd, const struct stat64 *sb, int blocksize)
{
	struct ext4_group_data_info	ext4_group_data;
	struct ext4_extents_info	tmpext;
	struct ext4_extent_data	ext;
	struct ext4_ext_defrag_data	defrag_data;
	bigext	*bighead, *target_bighead, *bigptr;
	extlist	*head, *startptr, *ptr0;
	ext_wrap	*target_head, *wrap, *tmp_wrap_list;
	ext4_fsblk_t	bstart, bend;
	unsigned long	filesize;
	unsigned long long	ino, istart, iend;
	unsigned int	gn;
	int	len, maxlen;
	int	pos = 0;
	int	ret = 0;
	int	exts, file_exts;

	memset(&ext4_group_data, 0, sizeof(struct ext4_group_data_info));
	memset(&tmpext, 0, sizeof(struct ext4_extents_info));
	memset(&defrag_data, 0, sizeof(struct ext4_ext_defrag_data));
	memset(&ext, 0, sizeof(struct ext4_extent_data));

	bigptr = target_bighead = bighead = NULL;
	head = startptr = ptr0 =  NULL;
	target_head = wrap = tmp_wrap_list = NULL;

	if (ioctl(fd, EXT4_IOC_GROUP_INFO, &ext4_group_data) < 0) {
		return RETURN_NG;
	}

	gn = (sb->st_ino -1) / ext4_group_data.s_inodes_per_group;
	istart = gn * ext4_group_data.s_inodes_per_group;
	iend = istart + ext4_group_data.s_inodes_per_group - 1;
	bstart = gn * ext4_group_data.s_blocks_per_group;
	bend = bstart + ext4_group_data.s_blocks_per_group - 1;

	/* Compute filesize in block */
	filesize = (sb->st_size+ blocksize - 1) / blocksize;

	/* Get used extent in the block group */
	tmpext.max_entries = DEFRAG_MAX_ENT;
	for (ino = istart; ino <= iend; ino++) {
		tmpext.ino = ino;
		tmpext.entries = 0;
		pos = 0;
		do {
			/* Get extents info */
			int j;
			tmpext.entries += pos;/* Offset */
			pos = tmpext.entries;
			memset(tmpext.ext, 0,
			     sizeof(struct ext4_extent_data) * DEFRAG_MAX_ENT);
			ret = ioctl(fd, EXT4_IOC_EXTENTS_INFO, &tmpext);
			if (ret < 0) {
				if (errno == ENOENT) {
					continue;
				} else {
					/* without ENOENT case*/
					ret = RETURN_NG;
					goto freelist;
				}
			}

			for (j = 0; j < tmpext.entries; j++) {
				extlist	*listptr = NULL;
				/* Is this extent in current block group? */
				if (tmpext.ext[j].start < bstart ||
				    tmpext.ext[j].start > bend) {
					continue;
				}
				listptr = malloc(sizeof(extlist));
				if (listptr == NULL) {
					ret = RETURN_NG;
					goto freelist;
				}
				memset(listptr, 0, sizeof(extlist));
				memcpy(&(listptr->data), &tmpext.ext[j],
				       sizeof(struct ext4_extent_data));
				listptr->ino = ino;
				if (insertextent(&head, listptr) < 0) {
					ret = RETURN_NG;
					goto freelist;
				}
			}
		} while (tmpext.entries == DEFRAG_MAX_ENT && ret == 0);
	}
	/* Get free extents in the group */
	memset(&tmpext, 0, sizeof(struct ext4_extents_info));
	tmpext.ino = sb->st_ino;
	tmpext.max_entries = DEFRAG_MAX_ENT;
	for (pos = 0; pos < ext4_group_data.s_blocks_per_group;)
	{
		int	j;
		if (ioctl(fd, EXT4_IOC_FREE_BLOCKS_INFO, &tmpext) < 0) {
			ret = RETURN_NG;
			goto freelist;
		}
		/*
		 * No free extent after the logical block number "pos".
		 * In other word, offset this time equals to prev recursion.
		 */
		for (j = 0; tmpext.ext[j].len != 0 && j < DEFRAG_MAX_ENT; j++) {
			/* Alloc list node store extent */
			extlist	*listptr = NULL;
			listptr = malloc(sizeof(extlist));
			if (listptr == NULL) {
				ret = RETURN_NG;
				goto freelist;
			}
			memset(listptr, 0, sizeof(extlist));
			memcpy(&(listptr->data), &(tmpext.ext[j]),
			       sizeof(struct ext4_extent_data));
			listptr->tag = EXT4_EXT_FREE;/* Free extent */
			if (insertextent(&head, listptr) < 0) {
				ret = RETURN_NG;
				goto freelist;
			}
		}
		/*
		 * No free extent after the logical block number "pos".
		 * In other word, offset this time equals to prev recursion.
		 */
		if (pos == tmpext.offset) {
			break;
		}
		if (j < DEFRAG_MAX_ENT) {
			break;
		}
		/* Record the offset of logical block number this time */
		pos = tmpext.offset;
		memset(tmpext.ext, 0,
		       sizeof(struct ext4_extent_data) * DEFRAG_MAX_ENT);
	}

	/* All space in this group is used by other groups' inodes */
	if (head == NULL) {
		ret = RETURN_NG;
		goto freelist;
	}

	/* Find continuous region(big extent) */
	startptr = ptr0 = head;
	maxlen = 0;
	len = head->data.len;
	ptr0 = ptr0->next;
	do {
		if (len >= filesize) {
			/* Hit on the way */
			bigext	*bigtmp = malloc(sizeof(bigext));
			if (!bigtmp) {
				ret = RETURN_NG;
				goto freelist;
			}
			bigtmp->prev = bigtmp->next = NULL;
			bigtmp->start = startptr;
			bigtmp->end = ptr0->prev;
			bigtmp->big_len = len;
			if (insertbig(&target_bighead, bigtmp) < 0) {
				ret = RETURN_NG;
				goto freelist;
			}
			maxlen += len;
			exts = 1;
			goto frag_check;
		}
		if ((ptr0->prev->data.start + ptr0->prev->data.len) !=
		    ptr0->data.start) {
			bigext	*bigtmp = NULL;
			bigtmp = malloc(sizeof(bigext));
			if (bigtmp == NULL) {
				ret = RETURN_NG;
				goto freelist;
			}
			memset(bigtmp, 0, sizeof(bigext));
			bigtmp->big_len = len;
			bigtmp->start = startptr;
			bigtmp->end = ptr0->prev;

			if (insertbig(&bighead, bigtmp) < 0) {
				ret = RETURN_NG;
				goto freelist;
			}
			maxlen += len;
			startptr = ptr0;
			len = ptr0->data.len;
			ptr0 = ptr0->next;
			continue;
		}
		len += ptr0->data.len;
		ptr0 = ptr0->next;
	} while (ptr0 != head->next);

	if (maxlen < filesize) {
		/* No enough space */
		errno = ENOSPC;
		ret = RETURN_NG;
		goto freelist;
	}

	if (!bighead) {
		ret = RETURN_NG;
		goto freelist;
	}
	len = 0;/* Blocks we found for target file */
	exts = 0;/* Extents we found for target file */
	while (bighead)
	{
		bigext	*bigtmp;
		if (bighead->big_len + len >= filesize) {
			/*
			 * Search from the smallest big-extent
			 * to avoid waste of space
			 */
			bigtmp = bighead->prev;
			do {
				if (bigtmp->big_len + len >= filesize) {
					len += bigtmp->big_len;
					bigtmp = del_get_big(&bighead, bigtmp);
					if (insertbig(&target_bighead, bigtmp) <
					    0) {
						ret = RETURN_NG;
						goto freelist;
					}
					exts++;
					goto frag_check;
				}
				bigtmp = bigtmp->prev;
			} while (bigtmp != bighead->prev);
		}
		len += bighead->big_len;
		bigtmp = del_get_big(&bighead, bighead);
		if (insertbig(&target_bighead, bigtmp) < 0) {
			ret = RETURN_NG;
			goto freelist;
		}
		exts++;
	}
	if (!bighead) {
		ret = RETURN_NG;
		goto freelist;
	}

frag_check:
	/* Count file exts */
	memset(&tmpext, 0, sizeof(struct ext4_extents_info));
	file_exts = 0;/* Extents count of file */
	tmpext.ino = sb->st_ino;
	tmpext.max_entries = DEFRAG_MAX_ENT;
	tmpext.entries = 0;
	pos = 0;
	do {
		tmpext.entries += pos;
		pos = tmpext.entries;
		ret = ioctl(fd, EXT4_IOC_EXTENTS_INFO, &tmpext);
		if (ret < 0) {
			ret = RETURN_NG;
			goto freelist;
		}
		file_exts += tmpext.entries;
	} while (tmpext.entries == DEFRAG_MAX_ENT && ret == 0);

	if (exts >= file_exts) {
		/* No improvment */
		ret = RETURN_NG;
		goto freelist;
	}

	/* Reserve free extents */
	if (!target_bighead) {
		/* Fault */
		ret = RETURN_NG;
		goto freelist;
	}
	bigptr = target_bighead;
	memset(&tmpext, 0, sizeof(tmpext));
	tmpext.ino = 0;
	tmpext.max_entries = DEFRAG_MAX_ENT;
	tmpext.ino = sb->st_ino;
	tmp_wrap_list = NULL;
	ext4_fsblk_t data_block = 0;
	ext4_fsblk_t data_start = 0;
	int data_len = 0;
	defrag_data.start_offset = 0;

	do {
		ext_wrap	*wrap;
		ptr0 = bigptr->start;
		data_len = 0;
		data_start = ptr0->data.start;
		data_block = ptr0->data.block;
		do {
			data_len += ptr0->data.len;
			if (ptr0->tag != EXT4_EXT_USE) {
				ptr0->tag = EXT4_EXT_RESERVE;
				ptr0 = ptr0->next;
				continue;
			}
			tmpext.ino = ptr0->ino;
			tmpext.goal = fgoal;
			memcpy(tmpext.ext, &ptr0->data,
			       sizeof(struct ext4_extent_data));
			wrap = malloc(sizeof(ext_wrap));
			if (!wrap) {
				ret = RETURN_NG;
				goto release_blocks;
			}
			wrap->group_ext = ptr0;
			wrap->next = wrap->prev = wrap;
			if (move_wrap_tail(NULL, &tmp_wrap_list, wrap) < 0) {
				ret = RETURN_NG;
				goto release_blocks;
			}
			ptr0 = ptr0->next;
			tmpext.entries = 1;
			ret = ioctl(fd, EXT4_IOC_MOVE_VICTIM, &tmpext);
			if (ret < 0) {
				ret = RETURN_NG;
				goto release_blocks;
			}
			mark_wrap(tmp_wrap_list);
			free_wrap_list(&tmp_wrap_list);
		} while (ptr0 != bigptr->end->next);

		if (fsync(fd) < 0) {
			if (detail_flag) {
				perror(NGMSG_FILE_SYNC);
			}
			close(fd);
			goto freelist;
		}

		tmpext.entries = 1;
		tmpext.ext[0].block = data_block;
		tmpext.ext[0].start = data_start;
		tmpext.ext[0].len = bigptr->big_len;
		ret = ioctl(fd, EXT4_IOC_RESERVE_BLOCK, &tmpext);
		if (ret < 0) {
			printf("RESERVE_ERROR ret = %d\n", ret);
			goto release_blocks;
		}
		ret = do_defrag(fd, bigptr, ptr0, defrag_data);
		if (ret < 0) {
			printf("DEFRAG_ERROR ret = %d\n", ret);
			goto release_blocks;
		}
		defrag_data.start_offset += ret;
		ret = defrag_data.start_offset;

		bigptr = bigptr->next;
	} while (bigptr != target_bighead);
	goto freelist;

release_blocks:
	ret = ioctl(fd, EXT4_IOC_BLOCK_RELEASE);
	if (ret < 0) {
		ret = RETURN_NG;
		goto freelist;
	}

freelist:
	free_wrap_list(&target_head);
	free_wrap_list(&tmp_wrap_list);
	freebig(target_bighead);
	freebig(bighead);
	free_ext(head);
	return ret;
}
