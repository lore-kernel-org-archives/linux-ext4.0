From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] Add a pair of system calls to make extended file stats
	available [ver #2]
Date: Wed, 30 Jun 2010 02:17:12 +0100
Message-ID: <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
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
		struct xstat_time	st_btime;
		unsigned long long	st_blocks;
		unsigned long long	st_gen;
		unsigned long long	st_data_version;
		unsigned long long	query_flags;
	#define XSTAT_QUERY_SIZE		0x00000001ULL
	#define XSTAT_QUERY_NLINK		0x00000002ULL
	#define XSTAT_QUERY_AMC_TIMES		0x00000004ULL
	#define XSTAT_QUERY_CREATION_TIME	0x00000008ULL
	#define XSTAT_QUERY_BLOCKS		0x00000010ULL
	#define XSTAT_QUERY_INODE_GENERATION	0x00000020ULL
	#define XSTAT_QUERY_DATA_VERSION	0x00000040ULL
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
caller may desire.  These come in three classes:

 (1) Size, nlinks, [amc]times and block count.

     These will be returned whether the caller asks for them or not.  The
     corresponding bits in query_flags will be set to indicate their presence.

     If the called didn't ask for them, then they may be approximated.  For
     example, NFS won't waste any time updating them from the server, unless
     as a byproduct of updating something requested.

	Query Flag			Field
	===============================	================
	XSTAT_QUERY_SIZE		st_size
	XSTAT_QUERY_NLINK		st_nlink
	XSTAT_QUERY_AMC_TIMES		st_[amc]time
	XSTAT_QUERY_BLOCKS		st_blocks

 (2) Creation time, Inode generation and Data version.

     These will be returned if available whether the caller asked for them or
     not.  The corresponding bits in query_flags will be set or cleared as
     appropriate to indicate their presence.

	Query Flag			Field
	===============================	================
	XSTAT_QUERY_CREATION_TIME	st_btime
	XSTAT_QUERY_INODE_GENERATION	st_gen
	XSTAT_QUERY_DATA_VERSION	st_data_version

     If the called didn't ask for them, then they may be approximated.  For
     example, NFS won't waste any time updating them from the server, unless
     as a byproduct of updating something requested.

 (3) Extra results.

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

The following filesystems have been modified to make use of this facility:

 (*) Ext4.  This will return the creation time and inode version number for all
     files.  It will, however, only return the data version number for
     directories as i_version is only maintained for them.

 (*) AFS.  This will return the vnode ID uniquifier as the inode version and
     the AFS data version number as the data version.  There is no file
     creation time available.

 (*) NFS.  This will return the change attribute if NFSv4 only.  No other extra
     values are returned at this time.  If mtime and ctime aren't asked for,
     the outstanding writes won't be written to the server.  If none of
     [amc]time, size, nlink, blocks and data_version are requested, then the
     attributes won't be refreshed from the server.

     Probably this isn't sufficient, as the other non-optional attributes may
     require refreshing.


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
		struct xstat_time	st_btim;
		unsigned long long	st_blocks;
		unsigned long long	st_gen;
		unsigned long long	st_data_version;
		unsigned long long	query_flags;
	#define XSTAT_QUERY_SIZE		0x00000001ULL	/* want/got st_size */
	#define XSTAT_QUERY_NLINK		0x00000002ULL	/* want/got st_nlink */
	#define XSTAT_QUERY_AMC_TIMES		0x00000004ULL	/* want/got st_[amc]time */
	#define XSTAT_QUERY_CREATION_TIME	0x00000008ULL	/* want/got st_btime */
	#define XSTAT_QUERY_BLOCKS		0x00000010ULL	/* want/got st_blocks */
	#define XSTAT_QUERY_INODE_GENERATION	0x00000020ULL	/* want/got st_gen */
	#define XSTAT_QUERY_DATA_VERSION	0x00000040ULL	/* want/got st_data_version */
	#define XSTAT_QUERY__ORDINARY_SET	0x00000017ULL	/* the stuff in the normal stat struct */
	#define XSTAT_QUERY__GET_ANYWAY		0x0000007fULL	/* what we get anyway if available */
	#define XSTAT_QUERY__DEFINED_SET	0x0000007fULL	/* the defined set of flags */
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

		printf(" ");
		if (xst->query_flags & XSTAT_QUERY_SIZE)
			printf(" Size: %-15llu", xst->st_size);
		if (xst->query_flags & XSTAT_QUERY_BLOCKS)
			printf(" Blocks: %-10llu", xst->st_blocks);
		printf(" IO Block: %-6u ", xst->st_blksize);
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

		sprintf(buffer, "%02x:%02x", xst->st_dev.major, xst->st_dev.minor);
		printf("Device: %-15s Inode: %-11llu", buffer, xst->st_ino);
		if (xst->query_flags & XSTAT_QUERY_SIZE)
			printf(" Links: %u", xst->st_nlink);
		printf("\n");

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

		if (xst->query_flags & XSTAT_QUERY_AMC_TIMES) {
			printf("Access: "); print_time(&xst->st_atim); printf("\n");
			printf("Modify: "); print_time(&xst->st_mtim); printf("\n");
			printf("Change: "); print_time(&xst->st_ctim); printf("\n");
		}
		if (xst->query_flags & XSTAT_QUERY_CREATION_TIME) {
			printf("Create: "); print_time(&xst->st_btim); printf("\n");
		}

		if (xst->query_flags & XSTAT_QUERY_INODE_GENERATION)
			printf("Inode version: %llxh\n", xst->st_gen);
		if (xst->query_flags & XSTAT_QUERY_DATA_VERSION)
			printf("Data version: %llxh\n", xst->st_data_version);
	}

	int main(int argc, char **argv)
	{
		struct xstat xst;
		int ret, atflag = AT_SYMLINK_NOFOLLOW;

		unsigned long long query =
			XSTAT_QUERY__ORDINARY_SET |
			XSTAT_QUERY_CREATION_TIME |
			XSTAT_QUERY_INODE_GENERATION |
			XSTAT_QUERY_DATA_VERSION;

		for (argv++; *argv; argv++) {
			if (strcmp(*argv, "-L") == 0) {
				atflag = 0;
				continue;
			}
			if (strcmp(*argv, "-O") == 0) {
				query &= ~XSTAT_QUERY__ORDINARY_SET;
				continue;
			}

			memset(&xst, 0xbf, sizeof(xst));
			xst.struct_version = 0;
			xst.query_flags = query;
			ret = xstat(AT_FDCWD, *argv, atflag, &xst, sizeof(xst));
			printf("xstat(%s) = %d\n", *argv, ret);
			if (ret < 0) {
				perror(*argv);
				exit(1);
			}

			printf("sv=%u qf=%llx cr=%llx.%llx iv=%llx dv=%llx\n",
			       xst.struct_version, xst.query_flags,
			       xst.st_btim.tv_sec, xst.st_btim.tv_nsec,
			       xst.st_gen, xst.st_data_version);

			dump_xstat(&xst);
		}
		return 0;
	}

