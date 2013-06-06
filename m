From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] ext4: add check to io_submit_init_bio
Date: Fri, 7 Jun 2013 09:49:40 +1000
Message-ID: <20130607094940.d4a0056025f1c3ad32c35155@canb.auug.org.au>
References: <20130606115653.a21b0c6a7bdbbbac23164b85@canb.auug.org.au>
	<20130606141941.GA5382@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Jun_2013_09_49_40_+1000_.py8XxszQ1LcfX.u"
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130606141941.GA5382@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Signature=_Fri__7_Jun_2013_09_49_40_+1000_.py8XxszQ1LcfX.u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Thu, 6 Jun 2013 10:19:41 -0400 Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Thu, Jun 06, 2013 at 11:56:53AM +1000, Stephen Rothwell wrote:
> >=20
> > In tracking this down, I followed the call chains and discovered that
> > io_submit_init_bio() only ever returned 0.  Switching that to return
> > void and following back up the chain lead to the following patch.
>=20
> Actually, that's a bug.  We're missing an check in that function.
> Thanks for looking at this code.  (I'll fix the uninitialized err
> warning another way.)

Glad to be of service.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Jun_2013_09_49_40_+1000_.py8XxszQ1LcfX.u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsSAYAAoJEECxmPOUX5FESGYP/RPUQO39eFs1JGS/FEWd9Ciz
JsSe2/e3+mx8dQXNYz8EsvNGBglkA4ViclVFPT7Mv+hPzcblLpL+p4NLGnzhB64f
b5iSYtWpEGfgXCj387cxtjtGeuMbB8jTyYB45RcFD119Yr4oUo70E0ixZSRw0FOw
LN2mVd6hZiC/lU8IKXU4ZybDCxa8B46V+DSQf7m+LvVacx/Igr2HokfyHXVeNdA1
fInfcYpSsb7zCVaXktdqOBRVGGlbFw3XhoC9r3IxNRKm4k417flYXNjQBsByG/de
vMuf6DCUzckc48st7Zxrf0dI28uOPDW8z7FfGbDU6jw8rRLOQqpZEigbdg1fQ6hf
aIRmKbGL1E4wPea3tQwhRGZspR1WEYjqmOxoPcSQ1Mvg/Y8ufRp1U0xVguPCzWo7
NJ45Y85yk+CaCZAwURda6hGBvA3BK689DyiBz8Y8hcnXKQucE4LadGZM2RJEsQ0y
PmvtgY0ISIe11KPBDli7RP0udruN6/uyazh7cRg0RJRQ8QIsW7nKqOBzG6LaWVc2
4cBPaTW2sr2UITTs8VBoKfmgDAFKLLHOX12VdXmCjw8QukUf2ktkapDjMtQJbd16
Bx+/hlemk1/M2bUG2q585fMmwRU13DbunWamDh4YfrZEuyUgW3+P7rI38y62qD+s
TOenNVRrmbulelx/PNMz
=OSN6
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jun_2013_09_49_40_+1000_.py8XxszQ1LcfX.u--
