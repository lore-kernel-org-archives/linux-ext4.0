From: Eric Blake <eblake@redhat.com>
Subject: Re: [Qemu-devel] (v2. forward to qemu )-Panic with ext4, nbd,
 qemu-img, block
Date: Thu, 25 Jan 2018 08:58:39 -0600
Message-ID: <77c33c7b-fb3d-27e7-a694-c0fe5f34e036@redhat.com>
References: <4ac7d86b-d96d-ef75-6965-284c527cde9b@windriver.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bDqO61JGggrCnogO4Bpau2MBb8A8ZyJqp"
Cc: linux-block@vger.kernel.org, qemu-discuss@nongnu.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
To: "Hongzhi, Song" <hongzhi.song@windriver.com>, qemu-block@nongnu.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ac7d86b-d96d-ef75-6965-284c527cde9b@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bDqO61JGggrCnogO4Bpau2MBb8A8ZyJqp
Content-Type: multipart/mixed; boundary="xTkWl5vnnzWx3QB5YDgCVRFF7oRL4eNPo";
 protected-headers="v1"
From: Eric Blake <eblake@redhat.com>
To: "Hongzhi, Song" <hongzhi.song@windriver.com>, qemu-block@nongnu.org
Cc: linux-block@vger.kernel.org, qemu-discuss@nongnu.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 qemu-devel@nongnu.org
Message-ID: <77c33c7b-fb3d-27e7-a694-c0fe5f34e036@redhat.com>
Subject: Re: [Qemu-devel] (v2. forward to qemu )-Panic with ext4, nbd,
 qemu-img, block
References: <4ac7d86b-d96d-ef75-6965-284c527cde9b@windriver.com>
In-Reply-To: <4ac7d86b-d96d-ef75-6965-284c527cde9b@windriver.com>

--xTkWl5vnnzWx3QB5YDgCVRFF7oRL4eNPo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/21/2018 08:06 PM, Hongzhi, Song wrote:
> Hello,
>=20
> I create a virtual disk-image using qemu-img.
>=20
> And then I use /dev/nbd to map the image.
>=20
> I mount the /dev/nbd to a local dir with ext4-format
>=20
> Finally, I have some trouble about ext4-filesystem and block device,
> with using demand of rsync or dd to write the image.
>=20
> Reproduce :
>=20
> =C2=A0=C2=A0=C2=A0 qemu-img create test.img 2G
>=20
> =C2=A0=C2=A0=C2=A0 mkfs.ext4 -F test.img
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 qemu-nbd -f raw -c /dev/nbd0 test.img
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 mount -r ext4 /dev/nbd0 LOCAL_DIR/
>=20
> =C2=A0=C2=A0=C2=A0 rsync -av META_DATA_DIR/=C2=A0 LOCAL_DIR/
>=20
> Qemu Version:
>=20
> =C2=A0=C2=A0=C2=A0 QEMU emulator version 2.10.0

There have been some bug fixes in the NBD code in qemu 2.11; does using
a newer version make a difference in your results?


> Detail:
>=20
>=20
> 329.11 EXT4-fs (nbd0): mounted filesystem with ordered data mode. Opts:=

> (null)
> 329.12 block nbd0: Connection timed out
> 329.13 block nbd0: shutting down sockets

This sounds like a log of the kernel side; but it is rather sparse on
details on why the kernel lost the connection to the socket provided by
qemu-nbd -c.  Is there any chance we can get a corresponding trace from
qemu-nbd when reproducing the lost connection?

> 329.14 blk_update_request: I/O error, dev nbd0, sector 304384
> 329.15 blk_update_request: I/O error, dev nbd0, sector 304640
> 329.16 blk_update_request: I/O error, dev nbd0, sector 304896
> 329.17 blk_update_request: I/O error, dev nbd0, sector 305152
> 329.18 blk_update_request: I/O error, dev nbd0, sector 305408
> 329.19 blk_update_request: I/O error, dev nbd0, sector 305664
> 329.20 blk_update_request: I/O error, dev nbd0, sector 305920
> 329.21 blk_update_request: I/O error, dev nbd0, sector 306176
> 329.22 blk_update_request: I/O error, dev nbd0, sector 306432
> 329.23 blk_update_request: I/O error, dev nbd0, sector 306688
> 329.24 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5
> writing to inode 160 (offset 8388608 size 8388608 starting block 38400)=


