From: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: Re: [PATCH] ext4: in ext4_dirty_inode() current_handle only needed for debugging
Date: Sat, 3 Oct 2009 00:36:21 +0200
Message-ID: <200910030036.37640.tobias.doerffel@gmail.com>
References: <1254522048-15046-1-git-send-email-tobias.doerffel@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1520648.eQf7IxDlfN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:57496 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZJBXCS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 19:02:18 -0400
Received: from vpnclient-194-145.hrz.tu-chemnitz.de ([134.109.194.145] helo=nc10.localnet)
	by jack.hrz.tu-chemnitz.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <doto@hrz.tu-chemnitz.de>)
	id 1Mtqjy-0002gv-60
	for linux-ext4@vger.kernel.org; Sat, 03 Oct 2009 00:36:42 +0200
In-Reply-To: <1254522048-15046-1-git-send-email-tobias.doerffel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1520648.eQf7IxDlfN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Am Samstag, 3. Oktober 2009 00:20:48 schrieb Tobias Doerffel:
> As of d3d1faf6a74496ea4435fd057c6a2cad49f3e523 in ext4_dirty_inode()
> the current_handle variable is only used for debugging now. Therefore
> compiling fs/ext4/inode.c without JBD_DEBUG set will result in a
> compiler warning:
Sorry for the noise, didn't look at the ML archive before.. looks like Curt=
=20
already handles this.

Regards,
Tobias

--nextPart1520648.eQf7IxDlfN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrGgGUACgkQHsjdpw2OaafhUwCgyTxErkGeqX/ZpSmDouS32e1r
SaIAn0M5R/l/w4fG3TIhk/ROIHcer1/2
=0TFj
-----END PGP SIGNATURE-----

--nextPart1520648.eQf7IxDlfN--
