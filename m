From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: [RFC][PATCH 3/4] Online defrag command
Date: Thu, 26 Apr 2007 21:13:39 +0900
Message-ID: <20070426211339sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50997 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031187AbXDZMNg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Apr 2007 08:13:36 -0400
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.193])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3QCDZfw012962
	for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2007 21:13:35 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3QCDZw05912 for linux-ext4@vger.kernel.org; Thu, 26 Apr 2007 21:13:35 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l3QCDY220852 for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2007 21:13:34 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070426.211334.29702572 for <linux-ext4@vger.kernel.org>
	; Thu, 26 Apr 2007 21:13:34 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The defrag command.  Usage is as follows:
o Put the multiple files closer together.
  # e4defrag -r directory-name
o Defrag for a single file.
  # e4defrag file-name
o Defrag for all files on ext4.
  # e4defrag device-name

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
---
/*
 * e4defrag, ext4 filesystem defragmenter
 *
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

#define EXT4_SUPER_MAGIC	0xEF53 /* magic number for ext4 */
#define DEFRAG_PAGES    	128 /* the number of pages to defrag at one time */
#define MAX_BLOCKS_LEN  	16384 /* Maximum length of contiguous blocks */

/* data type for filesystem-wide blocks number */
#define  ext4_fsblk_t unsigned long long

/* ioctl command */
#define EXT4_IOC_GET_DATA_BLOCK	_IOW('f', 9, ext4_fsblk_t)
#define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)

#define		DEVNAME			0
#define		DIRNAME			1
#define		FILENAME		2

#define		RETURN_OK		0
#define		RETURN_NG		-1
#define		FTW_CONT		0
#define		FTW_STOP		-1
#define		FTW_OPEN_FD		2000
#define		FILE_CHK_OK		0
#define		FILE_CHK_NG		-1
#define		FS_EXT4			"ext4dev"
#define		ROOT_UID		0
/* defrag block size, in bytes */
#define		DEFRAG_SIZE		67108864

#define 	min(x,y) (((x) > (y)) ? (y) : (x))

#define		PRINT_ERR_MSG(msg)	fprintf(stderr, "%s\n", (msg));
#define		PRINT_FILE_NAME(file)	\
			fprintf(stderr, "\t\t    \"%s\"\n", (file));

#define		MSG_USAGE	\
		"Usage : e4defrag [-v] file...| directory...| device...\n      : e4defrag [-r] \
directory... | device... \n"
#define		MSG_R_OPTION	\
		" with regional block allocation mode.\n"
#define		NGMSG_MTAB	\
		"\te4defrag  : Can not access /etc/mtab."
#define		NGMSG_UNMOUNT		"\te4defrag  : FS is not mounted."
#define		NGMSG_EXT4	\
		"\te4defrag  : FS is not ext4 File System."
#define		NGMSG_FS_INFO		"\te4defrag  : get FSInfo fail."
#define		NGMSG_FILE_INFO		"\te4defrag  : get FileInfo fail."
#define		NGMSG_FILE_OPEN		"\te4defrag  : open fail."
#define		NGMSG_FILE_SYNC		"\te4defrag  : sync(fsync) fail."
#define		NGMSG_FILE_DEFRAG	"\te4defrag  : defrag fail."
#define		NGMSG_FILE_BLOCKSIZE	"\te4defrag  : can't get blocksize."
#define		NGMSG_FILE_DATA		"\te4defrag  : can't get data."
#define		NGMSG_FILE_UNREG	\
		"\te4defrag  : File is not regular file."
#define		NGMSG_FILE_LARGE	\
	"\te4defrag  : Defrag size is larger than FileSystem's free space."
#define		NGMSG_FILE_PRIORITY	\
"\te4defrag  : File is not current user's file or current user is not root."
#define		NGMSG_FILE_LOCK		"\te4defrag  : File is locked."
#define		NGMSG_FILE_BLANK	"\te4defrag  : File size is 0."
#define		NGMSG_GET_LCKINFO	"\te4defrag  : get LockInfo fail."
#define		NGMSG_TYPE		\
		"e4defrag  : Can not process %s."

struct ext4_ext_defrag_data {
	ext4_fsblk_t start_offset; /* start offset to defrag in blocks */
	ext4_fsblk_t defrag_size;  /* size of defrag in blocks */
	ext4_fsblk_t goal;   /* block offset for allocation */
};