Everything else in the trace looks like fallout from the initial lost
connection - once the kernel can't communicate to the NBD server, it has
to fail all pending and subsequent I/O requests to /dev/nbd0.  But until
we can figure out why the connection is dropped, seeing this part of the
trace doesn't add any information about the root cause.

But oddly enough, once things go south in the kernel nbd module, it
leads to a full-on kernel bug:

> GRNDSDP1.86B.0036.R05.1407140519 07/14/2014
> 329.51 Workqueue: writeback wb_workfn (flush-43:0)
> 329.52 task: ffff977bec759e00 task.stack: ffffa2930524c000
> 329.53 RIP: 0010:submit_bh_wbc+0x155/0x160
> 329.54 RSP: 0018:ffffa2930524f7e0 EFLAGS: 00010246
> 329.55 RAX: 0000000000620005 RBX: ffff977f05cddc18 RCX: 000000000000000=
0
> 329.56 RDX: ffff977f05cddc18 RSI: 0000000000020800 RDI: 000000000000000=
1
> 329.57 RBP: ffffa2930524f808 R08: ff00000000000000 R09: 00fffffffffffff=
f
> 329.58 R10: ffffa2930524f920 R11: 000000000000058c R12: 000000000000a59=
8
> 329.59 R13: ffffffffba15c500 R14: ffff977fe1bab400 R15: ffff977fea64300=
0
> 329.60 FS: 0000000000000000(0000) GS:ffff977befa00000(0000)
> knlGS:0000000000000000
> 329.61 CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 329.62 CR2: 00007f7d70000010 CR3: 000000035ce0e000 CR4: 00000000001406e=
0
> 329.63 Call Trace:
> 329.64 __sync_dirty_buffer+0x41/0xa0
> 329.65 ext4_commit_super+0x1d6/0x2a0
> 329.66 __ext4_error_inode+0xb2/0x170

> 329.99 JBD2: Error -5 detected when updating journal superblock for nbd=
0-8.
> 329.100 Aborting journal on device nbd0-8.
> 329.101 ------------[ cut here ]------------
> 329.102 kernel BUG at /kernel-source//fs/buffer.c:3091!

Well, that should certainly be reported to the kernel folks; nothing
qemu can do about it (a userspace socket serving NBD data should not be
able to cause the kernel NBD client to result in a subsequent kernel
crash, regardless of how bad data loss is when the socket disappears out
from under the kernel).

--=20
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org


--xTkWl5vnnzWx3QB5YDgCVRFF7oRL4eNPo--

--bDqO61JGggrCnogO4Bpau2MBb8A8ZyJqp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEzBAEBCAAdFiEEccLMIrHEYCkn0vOqp6FrSiUnQ2oFAlpp8J8ACgkQp6FrSiUn
Q2rJ9wf8CB3dBoOdh+ZFyOYO1q88ZMUg0V4AzZiO49oAvk5yAu9Sq5KdZZDqelQH
I19yN+X/McmAF+qOhebmIl0jqa0XB2Rc8En5KewCtpiqHSsxLRewe/AhwDQmKGJZ
QVeG/JjqJMg7SaNsR/NnzAfte94IthCbe7tH/KEZhr+gHX/g5PqmWCB1o7H9W9BB
PNsWrvZdglzrQO9Gc/w3E0kediwsEQZMMdAzp8vWrFOjhyZaIrtoZRnG9k723xyI
I2BKPaBgIoLdZbiqAStNf/JaO5b4RJjIlTuI9t3n+WgiE3rYd/st04yxOBFddZj1
B6YJybA+/mHGx4Qa49O14Wfkj3YyEw==
=1XT1
-----END PGP SIGNATURE-----

--bDqO61JGggrCnogO4Bpau2MBb8A8ZyJqp--
