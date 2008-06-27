From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH] ext4: fix online resize with mballoc
Date: Fri, 27 Jun 2008 16:36:50 +0200
Message-ID: <1214577410.3257.24.camel@localhost>
References: <20080626143704.642665893@bull.net>
	 <1214492283.10187.17.camel@localhost>
	 <20080626232659.GY6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40251 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYF0OgP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 10:36:15 -0400
In-Reply-To: <20080626232659.GY6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for your feedback !

Le jeudi 26 juin 2008 =C3=A0 17:26 -0600, Andreas Dilger a =C3=A9crit :
> On Jun 26, 2008  16:58 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD w=
rote:
> > From: Frederic Bohe <frederic.bohe@bull.net>
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
> It probably also makes sense to round this up to the next power-of-tw=
o
> value, since kmalloc will do that internally anyways, and it gives us
> some resizing headroom for no cost.

Do you have any idea of how this headroom could be used in the future ?

Regards,
=46red





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
