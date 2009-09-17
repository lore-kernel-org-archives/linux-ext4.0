From: Jens Kubieziel <maillist@kubieziel.de>
Subject: git svn clone freezes the pc on ext4
Date: Thu, 17 Sep 2009 15:13:56 +0200
Message-ID: <20090917131356.GG9393@kubieziel.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from jengate.thur.de ([217.17.193.190]:46100 "EHLO jengate.thur.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZIQNVc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 09:21:32 -0400
Received: from tacop (p5B2B4D17.dip.t-dialin.net [91.43.77.23])
	(authenticated bits=0)
	by jengate.thur.de (8.14.3/8.14.1) with ESMTP id n8HDDx9c030541
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 15:14:07 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I recently changed my /home-partition to ext4 and wanted to clone a SVN
repository. After calling "git svn clone https://...", git began
fetching old revisions and at every try the complete pc freezes. It
doesn't respond to any keyboard presses nor to SysRq. I tried the same
command on different filesystems (ext3, reiser) and with different git
versions. Only git on ext4 causes this freeze.

The system logs have no uncommon messages. I found only:
EXT4 FS on sda3, internal journal on sda3:8
EXT4-fs: deleayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem with ordered data mode
Linux version is 2.6.28-15 (default installation from Ubuntu jaunty).

How can I find out more about this freeze? Is maybe something known what
causes this? Thanks for any hints.

--=20
Jens Kubieziel                                   http://www.kubieziel.de

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKsjYUVm02LO4Jd+gRAvJBAKCEqVyR+197rKoj3Slp0051hQxragCghTi9
OXuqm8q11Ew+v+7tCsER1l4=
=tv1y
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
