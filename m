From: NeilBrown <neilb@suse.de>
Subject: Re: [GIT PULL] ext4 updates for 3.3
Date: Wed, 11 Jan 2012 10:54:14 +1100
Message-ID: <20120111105414.240c0a46@notabene.brown>
References: <E1Rkift-0006hB-04@tytso-glaptop.cam.corp.google.com>
	<CA+55aFwON1TgKhAg6EAkN-D-N87cw9H9UrmyJhzA0G3Rt8TSqw@mail.gmail.com>
	<20120110234250.GC6034@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kiKgN7kTlg+E3ukOe0FlFeQ"; protocol="application/pgp-signature"
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2AJXy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 18:54:28 -0500
In-Reply-To: <20120110234250.GC6034@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/kiKgN7kTlg+E3ukOe0FlFeQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jan 2012 18:42:50 -0500 Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Jan 10, 2012 at 03:15:53PM -0800, Linus Torvalds wrote:
> > On Tue, Jan 10, 2012 at 12:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > >
> > > There is a signed tag ext4_for_linus covering these commits.
> >=20
> > I'm not seeing any such tag. Forgot to push out?
>=20
> Argh, I always forget to do "git push --tags".  Pushed now...
>=20

I always
   git push $name-of-tag
and then
   git request-pull ....

and make sure it mentions the right tag.  If 'request-pull' can see it, then
I can be sure that Linus can.

NeilBrown


--Sig_/kiKgN7kTlg+E3ukOe0FlFeQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwzPpjnsnt1WYoG5AQKhxw//TVBRFt2DxSd2IaRoyXBlXLwnYkB+feFj
F7S/tU/BabmZcNzYnsJKd3fvTpQlNh6SUhzCkHsImDVOgxLBIufo4ra0rnca0UYU
5KdeEwjs1dND7Okys1OhtnQIgh9JF6kBHAiqb4g96i1HQVeqIaZ6AdYic9WbGs04
0dFWFiElx4Xwl5RtT4Fo19QqlYazmZka4d17WYSlM7M7gKnual4/H4sjIrA9g9rZ
ivvRWk3wsI/rapOFb0EfqL6uzcgdzv/EBHRyzvbq8are5rvgBNQx1KAIeDVHyW6Y
Oj5EclpE2qIErUy8eo2lNl9uQB/VQrKO6R8pOXfGph1zcuXQkrL5i+kEGZ7t/8T2
VoFE8EoNSLLtCAygMks6feqV0h6NtZ1cwG+pFQZrZySlyYbpbJUUzpAQ999B9PXy
mMi8rMOM+EfjAOb35TA1x0UrZAdrhB3erA5Nqd2c/bDCCs7hd1I8JUSLMZkvg09f
xz846u5YsAIxQr0lfU8BbOiLxHnEtOYYwO4BeTovzBNQh0MwIzcfvSGjmcISBVsX
kSoYyvnF17mQ8NgMFgwkP4Q2u0patDpQTcX/7VL+UNFLxvbWjmRBUTLwbg3iB8Av
5yf02kI3rtdYjREkbKR2SNOIdjlos9EmP6HDTc1aa9vRhP3HYbuifoMsW+1qFqfk
9Hh75HG0tEk=
=ICdc
-----END PGP SIGNATURE-----

--Sig_/kiKgN7kTlg+E3ukOe0FlFeQ--
