From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 15:48:44 +1100
Message-ID: <20121030154844.1898f068@notabene.brown>
References: <20121026101909.GB19617@blackbox.djwong.org>
	<20121027013524.GA19591@blackbox.djwong.org>
	<yq1ehkg8us1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c/itFBuq+A.7zMntXTa.IYL"; protocol="application/pgp-signature"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yq1ehkg8us1.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/c/itFBuq+A.7zMntXTa.IYL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Oct 2012 00:10:22 -0400 "Martin K. Petersen"
<martin.petersen@oracle.com> wrote:

> >>>>> "Darrick" =3D=3D Darrick J Wong <darrick.wong@oracle.com> writes:
>=20
> Darrick> This creates BDI_CAP_STABLE_WRITES, which indicates that a
> Darrick> device requires stable page writes.  It also plumbs in a sysfs
> Darrick> attribute so that admins can check the device status.
>=20
> Might be nice to make the sysfs knob tweakable. Also, don't forget to
> add a suitable blurb to Documentation/ABI/.

 It isn't at all clear to me that having the sysfs knob 'tweakable' is a go=
od
 idea.
 From the md/raid5 perspective, I would want to know for certain whether the
 pages in a give bio are guaranteed not to change, or if they might.
 I could set the BDI_CAP_STABLE_WRITES and believe they will never change, =
or
 test the BDI_CAP_STABLE_WRITES and let that tell me if they might change or
 not.  But if the bit can be changed at any moment, then it can never be
 trusted and so becomes worthless to me.

 At the very least it should only be possible to change it when there is no
 IO in flight.

NeilBrown


>=20
> Feel free to add my Acked-by:
>=20


--Sig_/c/itFBuq+A.7zMntXTa.IYL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI9cLDnsnt1WYoG5AQLmLA//U5Xz60zeREjktAv1PIv/31S/KdEceRXt
ipilRltZGso/AntT4gyNfAU8wzojTKJxcVY8nmE+e0M2HsAks5y2WsdiqK9Sfkg8
S6tsxqJpEPMYJVg6uPIMAZvM5OjQWBtSMHDaWt/mWhzQq9eF9EV0dJNmEXZLEqMA
zQO+nu3tnK4VEkwCtXFb+z4wJkidDtUT+Zsl+a920COORJBGAkNX/M2BhQDodaRG
Hfx9StPbgWgWPGl98t/LbQN8eu2/eqyij0oNtWVN6D6FSbnemphsusDjwyIftXuY
RTzSbMijTyojNfhZT73rVkduHa6evAlQ5jhZPN+G/9mHdN9J2cAm0zDt8/BnRzjO
Hu6W9mqe2XZNEghVPZjqjAWl+UBBUXU2GfJHxkZyEz3jv1WZKLDfsdigyeVxYd2K
YYd7pM3TUQmniUDvqHSiynGFwWWI+MRpg/96Fr5IxxJjdBW1Wyn9kqD7G/1uTTlw
kze1d3W2zAg4aRoNs9PSWaGvaEcXkIrJjnHpM6mi0TTA0vFfr/Fa04O1axjTQv4+
KQBASb2TlQC0iN3W8NLc97yyTpurJMZJ2CQDAwL+k0nKxy+wqXcoeASKs3OCXkCR
EVIFMpQkYvAIAB5rIsMrdpPkJvW9iQuQNC02e8pKavZBZyKmWZVmqz+XqybhCvGf
8OP8NUs4lJ0=
=hcZ+
-----END PGP SIGNATURE-----

--Sig_/c/itFBuq+A.7zMntXTa.IYL--
