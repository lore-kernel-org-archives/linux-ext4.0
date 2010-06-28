From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation
	available by xattrs
Date: Mon, 28 Jun 2010 11:33:10 -0500
Message-ID: <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100628162626.6026.26679.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 28, 2010 at 11:26 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> Make the file creation time, inode data version number and inode gene=
ration
> number available on Ext4 by as xattrs named:
>
> =A0 =A0 =A0 =A0file.crtime
> =A0 =A0 =A0 =A0file.i_generation
> =A0 =A0 =A0 =A0file.i_version (directories only for ext4)
>
> This could then be used by Samba as the SMB protocol passes the file =
creation
> time to the client.
>
> With this patch, you can see the xattrs providing binary data:
>
> [root@andromeda ~]# getfattr -d /var/cache/fscache -e hex -m\.*
> getfattr: Removing leading '/' from absolute path names
> # file: var/cache/fscache
> file.crtime=3D0x53ba244c000000000000000000000000
> file.i_generation=3D0x0000000000000000
> file.i_version=3D0x0400000000000000

It would be easy enough to do something similar for crtime for cifs
(it may also be possible to do something similar to
i_generation and i_version at least for smb2 but haven't
experimented to see which servers could return something
similar to version and generation).  I did have a request for
someone doing a backup application over cifs to return creation
time so at least this would make sense.


--=20
Thanks,

Steve
