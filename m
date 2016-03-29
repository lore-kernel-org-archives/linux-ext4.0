From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [oss-security] CVE Request - Linux kernel (multiple versions) ext2/ext3  filesystem DoS
Date: Tue, 29 Mar 2016 16:56:11 -0600
Message-ID: <57514A3C-DBAD-4E5E-98EA-23E490629C02@dilger.ca>
References: <f4df42b35dd9a6c8c6851eba66b2b3f1.squirrel@webmail-etu.univ-nantes.fr> <1459286067.2596.18.camel@debian.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F4A8B62D-5607-473B-AD03-C48DC1434B0F"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: oss-security@lists.openwall.com, Theodore Tso <tytso@google.com>,
	linux-ext4@vger.kernel.org
To: Yves-Alexis Perez <corsac@debian.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33767 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbcC2W4R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2016 18:56:17 -0400
Received: by mail-io0-f176.google.com with SMTP id a129so42384371ioe.0
        for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 15:56:16 -0700 (PDT)
In-Reply-To: <1459286067.2596.18.camel@debian.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F4A8B62D-5607-473B-AD03-C48DC1434B0F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Mar 29, 2016, at 3:14 PM, Yves-Alexis Perez <corsac@debian.org> =
wrote:
>=20
> [dropping MITRE from CC since it's not about the CVE]
> [adding ext and Theodore to CC]
>=20
> On mar., 2016-03-29 at 19:24 +0200, Hugues ANGUELKOV wrote:
>> Hello,
>>=20
>> The linux kernel is prone to a Denial of service when mounting =
specially
>> crafted ext2/ext3 (possibly ext4) filesystems. This occurs in the =
function
>> ext4_handle_error who call the panic function on precise =
circumstance.
>=20
> Did you contact the upstream maintainers about this? I'm adding them =
just in
> case they're not already aware of that=E2=80=A6
>=20
>> This was tested on severals linux kernel version: 3.10, 3.18, 3.19, =
on
>> real hardware and Xen DomU PV & HVM (the crash report attached is =
from a
>> Fedora 3.18 PV DomU), from different distribution release: Ubuntu, =
CentOS,
>> Fedora, Linux Mint, QubesOS.
>> This a low security impact bug, because generally only root can mount
>> image, however on Desktop (or possibly server?) system configured =
with
>> automount the bug is easily triggable (think of android smartphone? =
Haven't
>> test yet).

It seems that the important point here is that the filesystem has
"s_errors=3DEXT4_ERRORS_PANIC" set in the superblock?  I don't think
the actual corruption that triggered the ext4_error() call is important,
since there are any number of other failure cases that could generate
a similar error.

It seems practical to change s_errors at mount time from =
EXT4_ERRORS_PANIC
to EXT4_ERRORS_RO for filesystems mounted by regular users.  The =
question
is whether there is a way for the ext4 code to know this at mount time?

Cheers, Andreas

>> The crafted image may be burn onto SD card or USB key to crash a =
large
>> panel of linux box.
>>=20
>>=20
>> [ 929.200197] EXT4-fs error (device loop0): ext4_iget:4058: inode #2: =
comm
>> mount: bad extended attribute block 8390656
>> [ 929.200226] Kernel panic - not syncing: EXT4-fs (device loop0): =
panic
>> forced after error
>> [ 929.200226]
>> [ 929.200230] CPU: 1 PID: 980 Comm: mount Tainted: G O
>> 3.18.17-8.pvops.qubes.x86_64 #1
>> [ 929.200233] 0000000000000000 000000007533690c ffff88000ea07aa8
>> ffffffff81722191
>> [ 929.200237] 0000000000000000 ffffffff81a84108 ffff88000ea07b28
>> ffffffff8171a462
>> [ 929.200240] ffff880000000010 ffff88000ea07b38 ffff88000ea07ad8
>> 000000007533690c
>> [ 929.200244] Call Trace:
>> [ 929.200249] [<ffffffff81722191>] dump_stack+0x46/0x58
>> [ 929.200253] [<ffffffff8171a462>] panic+0xd0/0x204
>> [ 929.200257] [<ffffffff812ae4d6>] =
ext4_handle_error.part.188+0x96/0xa0
>> [ 929.200260] [<ffffffff812ae838>] __ext4_error_inode+0xa8/0x180
>> [ 929.200264] [<ffffffff81292869>] ext4_iget+0x929/0xae0
>> [ 929.200267] [<ffffffff812b31fb>] ext4_fill_super+0x18db/0x2b60
>> [ 929.200270] [<ffffffff8120af20>] mount_bdev+0x1b0/0x1f0
>> [ 929.200273] [<ffffffff812b1920>] ? =
ext4_calculate_overhead+0x3d0/0x3d0
>> [ 929.200276] [<ffffffff812a3425>] ext4_mount+0x15/0x20
>> [ 929.200278] [<ffffffff8120b879>] mount_fs+0x39/0x1b0
>> [ 929.200282] [<ffffffff811afd95>] ? __alloc_percpu+0x15/0x20
>> [ 929.200285] [<ffffffff8122754b>] vfs_kern_mount+0x6b/0x110
>> [ 929.200287] [<ffffffff8122a38c>] do_mount+0x22c/0xb60
>> [ 929.200290] [<ffffffff811aab96>] ? memdup_user+0x46/0x80
>> [ 929.200292] [<ffffffff8122b002>] SyS_mount+0xa2/0x110
>> [ 929.200295] [<ffffffff8172a609>] system_call_fastpath+0x12/0x17
>> [ 929.200301] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
>> range: 0xffffffff80000000-0xffffffff9fffffff)c
>>=20
>> I cannot attach the PoC (2x2MB too large) nor sending it in plain =
text
>> (they are filesystems), so I've uploaded it on this website of free =
file
>> sharing ... (sorry for the inconvenient):
>> poc.ext2 https://1fichier.com/?zbk2gohk8s
>> poc.ext3 https://1fichier.com/?9r0c8agjfa
>>=20
>> Can you assign a CVE for this?
>> Thank for reading and your time.
>>=20
>> Hugues ANGUELKOV.
>>=20
>>=20
> --
> Yves-Alexis
>=20


