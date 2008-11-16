From: Andreas Schultz <aschultz@warp10.net>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Sun, 16 Nov 2008 13:11:23 +0100
Message-ID: <200811161311.29107.aschultz@warp10.net>
References: <200811141349.39160.aschultz@warp10.net> <20081114210612.GZ16005@webber.adilger.int> <20081115055017.GO25117@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1836184.P36K7NFSig";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tpip.net ([213.187.84.201]:51767 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYKPMLm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Nov 2008 07:11:42 -0500
In-Reply-To: <20081115055017.GO25117@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1836184.P36K7NFSig
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Saturday 15 November 2008 06:50:17 Theodore Tso wrote:

> Fixing both of these should remove most of the user-space time that's
> being burned by tune2fs -I 256.  There is still some CPU burned by the
> undo file, and indeed we can probably speed this up some more by
> omitting creating an undo entry when we're copying a data block to a
> previously unused block.  But hopefully this should be enough to speed
> up "tune2fs -I 256" for most people.

it does speed up things, but it is still quite slow. I tried it on a 250GB =
partition which is about 86% filled:

root@ws-aschultz:~# df -i /usr/src2/
=46ilesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb1            30523392 1401574 29121818    5% /usr/src2
root@ws-aschultz:~# df /usr/src2/
=46ilesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1            240308484 196091320  32010176  86% /usr/src2
root@ws-aschultz:~# umount /usr/src2
root@ws-aschultz:~# time tune2fs -I 256 /dev/sdb1
tune2fs 1.41.3 (12-Oct-2008)
Setting inode size 256

real    64m31.189s
user    43m46.708s
sys     1m50.627s

64min for 250GB seems to be to much for the average user.

=46rom watching the disc activity and the output of 'top', it seems that th=
e operation periodically consumes 100%CPU for extended periods without any =
disc activity, followed by a brief period of about 20%CPU load and light di=
sc activity.

Andreas

--nextPart1836184.P36K7NFSig
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkgDewACgkQ9wB/4yf/y7dAJACfYQZiI54CGYcuquYHBwftFBl0
gXwAoN0/HJjTZHvzzDQcCtcJUoDYSI4D
=aIV+
-----END PGP SIGNATURE-----

--nextPart1836184.P36K7NFSig--
