From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] Add a pair of system calls to make extended file stats
	available
Date: Tue, 29 Jun 2010 21:03:15 +0100
Message-ID: <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100629200259.23196.81509.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Add a pair of system calls to make extended file stats available, including
file creation time, inode version and data version where available through the
underlying filesystem:

	struct xstat_dev {
		unsigned int	major;
		unsigned int	minor;
	};

	struct xstat_time {
		unsigned long long	tv_sec;
		unsigned long long	tv_nsec;
	};

	struct xstat {
		unsigned int		struct_version;
	#define XSTAT_STRUCT_VERSION	0
		unsigned int		st_mode;
		unsigned int		st_nlink;
		unsigned int		st_uid;
		unsigned int		st_gid;
		unsigned int		st_blksize;
		struct xstat_dev	st_rdev;
		struct xstat_dev	st_dev;
		unsigned long long	st_ino;
		unsigned long long	st_size;
		struct xstat_time	st_atime;
		struct xstat_time	st_mtime;
		struct xstat_time	st_ctime;
		struct xstat_time	st_crtime;
		unsigned long long	st_blocks;
		unsigned long long	st_inode_version;
		unsigned long long	st_data_version;
		unsigned long long	query_flags;
	#define XSTAT_QUERY_CREATION_TIME	0x00000001ULL
	#define XSTAT_QUERY_INODE_VERSION	0x00000002ULL
	#define XSTAT_QUERY_DATA_VERSION	0x00000004ULL
		unsigned long long	extra_results[0];
	};

	ssize_t ret = xstat(int dfd,
			    const char *filename,
			    unsigned atflag,
			    struct xstat *buffer,
			    size_t buflen);

	ssize_t ret = fxstat(int fd,
			     struct xstat *buffer,
			     size_t buflen);


The dfd, filename, atflag and fd parameters indicate the file to query.  There
is no equivalent of lstat() as that can be emulated with xstat(), passing 0
instead of AT_SYMLINK_NOFOLLOW as atflag.

When the system call is executed, the struct_version ID and query_flags bitmask
are read from the buffer to work out what the user is requesting.

If the structure version specified is not supported, the system call will
return ENOTSUPP.  The above structure is version 0.

The query_flags should be set by the caller to specify extra results that the
caller may desire.  These come in two classes:

 (1) Creation time, Inode version and Data version.

     These will be returned if available whether the caller asked for them or
     not.  The corresponding bits in query_flags will be set or cleared as
     appropriate to indicate their presence.

	Query Flag			Field
	===============================	================
	XSTAT_QUERY_CREATION_TIME	st_crtime
	XSTAT_QUERY_INODE_VERSION	st_inode_version
	XSTAT_QUERY_DATA_VERSION	st_data_version

 (2) Extra results.

     These will only be returned if the caller asked for them by setting their
     bits in query_flags.  They will be placed in the buffer after the xstat
     struct in ascending query_flags bit order.  Any bit set in query_flags
     mask will be left set if the result is available and cleared otherwise.

     The pointer into the results list will be rounded up to the nearest 8-byte
     boundary after each result is written in.  The size of each extra result
     is specific to the definition for that result.

     No extra results are currently defined.

If the buffer is insufficiently big, the syscall returns the amount of space it
will need to write the complete result set, but otherwise does nothing.

If successful, the amount of data written into the buffer will be returned.

At the moment, this will only work on x86_64 as it requires system calls to be
wired up.


===========
FILESYSTEMS
===========

Ext4 is modified to make use of this facility.  It will return the creation
time and inode version number for all files.  It will, however, only return the
data version number for directories as i_version is only maintained for them.

