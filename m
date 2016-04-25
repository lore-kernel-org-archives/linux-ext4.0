From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Backport commit 5e1021f2b6dff
Date: Tue, 26 Apr 2016 00:26:18 +0200
Message-ID: <1461623178.14569.16.camel@decadent.org.uk>
References: <20160414133056.GC22053@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vrCk7YWCBL7UGRRBatoF"
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
To: Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33801 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbcDYW0f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2016 18:26:35 -0400
In-Reply-To: <20160414133056.GC22053@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-vrCk7YWCBL7UGRRBatoF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-04-14 at 15:30 +0200, Jan Kara wrote:
> Hello,
>=20
> I'd like to ask for commit 5e1021f2b6dff (ext4: fix NULL pointer derefere=
nce
> in ext4_mark_inode_dirty()) to be pulled into stable kernels as far as
> easily possible (the problem is there at least since 3.0 kernel) since I'=
ve
> got report of kernel crashes due to this bug on accidental USB disk
> removal. Thanks!

Queued up for 3.2 and 3.16, thanks.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u
--=-vrCk7YWCBL7UGRRBatoF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXHpmKAAoJEOe/yOyVhhEJh8IP/3Yf3Edm6ogpzy9PoZHn74vR
6G5DToM0hxfY1dsNTP7ODklbIsFJJJf9cUvJR2sqHnur3UarpNxWYD+yarYIt0kn
yXv6+MMb0U7bbaOtFdYczT9j0OftHgJ5wPHSjrUk03ET21bnCL+zhJYho1QAmoar
wNHAKaN2GCY6OK4YANgK7tSyjUPyy0UxF3Dr7TCpj3eEdpWHnFJUQw3aaX1meVXT
u08mlbduAAQgTCjBByxbY9zVIFKl1SoebwxeLM65/kRoLSKSxadNVRyhGkaKjk4q
SQkMuua6AN/VlvaMe0uQs+urmKQ478TFLCqwrGfpNh5fF+txKUanu6TnSl/OQbYD
6zh7JM67TZTpmGpHlNC7o1DoxHuZIxyNNLNiT7nenO19MV5Vkt731bUArY0Yg5vi
dTvU8UfXjBkdbPd4YkB62Pazi7OSyhVk0GV07oY8fU5XrboNwnArlZKRKp6KeYSk
9uLzsNThmPngtT8hWEYeMeZH3bcw3XFtlGNptc9lMurgPUeeP5rtAiUS71yiI3V+
SAX45FhFBwIKiLJzn1rCkdIMfL8u5R7NcCqugXd0iKosBhqSrEyrKtuMxgwFu4xw
BkbT7zKujWD1HfEob4DAfaD8F/jYarDUm2pWUxzYHh/Zs491EYJdYpRq6X+R3ISV
vBdXecJ8cQJkF0v5+kgq
=XKOZ
-----END PGP SIGNATURE-----

--=-vrCk7YWCBL7UGRRBatoF--
