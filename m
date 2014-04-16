From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4_orphan_cleanup errors during mount a LVM snapshot
Date: Wed, 16 Apr 2014 10:33:22 -0600
Message-ID: <1804D95E-CD91-41A3-8177-E3E585C9E1E6@dilger.ca>
References: <CAGj=0YK3GGuis-jCYT-Rr9LCCg3_xjsYWi-20syTPy7Q8NX3LQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_003204B4-2CF6-408B-A61A-E909F5858EAD"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Wayne Chou <gmmark12@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62638 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDPQdd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 12:33:33 -0400
Received: by mail-pd0-f175.google.com with SMTP id x10so10922792pdj.20
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 09:33:33 -0700 (PDT)
In-Reply-To: <CAGj=0YK3GGuis-jCYT-Rr9LCCg3_xjsYWi-20syTPy7Q8NX3LQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_003204B4-2CF6-408B-A61A-E909F5858EAD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 16, 2014, at 2:46 AM, Wayne Chou <gmmark12@gmail.com> wrote:
> I create a LVM snapshot from a mounted ext4 file system by:
> "lvcreate -kn --snapshot --name snap1 /dev/mapper/vg1/lv1"
>=20
> And after I mount this snapshot to another folder like:
> "mount -t ext4 /dev/mapper/vg1-snap1 /mnt/test"
> the following messages prompted in dmesg:
>=20
> [ 2445.480908] EXT4-fs (dm-6): orphan cleanup on readonly fs
> [ 2445.502317] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
> unreferenced inode 131180
> [ 2445.502355] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
> unreferenced inode 131176
> [ 2445.502360] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
> unreferenced inode 131175
> [ 2445.502366] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
> unreferenced inode 131174
> [ 2445.502372] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
> unreferenced inode 131173
> [ 2445.502376] EXT4-fs (dm-6): 5 orphan inodes deleted

The first question is whether you are experiencing any actual problems
as a result of the orphan inode cleanup?  This is normal behaviour if
there are applications with open-unlinked files when the snapshot is =
taken,
or if the system crashes at this point.  The orphan cleanup will free up
these open-unlinked inodes and their blocks at mount time, keeping the
filesystem consistent.

> To find out what the reason is, I use 'lsof' on lv1's mount point =
before I take
> the snapshot.  Then I got some MySQL services that opened these =
temporary files
> which causes the orphan inodes in LVM snapshots:
> mysqld    26257 admin    7u   REG  253,5        0 131173
> /LV1/.system/tmp/ibTidhzb (deleted)
> mysqld    26257 admin    8u   REG  253,5        0 131174
> /LV1/.system/tmp/ibgWhCYc (deleted)
> mysqld    26257 admin    9u   REG  253,5        0 131175
> /LV1/.system/tmp/ibJE5pne (deleted)
> mysqld    26257 admin   10u   REG  253,5        0 131176
> /LV1/.system/tmp/ibsvL9hg (deleted)
> mysqld    26257 admin   14u   REG  253,5        0 131180
> /LV1/.system/tmp/ibcz1qOM (deleted)
>=20
>=20
> =46rom the above investigation, the problem gets solved if I
> disable the MySQL service before taking the LVM snapshot.
>=20
> However, I wonder if there's any other way to solve this issue.
> For example, can I just blindly remove these orphan inodes when
> ext4_freeze() is called?  Thank you.

What problem needs to be solved?  Is it just the printing of these
error messages that is confusing, or something else?

Cheers, Andreas






--Apple-Mail=_003204B4-2CF6-408B-A61A-E909F5858EAD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU06w0nKl2rkXzB/gAQJdjxAArrDc7kIJD6hyowN/Hb85YdK1+NAnIWz0
C1FoK7WIV6pQxoqBjMcTQnDFS605KpDVDky2wdzCbHk6Z6b6UqNZo35v3TCXTd9u
y1N1A418sEV20Wi8OS9vGVqXauTv579DhwF5oAZW49/jJv3f7rEqNNmDaoImadtM
0t3+PbOZGDKmAq/Q2drOVAus/fwCDb6Ch1RvQyVaKvgUf1LnEU/ImAkz4nmH73pl
Je7KBkiXtyWFxGLUckT0mQJn5elpqU7wqmE9EOvWhP8V3QwzmE1ieM7NseIb+FOb
ckFmrxD6/Wmu8Z2qQDvHoWkIHIj57kNeeJrB7+2JY9Xdv668132F5UkoteLLXtbc
T6yHpXPfrKnfeQTbWoOjqUCZJ0f46atkOXmRGkCtStAPRuJ1r1zlwaUyKqeiHhgJ
kng1v1TBJmdsP1Gas/BHJ+roGH2rC+9n18oMJF8QzBeCYsT61iyxbcQ9dHJw8A1l
Cf2gr3uXiGy88kqZo2RRytRZwrQRLC1vSdAZD4JoBA0FnIddzqwzpBqQm2NXrYaf
asJILY/KU/0qAannyUN08IGH19VoFOZBHdCcHn4uYsjhhcmsfQInaiSh7QS74GYc
rK1BNKA6RRKmBBcXnKRyAf/CzggMJPTAPCu3Dy3FbWCNmcSx5ZI6eYKaDTuiGPXb
0keacI7tjFo=
=pWQO
-----END PGP SIGNATURE-----

--Apple-Mail=_003204B4-2CF6-408B-A61A-E909F5858EAD--
