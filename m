From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Thu, 2 Jul 2009 11:51:08 -0400
Message-ID: <200907021151.10268.vapier@gentoo.org>
References: <200905311113.23004.arvidjaar@mail.ru> <ac3eb2510907020549g138c5dd2y3caa8eeba782c3ac@mail.gmail.com> <20090702142515.GA29429@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2770737.3sYOAzarHo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41387 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZGBPwD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jul 2009 11:52:03 -0400
In-Reply-To: <20090702142515.GA29429@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart2770737.3sYOAzarHo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 02 July 2009 10:25:15 Theodore Tso wrote:
> On Thu, Jul 02, 2009 at 02:49:24PM +0200, Kay Sievers wrote:
> > > Kay's rules look like they should be fairly straightforward to drop
> > > into e2fsprogs.  personally i'd use:
> > > E =3D @:
> > > when V=3D1, but this is probably just splitting hairs
> >
> > Ah nice, looks good to me, if that works.
>
> Take a look at what I've checked into e2fsprogs' maint branch; it was
> largely based on what you suggested.
>
> If someone can point me at an autoconf test that determines whether or
> not we're using gmake, I could even set up something which sucks in a
> Makefile fragment that enhances what we can do for developers who are
> using GNU make.  (i.e., if you're using GNU make, "make V=3D1" will
> DTRT, but if you're using a Solaris or BSD make, you'll have to settle
> for "configure --enable-verbose-makecmds")

two methods:
 - http://autoconf-archive.cryp.to/check_gnu_make.html
 - a local "GNUmakefile" will be processed by GNU make only, and be done=20
before the normal Makefile
=2Dmike

--nextPart2770737.3sYOAzarHo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKTNduAAoJEEFjO5/oN/WBv5wQAKZZgjOsEDHOHOqYiaJwdfyx
QBWLXkxjjtp9rq07uZknZfoKMP7RAvOBCSzxEsxHsk3NyTSzzDpVtf90bPzvXQ+a
AkOTgep2wYwKBOkaSF1F/59WkHTXJNUaMSu2OaLG5rQEUFFkd1zDJTz4ANDvLbmM
VElw1k5e3aT9dIE/Q6CjUMn6DV0b8XRTOOQgEz/SQw8c7mLslDcAf+ie6qcsPF3c
2VF20Jh7+L2AAsJChXLQzNdtzBHHqy47Q32NQXJDaSo9JeJljY18zPC4h/h4e6Dc
+SON96O8P0NnzD3sInr9DHotR+eCtdz8m2hH2YIBxkg2eYzpF0YkDroXsDAIZ3Z2
AiYGYFNMEpd4mGLS9awJV25EHjJo9/WG22BGG9+2b+rybtkU/Ey5e0n+k9a2YzE1
U1E5Xat+JNsngas/XbXz2ufWtfT/BF5AuLb2i35XwbnY6VURcQD8INiLqGo5yGkg
RO6lrRtrVJ7eV1l/IbMidp0Ir+hzJpwe8bM3SERTwbsxapQn0BID30nB+0QiAx3H
2tf5/EzjAQDvdao5diy1+zTs3nkDwITtHqtcVyrmN8awvlOw4jvxXPGZASx93y9H
OFopub1/ZTRSpfuOHUU5K3olAtMFzYYmLZwYz+73OW9D+dBvXpN/0stjrtAoUnYo
e/QvXAs46DqV6jo2xwtK
=b7Ai
-----END PGP SIGNATURE-----

--nextPart2770737.3sYOAzarHo--
