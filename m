Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:58948 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730513AbeK1FwJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 00:52:09 -0500
From: Rainer Fiebig <jrf@mailbox.org>
To: linux-kernel@vger.kernel.org, grendel@twistedcode.net
Cc: Guenter Roeck <linux@roeck-us.net>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Date: Tue, 27 Nov 2018 19:55:01 +0100
Message-ID: <2157925.3ZPi3Rj3bs@siriux>
In-Reply-To: <5d94f857-b31d-a02c-5a20-2796076f447e@twistedcode.net>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net> <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net> <5d94f857-b31d-a02c-5a20-2796076f447e@twistedcode.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2486729.86Eausdgvx"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart2486729.86Eausdgvx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 27. November 2018, 15:48:19 schrieb Marek Habersack:
> On 27/11/2018 15:32, Guenter Roeck wrote:
> Hi,
>=20
> You might try to see if you have CONFIG_SCSI_MQ_DEFAULT=3Dyes in your=
 kernel
> config. Starting with 4.19.1 it somehow interferes with ext4 and caus=
es
> problems similar to the ones you list below. Ever since I disabled MQ=

> (either recompile your kernel or add `scsi_mod.use_blk_mq=3D0` to the=
 kernel
> command line) none of those errors came back.
>=20
> hope it helps,
>=20
> marek

Unfortunately, this doesn't seem to work in every case:=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D201685#c54

And I'm using a defconfig-4.19.3 (meaning: CONFIG_SCSI_MQ_DEFAULT=3Dyes=
) in a VM=20
and I'm not seeing those errors there. OK, it's a VM - but anyway.

The definite cause of this can only be found by bisecting, IMO. And it =
needs=20
to be pinned down because else some feeling of insecurity will remain.

So long!

Rainer Fiebig

>=20
> > [trying again, this time with correct kernel.org address]
> >=20
> > Hi,
> >=20
> > I have seen the following and similar problems several times,
> > with both v4.19.3 and v4.19.4:
> >=20
> > Nov 23 04:32:25 mars kernel: [112668.673671] EXT4-fs error (device =
sdb1):
> > ext4_iget:4831: inode #12602889: comm git: bad extra_isize 33661 (i=
node
> > size 256)
> > Nov 23 04:32:25 mars kernel: [112668.675217] Aborting journal on de=
vice
> > sdb1-8. Nov 23 04:32:25 mars kernel: [112668.676681] EXT4-fs (sdb1)=
:
> > Remounting filesystem read-only Nov 23 04:32:25 mars kernel:
> > [112668.808886] EXT4-fs error (device sdb1): ext4_iget:4831: inode
> > #12602881: comm rm: bad extra_isize 33685 (inode size 256)
> > ...
> >=20
> > Nov 25 00:12:43 saturn kernel: [59377.725984] EXT4-fs error (device=
 sda1):
> > ext4_lookup:1578: inode #238034131: comm updatedb.mlocat: deleted i=
node
> > referenced: 238160407
> > Nov 25 00:12:43 saturn kernel: [59377.766638] Aborting journal on d=
evice
> > sda1-8. Nov 25 00:12:43 saturn kernel: [59377.779372] EXT4-fs (sda1=
):
> > Remounting filesystem read-only ...
> >=20
> > Nov 24 01:52:31 saturn kernel: [189085.240016] EXT4-fs error (devic=
e
> > sda1): ext4_lookup:1578: inode #52038457: comm nfsd: deleted inode
> > referenced: 52043796
> > Nov 24 01:52:31 saturn kernel: [189085.263427] Aborting journal on =
device
> > sda1-8. Nov 24 01:52:31 saturn kernel: [189085.275313] EXT4-fs (sda=
1):
> > Remounting filesystem read-only
> >=20
> >=20
> > The same systems running v4.18.6 never experienced a problem.
> >=20
> > Has anyone else seen similar problems ? Is there anything I can do
> > to help tracking down the problem ?
> >=20
> > Thanks,
> > Guenter

=2D-=20
The truth always turns out to be simpler than you thought.
Richard Feynman
--nextPart2486729.86Eausdgvx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE6yx5PjBNuGB2qJXG8OH3JiWK+PUFAlv9kwUACgkQ8OH3JiWK
+PU9Fw/+LCBuffACw269aBKuv9iwFOWPXILHphPtxQu9DGSd5A5Whv6Nl6zgQ1Zq
NAzpziZm7zR7DlKCmyGckj1rToPyhHFNE5pjC+IxSqBkw17TaafREWF299ZZ+jo6
RnrKcyuuw1roz8KLnkJtK/2XGj0QEH0ZwAINFryBEjYhkD6ysT9fqXnh0QdXB1lr
kgHUwPdn9ToVecWFwReW9+9CzoCmwk96dm3Fh8DA27juG/A/sEsqk5VE+YLkBEsd
c+Ce37EwO6+y2D0esWFPvsY0U5rNriQ1aVFb4nMKDslxQlM1nfbVUKKvzcD1ha08
Tuffoey9G5XTVxqWGwm9eKfekJZTaWSXsWDr3RkF9uejKxge9HPr51bxJ/rl7cNh
ZEIcE5Y+eIYOWpWYzOOpOaTDUHE+bKd6DVfv7zz+bmZenj23yFz8K1FxY2/NOKBp
O8SSNy9ofFbhn/Wyd/7w0CWyulFXbx76eVJiQ9Oj4o9vd5mmx/h+e54zzsY6wfEG
tgt0VAo6j3Qf+uUh7GpB0pmLXQaUllSFlZdw7jToWjM2xgckGEcJ9kWP1tgqs/Ly
DzSrHeb6nc6doBjJo7sAL1AVjU9nWVdVC0kwD2XMJdmFz2VolGEkc1o3yrnMaTLw
pZ9IYgLQnsGt6BbpjuI1zExzVGjX3o2bO9DJzXiH3hHCvl8JhXc=
=21M3
-----END PGP SIGNATURE-----

--nextPart2486729.86Eausdgvx--
