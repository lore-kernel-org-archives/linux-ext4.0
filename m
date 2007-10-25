From: Eric <erpo41@gmail.com>
Subject: Re: User permissions or UID/GIDs for portable disks?
Date: Wed, 24 Oct 2007 19:38:35 -0700
Message-ID: <1193279915.25351.18.camel@eric-laptop>
References: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sc1I45rksxrbySxenV4X"
Cc: linux-ext4@vger.kernel.org
To: Bram Neijt <bneijt@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:16686 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXJYCic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 22:38:32 -0400
Received: by rv-out-0910.google.com with SMTP id k20so347394rvb
        for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 19:38:31 -0700 (PDT)
In-Reply-To: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-sc1I45rksxrbySxenV4X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 20:10 +0200, Bram Neijt wrote:
> One of the best solutions I can come up with is if the filesystem
> would allow for a switch that would help ignore these permissions as
> part of the filesystem.

Ignoring file permissions on removable, user-supplied media sounds like
something that ought to be done above the level of individual
filesystems, just like how we ignore device files and suid/sgid files in
certain cases. Maybe this is something that ought to be one level up
from the ext2/3/4 filesystem driver?

In any case, this raises interesting questions. If we ignore permissions
on removable media, then anyone logged into your work computer (to which
you do not have root access) will be able to muck about with your files.
Is that something you want?

Cheers,

Eric


--=-sc1I45rksxrbySxenV4X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHIAGre2L37HVup3ARAgOKAKCuEBLzc2d15Fsfm9jjkdiwz8NBswCg7UI+
e95RnsrPk4+xjfudm/GPRUk=
=+vDq
-----END PGP SIGNATURE-----

--=-sc1I45rksxrbySxenV4X--
