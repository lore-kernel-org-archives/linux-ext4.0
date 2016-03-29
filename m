From: Yves-Alexis Perez <corsac@debian.org>
Subject: Re: [oss-security] CVE Request - Linux kernel (multiple versions)
 ext2/ext3  filesystem DoS
Date: Tue, 29 Mar 2016 23:14:27 +0200
Message-ID: <1459286067.2596.18.camel@debian.org>
References: <f4df42b35dd9a6c8c6851eba66b2b3f1.squirrel@webmail-etu.univ-nantes.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Lp5X2vCG+FwzIQH9IURn"
To: oss-security@lists.openwall.com, Theodore Tso <tytso@google.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:54184 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbcC2VOo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2016 17:14:44 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id B1B912DFA7
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 23:14:36 +0200 (CEST)
Received: from molly.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20:ff:ff:fe00:5])
	by smtp3-g21.free.fr (Postfix) with ESMTPS id 4417BA6278
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 23:10:22 +0200 (CEST)
Received: from corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20:6af7:28ff:fe8d:2119])
	by molly.corsac.net (Postfix) with ESMTPS id C525C74
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 23:14:33 +0200 (CEST)
In-Reply-To: <f4df42b35dd9a6c8c6851eba66b2b3f1.squirrel@webmail-etu.univ-nantes.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-Lp5X2vCG+FwzIQH9IURn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[dropping MITRE from CC since it's not about the CVE]
[adding ext and Theodore to CC]

On mar., 2016-03-29 at 19:24 +0200, Hugues ANGUELKOV wrote:
> Hello,
>=20
> The linux kernel is prone to a Denial of service when mounting specially
> crafted ext2/ext3 (possibly ext4) filesystems. This occurs in the functio=
n
> ext4_handle_error who call the panic function on precise circumstance.

Did you contact the upstream maintainers about this? I'm adding them just i=
n
case they're not already aware of that=E2=80=A6

> This was tested on severals linux kernel version: 3.10, 3.18, 3.19, on
> real hardware and Xen DomU PV & HVM (the crash report attached is from a
> Fedora 3.18 PV DomU), from different distribution release: Ubuntu, CentOS=
,
> Fedora, Linux Mint, QubesOS.
> This a low security impact bug, because generally only root can mount
> image, however on Desktop (or possibly server?) system configured with
> automount the bug is easily triggable (think of android smartphone?Haven'=
t
> test yet).
> The crafted image may be burn onto SD card or USB key to crash a large
> panel of linux box.
>=20
>=20
> [ 929.200197] EXT4-fs error (device loop0): ext4_iget:4058: inode #2: com=
m
> mount: bad extended attribute block 8390656
> [ 929.200226] Kernel panic - not syncing: EXT4-fs (device loop0): panic
> forced after error
> [ 929.200226]
> [ 929.200230] CPU: 1 PID: 980 Comm: mount Tainted: G O
> 3.18.17-8.pvops.qubes.x86_64 #1
> [ 929.200233] 0000000000000000 000000007533690c ffff88000ea07aa8
> ffffffff81722191
> [ 929.200237] 0000000000000000 ffffffff81a84108 ffff88000ea07b28
> ffffffff8171a462
> [ 929.200240] ffff880000000010 ffff88000ea07b38 ffff88000ea07ad8
> 000000007533690c
> [ 929.200244] Call Trace:
> [ 929.200249] [<ffffffff81722191>] dump_stack+0x46/0x58
> [ 929.200253] [<ffffffff8171a462>] panic+0xd0/0x204
> [ 929.200257] [<ffffffff812ae4d6>] ext4_handle_error.part.188+0x96/0xa0
> [ 929.200260] [<ffffffff812ae838>] __ext4_error_inode+0xa8/0x180
> [ 929.200264] [<ffffffff81292869>] ext4_iget+0x929/0xae0
> [ 929.200267] [<ffffffff812b31fb>] ext4_fill_super+0x18db/0x2b60
> [ 929.200270] [<ffffffff8120af20>] mount_bdev+0x1b0/0x1f0
> [ 929.200273] [<ffffffff812b1920>] ? ext4_calculate_overhead+0x3d0/0x3d0
> [ 929.200276] [<ffffffff812a3425>] ext4_mount+0x15/0x20
> [ 929.200278] [<ffffffff8120b879>] mount_fs+0x39/0x1b0
> [ 929.200282] [<ffffffff811afd95>] ? __alloc_percpu+0x15/0x20
> [ 929.200285] [<ffffffff8122754b>] vfs_kern_mount+0x6b/0x110
> [ 929.200287] [<ffffffff8122a38c>] do_mount+0x22c/0xb60
> [ 929.200290] [<ffffffff811aab96>] ? memdup_user+0x46/0x80
> [ 929.200292] [<ffffffff8122b002>] SyS_mount+0xa2/0x110
> [ 929.200295] [<ffffffff8172a609>] system_call_fastpath+0x12/0x17
> [ 929.200301] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
> range: 0xffffffff80000000-0xffffffff9fffffff)c
>=20
> I cannot attach the PoC (2x2MB too large) nor sending it in plain text
> (they are filesystems), so I've uploaded it on this website of free file
> sharing ... (sorry for the inconvenient):
> poc.ext2 https://1fichier.com/?zbk2gohk8s
> poc.ext3 https://1fichier.com/?9r0c8agjfa
>=20
> Can you assign a CVE for this?
> Thank for reading and your time.
>=20
> Hugues ANGUELKOV.
>=20
>=20
--=20
Yves-Alexis


--=-Lp5X2vCG+FwzIQH9IURn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJW+vAzAAoJEG3bU/KmdcClKwwIAKW2h1RDCyNQDmfvRsh+gQ5k
244I/yBrkJJjRTQzgVQrpMwAk2HL8VqhgioS1nYciQgeV2cRZS7zi21iyB6+JATk
QMn5YBWVpcdXfcxD4TAulF+6Txry3F6UAsJLzRK6xMfDbnSI3FYX4aoNfC9AtFAo
lMPgPcPt2IeV6RX5x0Tahnw3Vg5XA4w3rh6cNFT1Gnq1OIbw5pw79ZgPJ5GSq0hs
+hGiCo34tuJsQgKDQy8mKwqxdwjH+HRtk7Rp3TlsVkSQdq65relEgQfm9e38gUG3
lKrLW6q3/H1bD2RIEojggDlGz++l1r8jl39VDoi4xAe/0NvZnBgklyXmGDzKyVg=
=a1P9
-----END PGP SIGNATURE-----

--=-Lp5X2vCG+FwzIQH9IURn--
