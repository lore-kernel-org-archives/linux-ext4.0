From: Andres Freund <andres@anarazel.de>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 2 Dec 2008 18:47:24 +0100
Message-ID: <200812021847.35771.andres@anarazel.de>
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1405010.FDNW2tE0uM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.anarazel.de ([217.115.131.40]:44666 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbYLBRrk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2008 12:47:40 -0500
In-Reply-To: <20081202164709.GC18162@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1405010.FDNW2tE0uM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Tuesday 02 December 2008 17:47:09 Theodore Tso wrote:
> You say you are using Postgres, right?  Something you might try to see
> if it triggers the problem it is creating a new database and then
> restoring some database dump/backup into that new database.  Some
> databases expand into a new table space (or whatever terminology
> Postgres uses) by random writes into a sparse portion of the file.
> This could be triggering the problem, or at least trigger the problem
> more quickly.
I tried that - I have seen no problems so far. But it is not the first time=
 I=20
did not see the problem for some time.

Btw, postgres just creates the database by copying over a default database.

=46or an easy test with sparse files, I created a big one, set it up as a l=
oop=20
device, created a filesystem and ran some stuff in it.
No Problem so far.

> The other thing I wanted to ask is whether "df" was showing the 37%
> in-use statistic at the time, or was that after you rebooted.=20
It definitely was before a reboot. And there were plenty of both, inodes an=
d=20
blocks.

I think that I have seen the problem on metadata only changes (find /tmp -t=
ype=20
f|xargs touch) as well, but sometimes metadata changes were possible while =
file=20
creation was not.

Another Datapoint: File deletion sometimes made it possible to create more=
=20
files, but by far not as much as the space freed.

> And although I hate to ask it, you're sure this isn't the standard "delete
> an in-use file but not get the space back" Unix trap, right?
There were over 200GB free, so I doubt that. I don't know what could have=20
caused an allocation of so much space unnoticed in an idle system multiple=
=20
times.
But I do understand the reason for the question ;-)


Andres

--nextPart1405010.FDNW2tE0uM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk1dK4ACgkQporPraT14ihacQCdHkIhXaNgYpTgrQ5Fk22PbXGu
i2UAniRSW0lFNCVxCmwEUs1CqO4C6349
=Nt6t
-----END PGP SIGNATURE-----

--nextPart1405010.FDNW2tE0uM--