Just compile and run, passing it paths to the files you want to examine:

	[root@andromeda ~]# /tmp/xstat /afs/archive/linuxdev/fedora9/i386/repodata/
	xstat(/afs/archive/linuxdev/fedora9/i386/repodata/) = 152
	sv=0 qf=77 cr=0.0 iv=7a5 dv=5
	  Size: 2048            Blocks: 0          IO Block: 4096    directory
	Device: 00:15           Inode: 83          Links: 2
	Access: (0755/drwxr-xr-x)  Uid: 75338   Gid: 0
	Access: 2008-11-05 20:00:12.000000000+0000
	Modify: 2008-11-05 20:00:12.000000000+0000
	Change: 2008-11-05 20:00:12.000000000+0000
	Inode version: 7a5h
	Data version: 5h

	[root@andromeda ~]# /tmp/xstat /warthog/nfs/linux-2.6-fscache
	xstat(/warthog/nfs/linux-2.6-fscache) = 152
	sv=0 qf=57 cr=0.0 iv=0 dv=f4992a4c00000000
	  Size: 4096            Blocks: 16         IO Block: 1048576  directory
	Device: 00:13           Inode: 19005487    Links: 27
	Access: (2775/drwxrwxr-x)  Uid: -2   Gid: 4294967294
	Access: 2010-06-30 02:07:42.000000000+0100
	Modify: 2010-06-30 02:12:20.000000000+0100
	Change: 2010-06-30 02:12:20.000000000+0100
	Data version: f4992a4c00000000h

	[root@andromeda ~]# /tmp/xstat /var/cache/fscache/cache/
	xstat(/var/cache/fscache/cache/) = 152
	sv=0 qf=7f cr=4c24ba83.1c15ee3d iv=f585ab70 dv=2
	  Size: 4096            Blocks: 16         IO Block: 4096    directory
	Device: 08:06           Inode: 130561      Links: 3
	Access: (0700/drwx------)  Uid: 0   Gid: 0
	Access: 2010-06-29 18:16:33.680703545+0100
	Modify: 2010-06-29 18:16:20.132786632+0100
	Change: 2010-06-29 18:16:20.132786632+0100
	Create: 2010-06-25 15:17:39.471199293+0100
	Inode version: f585ab70h
	Data version: 2h


Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/unistd_32.h |    4 +
 arch/x86/include/asm/unistd_64.h |    4 +
 fs/afs/inode.c                   |   12 ++-
 fs/ecryptfs/inode.c              |    1 
 fs/ext4/ext4.h                   |    2 
 fs/ext4/file.c                   |    2 
 fs/ext4/inode.c                  |   27 ++++++-
 fs/ext4/namei.c                  |    2 
 fs/ext4/symlink.c                |    2 
 fs/nfs/inode.c                   |   38 ++++++---
 fs/nfsd/nfs3proc.c               |    1 
 fs/nfsd/nfs3xdr.c                |    2 
 fs/nfsd/nfs4xdr.c                |    2 
 fs/nfsd/nfsproc.c                |    3 +
 fs/nfsd/nfsxdr.c                 |    1 
 fs/stat.c                        |  153 +++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h               |    2 
 include/linux/stat.h             |   88 ++++++++++++++++++++++
 include/linux/syscalls.h         |    5 +
 19 files changed, 322 insertions(+), 29 deletions(-)

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
index ee3190a..3b68136 100644
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
+		XSTAT_QUERY_INODE_GENERATION | XSTAT_QUERY_DATA_VERSION;
+	stat->gen = inode->i_generation;
+	stat->data_version = inode->i_version;
 	return 0;
 }
 
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 31ef525..93b914b 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -994,6 +994,7 @@ int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct kstat lower_stat;
 	int rc;
 
