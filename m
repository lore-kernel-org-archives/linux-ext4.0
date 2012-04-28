From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: Intentionally corrupted fs: [this times really] "kernel BUG at
 fs/jbd2/transaction.c:161!"
Date: Sat, 28 Apr 2012 04:56:00 +0300
Message-ID: <20120428015600.GF20648@sli.dy.fi>
References: <20120428004522.GC20648@sli.dy.fi>
 <4F9B4B16.4090903@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:58825 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758345Ab2D1B4F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2012 21:56:05 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q3S1u3JG025386
	for <linux-ext4@vger.kernel.org>; Sat, 28 Apr 2012 04:56:03 +0300
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 28995-563 for <linux-ext4@vger.kernel.org>;
 Sat, 28 Apr 2012 04:56:03 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q3S1u0pl025376
	for <linux-ext4@vger.kernel.org>; Sat, 28 Apr 2012 04:56:00 +0300
Content-Disposition: inline
In-Reply-To: <4F9B4B16.4090903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 27, 2012 at 08:42:46PM -0500, Eric Sandeen wrote:
> > (This bug report serves also as a preview of the Berserker toolkit
> > that automates finding such bugs and minimizing the differences to
> > pristine filesystems. I plan on making the announcement and making the
> > toolkit available within the next few hours.)
>=20
> sounds a bit like fsfuzzer, how is it different?

I hope the announcement I just sent responded to this; but basically,
the toolkit works on a somewhat higher level (it uses zzuf, which I
believe to be similar to fsfuzzer but actually only fuzzes the
filesystem image and does not itself run tests on it; zzuf is not
written by me). Mostly the toolkit is about managing a virtual machine
to run tests automatically and about minimizing the differences to
pristine filesystems.

I confess I'm not intimately familiar with fsfuzzer (I should be!),
but I believe one of the advantages of berserker is that it automates
the virtual machine stuff and provides convenient scripts that can be
used with e.g. git bisect run.

	Sami

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPm04wAAoJEKLT589SE0a0JcAP+gPiF864Jn2GV2dVpZ8c2Po/
qHuPgpoo3woFClXzxt3i/oHteMFp8uu016/Ibye5oMmDiBAtaMhE0MNx4yxJdvZ9
VF0Zja6qKit5Ot0456X5dzU8gwc8lqVl/wFKy22IML7TXdn9Bjq/wBwf5eQLoA7e
PuQiQyx74oLI6jtgrHw9cH9RTUGidgjrQu8vZ/WjMJ8gf9OIRMsH5ZxN3poQ8pFh
hXBMuOYKfek0cxylIgvBW4r8BdNEmmefLEIBGxX1XmP9b+ULb8+uzARl+rldRoIm
cbhE1B2gE6QJTo2Qtv2yDDFzqXqPE4u5F3OLUNxL38ZvYQr5N1ruGMBd0y6ENZxa
Dczh0SOyXnMkLQ/HeudZDgZSGcLkJ+jaR3AH5sU9rlaXHxmKLnzfrA3DFYtAg3Ww
A//in8eDmxV7eLIhLeQb5OfIL8qyCbqxqHtcMchcmVOKtjPKO9AJ8j/0donKardH
ZUtc8tcBnAjcFlmp1ziVd5NTv18JmLJBhm/qmDlFA8zqFxe3mT79QI0xlz9iW93W
+CQQIlmiwjauL8UQrTOx+gZ6hUNDfBH1Z8ibsWwNo8WfhZhF2SMtSqJISmV+NUot
Dbe+qEhGOuix0RqPpkgBeuXTAmJvTP8Rgoh63QROHLZpdtO6fzG2Nf3mqSgX7Wbb
Ez1aMHUgMO70TvYOUdMN
=Uuds
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
