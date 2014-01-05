From: Oleksij Rempel <linux@rempel-privat.de>
Subject: maintain badblocks list on the fly
Date: Sun, 05 Jan 2014 11:02:49 +0100
Message-ID: <52C92DC9.7030806@rempel-privat.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W7wqoNKL7h9SaE1KojOHKIru2bAIMCvn5"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54539 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaAEKDF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 05:03:05 -0500
Received: from [192.168.1.221] ([93.218.64.233]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MdrK9-1VlFOc1stx-00PeI5 for
 <linux-ext4@vger.kernel.org>; Sun, 05 Jan 2014 11:03:03 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W7wqoNKL7h9SaE1KojOHKIru2bAIMCvn5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello all,

after some googling i didn't found answer to my question, so i set it
directly here: do it makes sense and is it possible to maintain bad
block list of ext4 on fly? I mean, if ext4 get error from, for example
from ata subsystem, and it will mark block as bad or may be better as
"probably bad"?

Since ext4 do anyway journal recovery, it can do some sort of
auto-repair too.

The reason why i ask is a story of laptop which i got for repair. After
update, system failed to boot. One of system relevant files was placed
on badblock which was already detected by kernel one month(!) before (it
can be found in syslog). After reboot, system was unusable for average
user. It is single bad block for 500GB, so it is not the case for
replacement.

In case if ext4 would maintain bad blocks on the fly, it would keep the
system working. Hi-level tools should be responsible to notify user
about FS and device degradation.

PS: thanks for metadata_csum :)
--=20
Regards,
Oleksij


--W7wqoNKL7h9SaE1KojOHKIru2bAIMCvn5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLJLdYACgkQHwImuRkmbWkHMQD/UzzII4Vn7mumPyH4Qn4GiWTa
tOQ5kiyVZqHK8PuCVB0A/jykyiZD9KBRuTFql2cCn8vBKFkQ3t7wNu1rS73VC0/Q
=6/vL
-----END PGP SIGNATURE-----

--W7wqoNKL7h9SaE1KojOHKIru2bAIMCvn5--
