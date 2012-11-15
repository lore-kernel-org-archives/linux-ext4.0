From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: ext4 settings in an embedded system
Date: Thu, 15 Nov 2012 10:42:13 +0200
Message-ID: <1352968933.2221.16.camel@sauron.fi.intel.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/CxZ9WqU7zbnej7C+vJf"
Cc: linux-ext4@vger.kernel.org
To: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17431 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471Ab2KOIle (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 03:41:34 -0500
In-Reply-To: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-/CxZ9WqU7zbnej7C+vJf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Fredrik,

On Wed, 2012-11-14 at 11:41 +0100, Ohlsson, Fredrik (GE Healthcare,
consultant) wrote:
> 2. Empty files, size 0.

Well, this is expected in some cases. If create a file, start appending
data, and have a power cut, you may end up with zero-sized files.

This is a Linux feature - the data is cached in RAM until write-back
happens or something like fsync() happens.

Ext4 has a feature that if you write to a file, then close it, ext4 will
initiate write-back for you right away. It was added a couple of years
ago to make it more user-friendly.

You really should investigate what are those files and what was
happening to them just before the power cut. Zero-length files may be
normal, in general.

However, strictly _all_ files you care about should be explicitly
synced. This is just safer.

If you write serious medical software, you should take data integrity
seriously in your apps.

I wrote this section for UBIFS users long time ago, and it is the same
(modulo UBIFS-specific details) for other Linux file-systems, including
ext4:

http://www.linux-mtd.infradead.org/doc/ubifs.html#L_writeback
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_sync_exceptions

> Is ext4 a bad choice for an embedded system with I 1Gb IDE Flash Disk and=
 Debian 2.6.32-5-686?  Should we change filesystem?

I do not know for sure, but I doubt there is serious power-cut testing
regularly conducted for ext4, but people may correct me.

So if power-cut tolerance is important for you, you should conduct good
power-cut tests.

And remember, the disk quality is very important for
power-cut-tolerance. If you uses something like bad managed flash (bad
SSD, eMMC), it may lose recently written data on power-cut. So testing
is important.

Of course you should have barriers on as well.

We conducted some 3 years ago. Results were quite good for ext4 - in
many cases it could recover without a need to run ckfs.ext4, sometimes
it was not mountable, but ckfs.ext4 helped.

On the opposite, ext3 constantly required ckfs.ext3, and sometimes died
so badly that even ckfs.ext3 could not recover it.

--=20
Best Regards,
Artem Bityutskiy

--=-/CxZ9WqU7zbnej7C+vJf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQpKrlAAoJECmIfjd9wqK03kwP/Rkw8YlYiV4+UykZwKsBKHua
MKjq9uckHs5+iob6ncGWKBgd2SmjseTtsJAQcWC2ihYdx+XMBYPo7SYUzz1XCk8O
6UmB7hKu4Aa58/Eo6Idyi0lL7GXqEh9sjlBp8JC24UtoLVtj5oiJgtXseQAblcKL
qFXqqI46Wdw4RET/iKircpF7enzbebCbAd5z6eerVU0l89FXChXAAyEx1iSECElx
NeVRFcGEFRpZb2rzK+RBIDHyELKqcnu1cHG5jvcsHnXN6ya6BDJ2D69aFtzFwZfF
dEEsb2le8Ezc0mS0juUAZGnOGavR5OnkaMmiWRl8fsKSJAfNK2+mSC5jwXlF61Hi
ZXT+bLwv0/wi6HUO9EUrjHiOjdrZ/W0W9HIUtnUqxOoJuL5IB6QByiyqfkq+8UKy
4FDvH6u28TFGcr8YtTwaXZWqHolNxi4H8yJrAfE2OPPNb1PtOp7cSzRGrZR1j2bE
B90WG95y4SMFFsg6votrKaaZ3sNq+qtBFPXgSLYyaZou2l4bVfXJe6RDxRwy7WhD
VBngMuw/Vy9ws2DLZ10zgTu38bcXgIQRkzrTJHjfErZ7x3j0Iv5obhrUr2+ZzmmA
ftp0Qf/DxIritHnvyz82T1IcvrNVRJwsaKwARfp4jwGcveAEFN4lZo1D9qWt/VHS
ukFt+3YahMLHJHnOoWVY
=AMOX
-----END PGP SIGNATURE-----

--=-/CxZ9WqU7zbnej7C+vJf--

