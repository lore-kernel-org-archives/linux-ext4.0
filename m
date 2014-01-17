From: Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: What is status of metadata_csum
Date: Fri, 17 Jan 2014 09:18:29 +0100
Message-ID: <52D8E755.6030205@rempel-privat.de>
References: <52D7BB10.5090003@rempel-privat.de> <20140117020009.GL9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="c8d8xu7l4d9LthACS57n2k8cEs7LH6tkj"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62769 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaAQISj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jan 2014 03:18:39 -0500
Received: from [192.168.1.100] ([93.218.75.192]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MbrR4-1Vo37T2LCQ-00JLCe for
 <linux-ext4@vger.kernel.org>; Fri, 17 Jan 2014 09:18:37 +0100
In-Reply-To: <20140117020009.GL9229@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c8d8xu7l4d9LthACS57n2k8cEs7LH6tkj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.01.2014 03:00, schrieb Darrick J. Wong:
> On Thu, Jan 16, 2014 at 11:57:20AM +0100, Oleksij Rempel wrote:
>> What is metadata_csum status?
>>
>> i see there are benchmark updates on wiki page, but no updates for
>> e2fsprogs. 1.43-WIP seems to be really old.
>=20
> Still waiting for 1.43.  I don't know if there are early adopters runni=
ng
> 1.43-WIP without complaint, or if simply nobody's using it at all. :/

I didn't tested current master.git - my bad. It is not outdated :)

Beside, the wiki should be corrected. If you enable 64bit, it will need
extents too.

Are there any existing tools for error injection for file systems?
Random read error from libata or silent data corruptions?
--=20
Regards,
Oleksij


--c8d8xu7l4d9LthACS57n2k8cEs7LH6tkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLY51sACgkQHwImuRkmbWm+LQEAl8WvnDNL/sQ+pPKixalCyB6Q
ob3/BEbpYV5JOhGtdI8A/2ngKce75PlPFu/KmHd8XOBzMP26ubXa5xDRK6dzwswy
=7E1l
-----END PGP SIGNATURE-----

--c8d8xu7l4d9LthACS57n2k8cEs7LH6tkj--
