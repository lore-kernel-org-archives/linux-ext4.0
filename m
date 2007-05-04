From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: 2.6.21-git4 Scheduler, NOHZ, VFS bugs
Date: Fri, 04 May 2007 18:20:51 +0200
Message-ID: <463B5D63.2030109@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	viro@ftp.linux.org.uk, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:15441 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031332AbXEDQUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 12:20:54 -0400
Received: by wr-out-0506.google.com with SMTP id 71so949371wri
        for <linux-ext4@vger.kernel.org>; Fri, 04 May 2007 09:20:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I ran this script tree times,

#! /bin/sh

for i in `find /sys/ -type f`
do
    echo "wy=B6wietlam $i"
    sudo cat $i > /dev/null
done

=46irst run - scheduler bug
Second run - NOHZ bug
Third - VFS bug

Hmmmm...

[93298.252601] BUG: at /mnt/md0/devel/linux-git/kernel/sched.c:3241 add=
_preempt_count()
[93298.260334]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93298.265507]  [<c0105720>] show_trace+0x12/0x14
[93298.269974]  [<c01057d2>] dump_stack+0x16/0x18
[93298.274434]  [<c011d18a>] add_preempt_count+0x89/0x8b
[93298.279501]  [<c0126492>] irq_enter+0xd/0x2e
[93298.283788]  [<c0114c1e>] smp_apic_timer_interrupt+0x2a/0x84
[93298.289458]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93298.294783]  [<c0257b79>] show_uevent+0x58/0xcd
[93298.299329]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93390.468056] NOHZ: local_softirq_pending 22
[93447.105850] NOHZ: local_softirq_pending 22
[93450.332884] BUG: unable to handle kernel paging request at virtual a=
ddress 3e343c0c
[93450.340626]  printing eip:
[93450.343333] c018e2bc
[93450.345520] *pde =3D 00000000
[93450.348314] Oops: 0000 [#1]
[93450.351105] PREEMPT SMP=20
[93450.353683] Modules linked in: iptable_filter ip_tables oprofile snd=
_rtctimer ipt_MASQUERADE nf_nat autofs4 af_packet nf_conntrack_netbios_=
ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink ip6t_RE=
JECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc the=
rmal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus=
 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device sn=
d_pcm_oss snd_mixer_oss evdev snd_pcm snd_timer snd intel_agp soundcore=
 agpgart snd_page_alloc i2c_i801 ide_cd cdrom rtc unix
[93450.402543] CPU:    1
[93450.402544] EIP:    0060:[<c018e2bc>]    Not tainted VLI
[93450.402546] EFLAGS: 00010213   (2.6.21-gdc87c398-dirty #170)
[93450.415753] EIP is at __find_get_block_slow+0x66/0x105
[93450.420874] eax: 00000000   ebx: 3e343c00   ecx: e750adcc   edx: 000=
00000
[93450.427642] esi: c54ae840   edi: 00006665   ebp: f7e26e8c   esp: f7e=
26e64
[93450.434412] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[93450.440228] Process kjournald (pid: 379, ti=3Df7e26000 task=3Df7e40a=
d0 task.ti=3Df7e26000)
[93450.447774] Stack: f7c742bc f7da2c24 f7e26e84 c01ae271 00000046 f7cf=
90f4 f7cf9210 00000000=20
[93450.456278]        c602ae40 00001000 f7e26ed0 c018e5c7 00006665 f7cf=
9034 f7e26ec8 00000246=20
[93450.464786]        00000000 c01c06e2 f7c742e4 f7c742d0 c01c074b 0000=
0246 f7c742d0 00005e41=20
[93450.473308] Call Trace:
[93450.475946]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93450.481098]  [<c01050eb>] show_stack_log_lvl+0x9d/0xa5
[93450.486249]  [<c01052e0>] show_registers+0x1ed/0x32c
[93450.491228]  [<c0105537>] die+0x118/0x22f
[93450.495257]  [<c0119729>] do_page_fault+0x43a/0x50d
[93450.500149]  [<c031f44c>] error_code+0x7c/0x84
[93450.504610]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93450.509675]  [<c018e6a9>] __getblk+0x16/0x1fb
[93450.514049]  [<c01c1157>] journal_get_descriptor_buffer+0x2f/0x8c
[93450.520152]  [<c01bd042>] journal_commit_transaction+0xbfd/0x11d3
[93450.526255]  [<c01c0aae>] kjournald+0xab/0x1e8
[93450.530714]  [<c013341d>] kthread+0xb5/0xe0
[93450.534916]  [<c0104ccf>] kernel_thread_helper+0x7/0x10
[93450.540153]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93450.543723] Code: 8b 45 f0 83 c0 7c e8 46 09 19 00 8b 06 f6 c4 08 0f=
 84 96 00 00 00 8b 06 f6 c4 08 75 04 0f 0b eb fe 8b 5e 0c 89 d9 ba 01 0=
