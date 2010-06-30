From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file
 stats available [ver #2]
Date: Tue, 29 Jun 2010 21:48:56 -0400
Message-ID: <1277862536.9326.3.camel@heimdal.trondhjem.org>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
	 <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-out2.uio.no ([129.240.10.58]:56884 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0F3BtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jun 2010 21:49:16 -0400
In-Reply-To: <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-06-30 at 02:17 +0100, David Howells wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem:
> 
> 	struct xstat_dev {
> 		unsigned int	major;
> 		unsigned int	minor;
> 	};
> 
> 	struct xstat_time {
> 		unsigned long long	tv_sec;
> 		unsigned long long	tv_nsec;
> 	};
> 
> 	struct xstat {
> 		unsigned int		struct_version;
> 	#define XSTAT_STRUCT_VERSION	0
> 		unsigned int		st_mode;
> 		unsigned int		st_nlink;
> 		unsigned int		st_uid;
> 		unsigned int		st_gid;
> 		unsigned int		st_blksize;
> 		struct xstat_dev	st_rdev;
> 		struct xstat_dev	st_dev;
> 		unsigned long long	st_ino;
> 		unsigned long long	st_size;
> 		struct xstat_time	st_atime;
> 		struct xstat_time	st_mtime;
> 		struct xstat_time	st_ctime;
> 		struct xstat_time	st_btime;
> 		unsigned long long	st_blocks;
> 		unsigned long long	st_gen;
> 		unsigned long long	st_data_version;
> 		unsigned long long	query_flags;
> 	#define XSTAT_QUERY_SIZE		0x00000001ULL
> 	#define XSTAT_QUERY_NLINK		0x00000002ULL
> 	#define XSTAT_QUERY_AMC_TIMES		0x00000004ULL
> 	#define XSTAT_QUERY_CREATION_TIME	0x00000008ULL
> 	#define XSTAT_QUERY_BLOCKS		0x00000010ULL
> 	#define XSTAT_QUERY_INODE_GENERATION	0x00000020ULL
> 	#define XSTAT_QUERY_DATA_VERSION	0x00000040ULL
> 		unsigned long long	extra_results[0];
> 	};
> 
> 	ssize_t ret = xstat(int dfd,
> 			    const char *filename,
> 			    unsigned atflag,
> 			    struct xstat *buffer,
> 			    size_t buflen);
> 
> 	ssize_t ret = fxstat(int fd,
> 			     struct xstat *buffer,
> 			     size_t buflen);
> 
> 
> The dfd, filename, atflag and fd parameters indicate the file to query.  There
> is no equivalent of lstat() as that can be emulated with xstat(), passing 0
> instead of AT_SYMLINK_NOFOLLOW as atflag.
> 
> When the system call is executed, the struct_version ID and query_flags bitmask
> are read from the buffer to work out what the user is requesting.
> 
> If the structure version specified is not supported, the system call will
> return ENOTSUPP.  The above structure is version 0.
> 
> The query_flags should be set by the caller to specify extra results that the
> caller may desire.  These come in three classes:
> 
>  (1) Size, nlinks, [amc]times and block count.
> 
>      These will be returned whether the caller asks for them or not.  The
>      corresponding bits in query_flags will be set to indicate their presence.
> 
>      If the called didn't ask for them, then they may be approximated.  For
>      example, NFS won't waste any time updating them from the server, unless
>      as a byproduct of updating something requested.
> 
> 	Query Flag			Field
> 	===============================	================
> 	XSTAT_QUERY_SIZE		st_size
> 	XSTAT_QUERY_NLINK		st_nlink
> 	XSTAT_QUERY_AMC_TIMES		st_[amc]time
> 	XSTAT_QUERY_BLOCKS		st_blocks
> 
>  (2) Creation time, Inode generation and Data version.
> 
>      These will be returned if available whether the caller asked for them or
>      not.  The corresponding bits in query_flags will be set or cleared as
>      appropriate to indicate their presence.
> 
> 	Query Flag			Field
> 	===============================	================
> 	XSTAT_QUERY_CREATION_TIME	st_btime
> 	XSTAT_QUERY_INODE_GENERATION	st_gen
> 	XSTAT_QUERY_DATA_VERSION	st_data_version
> 
>      If the called didn't ask for them, then they may be approximated.  For
>      example, NFS won't waste any time updating them from the server, unless
>      as a byproduct of updating something requested.
> 
>  (3) Extra results.
> 
>      These will only be returned if the caller asked for them by setting their
>      bits in query_flags.  They will be placed in the buffer after the xstat
>      struct in ascending query_flags bit order.  Any bit set in query_flags
>      mask will be left set if the result is available and cleared otherwise.
> 
>      The pointer into the results list will be rounded up to the nearest 8-byte
>      boundary after each result is written in.  The size of each extra result
>      is specific to the definition for that result.
> 
>      No extra results are currently defined.
> 
> If the buffer is insufficiently big, the syscall returns the amount of space it
> will need to write the complete result set, but otherwise does nothing.
> 
> If successful, the amount of data written into the buffer will be returned.
> 
> At the moment, this will only work on x86_64 as it requires system calls to be
> wired up.
> 
> 
> ===========
> FILESYSTEMS
> ===========
> 
> The following filesystems have been modified to make use of this facility:
> 
>  (*) Ext4.  This will return the creation time and inode version number for all
>      files.  It will, however, only return the data version number for
>      directories as i_version is only maintained for them.
> 
>  (*) AFS.  This will return the vnode ID uniquifier as the inode version and
>      the AFS data version number as the data version.  There is no file
>      creation time available.
> 
>  (*) NFS.  This will return the change attribute if NFSv4 only.  No other extra
>      values are returned at this time.  If mtime and ctime aren't asked for,
>      the outstanding writes won't be written to the server.  If none of
>      [amc]time, size, nlink, blocks and data_version are requested, then the
>      attributes won't be refreshed from the server.
> 
>      Probably this isn't sufficient, as the other non-optional attributes may
>      require refreshing.
> 
> 
> =======
> TESTING
> =======
> 
> The following test program can be used to test the xstat system call:
> 
> 	#define _GNU_SOURCE
> 	#define _ATFILE_SOURCE
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <string.h>
> 	#include <unistd.h>
> 	#include <fcntl.h>
> 	#include <time.h>
> 	#include <sys/syscall.h>
> 	#include <sys/stat.h>
> 	#include <sys/types.h>
> 
> 	struct xstat_dev {
> 		unsigned int	major;
> 		unsigned int	minor;
> 	};
> 
> 	struct xstat_time {
> 		unsigned long long	tv_sec;
> 		unsigned long long	tv_nsec;
> 	};
> 
> 	struct xstat {
> 		unsigned int		struct_version;
> 	#define XSTAT_STRUCT_VERSION	0
> 		unsigned int		st_mode;
> 		unsigned int		st_nlink;
> 		unsigned int		st_uid;
> 		unsigned int		st_gid;
> 		unsigned int		st_blksize;
> 		struct xstat_dev	st_rdev;
> 		struct xstat_dev	st_dev;
> 		unsigned long long	st_ino;
> 		unsigned long long	st_size;
> 		struct xstat_time	st_atim;
> 		struct xstat_time	st_mtim;
> 		struct xstat_time	st_ctim;
> 		struct xstat_time	st_btim;
> 		unsigned long long	st_blocks;
> 		unsigned long long	st_gen;
> 		unsigned long long	st_data_version;
> 		unsigned long long	query_flags;
> 	#define XSTAT_QUERY_SIZE		0x00000001ULL	/* want/got st_size */
> 	#define XSTAT_QUERY_NLINK		0x00000002ULL	/* want/got st_nlink */
> 	#define XSTAT_QUERY_AMC_TIMES		0x00000004ULL	/* want/got st_[amc]time */
> 	#define XSTAT_QUERY_CREATION_TIME	0x00000008ULL	/* want/got st_btime */
> 	#define XSTAT_QUERY_BLOCKS		0x00000010ULL	/* want/got st_blocks */
> 	#define XSTAT_QUERY_INODE_GENERATION	0x00000020ULL	/* want/got st_gen */
> 	#define XSTAT_QUERY_DATA_VERSION	0x00000040ULL	/* want/got st_data_version */
> 	#define XSTAT_QUERY__ORDINARY_SET	0x00000017ULL	/* the stuff in the normal stat struct */
> 	#define XSTAT_QUERY__GET_ANYWAY		0x0000007fULL	/* what we get anyway if available */
> 	#define XSTAT_QUERY__DEFINED_SET	0x0000007fULL	/* the defined set of flags */
> 		unsigned long long	extra_results[0];
> 	};
> 
> 	#define __NR_xstat				300
> 	#define __NR_fxstat				301
> 
> 	static __attribute__((unused))
> 	ssize_t xstat(int dfd, const char *filename, int atflag,
> 			     struct xstat *buffer, size_t bufsize)
> 	{
> 		return syscall(__NR_xstat, dfd, filename, atflag, buffer, bufsize);
> 	}
> 
> 	static __attribute__((unused))
> 	ssize_t fxstat(int fd, struct xstat *buffer, size_t bufsize)
> 	{
> 		return syscall(__NR_fxstat, fd, buffer, bufsize);
> 	}
> 
> 	static void print_time(const struct xstat_time *xstm)
> 	{
> 		struct tm tm;
> 		time_t tim;
> 		char buffer[100];
> 		int len;
> 
> 		tim = xstm->tv_sec;
> 		if (!localtime_r(&tim, &tm)) {
> 			perror("localtime_r");
> 			exit(1);
> 		}
> 		len = strftime(buffer, 100, "%F %T", &tm);
> 		if (len == 0) {
> 			perror("strftime");
> 			exit(1);
> 		}
> 		fwrite(buffer, 1, len, stdout);
> 		printf(".%09llu", xstm->tv_nsec);
> 		len = strftime(buffer, 100, "%z", &tm);
> 		if (len == 0) {
> 			perror("strftime2");
> 			exit(1);
> 		}
> 		fwrite(buffer, 1, len, stdout);
> 	}
> 
> 	static void dump_xstat(struct xstat *xst)
> 	{
> 		char buffer[256], ft;
> 
> 		printf(" ");
> 		if (xst->query_flags & XSTAT_QUERY_SIZE)
> 			printf(" Size: %-15llu", xst->st_size);
> 		if (xst->query_flags & XSTAT_QUERY_BLOCKS)
> 			printf(" Blocks: %-10llu", xst->st_blocks);
> 		printf(" IO Block: %-6u ", xst->st_blksize);
> 		switch (xst->st_mode & S_IFMT) {
> 		case S_IFIFO:	printf(" FIFO\n");			ft = 'p'; break;
> 		case S_IFCHR:	printf(" character special file\n");	ft = 'c'; break;
> 		case S_IFDIR:	printf(" directory\n");			ft = 'd'; break;
> 		case S_IFBLK:	printf(" block special file\n");	ft = 'b'; break;
> 		case S_IFREG:	printf(" regular file\n");		ft = '-'; break;
> 		case S_IFLNK:	printf(" symbolic link\n");		ft = 'l'; break;
> 		case S_IFSOCK:	printf(" socket\n");			ft = 's'; break;
> 		default:
> 			printf("unknown type (%o)\n", xst->st_mode & S_IFMT);
> 			ft = '?';
> 			break;
> 		}
> 
> 		sprintf(buffer, "%02x:%02x", xst->st_dev.major, xst->st_dev.minor);
> 		printf("Device: %-15s Inode: %-11llu", buffer, xst->st_ino);
> 		if (xst->query_flags & XSTAT_QUERY_SIZE)
> 			printf(" Links: %u", xst->st_nlink);
> 		printf("\n");
> 
> 		printf("Access: (%04o/%c%c%c%c%c%c%c%c%c%c)  ",
> 		       xst->st_mode & 07777,
> 		       ft,
> 		       xst->st_mode & S_IRUSR ? 'r' : '-',
> 		       xst->st_mode & S_IWUSR ? 'w' : '-',
> 		       xst->st_mode & S_IXUSR ? 'x' : '-',
> 		       xst->st_mode & S_IRGRP ? 'r' : '-',
> 		       xst->st_mode & S_IWGRP ? 'w' : '-',
> 		       xst->st_mode & S_IXGRP ? 'x' : '-',
> 		       xst->st_mode & S_IROTH ? 'r' : '-',
> 		       xst->st_mode & S_IWOTH ? 'w' : '-',
> 		       xst->st_mode & S_IXOTH ? 'x' : '-');
> 		printf("Uid: %d   Gid: %u\n", xst->st_uid, xst->st_gid);
> 
> 		if (xst->query_flags & XSTAT_QUERY_AMC_TIMES) {
> 			printf("Access: "); print_time(&xst->st_atim); printf("\n");
> 			printf("Modify: "); print_time(&xst->st_mtim); printf("\n");
> 			printf("Change: "); print_time(&xst->st_ctim); printf("\n");
> 		}
> 		if (xst->query_flags & XSTAT_QUERY_CREATION_TIME) {
> 			printf("Create: "); print_time(&xst->st_btim); printf("\n");
> 		}
> 
> 		if (xst->query_flags & XSTAT_QUERY_INODE_GENERATION)
> 			printf("Inode version: %llxh\n", xst->st_gen);
> 		if (xst->query_flags & XSTAT_QUERY_DATA_VERSION)
> 			printf("Data version: %llxh\n", xst->st_data_version);
> 	}
> 
> 	int main(int argc, char **argv)
> 	{
> 		struct xstat xst;
> 		int ret, atflag = AT_SYMLINK_NOFOLLOW;
> 
> 		unsigned long long query =
> 			XSTAT_QUERY__ORDINARY_SET |
> 			XSTAT_QUERY_CREATION_TIME |
> 			XSTAT_QUERY_INODE_GENERATION |
> 			XSTAT_QUERY_DATA_VERSION;
> 
> 		for (argv++; *argv; argv++) {
> 			if (strcmp(*argv, "-L") == 0) {
> 				atflag = 0;
> 				continue;
> 			}
> 			if (strcmp(*argv, "-O") == 0) {
> 				query &= ~XSTAT_QUERY__ORDINARY_SET;
> 				continue;
> 			}
> 
> 			memset(&xst, 0xbf, sizeof(xst));
> 			xst.struct_version = 0;
> 			xst.query_flags = query;
> 			ret = xstat(AT_FDCWD, *argv, atflag, &xst, sizeof(xst));
> 			printf("xstat(%s) = %d\n", *argv, ret);
> 			if (ret < 0) {
> 				perror(*argv);
> 				exit(1);
> 			}
> 
> 			printf("sv=%u qf=%llx cr=%llx.%llx iv=%llx dv=%llx\n",
> 			       xst.struct_version, xst.query_flags,
> 			       xst.st_btim.tv_sec, xst.st_btim.tv_nsec,
> 			       xst.st_gen, xst.st_data_version);
> 
> 			dump_xstat(&xst);
> 		}
> 		return 0;
> 	}
> 
> Just compile and run, passing it paths to the files you want to examine:
> 
> 	[root@andromeda ~]# /tmp/xstat /afs/archive/linuxdev/fedora9/i386/repodata/
> 	xstat(/afs/archive/linuxdev/fedora9/i386/repodata/) = 152
> 	sv=0 qf=77 cr=0.0 iv=7a5 dv=5
> 	  Size: 2048            Blocks: 0          IO Block: 4096    directory
> 	Device: 00:15           Inode: 83          Links: 2
> 	Access: (0755/drwxr-xr-x)  Uid: 75338   Gid: 0
> 	Access: 2008-11-05 20:00:12.000000000+0000
> 	Modify: 2008-11-05 20:00:12.000000000+0000
> 	Change: 2008-11-05 20:00:12.000000000+0000
> 	Inode version: 7a5h
> 	Data version: 5h
> 
> 	[root@andromeda ~]# /tmp/xstat /warthog/nfs/linux-2.6-fscache
> 	xstat(/warthog/nfs/linux-2.6-fscache) = 152
> 	sv=0 qf=57 cr=0.0 iv=0 dv=f4992a4c00000000
> 	  Size: 4096            Blocks: 16         IO Block: 1048576  directory
> 	Device: 00:13           Inode: 19005487    Links: 27
> 	Access: (2775/drwxrwxr-x)  Uid: -2   Gid: 4294967294
> 	Access: 2010-06-30 02:07:42.000000000+0100
> 	Modify: 2010-06-30 02:12:20.000000000+0100
> 	Change: 2010-06-30 02:12:20.000000000+0100
> 	Data version: f4992a4c00000000h
> 
> 	[root@andromeda ~]# /tmp/xstat /var/cache/fscache/cache/
> 	xstat(/var/cache/fscache/cache/) = 152
> 	sv=0 qf=7f cr=4c24ba83.1c15ee3d iv=f585ab70 dv=2
> 	  Size: 4096            Blocks: 16         IO Block: 4096    directory
> 	Device: 08:06           Inode: 130561      Links: 3
> 	Access: (0700/drwx------)  Uid: 0   Gid: 0
> 	Access: 2010-06-29 18:16:33.680703545+0100
> 	Modify: 2010-06-29 18:16:20.132786632+0100
> 	Change: 2010-06-29 18:16:20.132786632+0100
> 	Create: 2010-06-25 15:17:39.471199293+0100
> 	Inode version: f585ab70h
> 	Data version: 2h

Yes, but could we please also add a flag that allows you to specify that
the kernel _must_ provide up to date attributes.

IOW: a flag that for something like NFS or CIFS will force a GETATTR RPC
call on the wire as opposed to using cached values.

Cheers
  Trond

