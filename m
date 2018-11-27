Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:11418 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbeK1Cqq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 21:46:46 -0500
From: Rainer Fiebig <jrf@mailbox.org>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Date: Tue, 27 Nov 2018 16:50:05 +0100
Message-ID: <2469172.LfQfxQsF9r@siriux>
In-Reply-To: <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net> <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2634171.pyS62653GN"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart2634171.pyS62653GN
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 27. November 2018, 06:32:08 schrieb Guenter Roeck:
> [trying again, this time with correct kernel.org address]
>=20
> Hi,
>=20
> I have seen the following and similar problems several times,
> with both v4.19.3 and v4.19.4:
>=20
> Nov 23 04:32:25 mars kernel: [112668.673671] EXT4-fs error (device sd=
b1):
> ext4_iget:4831: inode #12602889: comm git: bad extra_isize 33661 (ino=
de
> size 256) Nov 23 04:32:25 mars kernel: [112668.675217] Aborting journ=
al on
> device sdb1-8. Nov 23 04:32:25 mars kernel: [112668.676681] EXT4-fs (=
sdb1):
> Remounting filesystem read-only Nov 23 04:32:25 mars kernel:
> [112668.808886] EXT4-fs error (device sdb1): ext4_iget:4831: inode
> #12602881: comm rm: bad extra_isize 33685 (inode size 256) ...
>=20
> Nov 25 00:12:43 saturn kernel: [59377.725984] EXT4-fs error (device s=
da1):
> ext4_lookup:1578: inode #238034131: comm updatedb.mlocat: deleted ino=
de
> referenced: 238160407 Nov 25 00:12:43 saturn kernel: [59377.766638]
> Aborting journal on device sda1-8. Nov 25 00:12:43 saturn kernel:
> [59377.779372] EXT4-fs (sda1): Remounting filesystem read-only ...
>=20
> Nov 24 01:52:31 saturn kernel: [189085.240016] EXT4-fs error (device =
sda1):
> ext4_lookup:1578: inode #52038457: comm nfsd: deleted inode reference=
d:
> 52043796 Nov 24 01:52:31 saturn kernel: [189085.263427] Aborting jour=
nal on
> device sda1-8. Nov 24 01:52:31 saturn kernel: [189085.275313] EXT4-fs=

> (sda1): Remounting filesystem read-only
>=20
>=20
> The same systems running v4.18.6 never experienced a problem.
>=20
> Has anyone else seen similar problems ? Is there anything I can do
> to help tracking down the problem ?
>=20
> Thanks,
> Guenter

This is already being discussed here:=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D201685

I guess bisecting between 4.18.0 and 4.19.0 by someone who is proficien=
t in=20
this and is affected by the problem would be immensely valuable.

I'm not affected and am a bit reluctant to expose my production system =
to=20
this. ;)

So long!

Rainer Fiebig=20

=2D-=20
The truth always turns out to be simpler than you thought.
Richard Feynman
--nextPart2634171.pyS62653GN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE6yx5PjBNuGB2qJXG8OH3JiWK+PUFAlv9Z60ACgkQ8OH3JiWK
+PWDOQ/9EjNDKB9iogBOWd4TT0W5UWpZELT3m6sGr8pThX4lbDTmQaYgu+dqbrvB
VNye9KBBthDeJurSZN5VJLlSZ+fcwzUfBPBAq3EfLPB0pfHrB/m6fJtAc0AyEjPT
sZ3JE/jTMCYsh/r1rLYHHkBHwiPJ3l/+f5aUZu2KuqGGmw4Ff8FYCy6JeBFafBSS
3obyzPJSKycwihXc5W0gA3TNdvF6JTWnC8ji9TEo1l5Gc3TzoWJEs4Ody3z4EQUn
KQ+/o0e7+KC58tgT2x9SrARQ0UmpGXAWLogKAWUZfsuoHQoIYyUiuJ5ODHbBcSUh
b98vIBnWyFQLmFxXiPvPnvWiVlfsagMKrUdR+xYugUvve5Q6vIUmkQHsUjijIlhC
lpbdoc+qV648XfNPLs6hiNmv1oYLdwtP/JreLaTbNzD+eD1+D3m8TI7C+9qF9tJG
dtUxOjt4LM6Mbc7aQ5p9MJa+uTY9Ufi7juMl795/yeGahTJvIw8t76Ki2cBXXm5K
PXx7kN9k8Cr3pUIjVun6iSM+iSUhul10sZhNT+cwsiA8hos9GE5+bene1wSOxUQb
GoedusqHpQz1/p+TTQxhNR98V3fJatKxhZKRX3mLWhO6TJ369dB6PMD68kYjcx8p
v33hmANDrg3hhMfaJkJ915s4zHhY1n3i0C5ZJ1OGCWNYEboAgio=
=crZc
-----END PGP SIGNATURE-----

--nextPart2634171.pyS62653GN--