AFS is modified to make use of this facility too.  It will return the vnode ID
uniquifier as the inode version and the AFS data version number as the data
version.  There is no file creation time available.


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

	struct xstat_dev {
		unsigned int	major;
		unsigned int	minor;
	};

	struct xstat_time {
		unsigned long long	tv_sec;
		unsigned long long	tv_nsec;
	};

	struct xstat {
		unsigned int		struct_version;
	#define XSTAT_STRUCT_VERSION	0
		unsigned int		st_mode;
		unsigned int		st_nlink;
		unsigned int		st_uid;
		unsigned int		st_gid;
		unsigned int		st_blksize;
		struct xstat_dev	st_rdev;
		struct xstat_dev	st_dev;
		unsigned long long	st_ino;
		unsigned long long	st_size;
		struct xstat_time	st_atim;
		struct xstat_time	st_mtim;
		struct xstat_time	st_ctim;
		struct xstat_time	st_crtim;
		unsigned long long	st_blocks;
		unsigned long long	st_inode_version;
		unsigned long long	st_data_version;
		unsigned long long	query_flags;
	#define XSTAT_QUERY_CREATION_TIME	0x00000001ULL
	#define XSTAT_QUERY_INODE_VERSION	0x00000002ULL
	#define XSTAT_QUERY_DATA_VERSION	0x00000004ULL
		unsigned long long	extra_results[0];
	};

	#define __NR_xstat				300
	#define __NR_fxstat				301

	static __attribute__((unused))
	ssize_t xstat(int dfd, const char *filename, int atflag,
			     struct xstat *buffer, size_t bufsize)
	{
		return syscall(__NR_xstat, dfd, filename, atflag, buffer, bufsize);
	}

	static __attribute__((unused))
	ssize_t fxstat(int fd, struct xstat *buffer, size_t bufsize)
	{
		return syscall(__NR_fxstat, fd, buffer, bufsize);
	}

	static void print_time(const struct xstat_time *xstm)
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
		fwrite(buffer, 1, len, stdout);
		printf(".%09llu", xstm->tv_nsec);
		len = strftime(buffer, 100, "%z", &tm);
		if (len == 0) {
			perror("strftime2");
			exit(1);
		}
		fwrite(buffer, 1, len, stdout);
	}

	static void dump_xstat(struct xstat *xst)
	{
		char buffer[256], ft;

		printf("  Size: %-15llu Blocks: %-10llu IO Block: %-6u ",
		       xst->st_size, xst->st_blocks, xst->st_blksize);
		switch (xst->st_mode & S_IFMT) {
		case S_IFIFO:	printf("FIFO\n");			ft = 'p'; break;
		case S_IFCHR:	printf("character special file\n");	ft = 'c'; break;
		case S_IFDIR:	printf("directory\n");			ft = 'd'; break;
		case S_IFBLK:	printf("block special file\n");		ft = 'b'; break;
		case S_IFREG:	printf("regular file\n");		ft = '-'; break;
		case S_IFLNK:	printf("symbolic link\n");		ft = 'l'; break;
		case S_IFSOCK:	printf("socket\n");			ft = 's'; break;
		default:
			printf("unknown type (%o)\n", xst->st_mode & S_IFMT);
			ft = '?';
			break;
		}

		sprintf(buffer, "%02x:%02x", xst->st_dev.major, xst->st_dev.minor);
		printf("Device: %-15s Inode: %-11llu Links: %u\n",
		       buffer, xst->st_ino, xst->st_nlink);

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
		printf("Uid: %d   Gid: %u\n", xst->st_uid, xst->st_gid);

		printf("Access: "); print_time(&xst->st_atim); printf("\n");
		printf("Modify: "); print_time(&xst->st_mtim); printf("\n");
		printf("Change: "); print_time(&xst->st_ctim); printf("\n");
		if (xst->query_flags & XSTAT_QUERY_CREATION_TIME) {
			printf("Create: "); print_time(&xst->st_crtim); printf("\n");
		}

		if (xst->query_flags & XSTAT_QUERY_INODE_VERSION)
			printf("Inode version: %llxh\n", xst->st_inode_version);
		if (xst->query_flags & XSTAT_QUERY_DATA_VERSION)
			printf("Data version: %llxh\n", xst->st_data_version);
	}

	int main(int argc, char **argv)
	{
		struct xstat xst;
		int ret, atflag = AT_SYMLINK_NOFOLLOW;

		for (argv++; *argv; argv++) {
			if (strcmp(*argv, "-L") == 0) {
				atflag = 0;
				continue;
			}

			memset(&xst, 0xbf, sizeof(xst));
			xst.struct_version = 0;
			xst.query_flags = XSTAT_QUERY_CREATION_TIME |
				XSTAT_QUERY_INODE_VERSION |
				XSTAT_QUERY_DATA_VERSION;
			ret = xstat(AT_FDCWD, *argv, atflag, &xst, sizeof(xst));
			printf("xstat(%s) = %d\n", *argv, ret);
			if (ret < 0) {
				perror(*argv);
				exit(1);
			}

			dump_xstat(&xst);
		}
		return 0;
	}

