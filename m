From: Sami Liedes <sami.liedes@iki.fi>
Subject: A very similar crash on ext2
Date: Fri, 10 Oct 2014 00:28:02 +0300
Message-ID: <20141009212802.GH27150@sli.dy.fi>
References: <20141005001239.GD27150@sli.dy.fi>
 <20141007205643.GF27150@sli.dy.fi>
 <20141009201541.GG27150@sli.dy.fi>
 <20141009204913.GA9620@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="z0eOaCaDLjvTGF2l"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:57335 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083AbaJIV2H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2014 17:28:07 -0400
Content-Disposition: inline
In-Reply-To: <20141009204913.GA9620@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--z0eOaCaDLjvTGF2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 01:49:13PM -0700, Darrick J. Wong wrote:
> Yeah.  There's a directory that's linked twice (inode 195).  The subseque=
nt FS
> walk loads the inode into memory twice (=3D=3D i_count > 2).  When you de=
lete
> everything on the FS, the inode gets put on the in-memory orphan list but=
 for
> whatever reason doesn't seem to get released via iput or something.  This=
 means
> it's still on the orphan list at umount time, which triggers the BUG.  Wo=
rse
> yet, i_nlink is now 0...
>=20
> ...not clear what the appropriate course of action is here.  The FS is co=
rrupt
> and we need to scrape the mess off the machine.  I guess you could -EIO e=
arlier
> when you notice i_count > i_nlink?

I don't know if this is exactly the same bug, but I'm also seeing a
similar crash on ext2 which also bisected to this exact same commit
(908790fa3b). The symptoms are a bit different, though; first a VFS
warning about busy inodes after unmount, then shortly after that a
crash.

Pristine fs: http://www.niksula.hut.fi/~sliedes/ext2/testimg.ext2.bz2

Broken fs: http://www.niksula.hut.fi/~sliedes/ext2/testimg.ext2.449.min.bz2

Diff:

--- /dev/fd/63  2014-10-10 00:20:59.562913594 +0300
+++ /dev/fd/62  2014-10-10 00:20:59.562913594 +0300
@@ -9785,6 +9785,8 @@
 0080a8f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 80  |.............=
=2E..|
 0080a900  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |.............=
=2E..|
 *
+0080ac20  ff ff ff ff ff ff ff ff  ff ff ff fd ff ff ff ff  |.............=
=2E..|
+0080ac30  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |.............=
=2E..|
 0080ac40  ff ff 01 00 00 00 00 00  00 00 00 00 00 00 00 00  |.............=
=2E..|
 0080ac50  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |.............=
=2E..|
 *

Backtrace:

[    1.422976] VFS: Busy inodes after unmount of vdb. Self-destruct in 5 se=
conds.  Have a nice day...
[    1.857020] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000197
[    1.858178] IP: [<ffffffff810a0859>] __lock_acquire.isra.31+0x199/0xd70
[    1.859047] PGD 633a067 PUD 5171067 PMD 0
[    1.859524] Oops: 0002 [#1] SMP
[    1.859842] CPU: 0 PID: 59 Comm: kworker/u2:1 Not tainted 3.16.0+ #94
[    1.860068] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    1.860068] Workqueue: writeback bdi_writeback_workfn (flush-254:16)
[    1.860068] task: ffff8800060f2060 ti: ffff880006104000 task.ti: ffff880=
006104000
[    1.860068] RIP: 0010:[<ffffffff810a0859>]  [<ffffffff810a0859>] __lock_=
acquire.isra.31+0x199/0xd70
[    1.860068] RSP: 0018:ffff880006107b28  EFLAGS: 00010086
[    1.860068] RAX: 0000000000000000 RBX: ffff8800060f2060 RCX: 00000000000=
00001
[    1.860068] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8800051=
cb0c8
[    1.860068] RBP: ffff880006107b90 R08: 0000000000000000 R09: 00000000000=
00000
[    1.860068] R10: ffff8800051cb0c8 R11: 0000000000000003 R12: 00000000000=
00001
[    1.860068] R13: 0000000000000001 R14: ffffffffffffffff R15: 00000000000=
00000
[    1.860068] FS:  0000000000000000(0000) GS:ffff880007c00000(0000) knlGS:=
0000000000000000
[    1.860068] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.860068] CR2: 0000000000000197 CR3: 000000000517c000 CR4: 00000000000=
006b0
[    1.860068] Stack:
[    1.860068]  ffff880006107b88 ffff8800060f2770 ffffffff81170027 00000000=
00000096
[    1.860068]  0000000000000000 0000000000000000 ffff8800060f2770 00000000=
0000003d
[    1.860068]  0000000000000286 0000000000000000 0000000000000001 00000000=
00000001
[    1.860068] Call Trace:
[    1.860068]  [<ffffffff81170027>] ? SyS_sysfs+0xf7/0x1e0
[    1.860068]  [<ffffffff810a1c46>] lock_acquire+0x96/0x130
[    1.860068]  [<ffffffff81152aaf>] ? grab_super_passive+0x3f/0x90
[    1.860068]  [<ffffffff8109e079>] down_read_trylock+0x59/0x60
[    1.860068]  [<ffffffff81152aaf>] ? grab_super_passive+0x3f/0x90
[    1.860068]  [<ffffffff81152aaf>] grab_super_passive+0x3f/0x90
[    1.860068]  [<ffffffff8117c837>] __writeback_inodes_wb+0x57/0xd0
[    1.860068]  [<ffffffff8117caeb>] wb_writeback+0x23b/0x320
[    1.860068]  [<ffffffff8117ceed>] bdi_writeback_workfn+0x1cd/0x470
[    1.860068]  [<ffffffff8107bf90>] process_one_work+0x1c0/0x580
[    1.860068]  [<ffffffff8107bf27>] ? process_one_work+0x157/0x580
[    1.860068]  [<ffffffff8107c3b3>] worker_thread+0x63/0x540
[    1.860068]  [<ffffffff8107c350>] ? process_one_work+0x580/0x580
[    1.860068]  [<ffffffff81081b81>] kthread+0xf1/0x110
[    1.860068]  [<ffffffff81081a90>] ? __kthread_parkme+0x70/0x70
[    1.860068]  [<ffffffff81850f2c>] ret_from_fork+0x7c/0xb0
[    1.860068]  [<ffffffff81081a90>] ? __kthread_parkme+0x70/0x70
[    1.860068] Code: 0b 00 00 48 c7 c7 25 cd c8 81 31 c0 e8 31 4a fc ff eb =
a7 0f 1f 80 00 00 00 00 44 89 f8 4d 8b 74 c2 08 4d 85 f6 0f 84 c2 fe ff ff =
<3e> 41 ff 86 98 01 00 00 8b 05 f1 57 96 01 44 8b bb 90 06 00 00
[    1.860068] RIP  [<ffffffff810a0859>] __lock_acquire.isra.31+0x199/0xd70
[    1.860068]  RSP <ffff880006107b28>
[    1.860068] CR2: 0000000000000197
[    1.860068] ---[ end trace 3d3d835bcb59d5fe ]---
[    1.860068] Kernel panic - not syncing: Fatal exception
[    1.860068] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[    1.860068] Rebooting in 1 seconds..

	Sami


