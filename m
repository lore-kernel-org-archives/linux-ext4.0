From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: Re: ext4 unlink performance
Date: Thu, 13 Nov 2008 14:27:33 -0600
Message-ID: <20081113202733.GA11746@untroubled.org>
References: <20081113185712.GB11204@untroubled.org> <20081113194628.GB21652@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:55289 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751840AbYKMU1i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 15:27:38 -0500
Content-Disposition: inline
In-Reply-To: <20081113194628.GB21652@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2008 at 02:46:28PM -0500, Theodore Tso wrote:
> I'm assuming that ext3 filesystem was created with htree enabled
> (possibly not true on older versions of e2fsprogs), but if you're
> creating ext4 filesystems, I'm assuming that you have been using an
> 1.41.x version of e2fsprogs.

All filesystems are new filesystems, created with e2fsprogs 1.41.2, all
with the default options except for ^huge_file and the inode size.

> If this the the case, the most likely explanation is that that ext4
> defaults to barriers enabled, and ext3 defaults to barriers disabled.
> So try mounting ext3 with "-o barriers=3D1", or ext4 with "-o
> barriers=3D0", so that the comparison is between apples and apples.

The indication from dmesg is that ext4 is already running with barriers
disabled due to running over dm, but I will re-run with barriers forced
off to double check.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJHI216W+y3GmZgOgRAgAXAKCagyJMym499Tz9OPNOw1hC4ut6hwCdH+rI
E0FxWEZGbb1e8UMHkMtbpII=
=Lina
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
