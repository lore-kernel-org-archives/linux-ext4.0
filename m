From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Tue, 26 Jun 2012 12:47:49 +1000
Message-ID: <20120626024748.GB26200@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
 <20120626021046.GA26200@thor.bakeyournoodle.com>
 <20120626023331.GC14329@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:57187 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab2FZCrx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 22:47:53 -0400
Content-Disposition: inline
In-Reply-To: <20120626023331.GC14329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 25, 2012 at 10:33:31PM -0400, Theodore Ts'o wrote:
> On Tue, Jun 26, 2012 at 12:10:47PM +1000, Tony Breeds wrote:
> >=20
> > I was thinking that this was the very sinmple matter of making
> > BMAP_STATS conditional rather that have it always #defined.  Is that
> > what you were thinking?
> >=20
> > Also what's the correct way to get BMAP_STATS_OPS defined?
>=20
> Yeah, I was thinking to simply rename BMAP_STATS and BMAP_STATS_OPS to
> ENABLE_BMAP_STATS and ENABLE_BMAP_STATS_OPS, and then handle them via
> an AC_ARG_ENABLE much like --enable-compression is handled (with the
> first enabled by default, so --disable-bmap-stats to the configure
> script would disable it, while the much more heavier weight from a
> performance standpoint BMAP_STATS_OPS would be disabled by default, so
> the user would have to specify --enable-bmap-stats-ops to the
> configure script to enable it.)

Thanks for the clarification.  Should be doable today.

Yours Tony

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6SLUAAoJEEsCiJRY75GKywEQAKT9nh5Y0XYKFAok6/KvECnI
9TJB4lplYLoR+eOuqHtkwaxs0yYl0U3uVZevSjzPgNMcTqkG0J3em3VUkd9qCiK+
RfCV9ME5/cWYtchoLIktccMpkRJY5flmu4gTRes4J8s3SYyhLnV8v0I20OgE/OD9
wbz5dKhlzo8kImOwmpEcrhNk5ORTKG7B0BxYJzGUx3kwA27rEov7sLeSsXc4FIy/
uFa02QyVCDEouMYvqgok0Ei7wOxQK0d9C3ROAM9Id0wAapxXq9ppJHC2h3iDQxcn
+HFpbTT0uhLRpaiode8ThyXHeOoiVSaLg+XLDMAq2kD/R6fBuv8ibQEujG8Yssu4
PtQJZLC4DncFg8+TbK/Zga3MuSr3Y4+tH7uYVz3dysgFaWQpKfjYS8bIOHp7uat0
bCKVHGJHn2MMX5OThY7gXv1kXcZ14gKQFDD5/F3Qr/jAcI2I3sXRKpPYq+EHu13U
z96rLjymE6vrYXeC7Z0sImrYo/kwNVyhGjCCN63OKZW2DZfN66ZxPTgBnAvpelld
YK0dB4q419WNO1eKeoAEZER841uSb1ylcKGsE6nXf86HQEtfUzdA/e6oHKAGmFjT
66L2CH10ZXq2/0VTrwSg9uoqnp7AvPGpYX8OpJSXFll+WPKAd48A6jtGm8mzLD8H
iXr1lNn5JMvsyuUzpMul
=dEeQ
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
