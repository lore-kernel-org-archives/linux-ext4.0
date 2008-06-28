From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: fix online resize with mballoc
Date: Fri, 27 Jun 2008 17:30:41 -0700
Message-ID: <1214613041.6837.37.camel@mingming-laptop>
References: <20080626143704.642665893@bull.net>
	 <1214492283.10187.17.camel@localhost>
	 <20080626232659.GY6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42285 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272AbYF1Aau (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jun 2008 20:30:50 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5S0UfHA002440
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2008 20:30:41 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5S0Uf5K207666
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2008 20:30:41 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5S0Uf2e005967
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2008 20:30:41 -0400
In-Reply-To: <20080626232659.GY6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-06-26 at 17:26 -0600, Andreas Dilger wrote:
> On Jun 26, 2008  16:58 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD w=
rote:
> > From: Frederic Bohe <frederic.bohe@bull.net>

>=20
> >  static int ext4_mb_init_backend(struct super_block *sb)
> >  {
> > +	/* This is the total number of blocks used by GDT including
> > +	* the number of reserved blocks for GDT.
> > +	* The s_group_info array is allocated with this value
> > +	* to allow a clean online resize without a complex
> > +	* manipulation of pointer.
> > +	* The drawback is the unused memory when no resize
> > +	* occurs but it's very low in terms of pages
> > +	* (see comments below)
> > +	*/
>=20
> Also align comment '*' in the same columns.
>=20
> > +	num_meta_group_infos_max =3D num_meta_group_infos +
> > +				le16_to_cpu(es->s_reserved_gdt_blocks);
>=20
> The only drawback of NOT handling this properly is that once (eventua=
lly)
> we allow resizing with META_BG this code will be broken again.  It at
> least deserves a comment like "Need to handle this properly when META=
_BG
> resizing is allowed" so that it will show up on any grep for META_BG.
>=20

It probably useful to document this limit in the change log too.

It would be nice to do it right now since we are here, if it's not too
complicated. The locking cost to do dynamic re-allocation of
s_groups_info seems low to me if we use read-write lock, as the write
path is relatively rare. But I guess there are a lot of there places we
need to worry to enable resize to any large with FLEX_BG/META_BG, and
could deal with that later.

Mingming
> It probably also makes sense to round this up to the next power-of-tw=
o
> value, since kmalloc will do that internally anyways, and it gives us
> some resizing headroom for no cost.
>=20
> > @@ -2276,62 +2431,15 @@ static int ext4_mb_init_backend(struct s
> >  		sbi->s_group_info[i] =3D meta_group_info;
> >  	}
> > =20
> >  	for (i =3D 0; i < sbi->s_groups_count; i++) {
> > +		if (ext4_mb_add_groupinfo(sb, i, desc) !=3D 0)
> > +			goto err_freebuddy;
>=20
> This is much nicer, great.
>=20
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>=20
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