int		detail_flag = 0;
int		regional_flag = 0;
int		amount_cnt = 0;
int		succeed_cnt = 0;
ext4_fsblk_t	goal = 0;

/*
 * Check if there's enough disk space
 */
int
check_free_size(int fd, off64_t fsize)
{
	struct statfs		fsbuf;
	off64_t			file_asize = 0;

	if (-1 == fstatfs(fd, &fsbuf)) {
		if (detail_flag) {
			perror(NGMSG_FS_INFO);
		}
		return RETURN_NG;
	}

	/* compute free space for root and normal user separately */
	if (ROOT_UID == getuid())
		file_asize = (off64_t)fsbuf.f_bsize * fsbuf.f_bfree;
	else
		file_asize = (off64_t)fsbuf.f_bsize * fsbuf.f_bavail;

	if (file_asize >= fsize)
		return RETURN_OK;

	return RETURN_NG;
}

/*
 * file tree walk callback function
 * check file attributes before ioctl call to avoid illegal operations
 */
int
ftw_fn(
	const char*		file,
	const struct stat64	*sb,
	int			flag,
	struct FTW*		ftwbuf
)
{
	struct ext4_ext_defrag_data	df_data;
	loff_t				start = 0;
	int				defraged_size = 0;
	int				blocksize;
	int				fd;

	if (FTW_F == flag) {
		amount_cnt++;
		if (-1 == (fd = open64(file, O_RDONLY))) {
			if (detail_flag) {
				perror(NGMSG_FILE_OPEN);
				PRINT_FILE_NAME(file);
			}
			return FTW_CONT;
		}

		if (FILE_CHK_NG == file_check(fd, sb, file)) {
			close(fd);
			return FTW_CONT;
		}

		if (-1 == fsync(fd)) {
			if (detail_flag) {
				perror(NGMSG_FILE_SYNC);
				PRINT_FILE_NAME(file);
			}
			close(fd);
			return FTW_CONT;
		}
		/* get blocksize */
		if (ioctl(fd, FIGETBSZ, &blocksize) < 0) {
			if (detail_flag) {
				perror(NGMSG_FILE_BLOCKSIZE);
				PRINT_FILE_NAME(file);
			}
			return FTW_CONT;
		}
		/* ioctl call does the actual defragment job. */
		df_data.start_offset = 0;
		df_data.goal = goal;
		while (1) {
			df_data.defrag_size =
					(min((sb->st_size - start),
					 DEFRAG_SIZE) + blocksize - 1) / blocksize;
			/* EXT4_IOC_DEFRAG */
			defraged_size = ioctl(fd, EXT4_IOC_DEFRAG, &df_data);
			if (defraged_size == -1) {
				if (detail_flag) {
					perror(NGMSG_FILE_DEFRAG);
					PRINT_FILE_NAME(file);
				}
				close(fd);
				return FTW_CONT;
			}
			df_data.start_offset += defraged_size;
			start = df_data.start_offset * blocksize;
			/* end of file */
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
 * check file's attributes
 */
int
file_check(int fd, const struct stat64 * buf, const char * file_name)
{
	struct flock	lock;

	lock.l_type = F_WRLCK;	/* write-lock check is more reliable. */
	lock.l_start = 0;
	lock.l_whence = SEEK_SET;
	lock.l_len = 0;

	/* regular file */
	if (0 == S_ISREG(buf->st_mode)) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_UNREG);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* available space */
	if (RETURN_NG == check_free_size(fd, DEFRAG_SIZE)) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_LARGE);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* priority */
	if (ROOT_UID != getuid() &&
		buf->st_uid != getuid()) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_PRIORITY);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* lock status */
	if (-1 == fcntl(fd, F_GETLK, &lock)) {
		if (detail_flag) {
			perror(NGMSG_GET_LCKINFO);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	} else if (F_UNLCK != lock.l_type) {
		if (detail_flag) {
			PRINT_ERR_MSG(NGMSG_FILE_LOCK);
			PRINT_FILE_NAME(file_name);
		}
		return FILE_CHK_NG;
	}

	/* empty file */
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
 * whether on an ext4 filesystem
 */
int
is_ext4(const char * filename)
{
	struct statfs	buffs;

	if (-1 == statfs(filename, &buffs)) {
		perror(NGMSG_FS_INFO);
		PRINT_FILE_NAME(filename);
		return RETURN_NG;
	} else if (EXT4_SUPER_MAGIC == buffs.f_type) {
		return RETURN_OK;
	} else {
		PRINT_ERR_MSG(NGMSG_EXT4);
		return RETURN_NG;
	}
}

/*
 * Get device's mount point
 */
int
get_mount_point(const char * devname, char * mount_point, int buf_len)
{
	char * mtab = MOUNTED;	/* refer to /etc/mtab */
	struct mntent * mnt = NULL;
	FILE * fp = NULL;

	if (NULL == (fp = setmntent(mtab, "r"))) {
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

int
main(
	int		argc,
	char*	argv[]
)
{
	int		i, flags;
	int		arg_type;
	int		success_flag;
	int		orig_detail;
	char		dir_name[PATH_MAX];
	int		fd;
	int		ret;
	int 		c;
	struct stat64	buf;
	struct ext4_ext_defrag_data     df_data;

	i = 1;
	arg_type = -1;
	success_flag = 0;
	orig_detail = -1;
	flags = 0;
	flags |= FTW_PHYS;	/* do not follow symlink */
	flags |= FTW_MOUNT;	/* stay within the same filesystem */

	/* parse arguments */
	while ((c = getopt(argc, argv, "rv")) != EOF) {
		switch (c) {
		case 'r':
			regional_flag = 1;
			i = 2;
			break;
		case 'v':
			detail_flag = 1;
			i = 2;
			break;
		default:
			printf(MSG_USAGE);
			return 1;
		}
	}

	/* main process */
	for (; i < argc; i++) {
		amount_cnt = 0;
		succeed_cnt = 0;
		memset(dir_name, 0, PATH_MAX);

		if (-1 == stat64(argv[i], &buf)) {
			perror(NGMSG_FILE_INFO);
			PRINT_FILE_NAME(argv[i]);
			continue;
		}

		/* block device */
		if (S_ISBLK(buf.st_mode)) {
			arg_type = DEVNAME;
			if (RETURN_NG ==
				get_mount_point(argv[i], dir_name, PATH_MAX)) {
				continue;
			}
			printf("Start defragment for device(%s)\n", argv[i]);
		} else if (S_ISDIR(buf.st_mode)) {
			/* directory */
			arg_type = DIRNAME;
			if (-1 == access(argv[i], R_OK)) {
				perror(argv[i]);
				continue;
			}
			strcpy(dir_name, argv[i]);
		} else if (S_ISREG(buf.st_mode)) {
			/* regular file */
			arg_type = FILENAME;
		} else {
			/* irregular file */
			PRINT_ERR_MSG(NGMSG_FILE_UNREG);
			PRINT_FILE_NAME(argv[i]);
			continue;
		}

		/* device's ext4 check is in get_mount_point() */
		if (arg_type == FILENAME || arg_type == DIRNAME) {
			if (RETURN_NG == is_ext4(argv[i])) {
				continue;
			}
		}

		switch (arg_type) {
			case DIRNAME:
				printf("Start defragment for directory(%s)\n",
					argv[i]);
			case DEVNAME:
				/* regional block allocation */
				if (regional_flag) {
					printf(MSG_R_OPTION);

					if (-1 == (fd = open64(dir_name,
								O_RDONLY))) {
						if (detail_flag) {
							perror(NGMSG_FILE_OPEN);
							PRINT_FILE_NAME(dir_name);
						}
						return RETURN_NG;
					}

					if (0 < (ret = ioctl(fd,
						 EXT4_IOC_GET_DATA_BLOCK,
								&goal))) {
						perror(NGMSG_FILE_DATA);
						PRINT_FILE_NAME(dir_name);
						close(fd);
						return ret;
					}
					close(fd);
				}

				/* file tree walk */
				nftw64(dir_name, ftw_fn, FTW_OPEN_FD, flags);
				printf("\tTotal:\t\t%12d\n", amount_cnt);
				printf("\tSuccess:\t%12d\n", succeed_cnt);
				printf("\tFailure:\t%12d\n",
					amount_cnt - succeed_cnt);
				break;
			case FILENAME:
				if (regional_flag) {
					printf(MSG_USAGE);
					return 1;
				}
				orig_detail = detail_flag;
				detail_flag = 1;
				printf("Start defragment for %s\n", argv[i]);
				/* single file process */
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
