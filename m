From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: ext4 settings in an embedded system
Date: Mon, 19 Nov 2012 12:43:56 +0200
Message-ID: <1353321836.20111.36.camel@sauron.fi.intel.com>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
	 <1352968933.2221.16.camel@sauron.fi.intel.com>
	 <50A65F64.3020603@redhat.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BBYA6kEhmNPkW4kGtc5c"
Cc: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8404 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab2KSKnM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 05:43:12 -0500
In-Reply-To: <50A65F64.3020603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-BBYA6kEhmNPkW4kGtc5c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-16 at 09:44 -0600, Eric Sandeen wrote:
> > I do not know for sure, but I doubt there is serious power-cut testing
> > regularly conducted for ext4, but people may correct me.
>=20
> We do it here, though maybe not as regularly as we should.
> I also periodically test journal replay, but not in a way that simulates
> lost write caches or misbehaving hardware.  OTOH, those things are out
> of our control in the real world (if users disable barriers, or if the
> hardware lies to us).

Good to know, thanks. I actually now recall Josef mentioned that RedHad
does some power-cut testing.

> But you absolutely should test YOUR system, audit YOUR software, and
> YOUR configuration to be sure that it is behaving as you require.

Sure.

--=20
Best Regards,
Artem Bityutskiy

--=-BBYA6kEhmNPkW4kGtc5c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQqg1sAAoJECmIfjd9wqK0RZEP/Rt84DDk5qEbhsEyFR1ljOiU
8JRVS9M4yaOHJs28dLbRgiY1zy1kpmf4P82oUf/pHUIcQ/LEUhdBvZxRWHh4WrgG
uH9f5rVW2JtPIjl1AEOp95s8GL/gl+ZRrYDEVxPaapUeo6/RXe5ioOghhbtQxhkS
c7w7s+8Q/y3VlKao8Hdwsds6lEziz1shl86XDnLwUblpRc5/gwlwxUSrOJfyp9xy
fgTueKHFZ5UmOtyL2Qog6y6L4eZY86Bw5rj3a2qF7X8YbFVSW7dNYCyA9eFemJ1W
3+vkLnXu/SpykSpNOg7X2xuQAeve9KiWfWgydC+DQwtFvJQpxukw62OfDEEDQCsy
Q3hMD0ircW41UcVIwAjSIoMmVlqCV4F1KqU5R3qYllh1ufejXCmTb3gybXz0CDkD
1HOuCiqEBN9BhQVbE+nBtffOYN3KGORFdMQ86Vs/IePYdM4UjIjX+WrxE0hWPHqz
3TBwkc592cZRjEBHQ+85DWKgpliJTcIyy/Qv/yO0e6wPQwAUK0X8Fl3/px1D6ypG
Xg7eAJTxa9KQpo7Y1XK4+QSTnWjfba8X8DF0uuHI3R5DeHjrKfXAXgNKOcPMYaw8
jLthhs1GRtSvb2hkwFIk+AzCrWDT8vOFjrXev+jqip2Y+lHibZGdGHf3/F7lDrUj
cateXVHOqkCTrQMc1vRF
=44VC
-----END PGP SIGNATURE-----

--=-BBYA6kEhmNPkW4kGtc5c--

