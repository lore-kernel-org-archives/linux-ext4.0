From: "Michael B. Trausch" <mike@trausch.us>
Subject: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Sat, 1 Nov 2008 15:10:02 -0400
Message-ID: <20081101151002.4ed9be99@zest>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LOi8.4M=k8WFEX4fvu+6H_H";
 protocol="application/pgp-signature"; micalg=PGP-RIPEMD160
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:24323 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYKATKI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Nov 2008 15:10:08 -0400
Received: by qw-out-2122.google.com with SMTP id 3so802232qwe.37
        for <linux-ext4@vger.kernel.org>; Sat, 01 Nov 2008 12:10:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/LOi8.4M=k8WFEX4fvu+6H_H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I have a drive (a 250 GB external USB hard drive) which I wanted to
convert to 256 byte inodes and start using as an ext4 drive (currently
I use it as ext3).  However, I started the tune2fs operation on 01 Nov
2008 02:27:34 -0400, and it is currently nearly 13 hours later, and the
operation is _still_ going at 100% of one core and operating on the
drive.

Three questions:

  * Is this normal?
  * How long can I expect this process to continue?
  * Can it be (safely) interrupted if it will continue for a long time?

I converted my home directory to ext4 without issue and so I (stupidly,
I admit) did not take a backup of this 250 GB drive's contents before I
started the conversion process.  Oops.  Lesson learned.  My thinking at
this point is that it would take _far_ less time to interrupt, backup,
and just use mkfs.ext4 on the drive and then restore (about 2 hours
instead of an unknown quantity which is already nearing 13 hours).

	Thanks,
	Mike Trausch

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/LOi8.4M=k8WFEX4fvu+6H_H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkkMqYoACgkQ0kE/IBnFmjCpZACfS4CdNheBPu/H2Hi5E57u43+B
7+0AnRM3S7YLa2p77EwsvQQoXNyp4o1/
=uYnI
-----END PGP SIGNATURE-----

--Sig_/LOi8.4M=k8WFEX4fvu+6H_H--
