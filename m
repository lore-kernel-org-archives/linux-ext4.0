From: Darren Hart <dvhart@infradead.org>
Subject: Re: xattr corruption issue on ext2fs generated filesystems
Date: Tue, 16 Feb 2016 23:35:43 -0800
Message-ID: <20160217073543.GE22091@dvhart-mobl5.amr.corp.intel.com>
References: <1454757826.27087.300.camel@linuxfoundation.org>
 <1455128452.24036.38.camel@linux.intel.com>
 <20160213212955.GD6338@birch.djwong.org>
 <20160213223459.GE6338@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>,
	Darren Hart <dvhart@linux.intel.com>,
	linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbcBQHfm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2016 02:35:42 -0500
Content-Disposition: inline
In-Reply-To: <20160213223459.GE6338@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 13, 2016 at 02:34:59PM -0800, Darrick J. Wong wrote:
> On Sat, Feb 13, 2016 at 01:29:55PM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 10, 2016 at 10:20:52AM -0800, Darren Hart wrote:
> > > On Sat, 2016-02-06 at 11:23 +0000, Richard Purdie wrote:
> > > > I'm using the -d option of mke2fs to construct a filesystem, I'=
m
> > > > seeing
> > > > that some xattrs are being corrupted. The filesystem builds wit=
h no
> > > > errors but when mounted by the kernel, I see errors like
> > > > "security.ima:
> > > > No such attribute". The strace from such a failure is:
> > >=20
> > >=20
> > > Interesting. +Ted and +Darrick who helped us merge the -d argumen=
t
> > > originally.
> > >=20
> > >=20
> > > > mmap(NULL, 26258, PROT_READ, MAP_SHARED, 3, 0) =3D 0x7fdb36a8c0=
00
> > > > close(3)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=3D 0
> > > > getrlimit(RLIMIT_NOFILE, {rlim_cur=3D1024, rlim_max=3D64*1024})=
 =3D 0
> > > > lstat("mnt/foobar", {st_mode=3DS_IFREG|0755, st_size=3D1, ...})=
 =3D 0
> > > > listxattr("mnt/foobar", NULL, 0) =3D 30
> > > > listxattr("mnt/foobar", "security.SMACK64\0security.ima\0", 256=
) =3D 30
> > > > getxattr("mnt/foobar", "security.SMACK64", 0x0, 0) =3D 1
> > > > getxattr("mnt/foobar", "security.SMACK64", "_", 256) =3D 1
> > > > fstat(1, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 13), .=
=2E.}) =3D 0
> > > > mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOU=
S, -1,
> > > > 0) =3D 0x7fdb36a8b000
> > > > write(1, "# file: mnt/foobar\n", 19# file: mnt/foobar) =3D 19
> > > > write(1, "security.SMACK64=3D\"_\"\n", 21security.SMACK64=3D"_"=
) =3D 21
> > > > getxattr("mnt/foobar", "security.ima", 0x0, 0) =3D -1 ENODATA (=
No data
> > > > available)
> > > > write(2, "mnt/foobar: ", 12mnt/foobar: ) =3D 12
> > > > write(2, "security.ima: No such attribute\n", 32security.ima: N=
o such
> > > > attribute) =3D 32=3D 32
> >=20
> > Aha, you're right, the trick is that EAs in an external block have =
to be sorted
> > by index number, then by strlen(name), and then by strcmp(name).  U=
nlike inode
> > attributes, which can be in any order.
> >=20
> > e2fsprogs inserts them in whatever order you happened to set them, =
which is
> > whatever order llistxattr provides them.
> >=20
> > So, Mr. Purdie's is correct -- attr_compare needs to do more work, =
but it needs
> > to grab the index number and the suffix text (via find_ea_index()) =
and
> > replicate the same comparison operators as the kernel code.
> >=20
> > (Not sure why we bother to sort the keys in the xattr block since t=
here can
> > only be one block, but whatever...)
>=20
> A patch to (I hope) fix this issue will appear shortly as patch #9 in
> my e2fsprogs patchbomb.  When it appears, can you please give it a sp=
in?

Thank you very much Darrick!

--=20
Darren Hart
Intel Open Source Technology Center
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
