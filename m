From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] xstat: Add a pair of system calls to make extended file
	stats available [ver #4]
Date: Fri, 02 Jul 2010 00:57:28 +0100
Message-ID: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab0GAX5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Jul 2010 19:57:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a pair of system calls to make extended file stats available, including
file creation time, inode version and data version where available through the
underlying filesystem.

[This depends on the previously posted pair of patches to (a) constify a number
 of syscall string and buffer arguments and (b) rearrange AFS's use of
 i_version and i_generation].

The following structures are defined for their use:

	struct xstat_parameters {
		unsigned long long	request_mask;
	};

	struct xstat_dev {
		unsigned int		major, minor;
	};

	struct xstat_time {
		unsigned long long	tv_sec, tv_nsec;
	};

	struct xstat {
		unsigned int		st_mode;
		unsigned int		st_nlink;
		unsigned int		st_uid;
		unsigned int		st_gid;
		struct xstat_dev	st_rdev;
		struct xstat_dev	st_dev;
		struct xstat_time	st_atime;
		struct xstat_time	st_mtime;
		struct xstat_time	st_ctime;
		struct xstat_time	st_btime;
		unsigned long long	st_ino;
		unsigned long long	st_size;
		unsigned long long	st_blksize;
		unsigned long long	st_blocks;
		unsigned long long	st_gen;
		unsigned long long	st_data_version;
		unsigned long long	st_result_mask;
		unsigned long long	st_extra_results[0];
	};

where st_btime is the file creation time, st_gen is the inode generation
(i_generation), st_data_version is the data version number (i_version),
request_mask and st_result_mask are bitmasks of data desired/provided and
st_extra_results[] is where as-yet undefined fields are appended.

The defined bits in request_mask and st_result_mask are:

	XSTAT_REQUEST_MODE		Want/got st_mode
	XSTAT_REQUEST_NLINK		Want/got st_nlink
	XSTAT_REQUEST_UID		Want/got st_uid
	XSTAT_REQUEST_GID		Want/got st_gid
	XSTAT_REQUEST_RDEV		Want/got st_rdev
	XSTAT_REQUEST_ATIME		Want/got st_atime
	XSTAT_REQUEST_MTIME		Want/got st_mtime
	XSTAT_REQUEST_CTIME		Want/got st_ctime
	XSTAT_REQUEST_INO		Want/got st_ino
	XSTAT_REQUEST_SIZE		Want/got st_size
	XSTAT_REQUEST_BLOCKS		Want/got st_blocks
	XSTAT_REQUEST__BASIC_STATS	The stuff in the normal stat struct
	XSTAT_REQUEST_BTIME		Want/got st_btime
	XSTAT_REQUEST_GEN		Want/got st_gen
	XSTAT_REQUEST_DATA_VERSION	Want/got st_data_version
	XSTAT_REQUEST__EXTENDED_STATS	The stuff in the xstat struct
	XSTAT_REQUEST__ALL_STATS	The defined set of requestables

The system calls are:

	ssize_t ret = xstat(int dfd,
			    const char *filename,
			    unsigned flags,
			    const struct xstat_parameters *params,
			    struct xstat *buffer,
			    size_t buflen);

	ssize_t ret = fxstat(unsigned fd,
			     unsigned flags,
			     const struct xstat_parameters *params,
			     struct xstat *buffer,
			     size_t buflen);


The dfd, filename, flags and fd parameters indicate the file to query.  There
is no equivalent of lstat() as that can be emulated with xstat() by passing
AT_SYMLINK_NOFOLLOW in flags.

AT_FORCE_ATTR_SYNC can also be set in flags.  This will require a network
filesystem to synchronise its attributes with the server.

When the system call is executed, the request_mask bitmask is read from the
parameter block to work out what the user is requesting.  If params is NULL,
then request_mask will be assumed to be XSTAT_REQUEST__GET_ANYWAY.

The request_mask should be set by the caller to specify extra results that the
caller may desire.  These come in a number of classes:

 (0) dev, blksize.

     These are local data and are always available.

 (1) mode, nlinks, uid, gid, [amc]time, ino, size, blocks.

     These will be returned whether the caller asks for them or not.  The
     corresponding bits in result_mask will be set to indicate their presence.

     If the caller didn't ask for them, then they may be approximated.  For
     example, NFS won't waste any time updating them from the server, unless as
     a byproduct of updating something requested.

 (2) rdev.

     As for class (1), but this won't be returned if the file is not a blockdev
     or chardev.  The bit will be cleared if the value is not returned.

 (3) File creation time, inode generation and data version.

     These will be returned if available whether the caller asked for them or
     not.  The corresponding bits in result_mask will be set or cleared as
     appropriate to indicate their presence.

     If the caller didn't ask for them, then they may be approximated.  For
     example, NFS won't waste any time updating them from the server, unless
     as a byproduct of updating something requested.

 (4) Extra results.

     These will only be returned if the caller asked for them by setting their
     bits in request_mask.  They will be placed in the buffer after the xstat
     struct in ascending result_mask bit order.  Any bit set in request_mask
     mask will be left set in result_mask if the result is available and
     cleared otherwise.

     The pointer into the results list will be rounded up to the nearest 8-byte
     boundary after each result is written in.  The size of each extra result
     is specific to the definition for that result.

     No extra results are currently defined.

If the buffer is insufficiently big, the syscall returns the amount of space it
will need to write the complete result set and returns a partial result in the
buffer.

At the moment, this will only work on x86_64 as it requires system calls to be
wired up.


===========
FILESYSTEMS
===========

The following filesystems have been modified to make use of this facility:

 (*) Ext4.  This will return the creation time and inode version number for all
     files.  It will, however, only return the data version number for
     directories unless the I_VERSION option is set on the filesystem.

 (*) AFS.  This will return the vnode ID uniquifier as the inode version and
     the AFS data version number as the data version.  There is no file
     creation time available.

     AFS should go to the server if AT_FORCE_ATTR_SYNC is specified.

 (*) NFS.  This will return the change attribute if NFSv4 only.  No other extra
     values are returned at this time.

     If AT_FORCE_ATTR_SYNC is set or mtime, ctime or data_version (NFSv4 only)
     are asked for then the outstanding writes will be written to the server
     first.

     If AT_FORCE_ATTR_SYNC is set or atime is requested then the attributes
     will be reread unconditionally, otherwise if any of data version (NFSv4
     only) XSTAT_REQUEST__BASIC_STATS are requested, then the attributes will
     be reread if the cached attributes have expired.


=======
TESTING
=======

The following test program can be used to test the xstat system call:

	#define _GNU_SOURCE
	#define _ATFILE_SOURCE
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <unistd.h>
	#include <fcntl.h>
	#include <time.h>
	#include <sys/syscall.h>
	#include <sys/stat.h>
	#include <sys/types.h>

	#define AT_FORCE_ATTR_SYNC	0x800

	struct xstat_parameters {
		unsigned long long	request_mask;
	#define XSTAT_REQUEST_MODE		0x00000001ULL
	#define XSTAT_REQUEST_NLINK		0x00000002ULL
	#define XSTAT_REQUEST_UID		0x00000004ULL
	#define XSTAT_REQUEST_GID		0x00000008ULL
	#define XSTAT_REQUEST_RDEV		0x00000010ULL
	#define XSTAT_REQUEST_ATIME		0x00000020ULL
	#define XSTAT_REQUEST_MTIME		0x00000040ULL
	#define XSTAT_REQUEST_CTIME		0x00000080ULL
	#define XSTAT_REQUEST_INO		0x00000100ULL
	#define XSTAT_REQUEST_SIZE		0x00000200ULL
	#define XSTAT_REQUEST_BLOCKS		0x00000400ULL
	#define XSTAT_REQUEST__BASIC_STATS	0x000007ffULL
	#define XSTAT_REQUEST_BTIME		0x00000800ULL
	#define XSTAT_REQUEST_GEN		0x00001000ULL
	#define XSTAT_REQUEST_DATA_VERSION	0x00002000ULL
	#define XSTAT_REQUEST__EXTENDED_STATS	0x00003fffULL
	#define XSTAT_REQUEST_INODE_FLAGS	0x00004000ULL
	#define XSTAT_REQUEST__ALL_STATS	0x00007fffULL
	#define XSTAT_REQUEST__EXTRA_STATS	(XSTAT_REQUEST__ALL_STATS & ~XSTAT_REQUEST__EXTENDED_STATS)
	};

	struct xstat_dev {
		unsigned int	major;
		unsigned int	minor;
	};

	struct xstat_time {
		unsigned long long	tv_sec;
		unsigned long long	tv_nsec;
	};

	struct xstat {
		unsigned int		st_mode;
		unsigned int		st_nlink;
		unsigned int		st_uid;
		unsigned int		st_gid;
		struct xstat_dev	st_rdev;
		struct xstat_dev	st_dev;
		struct xstat_time	st_atim;
		struct xstat_time	st_mtim;
		struct xstat_time	st_ctim;
		struct xstat_time	st_btim;
		unsigned long long	st_ino;
		unsigned long long	st_size;
		unsigned long long	st_blksize;
		unsigned long long	st_blocks;
		unsigned long long	st_gen;
		unsigned long long	st_data_version;
		unsigned long long	st_result_mask;
		unsigned long long	st_extra_results[0];
	};

	#define __NR_xstat				300
	#define __NR_fxstat				301

	static __attribute__((unused))
	ssize_t xstat(int dfd, const char *filename, unsigned flags,
		      struct xstat_parameters *params,
		      struct xstat *buffer, size_t bufsize)
	{
		return syscall(__NR_xstat, dfd, filename, flags,
			       params, buffer, bufsize);
	}

	static __attribute__((unused))
	ssize_t fxstat(int fd, unsigned flags,
		       struct xstat_parameters *params,
		       struct xstat *buffer, size_t bufsize)
	{
		return syscall(__NR_fxstat, fd, flags,
			       params, buffer, bufsize);
	}

	static void print_time(const char *field, const struct xstat_time *xstm)
	{
		struct tm tm;
		time_t tim;
		char buffer[100];
		int len;

		tim = xstm->tv_sec;
		if (!localtime_r(&tim, &tm)) {
			perror("localtime_r");
			exit(1);
		}
		len = strftime(buffer, 100, "%F %T", &tm);
		if (len == 0) {
			perror("strftime");
			exit(1);
		}
		printf("%s", field);
		fwrite(buffer, 1, len, stdout);
		printf(".%09llu", xstm->tv_nsec);
		len = strftime(buffer, 100, "%z", &tm);
		if (len == 0) {
			perror("strftime2");
			exit(1);
		}
		fwrite(buffer, 1, len, stdout);
		printf("\n");
	}

	static void dump_xstat(struct xstat *xst)
	{
		char buffer[256], ft;

		printf("results=%llx\n", xst->st_result_mask);

		printf(" ");
		if (xst->st_result_mask & XSTAT_REQUEST_SIZE)
			printf(" Size: %-15llu", xst->st_size);
		if (xst->st_result_mask & XSTAT_REQUEST_BLOCKS)
			printf(" Blocks: %-10llu", xst->st_blocks);
		printf(" IO Block: %-6llu ", xst->st_blksize);
		if (xst->st_result_mask & XSTAT_REQUEST_MODE) {
			switch (xst->st_mode & S_IFMT) {
			case S_IFIFO:	printf(" FIFO\n");			ft = 'p'; break;
			case S_IFCHR:	printf(" character special file\n");	ft = 'c'; break;
			case S_IFDIR:	printf(" directory\n");			ft = 'd'; break;
			case S_IFBLK:	printf(" block special file\n");	ft = 'b'; break;
			case S_IFREG:	printf(" regular file\n");		ft = '-'; break;
			case S_IFLNK:	printf(" symbolic link\n");		ft = 'l'; break;
			case S_IFSOCK:	printf(" socket\n");			ft = 's'; break;
			default:
				printf("unknown type (%o)\n", xst->st_mode & S_IFMT);
				ft = '?';
				break;
			}
		}

		sprintf(buffer, "%02x:%02x", xst->st_dev.major, xst->st_dev.minor);
		printf("Device: %-15s", buffer);
		if (xst->st_result_mask & XSTAT_REQUEST_INO)
			printf(" Inode: %-11llu", xst->st_ino);
		if (xst->st_result_mask & XSTAT_REQUEST_SIZE)
			printf(" Links: %-5u", xst->st_nlink);
		if (xst->st_result_mask & XSTAT_REQUEST_RDEV)
			printf(" Device type: %u,%u",
			       xst->st_rdev.major, xst->st_rdev.minor);
		printf("\n");

		if (xst->st_result_mask & XSTAT_REQUEST_MODE)
			printf("Access: (%04o/%c%c%c%c%c%c%c%c%c%c)  ",
			       xst->st_mode & 07777,
			       ft,
			       xst->st_mode & S_IRUSR ? 'r' : '-',
			       xst->st_mode & S_IWUSR ? 'w' : '-',
			       xst->st_mode & S_IXUSR ? 'x' : '-',
			       xst->st_mode & S_IRGRP ? 'r' : '-',
			       xst->st_mode & S_IWGRP ? 'w' : '-',
			       xst->st_mode & S_IXGRP ? 'x' : '-',
			       xst->st_mode & S_IROTH ? 'r' : '-',
			       xst->st_mode & S_IWOTH ? 'w' : '-',
			       xst->st_mode & S_IXOTH ? 'x' : '-');
		if (xst->st_result_mask & XSTAT_REQUEST_UID)
			printf("Uid: %d   \n", xst->st_uid);
		if (xst->st_result_mask & XSTAT_REQUEST_GID)
			printf("Gid: %u\n", xst->st_gid);

		if (xst->st_result_mask & XSTAT_REQUEST_ATIME)
			print_time("Access: ", &xst->st_atim);
		if (xst->st_result_mask & XSTAT_REQUEST_MTIME)
			print_time("Modify: ", &xst->st_mtim);
		if (xst->st_result_mask & XSTAT_REQUEST_CTIME)
			print_time("Change: ", &xst->st_ctim);
		if (xst->st_result_mask & XSTAT_REQUEST_BTIME)
			print_time("Create: ", &xst->st_btim);

		if (xst->st_result_mask & XSTAT_REQUEST_GEN)
			printf("Inode version: %llxh\n", xst->st_gen);
		if (xst->st_result_mask & XSTAT_REQUEST_DATA_VERSION)
			printf("Data version: %llxh\n", xst->st_data_version);
	}

	int main(int argc, char **argv)
	{
		struct xstat_parameters params;
		union {
			struct xstat xst;
			unsigned long long raw[4096 / 8];
		} buffer;
		int ret, atflag = AT_SYMLINK_NOFOLLOW;

		unsigned long long query = XSTAT_REQUEST__ALL_STATS;

		for (argv++; *argv; argv++) {
			if (strcmp(*argv, "-F") == 0) {
				atflag |= AT_FORCE_ATTR_SYNC;
				continue;
			}
			if (strcmp(*argv, "-L") == 0) {
				atflag &= ~AT_SYMLINK_NOFOLLOW;
				continue;
			}
			if (strcmp(*argv, "-O") == 0) {
				query &= ~XSTAT_REQUEST__BASIC_STATS;
				continue;
			}

			memset(&buffer, 0xbf, sizeof(buffer));
			params.request_mask = query;
			ret = xstat(AT_FDCWD, *argv, atflag, &params, &buffer.xst,
				    sizeof(buffer));
			printf("xstat(%s) = %d\n", *argv, ret);
			if (ret < 0) {
				perror(*argv);
				exit(1);
			}

			dump_xstat(&buffer.xst);

			ret = (ret + 7) / 8;
			if (ret > sizeof(buffer.xst) / 8) {
				unsigned offset, print_offset = 1, col = 0;
				if (ret > sizeof(buffer) / 8)
					ret = sizeof(buffer) / 8;

				for (offset = sizeof(buffer.xst) / 8; offset < ret; offset++) {
					if (print_offset) {
						printf("%04x: ", offset * 8);
						print_offset = 0;
					}
					printf("%016llx", buffer.raw[offset]);
					col++;
					if ((col & 3) == 0) {
						printf("\n");
						print_offset = 1;
					} else {
						printf(" ");
					}
				}

				if (!print_offset)
					printf("\n");
			}
		}
		return 0;
	}

Just compile and run, passing it paths to the files you want to examine:

	[root@andromeda ~]# /tmp/xstat -O /dev/tty
	xstat(/dev/tty) = 152
	results=7ff
	  Size: 0               Blocks: 0          IO Block: 4096    character special file
	Device: 00:0f           Inode: 246         Links: 1     Device type: 5,0
	Access: (0666/crw-rw-rw-)  Uid: 0
	Gid: 5
	Access: 2010-06-30 16:25:01.813517001+0100
	Modify: 2010-06-30 16:25:01.813517001+0100
	Change: 2010-06-30 16:25:01.813517001+0100

	[root@andromeda ~]# /tmp/xstat /var/cache/fscache/cache/
	xstat(/var/cache/fscache/cache/) = 152
	results=3fef
	  Size: 4096            Blocks: 16         IO Block: 4096    directory
	Device: 08:06           Inode: 130561      Links: 3
	Access: (0700/drwx------)  Uid: 0
	Gid: 0
	Access: 2010-06-29 18:16:33.680703545+0100
	Modify: 2010-06-29 18:16:20.132786632+0100
	Change: 2010-06-29 18:16:20.132786632+0100
	Create: 2010-06-25 15:17:39.471199293+0100
	Inode version: f585ab70h
	Data version: 2h

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/unistd_32.h |    4 
 arch/x86/include/asm/unistd_64.h |    4 
 fs/afs/inode.c                   |   11 +
 fs/ecryptfs/inode.c              |    6 -
 fs/ext4/ext4.h                   |    2 
 fs/ext4/file.c                   |    2 
 fs/ext4/inode.c                  |   27 +++
 fs/ext4/namei.c                  |    2 
 fs/ext4/symlink.c                |    2 
 fs/nfs/inode.c                   |   46 ++++--
 fs/stat.c                        |  307 +++++++++++++++++++++++++++++++++++---
 include/linux/fcntl.h            |    1 
 include/linux/fs.h               |    3 
 include/linux/stat.h             |  103 +++++++++++++
 include/linux/syscalls.h         |    9 +
 15 files changed, 479 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index beb9b5f..a9953cc 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -343,10 +343,12 @@
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
+#define __NR_xstat		338
+#define __NR_fxstat		339
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 338
+#define NR_syscalls 340
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index ff4307b..c90d240 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,10 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_xstat				300
+__SYSCALL(__NR_xstat, sys_xstat)
+#define __NR_fxstat				301
+__SYSCALL(__NR_fxstat, sys_fxstat)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index ee3190a..f624c5a 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -300,16 +300,17 @@ error_unlock:
 /*
  * read the attributes of an inode
  */
-int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		      struct kstat *stat)
+int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
-	struct inode *inode;
-
-	inode = dentry->d_inode;
+	struct inode *inode = dentry->d_inode;
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
 	generic_fillattr(inode, stat);
