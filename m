From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Tue, 28 Jun 2011 22:49:55 -0600
Message-ID: <20110629044955.GA30312@untroubled.org>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:50686 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751122Ab1F2E4h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2011 00:56:37 -0400
Content-Disposition: inline
In-Reply-To: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2011 at 01:26:03PM +0200, Lukas Czerner wrote:
> Data journalling mode (data=3Djournal) is known to be neglected by
> developers and only minority of people is actually using it. This
> mode is also less tested than the other two modes by the developers.
>=20
> This creates a dangerous combination, because the option which seems
> *safer* is actually less safe the others. So this commit adds a warning
> message in case that data=3Djournal mode is used, so the user is informed
> that the mode might be removed in the future.

When I last benchmarked it, data=3Djournal mode was considerably faster
than the other modes for sync heavy work loads, such as mail servers.
Have there been improvements to other (safe) modes that reverse this?

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk4KrvMACgkQ6W+y3GmZgOgjVQCgp7UNRGSDpzAj/IHeDE+Muv2y
COoAoIZpcZ0+/jQh6XWr8VT1XQVsSrGx
=roUt
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