Just compile and run, passing it paths to the files you want to examine:

	[root@andromeda ~]# /tmp/xstat /var/cache/fscache/cache/
	xstat(/var/cache/fscache/cache/) = 152
	  Size: 4096            Blocks: 16         IO Block: 4096   directory
	Device: 08:06           Inode: 130561      Links: 3
	Access: (0700/drwx------)  Uid: 0   Gid: 0
	Access: 2010-06-29 18:16:33.680703545+0100
	Modify: 2010-06-29 18:16:20.132786632+0100
	Change: 2010-06-29 18:16:20.132786632+0100
	Create: 2010-06-25 15:17:39.471199293+0100
	Inode version: f585ab70h
	Data version: 2h
	[root@andromeda ~]# /tmp/xstat /afs/archive/linuxdev/fedora9/i386/repodata/
	xstat(/afs/archive/linuxdev/fedora9/i386/repodata/) = 152
	  Size: 2048            Blocks: 0          IO Block: 4096   directory
	Device: 00:13           Inode: 83          Links: 2
	Access: (0755/drwxr-xr-x)  Uid: 75338   Gid: 0
	Access: 2008-11-05 20:00:12.000000000+0000
	Modify: 2008-11-05 20:00:12.000000000+0000
	Change: 2008-11-05 20:00:12.000000000+0000
	Inode version: 7a5h
	Data version: 5h


Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/x86/include/asm/unistd_32.h |    4 +
 arch/x86/include/asm/unistd_64.h |    4 +
 fs/afs/inode.c                   |   12 ++--
 fs/ext4/ext4.h                   |    2 +
 fs/ext4/file.c                   |    2 -
 fs/ext4/inode.c                  |   27 +++++++-
 fs/ext4/namei.c                  |    2 +
 fs/ext4/symlink.c                |    2 +
 fs/stat.c                        |  125 +++++++++++++++++++++++++++++++++++++-
 include/linux/stat.h             |   46 ++++++++++++++
 include/linux/syscalls.h         |    5 ++
 11 files changed, 217 insertions(+), 14 deletions(-)

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
index ee3190a..1b5b4c8 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -300,16 +300,18 @@ error_unlock:
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
+	stat->result_flags |=
+		XSTAT_QUERY_INODE_VERSION | XSTAT_QUERY_DATA_VERSION;
+	stat->inode_version = inode->i_generation;
+	stat->data_version = inode->i_version;
 	return 0;
 }
 
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
index 42272d6..8e374f3 100644
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
 
