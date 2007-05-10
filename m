From: Eric <erpo41@gmail.com>
Subject: ext2/3/4 online defrag
Date: Wed, 09 May 2007 21:19:59 -0700
Message-ID: <1178770799.26695.11.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bJuOZ7RXDO4VuH/eb99R"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:54803 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbXEJEUC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 May 2007 00:20:02 -0400
Received: by wx-out-0506.google.com with SMTP id h31so412633wxd
        for <linux-ext4@vger.kernel.org>; Wed, 09 May 2007 21:20:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-bJuOZ7RXDO4VuH/eb99R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

This is my first post to the list. I want to add online defrag support
to ext2/3/4 just to scratch an itch.

I've searched the archives and googled around, and I've come to the
following conclusions:
*An offline defrag tool is available but dangerous.
*Some patches exist that provide preliminary support for online defrag
in the ext3 driver, but interest in improving/integrating these patches
is low.
*An implementation of an ext* filesystem driver can work with any
ext2/3/4 filesystem as long as it supports the necessary revision
(GOOD_OLD_REV or DYNAMIC_REV) and feature flags set in the filesystem.

Please let me know if any of my assumptions are incorrect.


Thanks,

Eric Anopolsky


--=-bJuOZ7RXDO4VuH/eb99R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGQp1ve2L37HVup3ARAqVZAJ9Mp48s60CqDxwb2xl0SQU1trRT6QCgpse4
yVjeVqcCyT9p0yJ7JTfHHdU=
=VvWw
-----END PGP SIGNATURE-----

--=-bJuOZ7RXDO4VuH/eb99R--
