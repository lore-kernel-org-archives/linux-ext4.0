From: Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 16:28:39 -0400
Message-ID: <1277843319.4500.17.camel@heimdal.trondhjem.org>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100629200259.23196.81509.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2010-06-29 at 21:02 +0100, David Howells wrote:
> Implement a pair of new system calls to provide extended and further extensible
> stat functions.
> 
> The third of the associated patches provides these new system calls:
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
> 		struct xstat_time	st_crtime;
> 		unsigned long long	st_blocks;
> 		unsigned long long	st_inode_version;
> 		unsigned long long	st_data_version;
> 		unsigned long long	query_flags;
> 	#define XSTAT_QUERY_CREATION_TIME	0x00000001ULL
> 	#define XSTAT_QUERY_INODE_VERSION	0x00000002ULL
> 	#define XSTAT_QUERY_DATA_VERSION	0x00000004ULL
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
> which are more fully documented in that patch's description.
> 
> The bonuses of these new stat functions are:
> 
>  (1) The fields in the xstat struct are cleaned up.  There are no split or
>      duplicated fields.
> 
>  (2) Some extra information is made available (file creation time, inode
>      version number and data version number) where provided by the underlying
>      filesystem.
> 
>      These are implemented here for Ext4 and AFS, but could also be provided
>      for CIFS, NTFS and BtrFS and probably others.
> 
>  (3) The structure is versioned and extensible, meaning that further new system
>      calls shouldn't be required.
> 
> Note that no lstat() equivalent is required as that can be implemented through
> xstat() with atflag == 0.
> 
> 
> The first patch makes const a bunch of system call userspace string/buffer
> arguments.  I can then make sys_xstat()'s filename pointer const too (though
> the entire first patch is not required for that).
> 
> The second patch makes the AFS filesystem use i_generation for the vnode ID
> uniquifier rather than i_version, and assigns i_version to hold the AFS data
> version number, making them more logical for when I want to get at them from
> afs_getattr().
> 
> 
> There's a test program attached to the description for patch 3.  It can be run
> as follows:
> 
> 	[root@andromeda ~]# /tmp/xstat /afs/archive/linuxdev/fedora9/i386/repodata/
> 	xstat(/afs/archive/linuxdev/fedora9/i386/repodata/) = 152
> 	sv=0 qf=6 cr=0.0 iv=7a5 dv=5
> 	  Size: 2048            Blocks: 0          IO Block: 4096   directory
> 	Device: 00:13           Inode: 83          Links: 2
> 	Access: (0755/drwxr-xr-x)  Uid: 75338   Gid: 0
> 	Access: 2008-11-05 20:00:12.000000000+0000
> 	Modify: 2008-11-05 20:00:12.000000000+0000
> 	Change: 2008-11-05 20:00:12.000000000+0000
> 	Inode version: 7a5h
> 	Data version: 5h
> 
> 
> Things that need consideration:
> 
>  (1) Is it worth retaining the ability to arbitrarily add extra bits onto the
>      end of the stat buffer?  And what's the best way to do this?
> 
>      I've defined a way that from userspace involves assigning bits in
>      query_flags to extra results that you might want.  But this could instead
>      be done, say, by just upping the struct version number any time we want to
>      pass back more information.  Alternatively, we could go for a tagged data
>      method, perhaps using the same format as the recvmsg() control message
>      field.
> 
>      If we use tagged data then rather than being selective, we could just
>      return as many tagged data items as we feel the user might want and we can
>      cram into the buffer.  That could be rather slow, though.
> 
>  (2) What extra bits of information might we like to see available through the
>      stat interface?  Security labels?  NFS file IDs?  Xattrs?
> 
>      If we went for a tagged data method, xstat() could be modified to take a
>      list of tags as an argument, and could then return arbitrarily-sized
>      tagged results, including fs-specific stuff.
> 
>  (3) Does st_blksize really need to be 64 bits on a 64-bit system?  Or can it
>      be 32-bits?  Are we really likely to see something with a 4Gb+ blocksize?
> 
>  (4) Should the inode number and data version number fields be 128-bit?

There has been a lot of interest in allowing the user to specify exactly
which fields they want the filesystem to return, and whether or not the
kernel can use cached data or not. The main use is to allow
specification of a 'stat light' that could help speed up
"readdir()+multiple stat()" type queries. At last year's Filesystem and
Storage Workshop, Mark Fasheh actually came up with an initial design:

   http://www.kerneltrap.com/mailarchive/linux-fsdevel/2009/4/7/5427274

If we're going to add in a whole new syscall for stat, should we perhaps
revisit this discussion?

Cheers
  Trond
