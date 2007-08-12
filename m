From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] e2fsprogs: remove fragment support (V3)
Date: Mon, 13 Aug 2007 05:59:39 +0800
Message-ID: <46BF82CB.7060304@suse.de>
References: <46BC9CC3.9090005@suse.de> <20070812033129.GB21719@thunk.org> <46BF3656.4010108@suse.de> <20070812212955.GD21719@thunk.org>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig42217DF51B1F99D253D0745C"
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41612 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbXHLV7I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Aug 2007 17:59:08 -0400
In-Reply-To: <20070812212955.GD21719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig42217DF51B1F99D253D0745C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Theodore Tso wrote:
> On Mon, Aug 13, 2007 at 12:33:26AM +0800, Coly Li wrote:
>> Theodore,
>>
>> Another question of mine is for the .po files: Once I modify a string =
from _(""), should I mofify
>> all the corresponded strings from all .po files ?
>=20
> No, don't bother.  Periodically I run "make update-pot" in the po
> directory, which updates the e2fsprogs.pot file, followed by a "make
> update-po" which remove the strings from the .po files.
>=20
>> Oops, I thought that issues from my email client. OK, next time when
>> I send patch I will use MIME-PGP.
>=20
> Yeah, it's protecting the "-----BEGIN PGP SIGNED MESSAGE-----" header
> line, so it has to add "- " to all lines that begin with "-".  Using
> MIME-PGP means that we use the MIME message boundaries instead.
>=20
>>> In addition, for now, I'd like to keep the code which checks the
>>> remaining fragment fields in the inode and superblock since they act
>>> as a safety check to make sure the filesystem is sane and we don't
>>> have garbage there.  The checksum fields will obviate this need, but
>>> keeping the checks there for ext2/ext3 filesystems seem like a good
>>> idea.
>> My idea is:
>> 1) Modify names of related fields of superblock and inode. to avoid ot=
hers using these field in future.
>> 2) Keep checking code for the modified fields. to make source code rob=
ust.
>=20
> Comments in the header file is probably enough, I think.  Changing the
> names fields just causes a lot of code churn....
>=20
>>> Dropping the union is probably fine, since at this point it looks
>>> pretty clear that both the Hurd and Masix is dead.  But let's do the
>>> cleanups a little at a time, and I'd probably start with just removin=
g
>>> the cruft from the mke2fs options and man pages.
>> Sure, I agree with you :-)
>=20
> I did some checking, and it looks like Hurd is still using basic ext2.
> Some grad student did a ext3 driver for Hurd, but it's unstable and
> was apparently last touched in 2005 (the Ph.D. thesis was done in 2003
> iirc).  Sigh...
>=20
> Unfortunately, I did some checking and it looks like there are some
> crazy people that are still actively working on a Debian GNU/Hurd
> project.  So let's leave the Hurd stuff in for now.  There may be some
> issues where they will need to drop using ext2 for licensing reasons,
> but let's save this cleanup for later.  It doesn't cost us much to
> leave it in, after all.
>=20
Sure, I will only post a patch for removing masix. For hurd, let's wait a=
nd see :-)

> 					- Ted

Thanks for your comment :-)
Best regards.

--=20
Coly Li
SuSE PRC Labs


--------------enig42217DF51B1F99D253D0745C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGv4LPuTp8cyZ5lTERAphtAJ9JjRBtlsMIOP7OSDMICWfo7PkgHQCfQQMo
C2vUrQ5hqRnLs8yPBOy8bmo=
=0U/Q
-----END PGP SIGNATURE-----

--------------enig42217DF51B1F99D253D0745C--
