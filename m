From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 05 Mar 2007 07:48:41 -0800
Message-ID: <45EC3BD9.2090604@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <200703050136.37181.arnd@arndb.de> <20070305114109.GA454@lazybastard.org> <45EC3253.2030206@redhat.com> <20070305153326.GA1469@lazybastard.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig77CA57063B64602467E123E3"
Cc: Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933554AbXCEPuY@vger.kernel.org>
In-Reply-To: <20070305153326.GA1469@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig77CA57063B64602467E123E3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

J=C3=B6rn Engel wrote:
>> Of course.  You call posix_fallocate once for the lifetime of the file=

>> when it is created to ensure that all future uses will work.
>=20
> That part is not quite clear from the manpage but I trust most people
> would assume the same.

Not only that, it is what this function is for.  In the POSIX committee
we've looked at the functions in detail before adding them, even if some
information is not in the man page but instead in the Rationale.


> Still, it is quite obvious that noone designing this interface has lost=

> much thought to compressing filesystems.

You already have problems with supporting the functionality
posix_fallocate is supporting.  You cannot reliably support MAP_SHARED
files if all of a sudden the compression causes and expansion of a block
and that causes a ENOSPC error.  So, don't expect pity.  This is a
function in support of a real and reliable implementation of memory
mapped files.  You don't use MAP_SHARED on such filesystems, it'll eat
your kittens sooner or later anyway.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig77CA57063B64602467E123E3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF7DvZ2ijCOnn/RHQRAiQUAJ9B+efQ+xd3MrgwsG42Uitd2c6RSgCcCdA7
g0s1HK7Izt51Trru9/W9KY0=
=ezJL
-----END PGP SIGNATURE-----

--------------enig77CA57063B64602467E123E3--
