From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 05 Mar 2007 07:15:33 -0800
Message-ID: <45EC3415.6000307@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <8A8B28AA-3481-4CFF-AEAA-0CB4CCDFF9F9@cam.ac.uk> <20070305143703.GF26781@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7CB176E9316BAC63D943D816"
To: Theodore Tso <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070305143703.GF26781@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7CB176E9316BAC63D943D816
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Theodore Tso wrote:
> Given that glibc already has to support this for older kernels, I
> would argue that there's no point putting in generic support for
> filesystem that can't support a more advanced way of doing things.

Well, I'm sure the kernel can do better than the code we have in libc
now.  The kernel has access to the bitmasks which say which blocks have
already been allocated.  The libc code does not and we have to be very
simple-minded and simply touch every block.  And this means reading it
and then writing it back.  The kernel would know when the reading part
is not necessary.  Add to then the block granularity (we use f_bsize as
returned from fstatfs but that's not the best value in some cases) and
you have compelling data to have generic code in the kernel.  Then libc
implementation can then go away completely which is a good thing.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig7CB176E9316BAC63D943D816
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF7DQV2ijCOnn/RHQRAi9fAJ0b/PaSZBZvix28DBCddUOMTDE7mgCfYD7H
3WSVUkvsl9W+wg7aG5s4CNE=
=776z
-----END PGP SIGNATURE-----

--------------enig7CB176E9316BAC63D943D816--
