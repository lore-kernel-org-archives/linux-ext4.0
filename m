From: Dieter Ries <mail@dieterries.net>
Subject: kjournald and flush being blocked for 120 sec
Date: Mon, 2 Aug 2010 09:02:20 +0200
Message-ID: <20100802070220.GA32114@Localhorst.asterix.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([188.40.92.130]:42576 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0HBHLL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Aug 2010 03:11:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi there.

I recently got a new server, 4 x Opteron 6128 on a Supermicro H8QGi+-F
board, AMD SP5100 chipset, 3 S-ATA disks, one 500GB WD RE3 for system=20
and 2 identical 2TB Hitachi for data.

Creating a MD Raid 1 on the 2 2TB drives took 4 days, and now when I dd
zeroes to a LVM Partitioni, ext3 fs, on the raid, performance ist good=20
for the first ~4 GB, but then it gets horribly slow, sometimes stalls.=20
In the end I get write rates of about 20MB/s, and this in dmesg:

[  484.128146] INFO: task kjournald:2496 blocked for more than 120 seconds.
[  484.128286] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  484.128420] kjournald     D 00000000ffffdaac     0  2496      2 0x000000=
00
[  484.128427]  ffff88022650c420 0000000000000046 ffff880625721800 00000000=
00000000
[  484.128431]  ffffffff81632020 0000000000015300 0000000000015300 00000000=
00015300
[  484.128435]  ffff880224431fd8 0000000000015300 ffff88022650c420 ffff8802=
24431fd8
[  484.128439] Call Trace:
[  484.128452]  [<ffffffff8100f52e>] ? read_tsc+0x5/0x16
[  484.128459]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  484.128466]  [<ffffffff8136a3e8>] ? io_schedule+0x6b/0xaa
[  484.128469]  [<ffffffff81106a5d>] ? sync_buffer+0x3b/0x3f
[  484.128473]  [<ffffffff8136a931>] ? __wait_on_bit+0x3e/0x6f
[  484.128477]  [<ffffffff8136a9d0>] ? out_of_line_wait_on_bit+0x6e/0x77
[  484.128480]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  484.128486]  [<ffffffff8105cdeb>] ? wake_bit_function+0x0/0x2e
[  484.128489]  [<ffffffff811069bb>] ? wait_on_buffer+0xe/0x2d
[  484.128493]  [<ffffffff81106f4e>] ? sync_dirty_buffer+0x58/0x8f
[  484.128498]  [<ffffffff8115a254>] ? journal_commit_transaction+0xa8e/0xd=
ee
[  484.128502]  [<ffffffff8105cdc1>] ? autoremove_wake_function+0x0/0x2a
[  484.128506]  [<ffffffff8115cef4>] ? kjournald+0xde/0x220
[  484.128510]  [<ffffffff8105cdc1>] ? autoremove_wake_function+0x0/0x2a
[  484.128513]  [<ffffffff8115ce16>] ? kjournald+0x0/0x220
[  484.128516]  [<ffffffff8105c96d>] ? kthread+0x75/0x7d
[  484.128520]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[  484.128523]  [<ffffffff8105c8f8>] ? kthread+0x0/0x7d
[  484.128526]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[  604.128155] INFO: task kjournald:2496 blocked for more than 120 seconds.
[  604.128270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  604.128404] kjournald     D 00000000ffffdaac     0  2496      2 0x000000=
00
[  604.128410]  ffff88022650c420 0000000000000046 ffff880625721800 00000000=
00000000
[  604.128414]  ffffffff81632020 0000000000015300 0000000000015300 00000000=
00015300
[  604.128417]  ffff880224431fd8 0000000000015300 ffff88022650c420 ffff8802=
24431fd8
[  604.128421] Call Trace:
[  604.128434]  [<ffffffff8100f52e>] ? read_tsc+0x5/0x16
[  604.128440]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  604.128447]  [<ffffffff8136a3e8>] ? io_schedule+0x6b/0xaa
[  604.128450]  [<ffffffff81106a5d>] ? sync_buffer+0x3b/0x3f
[  604.128453]  [<ffffffff8136a931>] ? __wait_on_bit+0x3e/0x6f
[  604.128457]  [<ffffffff8136a9d0>] ? out_of_line_wait_on_bit+0x6e/0x77
[  604.128460]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  604.128467]  [<ffffffff8105cdeb>] ? wake_bit_function+0x0/0x2e
[  604.128470]  [<ffffffff811069bb>] ? wait_on_buffer+0xe/0x2d
[  604.128473]  [<ffffffff81106f4e>] ? sync_dirty_buffer+0x58/0x8f
[  604.128478]  [<ffffffff8115a254>] ? journal_commit_transaction+0xa8e/0xd=
ee
[  604.128482]  [<ffffffff8105cdc1>] ? autoremove_wake_function+0x0/0x2a
[  604.128486]  [<ffffffff8115cef4>] ? kjournald+0xde/0x220
[  604.128490]  [<ffffffff8105cdc1>] ? autoremove_wake_function+0x0/0x2a
[  604.128493]  [<ffffffff8115ce16>] ? kjournald+0x0/0x220
[  604.128496]  [<ffffffff8105c96d>] ? kthread+0x75/0x7d
[  604.128500]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[  604.128503]  [<ffffffff8105c8f8>] ? kthread+0x0/0x7d
[  604.128506]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[  844.128070] INFO: task flush-253:3:1753 blocked for more than 120 second=
s.
[  844.128184] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  844.128318] flush-253:3   D 000000010001618e     0  1753      2 0x000000=
00
[  844.128323]  ffff88022650d890 0000000000000046 ffff880625721800 00000000=
00000000
[  844.128327]  ffff880226d00da0 0000000000015300 0000000000015300 00000000=
00015300
[  844.128331]  ffff880226555fd8 0000000000015300 ffff88022650d890 ffff8802=
26555fd8
[  844.128335] Call Trace:
[  844.128345]  [<ffffffff8100f52e>] ? read_tsc+0x5/0x16
[  844.128351]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  844.128355]  [<ffffffff81106c5a>] ? end_buffer_async_write+0x0/0x129
[  844.128360]  [<ffffffff8136a3e8>] ? io_schedule+0x6b/0xaa
[  844.128363]  [<ffffffff81106a5d>] ? sync_buffer+0x3b/0x3f
[  844.128367]  [<ffffffff8136a833>] ? __wait_on_bit_lock+0x3c/0x85
[  844.128373]  [<ffffffff811aac20>] ? __lookup_tag+0xc9/0x13a
[  844.128376]  [<ffffffff8136a8ea>] ? out_of_line_wait_on_bit_lock+0x6e/0x=
77
[  844.128380]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  844.128385]  [<ffffffff8105cdeb>] ? wake_bit_function+0x0/0x2e
[  844.128388]  [<ffffffff81106eaf>] ? lock_buffer+0xe/0x2c
[  844.128391]  [<ffffffff811070e0>] ? __block_write_full_page+0x15b/0x2a8
[  844.128397]  [<ffffffff810b3e76>] ? __writepage+0xa/0x21
[  844.128400]  [<ffffffff810b4ef0>] ? write_cache_pages+0x1d8/0x2f1
[  844.128403]  [<ffffffff810b3e6c>] ? __writepage+0x0/0x21
[  844.128410]  [<ffffffff8110054c>] ? writeback_single_inode+0xd1/0x2e5
[  844.128413]  [<ffffffff81100ab6>] ? writeback_sb_inodes+0x136/0x204
[  844.128417]  [<ffffffff8110115b>] ? writeback_inodes_wb+0x127/0x139
[  844.128421]  [<ffffffff811012fb>] ? wb_writeback+0x18e/0x208
[  844.128424]  [<ffffffff811013d8>] ? wb_do_writeback+0x63/0x149
[  844.128428]  [<ffffffff811014a8>] ? wb_do_writeback+0x133/0x149
[  844.128432]  [<ffffffff811014f8>] ? bdi_writeback_task+0x3a/0x113
[  844.128435]  [<ffffffff8105cce7>] ? bit_waitqueue+0x14/0xa1
[  844.128440]  [<ffffffff810c0513>] ? bdi_start_fn+0x0/0xc3
[  844.128443]  [<ffffffff810c0576>] ? bdi_start_fn+0x63/0xc3
[  844.128446]  [<ffffffff810c0513>] ? bdi_start_fn+0x0/0xc3
[  844.128449]  [<ffffffff8105c96d>] ? kthread+0x75/0x7d
[  844.128452]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[  844.128456]  [<ffffffff8105c8f8>] ? kthread+0x0/0x7d
[  844.128459]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[  964.128053] INFO: task flush-253:3:1753 blocked for more than 120 second=
s.
[  964.128187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  964.128321] flush-253:3   D 000000010001618e     0  1753      2 0x000000=
00
[  964.128325]  ffff88022650d890 0000000000000046 ffff880625721800 00000000=
00000000
[  964.128329]  ffff880226d00da0 0000000000015300 0000000000015300 00000000=
00015300
[  964.128332]  ffff880226555fd8 0000000000015300 ffff88022650d890 ffff8802=
26555fd8
[  964.128336] Call Trace:
[  964.128344]  [<ffffffff8100f52e>] ? read_tsc+0x5/0x16
[  964.128347]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  964.128351]  [<ffffffff81106c5a>] ? end_buffer_async_write+0x0/0x129
[  964.128355]  [<ffffffff8136a3e8>] ? io_schedule+0x6b/0xaa
[  964.128358]  [<ffffffff81106a5d>] ? sync_buffer+0x3b/0x3f
[  964.128361]  [<ffffffff8136a833>] ? __wait_on_bit_lock+0x3c/0x85
[  964.128364]  [<ffffffff811aac20>] ? __lookup_tag+0xc9/0x13a
[  964.128368]  [<ffffffff8136a8ea>] ? out_of_line_wait_on_bit_lock+0x6e/0x=
77
[  964.128371]  [<ffffffff81106a22>] ? sync_buffer+0x0/0x3f
[  964.128375]  [<ffffffff8105cdeb>] ? wake_bit_function+0x0/0x2e
[  964.128378]  [<ffffffff81106eaf>] ? lock_buffer+0xe/0x2c
[  964.128381]  [<ffffffff811070e0>] ? __block_write_full_page+0x15b/0x2a8
[  964.128385]  [<ffffffff810b3e76>] ? __writepage+0xa/0x21
[  964.128388]  [<ffffffff810b4ef0>] ? write_cache_pages+0x1d8/0x2f1
[  964.128391]  [<ffffffff810b3e6c>] ? __writepage+0x0/0x21
[  964.128395]  [<ffffffff8110054c>] ? writeback_single_inode+0xd1/0x2e5
[  964.128399]  [<ffffffff81100ab6>] ? writeback_sb_inodes+0x136/0x204
[  964.128403]  [<ffffffff8110115b>] ? writeback_inodes_wb+0x127/0x139
[  964.128406]  [<ffffffff811012fb>] ? wb_writeback+0x18e/0x208
[  964.128410]  [<ffffffff811013d8>] ? wb_do_writeback+0x63/0x149
[  964.128413]  [<ffffffff811014a8>] ? wb_do_writeback+0x133/0x149
[  964.128417]  [<ffffffff811014f8>] ? bdi_writeback_task+0x3a/0x113
[  964.128420]  [<ffffffff8105cce7>] ? bit_waitqueue+0x14/0xa1
[  964.128424]  [<ffffffff810c0513>] ? bdi_start_fn+0x0/0xc3
[  964.128427]  [<ffffffff810c0576>] ? bdi_start_fn+0x63/0xc3
[  964.128430]  [<ffffffff810c0513>] ? bdi_start_fn+0x0/0xc3
[  964.128433]  [<ffffffff8105c96d>] ? kthread+0x75/0x7d
[  964.128436]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[  964.128439]  [<ffffffff8105c8f8>] ? kthread+0x0/0x7d
[  964.128442]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10


I tried this with debian squeeze stock kernel (2.6.32-5-amd64), 2.6.34.1
and now 2.6.35, but it's always kind of the same.

Any ideas where I could search for the problem?

Greetings,

cu
Dieter

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkxWbXwACgkQ5YzjaZZeXo1c1wCfQgyQTeRSzGmLmdi4tNHjc/43
5a0AoIo5PyN42ZYgWTCggINCeCX4I1OS
=ddwN
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
