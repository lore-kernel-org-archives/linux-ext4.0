From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] e2fsprogs: remove fragment support (V3)
Date: Mon, 13 Aug 2007 00:33:26 +0800
Message-ID: <46BF3656.4010108@suse.de>
References: <46BC9CC3.9090005@suse.de> <20070812033129.GB21719@thunk.org>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig44E86E98373E2B5C994CE883"
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37089 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbXHLQcz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Aug 2007 12:32:55 -0400
In-Reply-To: <20070812033129.GB21719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig44E86E98373E2B5C994CE883
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Theodore,

Another question of mine is for the .po files: Once I modify a string fro=
m _(""), should I mofify
all the corresponded strings from all .po files ?

Theodore Tso wrote:
> On Sat, Aug 11, 2007 at 01:13:39AM +0800, Coly Li wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>=20
> If you're going to use PGP signatures, please use the MIME-PGP that
> doesn't cause annoying quoting to take place, i.e.:
>=20
>> - -   switch (os) {
>> - -       case EXT2_OS_HURD:
>> - -           frag =3D inode->osd2.hurd2.h_i_frag;
>=20
Oops, I thought that issues from my email client. OK, next time when I se=
nd patch I will use MIME-PGP.


> Also, please take a look at my recent patch series to remove support
> for PPC big-endian byte-swapped filesystems.  Separate patches which
> makes it obvious what is being removed and makes it easy to review are
> much appreciated.
>=20

Sure, I agree with you.


> In addition, for now, I'd like to keep the code which checks the
> remaining fragment fields in the inode and superblock since they act
> as a safety check to make sure the filesystem is sane and we don't
> have garbage there.  The checksum fields will obviate this need, but
> keeping the checks there for ext2/ext3 filesystems seem like a good
> idea.

My idea is:
1) Modify names of related fields of superblock and inode. to avoid other=
s using these field in future.
2) Keep checking code for the modified fields. to make source code robust=
=2E

>=20
> Dropping the union is probably fine, since at this point it looks
> pretty clear that both the Hurd and Masix is dead.  But let's do the
> cleanups a little at a time, and I'd probably start with just removing
> the cruft from the mke2fs options and man pages.
>=20

Sure, I agree with you :-)

> Regards,
>=20
>     	       	   	  	      - Ted

--=20
Coly Li
SuSE PRC Labs


--------------enig44E86E98373E2B5C994CE883
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGvzZauTp8cyZ5lTERApYSAJ0e/GmQv4RiL4Hu+utFUo95dkhUbwCgmnqE
PxcwcL0PZJt/EfaqC2JzY9I=
=/cjd
-----END PGP SIGNATURE-----

--------------enig44E86E98373E2B5C994CE883--
