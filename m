From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: libcom_err DSO version bump needed for 1.42?
Date: Wed, 15 Aug 2012 17:48:12 -0400
Message-ID: <k0h5eu$f6u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2A21E1EDBDFBED850110FBCB"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53128 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2HOVuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Aug 2012 17:50:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1T1lTY-0002iM-HT
	for linux-ext4@vger.kernel.org; Wed, 15 Aug 2012 23:50:04 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 15 Aug 2012 23:50:04 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 15 Aug 2012 23:50:04 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2A21E1EDBDFBED850110FBCB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed when trying to upgrade my e2fsprogs RPM set from a 1.41.12ish
release to a 1.42.3ish release only e2fsprogs and e2fsprogs-libs got
upgraded and libcom_err didn't get upgraded despite there being ABI
differences between 1.41.12 and 1.42.3.  This results in the following
type of error:

# e2fsck
e2fsck: symbol lookup error: e2fsck: undefined symbol: set_com_err_gettex=
t
# mke2fs=20
mke2fs: symbol lookup error: mke2fs: undefined symbol: set_com_err_gettex=
t

This appears to be due to the addition of set_com_err_gettext()  (in
4259052093da329907e255b11bf3e799872828c7) during the 1.42 development
cycle.

Since this addition introduces an ABI incompatibility in libcom_err,
isn't the process supposed to be to increase the SO's version so that
the tools find the proper version of the library and also so that it
gets upgraded accordingly by RPM with it's autoprovides/requires bits?

Cheers,
b.


--------------enig2A21E1EDBDFBED850110FBCB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAsGR0ACgkQl3EQlGLyuXD/wACdEQTuhmfeO1dmHQx37DoZJQzN
zFoAnRP83b1pQ9kDohnWwRfYX21ad6wh
=esan
-----END PGP SIGNATURE-----

--------------enig2A21E1EDBDFBED850110FBCB--

