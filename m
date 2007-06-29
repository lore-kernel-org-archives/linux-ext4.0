From: "Hanno =?utf-8?q?B=C3=B6ck?=" <ml@hboeck.de>
Subject: Re: E2fsprogs 1.40 release imminent!
Date: Fri, 29 Jun 2007 23:51:29 +0200
Message-ID: <200706292351.33006.ml@hboeck.de>
References: <E1I2aKE-0008RV-KP@tinytim.thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1614229.jyitLLbpRa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zucker.schokokeks.org ([85.10.204.247]:41663 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbXF2V4G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2007 17:56:06 -0400
In-Reply-To: <E1I2aKE-0008RV-KP@tinytim.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--nextPart1614229.jyitLLbpRa
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag 25 Juni 2007 schrieb Theodore Ts'o:
> ... contains what I hope to be the e2fsprogs 1.40 release.  If folks
> could test it and let me know if they find any embarassing bugs, I would
> greatly appreciate it.  It can also be found at:

There are a bunch of patches applied in the gentoo package that might be wo=
rth=20
looking at:
http://dev.gentoo.org/~hanno/e2fsprogs/

All of them still seem to apply to the current mercurial source. I'm not=20
really familiar with them, just noted that there are a lot of patches and=20
nobody seemed to care sending upstream in the past.

e2fsprogs-1.32-mk_cmds-cosmetic.patc
e2fsprogs-1.38-tests-locale.patch
e2fsprogs-1.39-makefile.patch
e2fsprogs-1.39-parse-types.patch
e2fsprogs-1.39-util-strptime.patch
e2fsprogs-1.40-libintl.patch


=2D-=20
Hanno B=C3=B6ck		Blog:   http://www.hboeck.de/
GPG: 3DBD3B20		Jabber: jabber@hboeck.de

--nextPart1614229.jyitLLbpRa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGhX7kr2QksT29OyARAuKqAJ4qRDHygpm/WDAGMBxtSSeLt5mWpQCfYp1a
kFurlTXtJm28iJdgPwrTHFg=
=ijvv
-----END PGP SIGNATURE-----

--nextPart1614229.jyitLLbpRa--
