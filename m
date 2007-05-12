From: Eric <erpo41@gmail.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Sat, 12 May 2007 01:11:46 -0700
Message-ID: <1178957506.20145.41.camel@eric-laptop>
References: <20070512020248.GQ6375@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FewbKlhz/1dX4WHL51dS"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:16218 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbXELILw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 May 2007 04:11:52 -0400
Received: by py-out-1112.google.com with SMTP id a29so1025793pyi
        for <linux-ext4@vger.kernel.org>; Sat, 12 May 2007 01:11:52 -0700 (PDT)
In-Reply-To: <20070512020248.GQ6375@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-FewbKlhz/1dX4WHL51dS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-11 at 19:02 -0700, Andreas Dilger wrote:
> What would be rather convenient is to store the RAID stride value in the
> superblock.
> There is also a library used in the XFS tools that knows how to probe var=
ious
> kinds of block devices (e.g. MD RAID, LVM/DM, etc) to get their storage
> layout that would avoid the need for the user to specify anything.
>=20
> Any thoughts on this?

It's late at night here so my thoughts are a little fuzzy. Nonetheless:=20

The concept is really tempting. RAID is good, and not asking the user
for information that the system can find out for itself is good too.

In the unlikely event that the RAID stride were to change, I think the
autodetect-each-time method would be superior to the store-in-superblock
method. Doubly so if the code to detect MD and LVM stride is lean and
clean.

I wonder if, in a RAID 0 configuration, deliberately misaligning data
structures smaller than (size of stride * number of disks in array)
would yield a performance benefit.

Cheers,

Eric

--=-FewbKlhz/1dX4WHL51dS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGRXbCe2L37HVup3ARAgDyAJ9rxEMy418tTJ7EFvngLmPilMNf7gCg32Ns
zKSYT6HJ0G0KkfLt98JDxCI=
=iSwO
-----END PGP SIGNATURE-----

--=-FewbKlhz/1dX4WHL51dS--
