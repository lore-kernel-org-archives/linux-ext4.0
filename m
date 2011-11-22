From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fsfuzzer: exabyte file sizes
Date: Tue, 22 Nov 2011 13:10:50 +0300
Message-ID: <20111122101050.GK5832@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2pR2RtFp0tAjF3C"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:49177 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1KVKJW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Nov 2011 05:09:22 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Switch-3.4.4/Switch-3.4.4) with ESMTP id pAMA9LZX006984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Nov 2011 10:09:22 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id pAMA9KGd012598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Nov 2011 10:09:21 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id pAMA9FSh018333
	for <linux-ext4@vger.kernel.org>; Tue, 22 Nov 2011 04:09:15 -0600
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--J2pR2RtFp0tAjF3C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm messing with fsfuzzer and it created a filesystem with a huge
exabyte file which is larger than ext4 supports.

root@elgon:/tmp# mount -o loop ext4_exabyte_file.img mnt/
root@elgon:/tmp# ls -l mnt/
ls: cannot access mnt/config.h: Input/output error
ls: cannot access mnt/configure: Input/output error
total 114898965103020
-rw-r--r--     1 root root              267551 Nov 21 18:03 aclocal.m4
-rw-r--r--     1 root root                 216 Nov 21 18:03 AUTHORS
-rw-r--r--     1 root root            13893752 Nov 21 18:03 ChangeLog
-rw-r--r-- 10753 root  175               29713 Nov 21 18:03 c?nfig.log
-rwxr-xr-x     1 root root               44878 Nov 21 18:03 config.guess
-?????????     ? ?    ?                      ?            ? config.h
-rw-r--r--     1 root root                1882 Nov 21 18:03 config.h.i?~
-rw-r--r--     1 root root 9583660007044417438 Nov 21 18:03 config.h.in
-rwxr-xr-x     1 root root               33400 Nov 21 18:03 config.status
-rwxr-xr-x     1 root root               33387 Nov 21 18:03 config.sub
-?????????     ? ?    ?                      ?            ? configure
drwx------     2 root root               16384 Nov 21 18:03 lost+found
root@elgon:/tmp#=20

I've uploaded the corrupted filesystem image to:
http://smatch.sf.net/upload/ext4_exabyte_file.img

Not a huge deal, but I thought I'd report it anyway.

regards,
dan carpenter

--J2pR2RtFp0tAjF3C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOy3UpAAoJEOnZkXI/YHqRUeMP/3Ia1ewGi/QfWyYFDBe615Vy
pa9dBFy1ihMxE3AQLxsohIYA5AIN0Gdshz3Pe/ALYBn106YidJMtLvTNqvMLNl8J
VgbvSM5VpH73BfaPtHZ9CAFRKo6nmPNvlXjf3WVB3LRL1sbl4vSO2yrMnXWKQyPQ
DVSmwM2WlWmswu3QwvLIgjmrZDxmClOHXX/9uMFw4HeTw62ti0oB9Eqz4adKryz+
HSFfSj1WVQEQwN5vk3OldXTgATv9hMybBR5/lxXJwBO3mpWJrUABnGIy4z4jJVR/
nEyqMf5ZrAXlERIUsKhvKeE6pS1+K+4WL3cvxYzvfkGObjgFN3Qm6jAuF3rCBP+9
4QMUIaLPSDMba6/Ig3aG9k6lU0aER/8SDpgIsS4ME1Jqxyq1v8nT8/cvYp5iMqlK
+IhL+hCVktHuwYXwPG9tKrGL30p+YlRI1kGbftSdE/ouCZjbDicyRLF8CrfPhtY+
VOxHRs+V2LsVeDU5QIfTuOQPWJHpj3zbwRMNPypQ1X5zF9wF6InDv7aWollbDhC3
9vYIKu+u3qb507+04/H6WhqAKXjDJkTxCPoa4usv9neMcAAkRcVFR20Y57s5ZST3
2YFE7MkMQnB4RF0PMMihiATeo5RWYDCQ57D5y189B2e/87bL3D1S3IjmlVRIDFiD
9st3AdyTRkhFV/2ttiF+
=3Drn
-----END PGP SIGNATURE-----

--J2pR2RtFp0tAjF3C--
