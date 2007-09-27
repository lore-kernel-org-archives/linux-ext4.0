From: Marco Minutoli <mminutoli@gmail.com>
Subject: xattr index
Date: Thu, 27 Sep 2007 19:33:14 +0200
Message-ID: <20070927193314.06594648@legolas.homenet>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_8BpaQZSdxtvX2V8EKIchGZl;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:7642 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbXI0RdA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2007 13:33:00 -0400
Received: by nf-out-0910.google.com with SMTP id g13so2282094nfb
        for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 10:32:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_8BpaQZSdxtvX2V8EKIchGZl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I am a student and for my graduation thesis I am working on
filesystems. A part of the system that I have to implement is an index
of extended attributes in kernel space and every functions needed to
interact with indexes.

I want to group indexes in a totally hidden(to the user) directory. For
this purpose I need to modify the FS superblock in order to add
a reference to the index-directory where every index is stored like
regular files in the rest of the FS. In this way we could have the
possibility to submit queries about xattrs to the FS like BFS does in
haiku.

What do you think about this possible functionality?
Critics/suggestions are very appreciated.

Thank you in advice.

Cheers,
Marco

--=20
Marco Minutoli
ICQ: 316621654
MSN: tradewind(at)email(dot)it
Skype: mminutoli
GPG-Key: 0x36AD4977

--Sig_8BpaQZSdxtvX2V8EKIchGZl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG++laWFngjDatSXcRApM8AJ9rfUb7ba+R2tgQBvDS3dcBHdac2gCcDcmG
q5EzdNk6JX5FxJl+G4qEoN0=
=fQnj
-----END PGP SIGNATURE-----

--Sig_8BpaQZSdxtvX2V8EKIchGZl--
