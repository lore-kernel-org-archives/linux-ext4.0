From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Subject: Re: ext4 volume > 16TB possible?
Date: Tue, 8 Apr 2008 08:05:04 -1000
Message-ID: <20080408180504.GA8435@ifa.hawaii.edu>
References: <20080407210237.GO23213@ifa.hawaii.edu> <20080408092001.203605fd@gara.konoha.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:33148 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbYDHSTD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2008 14:19:03 -0400
Content-Disposition: inline
In-Reply-To: <20080408092001.203605fd@gara.konoha.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

OK - I am happy to test when this feature is merged.

Thanks,

-J

--
On Tue, Apr 08, 2008 at 09:20:01AM -0500, Jose R. Santos wrote:
> On Mon, 7 Apr 2008 11:02:37 -1000
> Joshua Hoblitt <jhoblitt@ifa.hawaii.edu> wrote:
>=20
> > Hi Folks,
> >=20
> > Is there as of yet a means of creating a large ext4 filesystem?  mke2fs
> > as of 1.40.8 is still limited to creating ext3 filesystems at 16TB.
>=20
> Support for 64-bit block number is not yet available on e2fsprogs.  It
> is being worked on but other features currently have higher priority
> that this so its hard to say when it will be done.
>=20
> -JRS

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH+7PQWa2BU+b7tU0RArjMAJ4vEyllSHH+yVESsQt9xxXb5Qp0NwCfUAy5
xEBNBc+gAutmWilYhNvkL2g=
=j5Zi
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