Cheers, Andreas






--Apple-Mail=_F4A8B62D-5607-473B-AD03-C48DC1434B0F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVvsIDHKl2rkXzB/gAQhiaw//cakn6bzIj8DPGH4rY+H4dAcAOcsVySJH
2enkXEdzXCHsNpTaWaS37e3n/7pbT1Z7uBt6bNbo0HX6ElwphSy/mntAYJFfL0M7
nejcGjwdLuguT67HRv6JCB1KH7JqFbRbMnnFHEZqj5g8t2FoRHVi0weB9OBsFhDc
IjYuW9icnAESglrkwRoXB2+3BVkokF3J4hSrh0lVPVndgs4LIDpq2Dh6ZvRJDb7h
x/MlxjjfUgGQbIu7qj6BoSrfwpW6C/xV/eMrq+nwo9idq3dR99jl7h4rROr70yLP
4SSe6pxK3ssQmpiMA/7oW+GorLNS9C7u6YZPzysP/gksIrKQD5KLtxH9LjMXTQtY
LNa+jc2VIiAG+bRco95DWkwJjsmf0HFht7wovQ9wKewLDDBjKS5s3lyT65sRo7g/
otKiLPOa3ASua7agFcNUsMAIGS12vWycfXHY75HCUcZghYuOwBYxbb2KxBuNFIFQ
cGrkiY/Awy4wKALsS3k4lqWHGcN3isSJ7VbOGzqm4LrYo7shIEFcUVlVqfaR06HT
lDqXtrTK6ncXkHEHwUYaFwP70ucxRGtk/OhO3mtZNyfflosJyxPuQl/Krbk6BTwF
hnKiuZDIwUUBvxns5kaBGcazlbHClyuc86mNXpElMIndaU5j4z0pScxllrJmLnHR
e6XjV1o70AQ=
=7tcj
-----END PGP SIGNATURE-----

--Apple-Mail=_F4A8B62D-5607-473B-AD03-C48DC1434B0F--
