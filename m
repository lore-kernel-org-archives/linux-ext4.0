From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: dumpe2fs: only print 'unused inodes' once
Date: Wed, 10 Sep 2014 17:38:43 -0400
Message-ID: <20140910213843.GB15632@thunk.org>
References: <BAY179-W101B94761503C2D6FBA0CBFDCE0@phx.gbl>
 <20140909194746.GF10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: TR Reardon <thomas_reardon@hotmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49435 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbaIJVir (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2014 17:38:47 -0400
Content-Disposition: inline
In-Reply-To: <20140909194746.GF10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2014 at 12:47:46PM -0700, Darrick J. Wong wrote:
> On Tue, Sep 09, 2014 at 03:32:56PM -0400, TR Reardon wrote:
> > just a minor nit...and I don't think fixing this harms any existing=
 tests.
>=20
> Running 'make check' will tell you.
>=20
> This also needs a Signed-off-by.

It also might make more sense to move the checksum to after the inode
table, i.e., instead of:

Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0xe0c6
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-512
  Block bitmap at 513 (+513), Inode bitmap at 529 (+529)
  Inode table at 545-1056 (+545)
  24025 free blocks, 8181 free inodes, 2 directories, 8181 unused inode=
s
  Free blocks: 8743-32767
  Free inodes: 12-8192

how about:

Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-512
  Block bitmap at 513 (+513), Inode bitmap at 529 (+529)
  Inode table at 545-1056 (+545), Checksum 0xe0c6
  24025 free blocks, 8181 free inodes, 2 directories, 8181 unused inode=
s
  Free blocks: 8743-32767
  Free inodes: 12-8192

								- Ted






>=20
> --D
> >=20
> > +Reardon
> >=20
> >=20
> > diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> > index a1c5ba2..d30cf87 100644
> > --- a/misc/dumpe2fs.c
> > +++ b/misc/dumpe2fs.c
> > @@ -205,8 +205,6 @@ static void list_desc (ext2_filsys fs)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(" =A0Check=
sum 0x%04x"), csum);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (csum !=3D exp_c=
sum)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pri=
ntf(_(" (EXPECTED 0x%04x)"), exp_csum);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(", unused in=
odes %u\n"),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs=
_bg_itable_unused(fs, i));
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 has_super =3D ((i=3D=3D0) || super_=
blk);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (has_super) {
> >=20
> >=20
> >  		 	   		  --
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
