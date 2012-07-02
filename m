From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: ext4 blocks up
Date: Mon, 02 Jul 2012 17:54:22 +0300
Message-ID: <1341240862.2979.23.camel@sauron.fi.intel.com>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
	 <20120702144444.GA18074@thunk.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-16R9Pcz+T5kOPCjUGV7k"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120702144444.GA18074@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-16R9Pcz+T5kOPCjUGV7k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-02 at 10:44 -0400, Theodore Ts'o wrote:
> Can you tell me *which* xfstest this was blocking on?

Test 068 which runs fsstress.

$ ps axjf
  828   830   828   828 ?           -1 S      500   0:00  |   \_ sshd: dede=
kind@pts/0
  830   831   831   831 pts/0      972 Ss     500   0:00  |       \_ -bash
  831   972   972   831 pts/0      972 S+       0   0:00  |           \_ su=
do env PATH=3D/home/dedekind/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sb=
in:/usr/sbin:/sbin ./test-ext4.sh elog
  972   973   972   831 pts/0      972 S+       0   0:00  |               \=
_ /bin/sh -euf ./test-ext4.sh elog
  973   997   972   831 pts/0      972 S+       0   0:00  |                =
   \_ /bin/bash ./check -g auto
  997 14830   972   831 pts/0      972 S+       0   0:00  |                =
       \_ /bin/bash ./068
14830 15000   972   831 pts/0      972 S+       0   0:00  |                =
           \_ /bin/bash ./068
15000 15153 15153   831 pts/0      972 S        0   0:00  |                =
           |   \_ /home/dedekind/git/xfstests/ltp/fsstress -d /mnt/xfstests=
-disk-2/fsstress_test_dir -p 2 -n 200
15153 15154 15153   831 pts/0      972 D        0   0:00  |                =
           |       \_ /home/dedekind/git/xfstests/ltp/fsstress -d /mnt/xfst=
ests-disk-2/fsstress_test_dir -p 2 -n 200
15153 15155 15153   831 pts/0      972 D        0   0:00  |                =
           |       \_ /home/dedekind/git/xfstests/ltp/fsstress -d /mnt/xfst=
ests-disk-2/fsstress_test_dir -p 2 -n 200
14830 15170   972   831 pts/0      972 S+       0   0:00  |                =
           \_ /bin/sh -f /usr/sbin/xfs_freeze -u /mnt/xfstests-disk-2
15170 15174   972   831 pts/0      972 D+       0   0:00  |                =
           |   \_ /usr/sbin/xfs_io -F -r -p xfs_freeze -x -c thaw /mnt/xfst=
ests-disk-2
14830 15171   972   831 pts/0      972 S+       0   0:00  |                =
           \_ tee -a 068.full

--=20
Best Regards,
Artem Bityutskiy

--=-16R9Pcz+T5kOPCjUGV7k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8bYeAAoJECmIfjd9wqK0mVwQALlmacsR3jOX9V/EF9dJkV8h
QOINV8WB4iQJQM7Xg8Z3iQi/OL35/OB03jkYf3thL1AKU6SmI56Kpak6a8CM4DKd
NFyBSx9+l09jxRifRRtLV1+jOOtOmhd0XWGAvukh2ekqQ6AYYUEdv/T8UjSZFgT+
TCXazk51U2xyJ0Kj+ztyfaCYo/gLxP4YgRXosInq819PikDcbjUCpzc5pqxuVIT4
gsRggA2kaz3YDJFKisDpCDCSHg8a72JUCG9dS0n203aJfWr1ZoaUPzetIEs3Ajqc
X9RPNuge0Kb2f33O9IxR+m46CGUWoxtD9LjVzmSolTjdahzUpb890BdsDHLsg7y1
0SLAo98GarYhyxjgFreiDw59kR9DXYdAIm7vk2iCoMtzrqSQ+hETaNJaktvs8w/M
Gsc7CqCE7xoHiF7zBGLTGjDmNISZmbPNzZmw54pJ7811n1X8CuEQlhHoDb3rAqYK
ww0n4vLArJLrtJy+4W7bKJY3J/uOT0kfpUsaUDJuADM+pLJ/zLUJoUHRBlN1BaFm
skAkHNMgjH0A2PHxD5iaZza195JTdsPak+uOnVhhmOF9NJi+Ke5C7KgjGSqQrHge
onNPXi1Qm43q4mINmu1MgaOyiFEh/bBlukK71MStfbMJKJRNsfJC9ruDXmWRH/AU
hKnYYZCsHpDld7ZvRfez
=7zOh
-----END PGP SIGNATURE-----

--=-16R9Pcz+T5kOPCjUGV7k--

