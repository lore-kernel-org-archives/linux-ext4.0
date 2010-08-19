From: Andre Noll <maan@systemlinux.org>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Thu, 19 Aug 2010 15:10:17 +0200
Message-ID: <20100819131017.GV16603@skl-net.de>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819005404.GO21182@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0iexB5Bk8cF8G6DP"
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:47823 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0HSNKc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 09:10:32 -0400
Content-Disposition: inline
In-Reply-To: <20100819005404.GO21182@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--0iexB5Bk8cF8G6DP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 18, 20:54, Ted Ts'o wrote:
> On Wed, Aug 18, 2010 at 02:20:13PM -0600, Andreas Dilger wrote:
> >=20
> > Ah, that is also a major user of memory, and not necessarily one
> > that optimizing the internal bitmap will help significantly.  It may
> > well be that your swap cannot be used if a single allocation is in
> > the same neighbourhood as the total RAM size.
>=20
> Something which *might* help (but will take a long time) is to add to
> your /etc/e2fsck.conf (if you have one; if not create one wiht these
> contents):
>=20
> [scratch_files]
>     directory =3D /var/cache/fsck
>=20
> (And then make sure /var/cache/fsck exists.)

Thanks for the hint. It is running for an hour now and I will report
back tomorrow. ATM, it's at 1% and the two files in /var/cache/fsck
are ~50M large.

> Unfortunately, as it turns out tdb (from Samba) doesn't scale as much
> as I would have liked, so it's on my todo to replace this with
> something else.  The problem with that berk_db has non-standard
> interfaces and varies from version to version.  So I've avoided using
> it up until now.

Silly question: Would it be possible to simply mmap a large enough
file for the data and and use e.g. rbtrees for the lookups? If yes,
osl [1] could probably be an option. It's very simple but likely too
slow on inserts to be useful for e2fsprogs.

> A related blog entry:
>=20
> http://thunk.org/tytso/blog/2009/01/12/wanted-incremental-backup-solution=
s-that-use-a-database/

Hey, I read this posting back then, and I agree with what you say.
However, we are quite happy with our hard link based backup and use
it to "snapshot" file systems as large as 16T. Users love that they
can simply copy back an older version of the file they just removed
by accident. Another killer argument for this type of backup is that
you can easily replace a broken system by the machine that stores
the backup. This takes an hour while restoring everything from tapes
takes _weeks_.

But yes, from the file system developer's POV the whole concept of
hard link based backups must be a nightmare ;) And it does not work
well if there are very many files. Unfortunately, this is the case
for the file system in question.

> P.S.  I recently was told about a new backup system that meets the
> requirements detailed in my post:
>=20
>     http://sites.google.com/site/hashbackup/home/features
>=20
> I haven't tried it yet, but it looks interesting.  Let me know if you
> do try it and what you think of it.

Looks interesting, but where's the source? I might give it a try for
the problematic file system, but maybe not before next month.

Thanks
Andre

[1] http://systemlinux.org/~maan/osl
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--0iexB5Bk8cF8G6DP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMbS05Wto1QDEAkw8RAldLAJ9DaoD9PiWaxDoTJOPVn+AYdjtP/wCfTTJ7
feM2q6wFdD2NiCWIeyziPnQ=
=YTiH
-----END PGP SIGNATURE-----

--0iexB5Bk8cF8G6DP--
