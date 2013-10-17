From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext2: Make sb magic number endianness conversion
 consistent
Date: Thu, 17 Oct 2013 14:59:00 -0300
Message-ID: <20131017175859.GA22111@orion.maiolino.org>
References: <1382030698-8746-1-git-send-email-cmaiolino@redhat.com>
 <alpine.LFD.2.00.1310171948320.3212@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab3JQR7E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Oct 2013 13:59:04 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9HHx4qg019403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2013 13:59:04 -0400
Received: from orion.maiolino.org (ovpn-113-158.phx2.redhat.com [10.3.113.158])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9HHx1Ic028286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2013 13:59:03 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310171948320.3212@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 07:50:59PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 17 Oct 2013, Carlos Maiolino wrote:
>=20
> > Date: Thu, 17 Oct 2013 14:24:58 -0300
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> > To: linux-ext4@vger.kernel.org
> > Subject: [PATCH] ext2: Make sb magic number endianness conversion c=
onsistent
> >=20
> > All ext2_super_block fields are converted from le16 to cpu when che=
cked or
> > loaded into memory. Magic number check is the only field where we c=
onvert the
> > magic number to le16. So, make the conversion pattern consistent wi=
th the
> > remaining code
>=20
> This not exactly true since this kind of comparison when a constant
> is converted rather the variable is present on several places in
> ext2, ext3 and ext4 (ext3 and ext4 have the same check you're fixing
> here as well).=20

I agree here, it should have the same behavior on another extX versions=
, since
this code should have been copied from ext2 to another ones.

>I personally do not see the problem with this,
> so honestly I do not see a reason to fix this.
>=20

No saying it's a problem, just a cosmetic stuff I figured out while doi=
ng a trip
on ext2 code. All of other comparisons (into the same funcion at least)=
 converts
the SB value (which IMHO is the right thing to do since it's the data w=
hich
might have a different endianness).

Anyway, it just feel better to my eyes in this way, not that I have pro=
blems
with though

> Thanks!
> -Lukas
>=20
> >=20
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/ext2/super.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index 2885349..808f99f 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -927,7 +927,7 @@ static int ext2_fill_super(struct super_block *=
sb, void *data, int silent)
> >  		}
> >  		es =3D (struct ext2_super_block *) (((char *)bh->b_data) + offse=
t);
> >  		sbi->s_es =3D es;
> > -		if (es->s_magic !=3D cpu_to_le16(EXT2_SUPER_MAGIC)) {
> > +		if (le16_to_cpu(es->s_magic) !=3D EXT2_SUPER_MAGIC) {
> >  			ext2_msg(sb, KERN_ERR, "error: magic mismatch");
> >  			goto failed_mount;
> >  		}
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Carlos
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
