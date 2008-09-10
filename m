From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Date: Wed, 10 Sep 2008 14:49:24 +0300
Message-ID: <20080910114923.GC3757@localhost.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain> <20080910114042.GA15996@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:20214 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYIJLsw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 07:48:52 -0400
Received: by ug-out-1314.google.com with SMTP id k3so484490ugf.37
        for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 04:48:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080910114042.GA15996@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 07:40:42AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 10, 2008 at 02:40:12PM +0300, Kirill A. Shutemov wrote:
> > On Wed, Sep 10, 2008 at 07:27:09AM -0400, Christoph Hellwig wrote:
> > > On Wed, Sep 10, 2008 at 02:22:03PM +0300, Kirill A. Shutemov wrote:
> > > > linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h
> > >=20
> > > And who cares? =20

Do you think it isn't error?

> > It breaks building pam_mktemp at least.
>=20
> pam_mktemp should not use <linux/ext2_fs.h>, but rather
> <ext2fs/ext2_fs.h>.

Why linux/ext2_fs.h does export to userspace?


--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjHtEMACgkQbWYnhzC5v6rh5gCdGdIT0xkimZvRmRPEUmyWi14d
jn8An2zHJUEBabtmUzfo6Agr5f1t9eDt
=Efdu
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