+	lower_stat.query_flags = XSTAT_QUERY_BLOCKS;
 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
 	if (!rc) {
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
index 42272d6..465ce48 100644
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
+	stat->btime.tv_sec = EXT4_I(inode)->i_crtime.tv_sec;
+	stat->btime.tv_nsec = EXT4_I(inode)->i_crtime.tv_nsec;
+
+	if (inode->i_ino != EXT4_ROOT_INO) {
+		stat->result_flags |= XSTAT_QUERY_INODE_GENERATION;
+		stat->gen = inode->i_generation;
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
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 099b351..bb19eaf 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -498,8 +498,10 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
 	int err;
 
-	/* Flush out writes to the server in order to update c/mtime.  */
-	if (S_ISREG(inode->i_mode)) {
+	/* Flush out writes to the server in order to update c/mtime if the
+	 * user wants them */
+	if (stat->query_flags & XSTAT_QUERY_AMC_TIMES &&
+	    S_ISREG(inode->i_mode)) {
 		err = filemap_write_and_wait(inode->i_mapping);
 		if (err)
 			goto out;
@@ -514,18 +516,30 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	 *  - NFS never sets MS_NOATIME or MS_NODIRATIME so there is
 	 *    no point in checking those.
 	 */
- 	if ((mnt->mnt_flags & MNT_NOATIME) ||
- 	    ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
+	if (!(stat->query_flags & XSTAT_QUERY_AMC_TIMES) ||
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
+	if (stat->query_flags &
+	    (XSTAT_QUERY__ORDINARY_SET | XSTAT_QUERY_DATA_VERSION)) {
+		if (need_atime)
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
+	if (stat->query_flags & XSTAT_QUERY_DATA_VERSION &&
+	    NFS_SERVER(inode)->nfs_client->rpc_ops->version == 4) {
+		stat->data_version = NFS_I(inode)->change_attr;
+		stat->result_flags |= XSTAT_QUERY_DATA_VERSION;
+	}
+
 out:
 	return err;
 }
@@ -770,7 +784,7 @@ int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 static int nfs_invalidate_mapping(struct inode *inode, struct address_space *mapping)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
-	
+
 	if (mapping->nrpages != 0) {
 		int ret = invalidate_inode_pages2(mapping);
 		if (ret < 0)
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 3d68f45..bcd08a3 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -55,6 +55,7 @@ nfsd3_proc_getattr(struct svc_rqst *rqstp, struct nfsd_fhandle  *argp,
 	if (nfserr)
 		RETURN_STATUS(nfserr);
 
+	resp->stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 	err = vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 			  resp->fh.fh_dentry, &resp->stat);
 	nfserr = nfserrno(err);
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2a533a0..7a8737b 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -205,6 +205,7 @@ encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 	        int err;
 		struct kstat stat;
 
+		stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 		err = vfs_getattr(fhp->fh_export->ex_path.mnt, dentry, &stat);
 		if (!err) {
 			*p++ = xdr_one;		/* attributes follow */
@@ -257,6 +258,7 @@ void fill_post_wcc(struct svc_fh *fhp)
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
+	fhp->fh_post_attr.query_flags = XSTAT_QUERY__GET_ANYWAY;
 	err = vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry,
 			&fhp->fh_post_attr);
 	fhp->fh_post_change = fhp->fh_dentry->d_inode->i_version;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ac17a70..afed8d5 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1769,6 +1769,7 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 			goto out;
 	}
 
+	stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 	err = vfs_getattr(exp->ex_path.mnt, dentry, &stat);
 	if (err)
 		goto out_nfserr;
@@ -2139,6 +2140,7 @@ out_acl:
 				if (path.dentry != path.mnt->mnt_root)
 					break;
 			}
+			stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 			err = vfs_getattr(path.mnt, path.dentry, &stat);
 			path_put(&path);
 			if (err)
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index a047ad6..81e4b4c 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -26,6 +26,7 @@ static __be32
 nfsd_return_attrs(__be32 err, struct nfsd_attrstat *resp)
 {
 	if (err) return err;
+	resp->stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 				    resp->fh.fh_dentry,
 				    &resp->stat));
@@ -34,6 +35,7 @@ static __be32
 nfsd_return_dirop(__be32 err, struct nfsd_diropres *resp)
 {
 	if (err) return err;
+	resp->stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 				    resp->fh.fh_dentry,
 				    &resp->stat));
@@ -150,6 +152,7 @@ nfsd_proc_read(struct svc_rqst *rqstp, struct nfsd_readargs *argp,
 				  &resp->count);
 
 	if (nfserr) return nfserr;
+	resp->stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 				    resp->fh.fh_dentry,
 				    &resp->stat));
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 4ce005d..c5f9869 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -197,6 +197,7 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 {
 	struct kstat stat;
+	stat.query_flags = XSTAT_QUERY__GET_ANYWAY;
 	vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry, &stat);
 	return encode_fattr(rqstp, p, fhp, &stat);
 }
