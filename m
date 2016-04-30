From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [RFC][PATCH 0/6] Enhanced file stat system call
Date: Sat, 30 Apr 2016 17:05:49 -0400
Message-ID: <1462050349.10011.52.camel@poochiereds.net>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-afs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2016-04-29 at 13:57 +0100, David Howells wrote:
> Implement a new system call to provide enhanced file stats.=C2=A0=C2=A0=
The patches can
> be found here:
>=20
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/lo=
g/?h=3Dxstat
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> DESCRIPTION
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The first patch provides this new system call:
>=20
> 	long ret =3D statx(int dfd,
> 			=C2=A0const char *filename,
> 			=C2=A0unsigned atflag,
> 			=C2=A0unsigned mask,
> 			=C2=A0struct statx *buffer);
>=20
> This is an enhanced file stat function that provides a number of usef=
ul
> features, in summary:
>=20
> =C2=A0(1) More information: creation time, data version number, inode=
 generation
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0number and flags.=C2=A0=C2=A0A subset o=
f these is available through a number of
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0filesystems (such as CIFS, NFS, AFS, Ex=
t4 and BTRFS).
>=20
> =C2=A0(2) Lightweight stat (AT_NO_ATTR_SYNC): Ask for just those deta=
ils of
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0interest, and allow a network fs to app=
roximate anything not of
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0interest, without going to the server.
>=20
> =C2=A0(3) Heavyweight stat (AT_FORCE_ATTR_SYNC): Force a network fs t=
o flush
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0buffers and go to the server, even if i=
t thinks its cached attributes
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0are up to date.
>=20
> =C2=A0(4) Allow the filesystem to indicate what it can/cannot provide=
: A
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0filesystem can now say it doesn't suppo=
rt a standard stat feature if
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0that isn't available.
>=20
> =C2=A0(5) Make the fields a consistent size on all arches, and make t=
hem large.
>=20
> =C2=A0(6) Can be extended by using more request flags and using up th=
e padding
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0space in the statx struct.
>=20
> Note that no lstat() equivalent is required as that can be implemente=
d
> through statx() with atflag =3D=3D 0.=C2=A0=C2=A0There is also no fst=
at() equivalent as
> that can be implemented through statx() with filename =3D=3D NULL and=
 the
> relevant fd passed as dfd.
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D
> TESTING
> =3D=3D=3D=3D=3D=3D=3D
>=20
> A test program is added into samples/statx/ by the first patch.
>=20
> David
> ---
> David Howells (6):
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0statx: Add a system call to make =
enhanced file info available
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0statx: AFS: Return enhanced file =
attributes
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0statx: Ext4: Return enhanced file=
 attributes
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0statx: NFS: Return enhanced file =
attributes
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0statx: Make windows attributes av=
ailable for CIFS, NTFS and FAT to use
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0statx: CIFS: Return enhanced attr=
ibutes
>=20
>=20
> =C2=A0arch/x86/entry/syscalls/syscall_32.tbl |=C2=A0=C2=A0=C2=A0=C2=A0=
1=C2=A0
> =C2=A0arch/x86/entry/syscalls/syscall_64.tbl |=C2=A0=C2=A0=C2=A0=C2=A0=
1=C2=A0
> =C2=A0fs/afs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A024 ++-
> =C2=A0fs/cifs/cifsfs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A04=C2=A0
> =C2=A0fs/cifs/cifsglob.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A08 +
> =C2=A0fs/cifs/dir.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0
> =C2=A0fs/cifs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0117 +++++++++---
> =C2=A0fs/exportfs/expfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A04=C2=A0
> =C2=A0fs/ext4/ext4.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0
> =C2=A0fs/ext4/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0
> =C2=A0fs/ext4/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A030 +++
> =C2=A0fs/ext4/namei.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0
> =C2=A0fs/ext4/symlink.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0
> =C2=A0fs/nfs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A041 ++++
> =C2=A0fs/stat.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0306 =
+++++++++++++++++++++++++++++---
> =C2=A0include/linux/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A05 -
> =C2=A0include/linux/stat.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A0=C2=A015 +-
> =C2=A0include/linux/syscalls.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=
=A04=C2=A0
> =C2=A0include/uapi/linux/fcntl.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0
> =C2=A0include/uapi/linux/stat.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0135 +++++++++=
+++++
> =C2=A0samples/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0
> =C2=A0samples/statx/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=
=C2=A010 +
> =C2=A0samples/statx/test-statx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0274 +++++++++++++++=
++++++++++++++
> =C2=A023 files changed, 910 insertions(+), 83 deletions(-)
> =C2=A0create mode 100644 samples/statx/Makefile
> =C2=A0create mode 100644 samples/statx/test-statx.c
>=20


I looked over the patchset and it looks fairly straightforward to me.

Are there things that I'd have probably done differently? Yes, but
nothing really sticks out to me as show-stopping and this has the
potential to be helpful in all sorts of ways.

I think we really ought to resist excessive bikeshedding this time
around. With the way the interface is designed, we should be able to
expand on it later if we want to add new attributes after the interface
itself is merged.

Reviewed-by: Jeff Layton <jlayton@poochiereds.net>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
