From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [e2fsprogs] rename configure.in to configure.ac
Date: Mon, 8 Jun 2015 11:56:06 -0400
Message-ID: <20150608155606.GD13517@vapier>
References: <1432546352-1855-1-git-send-email-vapier@gentoo.org>
 <20150608145922.GA15795@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VACxsDaSTfeluoxK"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45347 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbbFHP4I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 11:56:08 -0400
Content-Disposition: inline
In-Reply-To: <20150608145922.GA15795@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--VACxsDaSTfeluoxK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08 Jun 2015 10:59, Theodore Ts'o wrote:
> On Mon, May 25, 2015 at 05:32:32AM -0400, Mike Frysinger wrote:
> > Newer versions of autotools have started warning when using the old
> > configure.in name.
>=20
> Note that I ship a version of configure (and keep one checked in to
> git) because I do not trust the autoconf maintainers' ability to
> maintain backwards compatibility, having gotten badly burned in the
> past.  I am currently using autoconf 2.69, and people who try to rerun
> autoconf on some other version of autoconf are venturing into
> unsupported territory.  It may work; it may screw up in amazing ways.
> Some autoconf macro may silently assume that some feature is present
> when it is not, or vice versa.
>=20
> And if it breaks, you get to keep both pieces.  :-)

that's fine, but it doesn't really matter to this patch -- it should be=20
configure.ac and not configure.in.  the version of autoconf you're using=20
certainly supports the newer name.
-mike

--VACxsDaSTfeluoxK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVdbsWAAoJEEFjO5/oN/WB+eIQAIBn46q6mXpj5LY5WvbMXmNx
4LoZXbEeDwY8fvYxUAzoArhkyyyw0GFlYDttW0jYxzn0bKvIx3pPlQcNupaWprEi
hR69hs23RdJwaZGVJfHMHnPmqP38rwZbZtrmxvy3GmxbZCdn8WT0A017BaoBGbl9
5tGz4lp06pGCwM9Era1Jdd5IFFN+OQ7RuRk6L73oQH64cxL1tnf30FPxTW5WNQ/D
WJ6drctnxUuBFOgTjk8zlHWdq5ykEZnrqAAMCLrvTJiMHuImYjvutlkLk3Ic6vSQ
xbugoTt1rahLOIzKyqAs8RLMQZEplZluZHv3tlj00yVCr7evfvWs24hYzRNLyTwe
z5VsjQBZKHswXnYYz61y+f8qJqbNNJ8Std99d0DQX8J/PGUZnXTWRhWVXqZxjLI+
Qz3m8uRR8s9y0WhiSszr1Z5BYbym/lT2ZJixwyWERUofg1tTNqyYxmV3btdfr5i/
ItgI6wqYNVR4/Y2Pfw3CFkmnhCCSg1x0W2RiOc6u72v1MY4SQ8SuFTYh0EIPz0gN
HeeeK9wVIO8DduF9F+Q1T2hTup7RPeoV/ayYKOZlkDdzlp0mF5cMSeeuCL1L3UJf
fpNqeaBjGSRCjZ7Er6yErtfkjs+GpPw0c+HtA2RRBOiV5/u/A7UCxqKVDYdE4VMG
/XA8eqAbcMkJ1wH2jU+j
=IeDy
-----END PGP SIGNATURE-----

--VACxsDaSTfeluoxK--