+	stat->result_flags |= XSTAT_QUERY_CREATION_TIME;
+	stat->crtime.tv_sec = EXT4_I(inode)->i_crtime.tv_sec;
+	stat->crtime.tv_nsec = EXT4_I(inode)->i_crtime.tv_nsec;
+
+	if (inode->i_ino != EXT4_ROOT_INO) {
+		stat->result_flags |= XSTAT_QUERY_INODE_VERSION;
+		stat->inode_version = inode->i_generation;
+	}
+	if (S_ISDIR(inode->i_mode)) {
+		stat->result_flags |= XSTAT_QUERY_DATA_VERSION;
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
diff --git a/fs/stat.c b/fs/stat.c
index 12e90e2..5edb63a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -115,7 +115,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 {
 	static int warncount = 5;
 	struct __old_kernel_stat tmp;
-	
+
 	if (warncount > 0) {
 		warncount--;
 		printk(KERN_WARNING "VFS: Warning: %s using old stat() call. Recompile your binary.\n",
@@ -140,7 +140,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -222,7 +222,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -408,6 +408,125 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 */
 
+/*
+ * check the input parameters in the xstat struct
+ */
+static noinline int xstat_check_param(struct xstat __user *buffer, size_t bufsize,
+			     struct kstat *stat)
+{
+	u32 struct_version;
+	int ret;
+
+	/* if the buffer isn't large enough, return how much we wanted to
+	 * write, but otherwise do nothing */
+	if (bufsize < sizeof(struct xstat))
+		return sizeof(struct xstat);
+
+	ret = get_user(struct_version, &buffer->struct_version);
+	if (ret < 0)
+		return ret;
+	if (struct_version != 0)
+		return -ENOTSUPP;
+
+	memset(stat, 0xde, sizeof(*stat));
+
+	ret = get_user(stat->query_flags, &buffer->query_flags);
+	if (ret < 0)
+		return ret;
+
+	/* nothing outside this set has a defined purpose */
+	stat->query_flags &= (XSTAT_QUERY_CREATION_TIME |
+			      XSTAT_QUERY_INODE_VERSION |
+			      XSTAT_QUERY_DATA_VERSION);
+
+	/* the user gets these whatever */
+	stat->query_flags |= (XSTAT_QUERY_CREATION_TIME |
+			      XSTAT_QUERY_INODE_VERSION |
+			      XSTAT_QUERY_DATA_VERSION);
+	stat->result_flags = 0;
+	return 0;
+}
+
+/*
+ * copy the extended stats to userspace and return the amount of data written
+ * into the buffer
+ */
+static noinline long xstat_set_result(struct kstat *stat,
+			     struct xstat __user *buffer, size_t bufsize)
+{
+	struct xstat tmp;
+
+	memset(&tmp, 0, sizeof(tmp));
+	tmp.struct_version	= XSTAT_STRUCT_VERSION;
+	tmp.query_flags		= stat->result_flags;
+	tmp.st_dev.major	= MAJOR(stat->dev);
+	tmp.st_dev.minor	= MINOR(stat->dev);
+	tmp.st_rdev.major	= MAJOR(stat->rdev);
+	tmp.st_rdev.minor	= MINOR(stat->rdev);
+	tmp.st_ino		= stat->ino;
+	tmp.st_mode		= stat->mode;
+	tmp.st_nlink		= stat->nlink;
+	tmp.st_uid		= stat->uid;
+	tmp.st_gid		= stat->gid;
+	tmp.st_atime.tv_sec	= stat->atime.tv_sec;
+	tmp.st_atime.tv_nsec	= stat->atime.tv_nsec;
+	tmp.st_mtime.tv_sec	= stat->mtime.tv_sec;
+	tmp.st_mtime.tv_nsec	= stat->mtime.tv_nsec;
+	tmp.st_ctime.tv_sec	= stat->ctime.tv_sec;
+	tmp.st_ctime.tv_nsec	= stat->ctime.tv_nsec;
+	tmp.st_size		= stat->size;
+	tmp.st_blocks		= stat->blocks;
+	tmp.st_blksize		= stat->blksize;
+
+	if (stat->result_flags & XSTAT_QUERY_CREATION_TIME) {
+		tmp.st_crtime.tv_sec	= stat->crtime.tv_sec;
+		tmp.st_crtime.tv_nsec	= stat->crtime.tv_nsec;
+	}
+	if (stat->result_flags & XSTAT_QUERY_INODE_VERSION)
+		tmp.st_inode_version	= stat->inode_version;
+	if (stat->result_flags & XSTAT_QUERY_DATA_VERSION)
+		tmp.st_data_version	= stat->data_version;
+
+	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : sizeof(tmp);
+}
+
+/*
+ * System call to get extended stats by path
+ */
+SYSCALL_DEFINE5(xstat,
+		int, dfd, const char __user *, filename, unsigned, atflag,
+		struct xstat __user *, buffer, size_t, bufsize)
+{
+	struct kstat stat;
+	int error;
+
+	error = xstat_check_param(buffer, bufsize, &stat);
+	if (error != 0)
+		return error;
+	error = vfs_fstatat(dfd, filename, &stat, atflag);
+	if (error)
+		return error;
+	return xstat_set_result(&stat, buffer, bufsize);
+}
+
+/*
+ * System call to get extended stats by file descriptor
+ */
+SYSCALL_DEFINE3(fxstat, int, fd, struct xstat __user *, buffer, size_t, bufsize)
+{
+	struct kstat stat;
+	int error;
+
+	error = xstat_check_param(buffer, bufsize, &stat);
+	if (error < 0)
+		return error;
+	error = vfs_fstat(fd, &stat);
+	if (error)
+		return error;
+
+	return xstat_set_result(&stat, buffer, bufsize);
+}
+
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
 void __inode_add_bytes(struct inode *inode, loff_t bytes)
 {
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 611c398..d48bb5d 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -46,6 +46,45 @@
 
 #endif
 
+/*
+ * Extended stat structures
+ */
+struct xstat_dev {
+	unsigned int	major;
+	unsigned int	minor;
+};
+
+struct xstat_time {
+	unsigned long long	tv_sec;
+	unsigned long long	tv_nsec;
+};
+
+struct xstat {
+	unsigned int		struct_version;
+#define XSTAT_STRUCT_VERSION	0
+	unsigned int		st_mode;
+	unsigned int		st_nlink;
+	unsigned int		st_uid;
+	unsigned int		st_gid;
+	unsigned int		st_blksize;
+	struct xstat_dev	st_rdev;
+	struct xstat_dev	st_dev;
+	unsigned long long	st_ino;
+	unsigned long long	st_size;
+	struct xstat_time	st_atime;
+	struct xstat_time	st_mtime;
+	struct xstat_time	st_ctime;
+	struct xstat_time	st_crtime;
+	unsigned long long	st_blocks;
+	unsigned long long	st_inode_version;
+	unsigned long long	st_data_version;
+	unsigned long long	query_flags;
+#define XSTAT_QUERY_CREATION_TIME	0x00000001ULL
+#define XSTAT_QUERY_INODE_VERSION	0x00000002ULL
+#define XSTAT_QUERY_DATA_VERSION	0x00000004ULL
+	unsigned long long	extra_results[0];
+};
+
 #ifdef __KERNEL__
 #define S_IRWXUGO	(S_IRWXU|S_IRWXG|S_IRWXO)
 #define S_IALLUGO	(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
@@ -68,11 +107,16 @@ struct kstat {
 	gid_t		gid;
 	dev_t		rdev;
 	loff_t		size;
-	struct timespec  atime;
+	struct timespec	atime;
 	struct timespec	mtime;
 	struct timespec	ctime;
+	struct timespec	crtime;
 	unsigned long	blksize;
 	unsigned long long	blocks;
+	u64		query_flags;		/* what extras the user asked for */
+	u64		result_flags;		/* what extras the user got */
+	u64		inode_version;
+	u64		data_version;
 };
 
 #endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8812a63..760a303 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -44,6 +44,7 @@ struct shmid_ds;
 struct sockaddr;
 struct stat;
 struct stat64;
+struct xstat;
 struct statfs;
 struct statfs64;
 struct __sysctl_args;
@@ -824,4 +825,8 @@ asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
 			unsigned long fd, unsigned long pgoff);
 asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
 
+asmlinkage long sys_xstat(int, const char __user *, unsigned,
+			  struct xstat __user *, size_t);
+asmlinkage long sys_fxstat(int, struct xstat __user *, size_t);
+
 #endif
