From: Andre Noll <maan@systemlinux.org>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Fri, 20 Aug 2010 16:40:05 +0200
Message-ID: <20100820144005.GA16603@skl-net.de>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819005404.GO21182@thunk.org> <20100819131017.GV16603@skl-net.de> <20100819171620.GB3468@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6JAe/4X0qssghT2u"
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:32957 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab0HTOkS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 10:40:18 -0400
Content-Disposition: inline
In-Reply-To: <20100819171620.GB3468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--6JAe/4X0qssghT2u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 13:16, Ted Ts'o wrote:
> On Thu, Aug 19, 2010 at 03:10:17PM +0200, Andre Noll wrote:
> > Silly question: Would it be possible to simply mmap a large enough
> > file for the data and and use e.g. rbtrees for the lookups? If yes,
> > osl [1] could probably be an option. It's very simple but likely too
> > slow on inserts to be useful for e2fsprogs.
>=20
> As I recall, you're on a 32-bit machine, right?

Right.

> If so, a limitation you may run into is simply running out of address
> space.  If it's not an address space issue, we don't need to mmap
> anything; you could just try enabling swap, and use the existing
> e2fsck code.
>=20
> (I had assumed you had tried that before suggesting you use the
> scratch_files tdb approach....)

Yes, I added 50G of swap (which is of course kind of silly) before my
first posting. This did not help, so I guess it is an address space
issue. My question about mmap was about an alternative to tdb btw.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--6JAe/4X0qssghT2u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMbpPFWto1QDEAkw8RAsuTAJ9ka60jSK0FJCf+pleaEGoee0eKmQCgl3Qv
UoKlvwPEM/mmk0fo6ypwLNE=
=6Nv3
-----END PGP SIGNATURE-----

--6JAe/4X0qssghT2u--
