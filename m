From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: inline_data,metadata_csum  a lot of bad csum for directories
Date: Mon, 01 Dec 2014 17:09:23 +0300
Message-ID: <877fybcvho.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Theodore Ts'o <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:41640 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaLAOJw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2014 09:09:52 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so13998355wgh.26
        for <linux-ext4@vger.kernel.org>; Mon, 01 Dec 2014 06:09:51 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Ted can you please clarify what is status of inline_data patchset.
I've enabled inline_data testing in my test environment
I use xfstest-bld for this purpose, but most test generates a lot of incorr=
ect
inode's csum for directories(almost any test which makes/rm
directories). What I'm doing wrong? Are where any important fix I'm missing=
?=20
Please post your test matrix

My config:
e2fsprogs git commit: g210baa5
ext4.git commit: recent tytso/dev ca83cc75a16f67
./kvm-xfstests -c inline generic/011  generic/013
generic/013       [13:51:44]
[  368.507266] EXT4-fs error (device vdd): ext4_iget:3918: inode #294: comm=
 rm: checksum invalid
[  368.511098] EXT4-fs error (device vdd): ext4_iget:3918: inode #294: comm=
 rm: checksum invalid
[  369.098863] EXT4-fs error (device vdd): ext4_iget:3918: inode #2108:comm=
 rm: checksum invalid

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUfHaUAAoJELhyPTmIL6kBgVsH/2LBXKSYVxN/KcMvCAv+z1co
r2Xn+/tTgamPKYjBvcSe7VxJ/qyJxe5q2zPI26T52jp6wOq4iVAhPOYuONUGZ+X3
4tchdyQAJiKfgY6m6cReidCAWWAdA6XdVnnOGjvl11VZuIc7Rn4Fg4ibhC0LfPIJ
ybe73gispdpmHi+hywWLBg1VGfxHAPUHsF9cczNRVdeqDK9iNXYjBzEsgS6iXbjh
N1Ay7hMS1OfTy7d+mX35zuHA1gzWOnMvQa6Fnprt72izwC26xCzV4tdlpYYkWDhA
knzgbrGjghqRCmzFEtn3xc1vr5NFh3pqiZfqPRfPB6RsVpvK4yxdTT/H3wkwP7c=
=9d99
-----END PGP SIGNATURE-----
--=-=-=--
