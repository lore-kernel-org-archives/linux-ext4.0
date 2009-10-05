From: Tim Blechmann <tim@klingt.org>
Subject: ext4: smp_processor_id() in preemptible
Date: Mon, 05 Oct 2009 12:05:49 +0200
Message-ID: <4AC9C4FD.7080606@klingt.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEC882463BE279D5ECDC35205"
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932505AbZJEKGb@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEC882463BE279D5ECDC35205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hi all,

using 2.6.31.1 with CONFIG_PREEMPT=3Dy, i got the following call traces=20
from ext4 related code, when doing some io-heavy tasks:

[30477.126201] INFO: task gconfd-2:2296 blocked for more than 120 seconds=
=2E
[30477.126205] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[30477.126208] gconfd-2      D ffff8800280436e8     0  2296      1 0x0000=
0000
[30477.126214] BUG: using smp_processor_id() in preemptible [00000000] co=
de: khungtaskd/72
[30477.126221] caller is show_stack_log_lvl+0x32/0x170
[30477.126224] Pid: 72, comm: khungtaskd Tainted: P           2.6.31.1 #2=
9
[30477.126227] Call Trace:
[30477.126234]  [<ffffffff81266881>] debug_smp_processor_id+0xd1/0xf0
[30477.126238]  [<ffffffff81014b62>] show_stack_log_lvl+0x32/0x170
[30477.126242]  [<ffffffff814f57c0>] ? printk+0x3c/0x44
[30477.126246]  [<ffffffff81015e17>] show_stack+0x17/0x20
[30477.126251]  [<ffffffff81045b52>] sched_show_task+0x92/0x100
[30477.126256]  [<ffffffff810ab66d>] watchdog+0x1fd/0x240
[30477.126260]  [<ffffffff810ab470>] ? watchdog+0x0/0x240
[30477.126264]  [<ffffffff81071216>] kthread+0xa6/0xb0
[30477.126268]  [<ffffffff8101303a>] child_rip+0xa/0x20
[30477.126272]  [<ffffffff81071170>] ? kthread+0x0/0xb0
[30477.126275]  [<ffffffff81013030>] ? child_rip+0x0/0x20
[30477.126278]  ffff8803331afc98 0000000000000086 0000000000000000 000000=
0000000000
[30477.126282]  ffff8803331afc58 0000000000000000 ffff8803331afc58 000000=
01002ddc13
[30477.126287]  000000000000f6e8 00000000000147c0 ffff880331d3acb8 ffff88=
0331d3acb8
[30477.126291] Call Trace:
[30477.126298]  [<ffffffff811de775>] jbd2_log_wait_commit+0xb5/0x130
[30477.126303]  [<ffffffff81071660>] ? autoremove_wake_function+0x0/0x40
[30477.126307]  [<ffffffff81074b51>] ? ktime_get_ts+0x51/0x70
[30477.126311]  [<ffffffff811d6300>] jbd2_journal_stop+0x1e0/0x2b0
[30477.126315]  [<ffffffff811d6cbe>] ? jbd2_journal_start+0xae/0x100
[30477.126319]  [<ffffffff811d6d32>] jbd2_journal_force_commit+0x22/0x30
[30477.126325]  [<ffffffff811ae9f2>] ext4_force_commit+0x22/0x40
[30477.126329]  [<ffffffff8119c004>] ext4_write_inode+0x34/0x50
[30477.126335]  [<ffffffff8112b79c>] writeback_single_inode+0x2bc/0x420
[30477.126339]  [<ffffffff8112b92e>] sync_inode+0x2e/0x50
[30477.126343]  [<ffffffff81199220>] ext4_sync_file+0x100/0x1c0
[30477.126348]  [<ffffffff810db128>] ? do_writepages+0x28/0x50
[30477.126352]  [<ffffffff8112faf6>] vfs_fsync+0x86/0xf0
[30477.126356]  [<ffffffff8112fb99>] do_fsync+0x39/0x60
[30477.126360]  [<ffffffff8112fbeb>] sys_fsync+0xb/0x10
[30477.126365]  [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b
[30477.126374] INFO: task firefox:4898 blocked for more than 120 seconds.=

[30477.126376] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[30477.126378] firefox       D ffff8800280d46e8     0  4898      1 0x0000=
0000
[30477.126383] BUG: using smp_processor_id() in preemptible [00000000] co=
de: khungtaskd/72
[30477.126386] caller is show_stack_log_lvl+0x32/0x170
[30477.126389] Pid: 72, comm: khungtaskd Tainted: P           2.6.31.1 #2=
9
[30477.126391] Call Trace:
[30477.126394]  [<ffffffff81266881>] debug_smp_processor_id+0xd1/0xf0
[30477.126398]  [<ffffffff81014b62>] show_stack_log_lvl+0x32/0x170
[30477.126401]  [<ffffffff814f57c0>] ? printk+0x3c/0x44
[30477.126405]  [<ffffffff81015e17>] show_stack+0x17/0x20
[30477.126408]  [<ffffffff81045b52>] sched_show_task+0x92/0x100
[30477.126412]  [<ffffffff810ab66d>] watchdog+0x1fd/0x240
[30477.126415]  [<ffffffff810ab470>] ? watchdog+0x0/0x240
[30477.126419]  [<ffffffff81071216>] kthread+0xa6/0xb0
[30477.126422]  [<ffffffff8101303a>] child_rip+0xa/0x20
[30477.126426]  [<ffffffff81071170>] ? kthread+0x0/0xb0
[30477.126429]  [<ffffffff81013030>] ? child_rip+0x0/0x20
[30477.126431]  ffff880309409ac8 0000000000000082 0000000000000000 000000=
0000000286
[30477.126435]  ffff88012547fc78 0000000000000005 ffff8803309cf000 000000=
01002dc21f
[30477.126440]  000000000000f6e8 00000000000147c0 ffff88030954c438 ffff88=
030954c438
[30477.126444] Call Trace:
[30477.126448]  [<ffffffff811d7255>] do_get_write_access+0x365/0x6d0
[30477.126453]  [<ffffffff810716a0>] ? wake_bit_function+0x0/0x40
[30477.126456]  [<ffffffff811e1437>] ? jbd2_journal_add_journal_head+0x11=
7/0x220
[30477.126461]  [<ffffffff811d77dc>] jbd2_journal_get_write_access+0x2c/0=
x50
[30477.126466]  [<ffffffff811bf700>] __ext4_journal_get_write_access+0x30=
/0x70
[30477.126470]  [<ffffffff811a3f31>] ext4_orphan_add+0xc1/0x1d0
[30477.126474]  [<ffffffff811d6cbe>] ? jbd2_journal_start+0xae/0x100
[30477.126479]  [<ffffffff814f8737>] ? _spin_unlock_irq+0x17/0x40
[30477.126483]  [<ffffffff8119dd9a>] ext4_setattr+0x22a/0x360
[30477.126488]  [<ffffffff811229c3>] notify_change+0x163/0x340
[30477.126493]  [<ffffffff8110aae9>] do_truncate+0x69/0x90
[30477.126496]  [<ffffffff81114edc>] ? get_write_access+0x3c/0x60
[30477.126500]  [<ffffffff81115616>] may_open+0x1d6/0x200
[30477.126503]  [<ffffffff811184e8>] do_filp_open+0x208/0xb50
[30477.126508]  [<ffffffff814f81f6>] ? _spin_lock+0x16/0x40
[30477.126511]  [<ffffffff811238f2>] ? alloc_fd+0xf2/0x140
[30477.126515]  [<ffffffff81109b84>] do_sys_open+0x64/0x130
[30477.126518]  [<ffffffff81109c7b>] sys_open+0x1b/0x20
[30477.126522]  [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b
[30477.126530] INFO: task thunderbird-bin:12190 blocked for more than 120=
 seconds.
[30477.126532] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[30477.126534] thunderbird-b D ffff8800280436e8     0 12190  12186 0x0000=
0000
[30477.126539] BUG: using smp_processor_id() in preemptible [00000000] co=
de: khungtaskd/72
[30477.126542] caller is show_stack_log_lvl+0x32/0x170
[30477.126545] Pid: 72, comm: khungtaskd Tainted: P           2.6.31.1 #2=
9
[30477.126546] Call Trace:
[30477.126550]  [<ffffffff81266881>] debug_smp_processor_id+0xd1/0xf0
[30477.126553]  [<ffffffff81014b62>] show_stack_log_lvl+0x32/0x170
[30477.126556]  [<ffffffff814f57c0>] ? printk+0x3c/0x44
[30477.126560]  [<ffffffff81015e17>] show_stack+0x17/0x20
[30477.126563]  [<ffffffff81045b52>] sched_show_task+0x92/0x100
[30477.126567]  [<ffffffff810ab66d>] watchdog+0x1fd/0x240
[30477.126570]  [<ffffffff810ab470>] ? watchdog+0x0/0x240
[30477.126574]  [<ffffffff81071216>] kthread+0xa6/0xb0
[30477.126577]  [<ffffffff8101303a>] child_rip+0xa/0x20
[30477.126581]  [<ffffffff81071170>] ? kthread+0x0/0xb0
[30477.126584]  [<ffffffff81013030>] ? child_rip+0x0/0x20
[30477.126586]  ffff8803031c3a68 0000000000000082 0000000000000000 ffffea=
000b023168
[30477.126590]  00000000001800f2 0000000000000000 ffff880333713800 000000=
01002dba15
[30477.126594]  000000000000f6e8 00000000000147c0 ffff8803031c0938 ffff88=
03031c0938
[30477.126598] Call Trace:
[30477.126603]  [<ffffffff811d7255>] do_get_write_access+0x365/0x6d0
[30477.126607]  [<ffffffff810716a0>] ? wake_bit_function+0x0/0x40
[30477.126611]  [<ffffffff811e1437>] ? jbd2_journal_add_journal_head+0x11=
7/0x220
[30477.126615]  [<ffffffff811d77dc>] jbd2_journal_get_write_access+0x2c/0=
x50
[30477.126619]  [<ffffffff811bf700>] __ext4_journal_get_write_access+0x30=
/0x70
[30477.126624]  [<ffffffff8119d7cb>] ext4_reserve_inode_write+0x7b/0xa0
[30477.126628]  [<ffffffff8119d82c>] ext4_mark_inode_dirty+0x3c/0x1c0
[30477.126632]  [<ffffffff810d7cec>] ? T.1235+0xac/0xe0
[30477.126636]  [<ffffffff8119db22>] ext4_dirty_inode+0x62/0xb0
[30477.126640]  [<ffffffff8112c346>] __mark_inode_dirty+0x36/0x130
[30477.126644]  [<ffffffff81120ae4>] touch_atime+0xf4/0x150
[30477.126649]  [<ffffffff810d4590>] generic_file_aio_read+0x2a0/0x620
[30477.126654]  [<ffffffff8110b9f2>] do_sync_read+0xf2/0x130
[30477.126658]  [<ffffffff810dcc69>] ? __lru_cache_add+0x79/0xd0
[30477.126662]  [<ffffffff814f8630>] ? _spin_unlock+0x10/0x40
[30477.126665]  [<ffffffff81071660>] ? autoremove_wake_function+0x0/0x40
[30477.126670]  [<ffffffff8110fd4f>] ? cp_new_stat+0xdf/0xf0
[30477.126674]  [<ffffffff8120d991>] ? security_file_permission+0x11/0x20=

[30477.126678]  [<ffffffff8110be55>] vfs_read+0xb5/0x1a0
[30477.126682]  [<ffffffff8110cedd>] ? fget_light+0x9d/0xb0
[30477.126685]  [<ffffffff8110c49c>] sys_read+0x4c/0x80
[30477.126689]  [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b
[30477.126693] INFO: task thunderbird-bin:12196 blocked for more than 120=
 seconds.
[30477.126695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[30477.126697] thunderbird-b D ffff8800280436e8     0 12196  12186 0x0000=
0000
[30477.126702] BUG: using smp_processor_id() in preemptible [00000000] co=
de: khungtaskd/72
[30477.126705] caller is show_stack_log_lvl+0x32/0x170
[30477.126708] Pid: 72, comm: khungtaskd Tainted: P           2.6.31.1 #2=
9
[30477.126710] Call Trace:
[30477.126713]  [<ffffffff81266881>] debug_smp_processor_id+0xd1/0xf0
[30477.126716]  [<ffffffff81014b62>] show_stack_log_lvl+0x32/0x170
[30477.126720]  [<ffffffff814f57c0>] ? printk+0x3c/0x44
[30477.126723]  [<ffffffff81015e17>] show_stack+0x17/0x20
[30477.126726]  [<ffffffff81045b52>] sched_show_task+0x92/0x100
[30477.126730]  [<ffffffff810ab66d>] watchdog+0x1fd/0x240
[30477.126734]  [<ffffffff810ab470>] ? watchdog+0x0/0x240
[30477.126737]  [<ffffffff81071216>] kthread+0xa6/0xb0
[30477.126740]  [<ffffffff8101303a>] child_rip+0xa/0x20
[30477.126744]  [<ffffffff81071170>] ? kthread+0x0/0xb0
[30477.126747]  [<ffffffff81013030>] ? child_rip+0x0/0x20
[30477.126749]  ffff8803031a1d68 0000000000000082 0000000000000000 ffff88=
03031a1e30
[30477.126753]  0000000000000000 0000000000000000 ffff8803031a1d78 000000=
01002dba15
[30477.126757]  000000000000f6e8 00000000000147c0 ffff8803031a4978 ffff88=
03031a4978
[30477.126761] Call Trace:
[30477.126766]  [<ffffffff811de775>] jbd2_log_wait_commit+0xb5/0x130
[30477.126770]  [<ffffffff81071660>] ? autoremove_wake_function+0x0/0x40
[30477.126774]  [<ffffffff811d6300>] jbd2_journal_stop+0x1e0/0x2b0
[30477.126778]  [<ffffffff811d6cbe>] ? jbd2_journal_start+0xae/0x100
[30477.126782]  [<ffffffff811d6d32>] jbd2_journal_force_commit+0x22/0x30
[30477.126786]  [<ffffffff811ae9f2>] ext4_force_commit+0x22/0x40
[30477.126790]  [<ffffffff811991a3>] ext4_sync_file+0x83/0x1c0
[30477.126856]  [<ffffffff810db13d>] ? do_writepages+0x3d/0x50
[30477.126860]  [<ffffffff810d3103>] ? __filemap_fdatawrite_range+0x53/0x=
60
[30477.126865]  [<ffffffff8112faf6>] vfs_fsync+0x86/0xf0
[30477.126869]  [<ffffffff8112fb99>] do_fsync+0x39/0x60
[30477.126873]  [<ffffffff8112fbce>] sys_fdatasync+0xe/0x20
[30477.126877]  [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b
[30477.126885] INFO: task java:14629 blocked for more than 120 seconds.
[30477.126887] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[30477.126889] java          D ffff8800280436e8     0 14629      1 0x0000=
0004
[30477.126894] BUG: using smp_processor_id() in preemptible [00000000] co=
de: khungtaskd/72
[30477.126898] caller is show_stack_log_lvl+0x32/0x170
[30477.126900] Pid: 72, comm: khungtaskd Tainted: P           2.6.31.1 #2=
9
[30477.126902] Call Trace:
[30477.126906]  [<ffffffff81266881>] debug_smp_processor_id+0xd1/0xf0
[30477.126909]  [<ffffffff81014b62>] show_stack_log_lvl+0x32/0x170
[30477.126912]  [<ffffffff814f57c0>] ? printk+0x3c/0x44
[30477.126915]  [<ffffffff81015e17>] show_stack+0x17/0x20
[30477.126919]  [<ffffffff81045b52>] sched_show_task+0x92/0x100
[30477.126922]  [<ffffffff810ab66d>] watchdog+0x1fd/0x240
[30477.126926]  [<ffffffff810ab470>] ? watchdog+0x0/0x240
[30477.126929]  [<ffffffff81071216>] kthread+0xa6/0xb0
[30477.126933]  [<ffffffff8101303a>] child_rip+0xa/0x20
[30477.126937]  [<ffffffff81071170>] ? kthread+0x0/0xb0
[30477.126940]  [<ffffffff81013030>] ? child_rip+0x0/0x20
[30477.126942]  ffff88026ec81c68 0000000000000086 0000000000000000 ffffff=
ff811d7fb2
[30477.126946]  ffff88026ec81cc8 0000000000000000 ffff88026ec81c18 000000=
01002dc64a
[30477.126950]  000000000000f6e8 00000000000147c0 ffff8801571a88b8 ffff88=
01571a88b8
[30477.126954] Call Trace:
[30477.126957]  [<ffffffff811d7fb2>] ? jbd2_journal_dirty_metadata+0xb2/0=
x1e0
[30477.126962]  [<ffffffff814f6f9b>] __mutex_lock_common+0x12b/0x270
[30477.126966]  [<ffffffff8119d860>] ? ext4_mark_inode_dirty+0x70/0x1c0
[30477.126970]  [<ffffffff814f70f4>] __mutex_lock_slowpath+0x14/0x20
[30477.126973]  [<ffffffff814f6d8e>] mutex_lock+0x1e/0x40
[30477.126977]  [<ffffffff811a3cf3>] ext4_orphan_del+0x53/0x1d0
[30477.126981]  [<ffffffff814f81f6>] ? _spin_lock+0x16/0x40
[30477.126984]  [<ffffffff814f8630>] ? _spin_unlock+0x10/0x40
[30477.126988]  [<ffffffff8112c3a8>] ? __mark_inode_dirty+0x98/0x130
[30477.126992]  [<ffffffff8119de9a>] ext4_setattr+0x32a/0x360
[30477.126996]  [<ffffffff811229c3>] notify_change+0x163/0x340
[30477.126999]  [<ffffffff81115770>] ? putname+0x30/0x50
[30477.127004]  [<ffffffff81130087>] utimes_common+0xd7/0x1b0
[30477.127008]  [<ffffffff811301f0>] do_utimes+0x90/0xf0
[30477.127012]  [<ffffffff8113027b>] sys_futimesat+0x2b/0xb0
[30477.127016]  [<ffffffff81130314>] sys_utimes+0x14/0x20
[30477.127020]  [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b

hth, tim

--=20
tim@klingt.org
http://tim.klingt.org

You don't have to call it music if the term shocks you.
  John Cage



--------------enigEC882463BE279D5ECDC35205
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrJxP0ACgkQdL+4qsZfVsuX4wCdFaF/7U2RoiYyhacqYGZdTCYo
BBYAoKF1Q5ThXXrvu6tNQHBy+t3BiR75
=fgSc
-----END PGP SIGNATURE-----

--------------enigEC882463BE279D5ECDC35205--
