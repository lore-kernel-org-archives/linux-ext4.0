From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Thu, 22 Mar 2012 06:53:54 +0100
Message-ID: <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
 <20120321231651.GC32041@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2CVFyE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 01:54:04 -0400
Content-Disposition: inline
In-Reply-To: <20120321231651.GC32041@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Ted Ts'o wrote:
> On Wed, Mar 21, 2012 at 11:23:57PM +0100, Jan Kara wrote:
> >   Frankly, anybody seriously wanting to do anything with ext[2-4]
> > filesystems should use header files as provided by libext2fs. So I wond=
er
> > if just unexporting the whole file wouldn't be the best solution going
> > forward. Ted, do you have opinion?
>=20
> Agreed, it's been almost 8 years since e2fsprogs used the
> include/linux/ext2_fs.h (the last version that needed it was e2fsprogs
> 1.35, released February 28, 2004).
>=20
> There shouldn't be *anyone* using any of the ext2/3/4 kernel header
> files.  The only program that might be cheating and using kernel
> header files is ext3grep, as the author wasn't willing to fix his
> applications to use libext2fs.  (As a result, it doesn't work on ext4
> file systems, where as properly coded programs that do use libext2fs
> often work just fine on ext4, such as e2tools, which hasn't been
> modified for something like eight years but which works on ext4 just
> fine.)
>=20
> So yeah, I'd just unexport ext2_fs.h, and probably ext3_fs.h as well.

Alright. Do you want me to send a patch to do so?

What's the recommended fix for packages that cannot or will not use
libext2fs, like busybox? Copy the required parts into a private header
and use that instead?

Thierry

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9qvnIACgkQZ+BJyKLjJp+T+wCgjJ+OACZfkbfEvTtshS8OtG2R
poYAoIPdeP6RNGAfU2snxfLTP/sEc75t
=5ML4
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
