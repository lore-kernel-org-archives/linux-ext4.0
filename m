Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:48498 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbeK2C5V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 21:57:21 -0500
From: Rainer Fiebig <jrf@mailbox.org>
To: linux-kernel@vger.kernel.org
Cc: "Andrey Jr. Melnikov" <temnota.am@gmail.com>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Date: Wed, 28 Nov 2018 16:56:51 +0100
Message-ID: <2547416.7Vy7A2kRpU@siriux>
In-Reply-To: <en52df-5dh.ln1@banana.localnet>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net> <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2435657.fxogZo8kkS"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart2435657.fxogZo8kkS
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Am Mittwoch, 28. November 2018, 13:02:56 schrieb Andrey Jr. Melnikov:
> In gmane.comp.file-systems.ext4 Theodore Y. Ts'o <tytso@mit.edu> wrot=
e:
> > On Wed, Nov 28, 2018 at 03:16:33AM +0300, Andrey Jr. Melnikov wrote=
:
> > > Corrupted inodes - always directory, not touched at least year or=

> > > more for writing. Something wrong when updating atime?
> >=20
> > We're not sure.  The frustrating thing is that it's not reproducing=

> > for me.  I run extensive regression tests, and I'm using 4.19 on my=

> > development laptop without notcing any problems.  If I could reprod=
uce
> > it, I could debug it, but since I can't, I need to rely on those wh=
o
> > are seeing the problem to help pinpoint the problem.
>=20
> My workstation hit this bug every time after boot. If you have an ide=
a - I
> may test it.
>=20
> > I'm trying to figure out common factors from those people who are
> > reporting problems.
> >=20
> > (a) What distribution are you running (it appears that many people
> > reporting problems are running Ubuntu, but this may be a sampling
> > issue; lots of people run Ubuntu)?  (For the record, I'm using Debi=
an
> > Testing.)
>=20
> Debian sid but self-build kernel from ubuntu mainline-ppa.

You could try a vanilla 4.19.5 from https://www.kernel.org/
and compile it with your current .config.

If you still see the errors, at least the Ubuntu-kernel could be ruled =
out.

In addition, if you still see the errors:

=2D backup your .config in a *different* folder (so that you can later re=
=2Duse=20
it)
=2D do a "make mrproper" (deletes the .config, see above)
=2D do a "make defconfig"
=2D and compile the kernel with that new .config

If you still have the problem after that, you may want to learn how to =
bisect.=20
;)

So long!

Rainer Fiebig


>=20
> > (b) What hardware are you using?  (SSD?  SATA-attached?
> > NVMe-attached?)
>=20
> SATA HDD WDC WD20EZRZ-00Z5HB0.
>=20
> > (c) Are you using LVM?  LUKS (e.g., disk encrypted)?
>=20
> No and no. Plain ext4.
> -- cut --
> debugfs:  features
> Filesystem features: has_journal ext_attr resize_inode dir_index file=
type
> needs_recovery extent 64bit flex_bg sparse_super large_file huge_file=

> dir_nlink extra_isize metadata_csum
> -- cut --
>=20
> > (d) are you using discard?  One theory is a recent discard change m=
ay
> > be in play.   How do you use discard?   (mount option, fstrim, etc.=
)
>=20
> no

=2D-=20
The truth always turns out to be simpler than you thought.
Richard Feynman
--nextPart2435657.fxogZo8kkS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE6yx5PjBNuGB2qJXG8OH3JiWK+PUFAlv+usMACgkQ8OH3JiWK
+PUorA//cxifJkgEH+U8UUvb2ekdEwVaU7L4xbciqvYf4ANCvE/nCtuLvT3dtd2v
r2gEe4EVqwvt+zuPt8ihdcxRtrMNvdaZQNcLd0NyWderwtWnrMRqbiQKldvt8gjX
AGR1sPE5Otxmb3vksSSIoBWM1TzzDpSy1ANVNPLd3pJ+XvhVtGELN6nKpAoPgxHD
Z5kW194mEvz7EzjeAja9KAQl6PMu7oBSl1MvBEgUZoGamxEzazIqFyZmnULW9Ceu
RvDPi3yvs649S0kvIYgVccNKMmim9rwqyQmUWTwXn3cgXZ5AkrPaF4pu3aW2hawh
wL8O0z+WwTy3yHR/kp/MjDZrnrAlp7eZSA/KuuSoDxYy/oVyuHO5OT3b/ASUVMro
3WWstgOhA/plHqIyUPjzOKWRdJ2hrFqAt4Krx2n2D7+H1lqMpnS8qxINJv9SdJ2b
S4rWSqHUbacvwDbyxYfRxOyytbnWZKJcd2RoV+dRUREx5w5yEfEtKv5UofxchHpz
wMbS6fQI5u/9VntOpG0+AVG24WF3j4fUrwYsEH3990P1vFfTAcgMM5iEbfvCl0uP
/1/L4Eb2YbQ8RvoaY6QzvxF1gSgxITa07Zxp9gCjAMg93YniBRXQSVvKaiV+dZCk
7aV1XhZm3oN6X38McACcsonp2xwX2Ff6MiKNAphoNtMI5PyxYyA=
=j4de
-----END PGP SIGNATURE-----

--nextPart2435657.fxogZo8kkS--
