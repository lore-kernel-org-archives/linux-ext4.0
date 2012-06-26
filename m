From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Tue, 26 Jun 2012 12:10:47 +1000
Message-ID: <20120626021046.GA26200@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:48496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab2FZCKv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 22:10:51 -0400
Content-Disposition: inline
In-Reply-To: <20120618171257.GA16017@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 01:12:57PM -0400, Ted Ts'o wrote:

> If you'd like to try to clean up the --disable-mmp patch, and perhaps
> try your hand at a --disable-libext2fs-stats patch which disable the
> statistics options, that would be great.=20

I'm ready to tackle the --disable-libext2fs-stats portion but I need to
make sure I'm looking in the rigth area.

I was thinking that this was the very sinmple matter of making
BMAP_STATS conditional rather that have it always #defined.  Is that
what you were thinking?

Also what's the correct way to get BMAP_STATS_OPS defined?

Yours Tony

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6RomAAoJEEsCiJRY75GKaMQP/RCSAgRHlkp2dzEB+nzAhnSL
y35hoAX4timMyFuPJJ7q7M5fTISr5WHzlQsOAJFPAFWpCIjoFlfx92ob4Aqou/5I
dlRGlKPKMKaqkQikEPbnAoj9ZvGfXiSp13FXBaGof2KrONnMhN+Jyc8bmDW/iCwu
iwVTrcBV3keXQGzFapWvOjj6VB/2m+/7+x7DSAGxFskszHgqy0evJYXx9xlfGLhS
aWp4PU8YI+3ANjSHLvOq8Oo3OAfPEv5Retq3tUZQXFc+Vg0bIbHSrxcXRQM1hGDE
g8CsFZHtuElzyh9NdSkUwkv5M7voBwmsICNtmfEq2mgDl1qjvmL6t8rCUnAiBYEC
si/GM6MBy9zqtUU+wwvzVQe7bmgAXOaWijTgBznYyWxnPwCnKp34CkIS+s3RvJ7N
R390LPrjmyBqY1w5jCQwAz3IFNDY9aUaSdIDX88WaAKKI9bzX30ARikzc0MDMu3O
ntkwpOBUL1nuK2dOytvI4jOolJ/xfLziGJlf7e9ly8Z0jmg2to+z/UoDMrAF1dfx
3OvmSPmHzpFYEcXZoVZk+GsOKoCwWbg/5eB+T8+RzC624Y6xA3ewfXWNtc+2qpFW
7Jds6/F7fLoNTGsM98a/xPmnuzEZPwF8zBfDnyijIK69aJ+KDgOYKK0fNPGImUAG
jmjnGmOr5VX4BgOPdK2Y
=4Vqs
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