+
+	stat->result_mask |= XSTAT_REQUEST_GEN | XSTAT_REQUEST_DATA_VERSION;
+	stat->gen = inode->i_generation;
+	stat->data_version = inode->i_version;
 	return 0;
 }
 
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 31ef525..41bc407 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -994,8 +994,10 @@ int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct kstat lower_stat;
 	int rc;
 
-	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
-			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
+	lower_stat.query_flags = stat->query_flags;
+	lower_stat.request_mask = stat->request_mask | XSTAT_REQUEST_BLOCKS;
+	rc = vfs_xgetattr(ecryptfs_dentry_to_lower_mnt(dentry),
+			  ecryptfs_dentry_to_lower(dentry), &lower_stat);
 	if (!rc) {
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blocks = lower_stat.blocks;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..96823f3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1571,6 +1571,8 @@ extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 				struct kstat *stat);
+extern int  ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
+				struct kstat *stat);
 extern void ext4_delete_inode(struct inode *);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5313ae4..18c29ab 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -150,7 +150,7 @@ const struct file_operations ext4_file_operations = {
 const struct inode_operations ext4_file_inode_operations = {
 	.truncate	= ext4_truncate,
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_file_getattr,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..f9a730a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5550,12 +5550,33 @@ err_out:
 int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
-	struct inode *inode;
-	unsigned long delalloc_blocks;
+	struct inode *inode = dentry->d_inode;
 
-	inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
 
+	stat->result_mask |= XSTAT_REQUEST_BTIME;
+	stat->btime.tv_sec = EXT4_I(inode)->i_crtime.tv_sec;
+	stat->btime.tv_nsec = EXT4_I(inode)->i_crtime.tv_nsec;
+
+	if (inode->i_ino != EXT4_ROOT_INO) {
+		stat->result_mask |= XSTAT_REQUEST_GEN;
+		stat->gen = inode->i_generation;
+	}
+	if (S_ISDIR(inode->i_mode) || test_opt(inode->i_sb, I_VERSION)) {
+		stat->result_mask |= XSTAT_REQUEST_DATA_VERSION;
+		stat->data_version = inode->i_version;
+	}
+	return 0;
+}
+
+int ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		      struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+	unsigned long delalloc_blocks;
+
+	ext4_getattr(mnt, dentry, stat);
+
 	/*
 	 * We can't update i_blocks if the block allocation is delayed
 	 * otherwise in the case of system crash before the real block
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a43e661..0f776c7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2542,6 +2542,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.mknod		= ext4_mknod,
 	.rename		= ext4_rename,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
@@ -2554,6 +2555,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 
 const struct inode_operations ext4_special_inode_operations = {
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index ed9354a..d8fe7fb 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -35,6 +35,7 @@ const struct inode_operations ext4_symlink_inode_operations = {
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
@@ -47,6 +48,7 @@ const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= ext4_follow_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 099b351..8c6de96 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -495,11 +495,21 @@ void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr)
 int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
+	unsigned force = stat->query_flags & AT_FORCE_ATTR_SYNC;
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
 	int err;
 
-	/* Flush out writes to the server in order to update c/mtime.  */
-	if (S_ISREG(inode->i_mode)) {
+	if (NFS_SERVER(inode)->nfs_client->rpc_ops->version < 4)
+		stat->request_mask &= ~XSTAT_REQUEST_DATA_VERSION;
+
+	/* Flush out writes to the server in order to update c/mtime
+	 * or data version if the user wants them */
+	if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME |
+					    XSTAT_REQUEST_CTIME |
+					    XSTAT_REQUEST_DATA_VERSION
+					    )) &&
+	    S_ISREG(inode->i_mode)
+	    ) {
 		err = filemap_write_and_wait(inode->i_mapping);
 		if (err)
 			goto out;
@@ -514,18 +524,30 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	 *  - NFS never sets MS_NOATIME or MS_NODIRATIME so there is
 	 *    no point in checking those.
 	 */
- 	if ((mnt->mnt_flags & MNT_NOATIME) ||
- 	    ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
+	if (!(stat->request_mask & XSTAT_REQUEST_ATIME) ||
+	    (mnt->mnt_flags & MNT_NOATIME) ||
+	    ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
 		need_atime = 0;
 
-	if (need_atime)
-		err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	else
-		err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	if (!err) {
-		generic_fillattr(inode, stat);
-		stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
+	if (force || stat->request_mask & (XSTAT_REQUEST__BASIC_STATS |
+					   XSTAT_REQUEST_DATA_VERSION)
+	    ) {
+		if (force || need_atime)
+			err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		else
+			err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		if (err)
+			goto out;
 	}
+
+	generic_fillattr(inode, stat);
+	stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
+
+	if (stat->request_mask & XSTAT_REQUEST_DATA_VERSION) {
+		stat->data_version = NFS_I(inode)->change_attr;
+		stat->result_mask |= XSTAT_REQUEST_DATA_VERSION;
+	}
+
 out:
 	return err;
 }
@@ -770,7 +792,7 @@ int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 static int nfs_invalidate_mapping(struct inode *inode, struct address_space *mapping)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
-	
+
 	if (mapping->nrpages != 0) {
 		int ret = invalidate_inode_pages2(mapping);
 		if (ret < 0)
diff --git a/fs/stat.c b/fs/stat.c
index 12e90e2..defed4f 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -18,6 +18,15 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
+/**
+ * generic_fillattr - Fill in the basic attributes from the inode struct
+ * @inode: Inode to use as the source
+ * @stat: Where to fill in the attributes
+ *
+ * Fill in the basic attributes in the kstat structure from data that's to be
+ * found on the VFS inode structure.  This is the default if no getattr inode
+ * operation is supplied.
+ */
 void generic_fillattr(struct inode *inode, struct kstat *stat)
 {
 	stat->dev = inode->i_sb->s_dev;
@@ -33,11 +42,34 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->size = i_size_read(inode);
 	stat->blocks = inode->i_blocks;
 	stat->blksize = (1 << inode->i_blkbits);
+	stat->result_mask |= XSTAT_REQUEST__BASIC_STATS & ~XSTAT_REQUEST_RDEV;
+	if (unlikely(S_ISBLK(stat->mode) || S_ISCHR(stat->mode)))
+		stat->result_mask |= XSTAT_REQUEST_RDEV;
 }
-
 EXPORT_SYMBOL(generic_fillattr);
 
-int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+/**
+ * vfs_xgetattr - Get the extended attributes of a file
+ * @mnt: The mountpoint to which the dentry belongs
+ * @dentry: The file of interest
+ * @stat: Where to return the statistics
+ *
+ * Ask the filesystem for a file's attributes.  The caller must have preset
+ * stat->request_mask and stat->query_flags to indicate what they want.
+ *
+ * If the file is remote, the filesystem can be forced to update the attributes
+ * from the backing store by passing AT_FORCE_ATTR_SYNC in query_flags.
+ *
+ * Bits must have been set in stat->request_mask to indicate which attributes
+ * the caller wants retrieving.  Only attributes from the set
+ * XSTAT_REQUEST__EXTENDED_STATS can be retrieved through this interface.  Any
+ * such attribute not requested may be returned anyway, but the value may be
+ * approximate, and, if remote, may not have been synchronised with the server.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_xgetattr(struct vfsmount *mnt, struct dentry *dentry,
+		 struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
 	int retval;
@@ -46,61 +78,176 @@ int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	if (retval)
 		return retval;
 
+	stat->result_mask = 0;
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(mnt, dentry, stat);
 
 	generic_fillattr(inode, stat);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_xgetattr);
 
+/**
+ * vfs_getattr - Get the basic attributes of a file
+ * @mnt: The mountpoint to which the dentry belongs
+ * @dentry: The file of interest
+ * @stat: Where to return the statistics
+ *
+ * Ask the filesystem for a file's attributes.  If remote, the filesystem isn't
+ * forced to update its files from the backing store.  Only the basic set of
+ * attributes will be retrieved; anyone wanting more must use vfs_getxattr(),
+ * as must anyone who wants to force attributes to be sync'd with the server.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+{
+	stat->query_flags = 0;
+	stat->request_mask = XSTAT_REQUEST__BASIC_STATS;
+	return vfs_xgetattr(mnt, dentry, stat);
+}
 EXPORT_SYMBOL(vfs_getattr);
 
-int vfs_fstat(unsigned int fd, struct kstat *stat)
+/**
+ * vfs_fxstat - Get extended attributes by file descriptor
+ * @fd: The file descriptor refering to the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xgetattr().  The main difference is
+ * that it uses a file descriptor to determine the file location.
+ *
+ * The caller must have preset stat->query_flags and stat->request_mask as for
+ * vfs_xgetattr().
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fxstat(unsigned int fd, struct kstat *stat)
 {
 	struct file *f = fget(fd);
 	int error = -EBADF;
 
+	if (stat->query_flags & ~KSTAT_QUERY_FLAGS)
+		return -EINVAL;
 	if (f) {
-		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
+		error = vfs_xgetattr(f->f_path.mnt, f->f_path.dentry, stat);
 		fput(f);
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_fxstat);
+
+/**
+ * vfs_fstat - Get basic attributes by file descriptor
+ * @fd: The file descriptor refering to the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_getattr().  The main difference is
+ * that it uses a file descriptor to determine the file location.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fstat(unsigned int fd, struct kstat *stat)
+{
+	stat->query_flags = 0;
+	stat->request_mask = XSTAT_REQUEST__BASIC_STATS;
+	return vfs_fxstat(fd, stat);
+}
 EXPORT_SYMBOL(vfs_fstat);
 
-int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
-		int flag)
+/**
+ * vfs_xstat - Get extended attributes by filename
+ * @dfd: A file descriptor representing the base dir for a relative filename
+ * @filename: The name of the file of interest
+ * @flags: Flags to control the query
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xgetattr().  The main difference is
+ * that it uses a filename and base directory to determine the file location.
+ * Additionally, the addition of AT_SYMLINK_NOFOLLOW to flags will prevent a
+ * symlink at the given name from being referenced.
+ *
+ * The caller must have preset stat->request_mask as for vfs_xgetattr().  The
+ * flags are also used to load up stat->query_flags.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_xstat(int dfd, const char __user *filename, int flags,
+	      struct kstat *stat)
 {
 	struct path path;
-	int error = -EINVAL;
-	int lookup_flags = 0;
+	int error, lookup_flags;
 
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | KSTAT_QUERY_FLAGS))
+		return -EINVAL;
 
-	if (!(flag & AT_SYMLINK_NOFOLLOW))
-		lookup_flags |= LOOKUP_FOLLOW;
+	stat->query_flags = flags & KSTAT_QUERY_FLAGS;
+	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
 
 	error = user_path_at(dfd, filename, lookup_flags, &path);
-	if (error)
-		goto out;
-
-	error = vfs_getattr(path.mnt, path.dentry, stat);
-	path_put(&path);
-out:
+	if (!error) {
+		error = vfs_xgetattr(path.mnt, path.dentry, stat);
+		path_put(&path);
+	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_xstat);
+
+/**
+ * vfs_fstatat - Get basic attributes by filename
+ * @dfd: A file descriptor representing the base dir for a relative filename
+ * @filename: The name of the file of interest
+ * @flags: Flags to control the query
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xstat().  The difference is that it
+ * preselects basic stats only.  The flags are used to load up
+ * stat->query_flags in addition to indicating symlink handling during path
+ * resolution.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
+		int flags)
+{
+	stat->request_mask = XSTAT_REQUEST__BASIC_STATS;
+	return vfs_xstat(dfd, filename, flags, stat);
+}
 EXPORT_SYMBOL(vfs_fstatat);
 
-int vfs_stat(const char __user *name, struct kstat *stat)
+/**
+ * vfs_stat - Get basic attributes by filename
+ * @filename: The name of the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xstat().  The difference is that it
+ * preselects basic stats only, terminal symlinks are followed regardless and a
+ * remote filesystem can't be forced to query the server.  If such is desired,
+ * vfs_xstat() should be used instead.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_stat(const char __user *filename, struct kstat *stat)
 {
-	return vfs_fstatat(AT_FDCWD, name, stat, 0);
+	stat->request_mask = XSTAT_REQUEST__BASIC_STATS;
+	return vfs_xstat(AT_FDCWD, filename, 0, stat);
 }
 EXPORT_SYMBOL(vfs_stat);
 
+/**
+ * vfs_stat - Get basic attributes by filename, without following terminal symlink
+ * @filename: The name of the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xstat().  The difference is that it
+ * preselects basic stats only, terminal symlinks are note followed regardless
+ * and a remote filesystem can't be forced to query the server.  If such is
+ * desired, vfs_xstat() should be used instead.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
 int vfs_lstat(const char __user *name, struct kstat *stat)
 {
-	return vfs_fstatat(AT_FDCWD, name, stat, AT_SYMLINK_NOFOLLOW);
+	return vfs_xstat(AT_FDCWD, name, AT_SYMLINK_NOFOLLOW, stat);
 }
 EXPORT_SYMBOL(vfs_lstat);
 
@@ -115,7 +262,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 {
 	static int warncount = 5;
 	struct __old_kernel_stat tmp;
-	
+
 	if (warncount > 0) {
 		warncount--;
 		printk(KERN_WARNING "VFS: Warning: %s using old stat() call. Recompile your binary.\n",
@@ -140,7 +287,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -222,7 +369,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -408,6 +555,118 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 */
 
+/*
+ * Get the xstat parameters if supplied
+ */
+static int xstat_get_params(struct xstat_parameters __user *_params,
+			    struct kstat *stat)
+{
+	struct xstat_parameters params;
+
+	memset(stat, 0xde, sizeof(*stat));	// DEBUGGING
+
+	if (_params) {
+		if (copy_from_user(&params, _params, sizeof(params)) != 0)
+			return -EFAULT;
+		stat->request_mask =
+			params.request_mask & XSTAT_REQUEST__ALL_STATS;
+	} else {
+		stat->request_mask = XSTAT_REQUEST__EXTENDED_STATS;
+	}
+	stat->result_mask = 0;
+	return 0;
+}
+
+/*
+ * copy the extended stats to userspace and return the amount of data written
+ * into the buffer
+ */
+static long xstat_set_result(struct kstat *stat,
+			     struct xstat __user *buffer, size_t bufsize)
+{
+	struct xstat tmp;
+	size_t copy;
+
+	/* transfer the fixed results */
+	memset(&tmp, 0, sizeof(tmp));
+	tmp.st_result_mask	= stat->result_mask;
+	tmp.st_mode		= stat->mode;
+	tmp.st_nlink		= stat->nlink;
+	tmp.st_uid		= stat->uid;
+	tmp.st_gid		= stat->gid;
+	tmp.st_blksize		= stat->blksize;
+	tmp.st_rdev.major	= MAJOR(stat->rdev);
+	tmp.st_rdev.minor	= MINOR(stat->rdev);
+	tmp.st_dev.major	= MAJOR(stat->dev);
+	tmp.st_dev.minor	= MINOR(stat->dev);
+	tmp.st_atime.tv_sec	= stat->atime.tv_sec;
+	tmp.st_atime.tv_nsec	= stat->atime.tv_nsec;
+	tmp.st_mtime.tv_sec	= stat->mtime.tv_sec;
+	tmp.st_mtime.tv_nsec	= stat->mtime.tv_nsec;
+	tmp.st_ctime.tv_sec	= stat->ctime.tv_sec;
+	tmp.st_ctime.tv_nsec	= stat->ctime.tv_nsec;
+	tmp.st_ino		= stat->ino;
+	tmp.st_size		= stat->size;
+	tmp.st_blocks		= stat->blocks;
+
+	if (tmp.st_result_mask & XSTAT_REQUEST_BTIME) {
+		tmp.st_btime.tv_sec	= stat->btime.tv_sec;
+		tmp.st_btime.tv_nsec	= stat->btime.tv_nsec;
+	}
+	if (tmp.st_result_mask & XSTAT_REQUEST_GEN)
+		tmp.st_gen		= stat->gen;
+	if (tmp.st_result_mask & XSTAT_REQUEST_DATA_VERSION)
+		tmp.st_data_version	= stat->data_version;
+
+	copy = sizeof(tmp);
+	if (copy > bufsize)
+		copy = bufsize;
+	if (copy_to_user(buffer, &tmp, copy) != 0)
+		return -EFAULT;
+	return sizeof(tmp);
+}
+
+/*
+ * System call to get extended stats by path
+ */
+SYSCALL_DEFINE6(xstat,
+		int, dfd, const char __user *, filename, unsigned, atflag,
+		struct xstat_parameters __user *, params,
+		struct xstat __user *, buffer, size_t, bufsize)
+{
+	struct kstat stat;
+	int error;
+
+	error = xstat_get_params(params, &stat);
+	if (error != 0)
+		return error;
+	error = vfs_xstat(dfd, filename, atflag, &stat);
+	if (error)
+		return error;
+	return xstat_set_result(&stat, buffer, bufsize);
+}
+
+/*
+ * System call to get extended stats by file descriptor
+ */
+SYSCALL_DEFINE5(fxstat, unsigned int, fd, unsigned int, flags,
+		struct xstat_parameters __user *, params,
+		struct xstat __user *, buffer, size_t, bufsize)
+{
+	struct kstat stat;
+	int error;
+
+	error = xstat_get_params(params, &stat);
+	if (error < 0)
+		return error;
+	stat.query_flags = flags;
+	error = vfs_fxstat(fd, &stat);
+	if (error)
+		return error;
+
+	return xstat_set_result(&stat, buffer, bufsize);
+}
+
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
 void __inode_add_bytes(struct inode *inode, loff_t bytes)
 {
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index afc00af..bcf8083 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -45,6 +45,7 @@
 #define AT_REMOVEDIR		0x200   /* Remove directory instead of
                                            unlinking file.  */
 #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
+#define AT_FORCE_ATTR_SYNC	0x800	/* Force the attributes to be sync'd with the server */
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a18bcea..37cadd8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2331,6 +2331,7 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int vfs_xgetattr(struct vfsmount *, struct dentry *, struct kstat *);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
@@ -2343,6 +2344,8 @@ extern int vfs_stat(const char __user *, struct kstat *);
 extern int vfs_lstat(const char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , const char __user *, struct kstat *, int);
+extern int vfs_xstat(int, const char __user *, int, struct kstat *);
+extern int vfs_xfstat(unsigned int, struct kstat *);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 611c398..e0b89e4 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -46,6 +46,99 @@
 
 #endif
 
+/*
+ * Extended stat structures
+ */
+struct xstat_parameters {
+	/* Query request/result mask
+	 *
+	 * Bits should be set in request_mask to request particular items
+	 * before calling xstat() or fxstat().
+	 *
+	 * For each item in the set XSTAT_REQUEST__EXTENDED_STATS:
+	 *
+	 * - if not available at all, the bit will be cleared before returning
+	 *   and the field will be cleared; otherwise,
+	 *
+	 * - if AT_FORCE_ATTR_SYNC is set, then the datum will be synchronised
+	 *   to the server and the bit will be set on return; otherwise,
+	 *
+	 * - if requested, the datum will be synchronised to a server or other
+	 *   hardware if out of date before being returned, and the bit will be
+	 *   set on return; otherwise,
+	 *
+	 * - if not requested, but available in approximate form without any
+	 *   effort, it will be filled in anyway, and the bit will be set upon
+	 *   return (it might not be up to date, however, and no attempt will
+	 *   be made to synchronise the internal state first); otherwise,
+	 *
+	 * - the bit will be cleared before returning, and the field will be
+         *   cleared.
+	 *
+	 * For each item not in the set XSTAT_REQUEST__EXTENDED_STATS
+	 * 
+	 * - if not available at all, the bit will be cleared, and no result
+         *   data will be returned; otherwise,
+	 *
+	 * - if requested, the datum will be synchronised to a server or other
+	 *   hardware before being appended if necessary, and the bit will be
+	 *   set on return; otherwise,
+	 * 
+	 * - the bit will be cleared, and no result data will be returned.
+	 *
+	 * Items in XSTAT_REQUEST__BASIC_STATS may be marked unavailable on
+	 * return, but they will have a value installed for compatibility
+	 * purposes.
+	 */
+	unsigned long long	request_mask;
+#define XSTAT_REQUEST_MODE		0x00000001ULL	/* want/got st_mode */
+#define XSTAT_REQUEST_NLINK		0x00000002ULL	/* want/got st_nlink */
+#define XSTAT_REQUEST_UID		0x00000004ULL	/* want/got st_uid */
+#define XSTAT_REQUEST_GID		0x00000008ULL	/* want/got st_gid */
+#define XSTAT_REQUEST_RDEV		0x00000010ULL	/* want/got st_rdev */
+#define XSTAT_REQUEST_ATIME		0x00000020ULL	/* want/got st_atime */
+#define XSTAT_REQUEST_MTIME		0x00000040ULL	/* want/got st_mtime */
+#define XSTAT_REQUEST_CTIME		0x00000080ULL	/* want/got st_ctime */
+#define XSTAT_REQUEST_INO		0x00000100ULL	/* want/got st_ino */
+#define XSTAT_REQUEST_SIZE		0x00000200ULL	/* want/got st_size */
+#define XSTAT_REQUEST_BLOCKS		0x00000400ULL	/* want/got st_blocks */
+#define XSTAT_REQUEST__BASIC_STATS	0x000007ffULL	/* the stuff in the normal stat struct */
+#define XSTAT_REQUEST_BTIME		0x00000800ULL	/* want/got st_btime */
+#define XSTAT_REQUEST_GEN		0x00001000ULL	/* want/got st_gen */
+#define XSTAT_REQUEST_DATA_VERSION	0x00002000ULL	/* want/got st_data_version */
+#define XSTAT_REQUEST__EXTENDED_STATS	0x00003fffULL	/* the stuff in the xstat struct */
+#define XSTAT_REQUEST__ALL_STATS	0x00003fffULL	/* the defined set of requestables */
+};
+
+struct xstat_dev {
+	unsigned int		major, minor;
+};
+
+struct xstat_time {
+	unsigned long long	tv_sec, tv_nsec;
+};
+
+struct xstat {
+	unsigned int		st_mode;	/* file mode */
+	unsigned int		st_nlink;	/* number of hard links */
+	unsigned int		st_uid;		/* user ID of owner */
+	unsigned int		st_gid;		/* group ID of owner */
+	struct xstat_dev	st_rdev;	/* device ID of special file */
+	struct xstat_dev	st_dev;		/* ID of device containing file */
+	struct xstat_time	st_atime;	/* last access time */
+	struct xstat_time	st_mtime;	/* last data modification time */
+	struct xstat_time	st_ctime;	/* last attribute change time */
+	struct xstat_time	st_btime;	/* file creation time */
+	unsigned long long	st_ino;		/* inode number */
+	unsigned long long	st_size;	/* file size */
+	unsigned long long	st_blksize;	/* block size for filesystem I/O */
+	unsigned long long	st_blocks;	/* number of 512-byte blocks allocated */
+	unsigned long long	st_gen;		/* inode generation number */
+	unsigned long long	st_data_version; /* data version number */
+	unsigned long long	st_result_mask;	/* what requests were written */
+	unsigned long long	st_extra_results[0]; /* extra requested results */
+};
+
 #ifdef __KERNEL__
 #define S_IRWXUGO	(S_IRWXU|S_IRWXG|S_IRWXO)
 #define S_IALLUGO	(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
@@ -67,14 +160,20 @@ struct kstat {
 	uid_t		uid;
 	gid_t		gid;
 	dev_t		rdev;
+	unsigned int	query_flags;		/* operational flags */
+#define KSTAT_QUERY_FLAGS (AT_FORCE_ATTR_SYNC)
 	loff_t		size;
-	struct timespec  atime;
+	struct timespec	atime;
 	struct timespec	mtime;
 	struct timespec	ctime;
+	struct timespec	btime;			/* file creation time */
 	unsigned long	blksize;
 	unsigned long long	blocks;
+	u64		request_mask;		/* what fields the user asked for */
+	u64		result_mask;		/* what fields the user got */
+	u64		gen;			/* inode generation */
+	u64		data_version;
 };
 
 #endif
-
 #endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8812a63..5d68b4c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -44,6 +44,8 @@ struct shmid_ds;
 struct sockaddr;
 struct stat;
 struct stat64;
+struct xstat_parameters;
+struct xstat;
 struct statfs;
 struct statfs64;
 struct __sysctl_args;
@@ -824,4 +826,11 @@ asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
 			unsigned long fd, unsigned long pgoff);
 asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
 
+asmlinkage long sys_xstat(int, const char __user *, unsigned,
+			  struct xstat_parameters __user *,
+			  struct xstat __user *, size_t);
+asmlinkage long sys_fxstat(unsigned, unsigned,
+			   struct xstat_parameters __user *,
+			   struct xstat __user *, size_t);
+
 #endif

