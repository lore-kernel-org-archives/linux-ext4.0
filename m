From: Jon Leighton <j@jonathanleighton.com>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Fri, 21 Jan 2011 14:28:29 +0000
Message-ID: <1295620109.22802.1.camel@tybalt>
References: <1295568782.2459.29.camel@tybalt>
	 <20110121013140.GA8949@dhcp231-156.rdu.redhat.com>
	 <1295601083.5799.3.camel@tybalt>
	 <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
	 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/BqI0MvOkioIFAj+RGrN"
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from benvolio.jonathanleighton.com ([173.255.230.218]:50066 "EHLO
	benvolio.jonathanleighton.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab1AUO2c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 09:28:32 -0500
In-Reply-To: <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-/BqI0MvOkioIFAj+RGrN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi there,

On Fri, 2011-01-21 at 09:03 -0500, Josef Bacik wrote:
> Heh so now that I've had a moment to wake up, how about running your test=
 on
> ext3, but mount the partition with
>=20
> mount -o barrier
>=20
> and see if it's still faster than ext4.  Thanks,

You're right, that slows it down significantly on the ext3 partition. Is
this expected behaviour with ext4 then?

Thanks

Jon

--=-/BqI0MvOkioIFAj+RGrN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJNOZgKAAoJEIeyJN+tUcli+nYH/1jYy0fRVvE9F/hYfIeATNh2
ddcrloeQy2plQwliPdMw5IpAcGJO9aJr1WrrEokPBATJDl3a9mXQoP0gcYLhKTV4
wT2Beuwu39BPByQkY3UTcpfgkPeRudn71ZPK7GZcg6TygtXk0o8bUKfVuRGHVzLi
Nn8Fq9fhiZ1hXWbpYiMTLlZD0NHUE/j9CC3bviybEjZo1wlmmW4XvEu3D8ZcEyIY
tCi7CHlSW/SrV9UVQmOYXOWGogk4pDApUJ5JTDiqM36SUPNfeta8yBxsxUTDGDGN
ZYbXjL5Y6cSId5Wblj91s1RBuvpsit5HZ8LAosLyxT6m9DCX92uPC5wLwR4E0MY=
=jutt
-----END PGP SIGNATURE-----

--=-/BqI0MvOkioIFAj+RGrN--

