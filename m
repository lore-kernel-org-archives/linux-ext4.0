From: Walter Hurry <walterhurry@lavabit.com>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Thu, 9 Feb 2012 23:20:38 +0000 (UTC)
Message-ID: <jh1kc6$nt9$1@dough.gmane.org>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org
To: debian-user@lists.debian.org
Return-path: <bounce-debian-user=gldu-debian-user-2=m.gmane.org@lists.debian.org>
Resent-Message-ID: <3BxFt9HFZgK.A.GtC.AUFNPB@liszt>
List-Post: <mailto:debian-user@lists.debian.org>
List-Help: <mailto:debian-user-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-user-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-user-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

On Thu, 09 Feb 2012 16:29:53 +0000, Rudolf Zran wrote:

> Hi everybody!
>=20
> I recently damaged an ext4 partition by accident (mistakenly forced a
> RAID sync with another partition onto it, which I realized after about
> 3% completion). As a result the beginning of the ext4 partition seems t=
o
> be overwritten with garbage and refuses to mount.
>=20
> As you might guess, I'd now like to get as most of my data back (from
> the part which hasn't been overwritten, of course :)).
>=20
> Maybe somebody knows a good method to just "repair" the ext4-structure
> from the remaining part of the partition?
>=20
>=20
> Background information:
>=20
> Operation system:=C2=A0=C2=A0 Debian GNU/Linux 6.0.4 (Squeeze) Kernel:=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> Linux 2.6.32-5 Architecture:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 x86-am=
d64 e2fsprogs:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.41=
.12
> Filesystem type:=C2=A0=C2=A0=C2=A0 ext4, with default settings (mkfs.ex=
t4 /dev/xyz)
> Filesystem size:=C2=A0=C2=A0=C2=A0 Around 1TB, filled with around 800GB=
 of data.
> Filesystem content: From a lot of ASCII stuff up to files with several
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GB in size and arbitrary
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 non-standard type.
>=20
>=20
> What I've tried so far:
>=20
> * First of all, though the source drive is physically fine, I work on
> =C2=A0 images of the partition on a spare drive, to experiment with.
> =C2=A0 Everytime I make unrecoverable errors to that image, I recopy th=
e
> =C2=A0 original.
>=20
> * "dumpe2fs -b $SBERR /dev/loop0" does NOT work, for SBERR=3D{32768,
> 98304,
> =C2=A0 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 409600=
0,
> =C2=A0 7962624} ( see https://pzt.me/1l55 )
>=20
> * "dumpe2fs -b $SBOK /dev/loop0" DOES (partly) work, for SBOK=3D{112394=
24,
> =C2=A0 20480000, 23887872, 71663616, 78675968, 214990848} ( see
> =C2=A0 https://pzt.me/6txz )
>=20
> * "mkfs.ext4 -S /dev/loop0" results in a completely empty filesystem
>=20
> * "fsck.ext4 -b $SBOK -B 4096 -v -n /dev/loop0" shows a lot of errors.
> =C2=A0 Filesystem isn't mountable afterwards ( see https://pzt.me/42yk =
and
> =C2=A0 https://pzt.me/3frg )
>=20
> * "fsck.ext4 -b $SBOK -B 4096 -v -y /dev/loop0" recoveres after a long
> time.
> =C2=A0 Filesystem is mountable. Root is empty besides lost+found folder=
,
> =C2=A0 which contains about 300GB mostly useless data: Millions of file=
s
> =C2=A0 with wrong permissions, useless names and some random content.
>=20
> * photorec from the testdisk package recoveres, luckily!, about 500GB o=
f
> =C2=A0 data. Though the content seems to be pretty reasonable, no filen=
ames
> =C2=A0 are recovered, since photorec operates without using filesystem
> =C2=A0 knowledge.
>=20
> Do you see any chances (besides consulting professional recovery
> companies) getting the filenames back? I looked into the ext4 specs a
> bit to figure out where this information is stored on disk, but before =
I
> step with hexedit through a terabyte of data, I'd rather try some
> solutions which are maybe already out there.

The best, simplest and safest plan I think, would be simply to format the=
=20
partition and restore from backup.


--=20
To UNSUBSCRIBE, email to debian-user-REQUEST@lists.debian.org=20
with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian=
.org
Archive: http://lists.debian.org/jh1kc6$nt9$1@dough.gmane.org
