From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ext4:dev 43/52] fs/ext4/inode.c:2211:6: warning: 'err' may be
 used uninitialized in this function
Date: Fri, 7 Jun 2013 09:52:23 +1000
Message-ID: <20130607095223.b14f75f47630c39b434f449a@canb.auug.org.au>
References: <51aed48d.xK+2xHaWtYVlAT8d%fengguang.wu@intel.com>
	<20130606145711.GC5382@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Jun_2013_09_52_23_+1000_PJzQgvZgJGBL.NSb"
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Jan Kara <jack@suse.cz>, kbuild-all@01.org,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:55959 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FFXw1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jun 2013 19:52:27 -0400
In-Reply-To: <20130606145711.GC5382@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Signature=_Fri__7_Jun_2013_09_52_23_+1000_PJzQgvZgJGBL.NSb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Ted,

On Thu, 6 Jun 2013 10:57:11 -0400 Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Wed, Jun 05, 2013 at 02:02:53PM +0800, kbuild test robot wrote:
> > All warnings:
> >=20
> >    fs/ext4/inode.c: In function 'ext4_da_writepages':
> > >> fs/ext4/inode.c:2211:6: warning: 'err' may be used uninitialized in =
this function [-Wmaybe-uninitialized]
> >    fs/ext4/inode.c:2154:6: note: 'err' was declared here
>=20
> This looks like a false warning.  mpage_map_and_submit_extent() is
> only capped when mpd.m_len is non-zero.  Hence we will execute the
> budy of the while loop in that function at least once, which means err
> will be initialized.

Yeah, I guessed that was the case.

> I'm curious what gcc version and/or -Wall flags triggered this
> warning.  I'm using gcc 4.7.2 from Debian and it's not complaining.

$ gcc --version
gcc (Debian 4.7.3-4) 4.7.3

I also saw it with gcc 4.8.0.

> I'm happy to initialize err to zero just to shut up the gcc warning,
> but I'm curious how often it's triggered, since this looked pretty
> trivial for gcc to be able to figure out on its own.

gcc may not be as clever as you hope :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Jun_2013_09_52_23_+1000_PJzQgvZgJGBL.NSb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsSC3AAoJEECxmPOUX5FEyBoP/15M9KUhuEGdHClxvAxuFD3c
NOT6hSXxh08fR8Z/fJM0iwif1sUlXeUFE4lW31Uu1dYqaqvP+9SKKwint7AcywvW
09VzA0M8PV59iMtTZ0CGqHYpcKFm8MoQe0vGdNKkb/rZtfZW1ogZu1R2i1NCZBEX
JirAj7m4m47k5h4Hhw4jsZ9by63abIC64r0kWmwxzwa+Z35+ZPx4pzX8kRgloTdO
bInJLr1cUYwuxsMSEPVOoUAOyLLmnA2bzmOMVjL5/xBcPmMBMdirX0LUOrDCV558
Wh5n11CT2weanHMy2pjZ5hDWcUHDkTOXDSS7lFRGxVUbULSDUpI3bYiOLnhw43ZQ
5WqL2rQOgtJBgFgw0gtbzF6yhUVMxqtZHQ+3Nx01kKTcCflg7txUMcB7zp54mulL
bBip1iTpW/+oH6K+MofczGP0G4b5D6AW2vvYsra2H7Qp9dX1Mv0lvpPOZbOoPb96
nRzP4m/Icjb1xcFFedVayKam7TIbSJusFq1RQyHeBtngFvEXb00ZJIHXYt1T7YMH
swofn4oIIFZRPu0WNOCd40KGNazL8oxmYq44xutpHcPtrfSGrBPywXgPQqZN2TcI
u01nPxI1rq75JsKl3BQ59O8X/ujTLXTFkGuAT5odZesqnkbBAbjAAxvOiT8XiJYG
dZhX2tgvz2BLAZGd3Qy9
=IGQK
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jun_2013_09_52_23_+1000_PJzQgvZgJGBL.NSb--