diff --git a/fs/stat.c b/fs/stat.c
index 12e90e2..9ee968b 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -33,6 +33,7 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->size = i_size_read(inode);
 	stat->blocks = inode->i_blocks;
 	stat->blksize = (1 << inode->i_blkbits);
+	stat->result_flags |= XSTAT_QUERY__ORDINARY_SET;
 }
 
 EXPORT_SYMBOL(generic_fillattr);
@@ -42,6 +43,8 @@ int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	struct inode *inode = dentry->d_inode;
 	int retval;
 
+	stat->result_flags = 0;
+
 	retval = security_inode_getattr(mnt, dentry);
 	if (retval)
 		return retval;
@@ -55,7 +58,10 @@ int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 
 EXPORT_SYMBOL(vfs_getattr);
 
-int vfs_fstat(unsigned int fd, struct kstat *stat)
+/*
+ * VFS entrypoint to get extended stats by file descriptor
+ */
+int vfs_fxstat(unsigned int fd, struct kstat *stat)
 {
 	struct file *f = fget(fd);
 	int error = -EBADF;
@@ -66,10 +72,20 @@ int vfs_fstat(unsigned int fd, struct kstat *stat)
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_fxstat);
+
+int vfs_fstat(unsigned int fd, struct kstat *stat)
+{
+	stat->query_flags = XSTAT_QUERY__ORDINARY_SET;
+	return vfs_fxstat(fd, stat);
+}
 EXPORT_SYMBOL(vfs_fstat);
 
