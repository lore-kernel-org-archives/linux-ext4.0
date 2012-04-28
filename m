From: Sami Liedes <sami.liedes@iki.fi>
Subject: [corrected subject] unable to handle kernel paging request [was: Re:
 Intentionally corrupted fs: "kernel BUG at fs/jbd2/transaction.c:161!"]
Date: Sat, 28 Apr 2012 03:34:45 +0300
Message-ID: <20120428003445.GB20648@sli.dy.fi>
References: <20120428003052.GA20648@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:45393 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab2D1Aev (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2012 20:34:51 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id q3S0Yo7I022569
	for <linux-ext4@vger.kernel.org>; Sat, 28 Apr 2012 03:34:50 +0300
Received: from smtp-3.hut.fi ([130.233.228.93])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 07023-514 for <linux-ext4@vger.kernel.org>;
 Sat, 28 Apr 2012 03:34:49 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id q3S0YjaJ022561
	for <linux-ext4@vger.kernel.org>; Sat, 28 Apr 2012 03:34:45 +0300
Content-Disposition: inline
In-Reply-To: <20120428003052.GA20648@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 28, 2012 at 03:30:52AM +0300, Sami Liedes wrote:
> The 10 MiB ext4 image available at
[...]

Sorry for the confusion; the subject of the quoted mail was wrong and
actually pertains to another bug report that will follow shortly. The
actual bug in this report is:

> BUG: unable to handle kernel paging request at fffffffffffffff8

	Sami Liedes

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPmzskAAoJEKLT589SE0a0lj0P/2Hqj5wjSx7h1N/Qcl7J+Tng
n1KfM+EAomnY63LKr25fzt8kvYN0rxRYg/1bjl+h6GgICgvDTBHY3OIxbI56e4Ad
xW+BhptQ7i3oYYgxxfp5f4h5wF7As8/wq+f3hSTxuhUmiuVS5DUvcW0t0u34tiCz
ok2u/5aCTMtDpcEyxrvjDDjZERq8oOyacPU+bbpA0xDEV3W/rIeBV/YRBU3JIqjD
FYdKQ2TK2ot3wtwwapF2OJ/j/8e5PBoKvpgHV6whX9lu0P3ld81jhvdKljNTIeI0
6XV2iUEgkjPZf/ytS4pEuQYUzmnXD94PTfc2Q4UV9pngph427OYxSrYUAgHqHbc0
DpDkX4F2O4lh8vWG6eawp7/nN/xTLm89Bbv2yzIGl0Am7cPuXvGx0aXgywt3E2mF
3XNXVB0IbxRcXi6CFKJdQx48UToNztVaEZkr7oBCHkd3YogXERXSiuyGArrnx40K
ypmjFt8/bY0zRFtMGRq2C9Va2QITJNohaKlC216I8aIWC7BZ7l2943taAaE1xuoH
P5KEatHGHFn0E+GPes2E1sgJ/hkd/761YhFfw/GvXWsQchjmTbeFe2Tgm099JWoa
SBXQ91hIGwXbvkTCS3WOAbUvsxzQ2/eJIJRGxqrd4wd+WYIf4fGgBKPWxJGyaEo6
Tvl+cvBS4XCOZVvMUxLS
=JQgW
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
