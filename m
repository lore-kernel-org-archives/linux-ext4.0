From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 05 Mar 2007 08:07:24 -0800
Message-ID: <45EC403C.3020704@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <8A8B28AA-3481-4CFF-AEAA-0CB4CCDFF9F9@cam.ac.uk> <20070305143703.GF26781@thunk.org> <45EC3415.6000307@redhat.com> <20070305160153.GI26781@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig047926DEBCFEF4EC2586E7CB"
To: Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070305160153.GI26781@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig047926DEBCFEF4EC2586E7CB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Theodore Tso wrote:
> [...] although the libc
> implementation still wouldn't be able to go away for long time due to
> the need to be backwards compatible with older kernels that didn't
> have this support.

It's better than that.  If somebody compiles glibc to not run on older
kernels at all (tested at runtime) then the code is dropped.  E.g., the
current Fedora glibc does not support 2.6.8 or earlier.

So, don't let the compat code be a factor in the decision making.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig047926DEBCFEF4EC2586E7CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF7EA92ijCOnn/RHQRAgsbAKCZcV0zDM8GF5OGOMLP5/XJl0eT5gCfbDah
ro/6A/SqdLS1qSlMLWQ1Z44=
=9J0B
-----END PGP SIGNATURE-----

--------------enig047926DEBCFEF4EC2586E7CB--
