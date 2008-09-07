From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Sun, 7 Sep 2008 18:04:14 +0200
Message-ID: <20080907160414.GB26248@charite.de>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ausfall.charite.de ([193.175.70.131]:33822 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYIGQKD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2008 12:10:03 -0400
Content-Disposition: inline
In-Reply-To: <20080907121557.GA3432@x200.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Alexey Dobriyan <adobriyan@gmail.com>:

> > Why not use strchr(), which is normally optimized assembly:
> >=20
> > 	char *p =3D devname;
> > 	while ((p =3D strchr(p, '/'))
> > 		*p =3D '_';
> >=20
> > Using '!' as the separator makes it harder to use from shells I sus=
pect,
> > so I'd suggest '_' instead.
>=20
> bdevname is only 32 bytes and done once per mount, so nobody cares.
>=20
> '!' is what other code does in this situation (reiserfs, md, ...).

Anyway, the first patch fixes the issue. Will it go into mainline soon?

--=20
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charit=
e.de
Charite - Universit=C3=A4tsmedizin Berlin            Tel.  +49 (0)30-45=
0 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570=
-962
IT-Zentrum Standort CBF                              I'm looking for a =
job!
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
