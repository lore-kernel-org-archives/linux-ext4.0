From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Question on ext4 directory hashes in combination with file name encryption
Date: Fri, 30 Sep 2016 14:20:00 -0600
Message-ID: <CAF99CF6-E26D-4696-9F12-B3DFBC3C7561@dilger.ca>
References: <9a5198b3-0c00-a558-5132-9c38b4bb8795@nod.at>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E30F902E-918C-458B-AED1-A32AA552F427"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <9a5198b3-0c00-a558-5132-9c38b4bb8795@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E30F902E-918C-458B-AED1-A32AA552F427
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 30, 2016, at 8:09 AM, Richard Weinberger <richard@nod.at> wrote:
>=20
> Hi,
>=20
> if I read the ext4 code correctly, you pass encrypted filenames to =
ext4fs_dirhash().
> These filenames are not encoded and therefore binary gibberish.
> Isn't this a problem for the ext4 hash functions? My fear is that =
these hashes are optimized
> for ASCII strings and produce more collisions when binary data is used =
as input.

The default hash function (half-md4) is an (old) crypto hash and works
fine with binary data.  Some of the other hash functions are less =
strong,
but I don't think anyone changes the hash function for ext4.

Cheers, Andreas






--Apple-Mail=_E30F902E-918C-458B-AED1-A32AA552F427
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV+7I8XKl2rkXzB/gAQjnOxAAsEClYdTR8cXCb3tfOdxz0YDB7lSKSaXw
7SCc9Ol9S/b3LTL3LLBMyXdUunmURDFnxX8rLKhIAXQSeLL7W1hPkrLKLsUH3Smx
gmwhepMFA/4XZy25sD288NKXf0KhvSiJ5FMkp3h1o2z3/PzJKcglgDykOciBy5+9
zY1MYdfOURLxU6lpr/ypub6Qa67qUEVwC4XrVopXBu3OX4KvWAtBGcOdb9yq0soo
nKrTbWneq+MK6OSoDaygRU3cJJZ/8Hc8fjr6VXfp29nCEaNw7IYNDPrCB1aQi9p3
AiGuMXJLzwkUxzJ11Eh/y8JpGvDer76u6vfsIHRDcCkcOaUBVqXO8eMLtqCAo+2x
loT5ccANWS9S+Y3A5L9P//STC6C72M+4AYrpvboKJVMhNyexef685WIwfT5gCMu6
obnnj0pTg8re4zblcPuz3CMXTiBcZFVecOhIsRNlWFmwe3gusuJ/nd7Slz8xi5GE
0n/NvQrmVdnzPb/wlRJC/mjUe2O45TlM5kutieF7xzAIdqgqD2U7dB9ujn2GrcPn
WPslJuIhBRsEaU/a/EgI4ZNcNgNInmU+JC7cqSun89hlrORGzn/6cNVH/GYEXpTQ
PmtuAgpfPWDEi9XJ4HqCtopfr7dDqg9BRY1Vi7f/xWf2znpjusZN2mCuJ8YN4MxX
A3G5j5FsRKM=
=hR1K
-----END PGP SIGNATURE-----

--Apple-Mail=_E30F902E-918C-458B-AED1-A32AA552F427--
