From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 21:02:59 +0100
Message-ID: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
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
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Implement a pair of new system calls to provide extended and further extensible
stat functions.

The third of the associated patches provides these new system calls:

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

which are more fully documented in that patch's description.

The bonuses of these new stat functions are:

 (1) The fields in the xstat struct are cleaned up.  There are no split or
     duplicated fields.

 (2) Some extra information is made available (file creation time, inode
     version number and data version number) where provided by the underlying
     filesystem.

     These are implemented here for Ext4 and AFS, but could also be provided
     for CIFS, NTFS and BtrFS and probably others.

 (3) The structure is versioned and extensible, meaning that further new system
     calls shouldn't be required.

Note that no lstat() equivalent is required as that can be implemented through
xstat() with atflag == 0.


The first patch makes const a bunch of system call userspace string/buffer
arguments.  I can then make sys_xstat()'s filename pointer const too (though
the entire first patch is not required for that).

The second patch makes the AFS filesystem use i_generation for the vnode ID
uniquifier rather than i_version, and assigns i_version to hold the AFS data
version number, making them more logical for when I want to get at them from
afs_getattr().


There's a test program attached to the description for patch 3.  It can be run
as follows:

	[root@andromeda ~]# /tmp/xstat /afs/archive/linuxdev/fedora9/i386/repodata/
	xstat(/afs/archive/linuxdev/fedora9/i386/repodata/) = 152
	sv=0 qf=6 cr=0.0 iv=7a5 dv=5
	  Size: 2048            Blocks: 0          IO Block: 4096   directory
	Device: 00:13           Inode: 83          Links: 2
	Access: (0755/drwxr-xr-x)  Uid: 75338   Gid: 0
	Access: 2008-11-05 20:00:12.000000000+0000
	Modify: 2008-11-05 20:00:12.000000000+0000
	Change: 2008-11-05 20:00:12.000000000+0000
	Inode version: 7a5h
	Data version: 5h


Things that need consideration:

 (1) Is it worth retaining the ability to arbitrarily add extra bits onto the
     end of the stat buffer?  And what's the best way to do this?

     I've defined a way that from userspace involves assigning bits in
     query_flags to extra results that you might want.  But this could instead
     be done, say, by just upping the struct version number any time we want to
     pass back more information.  Alternatively, we could go for a tagged data
     method, perhaps using the same format as the recvmsg() control message
     field.

     If we use tagged data then rather than being selective, we could just
     return as many tagged data items as we feel the user might want and we can
     cram into the buffer.  That could be rather slow, though.

 (2) What extra bits of information might we like to see available through the
     stat interface?  Security labels?  NFS file IDs?  Xattrs?

     If we went for a tagged data method, xstat() could be modified to take a
     list of tags as an argument, and could then return arbitrarily-sized
     tagged results, including fs-specific stuff.

 (3) Does st_blksize really need to be 64 bits on a 64-bit system?  Or can it
     be 32-bits?  Are we really likely to see something with a 4Gb+ blocksize?

 (4) Should the inode number and data version number fields be 128-bit?

David
---

David Howells (3):
      Add a pair of system calls to make extended file stats available
      AFS: Use i_generation not i_version for the vnode uniquifier
      Mark arguments to certain syscalls as being const


 arch/alpha/kernel/osf_sys.c             |    6 +
 arch/alpha/kernel/process.c             |    2 
 arch/arm/kernel/sys_arm.c               |    4 -
 arch/arm/kernel/sys_oabi-compat.c       |    6 +
 arch/avr32/include/asm/syscalls.h       |    2 
 arch/avr32/kernel/process.c             |    3 -
 arch/blackfin/kernel/process.c          |    2 
 arch/frv/kernel/process.c               |    3 -
 arch/h8300/kernel/process.c             |    2 
 arch/ia64/include/asm/unistd.h          |    2 
 arch/ia64/kernel/process.c              |    2 
 arch/m32r/kernel/process.c              |    3 -
 arch/m68k/kernel/process.c              |    2 
 arch/m68knommu/kernel/process.c         |    2 
 arch/microblaze/kernel/sys_microblaze.c |    2 
 arch/mips/kernel/syscall.c              |    2 
 arch/mn10300/kernel/process.c           |    2 
 arch/parisc/hpux/fs.c                   |    7 +
 arch/powerpc/kernel/process.c           |    2 
 arch/powerpc/kernel/sys_ppc32.c         |    2 
 arch/s390/kernel/compat_linux.c         |   10 +-
 arch/s390/kernel/compat_linux.h         |   10 +-
 arch/s390/kernel/entry.h                |    2 
 arch/s390/kernel/process.c              |    2 
 arch/sh/include/asm/syscalls_32.h       |    2 
 arch/sh/include/asm/syscalls_64.h       |    2 
 arch/sh/kernel/process_64.c             |    2 
 arch/sparc/kernel/sys_sparc32.c         |    7 +
 arch/um/kernel/exec.c                   |    6 +
 arch/um/kernel/internal.h               |    2 
 arch/um/kernel/syscall.c                |    2 
 arch/x86/ia32/sys_ia32.c                |   14 +--
 arch/x86/include/asm/sys_ia32.h         |   12 +-
 arch/x86/include/asm/syscalls.h         |    2 
 arch/x86/include/asm/unistd_32.h        |    4 +
 arch/x86/include/asm/unistd_64.h        |    4 +
 arch/x86/kernel/entry_64.S              |    4 -
 arch/x86/kernel/process.c               |    2 
 arch/xtensa/kernel/process.c            |    2 
 fs/afs/dir.c                            |    8 +-
 fs/afs/fsclient.c                       |    3 -
 fs/afs/inode.c                          |   22 ++--
 fs/compat.c                             |   23 +++--
 fs/ext4/ext4.h                          |    2 
 fs/ext4/file.c                          |    2 
 fs/ext4/inode.c                         |   27 +++++
 fs/ext4/namei.c                         |    2 
 fs/ext4/symlink.c                       |    2 
 fs/stat.c                               |  154 ++++++++++++++++++++++++++++---
 fs/utimes.c                             |    7 +
 include/linux/compat.h                  |    6 +
 include/linux/fs.h                      |    6 +
 include/linux/stat.h                    |   46 +++++++++
 include/linux/syscalls.h                |   25 +++--
 include/linux/time.h                    |    2 
 55 files changed, 353 insertions(+), 133 deletions(-)
