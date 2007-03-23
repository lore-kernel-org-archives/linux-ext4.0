From: Timo Sirainen <tss@iki.fi>
Subject: Re: 2.6.20 ext3 rename() returns success but doesn't unlink the
	source
Date: Sat, 24 Mar 2007 01:18:33 +0200
Message-ID: <1174691913.10004.71.camel@hurina>
References: <1174670127.10004.14.camel@hurina>  <460453B3.2020304@yahoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5b2pW+9gpm5B8j1/4yKl"
Cc: linux-ext4@vger.kernel.org
To: Guillaume Chazarain <guichaz@yahoo.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dovecot.org ([213.157.71.38]:48883 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992613AbXCWXSf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2007 19:18:35 -0400
In-Reply-To: <460453B3.2020304@yahoo.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-5b2pW+9gpm5B8j1/4yKl
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-23 at 23:24 +0100, Guillaume Chazarain wrote:
> Timo Sirainen a =E9crit :
>=20
> > 	rename("/mnt/Maildir/.Trash/new/1174635781.P25986Q0M341350.hurina",
> > 	       "/mnt/Maildir/.Trash/cur/1174635781.P25986Q0M341350.hurina:2,")=
;
>=20
> $ ls -li /mnt/Maildir/.Trash/new/1174635781.P25986Q0M341350.hurina /mnt/M=
aildir/.Trash/cur/1174635781.P25986Q0M341350.hurina:2,
> 122481 -rw------- 2 1000 1000 3091 Mar 23 08:43 /mnt/Maildir/.Trash/cur/1=
174635781.P25986Q0M341350.hurina:2,
> 122481 -rw------- 2 1000 1000 3091 Mar 23 08:43 /mnt/Maildir/.Trash/new/1=
174635781.P25986Q0M341350.hurina
>=20
> All your files in the list are hard linked.
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dbl=
ob;f=3Dfs/namei.c;h=3Dee60cc4d3453209723d6f70982e7083d7cb39477;hb=3DHEAD#l2=
447
> seems to handle your case as you see it:
> if (old_dentry->d_inode =3D=3D new_dentry->d_inode)
> 	return 0;

Hmm. Oh. So this is this intentional? First I ever heard of it, and also
goes against my logic. I'll go complain to man pages people then. This
will make my error handling difficult..


--=-5b2pW+9gpm5B8j1/4yKl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGBGBJyUhSUUBViskRAsOOAJ0dY52+WelEt5ggOFCuI4exJ26yxgCcCJqc
W74X5T7+tw/jjgQrOf1dbY0=
=9gh+
-----END PGP SIGNATURE-----

--=-5b2pW+9gpm5B8j1/4yKl--
