From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: khugepaged: inconsistent lock {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
 usage
Date: Tue, 23 Aug 2011 15:10:13 +0300
Message-ID: <20110823121013.GB3554@swordfish.minsk.epam.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1HWMLi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Aug 2011 08:11:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

[12027.382589] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[12027.382594] [ INFO: inconsistent lock state ]
[12027.382600] 3.1.0-rc3-dbg-00548-gba7b8dc #692
[12027.382603] ---------------------------------
[12027.382607] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[12027.382614] khugepaged/552 [HC0[0]:SC0[0]:HE1:SE1] takes:
[12027.382619]  (&sb->s_type->i_mutex_key#9){+.+.?.}, at: [<ffffffff811c11f=
7>] ext4_evict_inode+0xb0/0x51d
[12027.382640] {RECLAIM_FS-ON-W} state was registered at:
[12027.382644]   [<ffffffff81071f8b>] mark_held_locks+0xc3/0xef
[12027.382655]   [<ffffffff810725a8>] lockdep_trace_alloc+0x9b/0xbd
[12027.382663]   [<ffffffff810ff580>] kmem_cache_alloc+0x2a/0x1a4
[12027.382671]   [<ffffffff8111d972>] __d_alloc+0x22/0x164
[12027.382679]   [<ffffffff8111dd5d>] d_alloc+0x19/0x7a
[12027.382686]   [<ffffffff811132f9>] d_alloc_and_lookup+0x27/0x66
[12027.382695]   [<ffffffff81113dc8>] do_lookup+0x1df/0x2e9
[12027.382702]   [<ffffffff81114566>] link_path_walk+0x1b3/0x738
[12027.382709]   [<ffffffff81115499>] path_lookupat+0x57/0x5ee
[12027.382717]   [<ffffffff81115a53>] do_path_lookup+0x23/0x9f
[12027.382724]   [<ffffffff81116f75>] user_path_at+0x54/0x91
[12027.382731]   [<ffffffff8110dc46>] vfs_fstatat+0x3f/0x69
[12027.382738]   [<ffffffff8110dca1>] vfs_stat+0x16/0x18
[12027.382745]   [<ffffffff8110dd87>] sys_newstat+0x15/0x2e
[12027.382751]   [<ffffffff814965d2>] system_call_fastpath+0x16/0x1b
[12027.382761] irq event stamp: 9401171
[12027.382765] hardirqs last  enabled at (9401171): [<ffffffff810cee07>] fr=
ee_hot_cold_page+0x168/0x181
[12027.382776] hardirqs last disabled at (9401170): [<ffffffff810cecfd>] fr=
ee_hot_cold_page+0x5e/0x181
[12027.382785] softirqs last  enabled at (9399656): [<ffffffff81045555>] __=
do_softirq+0x261/0x2ff
[12027.382795] softirqs last disabled at (9399635): [<ffffffff81497abc>] ca=
ll_softirq+0x1c/0x30
[12027.382805]=20
[12027.382805] other info that might help us debug this:
[12027.382809]  Possible unsafe locking scenario:
[12027.382811]=20
[12027.382814]        CPU0
[12027.382817]        ----
[12027.382819]   lock(&sb->s_type->i_mutex_key);
[12027.382826]   <Interrupt>
[12027.382829]     lock(&sb->s_type->i_mutex_key);
[12027.382835]=20
[12027.382836]  *** DEADLOCK ***
[12027.382838]=20
[12027.382842] 2 locks held by khugepaged/552:
[12027.382846]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810d6465>] shr=
ink_slab+0x37/0x3d0
[12027.382862]  #1:  (&type->s_umount_key#16){+++++.}, at: [<ffffffff8110c5=
12>] grab_super_passive+0x52/0x76
[12027.382880]=20
[12027.382881] stack backtrace:
[12027.382887] Pid: 552, comm: khugepaged Not tainted 3.1.0-rc3-dbg-00548-g=
ba7b8dc #692
[12027.382891] Call Trace:
[12027.382902]  [<ffffffff81486180>] print_usage_bug+0x28f/0x2a0
[12027.382913]  [<ffffffff8100cb2a>] ? save_stack_trace+0x27/0x44
[12027.382922]  [<ffffffff8106ee4e>] ? print_irq_inversion_bug+0x1cd/0x1cd
[12027.382929]  [<ffffffff8106fa1e>] mark_lock+0x2eb/0x53a
[12027.382937]  [<ffffffff81070321>] __lock_acquire+0x6b4/0x164b
[12027.382945]  [<ffffffff8106d318>] ? __bfs+0x23/0x1c7
[12027.382952]  [<ffffffff8106f62c>] ? check_irq_usage+0x99/0xab
[12027.382960]  [<ffffffff810711df>] ? __lock_acquire+0x1572/0x164b
[12027.382968]  [<ffffffff811c11f7>] ? ext4_evict_inode+0xb0/0x51d
[12027.382975]  [<ffffffff8107186e>] lock_acquire+0x138/0x1ac
[12027.382982]  [<ffffffff811c11f7>] ? ext4_evict_inode+0xb0/0x51d
[12027.382990]  [<ffffffff811c11f7>] ? ext4_evict_inode+0xb0/0x51d
[12027.382998]  [<ffffffff8148e953>] mutex_lock_nested+0x5e/0x325
[12027.383005]  [<ffffffff811c11f7>] ? ext4_evict_inode+0xb0/0x51d
[12027.383013]  [<ffffffff81120013>] ? evict+0x64/0x15c
[12027.383022]  [<ffffffff81256185>] ? do_raw_spin_lock+0x6b/0x122
[12027.383030]  [<ffffffff811c11f7>] ext4_evict_inode+0xb0/0x51d
[12027.383038]  [<ffffffff811c1147>] ? ext4_da_writepages+0x6df/0x6df
[12027.383045]  [<ffffffff81120050>] evict+0xa1/0x15c
[12027.383051]  [<ffffffff81120137>] dispose_list+0x2c/0x38
[12027.383059]  [<ffffffff811211c6>] prune_icache_sb+0x28c/0x29b
[12027.383067]  [<ffffffff8110c60b>] prune_super+0xd5/0x140
[12027.383074]  [<ffffffff810d6624>] shrink_slab+0x1f6/0x3d0
[12027.383083]  [<ffffffff810d9448>] do_try_to_free_pages+0x1ae/0x330
[12027.383091]  [<ffffffff810d979b>] try_to_free_pages+0x110/0x241
[12027.383099]  [<ffffffff810ce50a>] __alloc_pages_nodemask+0x4d2/0x801
[12027.383108]  [<ffffffff814902ea>] ? _raw_spin_unlock_irqrestore+0x56/0x74
[12027.383116]  [<ffffffff81102510>] khugepaged_alloc_hugepage+0x50/0xdd
[12027.383127]  [<ffffffff8105dc32>] ? __init_waitqueue_head+0x46/0x46
[12027.383134]  [<ffffffff81102aa1>] khugepaged+0x82/0xff5
[12027.383141]  [<ffffffff8148cadd>] ? schedule+0x353/0xa7e
[12027.383150]  [<ffffffff8105dc32>] ? __init_waitqueue_head+0x46/0x46
[12027.383157]  [<ffffffff81102a1f>] ? khugepaged_defrag_store+0x57/0x57
[12027.383164]  [<ffffffff8105d3e6>] kthread+0x9a/0xa2
[12027.383173]  [<ffffffff814979c4>] kernel_thread_helper+0x4/0x10
[12027.383181]  [<ffffffff8102d6d6>] ? finish_task_switch+0x76/0xf0
[12027.383188]  [<ffffffff814907b8>] ? retint_restore_args+0x13/0x13
[12027.383196]  [<ffffffff8105d34c>] ? __init_kthread_worker+0x53/0x53
[12027.383203]  [<ffffffff814979c0>] ? gs_change+0x13/0x13


	Sergey

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk5TmKUACgkQfKHnntdSXjQFGQQAkRjlZO/acTyaKoYCPwRdvx9U
86JOw6Cc+8vm9EHosBXG2L/b2Wq0GtkWKuzpwjJCb9OZe30HzMWWCKXn4GxQxYe9
m8iQUP+wNzvEwLBTsHW/HOtKgJlXsKj+IzqDlH8f0OQLQ7tozWzyTjJQ0iGxkon9
m8Bw9UulJ7gK2ncZxqQ=
=Ryum
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
