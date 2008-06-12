From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v2] ext4: fix online resize group descriptors corruption
Date: Thu, 12 Jun 2008 15:35:52 +0200
Message-ID: <1213277752.7974.8.camel@localhost>
References: <1213263754.6549.45.camel@localhost>
	 <20080612105945.GB3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59784 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211AbYFLNf2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 09:35:28 -0400
In-Reply-To: <20080612105945.GB3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le jeudi 12 juin 2008 =C3=A0 04:59 -0600, Andreas Dilger a =C3=A9crit :
> On Jun 12, 2008  11:42 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD w=
rote:
> > From: Frederic Bohe <frederic.bohe@bull.net>
> >=20
> > This is the patch for the group descriptor table corruption during
> > online resize pointed out by Theodore Tso.
> > The issue was due to the ext4 group descriptor which can be either
> > 32 or 64 bytes long.
> > Only the 64 bytes structure was taken into account.
> >=20
> > diff -rup a/fs/ext4/resize.c b/fs/ext4/resize.c
> > --- a/fs/ext4/resize.c
> > +++ b/fs/ext4/resize.c
> > @@ -855,7 +855,8 @@ int ext4_group_add(struct super_block *s
> >  	 */
> > =20
> >  	/* Update group descriptor block for new group */
> > -	gdp =3D (struct ext4_group_desc *)primary->b_data + gdb_off;
> > +	gdp =3D (struct ext4_group_desc *)(
> > +	       (__u8 *)primary->b_data + gdb_off * EXT4_DESC_SIZE(sb));
>=20
> Normally pointer arithmetic is done by casting to (char *)...
> Otherwise, patch looks sensible, though it could be reformatted to=20
> match the normal coding style a bit better:
>=20
> 	gdp =3D (struct ext4_group_desc *)((char *)primary->b_data +
> 					 gdb_off * EXT4_DESC_SIZE(sb));
>=20
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>=20
>=20
=EF=BB=BF
> From: Frederic Bohe <frederic.bohe@bull.net>
> >=20
> > This is the patch for the group descriptor table corruption during
> > online resize pointed out by Theodore Tso.
> > The issue was due to the ext4 group descriptor which can be either
> > 32 or 64 bytes long.
> > Only the 64 bytes structure was taken into account.
>=20
=EF=BB=BF=EF=BB=BF=EF=BB=BFFrom: Frederic Bohe <frederic.bohe@bull.net>=
=20

This is the patch for the group descriptor table corruption during
online resize pointed out by Theodore Tso.
The issue was due to the ext4 group descriptor which can be either
32 or 64 bytes long.
Only the 64 bytes structure was taken into account.=20

=EF=BB=BFSigned-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
=EF=BB=BF resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -rup a/fs/ext4/resize.c b/fs/ext4/resize.c
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -855,7 +855,8 @@ int ext4_group_add(struct super_block *s
 	 */
=20
 	/* Update group descriptor block for new group */
-	gdp =3D (struct ext4_group_desc *)primary->b_data + gdb_off;
+	gdp =3D (struct ext4_group_desc *)((char *)primary->b_data +
+	                                 gdb_off * EXT4_DESC_SIZE(sb));
=20
 	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
 	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
