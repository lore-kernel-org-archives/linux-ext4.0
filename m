From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Sat, 24 Mar 2012 13:59:32 -0400
Message-ID: <201203241359.36034.vapier@gentoo.org>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de> <CAMjpGUdnisfawUNThOu_+kbH54SWXCf6PhZwyWrV=B8SNjMRNg@mail.gmail.com> <20120324083756.GJ6589@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1592667.tP36DyLj1F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:49948 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab2CXR7g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Mar 2012 13:59:36 -0400
In-Reply-To: <20120324083756.GJ6589@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1592667.tP36DyLj1F
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Saturday 24 March 2012 04:37:56 Al Viro wrote:
> On Sat, Mar 24, 2012 at 02:50:38AM -0400, Mike Frysinger wrote:
> > > and that's it. ??blackfin and do_mounts_rd are doing the same thing
> > > (blackfin - buggy, AFAICS).
> >=20
> > buggy how ?  they're not exactly the same as the Blackfin code is
> > setting things up for the uClinux MTD map.  it isn't parsing the
> > filesystem itself (ignoring the size extraction from the superblock).
>=20
> Compare and you'll see...  Block size on ext2 may be bigger than 1Kb;
> ->s_log_block_size gives the shift (1Kb -> 0, 2Kb -> 1, etc.)  Offset
> 0x18 in superblock, __le32...

fair enough.  the users of the Blackfin code should generally be OK though =
due=20
to the constrained inputs and runtime systems.

> Anyway, I've pushed that into vfs.git#master along with other minor stuff
> right now; the last 5 commits in there are handling of ext2 and ext3
> headers, starting with "ext2: No longer export ext2_fs.h to user space" by
> Thierry Reding, with the next 3 after it doing the move and trimming...
> Should propagate to git.kernel.org in a few.

looks good to me
Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike

--nextPart1592667.tP36DyLj1F
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPbguHAAoJEEFjO5/oN/WBvEkP/39zMqms+pIqt5FRtk62yDAG
nQkhm+XRDbJ76NUiZwW+Vp9k9oyJqVPTBg9Jpfm3CCm/StDPinzQlvyBIIlH1Wv3
cQChrwQ7QncMXD7pDgyycFLjz3BG2SNAvUDQwtiDpBaOsHDaqDK4fC40tliBwInK
eYKPSrv5SyQIvbK3wctOthP+aTYFkCF4ltqBrZoDMdJAUZCfDUIR4iUsTXe8+hPJ
SWmMFi1jRAR0/M1sDYCIJir+U4cU+AAxsW6UBAb7fncsEVQjSze/NMWR9nV6JeDB
qI7lxOsHrzYQuwk/1KPko8u9GC33dGvKgUZJUo0ApCVZTcdIu2agXTHbLF9EESN8
gykDMezEESNX4zx0Wbgg7shrkPomzRXqtkk4LBSZQ0RAf/YLMYAnNhkGqRYH8ogM
hplw3tdBfxE+ytFW77vJIcP4OODVrkQKD/5cfloVlSUx5d5Z/A74kM0DPgTuZhrs
yeltrB9NHy9cXTn+//Z8GBML3CtoLdi5XohubUn+Y0BLrGQF/Smz0GsS1Kmo4Km5
HRDnbrIvb6KoKoD7HVNtMX5SZtNh5cSq0XvAvR8qk+7mrobJaQVFtkq8Lb3othql
Bs/VLtN7JirnNptrPgW2+jHac7/9+WUkRqoBSLbRHxuFv8b2cMg12pMMeCeEOGJe
i9RhgIzD0cPsjNVjrPd8
=3eub
-----END PGP SIGNATURE-----

--nextPart1592667.tP36DyLj1F--