> >=20
> > # first bad commit: [908790fa3b779d37365e6b28e3aa0f6e833020c3] dcache: =
d_splice_alias mustn't create directory aliases
> >=20
> > commit 908790fa3b779d37365e6b28e3aa0f6e833020c3
> > Author: J. Bruce Fields <bfields@redhat.com>
> > Date:   Mon Feb 17 17:58:42 2014 -0500
> >=20
> >     dcache: d_splice_alias mustn't create directory aliases
> >=20
> >     Currently if d_splice_alias finds a directory with an alias that is=
 not
> >     IS_ROOT or not DCACHE_DISCONNECTED, it creates a duplicate director=
y.
> >=20
> >     Duplicate directory dentries are unacceptable; it is better just to
> >     error out.
> >=20
> >     (In the case of a local filesystem the most likely case is filesyst=
em
> >     corruption: for example, perhaps two directories point to the same =
child
> >     directory, and the other parent has already been found and cached.)
> >=20
> >     Note that distributed filesystems may encounter this case in normal
> >     operation if a remote host moves a directory to a location different
> >     from the one we last cached in the dcache.  For that reason, such
> >     filesystems should instead use d_materialise_unique, which tries to=
 move
> >     the old directory alias to the right place instead of erroring out.
> >=20
> >     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >=20
> > --=20
> >=20
> > 	Sami
>=20
>=20

--z0eOaCaDLjvTGF2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUNv3iAAoJEKLT589SE0a0NEQP/jIuRSjNLI2BHwqQ4LBHvYGc
c8jsccZRdk7HnEbIvXOg8/s64/4bfT7ivmOSGBEV5MA5wUMIEj9iLIgcT9czNvw/
qJOW/OGZNobIEgICqpwXFA+BgH5C7CPTvWTK4lJsXGWo6vA9nDFhmhA4xPDbSMmD
wEhPTSZGqMy77g4tu3asF/23goUqaDchziVgdIthw3KygtyCf7ASQDmcHHQVsUXT
iDPJ39WwlZbDqo+uBxdlGQtoN/S8o9TdJylGpDL2M/X13xIN6iJKFBeotKtga+zg
rPRUYW7u5cadO43i/m2O4faEBYey9TRgB3gtdkdIbaRFT4R/iaAJaOtOdwEG/LgU
HpoDR+rTyZl5ji8TBJ5EmtdMx0/udYrCTQ75jFPfekcbgE0J7uZAX33R5kUxk5li
RnzHlJRv48BPjQdHOui0ug1NlkMjzIL80FTP8ixW1Wo6Wz882dnUOed3W4cmEtBb
AXcvb3BW4yfWa9Vw8+HLZAT7QDwYFMTE/uXnPqP1Q+VU6h7pqDBQLBj1KtEK6YEz
KmKTx2mlQGIoDd/J7DkNQLGIi4dtBxh2n2wzB784j4L/eP3ct+bMOQ0/3ur+EeWs
HmN1q1M0HmYQfDi0A3kgGgL5ZZ/nQ4duua4oCDc/kEdUL8TUNRtPvPy5SYZXpeXe
ccLwftuo0QKMVIBzPakU
=qaki
-----END PGP SIGNATURE-----

--z0eOaCaDLjvTGF2l--