-int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
-		int flag)
+/*
+ * VFS entrypoint to get extended stats by filename
+ */
+int vfs_xstat(int dfd, const char __user *filename, int flag,
+	      struct kstat *stat)
 {
 	struct path path;
 	int error = -EINVAL;
@@ -90,6 +106,14 @@ int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 out:
 	return error;
 }
+EXPORT_SYMBOL(vfs_xstat);
+
+int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
+		int flag)
+{
+	stat->query_flags = XSTAT_QUERY__ORDINARY_SET;
+	return vfs_xstat(dfd, filename, flag, stat);
+}
 EXPORT_SYMBOL(vfs_fstatat);
 
 int vfs_stat(const char __user *name, struct kstat *stat)
@@ -115,7 +139,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 {
 	static int warncount = 5;
 	struct __old_kernel_stat tmp;
-	
+
 	if (warncount > 0) {
 		warncount--;
 		printk(KERN_WARNING "VFS: Warning: %s using old stat() call. Recompile your binary.\n",
@@ -140,7 +164,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -222,7 +246,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -408,6 +432,123 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 */
 
+/*
+ * check the input parameters in the xstat struct
+ */
+static int xstat_check_param(struct xstat __user *buffer, size_t bufsize,
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
+	stat->query_flags &= XSTAT_QUERY__DEFINED_SET;
+	stat->result_flags = 0;
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
+	tmp.st_uid		= stat->uid;
+	tmp.st_gid		= stat->gid;
+	tmp.st_blksize		= stat->blksize;
+
+	if (stat->result_flags & XSTAT_QUERY_NLINK)
+		tmp.st_nlink		= stat->nlink;
+	if (stat->result_flags & XSTAT_QUERY_AMC_TIMES) {
+		tmp.st_atime.tv_sec	= stat->atime.tv_sec;
+		tmp.st_atime.tv_nsec	= stat->atime.tv_nsec;
+		tmp.st_mtime.tv_sec	= stat->mtime.tv_sec;
+		tmp.st_mtime.tv_nsec	= stat->mtime.tv_nsec;
+		tmp.st_ctime.tv_sec	= stat->ctime.tv_sec;
+		tmp.st_ctime.tv_nsec	= stat->ctime.tv_nsec;
+	}
+	if (stat->result_flags & XSTAT_QUERY_SIZE)
+		tmp.st_size		= stat->size;
+	if (stat->result_flags & XSTAT_QUERY_BLOCKS)
+		tmp.st_blocks		= stat->blocks;
+	if (stat->result_flags & XSTAT_QUERY_CREATION_TIME) {
+		tmp.st_btime.tv_sec	= stat->btime.tv_sec;
+		tmp.st_btime.tv_nsec	= stat->btime.tv_nsec;
+	}
+	if (stat->result_flags & XSTAT_QUERY_INODE_GENERATION)
+		tmp.st_gen		= stat->gen;
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
+	error = vfs_xstat(dfd, filename, atflag, &stat);
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a18bcea..9ce2119 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2343,6 +2343,8 @@ extern int vfs_stat(const char __user *, struct kstat *);
 extern int vfs_lstat(const char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , const char __user *, struct kstat *, int);
+extern int vfs_xstat(int, const char __user *, int, struct kstat *);
+extern int vfs_xfstat(unsigned int, struct kstat *);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 611c398..5ef092a 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -46,6 +46,87 @@
 
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
+	unsigned int		struct_version;	/* version of this structure */
+#define XSTAT_STRUCT_VERSION	0
+
+	unsigned int		st_mode;	/* file mode */
+	unsigned int		st_nlink;	/* number of hard links */
+	unsigned int		st_uid;		/* user ID of owner */
+	unsigned int		st_gid;		/* group ID of owner */
+	unsigned int		st_blksize;	/* block size for filesystem I/O */
+	struct xstat_dev	st_rdev;	/* device ID of special file */
+	struct xstat_dev	st_dev;		/* ID of device containing file */
+	unsigned long long	st_ino;		/* inode number */
+	unsigned long long	st_size;	/* file size */
+	struct xstat_time	st_atime;	/* last access time */
+	struct xstat_time	st_mtime;	/* last data modification time */
+	struct xstat_time	st_ctime;	/* last attribute change time */
+	struct xstat_time	st_btime;	/* file creation time */
+	unsigned long long	st_blocks;	/* number of 512-byte blocks allocated */
+	unsigned long long	st_gen;		/* inode generation number */
+	unsigned long long	st_data_version; /* data version number */
+
+	/* Query request/result flags
+	 *
+	 * Bits should be set in query_flags to request particular items before
+	 * calling xstat() or fxstat().
+	 *
+	 * For each item in the set XSTAT_QUERY__GET_ANYWAY:
+	 *
+	 * - if not available at all, the bit will be cleared before returning
+	 *   and the field will be cleared; otherwise,
+	 *
+	 * - if requested, the datum will be synchronised to a server or other
+	 *   hardware before being returned if necessary, and the bit will be
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
+	 * For each item not in the set XSTAT_QUERY__GET_ANYWAY:
+	 * 
+	 * - if not available at all, the bit will be cleared, and no result
+         *   data will be returned; otherwise,
+	 *
+	 * - if requested, the datum will be synchronised to a server or other
+	 *   hardware before being appended if necessary, and the bit will be
+	 *   set on return; otherwise,
+	 * 
+	 * - the bit will be cleared, and no result data will be returned.
+	 */
+	unsigned long long	query_flags;
+#define XSTAT_QUERY_SIZE		0x00000001ULL	/* want/got st_size */
+#define XSTAT_QUERY_NLINK		0x00000002ULL	/* want/got st_nlink */
+#define XSTAT_QUERY_AMC_TIMES		0x00000004ULL	/* want/got st_[amc]time */
+#define XSTAT_QUERY_CREATION_TIME	0x00000008ULL	/* want/got st_btime */
+#define XSTAT_QUERY_BLOCKS		0x00000010ULL	/* want/got st_blocks */
+#define XSTAT_QUERY_INODE_GENERATION	0x00000020ULL	/* want/got st_gen */
+#define XSTAT_QUERY_DATA_VERSION	0x00000040ULL	/* want/got st_data_version */
+#define XSTAT_QUERY__ORDINARY_SET	0x00000017ULL	/* the stuff in the normal stat struct */
+#define XSTAT_QUERY__GET_ANYWAY		0x0000007fULL	/* what we get anyway if available */
+#define XSTAT_QUERY__DEFINED_SET	0x0000007fULL	/* the defined set of flags */
+	unsigned long long	extra_results[0]; /* extra requested results */
+};
+
 #ifdef __KERNEL__
 #define S_IRWXUGO	(S_IRWXU|S_IRWXG|S_IRWXO)
 #define S_IALLUGO	(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
@@ -68,11 +149,16 @@ struct kstat {
 	gid_t		gid;
 	dev_t		rdev;
 	loff_t		size;
-	struct timespec  atime;
+	struct timespec	atime;
 	struct timespec	mtime;
 	struct timespec	ctime;
+	struct timespec	btime;			/* file creation time */
 	unsigned long	blksize;
 	unsigned long long	blocks;
+	u64		query_flags;		/* what extras the user asked for */
+	u64		result_flags;		/* what extras the user got */
+	u64		gen;			/* inode generation */
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
