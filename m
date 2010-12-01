From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 03/15] mke2fs: simplify inode table block counting
Date: Wed, 01 Dec 2010 20:49:05 +0900
Message-ID: <1291204145.1684.10.camel@leonhard>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
	 <1291020917-8671-4-git-send-email-namhyung@gmail.com>
	 <alpine.LFD.2.00.1011301250470.3004@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38216 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0LALtQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 06:49:16 -0500
Received: by yxt3 with SMTP id 3so2811284yxt.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Dec 2010 03:49:15 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1011301250470.3004@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-11-30 (=ED=99=94), 13:01 +0100, Lukas Czerner:
> On Mon, 29 Nov 2010, Namhyung Kim wrote:
>=20
> > Simplify counting of inode table blocks in a block group using
> > local variable 'ipb'. Otherwise the variable could be removed
> > because there was no user of it.
> >=20
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  misc/mke2fs.c |    7 ++-----
> >  1 files changed, 2 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 0980045..9fb5d5f 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -320,11 +320,8 @@ static void write_inode_tables(ext2_filsys fs,=
 int lazy_flag, int itable_zeroed)
> > =20
> >  		if (lazy_flag) {
> >  			ipb =3D fs->blocksize / EXT2_INODE_SIZE(fs->super);
> > -			num =3D ((((fs->super->s_inodes_per_group -
> > -				  ext2fs_bg_itable_unused(fs, i)) *
> > -				 EXT2_INODE_SIZE(fs->super)) +
> > -				EXT2_BLOCK_SIZE(fs->super) - 1) /
> > -			       EXT2_BLOCK_SIZE(fs->super));
> > +			num =3D (fs->super->s_inodes_per_group -
> > +			       ext2fs_bg_itable_unused(fs, i) + ipb - 1) / ipb;
> >  		}
> >  		if (!lazy_flag || itable_zeroed) {
> >  			/* The kernel doesn't need to zero the itable blocks */
> >=20
>=20
> Hi,
>=20
> I would rather add this macro into header file (lib/ext2fs/ext2fs.h
> maybe?)
>=20
> #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>=20
> remoevd ipb variable because it is rather useless. And do something l=
ike
> this ?
>=20
> num =3D DIV_ROUND_UP((fs->super->s_inodes_per_group -
> 		    ext2fs_bg_itable_unused(fs, i)) *
> 		   EXT2_INODE_SIZE(fs->super),=20
> 		   EXT2_BLOCK_SIZE(fs->super));
>=20
> IMO it improves readability a lot and I am sure that there are other
> places which may take advantage of the DIV_ROUND_UP macro.
>=20
> Thanks!
>=20
> -Lukas

Hi, Lukas.
Thanks for the review.

We have ext2fs_div[64]_ceil() for that. So I can use it like

ipb =3D fs->blocksize / EXT2_INODE_SIZE(fs->super);
num =3D ext2_fs_div_ceil(fs->super->s_inodes_per_group -
			ext2fs_bg_itable_unused(fs, i), ipb);

or

num =3D ext2_fs_div_ceil((fs->super->s_inodes_per_group -
			ext2fs_bg_itable_unused(fs, i)) *
		       EXT2_INODE_SIZE(fs->super),
		       EXT2_BLOCK_SIZE(fs->super));

Either is fine to me. Ted, what's your preference?

--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
