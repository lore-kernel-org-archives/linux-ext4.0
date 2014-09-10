From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: dumpe2fs: only print 'unused inodes' once
Date: Wed, 10 Sep 2014 14:47:46 -0700
Message-ID: <20140910214746.GJ10351@birch.djwong.org>
References: <BAY179-W101B94761503C2D6FBA0CBFDCE0@phx.gbl>
 <20140909194746.GF10351@birch.djwong.org>
 <20140910213843.GB15632@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: TR Reardon <thomas_reardon@hotmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26807 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaIJVrx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 17:47:53 -0400
Content-Disposition: inline
In-Reply-To: <20140910213843.GB15632@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2014 at 05:38:43PM -0400, Theodore Ts'o wrote:
> On Tue, Sep 09, 2014 at 12:47:46PM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 09, 2014 at 03:32:56PM -0400, TR Reardon wrote:
> > > just a minor nit...and I don't think fixing this harms any existi=
ng tests.
> >=20
> > Running 'make check' will tell you.
> >=20
> > This also needs a Signed-off-by.
>=20
> It also might make more sense to move the checksum to after the inode
> table, i.e., instead of:
>=20
> Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
>   Checksum 0xe0c6
>   Primary superblock at 0, Group descriptors at 1-1
>   Reserved GDT blocks at 2-512
>   Block bitmap at 513 (+513), Inode bitmap at 529 (+529)
>   Inode table at 545-1056 (+545)
>   24025 free blocks, 8181 free inodes, 2 directories, 8181 unused ino=
des
>   Free blocks: 8743-32767
>   Free inodes: 12-8192
>=20
> how about:
>=20
> Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
>   Primary superblock at 0, Group descriptors at 1-1
>   Reserved GDT blocks at 2-512
>   Block bitmap at 513 (+513), Inode bitmap at 529 (+529)
>   Inode table at 545-1056 (+545), Checksum 0xe0c6

But... 0xE0C6 is the group descriptor checksum.  Since we report the bi=
tmap
csum after mentioning them:

>  Block bitmap at 2 (+2), csum 0xc759340d, Inode bitmap at 18 (+18), c=
sum 0x941e2bba

It would make more sense to report the group checksum on the first line=
:

Group 0: (Blocks 0-32767) csum 0xe0c6 [ITABLE_ZEROED]                  =
                  =20

Unless it'll break peoples' scripts?

--D

>   24025 free blocks, 8181 free inodes, 2 directories, 8181 unused ino=
des
>   Free blocks: 8743-32767
>   Free inodes: 12-8192
>=20
> 								- Ted
>=20
>=20
>=20
>=20
>=20
>=20
> >=20
> > --D
> > >=20
> > > +Reardon
> > >=20
> > >=20
> > > diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> > > index a1c5ba2..d30cf87 100644
> > > --- a/misc/dumpe2fs.c
> > > +++ b/misc/dumpe2fs.c
> > > @@ -205,8 +205,6 @@ static void list_desc (ext2_filsys fs)
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(" =A0Che=
cksum 0x%04x"), csum);
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (csum !=3D exp=
_csum)
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p=
rintf(_(" (EXPECTED 0x%04x)"), exp_csum);
> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(", unused =
inodes %u\n"),
> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2=
fs_bg_itable_unused(fs, i));
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 has_super =3D ((i=3D=3D0) || supe=
r_blk);
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (has_super) {
> > >=20
> > >=20
> > >  		 	   		  --
> > > To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
