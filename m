From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Possible ext3 corruption with 1K block size
Date: Wed, 15 Oct 2008 07:24:38 +0400
Message-ID: <200810150724.42180.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1438259.lRcpkbiL6Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753200AbYJODY5@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--nextPart1438259.lRcpkbiL6Y
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

There is long standing open bug report on Mandriva which is currently
beieved to have root cause in file system corruption. It shows itself
in RPM DB corruption (at least, there is no other known method to trigger
it). So far all reported cases happened on filesystem with 1K block size
and stopped when RPM DB was moved to FS with 4K block size.

There are also similar RH reports as well.

Here are references:

https://qa.mandriva.com/show_bug.cgi?id=3D32547

This one is rather long. Interesting bits are probably around

https://qa.mandriva.com/show_bug.cgi?id=3D32547#c177
https://qa.mandriva.com/show_bug.cgi?id=3D32547#c148 (many users reporting
dumpe2fs)

https://bugzilla.redhat.com/show_bug.cgi?id=3D230362
https://bugzilla.redhat.com/show_bug.cgi?id=3D375931
https://bugzilla.redhat.com/show_bug.cgi?id=3D305301

The Mandriva bugzilla also mentions this mail from Stephen Tweedie=20
http://lkml.org/lkml/2007/9/18/232

which indicates some issues with 1K blocks, but according to last comment:
https://qa.mandriva.com/show_bug.cgi?id=3D32547#c300

it is still present in 2.6.27 (at least was present on -rc6)

There was a kernel bug report http://bugzilla.kernel.org/show_bug.cgi?id=3D=
11564,
but in this case it was identified as hardware issue.

--nextPart1438259.lRcpkbiL6Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj1YncACgkQR6LMutpd94yKZQCfa1EfoFpFlUCfkND+fIF8k0+c
dooAn1R5yzAuphJgowlnuh3M2WSrc696
=u7/1
-----END PGP SIGNATURE-----

--nextPart1438259.lRcpkbiL6Y--
