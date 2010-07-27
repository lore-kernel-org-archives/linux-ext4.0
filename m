From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/18] xstat: Make special system filesystems return FS_SPECIAL_FL [ver #6]
Date: Tue, 27 Jul 2010 14:41:24 +0100
Message-ID: <17717.1280238084@redhat.com>
References: <8426.1279548573@redhat.com> <20100718084955.GB27794@infradead.org> <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021720.5544.19973.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8426.1279548573-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Also, not all the flags are per-filesystem.  The following are:
> 
> 	FS_SPECIAL_FL		/* Special file as found in procfs/sysfs */
> 	FS_REMOTE_FL		/* File is remote */

Actually, that last is not true; FS_REMOTE_FL is per-file, not per-fs.  You
can have a filesystem that has fabricated files and remote files.  For
instance, with kAFS at some point you will be go into /afs, do a lookup for a
directory that doesn't exist, but whose name represents a cell+volume, the
filesystem will fabricate a local directory and then attempt to mount a remote
directory on to it.

David
