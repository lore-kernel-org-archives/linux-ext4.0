From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 3/3] xstat: Implement a requestable extra result to procure some inode flags [ver #4]
Date: Fri, 2 Jul 2010 11:45:41 -0600
Message-ID: <C80B6032-0FB2-4D63-B940-3FE86B52992B@dilger.ca>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk> <20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100701235738.19035.21536.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2010-07-01, at 17:57, David Howells wrote:
> [This is, for the moment, to be considered an example.  Do we actually want to
> export these flags?  Should they be a full member of struct xstat?]

I would say this should be a full-fledged member of struct xstat.  I think they are fairly standard (available on many filesystems today), and requiring an ioctl to access them is unpleasant.

> (1) User settable flags (to be consistent with the BSD st_flags field):
> 
> 	UF_NODUMP	Do not dump this file.
> 	UF_IMMUTABLE	This file is immutable.
> 	UF_APPEND	This file is append-only.
> 	UF_OPAQUE	This directory is opaque (unionfs).
> 	UF_NOUNLINK	This file can't be removed or renamed.
> 	UF_COMPRESSED	This file is compressed.
> 	UF_HIDDEN	This file shouldn't be displayed in a GUI.
> 
>    The UF_SETTABLE constant is the union of the above flags.
> 
> (2) Superuser settable flags (to be consistent with the BSD st_flags field):
> 
> 	SF_ARCHIVED	This file has been archived.
> 	SF_IMMUTABLE	This file is immutable.
> 	SF_APPEND	This file is append-only.
> 	SF_NOUNLINK	This file can't be removed or renamed.
> 	SF_HIDDEN	This file is a snapshot inode.
> 
>    The SF_SETTABLE constant is the union of the above flags.
> 
> (3) Linux-specific flags:
> 
> 	XSTAT_LF_MAGIC_FILE	Magic file, such as found in procfs and sysfs.
> 	XSTAT_LF_SYNC		File is written synchronously.
> 	XSTAT_LF_NOATIME	Atime is not updated on this file.
> 	XSTAT_LF_JOURNALLED_DATA Data modifications to this file are journalled.
> 	XSTAT_LF_ENCRYPTED	This file is encrypted.
> 	XSTAT_LF_SYSTEM		This file is a system file (FAT/NTFS/CIFS).
> 	XSTAT_LF_TEMPORARY	This file is a temporary file (NTFS/CIFS).
> 	XSTAT_LF_OFFLINE	file is currently unavailable (CIFS).

Yuck on the names.  Why not stick with the "UF_" and "SF_" prefixes?  Since we don't need to keep _binary_ compatibility with these flag values (only name portability) we can use the same flag values as the FS_*_FL definitions in fs.h.  That is what all of the existing filesystems already use (ext2/3/4, ocfs, btrfs, reiserfs, xfs, jfs).

Cheers, Andreas
