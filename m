From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: fio test triggering bad data on ext4
Date: Mon, 21 Jun 2010 11:37:29 +0200
Message-ID: <201006211137.29311.frank.mehnert@sun.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart28402937.fjPaQcR13e
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:45611 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab0FUJiE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jun 2010 05:38:04 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-1-fe1.eu.sun.com [192.18.6.7] (may be forged))
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o5L9c00V010526
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jun 2010 09:38:02 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0L4C00G00YG3H800@fe-emea-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 21 Jun 2010 10:37:46 +0100 (BST)
Received: from vpn-129-150-124-114.germany.sun.com
 ([unknown] [129.150.124.114]) by fe-emea-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 with ESMTPSA id <0L4C00CYIYQKQO70@fe-emea-09.sun.com> for
 linux-ext4@vger.kernel.org; Mon, 21 Jun 2010 10:37:33 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--nextPart28402937.fjPaQcR13e
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I want like to add that we have a similar testcase which probably triggers
much faster than the testcase of Jens, see here:

  https://bugzilla.kernel.org/show_bug.cgi?id=3D16165

We believe that this bug is responsible for data corruption of VirtualBox
disk images located on an ext4 file system. Please let me know how we can
help you debugging this issue.

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert

Sitz der Gesellschaft:
Sun Microsystems GmbH, Sonnenallee 1, 85551 Kirchheim-Heimstetten
Amtsgericht M=FCnchen: HRB 161028
Gesch=E4ftsf=FChrer: J=FCrgen Kunz

--nextPart28402937.fjPaQcR13e
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkwfMtkACgkQ6z8pigLf3EeHSwCglTedxLk19+R4w2lxblIP64Fk
x08An1C6/GkTOIwx3hxJr2pL5c9RZ9O0
=yAmB
-----END PGP SIGNATURE-----

--nextPart28402937.fjPaQcR13e--
