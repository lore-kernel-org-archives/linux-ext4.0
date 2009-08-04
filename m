From: Valdis.Kletnieks@vt.edu
Subject: 31-rc4-mmotm0730 - ext4 whinge at shutdown
Date: Mon, 03 Aug 2009 20:58:16 -0400
Message-ID: <24577.1249347496@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249347496_4761P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47813 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZHDA6t (ORCPT
	<RFC822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 20:58:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1249347496_4761P
Content-Type: text/plain; charset=us-ascii

Got this at system shutdown, while trying to unmount one of three ext4 file
system (note - the filesystems were all originally ext3, mounted as ext4, if
that matters).

RFE - if it's going to print the mballoc stats, it should at least dump
a major/minor pair so that I can tell which of my 3 ext4 filesystems each
one is talking about. :)

[  297.865667] EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
[  297.868397] EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
[  297.871459] EXT4-fs: mballoc: 0 generated and it took 0
[  297.874532] EXT4-fs: mballoc: 0 preallocated, 0 discarded
[  297.900378] ------------[ cut here ]------------
[  297.903618] WARNING: at fs/namespace.c:611 mntput_no_expire+0xd8/0x145()
[  297.906962] Hardware name: Latitude D820
[  297.910231] Modules linked in: ext4 jbd2 crc16 [last unloaded: scsi_wait_scan]
[  297.913357] Pid: 1783, comm: umount Not tainted 2.6.31-rc4-mmotm0730 #6
[  297.916352] Call Trace:
[  297.918164]  [<ffffffff8103fb1d>] warn_slowpath_common+0x77/0x8f
[  297.919706]  [<ffffffff8103fb44>] warn_slowpath_null+0xf/0x11
[  297.921172]  [<ffffffff810e80bf>] mntput_no_expire+0xd8/0x145
[  297.922797]  [<ffffffff810e86d0>] sys_umount+0x2de/0x30d
[  297.924312]  [<ffffffff810669d6>] ? trace_hardirqs_on_caller+0x121/0x145
[  297.925776]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
[  297.927343] ---[ end trace 6987d23c89c53046 ]---
[  297.982931] EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
[  297.984651] EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
[  297.986141] EXT4-fs: mballoc: 0 generated and it took 0
[  297.987772] EXT4-fs: mballoc: 0 preallocated, 0 discarded
[  297.993872] EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
[  297.995383] EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
[  297.996974] EXT4-fs: mballoc: 0 generated and it took 0
[  297.998595] EXT4-fs: mballoc: 0 preallocated, 0 discarded
[  301.239272] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  301.244884] Restarting system.
[  301.247821] machine restart


--==_Exmh_1249347496_4761P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKd4eocC3lWbTT17ARAgObAKDh4GjHJuEwwPUeMfDN0/fzqjdfYQCgj7PS
P40E1fJmSU+bNgbgagMi0yM=
=skUW
-----END PGP SIGNATURE-----

--==_Exmh_1249347496_4761P--
