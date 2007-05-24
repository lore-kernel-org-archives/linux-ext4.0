From: coly <colyli@gmail.com>
Subject: Re: [RFC 2/5] inode reservation v0.1 (ext4 kernel patch)
Date: Thu, 24 May 2007 22:47:26 +0800
Message-ID: <1180018046.4078.2.camel@coly-t43.site>
References: <1179943606.4179.53.camel@coly-t43.site>
	 <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:54830 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXEXOqm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2007 10:46:42 -0400
Received: by py-out-1112.google.com with SMTP id a73so897028pye
        for <linux-ext4@vger.kernel.org>; Thu, 24 May 2007 07:46:41 -0700 (PDT)
In-Reply-To: <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave,

Yes, I found all TABs gone when I received the mail. When I post next
version of the patch, I will test to send to me first :-)

Thanks for your information.

Coly


=E5=9C=A8 2007-05-24=E5=9B=9B=E7=9A=84 08:20 -0500=EF=BC=8CDave Kleikam=
p=E5=86=99=E9=81=93=EF=BC=9A
> On Thu, 2007-05-24 at 02:06 +0800, coly wrote:
> > The patch is generated based on 2.6.20-ext4-2 branch. you can find =
the
> > benchmark from other email.
> >=20
> > DO NOT waste time on reading the patch :-) I post this patch here i=
s to
> > show that I really spent time on it and the patch can work (even no=
t
> > well).
>=20
> I won't waste my time then.  I'm discouraged from trying by the lack =
of
> indentation.  It looks like the tabs got converted to a single space
> somehow.
>=20
> > diff --git a/Makefile b/Makefile
> > index 7e2750f..21d21e4 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,8 +1,7 @@
> > VERSION =3D 2
> > PATCHLEVEL =3D 6
> > SUBLEVEL =3D 20
> > -EXTRAVERSION =3D
> > -NAME =3D Homicidal Dwarf Hamster
> > +EXTRAVERSION =3D inores
> >=20
> > # *DOCUMENTATION*
> > # To see a list of typical targets execute "make help"
> > diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
> > index 11e93c1..daf88b4 100644
> > --- a/fs/ext4/bitmap.c
> > +++ b/fs/ext4/bitmap.c
> > @@ -30,3 +30,29 @@ unsigned long ext4_count_free (struct buffer_hea=
d *
> > map, unsigned int numchars)
> >=20
> > #endif  /*  EXT4FS_DEBUG  */
> >=20
> > +/*
> > + * Read the inode allocation bitmap for a given block_group, readi=
ng
> > + * into the specified slot in the superblock's bitmap cache.
> > + *
> > + * Return buffer_head of bitmap on success or NULL.
> > + */
> > +struct buffer_head *
> > +read_inode_bitmap(struct super_block * sb, unsigned long block_gro=
up)
> > +{
> > + struct ext4_group_desc *desc;
> > + struct buffer_head *bh =3D NULL;
> > +
> > + desc =3D ext4_get_group_desc(sb, block_group, NULL);
> > + if (!desc)
> > + goto error_out;
> > +
> > + bh =3D sb_bread(sb, ext4_inode_bitmap(sb, desc));
> > + if (!bh)
> > + ext4_error(sb, "read_inode_bitmap",
> > + "Cannot read inode bitmap - "
> > + "block_group =3D %lu, inode_bitmap =3D %llu",
> > + block_group, ext4_inode_bitmap(sb, desc));
> > +error_out:
> > + return bh;
> > +}
> > +
>=20
> Shaggy
