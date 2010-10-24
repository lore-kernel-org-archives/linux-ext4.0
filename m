From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Sun, 24 Oct 2010 17:39:04 +0200
Message-ID: <4CC45318.3080002@ddn.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig7BCB6103584EDD6E9DDA0784"
Cc: Ted Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:5777 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab0JXPjK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Oct 2010 11:39:10 -0400
In-Reply-To: <4CC44EAF.3090507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enig7BCB6103584EDD6E9DDA0784
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/24/2010 05:20 PM, Ric Wheeler wrote:
>=20
> This still sounds more like a Lustre issue than an ext4 one, Andreas ca=
n fill in=20
> the technical details.

The underlying device handling is unrelated to Lustre. In that sense it
is just a local filesystem.

>=20
> What ever shared storage sits under ext4 is irrelevant to the fail over=
 case.
>=20
> Unless Lustre does other magic, they still need to obey the basic clust=
er rules=20
> - one mount per cluster.

Yes, one mount per cluster.

>=20
> If Lustre is doing the same trick you would do with active/passive fail=
ure over=20
> clusters that export ext4 via NFS, you would still need to clean up the=
 file=20
> system before being able to re-export it from a fail over node.

What exactly is your question here? We use pacemaker/stonith to do the
fencing job.
What exactly do you want to clean up? The device is recovered by
journals, Lustre goes into recovery mode, clients reconnect, locks are
updated and incomplete transactions resend.


Cheers,
Bernd


--------------enig7BCB6103584EDD6E9DDA0784
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzEUxgACgkQqh74FqyuOzTCmgCguV95gbLXfJdeX27aYoOh/qFA
aR8An06nb4fqZ5QfR0nRTA6PZaTH3SNs
=daBJ
-----END PGP SIGNATURE-----

--------------enig7BCB6103584EDD6E9DDA0784--
