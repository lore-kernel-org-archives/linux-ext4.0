From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
 file stats available [ver #6]
Date: Sun, 18 Jul 2010 04:48:24 -0400
Message-ID: <20100718084824.GA27794@infradead.org>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
 <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100715021712.5544.44845.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Adding Uli to the Cc list to make sure this system call is useful
for glibc / can be exported by it.  Otherwise it's rather pointless
to add it.

>  (6) BSD stat compatibility: Including more fields from the BSD stat such as
>      creation time (st_btime) and inode generation number (st_gen) [Jeremy
>      Allison, Bernd Schubert]

How is this different from (1) and (4)?

>  (7) Extra coherency data may be useful in making backups [Andreas Dilger].

What do you mean with that?

>  (8) Allow the filesystem to indicate what it can/cannot provide: A filesystem
>      can now say it doesn't support a standard stat feature if that isn't
>      available.

What for?

>  (9) Make the fields a consistent size on all arches, and make them large.

Why making them large for the sake of it?  We'll need massive changes
all through libc and applications to ever make use of this.  So please
coordinate the types used with Uli.

> The following structures are defined for the use of these new system calls:
> 
> 	struct xstat_parameters {
> 		unsigned long long	request_mask;
> 	};

Just pass this as a single flag by value.  And just make it an unsigned
long to make the calling convention a lot simpler.


> 	struct xstat_dev {
> 		unsigned int		major, minor;
> 	};
> 
> 	struct xstat_time {
> 		unsigned long long	tv_sec, tv_nsec;
> 	};

No point in adding special types here that aren't genericly useful.
Also this is the first and only system call using split major/minor
values for the dev_t.  All this just creates more churn than it helps.

> 
> 	struct xstat {
> 		unsigned long long	st_result_mask;

Just st_mask?

> 		unsigned long long	st_data_version;

st version?

> 		unsigned long long	st_inode_flags;



> The defined bits in request_mask and st_result_mask are:
> 
> 	XSTAT_REQUEST_MODE		Want/got st_mode
> 	XSTAT_REQUEST_NLINK		Want/got st_nlink
> 	XSTAT_REQUEST_UID		Want/got st_uid
> 	XSTAT_REQUEST_GID		Want/got st_gid
> 	XSTAT_REQUEST_RDEV		Want/got st_rdev
> 	XSTAT_REQUEST_ATIME		Want/got st_atime
> 	XSTAT_REQUEST_MTIME		Want/got st_mtime
> 	XSTAT_REQUEST_CTIME		Want/got st_ctime
> 	XSTAT_REQUEST_INO		Want/got st_ino
> 	XSTAT_REQUEST_SIZE		Want/got st_size
> 	XSTAT_REQUEST_BLOCKS		Want/got st_blocks
> 	XSTAT_REQUEST__BASIC_STATS	The stuff in the normal stat struct
> 	XSTAT_REQUEST_BTIME		Want/got st_btime
> 	XSTAT_REQUEST_GEN		Want/got st_gen
> 	XSTAT_REQUEST_DATA_VERSION	Want/got st_data_version
> 	XSTAT_REQUEST_INODE_FLAGS	Want/got st_inode_flags
> 	XSTAT_REQUEST__EXTENDED_STATS	The stuff in the xstat struct
> 	XSTAT_REQUEST__ALL_STATS	The defined set of requestables

What's the point of the REQUEST in the name?  Also no double
underscores inside the identifier.  Instead adding a _MASK postfix
for masks would make it a lot more clear.

> The defined bits in st_inode_flags are the usual FS_xxx_FL flags in the LSW,
> plus some extra flags in the MSW:
> 
> 	FS_SPECIAL_FL		Special kernel file, such as found in procfs
> 	FS_AUTOMOUNT_FL		Specific automount point
> 	FS_AUTOMOUNT_ANY_FL	Free-form automount directory
> 	FS_REMOTE_FL		File is remote
> 	FS_ENCRYPTED_FL		File is encrypted
> 	FS_SYSTEM_FL		File is marked system (DOS/NTFS/CIFS)
> 	FS_TEMPORARY_FL		File is temporary (NTFS/CIFS)
> 	FS_OFFLINE_FL		File is offline (CIFS)

Please don't overload the FL_ namespace even more.  It's already a
complete mess given that it overloads the extN on-disk namespace.
You're much better off just adding a clean new namespace.

> The system calls are:
> 
> 	ssize_t ret = xstat(int dfd,
> 			    const char *filename,
> 			    unsigned flags,
> 			    const struct xstat_parameters *params,
> 			    struct xstat *buffer,
> 			    size_t buflen);

If you already have a buflen parameter there is absolute no need for
the extra results field.  Just define new fields at the end and include
them if the bufsize is big enough and it's in the mask of requested
fields.

> When the system call is executed, the request_mask bitmask is read from the
> parameter block to work out what the user is requesting.  If params is NULL,
> then request_mask will be assumed to be XSTAT_REQUEST__BASIC_STATS.

Why add a special case like that?  Especially if we make the request
flags a pass by value scalar initalizing it is trivial.

> The request_mask should be set by the caller to specify extra results that the
> caller may desire.  These come in a number of classes:
> 
>  (0) dev, blksize.
> 
>      These are local data and are always available.
> 
>  (1) mode, nlinks, uid, gid, [amc]time, ino, size, blocks.
> 
>      These will be returned whether the caller asks for them or not.  The
>      corresponding bits in result_mask will be set to indicate their presence.
> 
>      If the caller didn't ask for them, then they may be approximated.  For
>      example, NFS won't waste any time updating them from the server, unless as
>      a byproduct of updating something requested.

Please don't introduce tons of special cases.  Instead use a simple rule
like:

 - a filesystem must return all attributes requests, or return an
   error if it can't.
 - a filesystem may return additional attributes, the caller can detect
   this by looking at st_mask.

plus possibly a list of attributes the filesystem must be able to
provide if requests.  I don't see a reason to make that mask different
from the attributes required by Posix.