0 00 00 <39> 7b 0c 74 76 8b 03 a8 20 b8 00 00 00 00 0f 44 d0 8b 5b 04 3=
9=20
[93450.563736] EIP: [<c018e2bc>] __find_get_block_slow+0x66/0x105 SS:ES=
P 0068:f7e26e64

l *0xc018e2bc
0xc018e2bc is in __find_get_block_slow (/mnt/md0/devel/linux-git/fs/buf=
fer.c:273).
268             if (!page_has_buffers(page))
269                     goto out_unlock;
270             head =3D page_buffers(page);
271             bh =3D head;
272             do {
273                     if (bh->b_blocknr =3D=3D block) {
274                             ret =3D bh;
275                             get_bh(bh);
276                             goto out_unlock;
277                     }


[93450.571447] note: kjournald[379] exited with preempt_count 1
[93450.577125] BUG: sleeping function called from invalid context at /m=
nt/md0/devel/linux-git/fs/inode.c:246
[93450.586668] in_atomic():1, irqs_disabled():0
[93450.590937] INFO: lockdep is turned off.
[93450.594862]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93450.600030]  [<c0105720>] show_trace+0x12/0x14
[93450.604490]  [<c01057d2>] dump_stack+0x16/0x18
[93450.608960]  [<c011b58c>] __might_sleep+0xc9/0xcf
[93450.613695]  [<c0183386>] clear_inode+0x19/0x118
[93450.618338]  [<c019ecf8>] proc_delete_inode+0x42/0x46
[93450.623413]  [<c018352b>] generic_delete_inode+0xa6/0x110
[93450.628840]  [<c0182bb8>] iput+0x63/0x66
[93450.632783]  [<c0180d65>] dentry_iput+0x88/0xa2
[93450.637348]  [<c0181b9e>] prune_one_dentry+0x42/0x65
[93450.642342]  [<c0181d4f>] prune_dcache+0xcd/0x138
[93450.647071]  [<c0181e07>] shrink_dcache_parent+0x1c/0xe5
[93450.652397]  [<c01a0079>] proc_flush_task+0x54/0x1d1
[93450.657392]  [<c0123a53>] release_task+0x29e/0x2c5
[93450.662206]  [<c0124b64>] do_exit+0x69b/0x702
[93450.666582]  [<c0105628>] die+0x209/0x22f
[93450.670616]  [<c0119729>] do_page_fault+0x43a/0x50d
[93450.675511]  [<c031f44c>] error_code+0x7c/0x84
[93450.679979]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93450.685053]  [<c018e6a9>] __getblk+0x16/0x1fb
[93450.689427]  [<c01c1157>] journal_get_descriptor_buffer+0x2f/0x8c
[93450.695539]  [<c01bd042>] journal_commit_transaction+0xbfd/0x11d3
[93450.701660]  [<c01c0aae>] kjournald+0xab/0x1e8
[93450.706138]  [<c013341d>] kthread+0xb5/0xe0
[93450.710354]  [<c0104ccf>] kernel_thread_helper+0x7/0x10
[93450.715592]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93459.541220] BUG: soft lockup detected on CPU#0!
[93459.545746]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93459.550899]  [<c0105720>] show_trace+0x12/0x14
[93459.555357]  [<c01057d2>] dump_stack+0x16/0x18
[93459.559817]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93459.564711]  [<c012a0b5>] run_local_timers+0x12/0x14
[93459.569690]  [<c012a482>] update_process_times+0x3e/0x63
[93459.575015]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93459.579994]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93459.585231]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93459.590901]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93459.596227]  [<c01ed850>] __delay+0x9/0xb
[93459.600255]  [<c01f9bb5>] _raw_spin_lock+0x7d/0xe2
[93459.605061]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93459.609522]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93459.615020]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93459.620085]  [<c018e6a9>] __getblk+0x16/0x1fb
[93459.624458]  [<c01ac3d8>] __ext3_get_inode_loc+0x109/0x2e1
[93459.629956]  [<c01ac5c7>] ext3_get_inode_loc+0x17/0x19
[93459.635109]  [<c01ac5e9>] ext3_reserve_inode_write+0x20/0x68
[93459.640780]  [<c01ac65b>] ext3_mark_inode_dirty+0x2a/0x41
[93459.646190]  [<c01aefd2>] ext3_dirty_inode+0x59/0x6c
[93459.651169]  [<c018b4b0>] __mark_inode_dirty+0x2a/0x15a
[93459.656407]  [<c018e9a2>] generic_commit_write+0x68/0x72
[93459.661732]  [<c01ae3de>] ext3_ordered_commit_write+0xaa/0xd8
[93459.667490]  [<c01570e4>] generic_file_buffered_write+0x3ba/0x585
[93459.673591]  [<c0157706>] __generic_file_aio_write_nolock+0x457/0x4c=
4
[93459.680040]  [<c01577c9>] generic_file_aio_write+0x56/0xb4
[93459.685538]  [<c01aadb3>] ext3_file_write+0x27/0x99
[93459.690430]  [<c0171de2>] do_sync_write+0xc2/0xff
[93459.695150]  [<c01725bb>] vfs_write+0xaf/0x138
[93459.699610]  [<c0172b85>] sys_write+0x3d/0x61
[93459.703986]  [<c0103fd6>] sysenter_past_esp+0x5f/0x99
[93459.709049]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93469.687801] BUG: soft lockup detected on CPU#0!
[93469.692330]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93469.697480]  [<c0105720>] show_trace+0x12/0x14
[93469.701939]  [<c01057d2>] dump_stack+0x16/0x18
[93469.706400]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93469.711293]  [<c012a0b5>] run_local_timers+0x12/0x14
[93469.716271]  [<c012a482>] update_process_times+0x3e/0x63
[93469.721597]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93469.726576]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93469.731815]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93469.737485]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93469.742810]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93469.747270]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93469.752766]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93469.757833]  [<c018e6a9>] __getblk+0x16/0x1fb
[93469.762197]  [<c01ac3d8>] __ext3_get_inode_loc+0x109/0x2e1
[93469.767695]  [<c01ac5c7>] ext3_get_inode_loc+0x17/0x19
[93469.772847]  [<c01ac5e9>] ext3_reserve_inode_write+0x20/0x68
[93469.778519]  [<c01ac65b>] ext3_mark_inode_dirty+0x2a/0x41
[93469.783930]  [<c01aefd2>] ext3_dirty_inode+0x59/0x6c
[93469.788907]  [<c018b4b0>] __mark_inode_dirty+0x2a/0x15a
[93469.794138]  [<c018e9a2>] generic_commit_write+0x68/0x72
[93469.799462]  [<c01ae3de>] ext3_ordered_commit_write+0xaa/0xd8
[93469.805220]  [<c01570e4>] generic_file_buffered_write+0x3ba/0x585
[93469.811323]  [<c0157706>] __generic_file_aio_write_nolock+0x457/0x4c=
4
[93469.817773]  [<c01577c9>] generic_file_aio_write+0x56/0xb4
[93469.823270]  [<c01aadb3>] ext3_file_write+0x27/0x99
[93469.828161]  [<c0171de2>] do_sync_write+0xc2/0xff
[93469.832881]  [<c01725bb>] vfs_write+0xaf/0x138
[93469.837342]  [<c0172b85>] sys_write+0x3d/0x61
[93469.841715]  [<c0103fd6>] sysenter_past_esp+0x5f/0x99
[93469.846781]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93479.825401] BUG: soft lockup detected on CPU#0!
[93479.829922]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93479.835073]  [<c0105720>] show_trace+0x12/0x14
[93479.839532]  [<c01057d2>] dump_stack+0x16/0x18
[93479.843993]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93479.848885]  [<c012a0b5>] run_local_timers+0x12/0x14
[93479.853864]  [<c012a482>] update_process_times+0x3e/0x63
[93479.859188]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93479.864168]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93479.869407]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93479.875078]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93479.880402]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93479.884862]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93479.890359]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93479.895426]  [<c018e6a9>] __getblk+0x16/0x1fb
[93479.899799]  [<c01ac3d8>] __ext3_get_inode_loc+0x109/0x2e1
[93479.905297]  [<c01ac5c7>] ext3_get_inode_loc+0x17/0x19
[93479.910450]  [<c01ac5e9>] ext3_reserve_inode_write+0x20/0x68
[93479.916120]  [<c01ac65b>] ext3_mark_inode_dirty+0x2a/0x41
[93479.921530]  [<c01aefd2>] ext3_dirty_inode+0x59/0x6c
[93479.926510]  [<c018b4b0>] __mark_inode_dirty+0x2a/0x15a
[93479.931749]  [<c018e9a2>] generic_commit_write+0x68/0x72
[93479.937074]  [<c01ae3de>] ext3_ordered_commit_write+0xaa/0xd8
[93479.942831]  [<c01570e4>] generic_file_buffered_write+0x3ba/0x585
[93479.948933]  [<c0157706>] __generic_file_aio_write_nolock+0x457/0x4c=
4
[93479.955380]  [<c01577c9>] generic_file_aio_write+0x56/0xb4
[93479.960879]  [<c01aadb3>] ext3_file_write+0x27/0x99
[93479.965771]  [<c0171de2>] do_sync_write+0xc2/0xff
[93479.970492]  [<c01725bb>] vfs_write+0xaf/0x138
[93479.974952]  [<c0172b85>] sys_write+0x3d/0x61
[93479.979326]  [<c0103fd6>] sysenter_past_esp+0x5f/0x99
[93479.984391]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93483.665914] BUG: soft lockup detected on CPU#1!
[93483.670433]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93483.675585]  [<c0105720>] show_trace+0x12/0x14
[93483.680046]  [<c01057d2>] dump_stack+0x16/0x18
[93483.684506]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93483.689397]  [<c012a0b5>] run_local_timers+0x12/0x14
[93483.694377]  [<c012a482>] update_process_times+0x3e/0x63
[93483.699702]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93483.704681]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93483.709918]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93483.715590]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93483.720915]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93483.725375]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93483.730871]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93483.735937]  [<c018e6a9>] __getblk+0x16/0x1fb
[93483.740312]  [<c01ad2bd>] ext3_getblk+0xea/0x232
[93483.744944]  [<c01ae0dc>] ext3_bread+0x1a/0x7e
[93483.749406]  [<c01b1418>] htree_dirblock_to_tree+0x27/0x11a
[93483.754990]  [<c01b1573>] ext3_htree_fill_tree+0x68/0x1aa
[93483.760400]  [<c01aa9c9>] ext3_readdir+0x1d6/0x599
[93483.765206]  [<c017ce09>] vfs_readdir+0x67/0x93
[93483.769753]  [<c017d05e>] sys_getdents+0x5f/0x9d
[93483.774388]  [<c0104060>] syscall_call+0x7/0xb
[93483.778848]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93489.962999] BUG: soft lockup detected on CPU#0!
[93489.967523]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93489.972674]  [<c0105720>] show_trace+0x12/0x14
[93489.977133]  [<c01057d2>] dump_stack+0x16/0x18
[93489.981593]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93489.986487]  [<c012a0b5>] run_local_timers+0x12/0x14
[93489.991467]  [<c012a482>] update_process_times+0x3e/0x63
[93489.996791]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93490.001770]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93490.007009]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93490.012680]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93490.018004]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93490.022463]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93490.027962]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93490.033027]  [<c018e6a9>] __getblk+0x16/0x1fb
[93490.037401]  [<c01ac3d8>] __ext3_get_inode_loc+0x109/0x2e1
[93490.042898]  [<c01ac5c7>] ext3_get_inode_loc+0x17/0x19
[93490.048050]  [<c01ac5e9>] ext3_reserve_inode_write+0x20/0x68
[93490.053720]  [<c01ac65b>] ext3_mark_inode_dirty+0x2a/0x41
[93490.059133]  [<c01aefd2>] ext3_dirty_inode+0x59/0x6c
[93490.064111]  [<c018b4b0>] __mark_inode_dirty+0x2a/0x15a
[93490.069350]  [<c018e9a2>] generic_commit_write+0x68/0x72
[93490.074675]  [<c01ae3de>] ext3_ordered_commit_write+0xaa/0xd8
[93490.080431]  [<c01570e4>] generic_file_buffered_write+0x3ba/0x585
[93490.086534]  [<c0157706>] __generic_file_aio_write_nolock+0x457/0x4c=
4
[93490.092984]  [<c01577c9>] generic_file_aio_write+0x56/0xb4
[93490.098481]  [<c01aadb3>] ext3_file_write+0x27/0x99
[93490.103373]  [<c0171de2>] do_sync_write+0xc2/0xff
[93490.108092]  [<c01725bb>] vfs_write+0xaf/0x138
[93490.112552]  [<c0172b85>] sys_write+0x3d/0x61
[93490.116926]  [<c0103fd6>] sysenter_past_esp+0x5f/0x99
[93490.121992]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93493.757614] BUG: soft lockup detected on CPU#1!
[93493.762133]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93493.767285]  [<c0105720>] show_trace+0x12/0x14
[93493.771745]  [<c01057d2>] dump_stack+0x16/0x18
[93493.776206]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93493.781098]  [<c012a0b5>] run_local_timers+0x12/0x14
[93493.786079]  [<c012a482>] update_process_times+0x3e/0x63
[93493.791402]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93493.796381]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93493.801621]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93493.807290]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93493.812614]  [<c01ed850>] __delay+0x9/0xb
[93493.816643]  [<c01f9bb5>] _raw_spin_lock+0x7d/0xe2
[93493.821448]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93493.825911]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93493.831407]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93493.836472]  [<c018e6a9>] __getblk+0x16/0x1fb
[93493.840847]  [<c01ad2bd>] ext3_getblk+0xea/0x232
[93493.845479]  [<c01ae0dc>] ext3_bread+0x1a/0x7e
[93493.849939]  [<c01b1418>] htree_dirblock_to_tree+0x27/0x11a
[93493.855523]  [<c01b1573>] ext3_htree_fill_tree+0x68/0x1aa
[93493.860935]  [<c01aa9c9>] ext3_readdir+0x1d6/0x599
[93493.865741]  [<c017ce09>] vfs_readdir+0x67/0x93
[93493.870289]  [<c017d05e>] sys_getdents+0x5f/0x9d
[93493.874923]  [<c0104060>] syscall_call+0x7/0xb
[93493.879382]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93500.100600] BUG: soft lockup detected on CPU#0!
[93500.105125]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93500.110275]  [<c0105720>] show_trace+0x12/0x14
[93500.114734]  [<c01057d2>] dump_stack+0x16/0x18
[93500.119195]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93500.124087]  [<c012a0b5>] run_local_timers+0x12/0x14
[93500.129067]  [<c012a482>] update_process_times+0x3e/0x63
[93500.134391]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93500.139370]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93500.144610]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93500.150280]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93500.155604]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93500.160064]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93500.165563]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93500.170628]  [<c018e6a9>] __getblk+0x16/0x1fb
[93500.175002]  [<c01ac3d8>] __ext3_get_inode_loc+0x109/0x2e1
[93500.180499]  [<c01ac5c7>] ext3_get_inode_loc+0x17/0x19
[93500.185650]  [<c01ac5e9>] ext3_reserve_inode_write+0x20/0x68
[93500.191323]  [<c01ac65b>] ext3_mark_inode_dirty+0x2a/0x41
[93500.196733]  [<c01aefd2>] ext3_dirty_inode+0x59/0x6c
[93500.201713]  [<c018b4b0>] __mark_inode_dirty+0x2a/0x15a
[93500.206950]  [<c018e9a2>] generic_commit_write+0x68/0x72
[93500.212276]  [<c01ae3de>] ext3_ordered_commit_write+0xaa/0xd8
[93500.218034]  [<c01570e4>] generic_file_buffered_write+0x3ba/0x585
[93500.224135]  [<c0157706>] __generic_file_aio_write_nolock+0x457/0x4c=
4
[93500.230584]  [<c01577c9>] generic_file_aio_write+0x56/0xb4
[93500.236082]  [<c01aadb3>] ext3_file_write+0x27/0x99
[93500.240974]  [<c0171de2>] do_sync_write+0xc2/0xff
[93500.245693]  [<c01725bb>] vfs_write+0xaf/0x138
[93500.250153]  [<c0172b85>] sys_write+0x3d/0x61
[93500.254527]  [<c0103fd6>] sysenter_past_esp+0x5f/0x99
[93500.259592]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93503.858296] BUG: soft lockup detected on CPU#1!
[93503.862815]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93503.867968]  [<c0105720>] show_trace+0x12/0x14
[93503.872427]  [<c01057d2>] dump_stack+0x16/0x18
[93503.876887]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93503.881780]  [<c012a0b5>] run_local_timers+0x12/0x14
[93503.886760]  [<c012a482>] update_process_times+0x3e/0x63
[93503.892084]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93503.897064]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93503.902302]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93503.907972]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93503.913298]  [<c01ed850>] __delay+0x9/0xb
[93503.917326]  [<c01f9bb5>] _raw_spin_lock+0x7d/0xe2
[93503.922131]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93503.926593]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93503.932089]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93503.937154]  [<c018e6a9>] __getblk+0x16/0x1fb
[93503.941528]  [<c01ad2bd>] ext3_getblk+0xea/0x232
[93503.946162]  [<c01ae0dc>] ext3_bread+0x1a/0x7e
[93503.950622]  [<c01b1418>] htree_dirblock_to_tree+0x27/0x11a
[93503.956207]  [<c01b1573>] ext3_htree_fill_tree+0x68/0x1aa
[93503.961618]  [<c01aa9c9>] ext3_readdir+0x1d6/0x599
[93503.966425]  [<c017ce09>] vfs_readdir+0x67/0x93
[93503.970972]  [<c017d05e>] sys_getdents+0x5f/0x9d
[93503.975604]  [<c0104060>] syscall_call+0x7/0xb
[93503.980064]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93510.238200] BUG: soft lockup detected on CPU#0!
[93510.242725]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93510.247877]  [<c0105720>] show_trace+0x12/0x14
[93510.252338]  [<c01057d2>] dump_stack+0x16/0x18
[93510.256797]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93510.261689]  [<c012a0b5>] run_local_timers+0x12/0x14
[93510.266670]  [<c012a482>] update_process_times+0x3e/0x63
[93510.271993]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93510.276972]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93510.282211]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93510.287881]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93510.293205]  [<c01ed850>] __delay+0x9/0xb
[93510.297235]  [<c01f9bb5>] _raw_spin_lock+0x7d/0xe2
[93510.302040]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93510.306500]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93510.311998]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93510.317064]  [<c018e6a9>] __getblk+0x16/0x1fb
[93510.321438]  [<c01ac3d8>] __ext3_get_inode_loc+0x109/0x2e1
[93510.326934]  [<c01ac5c7>] ext3_get_inode_loc+0x17/0x19
[93510.332087]  [<c01ac5e9>] ext3_reserve_inode_write+0x20/0x68
[93510.337758]  [<c01ac65b>] ext3_mark_inode_dirty+0x2a/0x41
[93510.343169]  [<c01aefd2>] ext3_dirty_inode+0x59/0x6c
[93510.348149]  [<c018b4b0>] __mark_inode_dirty+0x2a/0x15a
[93510.353387]  [<c018e9a2>] generic_commit_write+0x68/0x72
[93510.358712]  [<c01ae3de>] ext3_ordered_commit_write+0xaa/0xd8
[93510.364467]  [<c01570e4>] generic_file_buffered_write+0x3ba/0x585
[93510.370570]  [<c0157706>] __generic_file_aio_write_nolock+0x457/0x4c=
4
[93510.377020]  [<c01577c9>] generic_file_aio_write+0x56/0xb4
[93510.382518]  [<c01aadb3>] ext3_file_write+0x27/0x99
[93510.387408]  [<c0171de2>] do_sync_write+0xc2/0xff
[93510.392130]  [<c01725bb>] vfs_write+0xaf/0x138
[93510.396589]  [<c0172b85>] sys_write+0x3d/0x61
[93510.400963]  [<c0103fd6>] sysenter_past_esp+0x5f/0x99
[93510.406029]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93513.242711] SysRq : Emergency Sync
[93513.958977] BUG: soft lockup detected on CPU#1!
[93513.963498]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[93513.968649]  [<c0105720>] show_trace+0x12/0x14
[93513.973109]  [<c01057d2>] dump_stack+0x16/0x18
[93513.977570]  [<c01518e8>] softlockup_tick+0xa7/0xb9
[93513.982463]  [<c012a0b5>] run_local_timers+0x12/0x14
[93513.987442]  [<c012a482>] update_process_times+0x3e/0x63
[93513.992767]  [<c013a028>] tick_sched_timer+0x5d/0xa1
[93513.997746]  [<c01366fb>] hrtimer_interrupt+0x127/0x1b4
[93514.002983]  [<c0114c66>] smp_apic_timer_interrupt+0x72/0x84
[93514.008654]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
[93514.013978]  [<c01f9bb5>] _raw_spin_lock+0x7d/0xe2
[93514.018785]  [<c031ec1e>] _spin_lock+0x3c/0x42
[93514.023246]  [<c018e29c>] __find_get_block_slow+0x46/0x105
[93514.028743]  [<c018e5c7>] __find_get_block+0x91/0x15d
[93514.033810]  [<c018e6a9>] __getblk+0x16/0x1fb
[93514.038182]  [<c01ad2bd>] ext3_getblk+0xea/0x232
[93514.042815]  [<c01ae0dc>] ext3_bread+0x1a/0x7e
[93514.047276]  [<c01b1418>] htree_dirblock_to_tree+0x27/0x11a
[93514.052860]  [<c01b1573>] ext3_htree_fill_tree+0x68/0x1aa
[93514.058271]  [<c01aa9c9>] ext3_readdir+0x1d6/0x599
[93514.063078]  [<c017ce09>] vfs_readdir+0x67/0x93
[93514.067625]  [<c017d05e>] sys_getdents+0x5f/0x9d
[93514.072258]  [<c0104060>] syscall_call+0x7/0xb
[93514.076718]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[93515.468612] SysRq : Emergency Remount R/O
[93517.937776] SysRq : Resetting

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git4/gi=
t-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git4/gi=
t-dmesg2
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git4/se=
rial-console2.log

Regards,
Michal

--=20
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
