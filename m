From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Tue, 20 May 2014 11:47:41 +0200
Message-ID: <20140520094741.GG11499@pcnci.linuxbox.cz>
References: <1399382357-12703-1-git-send-email-lczerner@redhat.com>
 <20140506174301.GQ8434@birch.djwong.org>
 <20140506192325.GB5012@thunk.org>
 <alpine.LFD.2.00.1405071040240.2128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="979CEDRuanSFbKgf"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:37471 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaETJr6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 05:47:58 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405071040240.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--979CEDRuanSFbKgf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Luk=C3=A1=C5=A1,

just wanted to ask about the status of this patch.. it didn't make it
to git yet, did it? Do you plan to make some changes to it? I'm eager
to test it ;-)

cheers

nik


On Wed, May 07, 2014 at 10:44:34AM +0200, Luk=C3=A1=C5=A1 Czerner wrote:
> On Tue, 6 May 2014, Theodore Ts'o wrote:
>=20
> > Date: Tue, 6 May 2014 15:23:26 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Darrick J. Wong <darrick.wong@oracle.com>
> > Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
> >     nikola.ciprich@linuxbox.cz
> > Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs conta=
ins
> >     errors
> >=20
> > On Tue, May 06, 2014 at 10:43:01AM -0700, Darrick J. Wong wrote:
> > >=20
> > > Minor complaint: "contains" makes me think that cat'ing that file wil=
l return
> > > either 0 or 1, not a string of error text.  Perhaps we could shorten =
it to
> > > /sys/fs/ext4/sda/errors ?
> >=20
> > What I'd suggest doing is simply calling it errors_count, and
> > returning s_error_count.  While we're at it, we could also return
> > s_first_error_time and s_last_error_time as well, since I imagine
> > those would could be quite useful for someone trying to create a
> > system health monitoring daemon.
> >=20
> > Cheers,
> >=20
> > 						- Ted
>=20
> Right now I am using the same function which prints this information
> to the log. So I am going to use simpler output for the sysfs.
>=20
> <error count> <first time> <function>:<line> <last time> <function>:<line>
>=20
> That should be easy to parse. I think that just calling it errors is
> good enough.
>=20
> Thanks!
> -Lukas
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--979CEDRuanSFbKgf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlN7JL0ACgkQ3xdJJrLygV6HEQCbBL5Aq3ZE9wmVWmtspnpfJ0LX
hTYAn0E9WMWe5FGAttIPvL3D53s54X1l
=CCqr
-----END PGP SIGNATURE-----

--979CEDRuanSFbKgf--
