From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Date: Wed, 10 Sep 2008 16:47:01 +0300
Message-ID: <20080910134700.GI3757@localhost.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain> <20080910114042.GA15996@infradead.org> <20080910114923.GC3757@localhost.localdomain> <48C7CDF4.2020206@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0XMZdl/q8hSSmFeD"
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752038AbYIJNqo@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48C7CDF4.2020206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--0XMZdl/q8hSSmFeD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 08:39:00AM -0500, Eric Sandeen wrote:
> Kirill A. Shutemov wrote:
> > On Wed, Sep 10, 2008 at 07:40:42AM -0400, Christoph Hellwig wrote:
> >> On Wed, Sep 10, 2008 at 02:40:12PM +0300, Kirill A. Shutemov wrote:
> >>> On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
> >>>> On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> >>>>> linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
> >>>> And who cares? =20
> >=20
> > Do you think it isn't error?
> >=20
> >>> It breaks building pam_mktemp at least.
> >> pam_mktemp should not use <linux/ext2_fs.h>, but rather
> >> <ext2fs/ext2_fs.h>.
>=20
> That's right.
>=20
> > Why linux/ext2_fs.h does export to userspace?
> >=20
>=20
> it does?
>=20
> $ grep header-y include/linux/Kbuild | wc -l
> 163
> $ grep header-y include/linux/Kbuild | grep ext2
> $
>=20
> I think it does not.

It does:

$ grep unifdef-y include/linux/Kbuild | grep ext2
unifdef-y +=3D ext2_fs.h

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--0XMZdl/q8hSSmFeD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjHz9QACgkQbWYnhzC5v6p/VwCePsvaciKrrHOdf5+ib74tgSKJ
ptIAoIK7PquXkumnsh48ahHOHCSKZvpn
=+dLe
-----END PGP SIGNATURE-----

--0XMZdl/q8hSSmFeD--
