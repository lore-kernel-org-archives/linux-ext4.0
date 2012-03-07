From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: kernel BUG at fs/ext4/extents.c:2766!
Date: Wed, 7 Mar 2012 02:14:30 +0100
Message-ID: <20120307011430.GA613@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:3646 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301Ab2CGBwG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 20:52:06 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've got this Oops after I've created a file that filled up the
filesystem.

[  852.407974] ------------[ cut here ]------------
[  852.412105] kernel BUG at /build/buildd-linux-2.6_3.2.9-1-powerpc-xXyGnW=
/linux-2.6-3.2.9/debian/build/source_powerpc_none/fs/ext4/extents.c:2766!
[  852.433083] Oops: Exception in kernel mode, sig: 5 [#1]
[  852.436340] PowerMac
[  852.438523] Modules linked in: evdev ext4 crc16 jbd2 mbcache sr_mod cdro=
m virtio_net virtio_blk ata_generic pata_cmd64x virtio_pci virtio_ring virt=
io [last unloaded: scsi_wait_scan]
[  852.449271] NIP: c9297bbc LR: c9297f78 CTR: c011f92c
[  852.452964] REGS: c5ec5930 TRAP: 0700   Not tainted  (3.2.0-2-powerpc)
[  852.456848] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24002042  XER: 00000000
[  852.477461] TASK =3D c1cea170[425] 'flush-254:0' THREAD: c5ec4000
[  852.479210] GPR00: 00000001 c5ec59e0 c1cea170 00000001 c759e0e0 c1fc54e0=
 00000000 00000003=20
[  852.484825] GPR08: 00000000 00000000 c31ff018 c5ec5a50 24002024 00000000=
 01000000 00000000=20
[  852.490069] GPR16: 000007b5 00000000 00071800 00005800 00000000 00000001=
 c1fc54e0 00000000=20
[  852.495771] GPR24: 00000000 c1fc5500 c31ff00c 00000003 c1fc54e0 00000001=
 00000000 c759e0e0=20
[  852.523827] NIP [c9297bbc] ext4_split_extent_at+0xb4/0x340 [ext4]
[  852.528397] LR [c9297f78] ext4_split_extent+0x130/0x144 [ext4]
[  852.532979] Call Trace:
[  852.536640] [c5ec5a50] [c9297f78] ext4_split_extent+0x130/0x144 [ext4]
[  852.541230] [c5ec5a80] [c92988a4] ext4_ext_handle_uninitialized_extents+=
0x918/0xabc [ext4]
[  852.563059] [c5ec5b20] [c9298f44] ext4_ext_map_blocks+0x41c/0x142c [ext4]
[  852.569110] [c5ec5bf0] [c9271340] ext4_map_blocks+0x134/0x344 [ext4]
[  852.574558] [c5ec5c70] [c9275750] mpage_da_map_and_submit+0xe0/0x4f8 [ex=
t4]
[  852.579567] [c5ec5d00] [c92762b0] ext4_da_writepages+0x328/0x4f8 [ext4]
[  852.585242] [c5ec5db0] [c00c1534] do_writepages+0x30/0x58
[  852.590489] [c5ec5dc0] [c0116608] writeback_single_inode+0x128/0x2f8
[  852.613485] [c5ec5df0] [c0116acc] writeback_sb_inodes+0x144/0x1d0
[  852.619216] [c5ec5e60] [c0116bc0] __writeback_inodes_wb+0x68/0xac
[  852.624050] [c5ec5e90] [c0116d4c] wb_writeback+0x148/0x250
[  852.628820] [c5ec5ef0] [c01174b4] wb_do_writeback+0x1e4/0x218
[  852.633826] [c5ec5f60] [c0117594] bdi_writeback_thread+0xac/0x244
[  852.656169] [c5ec5fb0] [c005cc34] kthread+0x78/0x7c
[  852.662327] [c5ec5ff0] [c000f534] kernel_thread+0x4c/0x68
[  852.666968] Instruction dump:
[  852.670996] 5012421e 5012c00e a01a0006 5411c23e 5011442e 38000001 563104=
3e 419c0014=20
[  852.676786] 7c18a214 7c00f010 38000000 7c000114 <0f000000> 80990018 7fa3=
eb78 4bffd80d=20
[  852.683259] ---[ end trace 7771de8b04a49e96 ]---

[    0.000000] Linux version 3.2.0-2-powerpc (Debian 3.2.9-1) (debian-kerne=
l@lists.debian.org) (gcc version 4.6.2 (Debian 4.6.2-11) ) #1 Sun Mar 4 22:=
09:57 UTC 2012

The system was a virtual machine running with kvm/qemu.

Bye, J=F6rg.
--=20
Der Mensch hat die Atombombe erfunden.
Keine Maus der Welt k=E4me auf die Idee, eine Mausefalle zu konstruieren.

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9WtnYACgkQwe0mZwH1VIBUkACfaB4eK6Zx6/7sFiyaUEdP9DlY
L+QAoK+Vda+FA2Ly7DZyF9m3700b9EwN
=Ri1j
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
