From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Fri, 16 Jul 2010 16:10:01 +0100
Message-ID: <13226.1279293001@redhat.com>
References: <201007161246.15923.arnd@arndb.de> <201007152235.22373.arnd@arndb.de> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30646.1279230807@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201007161246.15923.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:

> > > For the volume id, I could not find any file system that requires more
> > > than 32 bytes here, which is also reasonable to put into the structure.
> > > Make it 36 if you want to cover ascii encoded UUIDs.
> > 
> > You should also include a length.  Volume IDs may be binary rather than
> > NUL-terminated strings.
> 
> Yes, maybe. There are several possible encodings for this. I was actually
> thinking of fixed-length string rather than zero-terminated, but that
> is possible as well. If this gets added, we need to audit every possible
> use to make sure each of them is covered. My point was mostly that if we
> need at most 40 bytes, it doesn't have to be variable length at all.

I suppose it depends what you want it for.  Steve French asked for it:

	> (4) Should the inode number and data version number fields be
	>     128-bit?
	>
	This is tricky for SMB2, if you can also provide a device id (or an
	object id of some sort for the superblock) then 64 bit inode number is
	ok.

But I'm not sure what he wants to put in there.  He didn't respond to my reply:

	A remote device ID?  That would be possible.  That could be used by
	AFS to return the numeric volume ID (32 bits) and by NFS to return the
	FSID (128 bits).  Would you be using the VolumeGUID (128 bits) for
	SMB2?

so I'm not sure what he's thinking of.

Looking through various filesystems:

	FS	SOURCE				FORMAT	LENGTH (BYTES)
	=======	===============================	=======	=============
	-	__kernel_fsid_t			int	8
	-	super_block::s_id		chars	32
	ext234	superblock s_uuid 		UUID	16
	ext234	superblock s_volume_name	chars	16
	nfs2	FSID				int	4
	nfs3	FSID				int	8
	nfs4	FSID				int	16
	afs	Volume Name + type		chars	64+1
	afs	Numeric volume ID		int	4
	cifs	VolumeGUID			UUID	16
	btrfs	superblock fsid			bytes	16
	fat	superblock system_id+version?	bytes	8+2
	ntfs	volume_serial_number		int	8
	ntfs	FILE_Volume object_id		UUID	16
	xfs	superblock sb_fname		chars	12
	xfs	superblock sb_uuid		UUID	16
	jfs	superblock s_uuid		UUID	16
	jfs	superblock s_label		bytes	16
	isofs	medium_catalog_number		chars	13
	isofs	volume_id			chars	32
	udf	volIdent			chars	32


it would seem that a 16-byte (128-bit) ID would suit quite well.  That would be
able to contain most things and could be added to the super_block struct.  That
would also give NFSD something to use as a default FSID and Samba something to
used as a VolumeGUID.

David
