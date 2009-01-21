From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: ext4 fails on ext2 filesystems
Date: Wed, 21 Jan 2009 19:45:17 +0100
Message-ID: <20090121184221.GA2063@alea.gnuu.de>
References: <20090118013516.GA4876@alea.gnuu.de> <20090118023841.GD25943@mit.edu> <20090118100458.GA22064@alea.gnuu.de> <20090120145100.GD10037@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:2016 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZAUSqb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jan 2009 13:46:31 -0500
Content-Disposition: inline
In-Reply-To: <20090120145100.GD10037@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

Theodore Tso schrieb am Tue 20. Jan, 09:51 (-0500):
> On Sun, Jan 18, 2009 at 11:04:59AM +0100, J=F6rg Sommer wrote:
> > > > [  203.082300] EXT4 FS on hda3, no journal
> > > > [  205.746713] EXT4-fs error (device hda3): ext4_free_data: circula=
r indirect block detected, inode=3D165056, block=3D184476
> > > >=20
>=20
> Hi, this patch should fix your problem.

Yes, this patch fixes the problem. Thanks.

> commit bf3baec2b4529dcf47ee422a48b8c0e83df7f0a0
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Jan 20 09:50:19 2009 -0500
>=20
>     ext4: Fix ext4_free_blocks() w/o a journal when files have indirect b=
locks
>    =20
>     When trying to unlink a file with indirect blocks on a filesystem
>     without a journal, the "circular indirect block" sanity test was
>     getting falsely triggered.
>    =20
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Tested-by: J=F6rg Sommer <joerg@alea.gnuu.de>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 49484ba..b4386da 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3622,7 +3622,7 @@ static void ext4_free_data(handle_t *handle, struct=
 inode *inode,
>  		 * block pointed to itself, it would have been detached when
>  		 * the block was cleared. Check for this instead of OOPSing.
>  		 */
> -		if (bh2jh(this_bh))
> +		if ((EXT4_JOURNAL(inode) =3D=3D NULL) || bh2jh(this_bh))
>  			ext4_handle_dirty_metadata(handle, inode, this_bh);
>  		else
>  			ext4_error(inode->i_sb, __func__,
>=20

Bye, J=F6rg.
--=20
Freiheit hei=DFt, die Wahl zu haben, wessen Sklave man ist.

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl3bT0ACgkQwe0mZwH1VIBNRACgp+PpLvmO4vr5CZoODrs53wkb
rjcAn3VjUWc/JUeSl61F7WTswcpaCuqY
=AcLY
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
