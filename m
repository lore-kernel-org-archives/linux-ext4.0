From: Russell Cattelan <cattelan@thebarn.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 15:31:08 -0500
Message-ID: <1161721868.29094.35.camel@xenon.msp.redhat.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz>
	 <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net>
	 <20061024041433.GB12506@havoc.gtf.org>
	 <20061024135928.GB11034@melbourne.sgi.com>
	 <20061024194416.GB16087@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ReSBdGW5mPuoFvtWApCO"
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	Alex Tomas <alex@clusterfs.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cattelan-host202.dsl.visi.com ([208.42.117.202]:8408 "EHLO
	slurp.thebarn.com") by vger.kernel.org with ESMTP id S1161114AbWJXUcs
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 16:32:48 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061024194416.GB16087@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-ReSBdGW5mPuoFvtWApCO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-10-24 at 15:44 -0400, Theodore Tso wrote:
> On Tue, Oct 24, 2006 at 11:59:28PM +1000, David Chinner wrote:
> > That's the wrong way to look at it. if you want the userspace
> > process to specify a location, then you should preallocate it first
> > before doing anything else. There is no need to clutter a simple
> > data mover interface with all sorts of unnecessary error handling.
>=20
> This is doable, but it adds a huge amount of complexity before we
> could implement on-line defragmentation.
>=20
> First of all, we would need a way of allowing userpsace to specify
> which blocks should be used in the preallocation.
>=20
> Secondly, we would need a way of marking blocks as "preallocated but
> not pre-zeroed"; otherwise we would have to zero out all of the blocks
> in order to assure security (don't want userspace programs seeing the
> previous contents of the data blocks), only to do the copy and the
> extents vector swap

Chris Mason page place holder work for DIRECT IO should be applicable to
any pre-allocations?


--=20
Russell Cattelan <cattelan@thebarn.com>

--=-ReSBdGW5mPuoFvtWApCO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFPngMNRmM+OaGhBgRAs/xAJ0TspiyKdljn3HKa7UBmD+lQDHqeACcD6KM
Sth36VIh+T+Uq5ThpcASWak=
=H5Mh
-----END PGP SIGNATURE-----

--=-ReSBdGW5mPuoFvtWApCO--
