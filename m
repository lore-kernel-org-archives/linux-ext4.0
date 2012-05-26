From: "Brett M. Royles" <brett@royles.co.uk>
Subject: nouser_xattr
Date: Sat, 26 May 2012 12:09:46 +0100
Message-ID: <1338030586.2093.4.camel@dauntless.royles.co>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PhFvYF6MzUmu1QB/Lpfx"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50727 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2EZLKm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 May 2012 07:10:42 -0400
Received: by weyu7 with SMTP id u7so1059371wey.19
        for <linux-ext4@vger.kernel.org>; Sat, 26 May 2012 04:10:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-PhFvYF6MzUmu1QB/Lpfx
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi there,

I have just spotted in my log files that nouser_xattr will be removed.

I think it should be kept in as I currently use that option to ensure
that my / partition (which is on a ssd) is mounted without user_xattr to
stop some writes to it.  If I don't specify nouser_xattr the / partition
automatically gets mounted with user_xattr.=20

Will there be any other way to ensure that a partition is mounted
without user_xattr?

(I could have missed something totally obvious tho :P )

Thanks,

Brett

--=-PhFvYF6MzUmu1QB/Lpfx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPwLn6AAoJEIS8kqiM3crMJmAQAOXu/PxYGoUMpJX0fUMRtb5Y
dfewMGmuwyhsVTRleq9AwvKw2bzoYFv6w6ZVWwtOD59UuzdDGWBKzgkj11YxIbvw
DzAHhVldM9hZ1LHh9HmV7tc8jJZx8+b7vN9HmssYu3TVirOylp5noiF7C/etAqs9
vOKlF3diMe1pZTMVR4JxsHl/C2AJePDGJmKhJ5G0KgeS4heR6sdOySi/ONz9A6KF
99NRx2CR0WPia06RUFq8z12ivI8IK4T6U0/f0pCj63vt+Kmnh6LQfPcuHXZ9UPy2
k0dJ7ilHuh1s4hADVklbHKh3E57/hxegt1B0wfNwv2M4xiIpA94k5XRsQxawG2vu
kmCr8VITMHT7Y/sI06/vH18B0GoMXi5880gbPyU1YUa0pFW9vpFWIzqpRwmJvKT2
J5aQGtaaXcKBkianwkAlwXp1uVO4io9dB2YpgRht8rs5CGZCqnhKDwXGb1n2YUHu
Bum5/EQmlh22l5PsrclFZSgTfP6p7Pq9+7VXHK8Z4xjRz6AltIeWZign2XEetOo/
cjdUNYNKLLQdVXLiqMqC4nUdBJVUF/v3Qjqvni0rMyf80O2P4s6wWCWHmoZujYbX
ns0eZG6rUNluiANJuICVnJBWXc2JKGtWyipVJl1v0uGyoX6MtO2hlR9tTSYOWUUw
SCV39yQXHw5gc2Ail69x
=5fPs
-----END PGP SIGNATURE-----

--=-PhFvYF6MzUmu1QB/Lpfx--

