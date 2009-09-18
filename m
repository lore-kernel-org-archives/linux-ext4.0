From: Jens Kubieziel <maillist@kubieziel.de>
Subject: Re: git svn clone freezes the pc on ext4
Date: Fri, 18 Sep 2009 20:37:19 +0200
Message-ID: <20090918183719.GA14213@kubieziel.de>
References: <20090917131356.GG9393@kubieziel.de> <4AB2474D.2000908@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jengate.thur.de ([217.17.193.190]:46811 "EHLO jengate.thur.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387AbZIRShX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 14:37:23 -0400
Received: from tacop (p5B2B501C.dip.t-dialin.net [91.43.80.28])
	(authenticated bits=0)
	by jengate.thur.de (8.14.3/8.14.1) with ESMTP id n8IIbJfd028420
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 20:37:23 +0200
Content-Disposition: inline
In-Reply-To: <4AB2474D.2000908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Eric Sandeen schrieb am 2009-09-17 um 16:27 Uhr:
> Jens Kubieziel wrote:
> > I recently changed my /home-partition to ext4 and wanted to clone a SVN
> > repository. After calling "git svn clone https://...", git began
> > fetching old revisions and at every try the complete pc freezes. It
>=20
> .28 is getting a bit old, I'd probably try a newer upstream kernel as wel=
l.

I upgraded to .31 from Ubuntu and cannot reproduce the problem.

Regards,

--=20
Jens Kubieziel                                   http://www.kubieziel.de
"=C4hnlich scheitert Anne Will mit ihrem letzten Versuch, die Kanzlerin
mal wirklich fest zu nageln."
http://www.zeit.de/online/2009/13/merkel-anne-will (mittlerweile korrigiert)

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKs9NfVm02LO4Jd+gRApJrAKC8SzwkGt3sCuBlxQYjbItKb6tj3gCgmqdy
ynlU7jn7WZhlgQKFiTiH/mY=
=jSha
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
