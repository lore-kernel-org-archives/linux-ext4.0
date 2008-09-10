From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Date: Wed, 10 Sep 2008 14:40:12 +0300
Message-ID: <20080910114011.GB3757@localhost.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:27802 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYIJLjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 07:39:41 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1100078eyi.37
        for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 04:39:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080910112709.GA11742@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> > linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
>=20
> And who cares? =20

It breaks building pam_mktemp at least.

It's regression introduced by commit 36695673b.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjHshsACgkQbWYnhzC5v6rAZACeOu6dJN2J4FAU791UYghiVJMq
IYkAnAos59VGUJK+XW28DlY4lUF92c6h
=/YlD
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
