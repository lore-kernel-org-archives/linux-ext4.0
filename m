From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 10:48:37 +1100
Message-ID: <20121030104837.2e4b06fc@notabene.brown>
References: <20121026101909.GB19617@blackbox.djwong.org>
	<20121027013524.GA19591@blackbox.djwong.org>
	<20121029181358.GG18767@quack.suse.cz>
	<20121029183051.GJ18767@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KXAUnllFU/8ig4COcDuGsgc"; protocol="application/pgp-signature"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab2J2XsU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 19:48:20 -0400
In-Reply-To: <20121029183051.GJ18767@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/KXAUnllFU/8ig4COcDuGsgc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Oct 2012 19:30:51 +0100 Jan Kara <jack@suse.cz> wrote:

> On Mon 29-10-12 19:13:58, Jan Kara wrote:
> > On Fri 26-10-12 18:35:24, Darrick J. Wong wrote:
> > > This creates BDI_CAP_STABLE_WRITES, which indicates that a device req=
uires
> > > stable page writes.  It also plumbs in a sysfs attribute so that admi=
ns can
> > > check the device status.
> > >=20
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >   I guess Jens Axboe <axboe@kernel.dk> would be the best target for this
> > patch (so that he can merge it). The patch looks OK to me. You can add:
> >   Reviewed-by: Jan Kara <jack@suse.cz>
>   One more thing popped up in my mind: What about NFS, Ceph or md RAID5?
> These could (at least theoretically) care about stable writes as well. I'm
> not sure if they really started to use them but it would be good to at
> least let them know.
>=20

What exactly are the semantics of BDI_CAP_STABLE_WRITES ?

If I set it for md/RAID5, do I get a cast-iron guarantee that no byte in any
page submitted for write will ever change until after I call bio_endio()?

If so, is this true for all filesystems? - I would expect a bigger patch wo=
uld
be needed for that.

If not, what exactly are the semantics?

Thanks,
NeilBrown

--Sig_/KXAUnllFU/8ig4COcDuGsgc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI8V1Tnsnt1WYoG5AQKaUw/+KY6KG7Vb32opbE/7ZSJlE7Yig97VQteR
6zhwHCh713rWt9jUmzL1fgpM6qIzx8fZqcIpegFt6/u8KjydR9qfsvI+LErEHOoe
VLMWYN5eYQJhUOctN1HP794Nkg5PJYQbMNH+OurgFaacztJKE51BBwAUP4AT2Lpq
F6UF4lLV/CxUTEEVvSqliIWAIjr3bbuHqLFaNo0vhM9Yzshu8WfGMsyLO4rVyVP7
HpYY+IVYipSiLjTAPWx90iNx/PSNtu5XK8VUSBvAmJaE1d43AMTi5wTVrkBYoTMY
VAM40Z1Fe/iJ4PyRe8c+D8fUpzYCfxBi0+Tz4wG2HJpYY4InX//jn03AH5kFvm1P
fKLrFp8xpg/wX36xJcCX3FKboEzJtBtNmQ6NNkBejUw1s7D0Zkz1NjcTyN2ExIEB
aQ+WHixMfsJmsNQ85WZaAegCMN9sWii3W4/6PcaDVSq3M3EbSSAmZgnf5MZNhxsb
aBFPfREb93VRGJjf7WhhjgbEi0LRQF2nYkD0kpK7qH+54R5zHz13RcatUF7xewrV
bl0RB+9IU8twwX+Km6QCIym1sVu2K5ZPoJV0A0by1uG3wrmyMTmCihjPt+LWt/S4
FXRgzPMh//bicIguwx52+cja2Xj8um5CaeQar0RVrj0UHnRivYa+bx1ItCm6QjlN
327kzCm+7Ek=
=WJez
-----END PGP SIGNATURE-----

--Sig_/KXAUnllFU/8ig4COcDuGsgc--
