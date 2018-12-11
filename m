Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52363 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbeLKAMB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 19:12:01 -0500
Date: Tue, 11 Dec 2018 01:11:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrey Melnikov <temnota.am@gmail.com>
Cc: jrf@mailbox.org, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Message-ID: <20181211001158.GA20388@amd>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org>
 <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux>
 <CA+PODjo-da79FKQCmpcH9Z9CBq35HbWu2m+nB3si7WgD9w-kGA@mail.gmail.com>
 <cbdb2e6b-31a2-1e19-f51f-067dcbdcf183@mailbox.org>
 <CA+PODjpLRuc1u4SNSRqfWtx+Z+C8NGi6fs7yFuyKK0DwHggEdg@mail.gmail.com>
 <de67b507-ca54-e827-867e-76d57e531cb9@mailbox.org>
 <CA+PODjrT=pXg-jbhk=q=M6j6-v0x+c05s4Lmi3+MLm0P4iirqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <CA+PODjrT=pXg-jbhk=q=M6j6-v0x+c05s4Lmi3+MLm0P4iirqg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > >> OK, - and now we are looking forward to *your* ideas how to solve th=
is.
> > >
> > > After four days playing games around git bisect - real winner is
> > > debian gcc-8.2.0-9. Upgrade it to 8.2.0-10 or use 7.3.0-30 version for
> > > same kernel + config - does not exhibit ext4 corruption.
> > >
> > > I think I hit this https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D878=
59
> > > with 8.2.0-9 version.
> > >
> > Good that it works for you. But others used gcc 5.4.0 or 6.3.0 and were
> > hit anyway: https://bugzilla.kernel.org/show_bug.cgi?id=3D201685#c165
>=20
> Depends on workload pattern. 4.19.5 built with 8.2.0-10 and 7.3.0-30 -
> crashed after 4 hours of usage (previous build crash in 5 min).
> So my assumption about broken gcc is wrong.

Would it be possible to try vanilla 4.19? (Not stable?)

I test vanilla and -next kernels every week or two, and did not have
ext4 problems recently. I guess many kernel developers test mainline
but not stable...

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwPAM4ACgkQMOfwapXb+vLyyQCglNr9W0Yjj+gLo6r9M2hiqmgZ
nuUAoLpVLCRMF5SHvowKQwp8rB12CY4A
=9lSA
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
