From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 03/12] statx: Add a system call to make enhanced file
 info available
Date: Wed, 25 Nov 2015 07:21:13 +1100
Message-ID: <20151124202113.GJ26718@dastard>
References: <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
 <20151120145457.18930.79678.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arnd-r2nGTMty4D4@public.gmane.org, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151120145457.18930.79678.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 20, 2015 at 02:54:57PM +0000, David Howells wrote:
> The defined bits in st_ioc_flags are the usual FS_xxx_FL, plus some extra
> flags that might be supplied by the filesystem.  Note that Ext4 returns
> flags outside of {EXT4,FS}_FL_USER_VISIBLE in response to FS_IOC_GETFLAGS.
> Should {EXT4,FS}_FL_USER_VISIBLE be extended to cover them?  Or should the
> extra flags be suppressed?

Quite frankly, we should not expose flags owned by a filesystem like
this. Create a new set of flagsi that are exposed by the syscall,
and every filesystem is responsible for translating their internal
flag values to the syscall flag values....

> The defined bits in the st_information field give local system data on a
> file, how it is accessed, where it is and what it does:
> 
> 	STATX_INFO_ENCRYPTED		File is encrypted
> 	STATX_INFO_TEMPORARY		File is temporary (NTFS/CIFS/deleted)
> 	STATX_INFO_FABRICATED		File was made up by filesystem
> 	STATX_INFO_KERNEL_API		File is kernel API (eg: procfs/sysfs)
> 	STATX_INFO_REMOTE		File is remote
> 	STATX_INFO_OFFLINE		File is offline (CIFS)
> 	STATX_INFO_AUTOMOUNT		Dir is automount trigger
> 	STATX_INFO_AUTODIR		Dir provides unlisted automounts
> 	STATX_INFO_NONSYSTEM_OWNERSHIP	File has non-system ownership details
> 	STATX_INFO_REPARSE_POINT	File is reparse point (NTFS/CIFS)

	STATX_INFO_XATTR		File/dir has extended attrs

... just like these STATX_INFO flags are filesystem independent...

And, FWIW, I'd like to see more than one local filesystem supported
in the initial patchset (e.g. btrfs) and also have all their
inode/fs flags exposed so we don't end up encoding weird
ext4-specific feature quirks into the API.....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
