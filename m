From: Tony Vroon <tony@linx.net>
Subject: Re: [PATCH -BUGFIX] Re: BUG in ext4 with 2.6.37-rc1
Date: Sun, 07 Nov 2010 22:53:35 +0000
Message-ID: <1289170415.2853.3.camel@localhost>
References: <20101102202013.GA3861@elliptictech.com>
	 <20101103181412.GH25614@thunk.org> <20101103182229.GA8766@elliptictech.com>
	 <20101103205306.GA3627@elliptictech.com> <20101107212143.GA28396@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KzD+RMcyujP4saWCmT7d"
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:58128 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab0KGWxX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Nov 2010 17:53:23 -0500
In-Reply-To: <20101107212143.GA28396@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-KzD+RMcyujP4saWCmT7d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-11-07 at 16:21 -0500, Ted Ts'o wrote:
> OK, I think I have a new version of the patch that should fix both the
> original and the second BUG_ON which you reported.
> Subject: [PATCH -v2] ext4: handle writeback of inodes which are being fre=
ed

Tested-By: Tony Vroon <tony@linx.net>

This survived a 'cvs up' in /cvs/gentoo-x86 with only the CVS directory
in place; a workload that died at roughly 90% before. I did my best to
recreate the heavy I/O conditions that existed when it died there
before, with Evolution being opened just as cvs starts the first writes.
I opened Transmission-gtk with a few LiveDVD ISOs just for good measure.
The system was loaded enough for "su -" to stall for 20 seconds at some
points but ext4 survived now.

I do believe you have found the culprit, many thanks :)

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-KzD+RMcyujP4saWCmT7d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkzXLe8ACgkQp5vW4rUFj5rg5QCfbPZRL9u/k92Ury0JkB4I447s
yOoAnRA4DJz7HbjHHmznckbmu1rkSSTS
=SR2l
-----END PGP SIGNATURE-----

--=-KzD+RMcyujP4saWCmT7d--

