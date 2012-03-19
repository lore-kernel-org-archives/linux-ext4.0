From: Mike Frysinger <vapier@gentoo.org>
Subject: umode_t breakage in exported kernel headers
Date: Mon, 19 Mar 2012 16:01:53 -0400
Message-ID: <201203191601.55668.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3788957.zYGPhXnxX6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@zeniv.linux.org.uk>,
	Duane Griffin <duaneg@dghda.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48155 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab2CSUBz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 16:01:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart3788957.zYGPhXnxX6
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

commit 0583fcc96bb117763c0fa74c123573c0112dec65 moved umode_t out of the=20
exported headers space (via the arches' asm/types.h) and into __KERNEL__=20
specific linux/types.h.  this breaks the exported linux/ext2_fs.h=20
ext2_mask_flags function which uses that type.  that func appears to be the=
=20
only one exported that utilizes umode_t.

should ext2_mask_flags be updated to take a __kernel_mode_t as its first ar=
g ?
=2Dmike

--nextPart3788957.zYGPhXnxX6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPZ5CzAAoJEEFjO5/oN/WBxssQAK6qlMAEaB1rIkCHMMTzFPFm
7TO/Wk3mtKj00h0JhXijE+7jpZllh8QG89ebs8Vx+fwmdWarF+jvmxEgOQ1n6uWN
S/vAnzXCqpCQEz/2At4mhSAfZgHtliD1OEPSVil44Mh+4QVU0ksERA1tc6g3Tvng
BvR2wNx+cNWYaKB5rHLWo3vALf6RN7y+GGaZbuT5wjsulHk22mV5Mj7Arh4sknXk
JfMwbHVfKXqvOCU6VVin8hLyJYT0StWXbJh/9uv+84oRr/iBGQScWe8XOfUpjcya
xgpRRAeKABUkt52nwueZLd1tg9SNitStK1AsGiQfrAH+02JtaIlBHAVv84RO/7ZG
sFXPWcJ1oJV6f+bVvn0fYZABCymrV6Hw6OxOH7J9Wyxit9gd+4vQWsnfbcDU69XT
3WqACNlmUehUjeixWJm9wSHk4gK9XvsraCU+7iGtYjD5BNsSfBfZRqaJcM5ocIYe
AWbPsTzJpAahnrmMu0srK+mYO/Q1ECUdx9pqS9bdUUxuud6H0dYAOqLb06mGoax1
wS3+mjPErlWoA1F36dwrSAY3tHFEwPCwq7637iTCRuWwPltiOwxNMWLkL/0T7YMi
ge11b9hncEAFeBU7bRYv+OuRVt2hD6yme2Y27Su3e1gergERCxrE8SD3MG8KK5os
6+nT4Em6FDrmDv6bj6H2
=QHvj
-----END PGP SIGNATURE-----

--nextPart3788957.zYGPhXnxX6--
