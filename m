From: Peng Tao <bergwolf@gmail.com>
Subject: donor file data inconsistent after EXT4_IOC_MOVE_EXT
Date: Sun, 18 Oct 2009 15:03:14 +0800
Message-ID: <4ADABDB2.6080905@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F193435AEE43ED28AA1DFC7"
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Kazuya Mio <k-mio@sx.jp.nec.com>, Theodore Ts'o <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51084 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZJRHD1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 03:03:27 -0400
Received: by pzk26 with SMTP id 26so2547439pzk.4
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 00:03:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F193435AEE43ED28AA1DFC7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

As I am looking more closely to the EXT4_IOC_MOVE_EXT ioctl, I found a
problem. The iotcl exchanges the block layout of the orig file and donor =
file
and then writes out orig file data to orig file's new blocks.
After the ioctl, the donor file would have the blocks previously owned by=
 the
orig file. But it turns out inconsistent.

A simple test case for revealing the bug:
The program a.out is calling EXT4_IOC_MOVE_EXT against argv[1] (as orig f=
ile)
and argv[2] (as donor file) and move_data.len =3D argv[1]'s block count.

And I am running mainline kernel 2.6.32-rc3 and the ext4 partition is mou=
nted
in ordered mode with default settings, if you are interested.

[bergwolf@move_extent]$sh test-5.sh=20
make full-img
=3D=3D=3D=3D=3D=3D=3D=3Dcreate full.img=3D=3D=3D=3D=3D=3D=3D=3D
dd if=3D/home/bergwolf/vm/OpenSolaris200805.iso of=3Dfull-1.img bs=3D1M c=
ount=3D30
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 0.0847457 s, 371 MB/s
dd if=3D"/home/bergwolf/vm/WINXP_EN_PRO_SP3_MSDN/WinXp+Sp3 enu.iso" of=3D=
full-2.img bs=3D1M count=3D30
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 0.0664263 s, 474 MB/s
md5sum full-1.img full-2.img
4f47bee75290d094c94f8a7cb2075c69  full-1.img
9e35330146a610d0aa2fab1d16aa2b09  full-2.img
=2E/a.out full-1.img full-2.img
md5sum full-1.img full-2.img
4f47bee75290d094c94f8a7cb2075c69  full-1.img
9e35330146a610d0aa2fab1d16aa2b09  full-2.img		<---- wrong content
[bergwolf@move_extent]$cd
[bergwolf@~]$sudo umount /other/
[bergwolf@~]$sudo mount /other/
[bergwolf@~]$cd -
/other/test/move_extent
[bergwolf@move_extent]$md5sum full-1.img full-2.img=20
4f47bee75290d094c94f8a7cb2075c69  full-1.img
4f47bee75290d094c94f8a7cb2075c69  full-2.img		<---- right result

I verified that the bug is because of the pagecache hit in the  vfs_read(=
),=20
via the following test case:

[bergwolf@move_extent]$sudo sh test-4.sh=20
make full-img
=3D=3D=3D=3D=3D=3D=3D=3Dcreate full.img=3D=3D=3D=3D=3D=3D=3D=3D
dd if=3D/home/bergwolf/vm/OpenSolaris200805.iso of=3Dfull-1.img bs=3D1M c=
ount=3D30
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 0.115624 s, 272 MB/s
dd if=3D"/home/bergwolf/vm/WINXP_EN_PRO_SP3_MSDN/WinXp+Sp3 enu.iso" of=3D=
full-2.img bs=3D1M count=3D30
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 1.16482 s, 27.0 MB/s
md5sum full-1.img full-2.img
4f47bee75290d094c94f8a7cb2075c69  full-1.img
9e35330146a610d0aa2fab1d16aa2b09  full-2.img
sync
echo 1 > /proc/sys/vm/drop_caches	<------- this drops all pagecaches, FYI=

=2E/a.out full-1.img full-2.img
md5sum full-1.img full-2.img
4f47bee75290d094c94f8a7cb2075c69  full-1.img
4f47bee75290d094c94f8a7cb2075c69  full-2.img

IIUC, this is because pagecache not uptodate.  FWIW, EXT4_IOC_MOVE_EXT
calls ext4_ext_invalidate_cache() to prevent later access to donor file r=
eading
old data. But if the data is already in the pagecache (in which case,
ext4_get_blocks() won't be called), vfs_read will still read the old data=
=2E
But I don't know if there is a way to discard all pagecache for a specifi=
c
inode. I tried to write something similar to ext4_da_block_invalidatepage=
s()
and ClearPageUptodate() on each page found in the mapping address,
but it didn't work.

So am I missing anything? And any hints how to force the following vfs_re=
ad()
to read from disk?

--=20
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.


--------------enig3F193435AEE43ED28AA1DFC7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkravbgACgkQEyny3P47hFGbhACcDnWaJP5ESUTSbZBz/58BTTo+
BKwAnRvvxdaDrzmbQw5Qn5Cq7bJ0NsUB
=dTmW
-----END PGP SIGNATURE-----

--------------enig3F193435AEE43ED28AA1DFC7--
