From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: ext4 settings in an embedded system
Date: Mon, 19 Nov 2012 12:42:15 +0200
Message-ID: <1353321735.20111.34.camel@sauron.fi.intel.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
	 <1352968933.2221.16.camel@sauron.fi.intel.com>
	 <CAA0+VHyODd+hsSL6FBqcLGb_r3ViHmL78ay=8k5CJeP0=Z2k7A@mail.gmail.com>
	 <50A65E5D.7040305@redhat.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-F4u/a1lHy9gxDs06ErQL"
Cc: Andrey Sidorov <qrxd43@motorola.com>,
	"Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10438 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2KSKlc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 05:41:32 -0500
In-Reply-To: <50A65E5D.7040305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-F4u/a1lHy9gxDs06ErQL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-16 at 09:40 -0600, Eric Sandeen wrote:
> Barriers were not made default on ext3 until 2011, in kernel v3.1,
> astonishingly.  So it makes sense that ext3 fared worse than ext4.

Very probable, I do not remember if we had them. But we were testing on
top of eMMC with not write-cache.

Anyway, that was long time ago.

While on it, one problem I remember in an unrelated testing of ext3 on
top of eMMC was related to _read_ errors. Sometimes after an power cut
eMMC returned an ECC error, so a sector could be unreadable. But after
writing to this sector it became fine.

ext3 and the tools treated a read error as fatal. However, in case of
eMMC that was something "normal".

I do not know how the situation changes since then, this was probably in
2009.

--=20
Best Regards,
Artem Bityutskiy

--=-F4u/a1lHy9gxDs06ErQL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQqg0HAAoJECmIfjd9wqK0Jb0P/2m8U92rlBFeQBO2aEKsY//L
P9XbmEwekhCN1FUpqewu0cjMt6trj5fsxXZNyW+ra/V2hiSdGCFlnEzVpF19UutE
A5AFg4B73b6S6gjFX6FKetkAE1Pk0wS0gsCm7tes4li9eGtXoaEMIMuuz4xCzhNy
a6v+l2ID1X/tr3OspxmQYPL6ocWfWL15VYUcIjgrW0dogKM/uIPfi/Wwb3rtR+X6
QuxpDVrukDSPTwT5wNynwmS0hIgheZ0Nuuf+kD9W3AWgtPvCUUGYtdxn9Oz6GHUJ
NBaT1f8RYaQbZrL0JwKZp0f1YM0RozstJ+PpgqCbx12ua15MswYiFQ4jUfFK87/L
gAcD2bz6pZCaz6wqoGquhtkxkELdBCNgceIjuaE7KN/9ej8MCYMjRGQ0VvdIAc6C
je5KoQujA5USVTdL07vjNZjW+Vy3Tt7So3rVAF2xepV1H6wa2nqGa8IKyGOY40Bu
ivkxJvab1RmuyEzX1tS5mz6vZdOH4SpOUWg63Jx2Ylo9pDi6euGCPtQOlQiVOXTy
Vhfi8LkHmlZHFUI8DQhNAqzxPA4VaWA50laUKTObPsfh3gGK5jQm7bXZvrqyrncK
jxw7c5MJXBrYWEmTRu1EhPqh9vWB4IKGdqU11xuoVHt1IAt4FXkOhpP0INSL43Vr
dZjq28zzlHhL+swBwzBF
=nZFl
-----END PGP SIGNATURE-----

--=-F4u/a1lHy9gxDs06ErQL--

